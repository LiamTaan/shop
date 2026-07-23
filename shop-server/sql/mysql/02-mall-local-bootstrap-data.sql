-- Local mall bootstrap data for tenant 1.
-- Import with docker cp + mysql --default-character-set=utf8mb4 to keep UTF-8 text intact.

SET NAMES utf8mb4;

SET @mall_image = '/static/mall-logo.png';
SET @mall_icon = '/static/mall-logo.png';
SET @tabbar_home_icon = '/static/img/shop/tabbar/tabbar_home.png';
SET @tabbar_home_active_icon = '/static/img/shop/tabbar/tabbar_home1.png';
SET @tabbar_category_icon = '/static/img/shop/tabbar/tabbar_category.png';
SET @tabbar_category_active_icon = '/static/img/shop/tabbar/tabbar_category1.png';
SET @tabbar_cart_icon = '/static/img/shop/tabbar/tabbar_cart.png';
SET @tabbar_cart_active_icon = '/static/img/shop/tabbar/tabbar_cart1.png';
SET @tabbar_user_icon = '/static/img/shop/tabbar/tabbar_personal.png';
SET @tabbar_user_active_icon = '/static/img/shop/tabbar/tabbar_personal1.png';
SET @carousel_image_1 = '/static/mall-logo.png';
SET @carousel_image_2 = '/static/img/shop/app/sign.png';
SET @menu_icon_all = '/static/img/shop/tabbar/tabbar_home1.png';
SET @menu_icon_life = '/static/img/shop/tabbar/tabbar_category1.png';
SET @menu_icon_digital = '/static/img/shop/tabbar/tabbar_cart1.png';

ALTER TABLE `promotion_diy_template`
  MODIFY COLUMN `property` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL;
ALTER TABLE `promotion_diy_page`
  MODIFY COLUMN `property` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL;
ALTER TABLE `product_spu`
  MODIFY COLUMN `description` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL;

UPDATE `system_tenant`
SET `name` = '商城底座',
    `contact_name` = '商城管理员',
    `websites` = '127.0.0.1:80,localhost:80,127.0.0.1:81,localhost:81,127.0.0.1:3000,localhost:3000',
    `updater` = 'local-bootstrap'
WHERE `id` = 1;

UPDATE `system_tenant`
SET `name` = '示例租户',
    `contact_name` = '示例管理员',
    `websites` = 'tenant.example.local',
    `updater` = 'local-bootstrap'
WHERE `id` = 121;

UPDATE `system_tenant`
SET `contact_name` = '测试管理员',
    `websites` = 'test.example.local',
    `updater` = 'local-bootstrap'
WHERE `id` = 122;

UPDATE `system_dept`
SET `name` = '商城底座',
    `updater` = 'local-bootstrap'
WHERE `id` = 100;

UPDATE `system_users`
SET `nickname` = '商城管理员',
    `avatar` = NULL,
    `updater` = 'local-bootstrap'
WHERE `id` = 1;

UPDATE `system_users`
SET `username` = 'operator',
    `nickname` = '运营人员',
    `email` = 'operator@example.local',
    `avatar` = NULL,
    `updater` = 'local-bootstrap'
WHERE `id` = 100;

UPDATE `system_users`
SET `username` = 'product',
    `nickname` = '商品人员',
    `email` = 'product@example.local',
    `avatar` = NULL,
    `updater` = 'local-bootstrap'
WHERE `id` = 103;

UPDATE `system_users`
SET `nickname` = '测试管理员',
    `avatar` = NULL,
    `updater` = 'local-bootstrap'
WHERE `id` = 113;

UPDATE `system_users`
SET `nickname` = CONCAT('租户管理员', `id`),
    `avatar` = NULL,
    `updater` = 'local-bootstrap'
WHERE `id` IN (107, 108, 109);

UPDATE `system_menu`
SET `name` = '已移除外链菜单',
    `path` = '',
    `deleted` = b'1',
    `visible` = b'0',
    `status` = 1,
    `updater` = 'local-bootstrap'
WHERE `id` IN (1254, 2159, 2160);

DROP TEMPORARY TABLE IF EXISTS `tmp_mall_base_disabled_menu_ids`;
CREATE TEMPORARY TABLE `tmp_mall_base_disabled_menu_ids` (`id` bigint NOT NULL PRIMARY KEY);

INSERT INTO `tmp_mall_base_disabled_menu_ids` (`id`)
WITH RECURSIVE `disabled_menu` AS (
  SELECT `id`
  FROM `system_menu`
  WHERE `id` IN (1185, 1281, 2084, 2397, 2563, 2758, 4000, 5100, 6400, 6500)
  UNION ALL
  SELECT `m`.`id`
  FROM `system_menu` `m`
  INNER JOIN `disabled_menu` `dm` ON `m`.`parent_id` = `dm`.`id`
)
SELECT `id` FROM `disabled_menu`;

UPDATE `system_menu`
SET `deleted` = b'1',
    `visible` = b'0',
    `status` = 1,
    `updater` = 'local-bootstrap'
WHERE `id` IN (SELECT `id` FROM `tmp_mall_base_disabled_menu_ids`);

DROP TEMPORARY TABLE IF EXISTS `tmp_mall_base_disabled_menu_ids`;

UPDATE `system_menu`
SET `name` = '商城 AI 助手',
    `permission` = '',
    `type` = 2,
    `sort` = 90,
    `parent_id` = 2362,
    `path` = 'ai-assistant',
    `icon` = 'ep:magic-stick',
    `component` = 'ai/chat/index/index.vue',
    `component_name` = 'AiChat',
    `status` = 0,
    `visible` = b'1',
    `keep_alive` = b'1',
    `always_show` = b'1',
    `updater` = 'local-bootstrap',
    `deleted` = b'0'
WHERE `id` = 2759;

UPDATE `system_notice`
SET `title` = '商城底座通知',
    `content` = '<p>本地商城底座已接入管理端、移动端和后端服务。</p>',
    `updater` = 'local-bootstrap'
WHERE `id` = 1;

UPDATE `system_notice`
SET `title` = '系统维护通知',
    `content` = '<p>本地环境维护窗口可按项目需要自行配置。</p>',
    `updater` = 'local-bootstrap'
WHERE `id` = 2;

UPDATE `system_oauth2_client`
SET `name` = '商城管理系统',
    `logo` = @mall_image,
    `description` = '本地商城底座默认客户端',
    `redirect_uris` = '["http://127.0.0.1:81","http://localhost:81"]',
    `updater` = 'local-bootstrap'
WHERE `id` = 1;

UPDATE `system_oauth2_client`
SET `deleted` = b'1',
    `updater` = 'local-bootstrap'
WHERE `id` IN (40, 41, 42);

INSERT INTO `pay_app`
  (`id`, `app_key`, `name`, `status`, `remark`, `order_notify_url`, `refund_notify_url`, `transfer_notify_url`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (90001, 'mall-local-pay', 'Mall Local Pay', 0, 'Local bootstrap pay app', 'http://127.0.0.1:48080/app-api/pay/notify/order', 'http://127.0.0.1:48080/app-api/pay/notify/refund', 'http://127.0.0.1:48080/app-api/pay/notify/transfer', 'local-bootstrap', 'local-bootstrap', b'0', 1)
ON DUPLICATE KEY UPDATE
  `app_key` = VALUES(`app_key`),
  `name` = VALUES(`name`),
  `status` = VALUES(`status`),
  `remark` = VALUES(`remark`),
  `order_notify_url` = VALUES(`order_notify_url`),
  `refund_notify_url` = VALUES(`refund_notify_url`),
  `transfer_notify_url` = VALUES(`transfer_notify_url`),
  `updater` = VALUES(`updater`),
  `deleted` = b'0',
  `tenant_id` = VALUES(`tenant_id`);

INSERT INTO `pay_channel`
  (`id`, `code`, `status`, `fee_rate`, `remark`, `app_id`, `config`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (90011, 'mock', 0, 0, 'Local mock payment channel', 90001, '{"@class":"cn.iocoder.yudao.module.pay.framework.pay.core.client.impl.NonePayClientConfig","name":"mock-conf"}', 'local-bootstrap', 'local-bootstrap', b'0', 1),
  (90012, 'wallet', 0, 0, 'Local wallet payment channel', 90001, '{"@class":"cn.iocoder.yudao.module.pay.framework.pay.core.client.impl.NonePayClientConfig","name":"wallet-conf"}', 'local-bootstrap', 'local-bootstrap', b'0', 1)
ON DUPLICATE KEY UPDATE
  `code` = VALUES(`code`),
  `status` = VALUES(`status`),
  `fee_rate` = VALUES(`fee_rate`),
  `remark` = VALUES(`remark`),
  `app_id` = VALUES(`app_id`),
  `config` = VALUES(`config`),
  `updater` = VALUES(`updater`),
  `deleted` = b'0',
  `tenant_id` = VALUES(`tenant_id`);

INSERT INTO `pay_wallet_recharge_package`
  (`id`, `name`, `pay_price`, `bonus_price`, `status`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (90021, 'Balance Top-up 50', 5000, 0, 0, 'local-bootstrap', 'local-bootstrap', b'0', 1),
  (90022, 'Balance Top-up 100', 10000, 1000, 0, 'local-bootstrap', 'local-bootstrap', b'0', 1)
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `pay_price` = VALUES(`pay_price`),
  `bonus_price` = VALUES(`bonus_price`),
  `status` = VALUES(`status`),
  `updater` = VALUES(`updater`),
  `deleted` = b'0',
  `tenant_id` = VALUES(`tenant_id`);

INSERT INTO `product_category`
  (`id`, `parent_id`, `name`, `pic_url`, `sort`, `status`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (1001, 0, '精选商城', @mall_image, 100, 0, 'local-bootstrap', 'local-bootstrap', b'0', 1),
  (1002, 1001, '生活好物', @mall_image, 100, 0, 'local-bootstrap', 'local-bootstrap', b'0', 1),
  (1003, 1001, '数码优选', @mall_image, 90, 0, 'local-bootstrap', 'local-bootstrap', b'0', 1)
ON DUPLICATE KEY UPDATE
  `parent_id` = VALUES(`parent_id`),
  `name` = VALUES(`name`),
  `pic_url` = VALUES(`pic_url`),
  `sort` = VALUES(`sort`),
  `status` = VALUES(`status`),
  `updater` = VALUES(`updater`),
  `deleted` = b'0',
  `tenant_id` = VALUES(`tenant_id`);

UPDATE `product_category`
SET `pic_url` = CASE `id`
    WHEN 1001 THEN @menu_icon_all
    WHEN 1002 THEN @menu_icon_life
    WHEN 1003 THEN @menu_icon_digital
    ELSE `pic_url`
  END,
  `updater` = 'local-bootstrap'
WHERE `id` IN (1001, 1002, 1003);

INSERT INTO `product_spu`
  (`id`, `name`, `keyword`, `introduction`, `description`, `category_id`, `brand_id`, `pic_url`, `slider_pic_urls`, `sort`, `status`, `spec_type`, `price`, `market_price`, `cost_price`, `stock`, `delivery_types`, `delivery_template_id`, `give_integral`, `sub_commission_type`, `sales_count`, `virtual_sales_count`, `browse_count`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (2001, '商城底座体验商品', '商城,底座,体验', '用于验证管理端、移动端、后端联调的上架商品', '<p>这是本地商城底座的第一件体验商品，可在管理端商品列表、移动端首页和商品详情中联动查看。</p>', 1002, NULL, @mall_image, JSON_ARRAY(@mall_image), 100, 1, b'0', 9900, 12900, 5900, 100, '1', NULL, 0, b'0', 0, 32, 0, 'local-bootstrap', 'local-bootstrap', b'0', 1),
  (2002, '移动端联调测试商品', '移动端,联调,测试', '用于验证移动端商品列表和详情页读取后端真实数据', '<p>这是本地商城底座的第二件体验商品，商品数据来自 MySQL，通过后端接口返回给移动端。</p>', 1003, NULL, @mall_image, JSON_ARRAY(@mall_image), 90, 1, b'0', 19900, 25900, 12900, 80, '1', NULL, 0, b'0', 0, 18, 0, 'local-bootstrap', 'local-bootstrap', b'0', 1)
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `keyword` = VALUES(`keyword`),
  `introduction` = VALUES(`introduction`),
  `description` = VALUES(`description`),
  `category_id` = VALUES(`category_id`),
  `brand_id` = VALUES(`brand_id`),
  `pic_url` = VALUES(`pic_url`),
  `slider_pic_urls` = VALUES(`slider_pic_urls`),
  `sort` = VALUES(`sort`),
  `status` = VALUES(`status`),
  `spec_type` = VALUES(`spec_type`),
  `price` = VALUES(`price`),
  `market_price` = VALUES(`market_price`),
  `cost_price` = VALUES(`cost_price`),
  `stock` = VALUES(`stock`),
  `delivery_types` = VALUES(`delivery_types`),
  `delivery_template_id` = VALUES(`delivery_template_id`),
  `give_integral` = VALUES(`give_integral`),
  `sub_commission_type` = VALUES(`sub_commission_type`),
  `sales_count` = VALUES(`sales_count`),
  `virtual_sales_count` = VALUES(`virtual_sales_count`),
  `browse_count` = VALUES(`browse_count`),
  `updater` = VALUES(`updater`),
  `deleted` = b'0',
  `tenant_id` = VALUES(`tenant_id`);

INSERT INTO `product_sku`
  (`id`, `spu_id`, `properties`, `price`, `market_price`, `cost_price`, `bar_code`, `pic_url`, `stock`, `weight`, `volume`, `first_brokerage_price`, `second_brokerage_price`, `sales_count`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (3001, 2001, '[]', 9900, 12900, 5900, 'LOCAL-SPU-2001', @mall_image, 100, 0.5, 0.01, 0, 0, 0, 'local-bootstrap', 'local-bootstrap', b'0', 1),
  (3002, 2002, '[]', 19900, 25900, 12900, 'LOCAL-SPU-2002', @mall_image, 80, 0.8, 0.02, 0, 0, 0, 'local-bootstrap', 'local-bootstrap', b'0', 1)
ON DUPLICATE KEY UPDATE
  `spu_id` = VALUES(`spu_id`),
  `properties` = VALUES(`properties`),
  `price` = VALUES(`price`),
  `market_price` = VALUES(`market_price`),
  `cost_price` = VALUES(`cost_price`),
  `bar_code` = VALUES(`bar_code`),
  `pic_url` = VALUES(`pic_url`),
  `stock` = VALUES(`stock`),
  `weight` = VALUES(`weight`),
  `volume` = VALUES(`volume`),
  `first_brokerage_price` = VALUES(`first_brokerage_price`),
  `second_brokerage_price` = VALUES(`second_brokerage_price`),
  `sales_count` = VALUES(`sales_count`),
  `updater` = VALUES(`updater`),
  `deleted` = b'0',
  `tenant_id` = VALUES(`tenant_id`);

SET @template_property = CONCAT('{"tabBar":{"theme":"orange","style":{"bgType":"color","bgColor":"#fff","bgImg":"","color":"#282828","activeColor":"#fc4141"},"items":[{"text":"首页","url":"/pages/index/index","iconUrl":"', @mall_icon, '","activeIconUrl":"', @mall_icon, '"},{"text":"分类","url":"/pages/index/category?id=1001","iconUrl":"', @mall_icon, '","activeIconUrl":"', @mall_icon, '"},{"text":"购物车","url":"/pages/index/cart","iconUrl":"', @mall_icon, '","activeIconUrl":"', @mall_icon, '"},{"text":"我的","url":"/pages/index/user","iconUrl":"', @mall_icon, '","activeIconUrl":"', @mall_icon, '"}]}}');
SET @nav_cell = '{"type":"text","width":4,"height":35,"top":0,"left":2,"text":"商城","textColor":"#111111","imgUrl":"","url":"","backgroundColor":"","placeholder":"","placeholderPosition":"left","showScan":false,"borderRadius":0}';
SET @home_property = CONCAT('{"page":{"description":"","backgroundColor":"#f5f5f5","backgroundImage":""},"navigationBar":{"bgType":"color","bgColor":"#fff","bgImg":"","styleType":"normal","showType":"always","alwaysShow":true,"mpCells":[', @nav_cell, '],"otherCells":[', @nav_cell, '],"_local":{"previewMp":true,"previewOther":false}},"components":[{"id":"SearchBar","name":"搜索框","property":{"height":32,"showScan":false,"borderRadius":16,"placeholder":"搜索商品","placeholderPosition":"left","backgroundColor":"rgb(238,238,238)","textColor":"rgb(120,120,120)","hotKeywords":["底座","联调"],"style":{"bgType":"color","bgColor":"#fff","marginBottom":8,"paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8}}},{"id":"Carousel","name":"轮播图","property":{"type":"default","indicator":"dot","autoplay":true,"interval":3,"height":174,"items":[{"type":"img","imgUrl":"', @mall_icon, '","videoUrl":"","url":"/pages/goods/list"},{"type":"img","imgUrl":"', @mall_icon, '","videoUrl":"","url":"/pages/goods/list"}],"style":{"bgType":"color","bgColor":"#fff","marginBottom":8}}},{"id":"MenuGrid","name":"宫格导航","property":{"column":3,"space":0,"list":[{"iconUrl":"', @mall_icon, '","title":"全部商品","titleColor":"#333","subtitle":"现货上架","subtitleColor":"#999","url":"/pages/goods/list","badge":{"show":false,"text":"","textColor":"#fff","bgColor":"#FF6000"}},{"iconUrl":"', @mall_icon, '","title":"生活好物","titleColor":"#333","subtitle":"精选分类","subtitleColor":"#999","url":"/pages/goods/list?categoryId=1002","badge":{"show":false,"text":"","textColor":"#fff","bgColor":"#FF6000"}},{"iconUrl":"', @mall_icon, '","title":"数码优选","titleColor":"#333","subtitle":"新品推荐","subtitleColor":"#999","url":"/pages/goods/list?categoryId=1003","badge":{"show":false,"text":"","textColor":"#fff","bgColor":"#FF6000"}}],"style":{"bgType":"color","bgColor":"#fff","marginBottom":8,"marginLeft":8,"marginRight":8,"paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"borderTopLeftRadius":8,"borderTopRightRadius":8,"borderBottomRightRadius":8,"borderBottomLeftRadius":8}}},{"id":"TitleBar","name":"标题栏","property":{"bgImgUrl":"","marginLeft":0,"textAlign":"left","title":"精选商品","description":"管理端修改商品后，移动端会读取同一份后端数据","titleSize":16,"descriptionSize":12,"titleWeight":600,"descriptionWeight":200,"titleColor":"rgba(50,50,51,1)","descriptionColor":"rgba(150,151,153,1)","height":44,"more":{"show":true,"type":"all","text":"查看更多","url":"/pages/goods/list"},"style":{"bgType":"color","bgColor":"#fff","marginLeft":8,"marginRight":8,"marginBottom":8}}},{"id":"ProductList","name":"商品栏","property":{"layoutType":"twoCol","fields":{"name":{"show":true,"color":"#000"},"price":{"show":true,"color":"#ff3000"}},"badge":{"show":false,"imgUrl":""},"borderRadiusTop":8,"borderRadiusBottom":8,"space":8,"spuIds":[2001,2002],"style":{"bgType":"color","bgColor":"","marginLeft":8,"marginRight":8,"marginBottom":8}}}]}');
SET @user_property = CONCAT('{"page":{"description":"","backgroundColor":"#f5f5f5","backgroundImage":""},"navigationBar":{"bgType":"color","bgColor":"#fff","bgImg":"","styleType":"normal","showType":"always","alwaysShow":true,"mpCells":[', @nav_cell, '],"otherCells":[', @nav_cell, '],"_local":{"previewMp":true,"previewOther":false}},"components":[{"id":"UserCard","name":"用户卡片","property":{"space":0,"style":{"bgType":"color","bgColor":"#fff","marginBottom":8}}},{"id":"UserOrder","name":"用户订单","property":{"space":0,"style":{"bgType":"color","bgColor":"#fff","marginLeft":8,"marginRight":8,"marginBottom":8}}}]}');

SET @template_property = CONCAT('{"tabBar":{"theme":"orange","style":{"bgType":"color","bgColor":"#fff","bgImg":"","color":"#282828","activeColor":"#fc4141"},"items":[{"text":"首页","url":"/pages/index/index","iconUrl":"', @tabbar_home_icon, '","activeIconUrl":"', @tabbar_home_active_icon, '"},{"text":"分类","url":"/pages/index/category?id=1001","iconUrl":"', @tabbar_category_icon, '","activeIconUrl":"', @tabbar_category_active_icon, '"},{"text":"购物车","url":"/pages/index/cart","iconUrl":"', @tabbar_cart_icon, '","activeIconUrl":"', @tabbar_cart_active_icon, '"},{"text":"我的","url":"/pages/index/user","iconUrl":"', @tabbar_user_icon, '","activeIconUrl":"', @tabbar_user_active_icon, '"}]}}');
SET @nav_cell = '{"type":"text","width":4,"height":35,"top":0,"left":2,"text":"商城","textColor":"#111111","imgUrl":"","url":"","backgroundColor":"","placeholder":"","placeholderPosition":"left","showScan":false,"borderRadius":0}';
SET @home_property = CONCAT('{"page":{"description":"","backgroundColor":"#f5f5f5","backgroundImage":""},"navigationBar":{"bgType":"color","bgColor":"#fff","bgImg":"","styleType":"normal","showType":"always","alwaysShow":true,"mpCells":[', @nav_cell, '],"otherCells":[', @nav_cell, '],"_local":{"previewMp":true,"previewOther":false}},"components":[{"id":"SearchBar","name":"搜索框","property":{"height":32,"showScan":false,"borderRadius":16,"placeholder":"搜索商品","placeholderPosition":"left","backgroundColor":"rgb(238,238,238)","textColor":"rgb(120,120,120)","hotKeywords":["底座","联调"],"style":{"bgType":"color","bgColor":"#fff","marginBottom":8,"paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8}}},{"id":"Carousel","name":"轮播图","property":{"type":"default","indicator":"dot","autoplay":true,"interval":3,"height":174,"items":[{"type":"img","imgUrl":"', @carousel_image_1, '","videoUrl":"","url":"/pages/goods/list"},{"type":"img","imgUrl":"', @carousel_image_2, '","videoUrl":"","url":"/pages/goods/list"}],"style":{"bgType":"color","bgColor":"#fff","marginBottom":8}}},{"id":"MenuGrid","name":"宫格导航","property":{"column":3,"space":0,"list":[{"categoryId":1001,"iconUrl":"', @menu_icon_all, '","title":"全部商品","titleColor":"#333","subtitle":"现货上架","subtitleColor":"#999","url":"/pages/goods/list","badge":{"show":false,"text":"","textColor":"#fff","bgColor":"#FF6000"}},{"categoryId":1002,"iconUrl":"', @menu_icon_life, '","title":"生活好物","titleColor":"#333","subtitle":"精选分类","subtitleColor":"#999","url":"/pages/goods/list?categoryId=1002","badge":{"show":false,"text":"","textColor":"#fff","bgColor":"#FF6000"}},{"categoryId":1003,"iconUrl":"', @menu_icon_digital, '","title":"数码优选","titleColor":"#333","subtitle":"新品推荐","subtitleColor":"#999","url":"/pages/goods/list?categoryId=1003","badge":{"show":false,"text":"","textColor":"#fff","bgColor":"#FF6000"}}],"style":{"bgType":"color","bgColor":"#fff","marginBottom":8,"marginLeft":8,"marginRight":8,"paddingTop":8,"paddingRight":8,"paddingBottom":8,"paddingLeft":8,"borderTopLeftRadius":8,"borderTopRightRadius":8,"borderBottomRightRadius":8,"borderBottomLeftRadius":8}}},{"id":"TitleBar","name":"标题栏","property":{"bgImgUrl":"","marginLeft":0,"textAlign":"left","title":"精选商品","description":"管理端修改商品后，移动端会读取同一份后端数据","titleSize":16,"descriptionSize":12,"titleWeight":600,"descriptionWeight":200,"titleColor":"rgba(50,50,51,1)","descriptionColor":"rgba(150,151,153,1)","height":44,"more":{"show":true,"type":"all","text":"查看更多","url":"/pages/goods/list"},"style":{"bgType":"color","bgColor":"#fff","marginLeft":8,"marginRight":8,"marginBottom":8}}},{"id":"ProductList","name":"商品栏","property":{"layoutType":"twoCol","fields":{"name":{"show":true,"color":"#000"},"price":{"show":true,"color":"#ff3000"}},"badge":{"show":false,"imgUrl":""},"borderRadiusTop":8,"borderRadiusBottom":8,"space":8,"spuIds":[2001,2002],"style":{"bgType":"color","bgColor":"","marginLeft":8,"marginRight":8,"marginBottom":8}}}]}');

UPDATE `promotion_diy_template`
SET `used` = b'0',
    `updater` = 'local-bootstrap'
WHERE `tenant_id` = 1 AND `id` <> 1001;

INSERT INTO `promotion_diy_template`
  (`id`, `name`, `used`, `used_time`, `remark`, `preview_pic_urls`, `property`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (1001, '本地商城默认模板', b'1', NOW(), '本地联调默认模板', '', @template_property, 'local-bootstrap', 'local-bootstrap', b'0', 1)
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `used` = b'1',
  `used_time` = NOW(),
  `remark` = VALUES(`remark`),
  `preview_pic_urls` = VALUES(`preview_pic_urls`),
  `property` = VALUES(`property`),
  `updater` = VALUES(`updater`),
  `deleted` = b'0',
  `tenant_id` = VALUES(`tenant_id`);

INSERT INTO `promotion_diy_page`
  (`id`, `template_id`, `name`, `remark`, `preview_pic_urls`, `property`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (100101, 1001, '首页', '本地联调首页', '', @home_property, 'local-bootstrap', 'local-bootstrap', b'0', 1),
  (100102, 1001, '我的', '本地联调我的页', '', @user_property, 'local-bootstrap', 'local-bootstrap', b'0', 1)
ON DUPLICATE KEY UPDATE
  `template_id` = VALUES(`template_id`),
  `name` = VALUES(`name`),
  `remark` = VALUES(`remark`),
  `preview_pic_urls` = VALUES(`preview_pic_urls`),
  `property` = VALUES(`property`),
  `updater` = VALUES(`updater`),
  `deleted` = b'0',
  `tenant_id` = VALUES(`tenant_id`);
