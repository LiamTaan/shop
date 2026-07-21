package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;

import jakarta.validation.constraints.NotNull;

@Data
public class AiAfterSaleDetailReqVO {

    @NotNull(message = "userId cannot be null")
    private Long userId;

    @NotNull(message = "afterSaleId cannot be null")
    private Long afterSaleId;

}