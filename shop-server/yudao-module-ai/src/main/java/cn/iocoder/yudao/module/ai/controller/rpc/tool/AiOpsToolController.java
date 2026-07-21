package cn.iocoder.yudao.module.ai.controller.rpc.tool;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOpsBriefRespVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOpsProductListReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiOpsProductRespVO;
import cn.iocoder.yudao.module.ai.framework.config.AiServiceProperties;
import cn.iocoder.yudao.module.ai.service.tool.AiOpsToolService;
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
@RequestMapping(RPC_API_PREFIX + "/ai/tools/ops")
@Validated
public class AiOpsToolController {

    @Resource
    private AiOpsToolService opsToolService;
    @Resource
    private AiServiceProperties properties;

    @PostMapping("/low-stock")
    @PermitAll
    public CommonResult<List<AiOpsProductRespVO>> listLowStock(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody(required = false) AiOpsProductListReqVO request) {
        validateInternalToken(authorization);
        return success(opsToolService.listLowStock(request == null ? new AiOpsProductListReqVO() : request));
    }

    @PostMapping("/hot")
    @PermitAll
    public CommonResult<List<AiOpsProductRespVO>> listHot(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody(required = false) AiOpsProductListReqVO request) {
        validateInternalToken(authorization);
        return success(opsToolService.listHotProducts(request == null ? new AiOpsProductListReqVO() : request));
    }

    @PostMapping("/slow")
    @PermitAll
    public CommonResult<List<AiOpsProductRespVO>> listSlow(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody(required = false) AiOpsProductListReqVO request) {
        validateInternalToken(authorization);
        return success(opsToolService.listSlowProducts(request == null ? new AiOpsProductListReqVO() : request));
    }

    @PostMapping("/brief")
    @PermitAll
    public CommonResult<AiOpsBriefRespVO> brief(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody(required = false) AiOpsProductListReqVO request) {
        validateInternalToken(authorization);
        return success(opsToolService.getBrief(request == null ? new AiOpsProductListReqVO() : request));
    }

    private void validateInternalToken(String authorization) {
        String token = properties.getInternalToken();
        if (token == null || token.isEmpty() || !("Bearer " + token).equals(authorization)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        }
    }

}