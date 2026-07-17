# Skill: second-brain-ticket

Create or update a Jira ticket note in the vault.

## Usage
```
second-brain-ticket TICKET-XXX
```

## What to do

1. Use Atlassian MCP to fetch ticket details:
   `mcp__atlassian__getJiraIssue` with `cloudId: {{YOUR_JIRA_ORG}}` and `issueIdOrKey: TICKET-XXX`

2. Create a note at:
   `{{YOUR_VAULT_PATH}}/01-Work/Jira/TICKET-XXX - {title}.md`

3. Use the template at `{{YOUR_VAULT_PATH}}/Templates/jira-ticket.md`

4. Fill in:
   - Summary from Jira
   - Current status
   - Extract "Next concrete actions" (≤3 steps) from the description
   - Add "Why it matters" based on current OKR context

5. Update `Dashboard.md` Active Tickets table if it's a new ticket

## Note: no Jira?
If you don't use Jira, adapt this skill to your issue tracker (Linear, GitHub Issues, Notion, etc.).
The pattern is the same: fetch issue → create structured note → link from Dashboard.
