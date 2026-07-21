package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;

import jakarta.validation.constraints.NotNull;

@Data
public class AiOrderDetailReqVO {

    @NotNull(message = "userId cannot be null")
    private Long userId;

    /**
     * 订单主键 id（与 orderNo 二选一）。
     */
    private Long orderId;

    /**
     * 订单流水号（与 orderId 二选一）。
     */
    private String orderNo;

}