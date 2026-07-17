# Skill: second-brain-standup

Write or update today's standup note. Fast, lightweight — designed for Haiku.

## Usage
```
second-brain-standup   (or sb-standup)
```
Also auto-runs as part of `second-brain-exit`.

## Model target
**Haiku** — lightweight, fire-and-forget. Use current session only if sub-agent spawning unavailable.

## What to do

### Step 1 — Determine today's file path
```
FILE = {{YOUR_VAULT_PATH}}/standup/YYYY-MM-DD.md
```

### Step 2 — Check if file already exists
- Exists → **update** (merge new info, don't overwrite)
- Missing → **create** from template

### Step 3 — Infer content from session context
Do NOT ask the user. Infer everything from the conversation:

| Section | What to include |
|---------|----------------|
| ✅ Done today | Tickets closed, PRs merged, tasks completed this session |
| 🔄 Ongoing | PRs in review, CI running, blocked/waiting states |
| ▶️ Can start next | Concrete next actions from open tickets (max 3) |
| 🔮 Deferred | Things explicitly postponed |

### Step 4 — Write the note

```markdown
---
type: standup
date: YYYY-MM-DD
tags: [standup, work]
ai-first: true
---

## For future Claude
> Daily work inventory for YYYY-MM-DD.

# Standup — YYYY-MM-DD

## ✅ Done today
-

## 🔄 Ongoing (needs monitoring)
-

## ▶️ Can start next
-

## 🔮 Deferred
-
```

### Step 5 — Confirm (one line, no confirmation needed)
```
📋 Standup written: standup/YYYY-MM-DD.md
```
