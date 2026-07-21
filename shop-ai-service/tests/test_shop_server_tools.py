from app.api.schemas import ChatRequest
from app.tools.shop_server import ShopServerClient


def _request() -> ChatRequest:
    return ChatRequest(
        tenantId=1,
        userId=24601,
        userType="APP",
        conversationId="test",
        message="orders",
    )


def test_list_orders_injects_authenticated_user_id(monkeypatch) -> None:
    client = ShopServerClient()
    captured: dict = {}

    def fake_post(path, request, payload):
        captured["path"] = path
        captured["payload"] = payload
        captured["user_id"] = request.user_id
        return [{"id": 1, "no": "A1"}]

    monkeypatch.setattr(client, "_post", fake_post)
    result = client.list_orders(_request(), status=10, limit=3)

    assert result == [{"id": 1, "no": "A1"}]
    assert captured["path"] == "/rpc-api/ai/tools/order/list"
    assert captured["payload"] == {"userId": 24601, "limit": 3, "status": 10}
    assert captured["user_id"] == 24601


def test_get_order_and_logistics_pass_order_keys(monkeypatch) -> None:
    client = ShopServerClient()
    calls: list[tuple] = []

    def fake_post(path, request, payload):
        calls.append((path, payload))
        return {"orderId": payload.get("orderId")}

    monkeypatch.setattr(client, "_post", fake_post)
    client.get_order(_request(), order_id=88, order_no="NO-88")
    client.get_logistics(_request(), order_no="NO-88")

    assert calls[0][0] == "/rpc-api/ai/tools/order/detail"
    assert calls[0][1] == {"userId": 24601, "orderId": 88, "orderNo": "NO-88"}
    assert calls[1][0] == "/rpc-api/ai/tools/logistics/get"
    assert calls[1][1] == {"userId": 24601, "orderNo": "NO-88"}


def test_search_products_forwards_filters(monkeypatch) -> None:
    client = ShopServerClient()
    captured: dict = {}

    def fake_post(path, request, payload):
        captured["path"] = path
        captured["payload"] = payload
        return [{"id": 9, "price": 16800}]

    monkeypatch.setattr(client, "_post", fake_post)
    result = client.search_products(
        _request(),
        keyword="backpack",
        max_price=20000,
        in_stock=True,
        sort_field="price",
        sort_asc=True,
        limit=3,
    )

    assert result == [{"id": 9, "price": 16800}]
    assert captured["path"] == "/rpc-api/ai/tools/product/search"
    assert captured["payload"] == {
        "limit": 3,
        "inStock": True,
        "keyword": "backpack",
        "maxPrice": 20000,
        "sortField": "price",
        "sortAsc": True,
    }


def test_get_product_detail_payload(monkeypatch) -> None:
    client = ShopServerClient()
    captured: dict = {}

    def fake_post(path, request, payload):
        captured["path"] = path
        captured["payload"] = payload
        return {"id": 7, "name": "Bag"}

    monkeypatch.setattr(client, "_post", fake_post)
    result = client.get_product(_request(), product_id=7)

    assert result == {"id": 7, "name": "Bag"}
    assert captured["path"] == "/rpc-api/ai/tools/product/detail"
    assert captured["payload"] == {"productId": 7}


def test_list_coupons_and_aftersales_inject_user(monkeypatch) -> None:
    client = ShopServerClient()
    calls: list[tuple] = []

    def fake_post(path, request, payload):
        calls.append((path, payload, request.user_id))
        return []

    monkeypatch.setattr(client, "_post", fake_post)
    client.list_coupons(_request(), status=1, limit=5)
    client.list_aftersales(_request(), statuses=[10, 20], limit=3)
    client.get_aftersale(_request(), after_sale_id=99)

    assert calls[0][0] == "/rpc-api/ai/tools/coupon/list"
    assert calls[0][1] == {"userId": 24601, "limit": 5, "status": 1}
    assert calls[1][0] == "/rpc-api/ai/tools/aftersale/list"
    assert calls[1][1] == {"userId": 24601, "limit": 3, "statuses": [10, 20]}
    assert calls[2][0] == "/rpc-api/ai/tools/aftersale/detail"
    assert calls[2][1] == {"userId": 24601, "afterSaleId": 99}


def test_ops_tools_payload(monkeypatch) -> None:
    client = ShopServerClient()
    calls: list[tuple] = []

    def fake_post(path, request, payload):
        calls.append((path, payload))
        if path.endswith("/brief"):
            return {"onSaleCount": 3, "lowStockCount": 1}
        return [{"id": 1, "name": "x"}]

    monkeypatch.setattr(client, "_post", fake_post)
    brief = client.ops_brief(_request(), limit=5, stock_threshold=8)
    low = client.ops_low_stock(_request(), limit=3, stock_threshold=8)
    hot = client.ops_hot_products(_request(), limit=4)
    slow = client.ops_slow_products(_request(), limit=2, max_sales_count=3)

    assert brief == {"onSaleCount": 3, "lowStockCount": 1}
    assert low == [{"id": 1, "name": "x"}]
    assert hot == [{"id": 1, "name": "x"}]
    assert slow == [{"id": 1, "name": "x"}]
    assert calls[0][0] == "/rpc-api/ai/tools/ops/brief"
    assert calls[0][1] == {"limit": 5, "stockThreshold": 8}
    assert calls[1][0] == "/rpc-api/ai/tools/ops/low-stock"
    assert calls[2][0] == "/rpc-api/ai/tools/ops/hot"
    assert calls[3][0] == "/rpc-api/ai/tools/ops/slow"
    assert calls[3][1] == {"limit": 2, "maxSalesCount": 3}