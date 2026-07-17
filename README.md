# second-brain-os

> A fully autonomous second brain powered by Obsidian + Claude Code + MemPalace.
> Works with any LLM: Claude Code, Cursor, Gemini, Codex.

## What is this?

A personal knowledge operating system that:
- **Captures** everything: meetings, tickets, ideas, learnings
- **Routes** content to the right place automatically
- **Remembers** across sessions via [MemPalace](https://github.com/patrickmaynard/mempalace) (persistent vector memory)
- **Acts**: creates Jira tickets, writes PRs, runs standup notes, syncs your vault — all from a chat

You keep a private Obsidian vault. Claude (or your LLM of choice) is the engine that operates it.

---

## Demo

A typical end-of-day session:

```
$ cd ~/second-brain && claude

  ╔══════════════════════════════════════════════════════╗
  ║  Claude Code  ·  second-brain-os                     ║
  ╚══════════════════════════════════════════════════════╝

> second-brain-exit

  Reading Dashboard.md...          ✓
  Querying MemPalace...             ✓  (3 relevant memories surfaced)
  Scanning 00-Inbox/...             ✓  (2 unprocessed files)

  SESSION MANIFEST
  ├── tickets_touched:  ENG-142 (PR merged), ENG-156 (analysis done)
  ├── decisions_made:   Switch eval framework to LangSmith
  ├── tasks_completed:  PR review posted, Confluence doc updated
  └── new_todos:        Sync with Alice on ENG-156 scope

  VAULT UPDATES (confirm before writing)
  ├── Dashboard.md          check off ENG-142, add ENG-156 next action
  ├── 01-Work/Jira/ENG-142.md   → status: Done, PR #1847 merged
  └── 01-Work/Jira/ENG-156.md   → next: sync Alice, re-run eval

  Proceed? [y/N] y

  MemPalace diary written           ✓
  Vault updated (3 files)           ✓
  Git: committed + pushed           ✓  "vault: session 2024-03-15"
  Inbox: 2 files pending            ⚠  run `second-brain-catchup`

  ✅  Done. See you tomorrow.
```

**Cross-session memory** — start the next day and Claude already knows where you left off:

```
> What was the decision we made about the eval framework?

  [MemPalace search: "eval framework decision"]

  From session 2024-03-15: "Switched to LangSmith for eval tracking.
  Rationale: better experiment diffing than custom notebooks.
  Next: migrate baseline runs by ENG-156 milestone."
```

---

## Architecture

```
┌─────────────────────────────────────────────┐
│                  YOU                        │
│  chat with Claude Code / Cursor / Gemini    │
└────────────────────┬────────────────────────┘
                     │
         ┌───────────▼───────────┐
         │   LLM Session         │
         │  (reads CLAUDE.md     │
         │   + active skills)    │
         └──┬──────────┬─────────┘
            │          │
   ┌────────▼──┐  ┌────▼──────────┐
   │  Obsidian │  │  MemPalace    │
   │  Vault    │  │  (vector +    │
   │  (files)  │  │   BM25 mem)   │
   └───────────┘  └───────────────┘
```

- **Obsidian vault** — your files, your structure, git-synced
- **MemPalace** — persistent cross-session memory, semantic search over your entire history
- **CLAUDE.md** — global instructions that shape every session
- **Skills** — slash-command-style automations (sync, exit, ticket, 1on1, etc.)

---

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/your-username/second-brain-os
cd second-brain-os

# 2. Run the setup script
bash scripts/setup.sh

# 3. Open your vault in Obsidian
# 4. Start Claude Code in your vault directory
cd ~/your-vault
claude
```

Full guide: [SETUP.md](./SETUP.md)

---

## Features

| Feature | What it does |
|---------|-------------|
| `second-brain-sync` | Auto-updates vault from session context |
| `second-brain-exit` | End-of-session: diary, vault update, git push |
| `second-brain-ticket` | Creates a structured note from any Jira ticket |
| `second-brain-1on1` | Creates a structured 1-1 meeting note |
| `second-brain-catchup` | Processes all inbox files and routes them |
| `second-brain-ingest` | Ingests URLs, Confluence pages, PDFs into vault |
| `second-brain-review` | Senior-level PR review with inline comments |
| `second-brain-grill` | Stress-tests a plan with structured questions |
| `second-brain-handoff` | Creates a handoff doc for the next session |

---

## Adapters

- [Claude Code](./adapters/claude-code.md) — primary, full support
- [Cursor](./adapters/cursor.md)
- [Gemini CLI](./adapters/gemini.md)
- [Codex / OpenAI](./adapters/codex.md)

---

## Requirements

- [Obsidian](https://obsidian.md) (free)
- [Claude Code](https://claude.ai/code) or another LLM CLI
- [MemPalace](https://github.com/patrickmaynard/mempalace) (`uv tool install mempalace`)
- Python 3.11+, `uv`
- Git

---

## Philosophy

- **AI-first notes**: every note has a `## For future Claude` header so any new session can orient instantly
- **Caveman instructions**: CLAUDE.md uses terse, unambiguous language — no filler, no hedging
- **Skills over prompts**: reusable skill files replace long system prompts
- **MemPalace for memory**: vector search over your full session history means Claude never forgets context across sessions
- **Model routing**: heavy reasoning → Sonnet/Opus, grunt work → Haiku (cost-efficient)

---

## License

MIT — fork, adapt, share.
