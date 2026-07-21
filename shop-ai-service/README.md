# Shop AI Service

商城 AI 独立服务：流式对话、会话上下文、OpenAI-compatible 模型调用，以及经 `shop-server` 的业务工具。

## 来源

`vendor/awesome-llm-apps` 选择性引入了以下 Apache-2.0 示例，用于后续二次开发：

- `ai_customer_support_agent`：客服 Agent 与记忆
- `rag_database_routing`：RAG 查询路由
- `llm_app_personalized_memory`：持久化会话记忆

这些目录目前仅作为源码基线，尚未接入商城，也不应直接运行其 Streamlit 入口。

## 计划边界

- `shop-server` 仍是认证、租户、权限和商城数据的唯一事实来源。
- 本服务负责模型调用、Agent 编排、记忆和 SSE 流式响应。
- 商品、订单、物流等工具通过受控的 `shop-server` 内部 RPC 接入。

## 运行状态

已具备：

- OpenAI-compatible 模型流式调用
- `shop-server` 内部令牌校验
- 统一 SSE：`message` / `tool_result` / `done` / `error`
- 管理端和移动端共用的请求模型
- 会话上下文（本地 SQLite）+ 会话列表/重命名/删除/恢复
- 业务工具：商品搜索/详情、订单/物流、优惠券/售后（只读）、管理端运营简报（低库存/热销/滞销）
- 本地 RAG：`knowledge/*.md` 入库（售后政策/商城规则/FAQ），SQLite FTS 检索增强 system prompt；价库存仍走 tool

## Knowledge / RAG

```bash
# 默认知识目录与索引
knowledge/                 # 放置 .md / .txt
data/shop-ai-knowledge.db  # 自动生成的 FTS 索引
```

启动时会 warmup 索引。修改文档后删除 `data/shop-ai-knowledge.db` 或调用 `KnowledgeStore.reindex()` 即可重建。

**边界**：文档只回答政策/FAQ；商品实时价格与库存必须调用 product tools。

## Production

| 能力 | 默认 | 说明 |
|------|------|------|
| 限流 | `RATE_LIMIT_PER_MINUTE=30` | 按 tenant+user 滑动窗口；多实例可换 Redis |
| 审计 | `data/shop-ai-audit.db` | 记录路径、延迟、粗估 token |
| Prompt 防护 | `ENABLE_PROMPT_GUARD=true` | 拦截常见注入句式 |
| 出站脱敏 | `ENABLE_OUTPUT_REDACTION=true` | 手机号/证件等敏感字段脱敏 |
| 重试/熔断 | shop-server RPC | 超时重试 + 连续失败熔断 |
| 会话存储 | `MEMORY_BACKEND=sqlite` | 多实例设 `redis` + `REDIS_URL` |

### Docker

全栈（在 `shop-server` 侧）：

```bash
# 从 monorepo 根目录
cd shop-server/script/docker
docker compose --env-file docker.env up -d --build shop-ai-service
```

仅 AI 服务：

```bash
cd shop-ai-service
docker compose up -d --build
```

`shop-server` 需配置：

```yaml
yudao.ai.service.base-url: http://shop-ai-service:8000
yudao.ai.service.internal-token: <same as SHOP_AI_INTERNAL_TOKEN>
```

多实例前请将 `MEMORY_BACKEND=redis`，否则会话上下文不会跨副本共享。

## Internal protocol

共享协议：`POST /internal/v1/chat/stream`。`shop-server` facade 完成用户鉴权后，注入 `tenantId`、`userId`、`userType`，再代理 SSE。浏览器不应直连该内部端点。

业务工具 RPC（由本服务服务端调用）：

- `POST /rpc-api/ai/tools/product/search`
- `POST /rpc-api/ai/tools/product/detail`
- `POST /rpc-api/ai/tools/order/list`
- `POST /rpc-api/ai/tools/order/detail`
- `POST /rpc-api/ai/tools/logistics/get`
- `POST /rpc-api/ai/tools/coupon/list`
- `POST /rpc-api/ai/tools/aftersale/list`
- `POST /rpc-api/ai/tools/aftersale/detail`
- `POST /rpc-api/ai/tools/ops/brief`
- `POST /rpc-api/ai/tools/ops/low-stock`
- `POST /rpc-api/ai/tools/ops/hot`
- `POST /rpc-api/ai/tools/ops/slow`

订单/物流接口必须携带当前用户 `userId`（来自 facade，禁止模型侧伪造越权）。

## Local run

```bash
python -m pip install -e ".[dev]"
cp .env.example .env   # 填入 LLM_API_KEY / LLM_MODEL / SHOP_SERVER_INTERNAL_TOKEN
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```

配套 `shop-server` 默认端口 `48080`。

未配置 `LLM_API_KEY` 与 `LLM_MODEL` 时，流式接口返回明确的 provider 配置提示，不会调用外部模型。

## Smoke

```text
POST /internal/v1/chat/stream
message: 搜 backpack
期望: event tool_result (product_list) + message + done
```