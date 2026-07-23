<template>
  <s-layout
    title="AI 助手"
    navbar="normal"
    color="#1f2937"
    navbarBackgroundColor="#f6f7f9"
    :bgStyle="{ color: '#f6f7f9' }"
  >
    <view class="chat-toolbar">
      <text class="conversation-label">AI 商城助手</text>
      <view class="toolbar-actions">
        <view class="conversation-picker" @tap="chooseConversation">会话</view>
        <view class="new-conversation" @tap="startNewConversation">新会话</view>
      </view>
    </view>
    <scroll-view class="chat" scroll-y :scroll-into-view="scrollTarget">
      <view
        v-for="(item, index) in messages"
        :id="`message-${index}`"
        :key="index"
        :class="['message', item.role]"
      >
        <view v-if="item.content" class="bubble">{{ item.content }}</view>
        <view v-if="item.pending" class="thinking-bubble">
          <view class="thinking-dots" aria-label="AI 正在思考">
            <view></view>
            <view></view>
            <view></view>
          </view>
          <text>{{ item.status || 'AI 正在思考…' }}</text>
        </view>
        <view v-if="item.products?.length" class="products">
          <view
            v-for="product in item.products"
            :key="product.id"
            class="product"
            @tap="openProduct(product)"
          >
            <image class="product-image" :src="product.picUrl" mode="aspectFill" />
            <view class="product-body">
              <text class="product-name">{{ product.name }}</text>
              <text class="product-intro">{{ product.introduction || '精选商品' }}</text>
              <view class="product-meta">
                <text class="price">￥{{ yuan(product.price) }}</text>
                <text class="stock">库存 {{ product.stock ?? 0 }}</text>
              </view>
            </view>
          </view>
        </view>
        <view v-if="item.orders?.length" class="orders">
          <view
            v-for="order in item.orders"
            :key="order.id || order.no"
            class="order"
            @tap="openOrder(order)"
          >
            <view class="order-head">
              <text class="order-no">订单 {{ order.no || order.id }}</text>
              <text class="order-status">{{ order.statusName || '状态未知' }}</text>
            </view>
            <text class="order-items">{{ orderItemSummary(order) }}</text>
            <view class="order-meta">
              <text class="price">￥{{ yuan(order.payPrice) }}</text>
              <text class="stock">共 {{ order.productCount ?? order.items?.length ?? 0 }} 件</text>
            </view>
          </view>
        </view>
        <view v-if="item.logistics" class="logistics">
          <view class="order-head">
            <text class="order-no"
              >物流 {{ item.logistics.logisticsNo || item.logistics.orderNo }}</text
            >
            <text class="order-status">{{ item.logistics.logisticsName || '物流轨迹' }}</text>
          </view>
          <view
            v-for="(track, trackIndex) in item.logistics.tracks || []"
            :key="trackIndex"
            class="track"
          >
            <text class="track-content">{{ track.content }}</text>
          </view>
          <view v-if="!(item.logistics.tracks || []).length" class="track">
            <text class="track-content">暂无物流轨迹</text>
          </view>
        </view>
        <view v-if="item.coupons?.length" class="orders">
          <view v-for="coupon in item.coupons" :key="coupon.id" class="order">
            <view class="order-head">
              <text class="order-no">{{ coupon.name || '优惠券' }}</text>
              <text class="order-status">{{ coupon.statusName || '状态未知' }}</text>
            </view>
            <view class="order-meta">
              <text class="price" v-if="coupon.discountPrice"
                >减￥{{ yuan(coupon.discountPrice) }}</text
              >
              <text class="price" v-else-if="coupon.discountPercent"
                >{{ coupon.discountPercent }}折</text
              >
              <text class="stock">满￥{{ yuan(coupon.usePrice || 0) }}</text>
            </view>
          </view>
        </view>
        <view v-if="item.aftersales?.length" class="orders">
          <view
            v-for="sale in item.aftersales"
            :key="sale.id || sale.no"
            class="order"
            @tap="openAfterSale(sale)"
          >
            <view class="order-head">
              <text class="order-no">售后 {{ sale.no || sale.id }}</text>
              <text class="order-status">{{ sale.statusName || '状态未知' }}</text>
            </view>
            <text class="order-items">{{ sale.spuName || '售后商品' }}</text>
            <view class="order-meta">
              <text class="price">退￥{{ yuan(sale.refundPrice) }}</text>
              <text class="stock">{{ sale.applyReason || '' }}</text>
            </view>
          </view>
        </view>
      </view>
      <view id="chat-bottom" class="chat-bottom" />
    </scroll-view>
    <view class="composer">
      <input
        v-model="draft"
        class="input"
        confirm-type="send"
        placeholder="想买什么？或问我订单/物流"
        @confirm="send"
      />
      <button class="send" :disabled="streaming || !draft.trim()" @tap="send">
        {{ streaming ? '思考中' : '发送' }}
      </button>
    </view>
  </s-layout>
</template>

<script setup>
  import { nextTick, onBeforeUnmount, ref } from 'vue';
  import { onLoad } from '@dcloudio/uni-app';
  import sheep from '@/sheep';
  import ChatApi from '@/sheep/api/ai/chat';

  const draft = ref('');
  const streaming = ref(false);
  const abortRequest = ref(null);
  const createConversationId = () => `app-${Date.now()}-${Math.random().toString(36).slice(2, 10)}`;
  const conversationId = ref(createConversationId());
  const messages = ref([]);
  const scrollTarget = ref('');

  const scrollToLatest = () => {
    scrollTarget.value = '';
    nextTick(() => {
      scrollTarget.value = 'chat-bottom';
    });
  };
  const responseData = (response) => response?.data || response || {};
  const createMessage = (role, content = '', extra = {}) => ({
    role,
    content,
    products: [],
    orders: [],
    logistics: null,
    coupons: [],
    aftersales: [],
    pending: false,
    status: '',
    ...extra,
  });
  const showWelcome = () => {
    if (!messages.value.length) {
      messages.value = [
        createMessage('assistant', '你好，我可以帮你挑选商品，查询订单/物流，以及优惠券和售后。'),
      ];
    }
  };
  const applyToolResult = (target, data) => {
    if (data.type === 'product_list') target.products = data.items || [];
    if (data.type === 'product_detail' && data.item) target.products = [data.item];
    if (data.type === 'order_list') target.orders = data.items || [];
    if (data.type === 'order_detail' && data.item) target.orders = [data.item];
    if (data.type === 'logistics') target.logistics = data.item || null;
    if (data.type === 'coupon_list') target.coupons = data.items || [];
    if (data.type === 'aftersale_list') target.aftersales = data.items || [];
    if (data.type === 'aftersale_detail' && data.item) target.aftersales = [data.item];
  };
  const restoreLatestConversation = async () => {
    try {
      const result = responseData(await ChatApi.listConversations());
      const latest = result.items?.[0];
      if (!latest?.conversationId) {
        showWelcome();
        return;
      }
      conversationId.value = latest.conversationId;
      const history = responseData(await ChatApi.getConversationMessages(conversationId.value));
      messages.value = (history.items || []).map((item) => {
        const target = createMessage(
          item.role === 'user' ? 'user' : 'assistant',
          item.content || '',
        );
        (item.toolResults || []).forEach((toolResult) => applyToolResult(target, toolResult));
        return target;
      });
      showWelcome();
      scrollToLatest();
    } catch (error) {
      // Recovery is best-effort. A new conversation remains available after a transient failure.
      showWelcome();
    }
  };
  const loadConversation = async (id) => {
    conversationId.value = id;
    const result = responseData(await ChatApi.getConversationMessages(id));
    messages.value = (result.items || []).map((item) => {
      const target = createMessage(item.role === 'user' ? 'user' : 'assistant', item.content || '');
      (item.toolResults || []).forEach((toolResult) => applyToolResult(target, toolResult));
      return target;
    });
    showWelcome();
    scrollToLatest();
  };
  const startNewConversation = () => {
    abortRequest.value?.abort();
    conversationId.value = createConversationId();
    messages.value = [];
    streaming.value = false;
    showWelcome();
    scrollToLatest();
  };
  const chooseConversation = async () => {
    try {
      const result = responseData(await ChatApi.listConversations());
      const conversations = result.items || [];
      if (!conversations.length) {
        uni.showToast({ title: '暂无历史会话', icon: 'none' });
        return;
      }
      uni.showActionSheet({
        itemList: conversations.slice(0, 8).map((item) => item.title || '新会话'),
        success: async ({ tapIndex }) => {
          try {
            await loadConversation(conversations[tapIndex].conversationId);
          } catch {
            uni.showToast({ title: '加载会话失败', icon: 'none' });
          }
        },
      });
    } catch {
      uni.showToast({ title: '加载会话失败', icon: 'none' });
    }
  };
  const yuan = (fen) => (Number(fen || 0) / 100).toFixed(2);
  const openProduct = (product) => sheep.$router.go('/pages/goods/index', { id: product.id });
  const openOrder = (order) => {
    if (!order?.id) return;
    sheep.$router.go('/pages/order/detail', { id: order.id });
  };
  const openAfterSale = (sale) => {
    if (!sale?.id) return;
    sheep.$router.go('/pages/order/aftersale/detail', { id: sale.id });
  };
  const orderItemSummary = (order) => {
    const names = (order.items || []).map((item) => item.spuName).filter(Boolean);
    if (names.length) return names.slice(0, 2).join('、');
    return '订单商品';
  };

  const emptyAssistant = () => ({
    role: 'assistant',
    content: '',
    products: [],
    orders: [],
    logistics: null,
    coupons: [],
    aftersales: [],
    pending: true,
    status: 'AI 正在思考…',
  });

  const setAssistantStatus = (assistant, status) => {
    assistant.pending = true;
    assistant.status = status;
  };

  const send = () => {
    const message = draft.value.trim();
    if (!message || streaming.value) return;
    draft.value = '';
    messages.value.push(createMessage('user', message));
    const assistant = emptyAssistant();
    messages.value.push(assistant);
    streaming.value = true;
    abortRequest.value = ChatApi.sendStream(
      { conversationId: conversationId.value, content: message, useContext: true },
      {
        onEvent: (event, data) => {
          if (event === 'message' && data.type === 'text_delta') {
            assistant.pending = false;
            assistant.content += data.content || '';
          }
          if (event === 'tool_result' && data.type === 'product_list') {
            setAssistantStatus(assistant, '正在整理商品信息…');
          }
          if (event === 'tool_result' && data.type === 'product_detail' && data.item) {
            setAssistantStatus(assistant, '正在整理商品信息…');
          }
          if (event === 'tool_result' && data.type === 'order_list') {
            setAssistantStatus(assistant, '正在查询订单信息…');
          }
          if (event === 'tool_result' && data.type === 'order_detail' && data.item) {
            setAssistantStatus(assistant, '正在查询订单信息…');
          }
          if (event === 'tool_result' && data.type === 'logistics') {
            setAssistantStatus(assistant, '正在查询物流信息…');
          }
          if (event === 'tool_result' && data.type === 'coupon_list') {
            setAssistantStatus(assistant, '正在查询优惠信息…');
          }
          if (event === 'tool_result' && data.type === 'aftersale_list') {
            setAssistantStatus(assistant, '正在查询售后信息…');
          }
          if (event === 'tool_result' && data.type === 'aftersale_detail' && data.item) {
            setAssistantStatus(assistant, '正在查询售后信息…');
          }
          if (event === 'tool_result') applyToolResult(assistant, data);
          if (event === 'error') {
            assistant.pending = false;
            uni.showToast({ title: data.message || 'AI 请求失败', icon: 'none' });
          }
          if (event === 'done') {
            assistant.pending = false;
            streaming.value = false;
          }
          scrollToLatest();
        },
        onError: (error) => {
          streaming.value = false;
          assistant.pending = false;
          assistant.content = assistant.content || error.message || 'AI 请求失败，请稍后重试。';
        },
        onClose: () => {
          streaming.value = false;
          if (assistant.pending) {
            assistant.pending = false;
            assistant.content = assistant.content || '暂未收到回复，请稍后重试。';
          }
        },
      },
    );
  };

  onLoad(async (options) => {
    if (options.newConversation === '1') {
      startNewConversation();
      return;
    }
    if (options.conversationId) {
      try {
        await loadConversation(options.conversationId);
      } catch {
        startNewConversation();
      }
      return;
    }
    await restoreLatestConversation();
  });
  onBeforeUnmount(() => abortRequest.value?.abort());
</script>

<style lang="scss">
  .chat {
    height: calc(100vh - 262rpx);
    padding: 24rpx;
    padding-bottom: 0;
    box-sizing: border-box;
  }
  .chat-bottom {
    height: calc(136rpx + env(safe-area-inset-bottom));
  }
  .chat-toolbar {
    display: flex;
    height: 72rpx;
    align-items: center;
    justify-content: space-between;
    padding: 0 24rpx;
    border-bottom: 1rpx solid #eceef2;
    background: #f6f7f9;
  }
  .conversation-label {
    color: #737a85;
    font-size: 24rpx;
  }
  .toolbar-actions {
    display: flex;
    align-items: center;
    gap: 14rpx;
  }
  .conversation-picker {
    padding: 10rpx 16rpx;
    border: 1rpx solid #e0e3e8;
    border-radius: 8rpx;
    color: #66707e;
    font-size: 24rpx;
  }
  .new-conversation {
    padding: 10rpx 16rpx;
    border-radius: 8rpx;
    background: #fff0ed;
    color: #e94b35;
    font-size: 24rpx;
  }
  .message {
    display: flex;
    flex-direction: column;
    margin-bottom: 24rpx;
  }
  .message.user {
    align-items: flex-end;
  }
  .bubble {
    max-width: 78%;
    padding: 20rpx 24rpx;
    border-radius: 18rpx;
    background: #fff;
    color: #333;
    line-height: 1.6;
  }
  .user .bubble {
    background: #e94b35;
    color: #fff;
  }
  .thinking-bubble {
    display: inline-flex;
    align-items: center;
    align-self: flex-start;
    min-height: 68rpx;
    padding: 0 24rpx;
    border-radius: 18rpx;
    background: #fff;
    color: #6b7280;
    font-size: 25rpx;
  }
  .thinking-dots {
    display: flex;
    align-items: center;
    gap: 6rpx;
    margin-right: 14rpx;

    view {
      width: 10rpx;
      height: 10rpx;
      border-radius: 50%;
      background: #e94b35;
      animation: thinking-pulse 1.2s ease-in-out infinite;

      &:nth-child(2) {
        animation-delay: 0.15s;
      }

      &:nth-child(3) {
        animation-delay: 0.3s;
      }
    }
  }
  @keyframes thinking-pulse {
    0%,
    80%,
    100% {
      opacity: 0.35;
      transform: scale(0.75);
    }
    40% {
      opacity: 1;
      transform: scale(1);
    }
  }
  .products,
  .orders,
  .logistics {
    width: 100%;
    margin-top: 16rpx;
  }
  .product,
  .order,
  .logistics {
    display: flex;
    padding: 18rpx;
    margin-bottom: 14rpx;
    background: #fff;
    border-radius: 12rpx;
  }
  .order,
  .logistics {
    flex-direction: column;
  }
  .product-image {
    width: 150rpx;
    height: 150rpx;
    border-radius: 8rpx;
    background: #f0f0f0;
    flex: none;
  }
  .product-body {
    display: flex;
    flex: 1;
    flex-direction: column;
    min-width: 0;
    margin-left: 18rpx;
  }
  .product-name {
    overflow: hidden;
    color: #222;
    font-weight: 600;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
  .product-intro {
    display: -webkit-box;
    overflow: hidden;
    margin-top: 10rpx;
    color: #888;
    font-size: 24rpx;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }
  .product-meta,
  .order-meta,
  .order-head {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
  }
  .product-meta,
  .order-meta {
    margin-top: auto;
  }
  .order-head {
    margin-bottom: 10rpx;
  }
  .order-no {
    color: #222;
    font-weight: 600;
  }
  .order-status {
    color: #e94b35;
    font-size: 24rpx;
  }
  .order-items {
    color: #666;
    font-size: 24rpx;
    margin-bottom: 12rpx;
  }
  .price {
    color: #e94b35;
    font-size: 30rpx;
    font-weight: 700;
  }
  .stock {
    color: #999;
    font-size: 22rpx;
  }
  .track {
    margin-top: 8rpx;
  }
  .track-content {
    color: #555;
    font-size: 24rpx;
    line-height: 1.5;
  }
  .composer {
    position: fixed;
    right: 0;
    bottom: 0;
    left: 0;
    display: flex;
    align-items: center;
    padding: 18rpx 24rpx calc(18rpx + env(safe-area-inset-bottom));
    background: #fff;
    box-shadow: 0 -2rpx 12rpx rgba(0, 0, 0, 0.06);
  }
  .input {
    flex: 1;
    height: 76rpx;
    padding: 0 22rpx;
    border-radius: 38rpx;
    background: #f4f5f7;
  }
  .send {
    width: 132rpx;
    height: 76rpx;
    margin-left: 16rpx;
    padding: 0;
    border-radius: 38rpx;
    background: #e94b35;
    color: #fff;
    font-size: 28rpx;
    line-height: 76rpx;
  }
  .send[disabled] {
    background: #ccc;
  }
</style>
