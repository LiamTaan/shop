from app.api.schemas import ChatRequest
from app.memory.sqlite import ConversationMemory


def request(conversation_id: str, tenant_id: int = 1) -> ChatRequest:
    return ChatRequest(
        tenantId=tenant_id,
        userId=100,
        userType="APP",
        conversationId=conversation_id,
        message="test",
    )


def test_memory_keeps_recent_messages_and_scope(tmp_path) -> None:
    memory = ConversationMemory(str(tmp_path / "memory.db"), max_messages=4)
    current = request("conversation-a")

    memory.append_exchange(current, "first", "answer-one")
    memory.append_exchange(current, "second", "answer-two")
    memory.append_exchange(current, "third", "answer-three")

    assert memory.get_recent(current) == [
        {"role": "user", "content": "second"},
        {"role": "assistant", "content": "answer-two"},
        {"role": "user", "content": "third"},
        {"role": "assistant", "content": "answer-three"},
    ]
    assert memory.get_recent(request("conversation-b")) == []
    assert memory.get_recent(request("conversation-a", tenant_id=2)) == []


def test_memory_skips_disabled_context(tmp_path) -> None:
    memory = ConversationMemory(str(tmp_path / "memory.db"))
    current = request("conversation-a")
    current.use_context = False

    memory.append_exchange(current, "question", "answer")

    assert memory.get_recent(current) == []
