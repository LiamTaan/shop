package cn.iocoder.yudao.module.ai.service;

import cn.iocoder.yudao.framework.common.util.json.JsonUtils;
import cn.iocoder.yudao.module.ai.controller.vo.AiChatMessageSendReqVO;
import cn.iocoder.yudao.module.ai.controller.vo.AiConversationIdReqVO;
import cn.iocoder.yudao.module.ai.controller.vo.AiConversationRenameReqVO;
import cn.iocoder.yudao.module.ai.framework.client.AiServiceClient;
import cn.iocoder.yudao.module.ai.framework.client.dto.AiServiceChatReqDTO;
import cn.iocoder.yudao.module.ai.framework.client.dto.AiServiceConversationIdReqDTO;
import cn.iocoder.yudao.module.ai.framework.client.dto.AiServiceConversationRenameReqDTO;
import cn.iocoder.yudao.module.ai.framework.client.dto.AiServiceConversationScopeReqDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Collections;
import java.util.Map;
import java.util.concurrent.Executor;

@Service
@Slf4j
public class AiChatServiceImpl implements AiChatService {

    private static final long SSE_TIMEOUT_MILLIS = 120_000L;

    private final AiServiceClient aiServiceClient;
    private final Executor aiStreamExecutor;

    public AiChatServiceImpl(AiServiceClient aiServiceClient,
                             @Qualifier("aiStreamExecutor") Executor aiStreamExecutor) {
        this.aiServiceClient = aiServiceClient;
        this.aiStreamExecutor = aiStreamExecutor;
    }

    @Override
    public SseEmitter sendStream(Long tenantId, Long userId, String userType,
                                 AiChatMessageSendReqVO request) {
        SseEmitter emitter = new SseEmitter(SSE_TIMEOUT_MILLIS);
        AiServiceChatReqDTO serviceRequest = new AiServiceChatReqDTO()
                .setTenantId(tenantId)
                .setUserId(userId)
                .setUserType(userType)
                .setConversationId(request.getConversationId())
                .setMessage(request.getContent())
                .setUseContext(!Boolean.FALSE.equals(request.getUseContext()))
                .setToolContext(Collections.emptyMap());

        aiStreamExecutor.execute(() -> doStream(serviceRequest, emitter));
        return emitter;
    }

    @Override
    public Map<String, Object> listConversations(Long tenantId, Long userId, String userType) {
        return aiServiceClient.listConversations(new AiServiceConversationScopeReqDTO()
                .setTenantId(tenantId)
                .setUserId(userId)
                .setUserType(userType)
                .setLimit(30));
    }

    @Override
    public Map<String, Object> getConversationMessages(Long tenantId, Long userId, String userType,
                                                       AiConversationIdReqVO request) {
        return aiServiceClient.getConversationMessages(new AiServiceConversationIdReqDTO()
                .setTenantId(tenantId)
                .setUserId(userId)
                .setUserType(userType)
                .setConversationId(request.getConversationId())
                .setLimit(50));
    }

    @Override
    public Map<String, Object> renameConversation(Long tenantId, Long userId, String userType,
                                                  AiConversationRenameReqVO request) {
        return aiServiceClient.renameConversation(new AiServiceConversationRenameReqDTO()
                .setTenantId(tenantId)
                .setUserId(userId)
                .setUserType(userType)
                .setConversationId(request.getConversationId())
                .setTitle(request.getTitle()));
    }

    @Override
    public Map<String, Object> deleteConversation(Long tenantId, Long userId, String userType,
                                                  AiConversationIdReqVO request) {
        return aiServiceClient.deleteConversation(new AiServiceConversationIdReqDTO()
                .setTenantId(tenantId)
                .setUserId(userId)
                .setUserType(userType)
                .setConversationId(request.getConversationId()));
    }

    private void doStream(AiServiceChatReqDTO request, SseEmitter emitter) {
        try {
            aiServiceClient.streamChat(request, (event, data) -> sendEvent(emitter, event, data));
            emitter.complete();
        } catch (Exception ex) {
            log.error("AI stream proxy failed for user {}", request.getUserId(), ex);
            emitter.completeWithError(ex);
        }
    }

    private void sendEvent(SseEmitter emitter, String event, String data) {
        try {
            Object eventData = JsonUtils.parseObject(data, Object.class);
            emitter.send(SseEmitter.event().name(event).data(eventData, MediaType.APPLICATION_JSON));
        } catch (IOException ex) {
            throw new IllegalStateException("Failed to forward AI stream event", ex);
        }
    }

}