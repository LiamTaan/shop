"""Local knowledge retrieval for FAQ / policies.

Uses SQLite FTS5 when available, otherwise a plain table + LIKE fallback.
Product price and stock must still come from live tools, never from documents.
"""

from __future__ import annotations

import re
import sqlite3
import threading
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class KnowledgeChunk:
    doc_id: str
    title: str
    content: str
    score: float = 0.0


def _default_knowledge_dir() -> Path:
    return Path(__file__).resolve().parents[2] / "knowledge"


def _default_db_path() -> Path:
    return Path(__file__).resolve().parents[2] / "data" / "shop-ai-knowledge.db"


def chunk_markdown(text: str, *, max_chars: int = 600) -> list[str]:
    parts = [p.strip() for p in re.split(r"\n\s*\n", text) if p.strip()]
    if not parts:
        return []
    chunks: list[str] = []
    buf = ""
    for part in parts:
        candidate = f"{buf}\n\n{part}".strip() if buf else part
        if len(candidate) <= max_chars:
            buf = candidate
            continue
        if buf:
            chunks.append(buf)
        if len(part) <= max_chars:
            buf = part
        else:
            for i in range(0, len(part), max_chars):
                chunks.append(part[i : i + max_chars])
            buf = ""
    if buf:
        chunks.append(buf)
    return chunks


class KnowledgeStore:
    def __init__(self, db_path: str | Path | None = None, knowledge_dir: str | Path | None = None) -> None:
        path = Path(db_path) if db_path else _default_db_path()
        if not path.is_absolute():
            path = Path(__file__).resolve().parents[2] / path
        self.db_path = path
        kdir = Path(knowledge_dir) if knowledge_dir else _default_knowledge_dir()
        if not kdir.is_absolute():
            kdir = Path(__file__).resolve().parents[2] / kdir
        self.knowledge_dir = kdir
        self._lock = threading.Lock()
        self._ready = False
        self._use_fts = True

    def ensure_ready(self) -> None:
        if self._ready:
            return
        with self._lock:
            if self._ready:
                return
            self.db_path.parent.mkdir(parents=True, exist_ok=True)
            with self._connect() as conn:
                self._init_schema(conn)
                count = conn.execute("SELECT count(*) FROM knowledge_chunk").fetchone()[0]
                if count == 0:
                    self._ingest_files(conn)
            self._ready = True

    def reindex(self) -> int:
        with self._lock:
            self.db_path.parent.mkdir(parents=True, exist_ok=True)
            with self._connect() as conn:
                self._init_schema(conn)
                conn.execute("DELETE FROM knowledge_chunk")
                inserted = self._ingest_files(conn)
            self._ready = True
            return inserted

    def retrieve(self, query: str, *, top_k: int = 4) -> list[KnowledgeChunk]:
        self.ensure_ready()
        q = (query or "").strip()
        if not q:
            return []
        limit = max(1, min(top_k, 10))
        with self._connect() as conn:
            rows: list = []
            if self._use_fts:
                terms = self._fts_query(q)
                if terms:
                    try:
                        rows = conn.execute(
                            """
                            SELECT doc_id, title, content, bm25(knowledge_chunk) AS rank
                            FROM knowledge_chunk
                            WHERE knowledge_chunk MATCH ?
                            ORDER BY rank
                            LIMIT ?
                            """,
                            (terms, limit),
                        ).fetchall()
                    except sqlite3.OperationalError:
                        rows = []
            if not rows:
                rows = self._like_search(conn, q, limit)
        return [
            KnowledgeChunk(doc_id=row[0], title=row[1], content=row[2], score=float(row[3] or 0))
            for row in rows
        ]

    def format_context(self, chunks: list[KnowledgeChunk]) -> str:
        if not chunks:
            return ""
        blocks = []
        for idx, chunk in enumerate(chunks, start=1):
            blocks.append(f"[{idx}] {chunk.title} ({chunk.doc_id})\n{chunk.content.strip()}")
        return (
            "Knowledge base excerpts (policies/FAQ only). "
            "Do not use them for live product price or stock.\n\n"
            + "\n\n".join(blocks)
        )

    def _init_schema(self, conn: sqlite3.Connection) -> None:
        try:
            conn.execute(
                """
                CREATE VIRTUAL TABLE IF NOT EXISTS knowledge_chunk
                USING fts5(
                    doc_id UNINDEXED,
                    title,
                    content,
                    tokenize = 'unicode61 remove_diacritics 2'
                )
                """
            )
            self._use_fts = True
        except sqlite3.OperationalError:
            self._use_fts = False
            conn.execute(
                """
                CREATE TABLE IF NOT EXISTS knowledge_chunk (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    doc_id TEXT NOT NULL,
                    title TEXT NOT NULL,
                    content TEXT NOT NULL
                )
                """
            )

    def _ingest_files(self, conn: sqlite3.Connection) -> int:
        if not self.knowledge_dir.exists():
            return 0
        inserted = 0
        for path in sorted(self.knowledge_dir.rglob("*")):
            if not path.is_file() or path.suffix.lower() not in {".md", ".txt"}:
                continue
            text = path.read_text(encoding="utf-8").strip()
            if not text:
                continue
            title = path.stem.replace("_", " ").replace("-", " ")
            first_line = text.splitlines()[0].lstrip("# ").strip()
            if first_line:
                title = first_line
            doc_id = path.relative_to(self.knowledge_dir).as_posix()
            for chunk in chunk_markdown(text):
                conn.execute(
                    "INSERT INTO knowledge_chunk(doc_id, title, content) VALUES (?, ?, ?)",
                    (doc_id, title, chunk),
                )
                inserted += 1
        return inserted

    def _like_search(self, conn: sqlite3.Connection, query: str, limit: int) -> list:
        tokens = re.findall(r"[\w\u4e00-\u9fff]{1,20}", query, flags=re.UNICODE)
        if not tokens:
            like = f"%{query[:40]}%"
            return conn.execute(
                """
                SELECT doc_id, title, content, 0 AS rank
                FROM knowledge_chunk
                WHERE content LIKE ? OR title LIKE ?
                LIMIT ?
                """,
                (like, like, limit),
            ).fetchall()
        clauses = []
        params: list[object] = []
        for token in tokens[:8]:
            clauses.append("(content LIKE ? OR title LIKE ?)")
            like = f"%{token}%"
            params.extend([like, like])
        sql = f"""
            SELECT doc_id, title, content, 0 AS rank
            FROM knowledge_chunk
            WHERE {" OR ".join(clauses)}
            LIMIT ?
        """
        params.append(limit)
        return conn.execute(sql, params).fetchall()

    @staticmethod
    def _fts_query(query: str) -> str:
        tokens = re.findall(r"[\w\u4e00-\u9fff]{1,32}", query, flags=re.UNICODE)
        if not tokens:
            return ""
        unique: list[str] = []
        for token in tokens:
            if token not in unique:
                unique.append(token)
            if len(unique) >= 12:
                break
        return " OR ".join(f'"{t}"' for t in unique)

    def _connect(self) -> sqlite3.Connection:
        return sqlite3.connect(self.db_path, timeout=10)


_store: KnowledgeStore | None = None
_store_lock = threading.Lock()


def get_knowledge_store() -> KnowledgeStore:
    global _store
    if _store is not None:
        return _store
    with _store_lock:
        if _store is None:
            from app.settings import settings

            _store = KnowledgeStore(
                db_path=settings.knowledge_db_path,
                knowledge_dir=settings.knowledge_dir,
            )
            _store.ensure_ready()
        return _store