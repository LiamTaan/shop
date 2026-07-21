from __future__ import annotations

from typing import Any

from app.api.schemas import ChatRequest
from app.memory.factory import RedisConversationMemory


class FakeRedis:
    def __init__(self) -> None:
        self.lists: dict[str, list[str]] = {}
        self.hashes: dict[str, dict[str, str]] = {}
        self.sorted_sets: dict[str, dict[str, float]] = {}

    def pipeline(self) -> "FakeRedis":
        return self

    def execute(self) -> list[Any]:
        return []

    def expire(self, key: str, seconds: int) -> "FakeRedis":
        return self

    def rpush(self, key: str, *values: str) -> "FakeRedis":
        self.lists.setdefault(key, []).extend(values)
        return self

    def ltrim(self, key: str, start: int, end: int) -> "FakeRedis":
        values = self.lists.get(key, [])
        normalized_start = start if start >= 0 else max(len(values) + start, 0)
        normalized_end = end if end >= 0 else len(values) + end
        self.lists[key] = values[normalized_start : normalized_end + 1]
        return self

    def lrange(self, key: str, start: int, end: int) -> list[str]:
        values = self.lists.get(key, [])
        normalized_start = start if start >= 0 else max(len(values) + start, 0)
        normalized_end = end if end >= 0 else len(values) + end
        return values[normalized_start : normalized_end + 1]

    def hget(self, key: str, field: str) -> str | None:
        return self.hashes.get(key, {}).get(field)

    def hgetall(self, key: str) -> dict[str, str]:
        return self.hashes.get(key, {}).copy()

    def hset(self, key: str, mapping: dict[str, str]) -> "FakeRedis":
        self.hashes.setdefault(key, {}).update(mapping)
        return self

    def zadd(self, key: str, mapping: dict[str, float]) -> "FakeRedis":
        self.sorted_sets.setdefault(key, {}).update(mapping)
        return self

    def zrevrange(self, key: str, start: int, end: int) -> list[str]:
        values = sorted(
            self.sorted_sets.get(key, {}).items(),
            key=lambda item: (item[1], item[0]),
            reverse=True,
        )
        members = [item[0] for item in values]
        return members[start:] if end == -1 else members[start : end + 1]

    def zrem(self, key: str, *members: str) -> "FakeRedis":
        values = self.sorted_sets.get(key, {})
        for member in members:
            values.pop(member, None)
        return self

    def delete(self, *keys: str) -> "FakeRedis":
        for key in keys:
            self.lists.pop(key, None)
            self.hashes.pop(key, None)
            self.sorted_sets.pop(key, None)
        return self


def request(conversation_id: str, tenant_id: int = 1) -> ChatRequest:
    return ChatRequest(
        tenantId=tenant_id,
        userId=100,
        userType="APP",
        conversationId=conversation_id,
        message="test",
    )


def memory(max_messages: int = 4) -> RedisConversationMemory:
    backend = RedisConversationMemory.__new__(RedisConversationMemory)
    backend.client = FakeRedis()
    backend.max_messages = max_messages
    return backend


def test_redis_memory_keeps_recent_messages_and_scope() -> None:
    backend = memory()
    current = request("conversation-a")

    backend.append_exchange(current, "first", "answer-one")
    backend.append_exchange(current, "second", "answer-two")
    backend.append_exchange(current, "third", "answer-three")

    assert backend.get_recent(current) == [
        {"role": "user", "content": "second"},
        {"role": "assistant", "content": "answer-two"},
        {"role": "user", "content": "third"},
        {"role": "assistant", "content": "answer-three"},
    ]
    assert backend.get_recent(request("conversation-b")) == []
    assert backend.get_recent(request("conversation-a", tenant_id=2)) == []


def test_redis_conversation_list_rename_delete() -> None:
    backend = memory()
    current = request("conversation-a")
    backend.append_exchange(current, "搜背包", "这是推荐")

    listed = backend.list_conversations(tenant_id=1, user_id=100, user_type="APP")
    assert len(listed) == 1
    assert listed[0]["conversationId"] == "conversation-a"
    assert "背包" in listed[0]["title"]

    assert backend.rename_conversation(
        tenant_id=1,
        user_id=100,
        user_type="APP",
        conversation_id="conversation-a",
        title="我的导购",
    )
    listed = backend.list_conversations(tenant_id=1, user_id=100, user_type="APP")
    assert listed[0]["title"] == "我的导购"

    messages = backend.get_messages(
        tenant_id=1,
        user_id=100,
        user_type="APP",
        conversation_id="conversation-a",
    )
    assert len(messages) == 2
    assert messages[0]["role"] == "user"
    assert messages[0]["createTime"]

    assert backend.delete_conversation(
        tenant_id=1,
        user_id=100,
        user_type="APP",
        conversation_id="conversation-a",
    )
    assert backend.list_conversations(tenant_id=1, user_id=100, user_type="APP") == []
    assert backend.get_messages(
        tenant_id=1,
        user_id=100,
        user_type="APP",
        conversation_id="conversation-a",
    ) == []
