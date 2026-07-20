import uuid
from collections.abc import Iterable

from openai import OpenAI

from app.api.events import sse_event, text_events
from app.api.schemas import ChatRequest
from app.settings import settings


class OpenAiCompatibleProvider:

    def stream(self, request: ChatRequest) -> Iterable[str]:
        message_id = str(uuid.uuid4())
        if not settings.llm_api_key or not settings.llm_model:
            yield from text_events(
                "AI provider is not configured. Set LLM_API_KEY and LLM_MODEL.",
                message_id,
            )
            return

        client = OpenAI(api_key=settings.llm_api_key, base_url=settings.llm_base_url)
        stream = client.chat.completions.create(
            model=settings.llm_model,
            stream=True,
            messages=[
                {
                    "role": "system",
                    "content": (
                        "You are a shopping assistant. Use only verified shop data supplied "
                        "through tools. Do not invent prices, stock, orders, or policies."
                    ),
                },
                {"role": "user", "content": request.message},
            ],
        )
        for chunk in stream:
            content = chunk.choices[0].delta.content
            if content:
                yield sse_event("message", {"type": "text_delta", "content": content})
        yield sse_event("done", {"type": "done", "messageId": message_id})
