package cn.iocoder.yudao.module.ai.framework.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

import javax.validation.constraints.NotBlank;
import java.time.Duration;

@ConfigurationProperties(prefix = "yudao.ai.service")
@Validated
@Data
public class AiServiceProperties {

    @NotBlank
    private String baseUrl = "http://127.0.0.1:8000";

    private String internalToken;

    private Duration connectTimeout = Duration.ofSeconds(5);

    private Duration readTimeout = Duration.ofMinutes(2);

}

