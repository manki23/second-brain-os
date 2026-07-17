# Skill: second-brain-handoff

Compact the current session into a structured handoff document so the next session can pick up instantly.

## Usage
```
second-brain-handoff [optional: focus for next session]
```

## What to do

### Step 1 — Summarize the session
From the current conversation context, extract:
- **What was decided** (technical decisions, priorities, plans)
- **What was done** (files written, tickets updated)
- **What's in progress** (work started but not finished)
- **What's blocked** (and what unblocks it)
- **Open questions** that need resolution

Do NOT duplicate content already in Dashboard.md — reference by path instead.

### Step 2 — Write the handoff document
Save to `/tmp/second-brain-handoff-YYYY-MM-DD.md`:

```markdown
# Second Brain Handoff — YYYY-MM-DD HH:MM

## Context (read this first)
> One paragraph: what was happening in this session.

## Done this session
- ...

## In Progress
- [TICKET-XXX] ... → next action: ...

## Blocked
- ... → unblocked by: ...

## Open Questions
- ...

## Suggested next actions (≤3)
1. ...
2. ...
3. ...

## Suggested skills to invoke
- `second-brain-sync` — if Dashboard needs updating
- `second-brain-ingest <url>` — if there's a source to absorb
- `second-brain-catchup` — if inbox has new items

## Key files touched this session
- `{{YOUR_VAULT_PATH}}/...`
```

### Step 3 — Write to MemPalace diary
Call `mcp__mempalace__mempalace_diary_write` with a compact version (decisions + next actions only).

### Step 4 — Update Dashboard if needed
If focus items or ticket statuses changed, update `Dashboard.md`.

### Step 5 — Report
```
Handoff saved to: /tmp/second-brain-handoff-YYYY-MM-DD.md
MemPalace diary: written ✅
Dashboard: updated / no changes needed
```

To start the next session from this handoff:
```bash
cat /tmp/second-brain-handoff-YYYY-MM-DD.md
```
Paste the content as the first message.
