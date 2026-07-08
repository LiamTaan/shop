# 商城管理后台

这是商城项目的管理端前端，负责运营、商品、订单、会员、营销、权限和系统配置等后台能力。

## 技术栈

- Vue 3
- Vite
- TypeScript
- Element Plus
- Pinia
- Vue Router

## 运行要求

- Node.js `>= 16.18`
- pnpm `>= 8`

## 启动方式

```bash
pnpm install
pnpm dev
```

常用命令：

```bash
pnpm build
pnpm preview
pnpm lint
```

## 主要能力

- 管理员登录、权限控制、动态菜单
- 商品、分类、品牌、库存、订单、售后管理
- 会员、优惠券、积分、营销活动管理
- 支付配置、消息通知、文件上传、系统配置

## 对接说明

- 默认对接后端管理接口前缀：`/admin-api`
- 联调前请检查 `.env`、`.env.development` 等环境变量
- 如后端地址变更，请同步更新代理和构建配置

## 目录提示

- `src/views`：页面
- `src/api`：接口封装
- `src/components`：通用组件
- `src/router`：路由
- `src/store`：状态管理

## 备注

当前目录名称沿用历史结构，页面和接口说明以当前商城项目为准。
