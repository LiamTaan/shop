# 商城移动端

商城用户端前端项目，基于 uni-app 和 Vue 3 构建，可发布为 H5、微信小程序及 App（Android/iOS）。项目默认对接本仓库的 `shop-server` 服务。

## 技术栈

- uni-app（Vue 3）
- Vite
- Pinia 与 `pinia-plugin-persist-uni`
- luch-request
- Sass

> 项目源码当前以 JavaScript 为主，不使用 TypeScript。

## 运行要求

- Node.js（建议使用当前 LTS 版本）
- pnpm
- 微信小程序开发工具（仅运行或发布微信小程序时需要）
- HBuilderX（仅运行或打包 App 时需要）

## 安装与启动

在本目录执行：

```bash
pnpm install
```

启动 H5 开发服务：

```bash
pnpm dev:h5
```

启动微信小程序开发编译：

```bash
pnpm dev:mp-weixin
```

启动 App 开发编译：

```bash
pnpm dev:app
```

开发服务端口由 `.env` 中的 `SHOPRO_DEV_PORT` 控制，默认是 `3000`。H5 开发服务启动后，访问 `http://localhost:3000`。

## 构建

```bash
# 构建 H5
pnpm build:h5

# 构建微信小程序，并同步小程序静态资源
pnpm build:mp-weixin

# 构建 App 资源
pnpm build:app
```

构建产物位于 `dist/build`；微信小程序产物需使用微信开发者工具导入后进行预览、上传和发布。App 的证书、包名、支付及分享配置请在 HBuilderX 和 `manifest.json` 中完成。

## 后端对接配置

接口和运行环境配置位于 `.env`：

| 变量 | 说明 | 当前默认值 |
| --- | --- | --- |
| `SHOPRO_DEV_BASE_URL` | 开发环境后端地址 | `http://127.0.0.1:48080` |
| `SHOPRO_BASE_URL` | 生产环境后端地址 | 空，发布前必须设置 |
| `SHOPRO_USE_DEV_BASE_URL` | 是否强制使用开发后端地址 | `true` |
| `SHOPRO_API_PATH` | 用户端接口前缀 | `/app-api` |
| `SHOPRO_WEBSOCKET_PATH` | WebSocket 接口前缀 | `/infra/ws` |
| `SHOPRO_STATIC_URL` | 静态资源地址，`local` 表示本地资源 | `local` |
| `SHOPRO_H5_URL` | H5 访问地址 | `http://127.0.0.1:3000` |
| `SHOPRO_TENANT_ID` | 默认租户编号 | `1` |

请求地址由 `SHOPRO_DEV_BASE_URL` 或 `SHOPRO_BASE_URL` 与 `SHOPRO_API_PATH` 拼接。例如默认开发接口地址为 `http://127.0.0.1:48080/app-api`。配置生效逻辑见 `sheep/config/index.js`。

小程序和 App 访问后端时，请使用可访问的 HTTPS 域名，不能使用 `127.0.0.1`；同时将接口域名配置到微信小程序后台的合法域名列表中。

## 功能范围

- 首页装修、商品分类、搜索、商品详情和购物车
- 普通商品、拼团、秒杀、积分商品及优惠券
- 下单、支付、订单、物流和售后
- 会员资料、收货地址、收藏、足迹、余额、积分和签到
- 分销、佣金、提现和推广数据
- 在线客服与 AI 导购

具体可用功能取决于后端开关、租户配置和支付/第三方服务配置。

## 目录结构

```text
pages/              业务页面及分包页面
sheep/api/          按业务模块划分的接口封装
sheep/components/   业务通用组件
sheep/ui/           UI 组件
sheep/store/        Pinia 状态管理
sheep/request/      请求客户端、拦截器和令牌刷新
sheep/config/       环境变量读取与运行配置
sheep/platform/     H5、小程序、App 平台适配
static/             静态资源
uni_modules/        uni-app 扩展模块
scripts/            构建辅助脚本
```

## 平台发布注意事项

- 微信小程序：在 `manifest.json` 填写正确的 `appid`，并配置业务域名、隐私协议及所需接口权限。
- H5：生产环境设置 `SHOPRO_BASE_URL`、`SHOPRO_H5_URL` 和静态资源地址；服务器需要对 history 路由做回退处理。
- App：在 `manifest.json` 配置应用标识、图标、签名、OAuth、支付和分享参数，并按平台要求补充隐私权限说明。

## 常用命令

```bash
# 格式化页面和 sheep 目录中的前端文件
pnpm prettier
```
