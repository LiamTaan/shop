package cn.iocoder.yudao.module.ai.framework.client;

import cn.iocoder.yudao.framework.common.util.json.JsonUtils;
import cn.iocoder.yudao.module.ai.framework.client.dto.AiServiceChatReqDTO;
import cn.iocoder.yudao.module.ai.framework.config.AiServiceProperties;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.function.BiConsumer;

@Component
public class AiServiceClient {

    private final RestTemplate restTemplate;
    private final AiServiceProperties properties;

    public AiServiceClient(@Qualifier("aiServiceRestTemplate") RestTemplate restTemplate,
                           AiServiceProperties properties) {
        this.restTemplate = restTemplate;
        this.properties = properties;
    }

    public void streamChat(AiServiceChatReqDTO request, BiConsumer<String, String> eventConsumer) {
        String url = properties.getBaseUrl() + "/internal/v1/chat/stream";
        restTemplate.execute(url, org.springframework.http.HttpMethod.POST, clientRequest -> {
            clientRequest.getHeaders().setContentType(MediaType.APPLICATION_JSON);
            clientRequest.getHeaders().setAccept(java.util.Collections.singletonList(MediaType.TEXT_EVENT_STREAM));
            if (properties.getInternalToken() != null && !properties.getInternalToken().isEmpty()) {
                clientRequest.getHeaders().set(HttpHeaders.AUTHORIZATION,
                        "Bearer " + properties.getInternalToken());
            }
            clientRequest.getBody().write(JsonUtils.toJsonByte(request));
        }, response -> {
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(
                    response.getBody(), StandardCharsets.UTF_8))) {
                String eventName = "message";
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.startsWith("event:")) {
                        eventName = line.substring("event:".length()).trim();
                    } else if (line.startsWith("data:")) {
                        eventConsumer.accept(eventName, line.substring("data:".length()).trim());
                    }
                }
            }
            return null;
        });
    }

}
