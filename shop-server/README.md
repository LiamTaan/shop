# 商城后端服务

这是当前工作区的后端主服务，面向商城业务提供管理端、用户端和基础设施能力。

## 模块定位

- 系统能力：用户、角色、菜单、租户、字典、日志、文件、消息等基础模块
- 商城能力：商品、分类、SKU、营销、购物车、订单、售后、会员、支付等业务模块
- 对外能力：管理后台接口、移动端接口、WebSocket、文件服务

## 目录说明

- `yudao-server`：后端启动入口
- `yudao-module-system`：系统管理模块
- `yudao-module-member`：会员模块
- `yudao-module-mall`：商城核心模块
- `yudao-module-pay`：支付模块
- `yudao-module-infra`：基础设施模块
- `script`：部署、Docker、辅助脚本
- `sql`：数据库脚本

## 配置文件

主要配置位于：

- `yudao-server/src/main/resources/application.yaml`
- `yudao-server/src/main/resources/application-local.yaml`
- `yudao-server/src/main/resources/application-dev.yaml`

按实际环境重点检查：

- MySQL / Redis 连接
- 文件存储配置
- 短信、邮件、地图等第三方配置
- 微信公众号 / 小程序配置
- 支付渠道与回调地址

## 本地启动

1. 准备 MySQL、Redis。
2. 导入 `sql/mysql` 下所需脚本。
3. 修改本地环境配置。
4. 启动 `yudao-server`。

默认约定：

- 后端端口：`48080`
- 管理端接口前缀：`/admin-api`
- 用户端接口前缀：`/app-api`
- WebSocket：`/infra/ws`

## 部署说明

- `script/docker` 中提供基础 Docker 编排文件
- 生产环境请替换所有示例配置、默认口令和测试密钥
- 多实例部署前请补齐缓存、消息发送和回调域名配置

## 备注

当前目录作为商城后端主服务使用，文档说明以当前项目结构为准。
