import request from '@/config/axios'
import { fetchEventSource } from '@microsoft/fetch-event-source'
import { getAccessToken, getTenantId } from '@/utils/auth'
import { config } from '@/config/axios/config'

// 聊天VO
export interface ChatMessageVO {
  id: number // 编号
  conversationId: number // 对话编号
  type: string // 消息类型
  userId: string // 用户编号
  roleId: string // 角色编号
  model: number // 模型标志
  modelId: number // 模型编号
  content: string // 聊天内容
  reasoningContent?: string // 推理内容
  attachmentUrls?: string[] // 附件 URL 数组
  tokens: number // 消耗 Token 数量
  segmentIds?: number[] // 段落编号
  segments?: {
    id: number // 段落编号
    content: string // 段落内容
    documentId: number // 文档编号
    documentName: string // 文档名称
  }[]
  webSearchPages?: {
    name: string // 名称
    icon: string // 图标
    title: string // 标题
    url: string // URL
    snippet: string // 内容的简短描述
    summary: string // 内容的文本摘要
  }[]
  createTime: Date // 创建时间
  roleAvatar: string // 角色头像
  userAvatar: string // 用户头像
  toolResults?: ShopAssistantEvent[] // AI tool card data
}

export interface AiProductItem {
  id: number
  /** SPU id used by the admin product detail route. */
  spuId?: number
  name: string
  introduction?: string
  picUrl?: string
  price: number
  marketPrice?: number
  stock: number
  salesCount: number
}

export interface AiOrderItem {
  id?: number
  spuId?: number
  spuName?: string
  picUrl?: string
  count?: number
  price?: number
  payPrice?: number
}

export interface AiOrderCard {
  id?: number
  no?: string
  status?: number
  statusName?: string
  productCount?: number
  payPrice?: number
  logisticsName?: string
  logisticsNo?: string
  items?: AiOrderItem[]
}

export interface AiLogisticsCard {
  orderId?: number
  orderNo?: string
  logisticsName?: string
  logisticsNo?: string
  tracks?: { time?: string; content?: string }[]
}

export interface AiCouponCard {
  id?: number
  name?: string
  status?: number
  statusName?: string
  usePrice?: number
  discountType?: number
  discountTypeName?: string
  discountPercent?: number
  discountPrice?: number
  validEndTime?: string
}

export interface AiAfterSaleCard {
  id?: number
  no?: string
  status?: number
  statusName?: string
  orderNo?: string
  spuName?: string
  picUrl?: string
  count?: number
  refundPrice?: number
  applyReason?: string
}

export type ShopAssistantEvent =
  | { type: 'text_delta'; content: string }
  | { type: 'product_list'; items: AiProductItem[] }
  | { type: 'product_detail'; item: AiProductItem | null }
  | { type: 'order_list'; items: AiOrderCard[] }
  | { type: 'order_detail'; item: AiOrderCard | null }
  | { type: 'logistics'; item: AiLogisticsCard | null }
  | { type: 'coupon_list'; items: AiCouponCard[] }
  | { type: 'aftersale_list'; items: AiAfterSaleCard[] }
  | { type: 'aftersale_detail'; item: AiAfterSaleCard | null }
  | {
      type: 'ops_product_list'
      kind?: 'low_stock' | 'hot' | 'slow'
      items: AiProductItem[]
    }
  | {
      type: 'ops_brief'
      item: {
        alertStockThreshold?: number
        lowStockCount?: number
        soldOutCount?: number
        onSaleCount?: number
        lowStockItems?: AiProductItem[]
        hotItems?: AiProductItem[]
        slowItems?: AiProductItem[]
      }
    }
  | {
      type: 'knowledge_list'
      items: { docId?: string; title?: string; content?: string; score?: number }[]
    }
  | { type: 'done'; messageId?: string }
  | { type: 'error'; message: string }

// AI chat 聊天
export const ChatMessageApi = {
  listConversations: async () => {
    return await request.post({ url: `/ai/chat/message/conversation/list` })
  },

  getConversationMessages: async (conversationId: string) => {
    return await request.post({
      url: `/ai/chat/message/conversation/messages`,
      data: { conversationId }
    })
  },

  renameConversation: async (conversationId: string, title: string) => {
    return await request.post({
      url: `/ai/chat/message/conversation/rename`,
      data: { conversationId, title }
    })
  },

  deleteConversation: async (conversationId: string) => {
    return await request.post({
      url: `/ai/chat/message/conversation/delete`,
      data: { conversationId }
    })
  },

  sendShopAssistantStream: async (
    content: string,
    conversationId: string,
    ctrl: AbortController,
    onEvent: (event: ShopAssistantEvent) => void,
    onError: (error: unknown) => void,
    onClose: () => void
  ) => {
    const token = getAccessToken()
    return fetchEventSource(`${config.base_url}/ai/chat/message/send-stream`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
        'tenant-id': `${getTenantId() || ''}`
      },
      openWhenHidden: true,
      body: JSON.stringify({
        conversationId,
        content,
        useContext: true,
        useSearch: false,
        attachmentUrls: []
      }),
      signal: ctrl.signal,
      onopen: async (response) => {
        if (!response.ok) {
          throw new Error(`AI request failed: ${response.status}`)
        }
      },
      onmessage: (event) => {
        onEvent(JSON.parse(event.data) as ShopAssistantEvent)
      },
      onerror: (error) => {
        onError(error)
        throw error
      },
      onclose: onClose
    })
  },

  // 消息列表
  getChatMessageListByConversationId: async (conversationId: number | null) => {
    return await request.get({
      url: `/ai/chat/message/list-by-conversation-id?conversationId=${conversationId}`
    })
  },

  // 发送 Stream 消息
  // 为什么不用 axios 呢？因为它不支持 SSE 调用
  sendChatMessageStream: async (
    conversationId: number,
    content: string,
    ctrl,
    enableContext: boolean,
    enableWebSearch: boolean,
    onMessage,
    onError,
    onClose,
    attachmentUrls?: string[]
  ) => {
    const token = getAccessToken()
    const sendMessageId = -Date.now()
    const receiveMessageId = sendMessageId - 1
    return fetchEventSource(`${config.base_url}/ai/chat/message/send-stream`, {
      method: 'post',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
        'tenant-id': `${getTenantId() || ''}`
      },
      openWhenHidden: true,
      body: JSON.stringify({
        conversationId,
        content,
        useContext: enableContext,
        useSearch: enableWebSearch,
        attachmentUrls: attachmentUrls || []
      }),
      onmessage: (event) => {
        const payload = JSON.parse(event.data)
        if (payload.type !== 'text_delta') {
          return
        }
        onMessage({
          ...event,
          data: JSON.stringify({
            code: 0,
            data: {
              send: {
                id: sendMessageId,
                conversationId,
                type: 'user',
                content,
                createTime: new Date()
              },
              receive: {
                id: receiveMessageId,
                conversationId,
                type: 'assistant',
                content: payload.content,
                reasoningContent: '',
                createTime: new Date()
              }
            },
            msg: ''
          })
        })
      },
      onerror: onError,
      onclose: onClose,
      signal: ctrl.signal
    })
  },

  // 删除消息
  deleteChatMessage: async (id: string) => {
    return await request.delete({ url: `/ai/chat/message/delete?id=${id}` })
  },

  // 删除指定对话的消息
  deleteByConversationId: async (conversationId: number) => {
    return await request.delete({
      url: `/ai/chat/message/delete-by-conversation-id?conversationId=${conversationId}`
    })
  },

  // 获得消息分页
  getChatMessagePage: async (params: any) => {
    return await request.get({ url: '/ai/chat/message/page', params })
  },

  // 管理员删除消息
  deleteChatMessageByAdmin: async (id: number) => {
    return await request.delete({ url: `/ai/chat/message/delete-by-admin?id=${id}` })
  }
}
