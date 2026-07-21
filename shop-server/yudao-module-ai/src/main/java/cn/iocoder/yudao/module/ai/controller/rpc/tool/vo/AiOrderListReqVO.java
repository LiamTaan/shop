package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

@Data
public class AiOrderListReqVO {

    /**
     * 当前登录会员编号。必须由 shop-ai-service 从已鉴权会话注入，禁止信任模型参数。
     */
    @NotNull(message = "userId cannot be null")
    private Long userId;

    /**
     * 订单状态，可选。见 TradeOrderStatusEnum。
     */
    private Integer status;

    @Min(value = 1, message = "Limit must be at least 1")
    @Max(value = 20, message = "Limit cannot exceed 20")
    private Integer limit = 5;

}