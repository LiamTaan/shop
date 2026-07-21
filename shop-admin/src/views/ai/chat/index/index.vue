<template>
  <div class="assistant-page">
    <aside class="conversation-rail">
      <div class="rail-header">
        <strong>历史会话</strong>
        <el-button type="primary" link :disabled="streaming" @click="startNewConversation">新建</el-button>
      </div>
      <div class="conversation-list">
        <button
          v-for="item in conversations"
          :key="item.conversationId"
          class="conversation-item"
          :class="{ active: item.conversationId === conversationId }"
          :disabled="streaming"
          @click="openConversation(item.conversationId)"
        >
          <span class="conversation-title">{{ item.title || '新会话' }}</span>
          <span class="conversation-actions" @click.stop>
            <el-button link type="primary" @click="renameConversation(item)">改名</el-button>
            <el-button link type="danger" @click="removeConversation(item.conversationId)">删</el-button>
          </span>
        </button>
        <div v-if="!conversations.length" class="conversation-empty">暂无历史，发一条消息后出现</div>
      </div>
    </aside>

    <div class="chat-panel">
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
        <el-tooltip content="新开会话（清空当前）" placement="bottom">
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
          <div v-if="item.orders.length" class="order-list">
            <article v-for="order in item.orders" :key="order.id || order.no" class="order-item">
              <div class="order-head">
                <strong>订单 {{ order.no || order.id }}</strong>
                <span>{{ order.statusName || '状态未知' }}</span>
              </div>
              <span>{{ orderItemSummary(order) }}</span>
              <div class="product-stats">
                <b>￥{{ fenToYuan(order.payPrice || 0) }}</b>
                <span>共 {{ order.productCount ?? order.items?.length ?? 0 }} 件</span>
              </div>
            </article>
          </div>
          <div v-if="item.logistics" class="order-list">
            <article class="order-item">
              <div class="order-head">
                <strong>物流 {{ item.logistics.logisticsNo || item.logistics.orderNo }}</strong>
                <span>{{ item.logistics.logisticsName || '物流轨迹' }}</span>
              </div>
              <span
                v-for="(track, index) in item.logistics.tracks || []"
                :key="index"
                class="track-line"
              >
                {{ track.content }}
              </span>
              <span v-if="!(item.logistics.tracks || []).length">暂无物流轨迹</span>
            </article>
          </div>
          <div v-if="item.coupons?.length" class="order-list">
            <article v-for="coupon in item.coupons" :key="coupon.id" class="order-item">
              <div class="order-head">
                <strong>{{ coupon.name || '优惠券' }}</strong>
                <span>{{ coupon.statusName || '状态未知' }}</span>
              </div>
              <div class="product-stats">
                <b v-if="coupon.discountPrice">减￥{{ fenToYuan(coupon.discountPrice) }}</b>
                <b v-else-if="coupon.discountPercent">{{ coupon.discountPercent }} 折</b>
                <span>满￥{{ fenToYuan(coupon.usePrice || 0) }}可用</span>
                <span>{{ coupon.discountTypeName || '' }}</span>
              </div>
            </article>
          </div>
          <div v-if="item.aftersales?.length" class="order-list">
            <article v-for="sale in item.aftersales" :key="sale.id || sale.no" class="order-item">
              <div class="order-head">
                <strong>售后 {{ sale.no || sale.id }}</strong>
                <span>{{ sale.statusName || '状态未知' }}</span>
              </div>
              <span>{{ sale.spuName || '售后商品' }} · 订单 {{ sale.orderNo || '-' }}</span>
              <div class="product-stats">
                <b>退￥{{ fenToYuan(sale.refundPrice || 0) }}</b>
                <span>{{ sale.applyReason || '' }}</span>
              </div>
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
  </div>
</template>

<script setup lang="ts">
import { Delete } from '@element-plus/icons-vue'
import MarkdownView from '@/components/MarkdownView/index.vue'
import {
  AiAfterSaleCard,
  AiCouponCard,
  AiLogisticsCard,
  AiOrderCard,
  AiProductItem,
  ChatMessageApi,
  ShopAssistantEvent
} from '@/api/ai/chat/message'
import { onMounted } from 'vue'

defineOptions({ name: 'AiChat' })

interface AssistantMessage {
  id: number
  role: 'user' | 'assistant'
  content: string
  products: AiProductItem[]
  orders: AiOrderCard[]
  logistics: AiLogisticsCard | null
  coupons: AiCouponCard[]
  aftersales: AiAfterSaleCard[]
}

interface ConversationItem {
  conversationId: string
  title?: string
  updatedTime?: string
}

const router = useRouter()
const message = useMessage()
const prompt = ref('')
const streaming = ref(false)
const messages = ref<AssistantMessage[]>([])
const conversations = ref<ConversationItem[]>([])
const messageContainer = ref<HTMLElement>()
let controller: AbortController | undefined
const createConversationId = () => `admin-${Date.now()}-${Math.random().toString(36).slice(2, 10)}`
const conversationId = ref(createConversationId())

const promptExamples = ['低库存商品有哪些', '热销简报', '滞销商品']
const fenToYuan = (price: number) => (Number(price || 0) / 100).toFixed(2)
const orderItemSummary = (order: AiOrderCard) => {
  const names = (order.items || []).map((item) => item.spuName).filter(Boolean)
  return names.length ? names.slice(0, 2).join('、') : '订单商品'
}

const loadConversations = async () => {
  try {
    const data = await ChatMessageApi.listConversations()
    conversations.value = data?.items || []
  } catch {
    conversations.value = []
  }
}

const openConversation = async (id: string) => {
  if (streaming.value || id === conversationId.value) return
  conversationId.value = id
  messages.value = []
  try {
    const data = await ChatMessageApi.getConversationMessages(id)
    const items = data?.items || []
    messages.value = items.map((item: any, index: number) => ({
      id: Date.now() + index,
      role: item.role === 'user' ? 'user' : 'assistant',
      content: item.content || '',
      products: [],
      orders: [],
      logistics: null,
      coupons: [],
      aftersales: []
    }))
    await scrollToBottom()
  } catch {
    message.error('加载会话失败')
  }
}

const startNewConversation = () => {
  if (streaming.value) return
  conversationId.value = createConversationId()
  messages.value = []
}

const renameConversation = async (item: ConversationItem) => {
  const title = window.prompt('会话名称', item.title || '')
  if (!title?.trim()) return
  await ChatMessageApi.renameConversation(item.conversationId, title.trim())
  await loadConversations()
}

const removeConversation = async (id: string) => {
  await ChatMessageApi.deleteConversation(id)
  if (conversationId.value === id) startNewConversation()
  await loadConversations()
}

onMounted(loadConversations)

const scrollToBottom = async () => {
  await nextTick()
  if (messageContainer.value) {
    messageContainer.value.scrollTop = messageContainer.value.scrollHeight
  }
}

const handleEvent = (target: AssistantMessage, event: ShopAssistantEvent) => {
  if (event.type === 'text_delta') target.content += event.content || ''
  if (event.type === 'product_list') target.products = event.items || []
  if (event.type === 'product_detail' && event.item) target.products = [event.item as AiProductItem]
  if (event.type === 'order_list') target.orders = event.items || []
  if (event.type === 'order_detail' && event.item) target.orders = [event.item]
  if (event.type === 'logistics') target.logistics = event.item || null
  if (event.type === 'coupon_list') target.coupons = event.items || []
  if (event.type === 'aftersale_list') target.aftersales = event.items || []
  if (event.type === 'aftersale_detail' && event.item) target.aftersales = [event.item]
  if (event.type === 'ops_product_list') target.products = (event.items || []) as AiProductItem[]
  if (event.type === 'ops_brief' && event.item) {
    const brief = event.item
    const parts = [
      `上架 ${brief.onSaleCount ?? 0}`,
      `低库存 ${brief.lowStockCount ?? 0}`,
      `售罄 ${brief.soldOutCount ?? 0}`,
      `警戒阈值 ${brief.alertStockThreshold ?? '-'}`
    ]
    target.content = (target.content || '') + (target.content ? '\n' : '') + parts.join(' · ')
    target.products = [
      ...(brief.lowStockItems || []),
      ...(brief.hotItems || []),
      ...(brief.slowItems || [])
    ] as AiProductItem[]
  }
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
  messages.value.push({
    id: Date.now(),
    role: 'user',
    content,
    products: [],
    orders: [],
    logistics: null,
    coupons: [],
    aftersales: []
  })
  const assistant: AssistantMessage = {
    id: Date.now() + 1,
    role: 'assistant',
    content: '',
    products: [],
    orders: [],
    logistics: null,
    coupons: [],
    aftersales: []
  }
  messages.value.push(assistant)
  streaming.value = true
  controller = new AbortController()
  await scrollToBottom()

  try {
    await ChatMessageApi.sendShopAssistantStream(
      content,
      conversationId.value,
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
  } finally {
    await loadConversations()
  }
}

const stopStream = () => {
  controller?.abort()
  streaming.value = false
}

const clearMessages = () => {
  conversationId.value = createConversationId()
  messages.value = []
  loadConversations()
}

const openProduct = (id: number) => {
  router.push({ name: 'ProductSpuDetail', params: { id } })
}

onBeforeUnmount(stopStream)
</script>

<style scoped lang="scss">
.assistant-page {
  display: grid;
  grid-template-columns: 240px minmax(0, 1fr);
  height: calc(100vh - var(--top-tool-height) - var(--tags-view-height) - 32px);
  min-height: 560px;
  overflow: hidden;
}
.chat-panel {
  display: grid;
  grid-template-rows: 64px minmax(0, 1fr) auto;
  min-width: 0;
}
.conversation-rail {
  display: flex;
  flex-direction: column;
  border-right: 1px solid var(--el-border-color-light);
  background: var(--el-bg-color);
}
.rail-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px;
  border-bottom: 1px solid var(--el-border-color-light);
}
.conversation-list {
  overflow-y: auto;
  padding: 8px;
}
.conversation-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
  width: 100%;
  margin-bottom: 8px;
  padding: 10px 12px;
  border: 1px solid transparent;
  border-radius: 8px;
  background: var(--el-fill-color-extra-light);
  text-align: left;
  cursor: pointer;
}
.conversation-item.active {
  border-color: var(--el-color-primary);
  background: var(--el-color-primary-light-9);
}
.conversation-title {
  overflow: hidden;
  color: var(--el-text-color-primary);
  font-size: 13px;
  white-space: nowrap;
  text-overflow: ellipsis;
}
.conversation-actions {
  display: flex;
  gap: 4px;
}
.conversation-empty {
  padding: 16px 8px;
  color: var(--el-text-color-secondary);
  font-size: 12px;
}
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
.order-list {
  display: grid;
  gap: 10px;
  margin-top: 12px;
}
.order-item {
  display: grid;
  gap: 8px;
  padding: 12px;
  background: var(--el-bg-color);
  border: 1px solid var(--el-border-color-light);
  border-radius: 6px;
}
.order-head {
  display: flex;
  justify-content: space-between;
  gap: 12px;
}
.order-head span {
  color: var(--el-color-danger);
  font-size: 13px;
}
.track-line {
  color: var(--el-text-color-secondary);
  font-size: 13px;
  line-height: 1.5;
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
