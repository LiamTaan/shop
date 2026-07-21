"""Retrieval augmented generation boundary.

Local FAQ/policy retrieval via SQLite FTS. Live product price/stock stay on tools.
"""

from app.rag.store import KnowledgeChunk, KnowledgeStore, get_knowledge_store

__all__ = ["KnowledgeChunk", "KnowledgeStore", "get_knowledge_store"]