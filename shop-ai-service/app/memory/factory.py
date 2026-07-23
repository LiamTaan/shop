"""Conversation memory backends for single- and multi-instance deployments."""

from __future__ import annotations

import json
from datetime import UTC, datetime
from typing import Protocol

from app.api.schemas import ChatRequest
from app.memory.sqlite import ConversationMemory
from app.settings import settings


class MemoryBackend(Protocol):
    def get_recent(self, request: ChatRequest) -> list[dict[str, str]]: ...

    def append_exchange(
        self,
        request: ChatRequest,
        user_content: str,
        assistant_content: str,
        tool_results: list[dict] | None = None,
    ) -> None: ...

    def list_conversations(
        self, *, tenant_id: int, user_id: int, user_type: str, limit: int = 30
    ) -> list[dict]: ...

    def get_messages(
        self,
        *,
        tenant_id: int,
        user_id: int,
        user_type: str,
        conversation_id: str,
        limit: int = 50,
    ) -> list[dict[str, str]]: ...

    def rename_conversation(
        self,
        *,
        tenant_id: int,
        user_id: int,
        user_type: str,
        conversation_id: str,
        title: str,
    ) -> bool: ...

    def delete_conversation(
        self,
        *,
        tenant_id: int,
        user_id: int,
        user_type: str,
        conversation_id: str,
    ) -> bool: ...


class RedisConversationMemory:
    """Redis-backed conversation messages and metadata for horizontal scale."""

    ttl_seconds = 60 * 60 * 24 * 14

    def __init__(self, redis_url: str, max_messages: int = 12) -> None:
        import redis  # type: ignore

        self.client = redis.Redis.from_url(redis_url, decode_responses=True)
        self.max_messages = max(max_messages, 1)

    def _key(self, request: ChatRequest) -> str:
        return self._message_key(
            request.tenant_id,
            request.user_id,
            request.user_type,
            request.conversation_id or "",
        )

    @staticmethod
    def _scope_key(tenant_id: int, user_id: int, user_type: str) -> str:
        return f"shop-ai:conversations:{tenant_id}:{user_type}:{user_id}"

    @staticmethod
    def _message_key(
        tenant_id: int, user_id: int, user_type: str, conversation_id: str
    ) -> str:
        return f"shop-ai:mem:{tenant_id}:{user_type}:{user_id}:{conversation_id}"

    @staticmethod
    def _metadata_key(
        tenant_id: int, user_id: int, user_type: str, conversation_id: str
    ) -> str:
        return f"shop-ai:conversation:{tenant_id}:{user_type}:{user_id}:{conversation_id}"

    @staticmethod
    def _timestamp() -> tuple[float, str]:
        now = datetime.now(UTC)
        return now.timestamp(), now.strftime("%Y-%m-%d %H:%M:%S")

    def get_recent(self, request: ChatRequest) -> list[dict[str, str]]:
        if not request.use_context or not request.conversation_id:
            return []
        raw = self.client.lrange(self._key(request), -self.max_messages, -1)
        messages = [json.loads(item) for item in raw]
        return [
            {"role": message["role"], "content": message["content"]}
            for message in messages
        ]

    def append_exchange(
        self,
        request: ChatRequest,
        user_content: str,
        assistant_content: str,
        tool_results: list[dict] | None = None,
    ) -> None:
        if not request.use_context or not request.conversation_id or not assistant_content:
            return
        key = self._key(request)
        scope_key = self._scope_key(request.tenant_id, request.user_id, request.user_type)
        metadata_key = self._metadata_key(
            request.tenant_id,
            request.user_id,
            request.user_type,
            request.conversation_id,
        )
        score, updated_time = self._timestamp()
        title = (user_content or "").strip().replace("\n", " ")[:40] or "新会话"
        current_title = self.client.hget(metadata_key, "title")
        if current_title and current_title != "新会话":
            title = current_title
        pipe = self.client.pipeline()
        pipe.rpush(
            key,
            json.dumps(
                {"role": "user", "content": user_content, "createTime": updated_time},
                ensure_ascii=False,
            ),
        )
        pipe.rpush(
            key,
            json.dumps(
                {
                    "role": "assistant",
                    "content": assistant_content,
                    "createTime": updated_time,
                    "toolResults": tool_results or [],
                },
                ensure_ascii=False,
            ),
        )
        pipe.ltrim(key, -self.max_messages, -1)
        pipe.expire(key, self.ttl_seconds)
        pipe.hset(metadata_key, mapping={"title": title, "updatedTime": updated_time})
        pipe.expire(metadata_key, self.ttl_seconds)
        pipe.zadd(scope_key, {request.conversation_id: score})
        pipe.expire(scope_key, self.ttl_seconds)
        pipe.execute()

    def list_conversations(
        self,
        *,
        tenant_id: int,
        user_id: int,
        user_type: str,
        limit: int = 30,
    ) -> list[dict]:
        scope_key = self._scope_key(tenant_id, user_id, user_type)
        conversation_ids = self.client.zrevrange(scope_key, 0, -1)
        items: list[dict] = []
        stale_ids: list[str] = []
        for conversation_id in conversation_ids:
            metadata = self.client.hgetall(
                self._metadata_key(tenant_id, user_id, user_type, conversation_id)
            )
            if not metadata:
                stale_ids.append(conversation_id)
                continue
            items.append(
                {
                    "conversationId": conversation_id,
                    "title": metadata.get("title") or "新会话",
                    "updatedTime": metadata.get("updatedTime"),
                }
            )
            if len(items) >= min(max(limit, 1), 100):
                break
        if stale_ids:
            self.client.zrem(scope_key, *stale_ids)
        return items

    def get_messages(
        self,
        *,
        tenant_id: int,
        user_id: int,
        user_type: str,
        conversation_id: str,
        limit: int = 50,
    ) -> list[dict[str, str]]:
        if not conversation_id:
            return []
        raw = self.client.lrange(
            self._message_key(tenant_id, user_id, user_type, conversation_id),
            0,
            min(max(limit, 1), 200) - 1,
        )
        return [json.loads(item) for item in raw]

    def rename_conversation(
        self,
        *,
        tenant_id: int,
        user_id: int,
        user_type: str,
        conversation_id: str,
        title: str,
    ) -> bool:
        title = (title or "").strip()
        if not title or not conversation_id:
            return False
        scope_key = self._scope_key(tenant_id, user_id, user_type)
        metadata_key = self._metadata_key(tenant_id, user_id, user_type, conversation_id)
        score, updated_time = self._timestamp()
        pipe = self.client.pipeline()
        pipe.hset(metadata_key, mapping={"title": title[:80], "updatedTime": updated_time})
        pipe.expire(metadata_key, self.ttl_seconds)
        pipe.zadd(scope_key, {conversation_id: score})
        pipe.expire(scope_key, self.ttl_seconds)
        pipe.execute()
        return True

    def delete_conversation(
        self,
        *,
        tenant_id: int,
        user_id: int,
        user_type: str,
        conversation_id: str,
    ) -> bool:
        if not conversation_id:
            return False
        scope_key = self._scope_key(tenant_id, user_id, user_type)
        pipe = self.client.pipeline()
        pipe.delete(
            self._message_key(tenant_id, user_id, user_type, conversation_id),
            self._metadata_key(tenant_id, user_id, user_type, conversation_id),
        )
        pipe.zrem(scope_key, conversation_id)
        pipe.execute()
        return True


def build_memory() -> MemoryBackend:
    backend = (settings.memory_backend or "sqlite").lower()
    if backend == "redis":
        if not settings.redis_url:
            raise RuntimeError("MEMORY_BACKEND=redis requires REDIS_URL")
        return RedisConversationMemory(settings.redis_url, settings.memory_max_messages)
    return ConversationMemory(settings.memory_db_path, settings.memory_max_messages)
