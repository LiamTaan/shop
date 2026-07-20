package cn.iocoder.yudao.module.ai.controller.rpc.tool;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductSearchReqVO;
import cn.iocoder.yudao.module.ai.controller.rpc.tool.vo.AiProductSearchRespVO;
import cn.iocoder.yudao.module.ai.framework.config.AiServiceProperties;
import cn.iocoder.yudao.module.ai.service.tool.AiProductToolService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import javax.annotation.Resource;
import javax.annotation.security.PermitAll;
import javax.validation.Valid;
import java.util.List;

import static cn.iocoder.yudao.framework.common.enums.RpcConstants.RPC_API_PREFIX;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@RestController
@RequestMapping(RPC_API_PREFIX + "/ai/tools/product")
@Validated
public class AiProductToolController {

    @Resource
    private AiProductToolService productToolService;
    @Resource
    private AiServiceProperties properties;

    @PostMapping("/search")
    @PermitAll
    public CommonResult<List<AiProductSearchRespVO>> search(
            @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
            @Valid @RequestBody AiProductSearchReqVO request) {
        validateInternalToken(authorization);
        return success(productToolService.search(request));
    }

    private void validateInternalToken(String authorization) {
        String token = properties.getInternalToken();
        if (token == null || token.isEmpty() || !("Bearer " + token).equals(authorization)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        }
    }

}

