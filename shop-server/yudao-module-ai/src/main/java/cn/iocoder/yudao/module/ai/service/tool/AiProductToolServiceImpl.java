package cn.iocoder.yudao.module.ai.service.tool;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductDetailReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductDetailRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductSearchReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductSearchRespVO;
import cn.iocoder.yudao.module.product.controller.admin.category.vo.ProductCategoryListReqVO;
import cn.iocoder.yudao.module.product.controller.app.spu.vo.AppProductSpuPageReqVO;
import cn.iocoder.yudao.module.product.dal.dataobject.category.ProductCategoryDO;
import cn.iocoder.yudao.module.product.dal.dataobject.sku.ProductSkuDO;
import cn.iocoder.yudao.module.product.dal.dataobject.spu.ProductSpuDO;
import cn.iocoder.yudao.module.product.enums.ProductConstants;
import cn.iocoder.yudao.module.product.enums.spu.ProductSpuStatusEnum;
import cn.iocoder.yudao.module.product.service.category.ProductCategoryService;
import cn.iocoder.yudao.module.product.service.sku.ProductSkuService;
import cn.iocoder.yudao.module.product.service.spu.ProductSpuService;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class AiProductToolServiceImpl implements AiProductToolService {

    @Resource
    private ProductSpuService productSpuService;
    @Resource
    private ProductSkuService productSkuService;
    @Resource
    private ProductCategoryService productCategoryService;

    @Override
    @Cacheable(cacheNames = ProductConstants.AI_PRODUCT_SEARCH_CACHE, key = "#request.toString()", sync = true)
    public List<AiProductSearchRespVO> search(AiProductSearchReqVO request) {
        AppProductSpuPageReqVO pageRequest = new AppProductSpuPageReqVO();
        pageRequest.setPageNo(1);
        // 价格/库存在内存二次过滤，先多取一些再截断
        int limit = request.getLimit() == null ? 5 : request.getLimit();
        boolean needPostFilter = request.getMinPrice() != null
                || request.getMaxPrice() != null
                || !Boolean.FALSE.equals(request.getInStock());
        pageRequest.setPageSize(needPostFilter ? Math.min(Math.max(limit * 5, 20), 50) : limit);
        if (StrUtil.isNotBlank(request.getKeyword())) {
            pageRequest.setKeyword(request.getKeyword().trim());
        }
        Long categoryId = resolveCategoryId(request);
        if (categoryId != null) {
            pageRequest.setCategoryId(categoryId);
        }
        if (StrUtil.isNotBlank(request.getSortField())
                && StrUtil.equalsAny(request.getSortField(),
                AppProductSpuPageReqVO.SORT_FIELD_PRICE, AppProductSpuPageReqVO.SORT_FIELD_SALES_COUNT)) {
            pageRequest.setSortField(request.getSortField());
            pageRequest.setSortAsc(Boolean.TRUE.equals(request.getSortAsc()));
        }

        PageResult<ProductSpuDO> page = productSpuService.getSpuPage(pageRequest);
        return page.getList().stream()
                .filter(spu -> matchPriceAndStock(spu, request))
                .limit(limit)
                .map(this::convert)
                .collect(Collectors.toList());
    }

    @Override
    @Cacheable(cacheNames = ProductConstants.AI_PRODUCT_DETAIL_CACHE, key = "#request.productId", sync = true)
    public AiProductDetailRespVO getDetail(AiProductDetailReqVO request) {
        ProductSpuDO spu = productSpuService.getSpu(request.getProductId());
        if (spu == null || !ProductSpuStatusEnum.isEnable(spu.getStatus())) {
            return null;
        }
        List<ProductSkuDO> skus = productSkuService.getSkuListBySpuId(spu.getId());
        AiProductDetailRespVO detail = new AiProductDetailRespVO()
                .setId(spu.getId())
                .setSpuId(spu.getId())
                .setName(spu.getName())
                .setIntroduction(spu.getIntroduction())
                .setDescription(StrUtil.maxLength(spu.getDescription(), 500))
                .setCategoryId(spu.getCategoryId())
                .setPicUrl(spu.getPicUrl())
                .setPrice(spu.getPrice())
                .setMarketPrice(spu.getMarketPrice())
                .setStock(spu.getStock())
                .setSalesCount((spu.getSalesCount() == null ? 0 : spu.getSalesCount())
                        + (spu.getVirtualSalesCount() == null ? 0 : spu.getVirtualSalesCount()));
        if (CollUtil.isEmpty(skus)) {
            detail.setSkus(Collections.emptyList());
            return detail;
        }
        detail.setSkus(skus.stream().map(this::convertSku).collect(Collectors.toList()));
        return detail;
    }

    private Long resolveCategoryId(AiProductSearchReqVO request) {
        if (request.getCategoryId() != null) {
            return request.getCategoryId();
        }
        if (StrUtil.isBlank(request.getCategoryName())) {
            return null;
        }
        List<ProductCategoryDO> categories;
        ProductCategoryListReqVO categoryQuery = new ProductCategoryListReqVO();
        categoryQuery.setName(request.getCategoryName().trim());
        categoryQuery.setStatus(CommonStatusEnum.ENABLE.getStatus());
        categories = productCategoryService.getCategoryList(categoryQuery);
        if (CollUtil.isEmpty(categories)) {
            return null;
        }
        return categories.get(0).getId();
    }

    private boolean matchPriceAndStock(ProductSpuDO spu, AiProductSearchReqVO request) {
        Integer price = spu.getPrice() == null ? 0 : spu.getPrice();
        if (request.getMinPrice() != null && price < request.getMinPrice()) {
            return false;
        }
        if (request.getMaxPrice() != null && price > request.getMaxPrice()) {
            return false;
        }
        if (!Boolean.FALSE.equals(request.getInStock())) {
            Integer stock = spu.getStock() == null ? 0 : spu.getStock();
            return stock > 0;
        }
        return true;
    }

    private AiProductSearchRespVO convert(ProductSpuDO spu) {
        return new AiProductSearchRespVO()
                .setId(spu.getId())
                .setSpuId(spu.getId())
                .setName(spu.getName())
                .setIntroduction(spu.getIntroduction())
                .setPicUrl(spu.getPicUrl())
                .setPrice(spu.getPrice())
                .setMarketPrice(spu.getMarketPrice())
                .setStock(spu.getStock())
                .setSalesCount((spu.getSalesCount() == null ? 0 : spu.getSalesCount())
                        + (spu.getVirtualSalesCount() == null ? 0 : spu.getVirtualSalesCount()));
    }

    private AiProductDetailRespVO.SkuItem convertSku(ProductSkuDO sku) {
        String propertiesText = null;
        if (CollUtil.isNotEmpty(sku.getProperties())) {
            propertiesText = sku.getProperties().stream()
                    .map(property -> {
                        String name = property.getPropertyName();
                        String value = property.getValueName();
                        if (StrUtil.isAllBlank(name, value)) {
                            return null;
                        }
                        return StrUtil.blankToDefault(name, "") + ":" + StrUtil.blankToDefault(value, "");
                    })
                    .filter(Objects::nonNull)
                    .collect(Collectors.joining(", "));
        }
        return new AiProductDetailRespVO.SkuItem()
                .setId(sku.getId())
                .setPrice(sku.getPrice())
                .setMarketPrice(sku.getMarketPrice())
                .setStock(sku.getStock())
                .setPicUrl(sku.getPicUrl())
                .setPropertiesText(propertiesText);
    }

}
