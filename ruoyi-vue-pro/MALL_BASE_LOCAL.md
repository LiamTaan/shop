# 本地商城底座说明

这个工作区的目标是作为后续商城项目的基础底座：后端、管理端、移动端都连接同一个本地后端和同一套 MySQL 数据，管理端菜单和商城数据必须来自真实接口。

## 项目路径

- 后端：`D:\user\work_space_shop\ruoyi-vue-pro`
- 管理端：`D:\user\work_space_shop\yudao-ui-admin-vue3`
- 移动端：`D:\user\work_space_shop\yudao-ui-mall-uniapp`

## 本地端口

- 后端：`http://127.0.0.1:48080`
- 管理端：`http://localhost:81`
- 移动端 H5：`http://localhost:3000/?tenantId=1`
- MySQL：`127.0.0.1:3306`
- Redis：`127.0.0.1:6379`
- RocketMQ Namesrv：`127.0.0.1:19876`

## 本地账号

- 管理端：`admin / admin123`
- 移动端会员：`15600000000 / admin123`
- 租户：`1`

## 一键验收

在后端目录运行：

```powershell
cd D:\user\work_space_shop\ruoyi-vue-pro
node scripts\check-mall-base.js
```

这个脚本会检查：

- MySQL、Redis、RocketMQ、后端、管理端、移动端端口是否可达。
- Docker MySQL 容器和 `ruoyi-vue-pro` 数据库是否正常。
- `member`、`pay`、`product`、`promotion`、`trade`、`statistics` 相关表是否具备 `tenant_id`。
- 商品、分类、DIY 首页、DIY 模板等本地种子数据是否存在，且关键中文字段没有乱码。
- 管理端登录、商品分类、商品列表、DIY 模板接口是否正常。
- 管理端菜单 `2362` 是否是真实动态菜单：脚本会临时修改 `/mall` 路径，调用权限接口确认变更，然后自动恢复。
- 移动端 DIY 首页、分类、商品列表、商品详情、会员登录接口是否正常。

可通过环境变量覆盖本地配置：

```powershell
$env:MALL_BASE_MYSQL_PASSWORD='123456'
$env:MALL_BASE_BACKEND_URL='http://127.0.0.1:48080'
$env:MALL_BASE_ADMIN_URL='http://127.0.0.1:81'
$env:MALL_BASE_MOBILE_URL='http://127.0.0.1:3000'
node scripts\check-mall-base.js
```

## 启动命令

后端：

```powershell
cd D:\user\work_space_shop\ruoyi-vue-pro
mvn -pl yudao-server -am -DskipTests package
```

管理端：

```powershell
cd D:\user\work_space_shop\yudao-ui-admin-vue3
pnpm install
pnpm dev
```

移动端 H5：

```powershell
cd D:\user\work_space_shop\yudao-ui-mall-uniapp
pnpm install
pnpm dev:h5
```

## 构建验收

后端：

```powershell
cd D:\user\work_space_shop\ruoyi-vue-pro
mvn -pl yudao-server -am -DskipTests package
```

管理端：

```powershell
cd D:\user\work_space_shop\yudao-ui-admin-vue3
pnpm build:local
```

移动端 H5：

```powershell
cd D:\user\work_space_shop\yudao-ui-mall-uniapp
pnpm build:h5
```

## 数据初始化

商城相关表结构由当前后端 DO 生成：

```powershell
cd D:\user\work_space_shop\ruoyi-vue-pro
node scripts\generate-mall-schema.js
```

本地商城种子数据在：

```text
D:\user\work_space_shop\ruoyi-vue-pro\sql\mysql\mall-bootstrap\02-mall-local-bootstrap-data.sql
```

导入含中文的 SQL 时必须走 UTF-8 文件，不要在 PowerShell、cmd 或 Git Bash 中用 `echo`、here-string、管道内联中文 SQL。

推荐导入方式：

```powershell
docker cp D:\user\work_space_shop\ruoyi-vue-pro\sql\mysql\mall-bootstrap\02-mall-local-bootstrap-data.sql rural-helper-mysql:/tmp/02-mall-local-bootstrap-data.sql
docker exec -e MYSQL_PWD=123456 rural-helper-mysql sh -c "mysql --default-character-set=utf8mb4 -uroot ruoyi-vue-pro < /tmp/02-mall-local-bootstrap-data.sql"
```

## 关键联调点

- 管理端 `.env.local` 指向 `http://localhost:48080/admin-api`。
- 移动端 `.env` 指向 `http://127.0.0.1:48080/app-api`，租户为 `1`。
- 租户 `1` 的 `system_tenant.websites` 包含 `127.0.0.1:3000,localhost:3000`。
- 商城根菜单 `system_menu.id = 2362`，默认路径应为 `/mall`。
- 本地默认 DIY 模板 `promotion_diy_template.id = 1001`，首页页面 `promotion_diy_page.id = 100101`。
- 本地体验商品 `product_spu.id = 2001, 2002`，移动端首页和管理端商品列表读取的是同一份后端数据。
