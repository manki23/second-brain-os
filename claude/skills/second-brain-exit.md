# Skill: second-brain-exit

End-of-session mega-skill. Updates the vault, persists to MemPalace, and commits — with minimal token usage via Haiku sub-agents for all read/write grunt work.

> ⚠️ Known limitation: `claude` CLI cannot be spawned inside an active Claude Code session (nested session blocked). Haiku sub-agent steps fall back to direct reads in this session until this is resolved upstream.

## Usage
```
second-brain-exit
```

## Model strategy

| Phase | Who | What |
|-------|-----|-------|
| Reads | **Haiku (parallel)** | Dashboard, git status, inbox scan, ticket notes |
| Session summary | **Sonnet** | Only Sonnet has conversation context — extracts what changed |
| Diary + manifest | **Haiku** | Writes MemPalace diary + formats the update manifest |
| Vault writes | **Sonnet** | Judgment calls on what to update and how |
| Git | **Bash** | Commit + push |

---

## Step 1 — Parallel reads (fire all at once)

Run these 3 reads in parallel:

**A — Current vault state:**
Read `{{YOUR_VAULT_PATH}}/Dashboard.md` and extract:
- Unchecked items in `## Focus Right Now`
- Active ticket IDs and statuses
- Unchecked items in `## This Week`

**B — Git state:**
```bash
cd {{YOUR_VAULT_PATH}} && git status --short && git diff --stat
```
Note: has_changes, modified files, untracked files.

**C — Inbox scan:**
```bash
ls {{YOUR_VAULT_PATH}}/00-Inbox/
```
Note: unprocessed `.md` files.

---

## Step 2 — Extract session summary

Using the full conversation context, produce a compact internal manifest:

```
SESSION MANIFEST:
- tickets_touched: [TICKET-XXX: what happened, ...]
- decisions_made: [...]
- tasks_completed: [...]
- new_todos: [...]
- ideas_surfaced: [...]
- 1on1s_held: [person, date, key points]
- learnings: [...]
- inbox_needs_catchup: yes/no
```

Do NOT ask the user. Infer everything from the conversation.

---

## Step 3 — Write the MemPalace diary entry

Call `mcp__mempalace__mempalace_diary_write` with a compact entry (max 200 words):

```markdown
## Session — YYYY-MM-DD
**Done**: ...
**Decisions**: ...
**Next**: ...
**Open**: ...
```

---

## Step 4 — Update the vault

Using the manifest from Step 2 + vault state from Step 1A, apply only what actually changed:

- **Dashboard.md** → check off completed items, add new todos, update ticket statuses
- **01-Work/Jira/TICKET-XXX.md** → update notes + next actions for touched tickets
- **01-Work/1on1s/** → create note if a 1-1 happened
- **03-Personal/Projects/ideas.md** → append if new ideas surfaced
- **02-Learning/** → append if a learning happened

Show a compact diff summary before writing. One confirmation, no back-and-forth.

---

## Step 5 — Inbox check

If Step 1C found unprocessed inbox files:
> "There are N unprocessed files in 00-Inbox/. Run `second-brain-catchup` now?"

Don't run it automatically — just flag it.

---

## Step 6 — Git commit + push

If there are vault changes:

```bash
cd {{YOUR_VAULT_PATH}} && git add -A && git status
```

Show the file list, propose a commit message inferred from the manifest, then confirm with user before committing.

---

## Step 7 — Exit summary

```
✅ second-brain-exit complete
  MemPalace diary: written
  Vault updated: N files
  Git: committed + pushed (or: no changes)
  Inbox: N files pending (or: clear)
```
