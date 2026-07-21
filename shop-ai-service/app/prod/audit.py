"""Lightweight call audit + rough token usage accounting."""

from __future__ import annotations

import json
import logging
import sqlite3
import threading
import time
from pathlib import Path

logger = logging.getLogger("shop_ai.audit")


def estimate_tokens(text: str) -> int:
    if not text:
        return 0
    # Rough hybrid estimator: CJK ~1 token/char, latin ~1 token/4 chars.
    cjk = sum(1 for ch in text if "\u4e00" <= ch <= "\u9fff")
    other = max(len(text) - cjk, 0)
    return cjk + max(other // 4, 1 if other else 0)


class AuditLogger:
    def __init__(self, db_path: str | Path) -> None:
        path = Path(db_path)
        if not path.is_absolute():
            path = Path(__file__).resolve().parents[2] / path
        self.db_path = path
        self._lock = threading.Lock()
        self._ready = False

    def _ensure(self) -> None:
        if self._ready:
            return
        with self._lock:
            if self._ready:
                return
            self.db_path.parent.mkdir(parents=True, exist_ok=True)
            with self._connect() as conn:
                conn.execute(
                    """
                    CREATE TABLE IF NOT EXISTS ai_audit_log (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        ts REAL NOT NULL,
                        tenant_id INTEGER,
                        user_id INTEGER,
                        user_type TEXT,
                        conversation_id TEXT,
                        path TEXT,
                        status TEXT,
                        latency_ms INTEGER,
                        input_tokens INTEGER,
                        output_tokens INTEGER,
                        detail TEXT
                    )
                    """
                )
            self._ready = True

    def write(
        self,
        *,
        tenant_id: int | None,
        user_id: int | None,
        user_type: str | None,
        conversation_id: str | None,
        path: str,
        status: str,
        latency_ms: int,
        input_tokens: int = 0,
        output_tokens: int = 0,
        detail: dict | None = None,
    ) -> None:
        self._ensure()
        payload = json.dumps(detail or {}, ensure_ascii=False)[:2000]
        with self._lock:
            with self._connect() as conn:
                conn.execute(
                    """
                    INSERT INTO ai_audit_log(
                        ts, tenant_id, user_id, user_type, conversation_id, path,
                        status, latency_ms, input_tokens, output_tokens, detail
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    (
                        time.time(),
                        tenant_id,
                        user_id,
                        user_type,
                        conversation_id,
                        path,
                        status,
                        latency_ms,
                        input_tokens,
                        output_tokens,
                        payload,
                    ),
                )
        logger.info(
            "audit path=%s status=%s tenant=%s user=%s latency_ms=%s in_tok=%s out_tok=%s",
            path,
            status,
            tenant_id,
            user_id,
            latency_ms,
            input_tokens,
            output_tokens,
        )

    def _connect(self) -> sqlite3.Connection:
        return sqlite3.connect(self.db_path, timeout=10)


_audit: AuditLogger | None = None
_audit_lock = threading.Lock()


def get_audit_logger() -> AuditLogger:
    global _audit
    if _audit is not None:
        return _audit
    with _audit_lock:
        if _audit is None:
            from app.settings import settings

            _audit = AuditLogger(settings.audit_db_path)
        return _audit