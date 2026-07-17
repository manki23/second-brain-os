# Skill: second-brain-1on1

Create a 1-1 meeting note in the vault.

## Usage
```
second-brain-1on1 [person] [date?]
```

## What to do

1. Ask: "What happened in the 1-1? Dump everything, I'll structure it."

2. Create note at:
   `{{YOUR_VAULT_PATH}}/01-Work/1on1s/YYYY-MM-DD-1on1-{person}.md`

3. Use template from `{{YOUR_VAULT_PATH}}/Templates/1on1.md`

4. Extract:
   - Action items (concrete, ≤3 for this week)
   - Feedback received
   - New context about team/direction

5. If feedback received → also add to `01-Work/Senior-Promotion/tracking.md` (if you're tracking promotion)

6. Update `Dashboard.md` if new priorities emerge

7. Mine the note to MemPalace:
   `mcp__mempalace__mempalace_mine` with the file path
