# Adapter: OpenAI Codex / ChatGPT

Using second-brain-os with [OpenAI Codex CLI](https://github.com/openai/codex) or ChatGPT.

---

## Global Instructions (Codex CLI)

Codex CLI reads `~/.codex/instructions.md` as global instructions.

```bash
mkdir -p ~/.codex
cp claude/CLAUDE.md.template ~/.codex/instructions.md
```

Key differences to apply when editing:
- Replace `~/.claude/` references with `~/.codex/`
- Remove `mcp__mempalace__*` tool references (MCP not supported natively in Codex CLI)
- Remove `## Custom Skills` section
- Simplify to core behavioral instructions only

---

## MCP / Tools

Codex CLI does not natively support MCP. Workarounds:

**Option A — Shell integration**:
Run MemPalace search from the shell and paste results into context:
```bash
mempalace search "your query here" | pbcopy
# paste into Codex session
```

**Option B — Pre-session script**:
```bash
# search-memory.sh
#!/bin/bash
echo "=== MemPalace context ==="
mempalace search "$1" --limit 5
```

---

## ChatGPT (web / API)

For ChatGPT web or API usage:

1. **System prompt**: paste the content of `claude/CLAUDE.md.template` (filled in) as your system prompt / custom instructions
2. **Skills**: paste skill file content inline when you want to trigger a skill
3. **Memory**: use the `second-brain-handoff` pattern — end each session with a handoff doc, paste it at the start of the next session

For the API:
```python
import openai

with open("claude/CLAUDE.md.template") as f:
    system_prompt = f.read()

client = openai.OpenAI()
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": "second-brain-sync"}
    ]
)
```

---

## Memory Strategy Without MCP

Without MemPalace MCP integration, use this pattern:

1. **Start of session**: read Dashboard.md + paste as context
2. **During session**: write important decisions to vault files immediately
3. **End of session**: run `second-brain-handoff` (paste the skill, let the model execute it)
4. **Next session**: paste the handoff doc as first message

This gives ~80% of the MemPalace benefit without MCP.
