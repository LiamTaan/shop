package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
public class AiCouponRespVO {

    private Long id;
    private String name;
    private Integer status;
    private String statusName;
    private Integer usePrice;
    private Integer discountType;
    private String discountTypeName;
    private Integer discountPercent;
    private Integer discountPrice;
    private Integer discountLimitPrice;
    private LocalDateTime validStartTime;
    private LocalDateTime validEndTime;

}