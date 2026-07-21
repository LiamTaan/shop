package cn.iocoder.yudao.module.ai.service.tool;

import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductDetailReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductDetailRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductSearchReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductSearchRespVO;

import java.util.List;

public interface AiProductToolService {

    List<AiProductSearchRespVO> search(AiProductSearchReqVO request);

    AiProductDetailRespVO getDetail(AiProductDetailReqVO request);

}