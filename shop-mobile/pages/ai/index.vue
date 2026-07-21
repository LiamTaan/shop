<template>
  <s-layout title="AI 导购" navbar="inner" :bgStyle="{ color: '#f6f7f9' }">
    <scroll-view class="chat" scroll-y :scroll-into-view="scrollTarget">
      <view
        v-for="(item, index) in messages"
        :id="`message-${index}`"
        :key="index"
        :class="['message', item.role]"
      >
        <view v-if="item.content" class="bubble">{{ item.content }}</view>
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
      </view>
      <view id="chat-bottom" class="chat-bottom" />
    </scroll-view>
    <view class="composer">
      <input
        v-model="draft"
        class="input"
        confirm-type="send"
        placeholder="想买什么？"
        @confirm="send"
      />
      <button class="send" :disabled="streaming || !draft.trim()" @tap="send">发送</button>
    </view>
  </s-layout>
</template>

<script setup>
  import { computed, nextTick, onBeforeUnmount, ref } from 'vue';
  import sheep from '@/sheep';
  import ChatApi from '@/sheep/api/ai/chat';

  const draft = ref('');
  const streaming = ref(false);
  const abortRequest = ref(null);
  const conversationId = `app-${Date.now()}-${Math.random().toString(36).slice(2, 10)}`;
  const messages = ref([
    { role: 'assistant', content: '你好，我可以帮你挑选商城商品。', products: [] },
  ]);
  const scrollTarget = computed(() => `message-${Math.max(messages.value.length - 1, 0)}`);

  const scrollToLatest = () => nextTick(() => {});
  const yuan = (fen) => (Number(fen || 0) / 100).toFixed(2);
  const openProduct = (product) => sheep.$router.go('/pages/goods/index', { id: product.id });

  const send = () => {
    const message = draft.value.trim();
    if (!message || streaming.value) return;
    draft.value = '';
    messages.value.push({ role: 'user', content: message, products: [] });
    const assistant = { role: 'assistant', content: '', products: [] };
    messages.value.push(assistant);
    streaming.value = true;
    abortRequest.value = ChatApi.sendStream(
      { conversationId, content: message, useContext: true },
      {
        onEvent: (event, data) => {
          if (event === 'message' && data.type === 'text_delta')
            assistant.content += data.content || '';
          if (event === 'tool_result' && data.type === 'product_list')
            assistant.products = data.items || [];
          if (event === 'error')
            uni.showToast({ title: data.message || 'AI 请求失败', icon: 'none' });
          if (event === 'done') streaming.value = false;
          scrollToLatest();
        },
        onError: (error) => {
          streaming.value = false;
          assistant.content = assistant.content || error.message || 'AI 请求失败，请稍后重试。';
        },
        onClose: () => {
          streaming.value = false;
        },
      },
    );
  };

  onBeforeUnmount(() => abortRequest.value?.abort());
</script>

<style lang="scss">
  .chat {
    height: calc(100vh - 190rpx);
    padding: 24rpx;
    box-sizing: border-box;
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
  .products {
    width: 100%;
    margin-top: 16rpx;
  }
  .product {
    display: flex;
    padding: 18rpx;
    margin-bottom: 14rpx;
    background: #fff;
    border-radius: 12rpx;
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
  .product-meta {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    margin-top: auto;
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
