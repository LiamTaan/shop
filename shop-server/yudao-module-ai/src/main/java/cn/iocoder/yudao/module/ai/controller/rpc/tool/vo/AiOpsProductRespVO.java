package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class AiOpsProductRespVO {

    private Long id;
    private String name;
    private String picUrl;
    private Integer price;
    private Integer stock;
    private Integer salesCount;
    private Integer status;
    private String statusName;
    private Long categoryId;

}