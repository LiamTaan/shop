package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;

import jakarta.validation.constraints.NotNull;

@Data
public class AiProductDetailReqVO {

    @NotNull(message = "productId cannot be null")
    private Long productId;

}