package cn.iocoder.yudao.module.ai.service.tool;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOpsBriefRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOpsProductListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOpsProductRespVO;
import cn.iocoder.yudao.module.product.controller.admin.spu.vo.ProductSpuPageReqVO;
import cn.iocoder.yudao.module.product.dal.dataobject.spu.ProductSpuDO;
import cn.iocoder.yudao.module.product.dal.mysql.spu.ProductSpuMapper;
import cn.iocoder.yudao.module.product.enums.ProductConstants;
import cn.iocoder.yudao.module.product.enums.spu.ProductSpuStatusEnum;
import cn.iocoder.yudao.module.product.service.spu.ProductSpuService;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class AiOpsToolServiceImpl implements AiOpsToolService {

    @Resource
    private ProductSpuService productSpuService;
    @Resource
    private ProductSpuMapper productSpuMapper;

    @Override
    public List<AiOpsProductRespVO> listLowStock(AiOpsProductListReqVO request) {
        int limit = limitOf(request);
        int threshold = request.getStockThreshold() == null
                ? ProductConstants.ALERT_STOCK
                : request.getStockThreshold();
        if (threshold == ProductConstants.ALERT_STOCK) {
            ProductSpuPageReqVO pageReq = new ProductSpuPageReqVO();
            pageReq.setPageNo(1);
            pageReq.setPageSize(limit);
            pageReq.setTabType(ProductSpuPageReqVO.ALERT_STOCK);
            PageResult<ProductSpuDO> page = productSpuService.getSpuPage(pageReq);
            return convertList(page.getList());
        }
        List<ProductSpuDO> list = productSpuMapper.selectList(new LambdaQueryWrapperX<ProductSpuDO>()
                .le(ProductSpuDO::getStock, threshold)
                .notIn(ProductSpuDO::getStatus, ProductSpuStatusEnum.RECYCLE.getStatus())
                .orderByAsc(ProductSpuDO::getStock)
                .orderByDesc(ProductSpuDO::getId)
                .last("LIMIT " + limit));
        return convertList(list);
    }

    @Override
    public List<AiOpsProductRespVO> listHotProducts(AiOpsProductListReqVO request) {
        int limit = limitOf(request);
        List<ProductSpuDO> list = productSpuMapper.selectList(new LambdaQueryWrapperX<ProductSpuDO>()
                .eq(ProductSpuDO::getStatus, ProductSpuStatusEnum.ENABLE.getStatus())
                .orderByDesc(ProductSpuDO::getSalesCount)
                .orderByDesc(ProductSpuDO::getId)
                .last("LIMIT " + limit));
        return convertList(list);
    }

    @Override
    public List<AiOpsProductRespVO> listSlowProducts(AiOpsProductListReqVO request) {
        int limit = limitOf(request);
        int maxSales = request.getMaxSalesCount() == null ? 5 : request.getMaxSalesCount();
        List<ProductSpuDO> list = productSpuMapper.selectList(new LambdaQueryWrapperX<ProductSpuDO>()
                .eq(ProductSpuDO::getStatus, ProductSpuStatusEnum.ENABLE.getStatus())
                .gt(ProductSpuDO::getStock, 0)
                .le(ProductSpuDO::getSalesCount, maxSales)
                .orderByAsc(ProductSpuDO::getSalesCount)
                .orderByDesc(ProductSpuDO::getStock)
                .orderByDesc(ProductSpuDO::getId)
                .last("LIMIT " + limit));
        return convertList(list);
    }

    @Override
    public AiOpsBriefRespVO getBrief(AiOpsProductListReqVO request) {
        int limit = limitOf(request);
        ProductSpuPageReqVO countReq = new ProductSpuPageReqVO();
        Long lowStockCount = productSpuMapper.selectCountByTab(countReq, ProductSpuPageReqVO.ALERT_STOCK);
        Long soldOutCount = productSpuMapper.selectCountByTab(countReq, ProductSpuPageReqVO.SOLD_OUT);
        Long onSaleCount = productSpuMapper.selectCountByTab(countReq, ProductSpuPageReqVO.FOR_SALE);

        AiOpsProductListReqVO itemReq = new AiOpsProductListReqVO();
        itemReq.setLimit(Math.min(limit, 5));
        itemReq.setStockThreshold(request.getStockThreshold());
        itemReq.setMaxSalesCount(request.getMaxSalesCount());

        return new AiOpsBriefRespVO()
                .setAlertStockThreshold(request.getStockThreshold() == null
                        ? ProductConstants.ALERT_STOCK : request.getStockThreshold())
                .setLowStockCount(lowStockCount == null ? 0L : lowStockCount)
                .setSoldOutCount(soldOutCount == null ? 0L : soldOutCount)
                .setOnSaleCount(onSaleCount == null ? 0L : onSaleCount)
                .setLowStockItems(listLowStock(itemReq))
                .setHotItems(listHotProducts(itemReq))
                .setSlowItems(listSlowProducts(itemReq));
    }

    private static int limitOf(AiOpsProductListReqVO request) {
        return request.getLimit() == null ? 10 : request.getLimit();
    }

    private List<AiOpsProductRespVO> convertList(List<ProductSpuDO> list) {
        if (list == null || list.isEmpty()) {
            return Collections.emptyList();
        }
        return list.stream().map(this::convert).collect(Collectors.toList());
    }

    private AiOpsProductRespVO convert(ProductSpuDO spu) {
        int sales = (spu.getSalesCount() == null ? 0 : spu.getSalesCount())
                + (spu.getVirtualSalesCount() == null ? 0 : spu.getVirtualSalesCount());
        return new AiOpsProductRespVO()
                .setId(spu.getId())
                .setName(spu.getName())
                .setPicUrl(spu.getPicUrl())
                .setPrice(spu.getPrice())
                .setStock(spu.getStock())
                .setSalesCount(sales)
                .setStatus(spu.getStatus())
                .setStatusName(statusName(spu.getStatus()))
                .setCategoryId(spu.getCategoryId());
    }

    private static String statusName(Integer status) {
        if (Objects.equals(status, ProductSpuStatusEnum.ENABLE.getStatus())) {
            return "上架";
        }
        if (Objects.equals(status, ProductSpuStatusEnum.DISABLE.getStatus())) {
            return "下架";
        }
        if (Objects.equals(status, ProductSpuStatusEnum.RECYCLE.getStatus())) {
            return "回收站";
        }
        return status == null ? "未知" : String.valueOf(status);
    }

}