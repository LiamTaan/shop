import json
import uuid
from collections.abc import Iterable

from openai import OpenAI

from app.api.events import sse_event, text_events
from app.api.schemas import ChatRequest
from app.settings import settings
from app.tools.shop_server import ShopServerClient


class OpenAiCompatibleProvider:
    def __init__(self) -> None:
        self.shop_server = ShopServerClient()


    def stream(self, request: ChatRequest) -> Iterable[str]:
        message_id = str(uuid.uuid4())
        if not settings.llm_api_key or not settings.llm_model:
            yield from text_events(
                "AI provider is not configured. Set LLM_API_KEY and LLM_MODEL.",
                message_id,
            )
            return

        client = OpenAI(api_key=settings.llm_api_key, base_url=settings.llm_base_url)
        messages = [
            {
                "role": "system",
                "content": (
                    "You are a shopping assistant. Search the live catalogue before recommending "
                    "products. Do not invent prices, stock, orders, or policies."
                ),
            },
            {"role": "user", "content": request.message},
        ]
        tools = [
            {
                "type": "function",
                "function": {
                    "name": "search_products",
                    "description": "Search currently enabled products in the shop catalogue",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "keyword": {"type": "string"},
                            "limit": {"type": "integer", "minimum": 1, "maximum": 10},
                        },
                        "required": ["keyword"],
                    },
                },
            }
        ]
        decision = client.chat.completions.create(
            model=settings.llm_model,
            messages=messages,
            tools=tools,
            tool_choice="auto",
        )
        assistant_message = decision.choices[0].message
        if not assistant_message.tool_calls:
            yield from text_events(assistant_message.content or "", message_id)
            return

        messages.append(assistant_message.model_dump(exclude_none=True))
        for tool_call in assistant_message.tool_calls:
            if tool_call.function.name != "search_products":
                continue
            arguments = json.loads(tool_call.function.arguments or "{}")
            products = self.shop_server.search_products(
                request,
                keyword=arguments.get("keyword", request.message),
                limit=arguments.get("limit", 5),
            )
            yield sse_event("tool_result", {"type": "product_list", "items": products})
            messages.append(
                {
                    "role": "tool",
                    "tool_call_id": tool_call.id,
                    "content": json.dumps(products, ensure_ascii=False),
                }
            )

        stream = client.chat.completions.create(
            model=settings.llm_model,
            stream=True,
            messages=messages,
            tools=tools,
        )
        for chunk in stream:
            content = chunk.choices[0].delta.content
            if content:
                yield sse_event("message", {"type": "text_delta", "content": content})
        yield sse_event("done", {"type": "done", "messageId": message_id})
