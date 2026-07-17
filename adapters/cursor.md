# Adapter: Cursor

Cursor uses `.cursorrules` (or `.cursor/rules/`) for global instructions and MCP for tool integrations.

---

## Global Instructions

Create `.cursorrules` in your home directory or vault root:

```bash
cp claude/CLAUDE.md.template ~/.cursorrules
```

Edit and fill in your placeholders. Key differences from Claude Code:
- No `## Custom Skills` section (Cursor doesn't support skill files natively — see workaround below)
- Remove the `## Auto second-brain-exit` section

Or use Cursor's newer rules format:
```bash
mkdir -p ~/.cursor/rules
cp claude/CLAUDE.md.template ~/.cursor/rules/second-brain.mdc
```

---

## MCP Config

Add to `.cursor/mcp.json` (create if missing):

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

MemPalace MCP tools will be available in Cursor's Agent mode.

---

## Skills Workaround

Cursor doesn't have a native skill file system. Two options:

**Option A — Slash commands** (Cursor built-in):
Create `.cursor/prompts/second-brain-sync.md` with the skill content. Trigger with `/second-brain-sync` in chat.

**Option B — Paste on demand**:
Keep your skill files in `~/.cursor/skills/`. When you need one, `cat ~/.cursor/skills/second-brain-exit.md` and paste it into the chat.

---

## Session Memory

Cursor doesn't save session transcripts by default. To get MemPalace memory working:
- Export conversation history when prompted, or
- Use MemPalace only for vault mining (`mempalace mine ~/second-brain --wing projects`)
- Cross-session memory via vault notes + Dashboard.md

---

## Obsidian Vault Integration

Open your vault in Cursor as a workspace:
```bash
cursor ~/second-brain
```

Cursor can then read, edit, and create vault files directly via its file editing tools.
