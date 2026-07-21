package cn.iocoder.yudao.module.ai.controller.rpc.tool;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiAfterSaleDetailReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiAfterSaleListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiAfterSaleRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiCouponListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiCouponRespVO;
import cn.iocoder.yudao.module.ai.framework.config.AiServiceProperties;
import cn.iocoder.yudao.module.ai.service.tool.AiMemberToolService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import jakarta.annotation.Resource;
import jakarta.annotation.security.PermitAll;
import jakarta.validation.Valid;
import java.util.List;

import static cn.iocoder.yudao.framework.common.enums.RpcConstants.RPC_API_PREFIX;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@RestController
@RequestMapping(RPC_API_PREFIX + "/ai/tools")
@Validated
public class AiMemberToolController {

    @Resource
    private AiMemberToolService memberToolService;
    @Resource
    private AiServiceProperties properties;

    @PostMapping("/coupon/list")
    @PermitAll
    public CommonResult<List<AiCouponRespVO>> listCoupons(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody AiCouponListReqVO request) {
        validateInternalToken(authorization);
        return success(memberToolService.listCoupons(request));
    }

    @PostMapping("/aftersale/list")
    @PermitAll
    public CommonResult<List<AiAfterSaleRespVO>> listAfterSales(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody AiAfterSaleListReqVO request) {
        validateInternalToken(authorization);
        return success(memberToolService.listAfterSales(request));
    }

    @PostMapping("/aftersale/detail")
    @PermitAll
    public CommonResult<AiAfterSaleRespVO> getAfterSale(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody AiAfterSaleDetailReqVO request) {
        validateInternalToken(authorization);
        return success(memberToolService.getAfterSale(request));
    }

    private void validateInternalToken(String authorization) {
        String token = properties.getInternalToken();
        if (token == null || token.isEmpty() || !("Bearer " + token).equals(authorization)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        }
    }

}