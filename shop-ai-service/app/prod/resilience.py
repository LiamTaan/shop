"""Simple circuit breaker + retry helpers for outbound calls."""

from __future__ import annotations

import threading
import time
from collections.abc import Callable
from typing import TypeVar

T = TypeVar("T")


class CircuitOpenError(Exception):
    pass


class CircuitBreaker:
    def __init__(self, *, failure_threshold: int = 5, recovery_seconds: float = 30.0) -> None:
        self.failure_threshold = max(1, failure_threshold)
        self.recovery_seconds = max(1.0, recovery_seconds)
        self._failures = 0
        self._opened_at: float | None = None
        self._lock = threading.Lock()

    def before_call(self) -> None:
        with self._lock:
            if self._opened_at is None:
                return
            if time.monotonic() - self._opened_at >= self.recovery_seconds:
                # half-open: allow one probe
                return
            raise CircuitOpenError("circuit open")

    def record_success(self) -> None:
        with self._lock:
            self._failures = 0
            self._opened_at = None

    def record_failure(self) -> None:
        with self._lock:
            self._failures += 1
            if self._failures >= self.failure_threshold:
                self._opened_at = time.monotonic()


def with_retry(
    fn: Callable[[], T],
    *,
    attempts: int = 2,
    backoff_seconds: float = 0.2,
    retry_on: tuple[type[BaseException], ...] = (Exception,),
    breaker: CircuitBreaker | None = None,
) -> T:
    last: BaseException | None = None
    tries = max(1, attempts)
    for i in range(tries):
        if breaker is not None:
            breaker.before_call()
        try:
            result = fn()
            if breaker is not None:
                breaker.record_success()
            return result
        except CircuitOpenError:
            raise
        except retry_on as exc:  # type: ignore[misc]
            last = exc
            if breaker is not None:
                breaker.record_failure()
            if i + 1 >= tries:
                break
            time.sleep(backoff_seconds * (i + 1))
    assert last is not None
    raise last


_shop_breaker = CircuitBreaker(failure_threshold=5, recovery_seconds=30.0)
_llm_breaker = CircuitBreaker(failure_threshold=5, recovery_seconds=30.0)


def shop_breaker() -> CircuitBreaker:
    return _shop_breaker


def llm_breaker() -> CircuitBreaker:
    return _llm_breaker