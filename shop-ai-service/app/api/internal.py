from fastapi import APIRouter, Header, HTTPException, status
from fastapi.responses import StreamingResponse

from app.api.schemas import ChatRequest
from app.api.events import sse_event
from app.providers.openai_compatible import OpenAiCompatibleProvider
from app.settings import settings

router = APIRouter(prefix="/internal/v1", tags=["internal"])
provider = OpenAiCompatibleProvider()


def stream_with_error(request: ChatRequest):
    try:
        yield from provider.stream(request)
    except Exception:
        yield sse_event(
            "error",
            {"type": "error", "message": "AI provider request failed"},
        )


@router.post("/chat/stream")
def chat_stream(
    request: ChatRequest,
    authorization: str | None = Header(default=None),
) -> StreamingResponse:
    if settings.shop_server_internal_token:
        expected = f"Bearer {settings.shop_server_internal_token}"
        if authorization != expected:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)
    return StreamingResponse(
        stream_with_error(request),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )
