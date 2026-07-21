package cn.iocoder.yudao.module.ai.service;

import cn.iocoder.yudao.module.ai.controller.vo.AiChatMessageSendReqVO;
import cn.iocoder.yudao.module.ai.controller.vo.AiConversationIdReqVO;
import cn.iocoder.yudao.module.ai.controller.vo.AiConversationRenameReqVO;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.Map;

public interface AiChatService {

    SseEmitter sendStream(Long tenantId, Long userId, String userType, AiChatMessageSendReqVO request);

    Map<String, Object> listConversations(Long tenantId, Long userId, String userType);

    Map<String, Object> getConversationMessages(Long tenantId, Long userId, String userType,
                                                AiConversationIdReqVO request);

    Map<String, Object> renameConversation(Long tenantId, Long userId, String userType,
                                           AiConversationRenameReqVO request);

    Map<String, Object> deleteConversation(Long tenantId, Long userId, String userType,
                                           AiConversationIdReqVO request);

}