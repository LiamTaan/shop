"""Per-user sliding-window rate limiting with a Redis-backed multi-instance mode."""

from __future__ import annotations

import threading
import time
import logging
from collections import defaultdict, deque

logger = logging.getLogger(__name__)


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


class RedisSlidingWindowRateLimiter:
    """Atomic Redis limiter. Redis failures fall back to the local limiter."""

    _SCRIPT = """
    local cutoff = tonumber(ARGV[1]) - tonumber(ARGV[2])
    redis.call('ZREMRANGEBYSCORE', KEYS[1], 0, cutoff)
    local count = redis.call('ZCARD', KEYS[1])
    local maximum = tonumber(ARGV[3])
    if count >= maximum then
      local oldest = redis.call('ZRANGE', KEYS[1], 0, 0, 'WITHSCORES')
      if oldest[2] then
        return {0, tonumber(ARGV[2]) - (tonumber(ARGV[1]) - tonumber(oldest[2]))}
      end
      return {0, tonumber(ARGV[2])}
    end
    redis.call('ZADD', KEYS[1], ARGV[1], ARGV[4])
    redis.call('EXPIRE', KEYS[1], math.ceil(tonumber(ARGV[2])))
    return {1, 0}
    """

    def __init__(self, redis_url: str, max_requests: int, window_seconds: float) -> None:
        import redis

        self.client = redis.Redis.from_url(redis_url, decode_responses=True)
        self.max_requests = max(1, max_requests)
        self.window_seconds = max(1.0, window_seconds)
        self.fallback = SlidingWindowRateLimiter(self.max_requests, self.window_seconds)

    def check(self, key: str) -> None:
        now = time.time()
        try:
            result = self.client.eval(
                self._SCRIPT,
                1,
                f"shop-ai:rate-limit:{key}",
                now,
                self.window_seconds,
                self.max_requests,
                f"{now}:{threading.get_ident()}:{time.perf_counter_ns()}",
            )
        except Exception:
            logger.warning("Redis rate limiter request failed; using local fallback", exc_info=True)
            self.fallback.check(key)
            return
        if int(result[0]) == 0:
            raise RateLimitExceeded(max(float(result[1]), 0.1))


_limiter: SlidingWindowRateLimiter | RedisSlidingWindowRateLimiter | None = None
_limiter_lock = threading.Lock()


def get_rate_limiter() -> SlidingWindowRateLimiter:
    global _limiter
    if _limiter is not None:
        return _limiter
    with _limiter_lock:
        if _limiter is None:
            from app.settings import settings

            local_limiter = SlidingWindowRateLimiter(settings.rate_limit_per_minute, 60.0)
            if settings.redis_url:
                try:
                    redis_limiter = RedisSlidingWindowRateLimiter(
                        settings.redis_url, settings.rate_limit_per_minute, 60.0
                    )
                    redis_limiter.client.ping()
                    _limiter = redis_limiter
                except Exception:
                    logger.warning("Redis rate limiter unavailable; using local fallback", exc_info=True)
                    _limiter = local_limiter
            else:
                _limiter = local_limiter
        return _limiter


def rate_limit_key(*, tenant_id: int, user_id: int, user_type: str) -> str:
    return f"{tenant_id}:{user_type}:{user_id}"
