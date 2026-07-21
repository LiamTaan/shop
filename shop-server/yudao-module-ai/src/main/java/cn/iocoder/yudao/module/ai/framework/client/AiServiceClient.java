package cn.iocoder.yudao.module.ai.framework.client;

import cn.iocoder.yudao.framework.common.util.json.JsonUtils;
import cn.iocoder.yudao.module.ai.framework.client.dto.AiServiceChatReqDTO;
import cn.iocoder.yudao.module.ai.framework.client.dto.AiServiceConversationIdReqDTO;
import cn.iocoder.yudao.module.ai.framework.client.dto.AiServiceConversationRenameReqDTO;
import cn.iocoder.yudao.module.ai.framework.client.dto.AiServiceConversationScopeReqDTO;
import cn.iocoder.yudao.module.ai.framework.config.AiServiceProperties;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.Map;
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
            clientRequest.getHeaders().setAccept(Collections.singletonList(MediaType.TEXT_EVENT_STREAM));
            applyAuth(clientRequest.getHeaders());
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

    @SuppressWarnings("unchecked")
    public Map<String, Object> listConversations(AiServiceConversationScopeReqDTO request) {
        return postForMap("/internal/v1/conversations/list", request);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getConversationMessages(AiServiceConversationIdReqDTO request) {
        return postForMap("/internal/v1/conversations/messages", request);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> renameConversation(AiServiceConversationRenameReqDTO request) {
        return postForMap("/internal/v1/conversations/rename", request);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> deleteConversation(AiServiceConversationIdReqDTO request) {
        return postForMap("/internal/v1/conversations/delete", request);
    }

    private Map<String, Object> postForMap(String path, Object body) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        applyAuth(headers);
        ResponseEntity<Map> response = restTemplate.postForEntity(
                properties.getBaseUrl() + path,
                new HttpEntity<>(body, headers),
                Map.class);
        return response.getBody() == null ? Collections.emptyMap() : response.getBody();
    }

    private void applyAuth(HttpHeaders headers) {
        if (properties.getInternalToken() != null && !properties.getInternalToken().isEmpty()) {
            headers.set(HttpHeaders.AUTHORIZATION, "Bearer " + properties.getInternalToken());
        }
    }

}