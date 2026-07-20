package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;

@Data
public class AiProductSearchReqVO {

    @NotBlank(message = "Keyword cannot be empty")
    private String keyword;

    @Min(value = 1, message = "Limit must be at least 1")
    @Max(value = 10, message = "Limit cannot exceed 10")
    private Integer limit = 5;

}

