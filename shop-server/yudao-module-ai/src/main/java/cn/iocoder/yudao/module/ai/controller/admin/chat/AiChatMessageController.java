package cn.iocoder.yudao.module.ai.controller.admin.chat;

import cn.iocoder.yudao.framework.common.enums.UserTypeEnum;
import cn.iocoder.yudao.framework.tenant.core.context.TenantContextHolder;
import cn.iocoder.yudao.module.ai.controller.vo.AiChatMessageSendReqVO;
import cn.iocoder.yudao.module.ai.service.AiChatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import javax.annotation.Resource;
import javax.validation.Valid;

import static cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils.getLoginUserId;

@Tag(name = "Admin - AI chat")
@RestController
@RequestMapping("/ai/chat/message")
@Validated
public class AiChatMessageController {

    @Resource
    private AiChatService aiChatService;

    @PostMapping(value = "/send-stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    @Operation(summary = "Send a streaming AI chat message")
    public SseEmitter sendStream(@Valid @RequestBody AiChatMessageSendReqVO request) {
        return aiChatService.sendStream(TenantContextHolder.getRequiredTenantId(), getLoginUserId(),
                UserTypeEnum.ADMIN.name(), request);
    }

}

