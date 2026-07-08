# 商城底座

这是一个面向商城项目的后端底座，基于 Spring Boot、MyBatis-Plus、MySQL、Redis 构建，保留商城上线所需的核心链路。

## 当前定位

- 管理后台接口：用户、角色、菜单、租户、基础设施、文件、字典、日志等基础能力。
- 商城业务接口：商品、营销、交易、订单、售后、会员、统计等商城能力。
- 支付链路：支付应用、支付渠道、支付订单、退款订单、回调通知等能力保留。
- 微信链路：微信公众号、微信小程序、微信登录/授权相关配置入口保留。
- IM 链路：IM 模块和 WebSocket 配置保留，默认单机发送，集群部署时再补消息发送配置。
- AI 模块：代码模块保留，默认不启用；模型密钥建议放到独立配置或环境变量中。

## 配置说明

主要配置文件位于：

- `yudao-server/src/main/resources/application.yaml`
- `yudao-server/src/main/resources/application-local.yaml`
- `yudao-server/src/main/resources/application-dev.yaml`
- `script/docker/docker-compose.yml`
- `script/docker/docker.env`

本仓库已清理演示域名、示例密钥、未启用模块的默认连接配置。上线前需要按实际环境补齐：

- MySQL / Redis 连接。
- 后端公网域名和管理端域名。
- 支付回调公网 HTTPS 地址。
- 微信公众号 AppId / Secret。
- 微信小程序 AppId / Secret。
- 支付渠道商户号、证书、私钥、回调验签配置。
- 文件存储、短信、地图、物流查询等第三方服务密钥。

## 本地启动

1. 准备 MySQL 和 Redis。
2. 导入项目数据库脚本。
3. 修改 `application-local.yaml` 中的数据库、Redis、微信、支付等本地配置。
4. 启动 `yudao-server` 模块。

默认本地端口：

- 后端服务：`48080`
- 管理端接口前缀：`/admin-api`
- 商城端接口前缀：`/app-api`
- WebSocket：`/infra/ws`

## Docker

Docker 编排文件位于 `script/docker`，当前只保留 MySQL、Redis、后端服务。管理端和商城端建议按实际部署方式单独构建并接入 Nginx。

## 上线检查

- 生产环境不要使用默认数据库密码。
- 生产环境必须配置 HTTPS 支付回调域名。
- 微信小程序发布前必须配置合法请求域名、业务域名和 AppId。
- API 加密默认关闭，如需开启，需要后端和前端同时配置密钥。
- AI 模块默认不启用，启用前应将密钥放入环境变量或独立配置文件。
- IM/WebSocket 默认单机发送，集群部署时需要切换发送器并补 Redis/MQ 配置。

