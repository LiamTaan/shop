"""Prompt-injection heuristics and sensitive field redaction."""

from __future__ import annotations

import re
from typing import Any

_INJECTION_PATTERNS = [
    re.compile(r"ignore\s+(all\s+)?(previous|prior|above)\s+instructions", re.I),
    re.compile(r"disregard\s+(all\s+)?(previous|prior)\s+(rules|instructions)", re.I),
    re.compile(r"system\s*prompt", re.I),
    re.compile(r"you\s+are\s+now\s+(dan|unrestricted|jailbreak)", re.I),
    re.compile(r"忽略(以上|之前|全部)?(指令|提示|规则)", re.I),
    re.compile(r"越狱|jailbreak", re.I),
    re.compile(r"reveal\s+(your\s+)?(system|hidden)\s+prompt", re.I),
]

_MOBILE_RE = re.compile(r"(?<!\d)(1[3-9]\d)\d{4}(\d{4})(?!\d)")
_ID_CARD_RE = re.compile(r"(?<!\d)(\d{6})\d{8}(\d{3}[\dXx])(?!\d)")
_SENSITIVE_KEYS = {
    "password",
    "passwd",
    "secret",
    "token",
    "accessToken",
    "refreshToken",
    "idCard",
    "id_card",
    "bankCard",
    "bank_card",
    "receiverMobile",
    "mobile",
    "phone",
}


def looks_like_injection(text: str) -> bool:
    if not text:
        return False
    sample = text.strip()
    if len(sample) > 4000:
        # very long prompts are suspicious for injection dumps
        return True
    return any(p.search(sample) for p in _INJECTION_PATTERNS)


def sanitize_user_message(text: str) -> str:
    """Strip common injection phrases; keep readable Chinese/English content."""
    cleaned = text or ""
    for pattern in _INJECTION_PATTERNS:
        cleaned = pattern.sub("[filtered]", cleaned)
    # collapse extreme whitespace
    cleaned = re.sub(r"[ \t]{3,}", "  ", cleaned)
    return cleaned.strip()[:8000]


def mask_mobile(text: str) -> str:
    return _MOBILE_RE.sub(r"\1****\2", text)


def mask_id_card(text: str) -> str:
    return _ID_CARD_RE.sub(r"\1********\2", text)


def redact_text(text: str) -> str:
    if not text:
        return text
    return mask_id_card(mask_mobile(text))


def redact_value(value: Any, *, key: str | None = None) -> Any:
    if key and key in _SENSITIVE_KEYS:
        if value is None:
            return None
        if isinstance(value, str) and len(value) <= 4:
            return "****"
        if isinstance(value, str):
            return redact_text(value) if key in {"mobile", "phone", "receiverMobile"} else "******"
        return "******"
    if isinstance(value, str):
        return redact_text(value)
    if isinstance(value, list):
        return [redact_value(item) for item in value]
    if isinstance(value, dict):
        return {k: redact_value(v, key=str(k)) for k, v in value.items()}
    return value


def redact_payload(payload: Any) -> Any:
    return redact_value(payload)