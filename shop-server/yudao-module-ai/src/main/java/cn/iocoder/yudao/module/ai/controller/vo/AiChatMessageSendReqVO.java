package cn.iocoder.yudao.module.ai.controller.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.List;

@Schema(description = "AI chat stream request")
@Data
public class AiChatMessageSendReqVO {

    @Schema(description = "Conversation id")
    private String conversationId;

    @Schema(description = "Message content", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "Message content cannot be empty")
    @Size(max = 8000, message = "Message content cannot exceed 8000 characters")
    private String content;

    @Schema(description = "Use conversation context")
    private Boolean useContext;

    @Schema(description = "Use web search")
    private Boolean useSearch;

    @Schema(description = "Attachment URLs")
    private List<String> attachmentUrls;

}
