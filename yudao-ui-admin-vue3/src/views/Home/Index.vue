<template>
  <div>
    <el-card shadow="never">
      <el-skeleton :loading="loading" animated>
        <el-row :gutter="16" justify="space-between">
          <el-col :xl="12" :lg="12" :md="12" :sm="24" :xs="24">
            <div class="flex items-center">
              <el-avatar :src="avatar" :size="70" class="mr-16px">
                <img src="@/assets/imgs/avatar.gif" alt="" />
              </el-avatar>
              <div>
                <div class="text-20px">
                  {{ t('workplace.welcome') }} {{ username }} {{ t('workplace.happyDay') }}
                </div>
                <div class="mt-10px text-14px text-gray-500">
                  商城底座已就绪，管理端、移动端与后端共用本地联调服务。
                </div>
              </div>
            </div>
          </el-col>
          <el-col :xl="12" :lg="12" :md="12" :sm="24" :xs="24">
            <div class="h-70px flex items-center justify-end lt-sm:mt-10px">
              <div class="px-8px text-right">
                <div class="mb-16px text-14px text-gray-400">{{ t('workplace.project') }}</div>
                <CountTo
                  class="text-20px"
                  :start-val="0"
                  :end-val="totalSate.project"
                  :duration="2600"
                />
              </div>
              <el-divider direction="vertical" />
              <div class="px-8px text-right">
                <div class="mb-16px text-14px text-gray-400">{{ t('workplace.toDo') }}</div>
                <CountTo
                  class="text-20px"
                  :start-val="0"
                  :end-val="totalSate.todo"
                  :duration="2600"
                />
              </div>
              <el-divider direction="vertical" border-style="dashed" />
              <div class="px-8px text-right">
                <div class="mb-16px text-14px text-gray-400">{{ t('workplace.access') }}</div>
                <CountTo
                  class="text-20px"
                  :start-val="0"
                  :end-val="totalSate.access"
                  :duration="2600"
                />
              </div>
            </div>
          </el-col>
        </el-row>
      </el-skeleton>
    </el-card>
  </div>

  <el-row class="mt-8px" :gutter="8" justify="space-between">
    <el-col :xl="16" :lg="16" :md="24" :sm="24" :xs="24" class="mb-8px">
      <el-card shadow="never">
        <template #header>
          <div class="h-3 flex justify-between">
            <span>{{ t('workplace.project') }}</span>
          </div>
        </template>
        <el-skeleton :loading="loading" animated>
          <el-row :gutter="8" class="gap-y-8px">
            <el-col
              v-for="(item, index) in projects"
              :key="`card-${index}`"
              :xl="8"
              :lg="8"
              :md="8"
              :sm="24"
              :xs="24"
              class="!flex"
            >
              <el-card
                shadow="hover"
                class="flex-1 cursor-pointer"
                body-class="flex h-full flex-col"
                @click="handleProjectClick(item.url)"
              >
                <div class="flex items-center">
                  <Icon
                    :icon="item.icon"
                    :size="25"
                    class="mr-8px flex-none"
                    :style="{ color: item.color }"
                  />
                  <span class="min-w-0 line-clamp-2 text-16px" :title="item.name">{{
                    item.name
                  }}</span>
                </div>
                <div
                  class="mt-12px break-all line-clamp-2 text-12px text-gray-400"
                  :title="item.message"
                >
                  {{ item.message }}
                </div>
                <div
                  class="mt-auto flex items-center justify-between gap-8px pt-12px text-12px text-gray-400"
                >
                  <span class="min-w-0 truncate" :title="item.personal">{{ item.personal }}</span>
                  <span class="shrink-0 whitespace-nowrap">
                    {{ formatTime(item.time, 'yyyy-MM-dd') }}
                  </span>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </el-skeleton>
      </el-card>

      <el-card shadow="never" class="mt-8px">
        <el-skeleton :loading="loading" animated>
          <el-row :gutter="20" justify="space-between">
            <el-col :xl="10" :lg="10" :md="24" :sm="24" :xs="24">
              <el-card shadow="hover" class="mb-8px">
                <el-skeleton :loading="loading" animated>
                  <Echart :options="pieOptionsData" :height="280" />
                </el-skeleton>
              </el-card>
            </el-col>
            <el-col :xl="14" :lg="14" :md="24" :sm="24" :xs="24">
              <el-card shadow="hover" class="mb-8px">
                <el-skeleton :loading="loading" animated>
                  <Echart :options="barOptionsData" :height="280" />
                </el-skeleton>
              </el-card>
            </el-col>
          </el-row>
        </el-skeleton>
      </el-card>
    </el-col>
    <el-col :xl="8" :lg="8" :md="24" :sm="24" :xs="24" class="mb-8px">
      <el-card shadow="never">
        <template #header>
          <div class="h-3 flex justify-between">
            <span>{{ t('workplace.shortcutOperation') }}</span>
          </div>
        </template>
        <el-skeleton :loading="loading" animated>
          <el-row>
            <el-col v-for="item in shortcut" :key="`team-${item.name}`" :span="8" class="mb-8px">
              <div class="flex items-center">
                <Icon :icon="item.icon" class="mr-8px" :style="{ color: item.color }" />
                <el-link type="default" :underline="false" @click="handleShortcutClick(item.url)">
                  {{ item.name }}
                </el-link>
              </div>
            </el-col>
          </el-row>
        </el-skeleton>
      </el-card>
      <el-card shadow="never" class="mt-8px">
        <template #header>
          <div class="h-3 flex justify-between">
            <span>{{ t('workplace.notice') }}</span>
            <el-link type="primary" :underline="false">{{ t('action.more') }}</el-link>
          </div>
        </template>
        <el-skeleton :loading="loading" animated>
          <div v-for="(item, index) in notice" :key="`dynamics-${index}`">
            <div class="flex items-center">
              <el-avatar :src="avatar" :size="35" class="mr-16px">
                <img src="@/assets/imgs/avatar.gif" alt="" />
              </el-avatar>
              <div>
                <div class="text-14px">
                  <Highlight :keys="item.keys.map((v) => t(v))">
                    {{ item.type }} : {{ item.title }}
                  </Highlight>
                </div>
                <div class="mt-16px text-12px text-gray-400">
                  {{ formatTime(item.date, 'yyyy-MM-dd') }}
                </div>
              </div>
            </div>
            <el-divider />
          </div>
        </el-skeleton>
      </el-card>
    </el-col>
  </el-row>
</template>
<script lang="ts" setup>
import { set } from 'lodash-es'
import { EChartsOption } from 'echarts'
import { formatTime } from '@/utils'

import { useUserStore } from '@/store/modules/user'
// import { useWatermark } from '@/hooks/web/useWatermark'
import type { WorkplaceTotal, Project, Notice, Shortcut } from './types'
import { pieOptions, barOptions } from './echarts-data'
import { useRouter } from 'vue-router'

defineOptions({ name: 'Index' })

const { t } = useI18n()
const router = useRouter()
const userStore = useUserStore()
// const { setWatermark } = useWatermark()
const loading = ref(true)
const avatar = userStore.getUser.avatar
const username = userStore.getUser.nickname
const pieOptionsData = reactive<EChartsOption>(pieOptions) as EChartsOption
// 获取统计数
let totalSate = reactive<WorkplaceTotal>({
  project: 0,
  access: 0,
  todo: 0
})

const getCount = async () => {
  const data = {
    project: 6,
    access: 2340,
    todo: 10
  }
  totalSate = Object.assign(totalSate, data)
}

// 获取项目数
let projects = reactive<Project[]>([])
const getProject = async () => {
  const data = [
    {
      name: '商品中心',
      icon: 'icon-park-outline:commodity',
      message: '分类、品牌、属性、SPU/SKU 已接入统一商品服务。',
      personal: '商品基础',
      url: '/mall/product/spu',
      time: new Date('2025-01-02'),
      color: '#6DB33F'
    },
    {
      name: '交易订单',
      icon: 'ep:goods',
      message: '订单、售后、配送与交易配置使用同一套后端接口。',
      personal: '交易履约',
      url: '/mall/trade/order',
      time: new Date('2025-02-03'),
      color: '#409EFF'
    },
    {
      name: '会员运营',
      icon: 'ep:user-filled',
      message: '会员、等级、标签、积分与签到能力可直接复用。',
      personal: '会员增长',
      url: '/member/user',
      time: new Date('2025-03-04'),
      color: '#ff4d4f'
    },
    {
      name: '营销活动',
      icon: 'ep:present',
      message: '优惠券、秒杀、拼团、砍价、分销等营销模块已接入。',
      personal: '促销工具',
      url: '/mall/promotion/coupon',
      time: new Date('2025-04-05'),
      color: '#1890ff'
    },
    {
      name: '页面装修',
      icon: 'ep:brush',
      message: '移动端首页、底部导航、公告栏和专题页面可在线配置。',
      personal: '移动装修',
      url: '/mall/promotion/diy/template',
      time: new Date('2025-05-06'),
      color: '#e18525'
    },
    {
      name: '数据看板',
      icon: 'ep:data-analysis',
      message: '商品、会员、交易统计菜单与商城服务保持联动。',
      personal: '经营分析',
      url: '/mall/statistics/trade',
      time: new Date('2025-06-01'),
      color: '#2979ff'
    }
  ]
  projects = Object.assign(projects, data)
}

// 获取通知公告
let notice = reactive<Notice[]>([])
const getNotice = async () => {
  const data = [
    {
      title: '管理端菜单、后端权限与商城接口保持同源联动',
      type: '底座联调',
      keys: ['管理端', '后端'],
      date: new Date()
    },
    {
      title: '移动端读取同一套商品、会员、装修与交易接口',
      type: '移动端',
      keys: ['商品', '装修'],
      date: new Date()
    },
    {
      title: '本地 MySQL、Redis、MQ 可支撑后续商城项目快速复用',
      type: '本地环境',
      keys: ['MySQL', 'Redis'],
      date: new Date()
    },
    {
      title: '商品、订单、会员、营销是当前底座的核心验收链路',
      type: '验收重点',
      keys: ['订单', '会员'],
      date: new Date()
    }
  ]
  notice = Object.assign(notice, data)
}

// 获取快捷入口
let shortcut = reactive<Shortcut[]>([])

const getShortcut = async () => {
  const data = [
    {
      name: '工作台',
      icon: 'ion:home-outline',
      url: '/',
      color: '#1fdaca'
    },
    {
      name: '商城首页',
      icon: 'ep:shop',
      url: '/mall/home',
      color: '#ff6b6b'
    },
    {
      name: '商品管理',
      icon: 'ep:goods',
      url: '/mall/product/spu',
      color: '#409eff'
    },
    {
      name: '订单管理',
      icon: 'ep:tickets',
      url: '/mall/trade/order',
      color: '#e6a23c'
    },
    {
      name: '会员管理',
      icon: 'ep:user',
      url: '/member/user',
      color: '#67c23a'
    },
    {
      name: '页面装修',
      icon: 'ep:brush',
      url: '/mall/promotion/diy/template',
      color: '#f56c6c'
    }
  ]
  shortcut = Object.assign(shortcut, data)
}

// 用户来源
const getUserAccessSource = async () => {
  const data = [
    { value: 335, name: 'analysis.directAccess' },
    { value: 310, name: 'analysis.mailMarketing' },
    { value: 234, name: 'analysis.allianceAdvertising' },
    { value: 135, name: 'analysis.videoAdvertising' },
    { value: 1548, name: 'analysis.searchEngines' }
  ]
  set(
    pieOptionsData,
    'legend.data',
    data.map((v) => t(v.name))
  )
  pieOptionsData!.series![0].data = data.map((v) => {
    return {
      name: t(v.name),
      value: v.value
    }
  })
}
const barOptionsData = reactive<EChartsOption>(barOptions) as EChartsOption

// 周活跃量
const getWeeklyUserActivity = async () => {
  const data = [
    { value: 13253, name: 'analysis.monday' },
    { value: 34235, name: 'analysis.tuesday' },
    { value: 26321, name: 'analysis.wednesday' },
    { value: 12340, name: 'analysis.thursday' },
    { value: 24643, name: 'analysis.friday' },
    { value: 1322, name: 'analysis.saturday' },
    { value: 1324, name: 'analysis.sunday' }
  ]
  set(
    barOptionsData,
    'xAxis.data',
    data.map((v) => t(v.name))
  )
  set(barOptionsData, 'series', [
    {
      name: t('analysis.activeQuantity'),
      data: data.map((v) => v.value),
      type: 'bar'
    }
  ])
}

const getAllApi = async () => {
  await Promise.all([
    getCount(),
    getProject(),
    getNotice(),
    getShortcut(),
    getUserAccessSource(),
    getWeeklyUserActivity()
  ])
  loading.value = false
}

const handleProjectClick = (url: string) => {
  router.push(url)
}

const handleShortcutClick = (url: string) => {
  router.push(url)
}

getAllApi()
</script>
