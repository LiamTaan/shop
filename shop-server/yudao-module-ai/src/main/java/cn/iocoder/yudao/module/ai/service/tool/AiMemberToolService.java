package cn.iocoder.yudao.module.ai.service.tool;

import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiAfterSaleDetailReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiAfterSaleListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiAfterSaleRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiCouponListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiCouponRespVO;

import java.util.List;

public interface AiMemberToolService {

    List<AiCouponRespVO> listCoupons(AiCouponListReqVO request);

    List<AiAfterSaleRespVO> listAfterSales(AiAfterSaleListReqVO request);

    AiAfterSaleRespVO getAfterSale(AiAfterSaleDetailReqVO request);

}