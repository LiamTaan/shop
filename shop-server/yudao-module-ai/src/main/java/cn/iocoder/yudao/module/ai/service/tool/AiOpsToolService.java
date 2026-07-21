package cn.iocoder.yudao.module.ai.service.tool;

import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOpsBriefRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOpsProductListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOpsProductRespVO;

import java.util.List;

public interface AiOpsToolService {

    List<AiOpsProductRespVO> listLowStock(AiOpsProductListReqVO request);

    List<AiOpsProductRespVO> listHotProducts(AiOpsProductListReqVO request);

    List<AiOpsProductRespVO> listSlowProducts(AiOpsProductListReqVO request);

    AiOpsBriefRespVO getBrief(AiOpsProductListReqVO request);

}