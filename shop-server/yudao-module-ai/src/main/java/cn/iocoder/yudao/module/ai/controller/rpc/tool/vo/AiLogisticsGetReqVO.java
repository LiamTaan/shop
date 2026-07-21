package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;

import jakarta.validation.constraints.NotNull;

@Data
public class AiLogisticsGetReqVO {

    @NotNull(message = "userId cannot be null")
    private Long userId;

    private Long orderId;

    private String orderNo;

}