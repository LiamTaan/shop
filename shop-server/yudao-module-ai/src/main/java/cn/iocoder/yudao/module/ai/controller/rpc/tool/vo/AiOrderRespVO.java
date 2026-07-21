package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Accessors(chain = true)
public class AiOrderRespVO {

    private Long id;
    private String no;
    private Integer status;
    private String statusName;
    private Integer productCount;
    private Integer payPrice;
    private Boolean payStatus;
    private Integer deliveryType;
    private String logisticsName;
    private String logisticsNo;
    private String receiverName;
    private String receiverMobileMasked;
    private LocalDateTime createTime;
    private LocalDateTime deliveryTime;
    private List<AiOrderItemRespVO> items;

}