package cn.iocoder.yudao.module.ai.framework.client.dto;

import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class AiServiceConversationRenameReqDTO {

    private Long tenantId;
    private Long userId;
    private String userType;
    private String conversationId;
    private String title;

}