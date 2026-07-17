# Setup Guide

End-to-end setup for `second-brain-os` — from zero to a running AI second brain.

---

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Python | 3.11+ | [python.org](https://python.org) |
| uv | latest | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Git | any | system package manager |
| Obsidian | latest | [obsidian.md](https://obsidian.md) |
| Claude Code | latest | `npm install -g @anthropic-ai/claude-code` |

---

## Step 1 — Run the scaffold script

```bash
bash scripts/setup.sh
```

This will:
1. Install MemPalace via `uv tool install mempalace`
2. Initialize a MemPalace palace at `~/.mempalace/`
3. Copy `vault-template/` to `~/second-brain/` (your vault)
4. Write `~/.claude/CLAUDE.md` from the template (prompts for your name/org)
5. Copy skills to `~/.claude/skills/`
6. Print the MCP config snippet to add to your Claude settings

---

## Step 2 — Configure MemPalace MCP

Add MemPalace to your Claude Code MCP config.

Run:
```bash
mempalace mcp
```

This prints the exact JSON to add to your `~/.claude/settings.json` (or `.cursor/mcp.json` for Cursor).

Example output:
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

---

## Step 3 — Open your vault in Obsidian

1. Open Obsidian → "Open folder as vault"
2. Select `~/second-brain/`
3. Recommended plugins (Community):
   - **Dataview** — for dynamic tables
   - **Templater** — for template hotkeys
   - **Calendar** — for daily note navigation

---

## Step 4 — Configure CLAUDE.md

The scaffold script created `~/.claude/CLAUDE.md` with placeholders. Open it and fill in:

- `{{YOUR_NAME}}` — your name
- `{{YOUR_VAULT_PATH}}` — absolute path to your vault (e.g. `/Users/you/second-brain`)
- `{{YOUR_JIRA_ORG}}` — e.g. `yourcompany.atlassian.net`
- `{{YOUR_GITHUB_USERNAME}}` — your GitHub handle
- `{{YOUR_TEAM}}` — team name / Jira project key

See `claude/CLAUDE.md.template` for the full template.

---

## Step 5 — Connect Jira (optional)

If you use Jira, add the Atlassian MCP server:

```bash
# Install the Atlassian MCP server
npx @atlassian/mcp-server
```

Then add to your MCP config and set credentials per [Atlassian MCP docs](https://developer.atlassian.com/cloud/jira/platform/mcp/).

---

## Step 6 — First session

```bash
cd ~/second-brain
claude
```

In the session, type:
```
second-brain-sync
```

Claude will read your vault state and orient itself. You're live.

---

## Step 7 — Mine your history (optional but recommended)

If you have existing notes or chat transcripts to ingest into MemPalace:

```bash
# Mine your vault into MemPalace
mempalace mine ~/second-brain --wing projects

# Mine Claude Code session transcripts (if using Claude Code)
mempalace mine ~/.claude/projects/ --mode convos --wing sessions
```

---

## Directory Structure After Setup

```
~/.claude/
├── CLAUDE.md              ← global AI instructions
└── skills/
    ├── second-brain-sync.md
    ├── second-brain-exit.md
    ├── second-brain-ticket.md
    ├── second-brain-1on1.md
    ├── second-brain-catchup.md
    ├── second-brain-ingest.md
    ├── second-brain-review.md
    ├── second-brain-grill.md
    └── second-brain-handoff.md

~/.mempalace/
└── palace/                ← MemPalace vector database

~/second-brain/            ← your Obsidian vault
├── 00-Inbox/
├── 01-Work/
├── 02-Learning/
├── 03-Personal/
├── 04-Routines/
├── standup/
├── Templates/
└── Dashboard.md
```

---

## Troubleshooting

**MemPalace vector search disabled** — run `mempalace repair --yes` to rebuild the index.

**MCP server not connecting** — verify `mempalace-mcp` is on your `$PATH` (`which mempalace-mcp`). If not: `uv tool install mempalace` again.

**Claude doesn't read skills** — verify skill files are in `~/.claude/skills/` and referenced in `CLAUDE.md` under the Custom Skills section.

**Obsidian not showing links** — enable "Detect all file extensions" in Obsidian settings.
