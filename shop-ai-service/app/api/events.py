import json
from collections.abc import Iterable


def sse_event(event_type: str, payload: dict[str, object]) -> str:
    return f"event: {event_type}\ndata: {json.dumps(payload, ensure_ascii=False)}\n\n"


def text_events(text: str, message_id: str) -> Iterable[str]:
    yield sse_event("message", {"type": "text_delta", "content": text})
    yield sse_event("done", {"type": "done", "messageId": message_id})

