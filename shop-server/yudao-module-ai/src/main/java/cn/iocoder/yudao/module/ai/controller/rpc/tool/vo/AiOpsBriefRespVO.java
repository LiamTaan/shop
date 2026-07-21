package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;
import lombok.experimental.Accessors;

import java.util.List;

@Data
@Accessors(chain = true)
public class AiOpsBriefRespVO {

    private Integer alertStockThreshold;
    private Long lowStockCount;
    private Long soldOutCount;
    private Long onSaleCount;
    private List<AiOpsProductRespVO> lowStockItems;
    private List<AiOpsProductRespVO> hotItems;
    private List<AiOpsProductRespVO> slowItems;

}