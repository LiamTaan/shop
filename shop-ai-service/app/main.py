from fastapi import FastAPI

from app.api.internal import router as internal_router
from app.rag import get_knowledge_store
from app.settings import settings

app = FastAPI(title=settings.app_name, version="0.1.0")
app.include_router(internal_router)


@app.on_event("startup")
def warmup_knowledge() -> None:
    # Build/load local FAQ index so the first chat does not pay ingest latency.
    get_knowledge_store().ensure_ready()


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "service": settings.app_name}
