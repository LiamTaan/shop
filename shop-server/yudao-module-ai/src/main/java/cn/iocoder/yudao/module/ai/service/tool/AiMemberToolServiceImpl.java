package cn.iocoder.yudao.module.ai.service.tool;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiAfterSaleDetailReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiAfterSaleListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiAfterSaleRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiCouponListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiCouponRespVO;
import cn.iocoder.yudao.module.promotion.dal.dataobject.coupon.CouponDO;
import cn.iocoder.yudao.module.promotion.enums.common.PromotionDiscountTypeEnum;
import cn.iocoder.yudao.module.promotion.enums.coupon.CouponStatusEnum;
import cn.iocoder.yudao.module.promotion.service.coupon.CouponService;
import cn.iocoder.yudao.module.trade.controller.app.aftersale.vo.AppAfterSalePageReqVO;
import cn.iocoder.yudao.module.trade.dal.dataobject.aftersale.AfterSaleDO;
import cn.iocoder.yudao.module.trade.enums.aftersale.AfterSaleStatusEnum;
import cn.iocoder.yudao.module.trade.service.aftersale.AfterSaleService;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class AiMemberToolServiceImpl implements AiMemberToolService {

    @Resource
    private CouponService couponService;
    @Resource
    private AfterSaleService afterSaleService;

    @Override
    public List<AiCouponRespVO> listCoupons(AiCouponListReqVO request) {
        int limit = request.getLimit() == null ? 10 : request.getLimit();
        List<CouponDO> coupons = couponService.getCouponList(request.getUserId(), request.getStatus());
        if (coupons == null || coupons.isEmpty()) {
            return Collections.emptyList();
        }
        return coupons.stream()
                .limit(limit)
                .map(this::convertCoupon)
                .collect(Collectors.toList());
    }

    @Override
    public List<AiAfterSaleRespVO> listAfterSales(AiAfterSaleListReqVO request) {
        AppAfterSalePageReqVO pageReq = new AppAfterSalePageReqVO();
        pageReq.setPageNo(1);
        pageReq.setPageSize(request.getLimit() == null ? 10 : request.getLimit());
        pageReq.setStatuses(request.getStatuses());
        PageResult<AfterSaleDO> page = afterSaleService.getAfterSalePage(request.getUserId(), pageReq);
        if (page.getList() == null || page.getList().isEmpty()) {
            return Collections.emptyList();
        }
        return page.getList().stream().map(this::convertAfterSale).collect(Collectors.toList());
    }

    @Override
    public AiAfterSaleRespVO getAfterSale(AiAfterSaleDetailReqVO request) {
        AfterSaleDO afterSale = afterSaleService.getAfterSale(request.getUserId(), request.getAfterSaleId());
        if (afterSale == null) {
            return null;
        }
        return convertAfterSale(afterSale);
    }

    private AiCouponRespVO convertCoupon(CouponDO coupon) {
        return new AiCouponRespVO()
                .setId(coupon.getId())
                .setName(coupon.getName())
                .setStatus(coupon.getStatus())
                .setStatusName(couponStatusName(coupon.getStatus()))
                .setUsePrice(coupon.getUsePrice())
                .setDiscountType(coupon.getDiscountType())
                .setDiscountTypeName(discountTypeName(coupon.getDiscountType()))
                .setDiscountPercent(coupon.getDiscountPercent())
                .setDiscountPrice(coupon.getDiscountPrice())
                .setDiscountLimitPrice(coupon.getDiscountLimitPrice())
                .setValidStartTime(coupon.getValidStartTime())
                .setValidEndTime(coupon.getValidEndTime());
    }

    private AiAfterSaleRespVO convertAfterSale(AfterSaleDO afterSale) {
        return new AiAfterSaleRespVO()
                .setId(afterSale.getId())
                .setNo(afterSale.getNo())
                .setStatus(afterSale.getStatus())
                .setStatusName(afterSaleStatusName(afterSale.getStatus()))
                .setWay(afterSale.getWay())
                .setType(afterSale.getType())
                .setApplyReason(afterSale.getApplyReason())
                .setApplyDescription(afterSale.getApplyDescription())
                .setOrderId(afterSale.getOrderId())
                .setOrderNo(afterSale.getOrderNo())
                .setSpuName(afterSale.getSpuName())
                .setPicUrl(afterSale.getPicUrl())
                .setCount(afterSale.getCount())
                .setRefundPrice(afterSale.getRefundPrice())
                .setAuditReason(afterSale.getAuditReason())
                .setCreateTime(afterSale.getCreateTime());
    }

    private static String couponStatusName(Integer status) {
        return Arrays.stream(CouponStatusEnum.values())
                .filter(item -> Objects.equals(item.getStatus(), status))
                .map(CouponStatusEnum::getName)
                .findFirst()
                .orElse(status == null ? "未知" : String.valueOf(status));
    }

    private static String discountTypeName(Integer type) {
        return Arrays.stream(PromotionDiscountTypeEnum.values())
                .filter(item -> Objects.equals(item.getType(), type))
                .map(PromotionDiscountTypeEnum::getName)
                .findFirst()
                .orElse(type == null ? "未知" : String.valueOf(type));
    }

    private static String afterSaleStatusName(Integer status) {
        return Arrays.stream(AfterSaleStatusEnum.values())
                .filter(item -> Objects.equals(item.getStatus(), status))
                .map(AfterSaleStatusEnum::getName)
                .findFirst()
                .orElse(status == null ? "未知" : String.valueOf(status));
    }

}