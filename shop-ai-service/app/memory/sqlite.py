import sqlite3
import threading
from pathlib import Path

from app.api.schemas import ChatRequest


class ConversationMemory:
    def __init__(self, db_path: str, max_messages: int = 12) -> None:
        path = Path(db_path)
        if not path.is_absolute():
            path = Path(__file__).resolve().parents[2] / path
        self.db_path = path
        self.max_messages = max(max_messages, 1)
        self._initialized = False
        self._lock = threading.Lock()

    def get_recent(self, request: ChatRequest) -> list[dict[str, str]]:
        if not request.use_context or not request.conversation_id:
            return []
        self._initialize()
        with self._connect() as connection:
            rows = connection.execute(
                """
                SELECT role, content
                FROM ai_conversation_message
                WHERE tenant_id = ? AND user_id = ? AND user_type = ? AND conversation_id = ?
                ORDER BY id DESC
                LIMIT ?
                """,
                (
                    request.tenant_id,
                    request.user_id,
                    request.user_type,
                    request.conversation_id,
                    self.max_messages,
                ),
            ).fetchall()
        return [{"role": row[0], "content": row[1]} for row in reversed(rows)]

    def append_exchange(self, request: ChatRequest, user_content: str, assistant_content: str) -> None:
        if not request.use_context or not request.conversation_id or not assistant_content:
            return
        self._initialize()
        values = (
            request.tenant_id,
            request.user_id,
            request.user_type,
            request.conversation_id,
        )
        with self._connect() as connection:
            connection.executemany(
                """
                INSERT INTO ai_conversation_message
                    (tenant_id, user_id, user_type, conversation_id, role, content)
                VALUES (?, ?, ?, ?, ?, ?)
                """,
                [
                    (*values, "user", user_content),
                    (*values, "assistant", assistant_content),
                ],
            )
            connection.execute(
                """
                DELETE FROM ai_conversation_message
                WHERE tenant_id = ? AND user_id = ? AND user_type = ? AND conversation_id = ?
                  AND id NOT IN (
                    SELECT id FROM ai_conversation_message
                    WHERE tenant_id = ? AND user_id = ? AND user_type = ? AND conversation_id = ?
                    ORDER BY id DESC LIMIT ?
                  )
                """,
                (*values, *values, self.max_messages),
            )

    def _initialize(self) -> None:
        if self._initialized:
            return
        with self._lock:
            if self._initialized:
                return
            self.db_path.parent.mkdir(parents=True, exist_ok=True)
            with self._connect() as connection:
                connection.execute(
                    """
                    CREATE TABLE IF NOT EXISTS ai_conversation_message (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        tenant_id INTEGER NOT NULL,
                        user_id INTEGER NOT NULL,
                        user_type TEXT NOT NULL,
                        conversation_id TEXT NOT NULL,
                        role TEXT NOT NULL,
                        content TEXT NOT NULL,
                        create_time TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
                    )
                    """
                )
                connection.execute(
                    """
                    CREATE INDEX IF NOT EXISTS idx_ai_conversation_message_scope
                    ON ai_conversation_message
                        (tenant_id, user_id, user_type, conversation_id, id)
                    """
                )
            self._initialized = True

    def _connect(self) -> sqlite3.Connection:
        return sqlite3.connect(self.db_path, timeout=10)
