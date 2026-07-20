package cn.iocoder.yudao.module.ai.framework.client.dto;

import lombok.Data;
import lombok.experimental.Accessors;

import java.util.Collections;
import java.util.Map;

@Data
@Accessors(chain = true)
public class AiServiceChatReqDTO {

    private Long tenantId;
    private Long userId;
    private String userType;
    private String conversationId;
    private String message;
    private Boolean useContext;
    private Map<String, Object> toolContext = Collections.emptyMap();

}

