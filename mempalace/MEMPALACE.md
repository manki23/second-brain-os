# MemPalace Integration Guide

[MemPalace](https://github.com/patrickmaynard/mempalace) gives your LLM persistent memory across sessions — semantic search over your full session history and vault.

---

## What it does

- **Mines** your vault files and session transcripts into a local vector database
- **Searches** semantically — "what did I decide about X last month?" actually works
- **Diary** — write structured session summaries that persist and are searchable forever
- **MCP server** — exposes search/write tools directly to your LLM session

No API key needed. Fully local. SQLite + HNSW index.

---

## Install

```bash
uv tool install mempalace
```

---

## Initialize

```bash
mempalace init ~/second-brain
```

This detects your folder structure and creates rooms/wings for each folder.

---

## MCP config

Add to your Claude Code `~/.claude/settings.json`:
```json
{
  "mcpServers": {
    "mempalace": {
      "command": "mempalace-mcp",
      "args": []
    }
  }
}
```

For Cursor, add to `.cursor/mcp.json`. For other editors, see [adapters](../adapters/).

---

## Mine your vault

```bash
# Mine project files (notes, tickets, OKRs...)
mempalace mine ~/second-brain --wing projects

# Mine Claude Code session transcripts
mempalace mine ~/.claude/projects/ --mode convos --wing sessions

# Mine a specific directory
mempalace mine ~/second-brain/01-Work/Jira/ --wing work
```

Schedule with cron for automatic ingestion:
```cron
0 * * * * mempalace mine ~/second-brain --wing projects
```

---

## Available MCP tools (from inside an LLM session)

| Tool | Use |
|------|-----|
| `mcp__mempalace__mempalace_search` | Semantic + BM25 search |
| `mcp__mempalace__mempalace_diary_write` | Write a session diary entry |
| `mcp__mempalace__mempalace_diary_read` | Read recent diary entries |
| `mcp__mempalace__mempalace_mine` | Mine a specific file/dir on demand |
| `mcp__mempalace__mempalace_status` | Palace stats (drawer count, wings) |
| `mcp__mempalace__mempalace_repair` | Rebuild vector index (after corruption) |

---

## Repair

If vector search gets disabled (index drift):

```bash
mempalace repair --yes
```

This rebuilds the HNSW index from scratch. Takes a few minutes for large palaces. A backup is created first.

---

## Session start pattern

At the start of every session, your CLAUDE.md should instruct the LLM to:

```
mcp__mempalace__mempalace_search query="[current task topic]"
```

This surfaces relevant context from past sessions without you having to re-explain it.

---

## AI-first notes

For MemPalace to be maximally useful, every note should have a `## For future Claude` section at the top:

```markdown
## For future Claude
> What this note is about and why it exists.
> Key people: [[Name]] | Key tickets: [[TICKET-XXX]]
```

This section gets prioritized in search results and makes context retrieval much faster.

---

## Tips

- **Mine frequently** — run after every session or set up a cron job
- **Diary every session** — even 3 sentences. This is your long-term memory.
- **Search before asking** — "what was that approach we decided on?" → search MemPalace first
- **Wing = topic bucket** — `sessions`, `projects`, `work`, `personal`. Keep wings coarse.
