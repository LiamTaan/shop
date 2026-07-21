-- Fake Store API demo catalog seed for tenant 1.
-- Source: https://fakestoreapi.com/products
-- Prices are converted with 1 USD = 7.2 CNY for local UI testing only.
-- Import through a UTF-8 file path; do not pipe non-ASCII SQL through a Windows shell.

SET NAMES utf8mb4;
START TRANSACTION;

INSERT INTO `product_category`
  (`id`, `parent_id`, `name`, `pic_url`, `sort`, `status`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (11000, 0, '演示商品库', 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png', 200, 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (11001, 11000, '数码家电', 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_t.png', 190, 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (11002, 11000, '珠宝配饰', 'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_t.png', 180, 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (11003, 11000, '男装服饰', 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png', 170, 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (11004, 11000, '女装服饰', 'https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_t.png', 160, 0, 'fakestore-seed', 'fakestore-seed', b'0', 1)
ON DUPLICATE KEY UPDATE
  `parent_id` = VALUES(`parent_id`),
  `name` = VALUES(`name`),
  `pic_url` = VALUES(`pic_url`),
  `sort` = VALUES(`sort`),
  `status` = VALUES(`status`),
  `creator` = VALUES(`creator`),
  `updater` = VALUES(`updater`),
  `deleted` = VALUES(`deleted`),
  `tenant_id` = VALUES(`tenant_id`);

INSERT INTO `product_brand`
  (`id`, `name`, `pic_url`, `sort`, `description`, `status`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (12001, 'Acer', 'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_t.png', 200, 'Acer 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。', 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (12002, 'BIYLACLESEN', 'https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_t.png', 199, 'BIYLACLESEN 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。', 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (12003, 'Fjallraven', 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png', 198, 'Fjallraven 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。', 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (12004, 'John Hardy', 'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_t.png', 197, 'John Hardy 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。', 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (12005, 'Lock and Love', 'https://fakestoreapi.com/img/81XH0e8fefL._AC_UY879_t.png', 196, 'Lock and Love 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。', 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (12006, 'Samsung', 'https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_t.png', 195, 'Samsung 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。', 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (12007, 'SanDisk', 'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_t.png', 194, 'SanDisk 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。', 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (12008, 'Silicon Power', 'https://fakestoreapi.com/img/71kWymZ+c+L._AC_SX679_t.png', 193, 'Silicon Power 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。', 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (12009, 'WD', 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_t.png', 192, 'WD 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。', 0, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (12010, '商城严选', 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_t.png', 191, '商城严选 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。', 0, 'fakestore-seed', 'fakestore-seed', b'0', 1)
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `pic_url` = VALUES(`pic_url`),
  `sort` = VALUES(`sort`),
  `description` = VALUES(`description`),
  `status` = VALUES(`status`),
  `creator` = VALUES(`creator`),
  `updater` = VALUES(`updater`),
  `deleted` = VALUES(`deleted`),
  `tenant_id` = VALUES(`tenant_id`);

INSERT INTO `product_spu`
  (`id`, `name`, `keyword`, `introduction`, `description`, `category_id`, `brand_id`, `pic_url`, `slider_pic_urls`, `sort`, `status`, `spec_type`, `price`, `market_price`, `cost_price`, `stock`, `delivery_types`, `delivery_template_id`, `give_integral`, `sub_commission_type`, `sales_count`, `virtual_sales_count`, `browse_count`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (20001, 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops', '男装服饰,演示商品,Fake Store API', '男装服饰演示商品，评分 3.9，仅用于商城功能联调。', '<p>Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday</p><p><strong>商品分类：</strong>男装服饰</p><p><strong>演示评分：</strong>3.9 / 5（120 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11003, 12003, 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png', '["https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png"]', 200, 1, b'0', 79164, 94997, 49082, 120, '1', NULL, 791, b'0', 48, 120, 600, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20002, 'Mens Casual Premium Slim Fit T-Shirts', '男装服饰,演示商品,Fake Store API', '男装服饰演示商品，评分 4.1，仅用于商城功能联调。', '<p>Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight &amp; soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.</p><p><strong>商品分类：</strong>男装服饰</p><p><strong>演示评分：</strong>4.1 / 5（259 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11003, 12010, 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_t.png', '["https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_t.png"]', 199, 1, b'0', 16056, 19267, 9955, 259, '1', NULL, 160, b'0', 103, 259, 1295, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20003, 'Mens Cotton Jacket', '男装服饰,演示商品,Fake Store API', '男装服饰演示商品，评分 4.7，仅用于商城功能联调。', '<p>great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions, such as working, hiking, camping, mountain/rock climbing, cycling, traveling or other outdoors. Good gift choice for you or your family member. A warm hearted love to Father, husband or son in this thanksgiving or Christmas Day.</p><p><strong>商品分类：</strong>男装服饰</p><p><strong>演示评分：</strong>4.7 / 5（500 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11003, 12010, 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_t.png', '["https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_t.png"]', 198, 1, b'0', 40313, 48376, 24994, 500, '1', NULL, 403, b'0', 200, 500, 2500, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20004, 'Mens Casual Slim Fit', '男装服饰,演示商品,Fake Store API', '男装服饰演示商品，评分 2.1，仅用于商城功能联调。', '<p>The color could be slightly different between on the screen and in practice. / Please note that body builds vary by person, therefore, detailed size information should be reviewed below on the product description.</p><p><strong>商品分类：</strong>男装服饰</p><p><strong>演示评分：</strong>2.1 / 5（430 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11003, 12010, 'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_t.png', '["https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_t.png"]', 197, 1, b'0', 11513, 13816, 7138, 430, '1', NULL, 115, b'0', 172, 430, 2150, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20005, 'John Hardy Women''s Legends Naga Gold & Silver Dragon Station Chain Bracelet', '珠宝配饰,演示商品,Fake Store API', '珠宝配饰演示商品，评分 4.6，仅用于商城功能联调。', '<p>From our Legends Collection, the Naga was inspired by the mythical water dragon that protects the ocean&#39;s pearl. Wear facing inward to be bestowed with love and abundance, or outward for protection.</p><p><strong>商品分类：</strong>珠宝配饰</p><p><strong>演示评分：</strong>4.6 / 5（400 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11002, 12004, 'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_t.png', '["https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_t.png"]', 196, 1, b'0', 500400, 600480, 310248, 400, '1', NULL, 5004, b'0', 160, 400, 2000, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20006, 'Solid Gold Petite Micropave', '珠宝配饰,演示商品,Fake Store API', '珠宝配饰演示商品，评分 3.9，仅用于商城功能联调。', '<p>Satisfaction Guaranteed. Return or exchange any order within 30 days.Designed and sold by Hafeez Center in the United States. Satisfaction Guaranteed. Return or exchange any order within 30 days.</p><p><strong>商品分类：</strong>珠宝配饰</p><p><strong>演示评分：</strong>3.9 / 5（70 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11002, 12010, 'https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_t.png', '["https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_t.png"]', 195, 1, b'0', 120960, 145152, 74995, 70, '1', NULL, 1209, b'0', 28, 70, 350, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20007, 'White Gold Plated Princess', '珠宝配饰,演示商品,Fake Store API', '珠宝配饰演示商品，评分 3.0，仅用于商城功能联调。', '<p>Classic Created Wedding Engagement Solitaire Diamond Promise Ring for Her. Gifts to spoil your love more for Engagement, Wedding, Anniversary, Valentine&#39;s Day...</p><p><strong>商品分类：</strong>珠宝配饰</p><p><strong>演示评分：</strong>3.0 / 5（400 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11002, 12010, 'https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_t.png', '["https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_t.png"]', 194, 1, b'0', 7193, 8632, 4460, 400, '1', NULL, 71, b'0', 160, 400, 2000, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20008, 'Pierced Owl Rose Gold Plated Stainless Steel Double', '珠宝配饰,演示商品,Fake Store API', '珠宝配饰演示商品，评分 1.9，仅用于商城功能联调。', '<p>Rose Gold Plated Double Flared Tunnel Plug Earrings. Made of 316L Stainless Steel</p><p><strong>商品分类：</strong>珠宝配饰</p><p><strong>演示评分：</strong>1.9 / 5（100 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11002, 12010, 'https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_t.png', '["https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_t.png"]', 193, 1, b'0', 7913, 9496, 4906, 100, '1', NULL, 79, b'0', 40, 100, 500, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20009, 'WD 2TB Elements Portable External Hard Drive - USB 3.0', '数码家电,演示商品,Fake Store API', '数码家电演示商品，评分 3.3，仅用于商城功能联调。', '<p>USB 3.0 and USB 2.0 Compatibility Fast data transfers Improve PC Performance High Capacity; Compatibility Formatted NTFS for Windows 10, Windows 8.1, Windows 7; Reformatting may be required for other operating systems; Compatibility may vary depending on user’s hardware configuration and operating system</p><p><strong>商品分类：</strong>数码家电</p><p><strong>演示评分：</strong>3.3 / 5（203 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11001, 12009, 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_t.png', '["https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_t.png"]', 192, 1, b'0', 46080, 55296, 28570, 203, '1', NULL, 460, b'0', 81, 203, 1015, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20010, 'SanDisk SSD PLUS 1TB Internal SSD - SATA III 6 Gb/s', '数码家电,演示商品,Fake Store API', '数码家电演示商品，评分 2.9，仅用于商城功能联调。', '<p>Easy upgrade for faster boot up, shutdown, application load and response (As compared to 5400 RPM SATA 2.5” hard drive; Based on published specifications and internal benchmarking tests using PCMark vantage scores) Boosts burst write performance, making it ideal for typical PC workloads The perfect balance of performance and reliability Read/write speeds of up to 535MB/s/450MB/s (Based on internal testing; Performance may vary depending upon drive capacity, host device, OS and application.)</p><p><strong>商品分类：</strong>数码家电</p><p><strong>演示评分：</strong>2.9 / 5（470 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11001, 12007, 'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_t.png', '["https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_t.png"]', 191, 1, b'0', 78480, 94176, 48658, 470, '1', NULL, 784, b'0', 188, 470, 2350, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20011, 'Silicon Power 256GB SSD 3D NAND A55 SLC Cache Performance Boost SATA III 2.5', '数码家电,演示商品,Fake Store API', '数码家电演示商品，评分 4.8，仅用于商城功能联调。', '<p>3D NAND flash are applied to deliver high transfer speeds Remarkable transfer speeds that enable faster bootup and improved overall system performance. The advanced SLC Cache Technology allows performance boost and longer lifespan 7mm slim design suitable for Ultrabooks and Ultra-slim notebooks. Supports TRIM command, Garbage Collection technology, RAID, and ECC (Error Checking &amp; Correction) to provide the optimized performance and enhanced reliability.</p><p><strong>商品分类：</strong>数码家电</p><p><strong>演示评分：</strong>4.8 / 5（319 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11001, 12008, 'https://fakestoreapi.com/img/71kWymZ+c+L._AC_SX679_t.png', '["https://fakestoreapi.com/img/71kWymZ+c+L._AC_SX679_t.png"]', 190, 1, b'0', 78480, 94176, 48658, 319, '1', NULL, 784, b'0', 127, 319, 1595, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20012, 'WD 4TB Gaming Drive Works with Playstation 4 Portable External Hard Drive', '数码家电,演示商品,Fake Store API', '数码家电演示商品，评分 4.8，仅用于商城功能联调。', '<p>Expand your PS4 gaming experience, Play anywhere Fast and easy, setup Sleek design with high capacity, 3-year manufacturer&#39;s limited warranty</p><p><strong>商品分类：</strong>数码家电</p><p><strong>演示评分：</strong>4.8 / 5（400 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11001, 12009, 'https://fakestoreapi.com/img/61mtL65D4cL._AC_SX679_t.png', '["https://fakestoreapi.com/img/61mtL65D4cL._AC_SX679_t.png"]', 189, 1, b'0', 82080, 98496, 50890, 400, '1', NULL, 820, b'0', 160, 400, 2000, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20013, 'Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin', '数码家电,演示商品,Fake Store API', '数码家电演示商品，评分 2.9，仅用于商城功能联调。', '<p>21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz</p><p><strong>商品分类：</strong>数码家电</p><p><strong>演示评分：</strong>2.9 / 5（250 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11001, 12001, 'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_t.png', '["https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_t.png"]', 188, 1, b'0', 431280, 517536, 267394, 250, '1', NULL, 4312, b'0', 100, 250, 1250, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20014, 'Samsung 49-Inch CHG90 144Hz Curved Gaming Monitor (LC49HG90DMNXZA) – Super Ultrawide Screen QLED', '数码家电,演示商品,Fake Store API', '数码家电演示商品，评分 2.2，仅用于商城功能联调。', '<p>49 INCH SUPER ULTRAWIDE 32:9 CURVED GAMING MONITOR with dual 27 inch screen side by side QUANTUM DOT (QLED) TECHNOLOGY, HDR support and factory calibration provides stunningly realistic and accurate color and contrast 144HZ HIGH REFRESH RATE and 1ms ultra fast response time work to eliminate motion blur, ghosting, and reduce input lag</p><p><strong>商品分类：</strong>数码家电</p><p><strong>演示评分：</strong>2.2 / 5（140 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11001, 12006, 'https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_t.png', '["https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_t.png"]', 187, 1, b'0', 719993, 863992, 446396, 140, '1', NULL, 7199, b'0', 56, 140, 700, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20015, 'BIYLACLESEN Women''s 3-in-1 Snowboard Jacket Winter Coats', '女装服饰,演示商品,Fake Store API', '女装服饰演示商品，评分 2.6，仅用于商城功能联调。', '<p>Note:The Jackets is US standard size, Please choose size as your usual wear Material: 100% Polyester; Detachable Liner Fabric: Warm Fleece. Detachable Functional Liner: Skin Friendly, Lightweigt and Warm.Stand Collar Liner jacket, keep you warm in cold weather. Zippered Pockets: 2 Zippered Hand Pockets, 2 Zippered Pockets on Chest (enough to keep cards or keys)and 1 Hidden Pocket Inside.Zippered Hand Pockets and Hidden Pocket keep your things secure. Humanized Design: Adjustable and Detachable Hood and Adjustable cuff to prevent the wind and water,for a comfortable fit. 3 in 1 Detachable Design provide more convenience, you can separate the coat and inner as needed, or wear it together. It is suitable for different season and help you adapt to different climates</p><p><strong>商品分类：</strong>女装服饰</p><p><strong>演示评分：</strong>2.6 / 5（235 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11004, 12002, 'https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_t.png', '["https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_t.png"]', 186, 1, b'0', 41033, 49240, 25440, 235, '1', NULL, 410, b'0', 94, 235, 1175, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20016, 'Lock and Love Women''s Removable Hooded Faux Leather Moto Biker Jacket', '女装服饰,演示商品,Fake Store API', '女装服饰演示商品，评分 2.9，仅用于商城功能联调。', '<p>100% POLYURETHANE(shell) 100% POLYESTER(lining) 75% POLYESTER 25% COTTON (SWEATER), Faux leather material for style and comfort / 2 pockets of front, 2-For-One Hooded denim style faux leather jacket, Button detail on waist / Detail stitching at sides, HAND WASH ONLY / DO NOT BLEACH / LINE DRY / DO NOT IRON</p><p><strong>商品分类：</strong>女装服饰</p><p><strong>演示评分：</strong>2.9 / 5（340 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11004, 12005, 'https://fakestoreapi.com/img/81XH0e8fefL._AC_UY879_t.png', '["https://fakestoreapi.com/img/81XH0e8fefL._AC_UY879_t.png"]', 185, 1, b'0', 21564, 25877, 13370, 340, '1', NULL, 215, b'0', 136, 340, 1700, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20017, 'Rain Jacket Women Windbreaker Striped Climbing Raincoats', '女装服饰,演示商品,Fake Store API', '女装服饰演示商品，评分 3.8，仅用于商城功能联调。', '<p>Lightweight perfet for trip or casual wear---Long sleeve with hooded, adjustable drawstring waist design. Button and zipper front closure raincoat, fully stripes Lined and The Raincoat has 2 side pockets are a good size to hold all kinds of things, it covers the hips, and the hood is generous but doesn&#39;t overdo it.Attached Cotton Lined Hood with Adjustable Drawstrings give it a real styled look.</p><p><strong>商品分类：</strong>女装服饰</p><p><strong>演示评分：</strong>3.8 / 5（679 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11004, 12010, 'https://fakestoreapi.com/img/71HblAHs5xL._AC_UY879_-2t.png', '["https://fakestoreapi.com/img/71HblAHs5xL._AC_UY879_-2t.png"]', 184, 1, b'0', 28793, 34552, 17852, 500, '1', NULL, 287, b'0', 271, 679, 3395, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20018, 'MBJ Women''s Solid Short Sleeve Boat Neck V', '女装服饰,演示商品,Fake Store API', '女装服饰演示商品，评分 4.7，仅用于商城功能联调。', '<p>95% RAYON 5% SPANDEX, Made in USA or Imported, Do Not Bleach, Lightweight fabric with great stretch for comfort, Ribbed on sleeves and neckline / Double stitching on bottom hem</p><p><strong>商品分类：</strong>女装服饰</p><p><strong>演示评分：</strong>4.7 / 5（130 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11004, 12010, 'https://fakestoreapi.com/img/71z3kpMAYsL._AC_UY879_t.png', '["https://fakestoreapi.com/img/71z3kpMAYsL._AC_UY879_t.png"]', 183, 1, b'0', 7092, 8510, 4397, 130, '1', NULL, 70, b'0', 52, 130, 650, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20019, 'Opna Women''s Short Sleeve Moisture', '女装服饰,演示商品,Fake Store API', '女装服饰演示商品，评分 4.5，仅用于商城功能联调。', '<p>100% Polyester, Machine wash, 100% cationic polyester interlock, Machine Wash &amp; Pre Shrunk for a Great Fit, Lightweight, roomy and highly breathable with moisture wicking fabric which helps to keep moisture away, Soft Lightweight Fabric with comfortable V-neck collar and a slimmer fit, delivers a sleek, more feminine silhouette and Added Comfort</p><p><strong>商品分类：</strong>女装服饰</p><p><strong>演示评分：</strong>4.5 / 5（146 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11004, 12010, 'https://fakestoreapi.com/img/51eg55uWmdL._AC_UX679_t.png', '["https://fakestoreapi.com/img/51eg55uWmdL._AC_UX679_t.png"]', 182, 1, b'0', 5724, 6869, 3549, 146, '1', NULL, 57, b'0', 58, 146, 730, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (20020, 'DANVOUY Womens T Shirt Casual Cotton Short', '女装服饰,演示商品,Fake Store API', '女装服饰演示商品，评分 3.6，仅用于商城功能联调。', '<p>95%Cotton,5%Spandex, Features: Casual, Short Sleeve, Letter Print,V-Neck,Fashion Tees, The fabric is soft and has some stretch., Occasion: Casual/Office/Beach/School/Home/Street. Season: Spring,Summer,Autumn,Winter.</p><p><strong>商品分类：</strong>女装服饰</p><p><strong>演示评分：</strong>3.6 / 5（145 条样本）</p><p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>', 11004, 12010, 'https://fakestoreapi.com/img/61pHAEJ4NML._AC_UX679_t.png', '["https://fakestoreapi.com/img/61pHAEJ4NML._AC_UX679_t.png"]', 181, 1, b'0', 9353, 11224, 5799, 145, '1', NULL, 93, b'0', 58, 145, 725, 'fakestore-seed', 'fakestore-seed', b'0', 1)
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
  `creator` = VALUES(`creator`),
  `updater` = VALUES(`updater`),
  `deleted` = VALUES(`deleted`),
  `tenant_id` = VALUES(`tenant_id`);

INSERT INTO `product_sku`
  (`id`, `spu_id`, `properties`, `price`, `market_price`, `cost_price`, `bar_code`, `pic_url`, `stock`, `weight`, `volume`, `first_brokerage_price`, `second_brokerage_price`, `sales_count`, `creator`, `updater`, `deleted`, `tenant_id`)
VALUES
  (30001, 20001, '[]', 79164, 94997, 49082, 'FAKESTORE-0001', 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png', 120, 0.5, 0.01, 0, 0, 48, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30002, 20002, '[]', 16056, 19267, 9955, 'FAKESTORE-0002', 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_t.png', 259, 0.5, 0.01, 0, 0, 103, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30003, 20003, '[]', 40313, 48376, 24994, 'FAKESTORE-0003', 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_t.png', 500, 0.5, 0.01, 0, 0, 200, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30004, 20004, '[]', 11513, 13816, 7138, 'FAKESTORE-0004', 'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_t.png', 430, 0.5, 0.01, 0, 0, 172, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30005, 20005, '[]', 500400, 600480, 310248, 'FAKESTORE-0005', 'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_t.png', 400, 0.5, 0.01, 0, 0, 160, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30006, 20006, '[]', 120960, 145152, 74995, 'FAKESTORE-0006', 'https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_t.png', 70, 0.5, 0.01, 0, 0, 28, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30007, 20007, '[]', 7193, 8632, 4460, 'FAKESTORE-0007', 'https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_t.png', 400, 0.5, 0.01, 0, 0, 160, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30008, 20008, '[]', 7913, 9496, 4906, 'FAKESTORE-0008', 'https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_t.png', 100, 0.5, 0.01, 0, 0, 40, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30009, 20009, '[]', 46080, 55296, 28570, 'FAKESTORE-0009', 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_t.png', 203, 0.5, 0.01, 0, 0, 81, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30010, 20010, '[]', 78480, 94176, 48658, 'FAKESTORE-0010', 'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_t.png', 470, 0.5, 0.01, 0, 0, 188, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30011, 20011, '[]', 78480, 94176, 48658, 'FAKESTORE-0011', 'https://fakestoreapi.com/img/71kWymZ+c+L._AC_SX679_t.png', 319, 0.5, 0.01, 0, 0, 127, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30012, 20012, '[]', 82080, 98496, 50890, 'FAKESTORE-0012', 'https://fakestoreapi.com/img/61mtL65D4cL._AC_SX679_t.png', 400, 0.5, 0.01, 0, 0, 160, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30013, 20013, '[]', 431280, 517536, 267394, 'FAKESTORE-0013', 'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_t.png', 250, 0.5, 0.01, 0, 0, 100, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30014, 20014, '[]', 719993, 863992, 446396, 'FAKESTORE-0014', 'https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_t.png', 140, 0.5, 0.01, 0, 0, 56, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30015, 20015, '[]', 41033, 49240, 25440, 'FAKESTORE-0015', 'https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_t.png', 235, 0.5, 0.01, 0, 0, 94, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30016, 20016, '[]', 21564, 25877, 13370, 'FAKESTORE-0016', 'https://fakestoreapi.com/img/81XH0e8fefL._AC_UY879_t.png', 340, 0.5, 0.01, 0, 0, 136, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30017, 20017, '[]', 28793, 34552, 17852, 'FAKESTORE-0017', 'https://fakestoreapi.com/img/71HblAHs5xL._AC_UY879_-2t.png', 500, 0.5, 0.01, 0, 0, 271, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30018, 20018, '[]', 7092, 8510, 4397, 'FAKESTORE-0018', 'https://fakestoreapi.com/img/71z3kpMAYsL._AC_UY879_t.png', 130, 0.5, 0.01, 0, 0, 52, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30019, 20019, '[]', 5724, 6869, 3549, 'FAKESTORE-0019', 'https://fakestoreapi.com/img/51eg55uWmdL._AC_UX679_t.png', 146, 0.5, 0.01, 0, 0, 58, 'fakestore-seed', 'fakestore-seed', b'0', 1),
  (30020, 20020, '[]', 9353, 11224, 5799, 'FAKESTORE-0020', 'https://fakestoreapi.com/img/61pHAEJ4NML._AC_UX679_t.png', 145, 0.5, 0.01, 0, 0, 58, 'fakestore-seed', 'fakestore-seed', b'0', 1)
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
  `creator` = VALUES(`creator`),
  `updater` = VALUES(`updater`),
  `deleted` = VALUES(`deleted`),
  `tenant_id` = VALUES(`tenant_id`);

UPDATE `promotion_diy_page`
SET `property` = JSON_SET(`property`, '$.components[4].property.spuIds', JSON_ARRAY(20001, 20002, 20003, 20004, 20005, 20006, 20007, 20008)),
    `updater` = 'fakestore-seed'
WHERE `id` = 100101
  AND `tenant_id` = 1
  AND `deleted` = b'0'
  AND JSON_VALID(`property`) = 1
  AND JSON_UNQUOTE(JSON_EXTRACT(`property`, '$.components[4].id')) = 'ProductList';

COMMIT;
