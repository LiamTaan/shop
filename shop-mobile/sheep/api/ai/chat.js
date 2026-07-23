import { apiPath, baseUrl } from '@/sheep/config';
import request, { getAccessToken, getTenantId } from '@/sheep/request';

function parseEvents(state, chunk, onEvent) {
  state.buffer += chunk;
  const blocks = state.buffer.split('\n\n');
  state.buffer = blocks.pop() || '';
  blocks.forEach((block) => {
    let event = 'message';
    let data = '';
    block.split('\n').forEach((line) => {
      if (line.startsWith('event:')) event = line.slice(6).trim();
      if (line.startsWith('data:')) data += line.slice(5).trim();
    });
    if (!data) return;
    try {
      onEvent?.(event, JSON.parse(data));
    } catch (error) {
      onEvent?.('error', { message: 'Invalid AI stream event', cause: error });
    }
  });
}

function decodeChunk(state, buffer) {
  if (typeof TextDecoder !== 'undefined') {
    state.decoder ||= new TextDecoder('utf-8');
    return state.decoder.decode(buffer, { stream: true });
  }
  const bytes = new Uint8Array(buffer);
  let encoded = '';
  bytes.forEach((byte) => {
    encoded += `%${byte.toString(16).padStart(2, '0')}`;
  });
  return decodeURIComponent(encoded);
}

const ChatApi = {
  listConversations: () =>
    request({
      url: '/ai/chat/message/conversation/list',
      method: 'POST',
      data: {},
    }),

  getConversationMessages: (conversationId) =>
    request({
      url: '/ai/chat/message/conversation/messages',
      method: 'POST',
      data: { conversationId },
    }),

  renameConversation: (conversationId, title) =>
    request({
      url: '/ai/chat/message/conversation/rename',
      method: 'POST',
      data: { conversationId, title },
    }),

  deleteConversation: (conversationId) =>
    request({
      url: '/ai/chat/message/conversation/delete',
      method: 'POST',
      data: { conversationId },
    }),

  sendStream: (data, { onEvent, onError, onClose } = {}) => {
    const token = getAccessToken();
    if (!token) {
      const error = new Error('Authentication is required for AI chat');
      onError?.(error);
      return { abort: () => {} };
    }
    const headers = {
      'Content-Type': 'application/json',
      Accept: 'text/event-stream',
      Authorization: token?.startsWith('Bearer ') ? token : `Bearer ${token}`,
      'tenant-id': `${getTenantId() || ''}`,
    };
    const state = { buffer: '', decoder: null };

    // #ifdef H5
    const controller = new AbortController();
    fetch(`${baseUrl}${apiPath}/ai/chat/message/send-stream`, {
      method: 'POST',
      headers,
      body: JSON.stringify(data),
      signal: controller.signal,
    })
      .then(async (response) => {
        if (!response.ok || !response.body)
          throw new Error(`AI request failed: ${response.status}`);
        const reader = response.body.getReader();
        const decoder = new TextDecoder('utf-8');
        while (true) {
          const { done, value } = await reader.read();
          if (done) break;
          parseEvents(state, decoder.decode(value, { stream: true }), onEvent);
        }
        parseEvents(state, decoder.decode(), onEvent);
        onClose?.();
      })
      .catch((error) => {
        if (error.name !== 'AbortError') onError?.(error);
      });
    return { abort: () => controller.abort() };
    // #endif

    // #ifndef H5
    const task = uni.request({
      url: `${baseUrl}${apiPath}/ai/chat/message/send-stream`,
      method: 'POST',
      header: headers,
      data,
      enableChunked: true,
      success: () => onClose?.(),
      fail: (error) => onError?.(error),
    });
    task.onChunkReceived?.(({ data: chunk }) => {
      parseEvents(state, decodeChunk(state, chunk), onEvent);
    });
    return { abort: () => task.abort() };
    // #endif
  },
};

export default ChatApi;
