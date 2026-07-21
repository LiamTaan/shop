package cn.iocoder.yudao.module.ai.service.tool;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiLogisticsGetReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiLogisticsTrackRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOrderDetailReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOrderItemRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOrderListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOrderRespVO;
import cn.iocoder.yudao.module.trade.controller.app.order.vo.AppTradeOrderPageReqVO;
import cn.iocoder.yudao.module.trade.dal.dataobject.delivery.DeliveryExpressDO;
import cn.iocoder.yudao.module.trade.dal.dataobject.order.TradeOrderDO;
import cn.iocoder.yudao.module.trade.dal.dataobject.order.TradeOrderItemDO;
import cn.iocoder.yudao.module.trade.dal.mysql.order.TradeOrderMapper;
import cn.iocoder.yudao.module.trade.enums.order.TradeOrderStatusEnum;
import cn.iocoder.yudao.module.trade.framework.delivery.core.client.dto.ExpressTrackRespDTO;
import cn.iocoder.yudao.module.trade.service.delivery.DeliveryExpressService;
import cn.iocoder.yudao.module.trade.service.order.TradeOrderQueryService;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.util.collection.CollectionUtils.convertSet;

@Service
public class AiOrderToolServiceImpl implements AiOrderToolService {

    @Resource
    private TradeOrderQueryService tradeOrderQueryService;
    @Resource
    private TradeOrderMapper tradeOrderMapper;
    @Resource
    private DeliveryExpressService deliveryExpressService;

    @Override
    public List<AiOrderRespVO> listOrders(AiOrderListReqVO request) {
        AppTradeOrderPageReqVO pageReq = new AppTradeOrderPageReqVO();
        pageReq.setPageNo(1);
        pageReq.setPageSize(request.getLimit() == null ? 5 : request.getLimit());
        pageReq.setStatus(request.getStatus());
        PageResult<TradeOrderDO> page = tradeOrderQueryService.getOrderPage(request.getUserId(), pageReq);
        if (page.getList().isEmpty()) {
            return Collections.emptyList();
        }
        List<TradeOrderItemDO> items = tradeOrderQueryService.getOrderItemListByOrderId(
                convertSet(page.getList(), TradeOrderDO::getId));
        Map<Long, List<TradeOrderItemDO>> itemMap = items.stream()
                .collect(Collectors.groupingBy(TradeOrderItemDO::getOrderId));
        return page.getList().stream()
                .map(order -> convert(order, itemMap.getOrDefault(order.getId(), Collections.emptyList()), false))
                .collect(Collectors.toList());
    }

    @Override
    public AiOrderRespVO getOrderDetail(AiOrderDetailReqVO request) {
        TradeOrderDO order = resolveOwnedOrder(request.getUserId(), request.getOrderId(), request.getOrderNo());
        if (order == null) {
            return null;
        }
        List<TradeOrderItemDO> items = tradeOrderQueryService.getOrderItemListByOrderId(order.getId());
        return convert(order, items, true);
    }

    @Override
    public AiLogisticsTrackRespVO getLogistics(AiLogisticsGetReqVO request) {
        TradeOrderDO order = resolveOwnedOrder(request.getUserId(), request.getOrderId(), request.getOrderNo());
        if (order == null) {
            return null;
        }
        AiLogisticsTrackRespVO resp = new AiLogisticsTrackRespVO()
                .setOrderId(order.getId())
                .setOrderNo(order.getNo())
                .setLogisticsNo(order.getLogisticsNo());
        if (order.getLogisticsId() != null && order.getLogisticsId() > 0) {
            DeliveryExpressDO express = deliveryExpressService.getDeliveryExpress(order.getLogisticsId());
            if (express != null) {
                resp.setLogisticsName(express.getName());
            }
        }
        List<ExpressTrackRespDTO> tracks;
        try {
            tracks = tradeOrderQueryService.getExpressTrackList(order.getId(), request.getUserId());
        } catch (ServiceException ex) {
            tracks = Collections.emptyList();
        }
        resp.setTracks(tracks.stream()
                .map(track -> new AiLogisticsTrackRespVO.TrackItem()
                        .setTime(track.getTime())
                        .setContent(track.getContent()))
                .collect(Collectors.toList()));
        return resp;
    }

    private TradeOrderDO resolveOwnedOrder(Long userId, Long orderId, String orderNo) {
        if (orderId != null) {
            return tradeOrderQueryService.getOrder(userId, orderId);
        }
        if (StrUtil.isNotBlank(orderNo)) {
            return tradeOrderMapper.selectOne(new LambdaQueryWrapperX<TradeOrderDO>()
                    .eq(TradeOrderDO::getUserId, userId)
                    .eq(TradeOrderDO::getNo, orderNo.trim()));
        }
        return null;
    }

    private AiOrderRespVO convert(TradeOrderDO order, List<TradeOrderItemDO> items, boolean withLogisticsName) {
        AiOrderRespVO resp = new AiOrderRespVO()
                .setId(order.getId())
                .setNo(order.getNo())
                .setStatus(order.getStatus())
                .setStatusName(statusName(order.getStatus()))
                .setProductCount(order.getProductCount())
                .setPayPrice(order.getPayPrice())
                .setPayStatus(order.getPayStatus())
                .setDeliveryType(order.getDeliveryType())
                .setLogisticsNo(order.getLogisticsNo())
                .setReceiverName(order.getReceiverName())
                .setReceiverMobileMasked(maskMobile(order.getReceiverMobile()))
                .setCreateTime(order.getCreateTime())
                .setDeliveryTime(order.getDeliveryTime())
                .setItems(items.stream().map(this::convertItem).collect(Collectors.toList()));
        if (withLogisticsName && order.getLogisticsId() != null && order.getLogisticsId() > 0) {
            DeliveryExpressDO express = deliveryExpressService.getDeliveryExpress(order.getLogisticsId());
            if (express != null) {
                resp.setLogisticsName(express.getName());
            }
        }
        return resp;
    }

    private AiOrderItemRespVO convertItem(TradeOrderItemDO item) {
        return new AiOrderItemRespVO()
                .setId(item.getId())
                .setSpuId(item.getSpuId())
                .setSpuName(item.getSpuName())
                .setPicUrl(item.getPicUrl())
                .setCount(item.getCount())
                .setPrice(item.getPrice())
                .setPayPrice(item.getPayPrice());
    }

    private static String statusName(Integer status) {
        return Arrays.stream(TradeOrderStatusEnum.values())
                .filter(item -> Objects.equals(item.getStatus(), status))
                .map(TradeOrderStatusEnum::getName)
                .findFirst()
                .orElse(status == null ? "未知" : String.valueOf(status));
    }

    private static String maskMobile(String mobile) {
        if (StrUtil.isBlank(mobile) || mobile.length() < 7) {
            return mobile;
        }
        return mobile.substring(0, 3) + "****" + mobile.substring(mobile.length() - 4);
    }

}