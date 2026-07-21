package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
public class AiAfterSaleRespVO {

    private Long id;
    private String no;
    private Integer status;
    private String statusName;
    private Integer way;
    private Integer type;
    private String applyReason;
    private String applyDescription;
    private Long orderId;
    private String orderNo;
    private String spuName;
    private String picUrl;
    private Integer count;
    private Integer refundPrice;
    private String auditReason;
    private LocalDateTime createTime;

}