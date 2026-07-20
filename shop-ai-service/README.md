# Shop AI Service

商城 AI 服务独立项目骨架。当前阶段只完成工程边界和第三方示例引入，不包含商城业务实现。

## 来源

`vendor/awesome-llm-apps` 选择性引入了以下 Apache-2.0 示例，用于后续二次开发：

- `ai_customer_support_agent`：客服 Agent 与记忆
- `rag_database_routing`：RAG 查询路由
- `llm_app_personalized_memory`：持久化会话记忆

这些目录目前仅作为源码基线，尚未接入商城，也不应直接运行其 Streamlit 入口。

## 计划边界

- `shop-server` 仍是认证、租户、权限和商城数据的唯一事实来源。
- 本服务后续负责模型调用、Agent 编排、RAG、记忆和 SSE 流式响应。
- 商品、订单、物流、售后工具通过受控的 `shop-server` 内部接口接入。

## 运行状态

当前已具备第一条流式链路：

- OpenAI-compatible 模型流式调用
- `shop-server` 内部令牌校验
- 统一 SSE `message / done / error` 事件
- 管理端和移动端共用的请求模型

商品、订单、物流工具和会话持久化尚未实现。

## Internal protocol

The first shared protocol is `POST /internal/v1/chat/stream`. The shop-server
facade will authenticate the caller, add `tenantId`, `userId`, and `userType`,
then proxy the SSE stream to either the admin or app API. Direct browser access
to this internal endpoint is not supported.

## Local run

```bash
python -m pip install -e ".[dev]"
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```

Without `LLM_API_KEY` and `LLM_MODEL`, the stream returns an explicit provider
configuration message instead of calling an external model.
