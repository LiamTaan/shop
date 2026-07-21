"""In-process rate limiter (per tenant+user). Multi-instance: set REDIS_URL later."""

from __future__ import annotations

import threading
import time
from collections import defaultdict, deque


class RateLimitExceeded(Exception):
    def __init__(self, retry_after: float) -> None:
        super().__init__("rate limit exceeded")
        self.retry_after = retry_after


class SlidingWindowRateLimiter:
    def __init__(self, max_requests: int, window_seconds: float) -> None:
        self.max_requests = max(1, max_requests)
        self.window_seconds = max(1.0, window_seconds)
        self._hits: dict[str, deque[float]] = defaultdict(deque)
        self._lock = threading.Lock()

    def check(self, key: str) -> None:
        now = time.monotonic()
        with self._lock:
            bucket = self._hits[key]
            cutoff = now - self.window_seconds
            while bucket and bucket[0] < cutoff:
                bucket.popleft()
            if len(bucket) >= self.max_requests:
                retry_after = self.window_seconds - (now - bucket[0])
                raise RateLimitExceeded(max(retry_after, 0.1))
            bucket.append(now)


_limiter: SlidingWindowRateLimiter | None = None
_limiter_lock = threading.Lock()


def get_rate_limiter() -> SlidingWindowRateLimiter:
    global _limiter
    if _limiter is not None:
        return _limiter
    with _limiter_lock:
        if _limiter is None:
            from app.settings import settings

            _limiter = SlidingWindowRateLimiter(
                max_requests=settings.rate_limit_per_minute,
                window_seconds=60.0,
            )
        return _limiter


def rate_limit_key(*, tenant_id: int, user_id: int, user_type: str) -> str:
    return f"{tenant_id}:{user_type}:{user_id}"