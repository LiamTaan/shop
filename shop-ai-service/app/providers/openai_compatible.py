import json
import uuid
from collections.abc import Iterable

from openai import OpenAI

from app.api.events import sse_event, text_events
from app.api.schemas import ChatRequest
from app.memory.factory import build_memory
from app.rag import get_knowledge_store
from app.settings import settings
from app.tools.shop_server import ShopServerClient


MEMBER_TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "search_knowledge",
            "description": (
                "Search mall FAQ, after-sale policy, and mall rules. "
                "Do NOT use for live product price or stock."
            ),
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {"type": "string"},
                    "limit": {"type": "integer", "minimum": 1, "maximum": 8},
                },
                "required": ["query"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "search_products",
            "description": (
                "Search currently enabled products. Prices are in fen (1 yuan = 100 fen). "
                "Use maxPrice=20000 for products under 200 yuan."
            ),
            "parameters": {
                "type": "object",
                "properties": {
                    "keyword": {"type": "string"},
                    "categoryId": {"type": "integer"},
                    "categoryName": {"type": "string"},
                    "minPrice": {"type": "integer", "minimum": 0},
                    "maxPrice": {"type": "integer", "minimum": 0},
                    "inStock": {"type": "boolean"},
                    "sortField": {"type": "string", "enum": ["price", "salesCount"]},
                    "sortAsc": {"type": "boolean"},
                    "limit": {"type": "integer", "minimum": 1, "maximum": 10},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "get_product",
            "description": "Get product detail and SKU specs",
            "parameters": {
                "type": "object",
                "properties": {"productId": {"type": "integer"}},
                "required": ["productId"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "list_orders",
            "description": "List the current member's recent trade orders",
            "parameters": {
                "type": "object",
                "properties": {
                    "status": {"type": "integer"},
                    "limit": {"type": "integer", "minimum": 1, "maximum": 20},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "get_order",
            "description": "Get one order detail for the current member",
            "parameters": {
                "type": "object",
                "properties": {
                    "orderId": {"type": "integer"},
                    "orderNo": {"type": "string"},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "get_logistics",
            "description": "Get logistics tracks for one order owned by the current member",
            "parameters": {
                "type": "object",
                "properties": {
                    "orderId": {"type": "integer"},
                    "orderNo": {"type": "string"},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "list_coupons",
            "description": "List the current member's coupons. status: 1 unused, 2 used, 3 expired",
            "parameters": {
                "type": "object",
                "properties": {
                    "status": {"type": "integer", "enum": [1, 2, 3]},
                    "limit": {"type": "integer", "minimum": 1, "maximum": 20},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "list_aftersales",
            "description": "List the current member's after-sale tickets",
            "parameters": {
                "type": "object",
                "properties": {
                    "statuses": {"type": "array", "items": {"type": "integer"}},
                    "limit": {"type": "integer", "minimum": 1, "maximum": 20},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "get_aftersale",
            "description": "Get one after-sale ticket detail for the current member",
            "parameters": {
                "type": "object",
                "properties": {"afterSaleId": {"type": "integer"}},
                "required": ["afterSaleId"],
            },
        },
    },
]

ADMIN_TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "ops_brief",
            "description": (
                "Admin-only operations brief: low-stock count, sold-out count, "
                "on-sale count, plus sample low-stock / hot / slow products."
            ),
            "parameters": {
                "type": "object",
                "properties": {
                    "limit": {"type": "integer", "minimum": 1, "maximum": 10},
                    "stockThreshold": {"type": "integer", "minimum": 0},
                    "maxSalesCount": {"type": "integer", "minimum": 0},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "ops_low_stock",
            "description": "Admin-only list of low-stock products (default threshold 10)",
            "parameters": {
                "type": "object",
                "properties": {
                    "limit": {"type": "integer", "minimum": 1, "maximum": 30},
                    "stockThreshold": {"type": "integer", "minimum": 0},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "ops_hot_products",
            "description": "Admin-only list of best-selling on-sale products",
            "parameters": {
                "type": "object",
                "properties": {
                    "limit": {"type": "integer", "minimum": 1, "maximum": 30},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "ops_slow_products",
            "description": "Admin-only list of slow-moving on-sale products with stock",
            "parameters": {
                "type": "object",
                "properties": {
                    "limit": {"type": "integer", "minimum": 1, "maximum": 30},
                    "maxSalesCount": {"type": "integer", "minimum": 0},
                },
            },
        },
    },
]

MAX_TOOL_CALLS_PER_TURN = 3


def tools_for(request: ChatRequest) -> list[dict]:
    if request.user_type == "ADMIN":
        return MEMBER_TOOLS + ADMIN_TOOLS
    return MEMBER_TOOLS


def system_prompt_for(request: ChatRequest) -> str:
    if request.user_type == "ADMIN":
        base = (
            "You are a mall operations assistant for administrators. "
            "Use tools for live catalogue and operations reports. "
            "Use search_knowledge for FAQ and policies. "
            "Never invent stock, sales, or policies. "
            "Prices are in fen; convert to yuan when talking to users. "
            "Admin ops tools: ops_brief, ops_low_stock, ops_hot_products, ops_slow_products. "
            "Write operations such as price change or publish are not available."
        )
    else:
        base = (
            "You are a shopping assistant for members. "
            "Use tools for live product, order, logistics, coupon, and after-sale data. "
            "Use search_knowledge for after-sale policy, mall rules, and FAQ. "
            "Never invent prices, stock, orders, logistics, coupons, or policies. "
            "Product prices from tools are in fen; convert to yuan when talking to users. "
            "Member tools only return data for the authenticated user."
        )
    return base


def build_system_message(request: ChatRequest) -> str:
    base = system_prompt_for(request)
    store = get_knowledge_store()
    chunks = store.retrieve(request.message, top_k=settings.knowledge_top_k)
    context = store.format_context(chunks)
    if not context:
        return base
    return f"{base}\n\n{context}"


class OpenAiCompatibleProvider:
    def __init__(self) -> None:
        self.shop_server = ShopServerClient()
        self.memory = build_memory()
        self.knowledge = get_knowledge_store()

    def stream(self, request: ChatRequest) -> Iterable[str]:
        message_id = str(uuid.uuid4())
        if not settings.llm_api_key or not settings.llm_model:
            yield from text_events(
                "AI provider is not configured. Set LLM_API_KEY and LLM_MODEL.",
                message_id,
            )
            return

        tools = tools_for(request)
        client = OpenAI(api_key=settings.llm_api_key, base_url=settings.llm_base_url)
        messages = [{"role": "system", "content": build_system_message(request)}]
        messages.extend(self.memory.get_recent(request))
        messages.append({"role": "user", "content": request.message})
        decision = client.chat.completions.create(
            model=settings.llm_model,
            messages=messages,
            tools=tools,
            tool_choice="auto",
        )
        assistant_message = decision.choices[0].message
        if not assistant_message.tool_calls:
            assistant_content = assistant_message.content or ""
            self.memory.append_exchange(request, request.message, assistant_content)
            yield from text_events(assistant_content, message_id)
            return

        selected_tool_calls = assistant_message.tool_calls[:MAX_TOOL_CALLS_PER_TURN]
        messages.append(
            assistant_message.model_copy(update={"tool_calls": selected_tool_calls}).model_dump(
                exclude_none=True
            )
        )
        tool_results: list[dict] = []
        # Bound a single model turn so it cannot fan out into an unbounded number of
        # live database-backed tool calls.
        for tool_call in selected_tool_calls:
            tool_payload = self._run_tool(request, tool_call.function.name, tool_call.function.arguments)
            if tool_payload is not None:
                tool_results.append(tool_payload)
                yield sse_event("tool_result", tool_payload)
            messages.append(
                {
                    "role": "tool",
                    "tool_call_id": tool_call.id,
                    "content": json.dumps(tool_payload if tool_payload is not None else {}, ensure_ascii=False),
                }
            )

        stream = client.chat.completions.create(
            model=settings.llm_model,
            stream=True,
            messages=messages,
            tools=tools,
        )
        assistant_content_parts = []
        for chunk in stream:
            if not chunk.choices:
                continue
            content = chunk.choices[0].delta.content
            if content:
                assistant_content_parts.append(content)
                yield sse_event("message", {"type": "text_delta", "content": content})
        self.memory.append_exchange(
            request,
            request.message,
            "".join(assistant_content_parts),
            tool_results,
        )
        yield sse_event("done", {"type": "done", "messageId": message_id})

    def _run_tool(self, request: ChatRequest, name: str, raw_arguments: str | None) -> dict | None:
        arguments = json.loads(raw_arguments or "{}")
        admin_tools = {
            "ops_brief",
            "ops_low_stock",
            "ops_hot_products",
            "ops_slow_products",
        }
        if name in admin_tools and request.user_type != "ADMIN":
            return {
                "type": "error",
                "message": "Operations tools are only available for admin users",
            }
        if name == "search_knowledge":
            chunks = self.knowledge.retrieve(
                arguments.get("query") or request.message,
                top_k=int(arguments.get("limit") or settings.knowledge_top_k),
            )
            items = [
                {
                    "docId": c.doc_id,
                    "title": c.title,
                    "content": c.content,
                    "score": c.score,
                }
                for c in chunks
            ]
            return {"type": "knowledge_list", "items": items}
        if name == "search_products":
            products = self.shop_server.search_products(
                request,
                keyword=arguments.get("keyword"),
                category_id=arguments.get("categoryId"),
                category_name=arguments.get("categoryName"),
                min_price=arguments.get("minPrice"),
                max_price=arguments.get("maxPrice"),
                in_stock=arguments.get("inStock", True),
                sort_field=arguments.get("sortField"),
                sort_asc=arguments.get("sortAsc"),
                limit=arguments.get("limit", 5),
            )
            return {"type": "product_list", "items": products}
        if name == "get_product":
            product = self.shop_server.get_product(request, product_id=int(arguments["productId"]))
            return {"type": "product_detail", "item": product}
        if name == "list_orders":
            orders = self.shop_server.list_orders(
                request,
                status=arguments.get("status"),
                limit=arguments.get("limit", 5),
            )
            return {"type": "order_list", "items": orders}
        if name == "get_order":
            order = self.shop_server.get_order(
                request,
                order_id=arguments.get("orderId"),
                order_no=arguments.get("orderNo"),
            )
            return {"type": "order_detail", "item": order}
        if name == "get_logistics":
            logistics = self.shop_server.get_logistics(
                request,
                order_id=arguments.get("orderId"),
                order_no=arguments.get("orderNo"),
            )
            return {"type": "logistics", "item": logistics}
        if name == "list_coupons":
            coupons = self.shop_server.list_coupons(
                request,
                status=arguments.get("status"),
                limit=arguments.get("limit", 10),
            )
            return {"type": "coupon_list", "items": coupons}
        if name == "list_aftersales":
            aftersales = self.shop_server.list_aftersales(
                request,
                statuses=arguments.get("statuses"),
                limit=arguments.get("limit", 10),
            )
            return {"type": "aftersale_list", "items": aftersales}
        if name == "get_aftersale":
            aftersale = self.shop_server.get_aftersale(
                request,
                after_sale_id=int(arguments["afterSaleId"]),
            )
            return {"type": "aftersale_detail", "item": aftersale}
        if name == "ops_brief":
            brief = self.shop_server.ops_brief(
                request,
                limit=arguments.get("limit", 5),
                stock_threshold=arguments.get("stockThreshold"),
                max_sales_count=arguments.get("maxSalesCount"),
            )
            return {"type": "ops_brief", "item": brief}
        if name == "ops_low_stock":
            items = self.shop_server.ops_low_stock(
                request,
                limit=arguments.get("limit", 10),
                stock_threshold=arguments.get("stockThreshold"),
            )
            return {"type": "ops_product_list", "kind": "low_stock", "items": items}
        if name == "ops_hot_products":
            items = self.shop_server.ops_hot_products(request, limit=arguments.get("limit", 10))
            return {"type": "ops_product_list", "kind": "hot", "items": items}
        if name == "ops_slow_products":
            items = self.shop_server.ops_slow_products(
                request,
                limit=arguments.get("limit", 10),
                max_sales_count=arguments.get("maxSalesCount"),
            )
            return {"type": "ops_product_list", "kind": "slow", "items": items}
        return None
