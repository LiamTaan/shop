from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "shop-ai-service"
    app_env: str = "local"
    log_level: str = "INFO"
    shop_server_base_url: str = "http://127.0.0.1:48080"
    shop_server_internal_token: str = ""
    llm_base_url: str = "https://api.openai.com/v1"
    llm_api_key: str = ""
    llm_model: str = ""
    qdrant_url: str = "http://127.0.0.1:6333"
    qdrant_api_key: str = ""
    qdrant_collection: str = "shop_knowledge"

    model_config = SettingsConfigDict(env_file=".env", env_prefix="", case_sensitive=False)


settings = Settings()

