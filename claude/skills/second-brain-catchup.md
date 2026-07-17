# Skill: second-brain-catchup

Process all unprocessed notes in `00-Inbox/` and route them to the right vault location.

## Usage
```
second-brain-catchup
```

## Model strategy
Two-tier execution to minimize token cost:
- **Haiku sub-agents** — parallel extraction: one per inbox file
- **Sonnet (this session)** — routing decisions, writes to vault, confirms with user

## What to do

### Step 1 — List the inbox
List every `.md` file in `{{YOUR_VAULT_PATH}}/00-Inbox/`.

### Step 2 — Extract each file (in parallel)
For each inbox file, read and extract a structured summary:
- `file`: filename
- `items`: list of `{ content_summary, type, people_mentioned, tickets_mentioned, key_content }`
- `type`: one of `meeting_notes | jira_action | work_todo | technical_context | personal_idea | reading_list | misc`

If using Claude Code with sub-agents:
```bash
claude -m claude-haiku-4-5-20251001 --print "Read this inbox note and extract structured JSON: ..."
```
Otherwise: read each file directly in this session.

### Step 3 — Routing plan
Determine destination for each item:

| Type | Destination |
|------|-------------|
| `meeting_notes` | `01-Work/1on1s/YYYY-MM-DD-1on1-{person}.md` |
| `jira_action` | Create/update `01-Work/Jira/TICKET-XXX.md` |
| `work_todo` | Add to `Dashboard.md` Focus Right Now |
| `technical_context` | `02-Learning/` note or `01-Work/Jira/` ticket |
| `personal_idea` | `03-Personal/Projects/ideas.md` |
| `reading_list` | `03-Personal/Projects/ideas.md` (Reading section) |
| `misc` | Flag to user — ask what to do |

Show the routing plan before writing:
```
00-Inbox/2024-01-15.md:
  → "Team sync" [meeting_notes] → 01-Work/1on1s/...
  → "Article on LLM evals" [reading_list] → ideas.md
```
Ask for one confirmation — no back-and-forth.

### Step 4 — Execute routing
- Create or update destination files using AI-first format (see Step 5)
- For `technical_context` and `meeting_notes` → also mine with MemPalace
- For `work_todo` and `reading_list` → just update the target file

### Step 5 — AI-first format for new notes
```markdown
---
type: <1on1 | jira-ticket | learning | idea>
date: YYYY-MM-DD
tags: [relevant, tags]
ai-first: true
---

## For future Claude
> One sentence: what this note is about and why it exists.
> Key people: [[Name]] | Key tickets: [[TICKET-XXX]]

[rest of content]
```

### Step 6 — Clean up
After routing all items from a file, ask: "Delete `00-Inbox/file.md` now that it's been processed?" Never delete without explicit confirmation.

### Step 7 — Summary
```
Files processed: N
Items routed: N (breakdown by type)
Files mined to MemPalace: N
Inbox files to delete: [list] — awaiting confirmation
```
