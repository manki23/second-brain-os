# VERIFIED.md
> Claude reads this file at every session start and runs all active checks silently.
> Flag issues inline — do NOT interrupt the user unless action is required.

---

## 🔁 Daily Checks (every session)

### D1 — Stale Focus items
- Read `Dashboard.md` → `## Focus Right Now`
- Any unchecked item last touched > 3 days ago → flag: `⚠️ STALE: [item] — no progress in 3+ days`

### D2 — DEPLOYING → DONE auto-rule
- Read `Dashboard.md` → Active Tickets table
- Any ticket with status `DEPLOYING` and `deploying_since` > 7 days → automatically:
  1. Transition in your issue tracker to Done
  2. Update ticket note in `01-Work/Jira/`
  3. Update Dashboard.md ticket status
  4. Report: `✅ AUTO-CLOSED: TICKET-XXX (was DEPLOYING since YYYY-MM-DD)`

### D3 — Inbox overflow
- Check `00-Inbox/` for `.md` files older than 2 days
- Flag: `📥 INBOX: N unprocessed files (oldest: YYYY-MM-DD) — run second-brain-catchup`

### D4 — Stale draft PRs
- Check ticket notes for PRs in draft state > 5 days without update
- Flag: `🔀 STALE PR: #XXXX in draft since YYYY-MM-DD`

### D5 — MemPalace health
- If first search of session returns `vector_disabled: true`
- Flag: `🔧 MEMPALACE: vector search disabled — run \`mempalace repair --yes\``

---

## 📅 Weekly Checks (first session of the week)

### W1 — OKR progress
- Read `01-Work/OKRs/` for active OKRs
- If no ticket moved forward on a P0 this week → flag: `🎯 OKR RISK: [OKR name] — no progress this week`

### W2 — Learning log
- Check `02-Learning/` for any new file this week
- If nothing new in 7 days → flag: `📚 LEARNING: no new note this week — worth capturing something?`

### W3 — Promotion tracking
- Check `01-Work/Senior-Promotion/tracking.md` last modified date
- If > 10 days → flag: `🚀 PROMO: tracking.md not updated in 10+ days — any feedback or impact to log?`

---

## 🔇 Silence rule
- Green checks → say nothing. No "all good" message.
- Only surface flags that require attention.
- Max 3 flags per session — pick the most urgent if more.

---

## 📝 Add new checks
```
### XX — Check name
- Condition: what to look for
- Action: what to do / what to flag
```
