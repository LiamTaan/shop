from app.rag.store import KnowledgeStore, chunk_markdown


def test_chunk_markdown_splits_paragraphs() -> None:
    text = "第一段内容。\n\n第二段内容。\n\n第三段内容。"
    chunks = chunk_markdown(text, max_chars=20)
    assert len(chunks) >= 2
    assert "第一段" in chunks[0]


def test_knowledge_retrieve_aftersale(tmp_path) -> None:
    knowledge_dir = tmp_path / "knowledge"
    knowledge_dir.mkdir()
    (knowledge_dir / "aftersale.md").write_text(
        "# 售后政策\n\n签收后 7 天内可申请仅退款。\n\n质量问题商家承担运费。\n",
        encoding="utf-8",
    )
    (knowledge_dir / "faq.md").write_text(
        "# FAQ\n\n优惠券过期后不能延期。\n\n发票在订单详情申请。\n",
        encoding="utf-8",
    )
    store = KnowledgeStore(
        db_path=tmp_path / "k.db",
        knowledge_dir=knowledge_dir,
    )
    assert store.reindex() >= 2

    hits = store.retrieve("7天 退款", top_k=3)
    assert hits
    joined = "\n".join(h.content for h in hits)
    assert "7 天" in joined or "退款" in joined

    context = store.format_context(hits)
    assert "Knowledge base excerpts" in context
    assert "price or stock" in context


def test_knowledge_empty_query(tmp_path) -> None:
    store = KnowledgeStore(db_path=tmp_path / "k.db", knowledge_dir=tmp_path / "empty")
    store.ensure_ready()
    assert store.retrieve("") == []