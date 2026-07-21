package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class AiOrderItemRespVO {

    private Long id;
    private Long spuId;
    private String spuName;
    private String picUrl;
    private Integer count;
    private Integer price;
    private Integer payPrice;

}