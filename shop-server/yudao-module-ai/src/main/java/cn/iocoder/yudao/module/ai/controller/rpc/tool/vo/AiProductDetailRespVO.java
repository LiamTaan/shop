package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;

@Data
@Accessors(chain = true)
public class AiProductDetailRespVO {

    private Long id;
    private Long spuId;
    private String name;
    private String introduction;
    private String description;
    private Long categoryId;
    private String picUrl;
    private Integer price;
    private Integer marketPrice;
    private Integer stock;
    private Integer salesCount;
    private List<SkuItem> skus;

    @Data
    @Accessors(chain = true)
    public static class SkuItem {
        private Long id;
        private Integer price;
        private Integer marketPrice;
        private Integer stock;
        private String picUrl;
        private String propertiesText;
    }

}
