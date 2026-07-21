package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.util.Set;

@Data
public class AiAfterSaleListReqVO {

    @NotNull(message = "userId cannot be null")
    private Long userId;

    /**
     * 售后状态集合，可选。
     */
    private Set<Integer> statuses;

    @Min(1)
    @Max(20)
    private Integer limit = 10;

}