from fastapi.testclient import TestClient

from app.main import app


def test_health() -> None:
    response = TestClient(app).get("/health")

    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_chat_stream_protocol(monkeypatch) -> None:
    monkeypatch.setattr("app.api.internal.settings.shop_server_internal_token", "secret")
    monkeypatch.setattr("app.providers.openai_compatible.settings.llm_api_key", "")
    monkeypatch.setattr("app.providers.openai_compatible.settings.llm_model", "")
    response = TestClient(app).post(
        "/internal/v1/chat/stream",
        json={
            "tenantId": 1,
            "userId": 100,
            "userType": "APP",
            "message": "hello",
        },
        headers={"Authorization": "Bearer secret"},
    )

    assert response.status_code == 200
    assert "event: message" in response.text
    assert "event: done" in response.text


def test_chat_stream_rejects_invalid_internal_token(monkeypatch) -> None:
    monkeypatch.setattr("app.api.internal.settings.shop_server_internal_token", "secret")
    response = TestClient(app).post(
        "/internal/v1/chat/stream",
        json={"tenantId": 1, "userId": 100, "userType": "APP", "message": "hello"},
    )

    assert response.status_code == 401


def test_chat_stream_rejects_missing_internal_token_configuration(monkeypatch) -> None:
    monkeypatch.setattr("app.api.internal.settings.shop_server_internal_token", "")
    response = TestClient(app).post(
        "/internal/v1/chat/stream",
        json={"tenantId": 1, "userId": 100, "userType": "APP", "message": "hello"},
    )

    assert response.status_code == 503
