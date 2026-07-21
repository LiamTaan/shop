package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

@Data
public class AiOpsProductListReqVO {

    /**
     * 返回条数。
     */
    @Min(1)
    @Max(30)
    private Integer limit = 10;

    /**
     * 低库存阈值（分）。仅 low-stock 使用；默认使用系统警戒库存 10。
     */
    @Min(0)
    private Integer stockThreshold;

    /**
     * 滞销销量上限（含虚拟销量合计）。仅 slow 使用；默认 5。
     */
    @Min(0)
    private Integer maxSalesCount;

}