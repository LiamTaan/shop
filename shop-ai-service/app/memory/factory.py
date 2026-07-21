"""Optional multi-instance memory backends.

Default remains SQLite (single instance). Redis backend is a thin protocol
placeholder that stores recent messages as a capped list for horizontal scale.
"""

from __future__ import annotations

import json
from typing import Protocol

from app.api.schemas import ChatRequest
from app.memory.sqlite import ConversationMemory
from app.settings import settings


class MemoryBackend(Protocol):
    def get_recent(self, request: ChatRequest) -> list[dict[str, str]]: ...

    def append_exchange(
        self, request: ChatRequest, user_content: str, assistant_content: str
    ) -> None: ...


class RedisConversationMemory:
    """Minimal Redis list memory. Requires redis package + REDIS_URL."""

    def __init__(self, redis_url: str, max_messages: int = 12) -> None:
        import redis  # type: ignore

        self.client = redis.Redis.from_url(redis_url, decode_responses=True)
        self.max_messages = max(max_messages, 1)

    def _key(self, request: ChatRequest) -> str:
        return (
            f"shop-ai:mem:{request.tenant_id}:{request.user_type}:"
            f"{request.user_id}:{request.conversation_id}"
        )

    def get_recent(self, request: ChatRequest) -> list[dict[str, str]]:
        if not request.use_context or not request.conversation_id:
            return []
        raw = self.client.lrange(self._key(request), -self.max_messages, -1)
        return [json.loads(item) for item in raw]

    def append_exchange(
        self, request: ChatRequest, user_content: str, assistant_content: str
    ) -> None:
        if not request.use_context or not request.conversation_id or not assistant_content:
            return
        key = self._key(request)
        pipe = self.client.pipeline()
        pipe.rpush(key, json.dumps({"role": "user", "content": user_content}, ensure_ascii=False))
        pipe.rpush(
            key,
            json.dumps({"role": "assistant", "content": assistant_content}, ensure_ascii=False),
        )
        pipe.ltrim(key, -self.max_messages, -1)
        pipe.expire(key, 60 * 60 * 24 * 14)
        pipe.execute()


def build_memory() -> ConversationMemory | RedisConversationMemory:
    backend = (settings.memory_backend or "sqlite").lower()
    if backend == "redis":
        if not settings.redis_url:
            raise RuntimeError("MEMORY_BACKEND=redis requires REDIS_URL")
        return RedisConversationMemory(settings.redis_url, settings.memory_max_messages)
    return ConversationMemory(settings.memory_db_path, settings.memory_max_messages)