import httpx

from app.api.schemas import ChatRequest
from app.prod import CircuitOpenError, redact_payload, shop_breaker, with_retry
from app.settings import settings


class ShopServerClient:
    def _headers(self, request: ChatRequest) -> dict[str, str]:
        return {
            "Authorization": f"Bearer {settings.shop_server_internal_token}",
            "tenant-id": str(request.tenant_id),
            "Content-Type": "application/json; charset=utf-8",
        }

    def _post(self, path: str, request: ChatRequest, payload: dict) -> object:
        def call() -> object:
            with httpx.Client(
                trust_env=False,
                timeout=settings.shop_server_timeout_seconds,
            ) as client:
                response = client.post(
                    f"{settings.shop_server_base_url}{path}",
                    headers=self._headers(request),
                    json=payload,
                )
            response.raise_for_status()
            body = response.json()
            if body.get("code") != 0:
                raise RuntimeError(body.get("msg") or f"RPC failed: {path}")
            data = body.get("data")
            if settings.enable_output_redaction:
                return redact_payload(data)
            return data

        try:
            return with_retry(
                call,
                attempts=settings.shop_server_retry_attempts,
                backoff_seconds=0.2,
                retry_on=(httpx.TimeoutException, httpx.TransportError, httpx.HTTPStatusError),
                breaker=shop_breaker(),
            )
        except CircuitOpenError as exc:
            raise RuntimeError("shop-server circuit open, try later") from exc

    def search_products(
        self,
        request: ChatRequest,
        *,
        keyword: str | None = None,
        limit: int = 5,
        category_id: int | None = None,
        category_name: str | None = None,
        min_price: int | None = None,
        max_price: int | None = None,
        in_stock: bool | None = True,
        sort_field: str | None = None,
        sort_asc: bool | None = None,
    ) -> list[dict]:
        payload: dict = {
            "limit": min(max(limit, 1), 10),
            "inStock": True if in_stock is None else bool(in_stock),
        }
        if keyword:
            payload["keyword"] = keyword
        if category_id is not None:
            payload["categoryId"] = category_id
        if category_name:
            payload["categoryName"] = category_name
        if min_price is not None:
            payload["minPrice"] = max(int(min_price), 0)
        if max_price is not None:
            payload["maxPrice"] = max(int(max_price), 0)
        if sort_field:
            payload["sortField"] = sort_field
        if sort_asc is not None:
            payload["sortAsc"] = bool(sort_asc)
        data = self._post("/rpc-api/ai/tools/product/search", request, payload)
        return data or []

    def get_product(self, request: ChatRequest, *, product_id: int) -> dict | None:
        return self._post(
            "/rpc-api/ai/tools/product/detail",
            request,
            {"productId": product_id},
        )

    def list_orders(
        self,
        request: ChatRequest,
        *,
        status: int | None = None,
        limit: int = 5,
    ) -> list[dict]:
        payload: dict = {
            "userId": request.user_id,
            "limit": min(max(limit, 1), 20),
        }
        if status is not None:
            payload["status"] = status
        data = self._post("/rpc-api/ai/tools/order/list", request, payload)
        return data or []

    def get_order(
        self,
        request: ChatRequest,
        *,
        order_id: int | None = None,
        order_no: str | None = None,
    ) -> dict | None:
        payload: dict = {"userId": request.user_id}
        if order_id is not None:
            payload["orderId"] = order_id
        if order_no:
            payload["orderNo"] = order_no
        return self._post("/rpc-api/ai/tools/order/detail", request, payload)

    def get_logistics(
        self,
        request: ChatRequest,
        *,
        order_id: int | None = None,
        order_no: str | None = None,
    ) -> dict | None:
        payload: dict = {"userId": request.user_id}
        if order_id is not None:
            payload["orderId"] = order_id
        if order_no:
            payload["orderNo"] = order_no
        return self._post("/rpc-api/ai/tools/logistics/get", request, payload)

    def list_coupons(
        self,
        request: ChatRequest,
        *,
        status: int | None = None,
        limit: int = 10,
    ) -> list[dict]:
        payload: dict = {
            "userId": request.user_id,
            "limit": min(max(limit, 1), 20),
        }
        if status is not None:
            payload["status"] = status
        data = self._post("/rpc-api/ai/tools/coupon/list", request, payload)
        return data or []

    def list_aftersales(
        self,
        request: ChatRequest,
        *,
        statuses: list[int] | None = None,
        limit: int = 10,
    ) -> list[dict]:
        payload: dict = {
            "userId": request.user_id,
            "limit": min(max(limit, 1), 20),
        }
        if statuses:
            payload["statuses"] = statuses
        data = self._post("/rpc-api/ai/tools/aftersale/list", request, payload)
        return data or []

    def get_aftersale(self, request: ChatRequest, *, after_sale_id: int) -> dict | None:
        return self._post(
            "/rpc-api/ai/tools/aftersale/detail",
            request,
            {"userId": request.user_id, "afterSaleId": after_sale_id},
        )

    def ops_brief(
        self,
        request: ChatRequest,
        *,
        limit: int = 5,
        stock_threshold: int | None = None,
        max_sales_count: int | None = None,
    ) -> dict:
        payload: dict = {"limit": min(max(limit, 1), 10)}
        if stock_threshold is not None:
            payload["stockThreshold"] = stock_threshold
        if max_sales_count is not None:
            payload["maxSalesCount"] = max_sales_count
        return self._post("/rpc-api/ai/tools/ops/brief", request, payload) or {}

    def ops_low_stock(
        self,
        request: ChatRequest,
        *,
        limit: int = 10,
        stock_threshold: int | None = None,
    ) -> list[dict]:
        payload: dict = {"limit": min(max(limit, 1), 30)}
        if stock_threshold is not None:
            payload["stockThreshold"] = stock_threshold
        data = self._post("/rpc-api/ai/tools/ops/low-stock", request, payload)
        return data or []

    def ops_hot_products(self, request: ChatRequest, *, limit: int = 10) -> list[dict]:
        data = self._post(
            "/rpc-api/ai/tools/ops/hot",
            request,
            {"limit": min(max(limit, 1), 30)},
        )
        return data or []

    def ops_slow_products(
        self,
        request: ChatRequest,
        *,
        limit: int = 10,
        max_sales_count: int | None = None,
    ) -> list[dict]:
        payload: dict = {"limit": min(max(limit, 1), 30)}
        if max_sales_count is not None:
            payload["maxSalesCount"] = max_sales_count
        data = self._post("/rpc-api/ai/tools/ops/slow", request, payload)
        return data or []