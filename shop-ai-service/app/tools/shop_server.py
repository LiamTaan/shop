import httpx

from app.api.schemas import ChatRequest
from app.settings import settings


class ShopServerClient:
    def search_products(self, request: ChatRequest, keyword: str, limit: int = 5) -> list[dict]:
        with httpx.Client(trust_env=False, timeout=10.0) as client:
            response = client.post(
                f"{settings.shop_server_base_url}/rpc-api/ai/tools/product/search",
                headers={
                    "Authorization": f"Bearer {settings.shop_server_internal_token}",
                    "tenant-id": str(request.tenant_id),
                    "Content-Type": "application/json; charset=utf-8",
                },
                json={"keyword": keyword, "limit": min(max(limit, 1), 10)},
            )
        response.raise_for_status()
        body = response.json()
        if body.get("code") != 0:
            raise RuntimeError(body.get("msg") or "Product search failed")
        return body.get("data") or []
