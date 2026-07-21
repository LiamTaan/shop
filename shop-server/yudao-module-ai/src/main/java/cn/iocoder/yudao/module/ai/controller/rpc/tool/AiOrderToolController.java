package cn.iocoder.yudao.module.ai.controller.rpc.tool;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiLogisticsGetReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiLogisticsTrackRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOrderDetailReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOrderListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOrderRespVO;
import cn.iocoder.yudao.module.ai.framework.config.AiServiceProperties;
import cn.iocoder.yudao.module.ai.service.tool.AiOrderToolService;
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
public class AiOrderToolController {

    @Resource
    private AiOrderToolService orderToolService;
    @Resource
    private AiServiceProperties properties;

    @PostMapping("/order/list")
    @PermitAll
    public CommonResult<List<AiOrderRespVO>> listOrders(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody AiOrderListReqVO request) {
        validateInternalToken(authorization);
        return success(orderToolService.listOrders(request));
    }

    @PostMapping("/order/detail")
    @PermitAll
    public CommonResult<AiOrderRespVO> getOrderDetail(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody AiOrderDetailReqVO request) {
        validateInternalToken(authorization);
        return success(orderToolService.getOrderDetail(request));
    }

    @PostMapping("/logistics/get")
    @PermitAll
    public CommonResult<AiLogisticsTrackRespVO> getLogistics(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody AiLogisticsGetReqVO request) {
        validateInternalToken(authorization);
        return success(orderToolService.getLogistics(request));
    }

    private void validateInternalToken(String authorization) {
        String token = properties.getInternalToken();
        if (token == null || token.isEmpty() || !("Bearer " + token).equals(authorization)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        }
    }

}