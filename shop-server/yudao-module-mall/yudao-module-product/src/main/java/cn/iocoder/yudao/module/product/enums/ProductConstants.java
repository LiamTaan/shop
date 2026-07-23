package cn.iocoder.yudao.module.product.enums;

/**
 * Product 常量
 *
 * @author HUIHUI
 */
public interface ProductConstants {

    /** AI 商品搜索缓存，5 分钟；商品变更时主动清理。 */
    String AI_PRODUCT_SEARCH_CACHE = "ai:product-search#5m";

    /** AI 商品详情缓存，2 分钟；商品变更时主动清理。 */
    String AI_PRODUCT_DETAIL_CACHE = "ai:product-detail#2m";

    /** AI 运营低库存及简报缓存，1 分钟；库存变更时主动清理。 */
    String AI_OPS_LOW_STOCK_CACHE = "ai:ops-low-stock#1m";
    String AI_OPS_BRIEF_CACHE = "ai:ops-brief#1m";

    /** AI 运营热销、滞销商品缓存，5 分钟。 */
    String AI_OPS_HOT_PRODUCTS_CACHE = "ai:ops-hot-products#5m";
    String AI_OPS_SLOW_PRODUCTS_CACHE = "ai:ops-slow-products#5m";

    /**
     * 警戒库存 TODO 警戒库存暂时为 10，后期需要使用常量或者数据库配置替换
     */
    int ALERT_STOCK = 10;

}
