<template>
  <s-layout title="消息" navbar="normal" color="#1f2937" navbarBackgroundColor="#f6f7f9">
    <view class="message-page">
      <view class="section-title">智能服务</view>
      <view class="conversation-card ai-card" @tap="openAi()">
        <view class="avatar ai-avatar">AI</view>
        <view class="conversation-main">
          <view class="conversation-head">
            <text class="conversation-name">AI 商城助手</text>
            <text class="conversation-time">{{ latestTime }}</text>
          </view>
          <text class="conversation-summary">{{ latestTitle }}</text>
        </view>
        <view class="new-session" @tap.stop="openAi(true)">新会话</view>
      </view>

      <view class="section-title">服务消息</view>
      <view class="conversation-card" @tap="openCustomerService">
        <view class="avatar service-avatar">
          <uni-icons type="headphones" size="24" color="#fff" />
        </view>
        <view class="conversation-main">
          <view class="conversation-head">
            <text class="conversation-name">商城客服</text>
          </view>
          <text class="conversation-summary">订单、售后问题可联系人工客服</text>
        </view>
        <uni-icons type="right" size="18" color="#b0b7c3" />
      </view>
    </view>
  </s-layout>
</template>

<script setup>
  import { computed, ref } from 'vue';
  import { onShow } from '@dcloudio/uni-app';
  import sheep from '@/sheep';
  import ChatApi from '@/sheep/api/ai/chat';

  const conversations = ref([]);
  const latestConversation = computed(() => conversations.value[0]);
  const latestTitle = computed(
    () => latestConversation.value?.title || '商品、订单和售后问题都可以问我',
  );
  const latestTime = computed(() => {
    const value = latestConversation.value?.updatedTime;
    return value ? String(value).slice(11, 16) : '';
  });

  const loadConversations = async () => {
    try {
      const response = await ChatApi.listConversations();
      const data = response?.data || response || {};
      conversations.value = data.items || [];
    } catch {
      conversations.value = [];
    }
  };

  const openAi = (newConversation = false) => {
    sheep.$router.go('/pages/ai/index', newConversation ? { newConversation: 1 } : {});
  };
  const openCustomerService = () => sheep.$router.go('/pages/chat/index');

  onShow(loadConversations);
</script>

<style lang="scss">
  .message-page {
    min-height: 100vh;
    padding: 24rpx;
    box-sizing: border-box;
    background: #f6f7f9;
  }
  .section-title {
    margin: 12rpx 8rpx 16rpx;
    color: #858b96;
    font-size: 24rpx;
  }
  .conversation-card {
    display: flex;
    align-items: center;
    min-height: 124rpx;
    margin-bottom: 18rpx;
    padding: 18rpx;
    border-radius: 16rpx;
    background: #fff;
  }
  .avatar {
    display: flex;
    width: 76rpx;
    height: 76rpx;
    align-items: center;
    justify-content: center;
    margin-right: 18rpx;
    border-radius: 50%;
    color: #fff;
    font-size: 25rpx;
    font-weight: 700;
  }
  .ai-avatar {
    background: #e94b35;
  }
  .service-avatar {
    background: #4a8ff7;
  }
  .conversation-main {
    display: flex;
    flex: 1;
    flex-direction: column;
    min-width: 0;
  }
  .conversation-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  .conversation-name {
    color: #252a32;
    font-size: 30rpx;
    font-weight: 600;
  }
  .conversation-time {
    color: #a4abb5;
    font-size: 22rpx;
  }
  .conversation-summary {
    overflow: hidden;
    margin-top: 10rpx;
    color: #858b96;
    font-size: 24rpx;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
  .new-session {
    margin-left: 16rpx;
    padding: 10rpx 14rpx;
    border-radius: 8rpx;
    background: #fff0ed;
    color: #e94b35;
    font-size: 22rpx;
  }
</style>
