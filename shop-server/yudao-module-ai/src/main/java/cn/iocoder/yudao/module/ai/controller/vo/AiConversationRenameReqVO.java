package cn.iocoder.yudao.module.ai.controller.vo;

import lombok.Data;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Data
public class AiConversationRenameReqVO {

    @NotBlank(message = "conversationId cannot be empty")
    private String conversationId;

    @NotBlank(message = "title cannot be empty")
    @Size(max = 80, message = "title too long")
    private String title;

}