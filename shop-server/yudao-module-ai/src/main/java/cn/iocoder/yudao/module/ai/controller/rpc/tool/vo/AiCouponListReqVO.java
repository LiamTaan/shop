package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

@Data
public class AiCouponListReqVO {

    @NotNull(message = "userId cannot be null")
    private Long userId;

    /**
     * 优惠券状态：1 未使用 / 2 已使用 / 3 已过期；空=全部。
     */
    private Integer status;

    @Min(1)
    @Max(20)
    private Integer limit = 10;

}