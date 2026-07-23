package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class AiProductSearchRespVO {

    private Long id;
    private Long spuId;
    private String name;
    private String introduction;
    private String picUrl;
    private Integer price;
    private Integer marketPrice;
    private Integer stock;
    private Integer salesCount;

}
