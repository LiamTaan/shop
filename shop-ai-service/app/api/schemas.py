from typing import Literal

from pydantic import BaseModel, Field


class ChatRequest(BaseModel):
    tenant_id: int = Field(alias="tenantId")
    user_id: int = Field(alias="userId")
    user_type: Literal["APP", "ADMIN"] = Field(alias="userType")
    conversation_id: str | None = Field(default=None, alias="conversationId")
    message: str = Field(min_length=1, max_length=8000)
    use_context: bool = Field(default=True, alias="useContext")
    tool_context: dict[str, object] = Field(default_factory=dict, alias="toolContext")

    model_config = {"populate_by_name": True}

