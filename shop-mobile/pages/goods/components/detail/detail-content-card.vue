<template>
  <view class="detail-content-card bg-white ss-p-t-20">
    <view class="card-header ss-flex ss-col-center ss-m-b-30 ss-m-l-20">
      <view class="line"></view>
      <view class="title ss-m-l-20 ss-m-r-20">详情</view>
    </view>
    <view class="card-content">
      <mp-html :content="content" :tag-style="tagStyle" container-style="width:100%;"></mp-html>
    </view>
  </view>
</template>

<script setup>
  // 商品详情完全由管理台的富文本字段提供。样式通过 mp-html 的 tag-style
  // 注入，避免在小程序组件 WXSS 中使用不支持的标签选择器。
  const tagStyle = {
    img: 'display:block;width:100%;height:auto;margin:0;',
    h2: 'display:block;margin:0 20px 10px;font-size:20px;line-height:30px;font-weight:700;color:#202124;',
    h3: 'display:block;margin:20px 20px 8px;font-size:17px;line-height:26px;font-weight:700;color:#202124;',
    p: 'display:block;margin:0 20px 12px;font-size:15px;line-height:24px;color:#4b5563;',
    table:
      'display:table;width:calc(100% - 40px);margin:0 20px 20px;border-collapse:collapse;font-size:14px;line-height:22px;color:#4b5563;',
    td: 'padding:9px 10px;border:1px solid #e5e7eb;',
    section: 'display:block;width:100%;overflow:hidden;',
    div: 'display:block;box-sizing:border-box;max-width:100%;',
    span: 'max-width:100%;',
  };

  defineProps({
    content: {
      type: String,
      default: '',
    },
  });
</script>

<style lang="scss" scoped>
  .detail-content-card {
    overflow: hidden;

    .card-content {
      overflow: hidden;
      overflow-wrap: anywhere;
      word-break: break-word;
    }

    .card-header {
      .line {
        width: 6rpx;
        height: 30rpx;
        background: linear-gradient(180deg, var(--ui-BG-Main) 0%, var(--ui-BG-Main-gradient) 100%);
        border-radius: 3rpx;
      }

      .title {
        font-size: 30rpx;
        font-weight: bold;
      }
    }
  }
</style>
