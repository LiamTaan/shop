<template>
  <el-alert v-if="getEnable()" type="success" show-icon>
    <template #title>
      <div>{{ '【' + title + '】功能说明已由项目文档统一维护' }}</div>
    </template>
  </el-alert>
</template>
<script setup lang="tsx">
import { propTypes } from '@/utils/propTypes'

defineOptions({ name: 'DocAlert' })

const props = defineProps({
  title: propTypes.string,
  url: propTypes.string
})

/** 是否开启 */
const getEnable = () => {
  return import.meta.env.VITE_APP_DOCALERT_ENABLE === 'true' && !!props.title
}
</script>
<style scoped>
.el-alert--success.is-light {
  margin-bottom: 10px;
  border: 1px solid green;
}
</style>
