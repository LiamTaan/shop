package cn.iocoder.yudao.module.ai.service.tool;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductSearchReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductSearchRespVO;
import cn.iocoder.yudao.module.product.controller.app.spu.vo.AppProductSpuPageReqVO;
import cn.iocoder.yudao.module.product.dal.dataobject.spu.ProductSpuDO;
import cn.iocoder.yudao.module.product.service.spu.ProductSpuService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AiProductToolServiceImpl implements AiProductToolService {

    @Resource
    private ProductSpuService productSpuService;

    @Override
    public List<AiProductSearchRespVO> search(AiProductSearchReqVO request) {
        AppProductSpuPageReqVO pageRequest = new AppProductSpuPageReqVO();
        pageRequest.setPageNo(1);
        pageRequest.setPageSize(request.getLimit());
        pageRequest.setKeyword(request.getKeyword());
        PageResult<ProductSpuDO> page = productSpuService.getSpuPage(pageRequest);
        return page.getList().stream().map(this::convert).collect(Collectors.toList());
    }

    private AiProductSearchRespVO convert(ProductSpuDO spu) {
        return new AiProductSearchRespVO()
                .setId(spu.getId())
                .setName(spu.getName())
                .setIntroduction(spu.getIntroduction())
                .setPicUrl(spu.getPicUrl())
                .setPrice(spu.getPrice())
                .setMarketPrice(spu.getMarketPrice())
                .setStock(spu.getStock())
                .setSalesCount((spu.getSalesCount() == null ? 0 : spu.getSalesCount())
                        + (spu.getVirtualSalesCount() == null ? 0 : spu.getVirtualSalesCount()));
    }

}
