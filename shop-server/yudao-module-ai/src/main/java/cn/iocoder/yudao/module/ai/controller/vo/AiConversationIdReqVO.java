package cn.iocoder.yudao.module.ai.controller.vo;

import lombok.Data;

import jakarta.validation.constraints.NotBlank;

@Data
public class AiConversationIdReqVO {

    @NotBlank(message = "conversationId cannot be empty")
    private String conversationId;

}