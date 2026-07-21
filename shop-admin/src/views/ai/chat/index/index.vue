<template>
  <div class="assistant-page">
    <header class="assistant-header">
      <div>
        <h1>商城 AI 助手</h1>
        <span>{{ streaming ? '正在生成' : '在线' }}</span>
      </div>
      <div class="header-actions">
        <el-button v-if="streaming" type="danger" plain @click="stopStream">
          <Icon icon="ep:video-pause" />
          停止
        </el-button>
        <el-tooltip content="清空对话" placement="bottom">
          <el-button :icon="Delete" circle :disabled="streaming" @click="clearMessages" />
        </el-tooltip>
      </div>
    </header>

    <main ref="messageContainer" class="message-list">
      <section v-if="messages.length === 0" class="empty-state">
        <Icon icon="ep:chat-dot-round" :size="42" color="var(--el-color-primary)" />
        <div class="prompts">
          <el-button v-for="item in promptExamples" :key="item" plain @click="send(item)">
            {{ item }}
          </el-button>
        </div>
      </section>

      <section v-for="item in messages" :key="item.id" class="message-row" :class="item.role">
        <el-avatar v-if="item.role === 'assistant'" :size="34">
          <Icon icon="ep:service" />
        </el-avatar>
        <div class="message-content">
          <div class="message-meta">{{ item.role === 'user' ? '我' : '商城助手' }}</div>
          <div v-if="item.content" class="message-bubble">
            <MarkdownView v-if="item.role === 'assistant'" :content="item.content" />
            <span v-else>{{ item.content }}</span>
          </div>
          <div v-if="item.products.length" class="product-list">
            <article v-for="product in item.products" :key="product.id" class="product-item">
              <el-image :src="product.picUrl" fit="cover" class="product-image">
                <template #error><Icon icon="ep:picture" :size="28" /></template>
              </el-image>
              <div class="product-info">
                <strong>{{ product.name }}</strong>
                <span>{{ product.introduction || '暂无商品简介' }}</span>
                <div class="product-stats">
                  <b>￥{{ fenToYuan(product.price) }}</b>
                  <span>库存 {{ product.stock ?? 0 }}</span>
                  <span>销量 {{ product.salesCount ?? 0 }}</span>
                </div>
              </div>
              <el-button type="primary" link @click="openProduct(product.id)">
                查看商品
                <Icon icon="ep:arrow-right" />
              </el-button>
            </article>
          </div>
        </div>
      </section>
    </main>

    <footer class="composer">
      <el-input
        v-model="prompt"
        type="textarea"
        :rows="3"
        resize="none"
        maxlength="8000"
        show-word-limit
        placeholder="输入运营问题或商品查询"
        @keydown.enter.exact.prevent="send()"
      />
      <el-tooltip content="发送" placement="top">
        <el-button
          type="primary"
          circle
          class="send-button"
          :loading="streaming"
          :disabled="!prompt.trim()"
          @click="send()"
        >
          <Icon icon="ep:promotion" />
        </el-button>
      </el-tooltip>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { Delete } from '@element-plus/icons-vue'
import MarkdownView from '@/components/MarkdownView/index.vue'
import { AiProductItem, ChatMessageApi, ShopAssistantEvent } from '@/api/ai/chat/message'

defineOptions({ name: 'AiChat' })

interface AssistantMessage {
  id: number
  role: 'user' | 'assistant'
  content: string
  products: AiProductItem[]
}

const router = useRouter()
const message = useMessage()
const prompt = ref('')
const streaming = ref(false)
const messages = ref<AssistantMessage[]>([])
const messageContainer = ref<HTMLElement>()
let controller: AbortController | undefined

const promptExamples = ['搜索背包商品', '推荐库存充足的商品', '查找适合促销的商品']
const fenToYuan = (price: number) => (Number(price || 0) / 100).toFixed(2)

const scrollToBottom = async () => {
  await nextTick()
  if (messageContainer.value) {
    messageContainer.value.scrollTop = messageContainer.value.scrollHeight
  }
}

const handleEvent = (target: AssistantMessage, event: ShopAssistantEvent) => {
  if (event.type === 'text_delta') target.content += event.content || ''
  if (event.type === 'product_list') target.products = event.items || []
  if (event.type === 'done') streaming.value = false
  if (event.type === 'error') {
    streaming.value = false
    message.error(event.message || 'AI 请求失败')
  }
  scrollToBottom()
}

const send = async (preset?: string) => {
  const content = (preset || prompt.value).trim()
  if (!content || streaming.value) return

  prompt.value = ''
  messages.value.push({ id: Date.now(), role: 'user', content, products: [] })
  const assistant: AssistantMessage = {
    id: Date.now() + 1,
    role: 'assistant',
    content: '',
    products: []
  }
  messages.value.push(assistant)
  streaming.value = true
  controller = new AbortController()
  await scrollToBottom()

  try {
    await ChatMessageApi.sendShopAssistantStream(
      content,
      controller,
      (event) => handleEvent(assistant, event),
      () => {
        streaming.value = false
        if (!controller?.signal.aborted) message.error('AI 服务连接失败')
      },
      () => {
        streaming.value = false
      }
    )
  } catch (error) {
    if (!controller.signal.aborted) {
      assistant.content ||= '请求失败，请稍后重试。'
    }
  }
}

const stopStream = () => {
  controller?.abort()
  streaming.value = false
}

const clearMessages = () => {
  messages.value = []
}

const openProduct = (id: number) => {
  router.push({ name: 'ProductSpuDetail', params: { id } })
}

onBeforeUnmount(stopStream)
</script>

<style scoped lang="scss">
.assistant-page {
  display: grid;
  grid-template-rows: 64px minmax(0, 1fr) auto;
  height: calc(100vh - var(--top-tool-height) - var(--tags-view-height) - 32px);
  min-height: 560px;
  overflow: hidden;
  background: var(--el-bg-color);
  border: 1px solid var(--el-border-color-light);
  border-radius: 6px;
}

.assistant-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  border-bottom: 1px solid var(--el-border-color-light);

  h1 {
    display: inline;
    margin: 0 12px 0 0;
    font-size: 17px;
    letter-spacing: 0;
  }
  span {
    color: var(--el-text-color-secondary);
    font-size: 13px;
  }
}

.header-actions {
  display: flex;
  gap: 10px;
}
.message-list {
  overflow-y: auto;
  padding: 24px max(24px, calc((100% - 900px) / 2));
  background: var(--el-fill-color-extra-light);
}
.empty-state {
  display: grid;
  place-items: center;
  align-content: center;
  min-height: 100%;
  gap: 28px;
}
.prompts {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 10px;
}
.message-row {
  display: flex;
  gap: 12px;
  margin-bottom: 28px;
}
.message-row.user {
  justify-content: flex-end;
}
.message-content {
  max-width: min(760px, 82%);
  min-width: 0;
}
.message-meta {
  margin-bottom: 7px;
  color: var(--el-text-color-secondary);
  font-size: 12px;
}
.user .message-meta {
  text-align: right;
}
.message-bubble {
  padding: 12px 15px;
  background: var(--el-bg-color);
  border: 1px solid var(--el-border-color-light);
  border-radius: 6px;
  line-height: 1.7;
  white-space: pre-wrap;
}
.user .message-bubble {
  color: #fff;
  background: var(--el-color-primary);
  border-color: var(--el-color-primary);
}
.product-list {
  display: grid;
  gap: 10px;
  margin-top: 12px;
}
.product-item {
  display: grid;
  grid-template-columns: 76px minmax(0, 1fr) auto;
  align-items: center;
  gap: 14px;
  padding: 12px;
  background: var(--el-bg-color);
  border: 1px solid var(--el-border-color-light);
  border-radius: 6px;
}
.product-image {
  width: 76px;
  height: 76px;
  display: grid;
  place-items: center;
  background: var(--el-fill-color-light);
  border-radius: 4px;
}
.product-info {
  display: grid;
  min-width: 0;
  gap: 6px;
}
.product-info strong,
.product-info > span {
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}
.product-info > span {
  color: var(--el-text-color-secondary);
  font-size: 13px;
}
.product-stats {
  display: flex;
  align-items: center;
  gap: 16px;
  font-size: 13px;
}
.product-stats b {
  color: var(--el-color-danger);
  font-size: 16px;
}
.product-stats span {
  color: var(--el-text-color-secondary);
}
.composer {
  position: relative;
  padding: 16px max(24px, calc((100% - 900px) / 2));
  border-top: 1px solid var(--el-border-color-light);
}
.composer :deep(.el-textarea__inner) {
  padding-right: 56px;
}
.send-button {
  position: absolute;
  right: max(38px, calc((100% - 872px) / 2));
  bottom: 34px;
}

@media (max-width: 768px) {
  .assistant-page {
    height: calc(100vh - 120px);
    min-height: 480px;
  }
  .message-list,
  .composer {
    padding-right: 14px;
    padding-left: 14px;
  }
  .message-content {
    max-width: 90%;
  }
  .product-item {
    grid-template-columns: 60px minmax(0, 1fr);
  }
  .product-image {
    width: 60px;
    height: 60px;
  }
  .product-item > .el-button {
    grid-column: 2;
    justify-self: start;
  }
  .send-button {
    right: 28px;
  }
}
</style>
