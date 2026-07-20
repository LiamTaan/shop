from collections.abc import Iterable
from typing import Protocol

from app.api.schemas import ChatRequest


class LlmProvider(Protocol):
    def stream(self, request: ChatRequest) -> Iterable[str]: ...

