# Adapter: Claude Code (Primary)

Claude Code is the primary supported LLM for second-brain-os. This guide covers setup specific to Claude Code.

---

## Global Instructions

Claude Code reads `~/.claude/CLAUDE.md` at the start of every session.

Copy the template:
```bash
cp claude/CLAUDE.md.template ~/.claude/CLAUDE.md
# Edit and fill in your placeholders
```

---

## Skills

Claude Code supports custom skill files — markdown files that the LLM reads and executes when triggered by a keyword.

Copy skills:
```bash
cp claude/skills/* ~/.claude/skills/
```

Trigger a skill by typing its keyword in any session:
```
second-brain-sync
second-brain-exit
```

---

## MCP Servers

Claude Code supports MCP (Model Context Protocol) servers. Add to `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "mempalace": {
      "command": "mempalace-mcp",
      "args": []
    },
    "atlassian": {
      "command": "npx",
      "args": ["-y", "@atlassian/mcp-server"],
      "env": {
        "ATLASSIAN_SITE_URL": "https://your-org.atlassian.net",
        "ATLASSIAN_USER_EMAIL": "you@example.com",
        "ATLASSIAN_API_TOKEN": "your-token"
      }
    }
  }
}
```

---

## Session Transcripts

Claude Code saves session transcripts to `~/.claude/projects/`. Mine them into MemPalace:

```bash
mempalace mine ~/.claude/projects/ --mode convos --wing sessions
```

This is what makes memory persistent — every past session becomes searchable.

---

## Tips

- Start every session in your vault directory: `cd ~/second-brain && claude`
- Use `/compact` when context gets large — MemPalace fills the gap
- The `second-brain-exit` skill auto-triggers at session end (bye/done/exit keywords)
