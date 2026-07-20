from fastapi import FastAPI

from app.api.internal import router as internal_router
from app.settings import settings

app = FastAPI(title=settings.app_name, version="0.1.0")
app.include_router(internal_router)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "service": settings.app_name}
