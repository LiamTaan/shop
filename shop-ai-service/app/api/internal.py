from __future__ import annotations

import time

from fastapi import APIRouter, Header, HTTPException, status
from fastapi.responses import StreamingResponse

from app.api.schemas import (
    ChatRequest,
    ConversationIdRequest,
    ConversationRenameRequest,
    ConversationScopeRequest,
)
from app.api.events import sse_event
from app.memory.sqlite import ConversationMemory
from app.prod import (
    RateLimitExceeded,
    estimate_tokens,
    get_audit_logger,
    get_rate_limiter,
    looks_like_injection,
    rate_limit_key,
    sanitize_user_message,
)
from app.providers.openai_compatible import OpenAiCompatibleProvider
from app.settings import settings

router = APIRouter(prefix="/internal/v1", tags=["internal"])
provider = OpenAiCompatibleProvider()
# Conversation list/rename/delete stay on SQLite (shared metadata store is later).
# Stream context may use redis when MEMORY_BACKEND=redis via provider.
memory = ConversationMemory(settings.memory_db_path, settings.memory_max_messages)
audit = get_audit_logger()


def _assert_internal_token(authorization: str | None) -> None:
    if not settings.shop_server_internal_token:
        return
    expected = f"Bearer {settings.shop_server_internal_token}"
    if authorization != expected:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)


def _enforce_rate_limit(tenant_id: int, user_id: int, user_type: str) -> None:
    try:
        get_rate_limiter().check(
            rate_limit_key(tenant_id=tenant_id, user_id=user_id, user_type=user_type)
        )
    except RateLimitExceeded as exc:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="AI rate limit exceeded",
            headers={"Retry-After": str(int(exc.retry_after) + 1)},
        ) from exc


def stream_with_error(request: ChatRequest, started: float):
    output_chars = 0
    status_label = "ok"
    try:
        for chunk in provider.stream(request):
            if "text_delta" in chunk or "content" in chunk:
                # rough accounting from SSE payload length
                output_chars += max(len(chunk) // 8, 1)
            yield chunk
    except Exception:
        status_label = "error"
        yield sse_event(
            "error",
            {"type": "error", "message": "AI provider request failed"},
        )
    finally:
        latency_ms = int((time.perf_counter() - started) * 1000)
        audit.write(
            tenant_id=request.tenant_id,
            user_id=request.user_id,
            user_type=request.user_type,
            conversation_id=request.conversation_id,
            path="/internal/v1/chat/stream",
            status=status_label,
            latency_ms=latency_ms,
            input_tokens=estimate_tokens(request.message),
            output_tokens=max(output_chars // 2, 0),
            detail={"useContext": request.use_context},
        )


@router.post("/chat/stream")
def chat_stream(
    request: ChatRequest,
    authorization: str | None = Header(default=None),
) -> StreamingResponse:
    _assert_internal_token(authorization)
    _enforce_rate_limit(request.tenant_id, request.user_id, request.user_type)

    if settings.enable_prompt_guard and looks_like_injection(request.message):
        audit.write(
            tenant_id=request.tenant_id,
            user_id=request.user_id,
            user_type=request.user_type,
            conversation_id=request.conversation_id,
            path="/internal/v1/chat/stream",
            status="blocked_injection",
            latency_ms=0,
            input_tokens=estimate_tokens(request.message),
            detail={"reason": "prompt_injection"},
        )
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Message rejected by prompt safety guard",
        )

    # Sanitize copy for model while keeping request immutable fields.
    safe_message = (
        sanitize_user_message(request.message)
        if settings.enable_prompt_guard
        else request.message
    )
    safe_request = request.model_copy(update={"message": safe_message})
    started = time.perf_counter()
    return StreamingResponse(
        stream_with_error(safe_request, started),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )


@router.post("/conversations/list")
def list_conversations(
    request: ConversationScopeRequest,
    authorization: str | None = Header(default=None),
) -> dict:
    _assert_internal_token(authorization)
    _enforce_rate_limit(request.tenant_id, request.user_id, request.user_type)
    items = memory.list_conversations(
        tenant_id=request.tenant_id,
        user_id=request.user_id,
        user_type=request.user_type,
        limit=request.limit,
    )
    return {"items": items}


@router.post("/conversations/messages")
def conversation_messages(
    request: ConversationIdRequest,
    authorization: str | None = Header(default=None),
) -> dict:
    _assert_internal_token(authorization)
    _enforce_rate_limit(request.tenant_id, request.user_id, request.user_type)
    items = memory.get_messages(
        tenant_id=request.tenant_id,
        user_id=request.user_id,
        user_type=request.user_type,
        conversation_id=request.conversation_id,
        limit=request.limit,
    )
    return {"items": items}


@router.post("/conversations/rename")
def rename_conversation(
    request: ConversationRenameRequest,
    authorization: str | None = Header(default=None),
) -> dict:
    _assert_internal_token(authorization)
    _enforce_rate_limit(request.tenant_id, request.user_id, request.user_type)
    ok = memory.rename_conversation(
        tenant_id=request.tenant_id,
        user_id=request.user_id,
        user_type=request.user_type,
        conversation_id=request.conversation_id,
        title=request.title,
    )
    return {"success": ok}


@router.post("/conversations/delete")
def delete_conversation(
    request: ConversationIdRequest,
    authorization: str | None = Header(default=None),
) -> dict:
    _assert_internal_token(authorization)
    _enforce_rate_limit(request.tenant_id, request.user_id, request.user_type)
    ok = memory.delete_conversation(
        tenant_id=request.tenant_id,
        user_id=request.user_id,
        user_type=request.user_type,
        conversation_id=request.conversation_id,
    )
    return {"success": ok}