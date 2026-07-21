package cn.iocoder.yudao.module.ai.controller.app.chat;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.tenant.core.context.TenantContextHolder;
import cn.iocoder.yudao.module.ai.controller.vo.AiChatMessageSendReqVO;
import cn.iocoder.yudao.module.ai.controller.vo.AiConversationIdReqVO;
import cn.iocoder.yudao.module.ai.controller.vo.AiConversationRenameReqVO;
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

import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import java.util.Map;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import static cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils.getLoginUserId;

@Tag(name = "App - AI chat")
@RestController
@RequestMapping("/ai/chat/message")
@Validated
public class AppAiChatMessageController {

    @Resource
    private AiChatService aiChatService;

    @PostMapping(value = "/send-stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    @Operation(summary = "Send a streaming AI chat message")
    public SseEmitter sendStream(@Valid @RequestBody AiChatMessageSendReqVO request) {
        return aiChatService.sendStream(TenantContextHolder.getRequiredTenantId(), getLoginUserId(),
                "APP", request);
    }

    @PostMapping("/conversation/list")
    @Operation(summary = "List AI conversations")
    public CommonResult<Map<String, Object>> listConversations() {
        return success(aiChatService.listConversations(TenantContextHolder.getRequiredTenantId(),
                getLoginUserId(), "APP"));
    }

    @PostMapping("/conversation/messages")
    @Operation(summary = "Get AI conversation messages")
    public CommonResult<Map<String, Object>> getMessages(@Valid @RequestBody AiConversationIdReqVO request) {
        return success(aiChatService.getConversationMessages(TenantContextHolder.getRequiredTenantId(),
                getLoginUserId(), "APP", request));
    }

    @PostMapping("/conversation/rename")
    @Operation(summary = "Rename AI conversation")
    public CommonResult<Map<String, Object>> rename(@Valid @RequestBody AiConversationRenameReqVO request) {
        return success(aiChatService.renameConversation(TenantContextHolder.getRequiredTenantId(),
                getLoginUserId(), "APP", request));
    }

    @PostMapping("/conversation/delete")
    @Operation(summary = "Delete AI conversation")
    public CommonResult<Map<String, Object>> delete(@Valid @RequestBody AiConversationIdReqVO request) {
        return success(aiChatService.deleteConversation(TenantContextHolder.getRequiredTenantId(),
                getLoginUserId(), "APP", request));
    }

}