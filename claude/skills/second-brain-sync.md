# Skill: second-brain-sync

Auto-update the second brain vault from session context + MemPalace. No user input needed.

## Usage
```
second-brain-sync
```

## What to do when this skill is invoked

0. **Pull context from MemPalace** (if available):
   - Call `mcp__mempalace__mempalace_wake_up` for L0+L1 summary
   - Search for topics discussed in this session (tickets, people, repos mentioned)
   - Note anything not yet reflected in vault notes

1. **Read current state**:
   - `{{YOUR_VAULT_PATH}}/Dashboard.md`
   - `{{YOUR_VAULT_PATH}}/01-Work/OKRs/`
   - Recent files in `{{YOUR_VAULT_PATH}}/01-Work/Jira/`

2. **Infer what changed** from conversation context + MemPalace:
   - Which tickets were discussed, worked on, or had status changes?
   - Any blockers, decisions, or next actions surfaced?
   - Any 1-1 that happened?
   - Any new idea or learning worth capturing?
   - Do NOT ask the user — infer from available context

3. **Update**:
   - `Dashboard.md` → Focus Right Now + Active Tickets + This Week
   - Create/update ticket notes in `01-Work/Jira/` for any ticket touched
   - If a 1-1 happened → create note in `01-Work/1on1s/`
   - If a new idea surfaced → append to `03-Personal/Projects/ideas.md`
   - If a learning happened → append to relevant `02-Learning/` note

4. **Show diff + confirm**:
   - Show a compact summary of every file changed (what was added/updated)
   - Ask for confirmation once before writing — no back-and-forth

## Trigger
Invoked explicitly (`second-brain-sync`) OR automatically at natural session end.
