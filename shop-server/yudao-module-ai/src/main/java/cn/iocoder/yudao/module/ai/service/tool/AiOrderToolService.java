package cn.iocoder.yudao.module.ai.service.tool;

import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiLogisticsGetReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiLogisticsTrackRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOrderDetailReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOrderListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOrderRespVO;

import java.util.List;

public interface AiOrderToolService {

    List<AiOrderRespVO> listOrders(AiOrderListReqVO request);

    AiOrderRespVO getOrderDetail(AiOrderDetailReqVO request);

    AiLogisticsTrackRespVO getLogistics(AiLogisticsGetReqVO request);

}