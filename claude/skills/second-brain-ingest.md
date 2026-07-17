# Skill: second-brain-ingest

Ingest any external source into the vault — articles, URLs, Confluence pages, Slack threads, PDFs, pasted text.

## Usage
```
second-brain-ingest <URL | file path | "pasted text">
```

## What to do

### Step 1 — Classify the source type
- `url_article` — blog post, documentation page
- `confluence` — Confluence page URL or page ID
- `jira` — Jira ticket URL or key
- `slack` — Slack thread or message
- `file` — local file path
- `text` — raw pasted text

### Step 2 — Extract structured content

**For URLs / articles** — use WebFetch or equivalent:
Extract: `title`, `source_url`, `date`, `key_claims`, `people_mentioned`, `decisions`, `action_items`, `technical_content`, `summary`

**For Confluence / Jira** — use MCP tools directly.

**For local files / text** — read directly and extract the same fields.

### Step 3 — Determine destination

| Source type | Destination |
|-------------|-------------|
| Work-related article / doc | `02-Learning/` subfolder |
| Confluence / Jira context | `01-Work/Jira/TICKET-XXX.md` |
| Personal project / idea | `03-Personal/Projects/ideas.md` |
| Technical reference | Most relevant `02-Learning/` note or new file |
| Meeting / conversation | `01-Work/1on1s/` |

### Step 4 — Write the vault note (AI-first format)
```markdown
---
type: <learning | reference | meeting | idea>
date: YYYY-MM-DD
source: <URL or origin>
tags: [relevant, tags]
ai-first: true
---

## For future Claude
> What this note contains and why it was ingested.
> Key people: [[Name]] | Key tickets: [[TICKET-XXX]] | Source: (as of YYYY-MM, url)

## Key takeaways
- Claim (source)

## Technical context
[commands, code snippets, links — preserved verbatim]

## Action items
- [ ] ...

## Questions / open threads
-
```

### Step 5 — Mine to MemPalace
Call `mcp__mempalace__mempalace_mine` on the destination file.

### Step 6 — Confirm
```
Routed to: <path>
Mined: ✅
```
