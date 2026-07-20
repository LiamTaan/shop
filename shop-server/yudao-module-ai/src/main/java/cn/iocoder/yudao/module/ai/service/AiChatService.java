package cn.iocoder.yudao.module.ai.service;

import cn.iocoder.yudao.module.ai.controller.vo.AiChatMessageSendReqVO;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

public interface AiChatService {

    SseEmitter sendStream(Long tenantId, Long userId, String userType, AiChatMessageSendReqVO request);

}

