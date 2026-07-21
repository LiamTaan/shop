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


class ConversationScopeRequest(BaseModel):
    tenant_id: int = Field(alias="tenantId")
    user_id: int = Field(alias="userId")
    user_type: Literal["APP", "ADMIN"] = Field(alias="userType")
    limit: int = Field(default=30, ge=1, le=100)

    model_config = {"populate_by_name": True}


class ConversationIdRequest(BaseModel):
    tenant_id: int = Field(alias="tenantId")
    user_id: int = Field(alias="userId")
    user_type: Literal["APP", "ADMIN"] = Field(alias="userType")
    conversation_id: str = Field(alias="conversationId", min_length=1, max_length=128)
    limit: int = Field(default=50, ge=1, le=200)

    model_config = {"populate_by_name": True}


class ConversationRenameRequest(BaseModel):
    tenant_id: int = Field(alias="tenantId")
    user_id: int = Field(alias="userId")
    user_type: Literal["APP", "ADMIN"] = Field(alias="userType")
    conversation_id: str = Field(alias="conversationId", min_length=1, max_length=128)
    title: str = Field(min_length=1, max_length=80)

    model_config = {"populate_by_name": True}