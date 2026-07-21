from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "shop-ai-service"
    app_env: str = "local"
    log_level: str = "INFO"
    shop_server_base_url: str = "http://127.0.0.1:48080"
    shop_server_internal_token: str = ""
    shop_server_timeout_seconds: float = 10.0
    shop_server_retry_attempts: int = 2
    llm_base_url: str = "https://api.openai.com/v1"
    llm_api_key: str = ""
    llm_model: str = ""
    llm_timeout_seconds: float = 60.0
    # sqlite (default, single instance) | redis (multi-instance ready, optional)
    memory_backend: str = "sqlite"
    memory_db_path: str = "data/shop-ai.db"
    memory_max_messages: int = 12
    redis_url: str = ""
    knowledge_dir: str = "knowledge"
    knowledge_db_path: str = "data/shop-ai-knowledge.db"
    knowledge_top_k: int = 4
    rate_limit_per_minute: int = 30
    audit_db_path: str = "data/shop-ai-audit.db"
    enable_prompt_guard: bool = True
    enable_output_redaction: bool = True
    qdrant_url: str = "http://127.0.0.1:6333"
    qdrant_api_key: str = ""
    qdrant_collection: str = "shop_knowledge"

    model_config = SettingsConfigDict(env_file=".env", env_prefix="", case_sensitive=False)


settings = Settings()