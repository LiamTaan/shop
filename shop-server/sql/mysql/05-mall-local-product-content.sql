-- 本地商城商品内容修复：商品 20001
-- 使用 UTF-8 文件导入；不要通过 Windows shell 管道传输本文件中的中文内容。

SET NAMES utf8mb4;
START TRANSACTION;

CREATE TABLE IF NOT EXISTS `product_spu_content_backup` LIKE `product_spu`;
INSERT IGNORE INTO `product_spu_content_backup`
SELECT * FROM `product_spu` WHERE `id` = 20001 AND `tenant_id` = 1;

INSERT INTO `product_category`
  (`id`, `parent_id`, `name`, `pic_url`, `sort`, `status`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (11005, 11000, '箱包配饰', 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png', 150, 0, 'local-product-content', 'local-product-content', b'0', 1)
ON DUPLICATE KEY UPDATE
  `parent_id` = VALUES(`parent_id`),
  `name` = VALUES(`name`),
  `pic_url` = VALUES(`pic_url`),
  `sort` = VALUES(`sort`),
  `status` = VALUES(`status`),
  `updater` = VALUES(`updater`),
  `deleted` = VALUES(`deleted`);

INSERT INTO `product_brand`
  (`id`, `name`, `pic_url`, `sort`, `description`, `status`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (12011, '行迹', 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png', 190, '行迹通勤系列，专注轻量收纳与日常出行体验。', 0, 'local-product-content', 'local-product-content', b'0', 1)
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `pic_url` = VALUES(`pic_url`),
  `sort` = VALUES(`sort`),
  `description` = VALUES(`description`),
  `status` = VALUES(`status`),
  `updater` = VALUES(`updater`),
  `deleted` = VALUES(`deleted`);

UPDATE `product_spu`
SET
  `name` = '轻量通勤双肩包',
  `pic_url` = 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png',
  `keyword` = '通勤双肩包,电脑包,轻量背包,日常出行',
  `introduction` = '可容纳 15.6 英寸笔记本电脑，分区收纳设计，适合通勤、短途出行与日常使用。',
  `description` = '<p><img src="https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png" alt="轻量通勤双肩包" style="display:block;width:100%;height:auto;" /></p><h2>轻量通勤双肩包</h2><p>为通勤、上学和短途出行设计的日常收纳背包。大开口主仓搭配多分区设计，让电脑、文件和随身物品各得其所。</p><h3>一包收纳，一身轻松</h3><p>独立电脑隔层、前置快取袋与多处分区口袋，日常携带电脑、文件、水杯和小物无需翻找。</p><h3>01｜15.6 英寸电脑隔层</h3><p>主仓内置独立电脑隔层，可放置 15.6 英寸及以下笔记本电脑；加厚缓冲设计，为日常通勤多一层安心。</p><h3>02｜多分区有序收纳</h3><p>内置文件袋、充电设备收纳位与随身小物口袋；前置拉链袋方便快速取用交通卡、钥匙和耳机。</p><h3>03｜轻盈舒适背负</h3><p>加宽肩带搭配透气背垫，减轻长时间背负压力；双向拉链开合顺滑，拿取物品更方便。</p><h3>商品参数</h3><table border="1" cellspacing="0" cellpadding="8"><tbody><tr><td>适用场景</td><td>日常通勤、上学、短途出行</td></tr><tr><td>电脑隔层</td><td>适配 15.6 英寸及以下笔记本电脑</td></tr><tr><td>收纳建议</td><td>电脑、文件、水杯与日常随身物品</td></tr><tr><td>开合方式</td><td>双向拉链</td></tr></tbody></table><h3>使用与护理</h3><p>请避免长时间浸泡或暴晒；日常污渍可用湿布轻擦，自然阴干即可。颜色以实物为准，手工测量可能存在轻微误差。</p>',
  `category_id` = 11005,
  `brand_id` = 12011,
  `updater` = 'local-product-content'
WHERE `id` = 20001 AND `tenant_id` = 1;

COMMIT;
