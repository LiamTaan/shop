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


def test_memory_keeps_assistant_tool_results(tmp_path) -> None:
    memory = ConversationMemory(str(tmp_path / "memory.db"))
    current = request("conversation-a")
    tool_results = [{"type": "ops_product_list", "items": [{"spuId": 20017}]}]

    memory.append_exchange(current, "热销商品", "为你找到以下商品", tool_results)

    messages = memory.get_messages(
        tenant_id=1,
        user_id=100,
        user_type="APP",
        conversation_id="conversation-a",
    )
    assert messages[1]["toolResults"] == tool_results


def test_conversation_list_rename_delete(tmp_path) -> None:
    memory = ConversationMemory(str(tmp_path / "memory.db"))
    current = request("conversation-a")
    memory.append_exchange(current, "搜背包", "这是推荐")

    listed = memory.list_conversations(tenant_id=1, user_id=100, user_type="APP")
    assert len(listed) == 1
    assert listed[0]["conversationId"] == "conversation-a"
    assert "背包" in listed[0]["title"]

    assert memory.rename_conversation(
        tenant_id=1,
        user_id=100,
        user_type="APP",
        conversation_id="conversation-a",
        title="我的导购",
    )
    listed = memory.list_conversations(tenant_id=1, user_id=100, user_type="APP")
    assert listed[0]["title"] == "我的导购"

    messages = memory.get_messages(
        tenant_id=1,
        user_id=100,
        user_type="APP",
        conversation_id="conversation-a",
    )
    assert len(messages) == 2
    assert messages[0]["role"] == "user"

    assert memory.delete_conversation(
        tenant_id=1,
        user_id=100,
        user_type="APP",
        conversation_id="conversation-a",
    )
    assert memory.list_conversations(tenant_id=1, user_id=100, user_type="APP") == []
    assert memory.get_messages(
        tenant_id=1,
        user_id=100,
        user_type="APP",
        conversation_id="conversation-a",
    ) == []
