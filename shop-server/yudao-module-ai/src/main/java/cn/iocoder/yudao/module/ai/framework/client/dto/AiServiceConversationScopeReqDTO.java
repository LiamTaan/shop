package cn.iocoder.yudao.module.ai.framework.client.dto;

import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class AiServiceConversationScopeReqDTO {

    private Long tenantId;
    private Long userId;
    private String userType;
    private Integer limit = 30;

}