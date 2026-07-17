# Adapter: Gemini CLI

Using second-brain-os with [Gemini CLI](https://github.com/google-gemini/gemini-cli).

---

## Global Instructions

Gemini CLI reads `GEMINI.md` in the current directory or `~/.gemini/GEMINI.md` globally.

```bash
cp claude/CLAUDE.md.template ~/.gemini/GEMINI.md
```

Key differences to apply when editing:
- Replace Claude-specific references: `Claude Code` → `Gemini CLI`, `~/.claude/` → `~/.gemini/`
- Remove `## Custom Skills` section (Gemini CLI doesn't support skill files natively)
- Remove `mcp__mempalace__*` tool references (see MCP section below)

---

## MCP Config

Gemini CLI supports MCP via `~/.gemini/settings.json`:

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

Once configured, MemPalace tools are available as function calls in the session.

---

## Skills Workaround

Gemini CLI doesn't have native skill files. Options:

**Option A — Inline paste**:
```bash
cat ~/.gemini/skills/second-brain-sync.md
```
Paste content into the chat when you want to trigger a skill.

**Option B — GEMINI.md includes**:
Add frequently used skill instructions directly into `~/.gemini/GEMINI.md` under a dedicated section.

---

## Session Memory

Gemini CLI doesn't persist session transcripts by default. Memory strategy:
- Mine vault files into MemPalace: `mempalace mine ~/second-brain --wing projects`
- Use `Dashboard.md` as session state — ask Gemini to read it at session start
- Write important decisions to vault immediately (don't rely on session history)

---

## Tips

- Start every session by asking Gemini to read `~/second-brain/Dashboard.md`
- The `second-brain-handoff` skill is especially useful — create a handoff doc at session end and paste it as context in the next session
- Gemini's large context window (1M tokens) means you can paste more vault content than with other models
