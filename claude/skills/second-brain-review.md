# Skill: second-brain-review

Review a coworker's PR as a Senior Engineer would.

## Usage
```
second-brain-review <PR-number-or-URL>
```

## What to do

### Step 1 — Fetch the PR
```bash
gh pr view <PR> --json title,body,author,baseRefName,headRefName,files
gh pr diff <PR>
```

### Step 2 — Understand context
- Check if the PR references a ticket → fetch it for business context
- Identify language(s), services, and patterns involved

### Step 3 — Produce the review

```markdown
## PR Review: `<title>`
**Author**: @author | **Branch**: `head → base`
**Ticket**: TICKET-XXX (if found)

### Summary
2-4 sentences: what this PR does, why it exists, what problem it solves.

### What's good
Specific things done well (architecture, test coverage, naming, edge cases...).
Mention file/function names.

### Areas of concern
High-level issues worth discussing (design choices, missing tests, scope...).

---

### Review Comments

#### High Priority — must address before merge
Blockers: bugs, security issues, correctness problems, breaking changes.

| # | File | Line(s) | Comment |
|---|------|---------|---------|
| 1 | `path/to/file.go` | L42 | **[Bug]** ... |

#### Medium Priority — should address
Non-blocking but important: performance, error handling, unclear logic.

| # | File | Line(s) | Comment |
|---|------|---------|---------|

#### Low Priority — nit / suggestion
Style, naming, optional refactors. Prefix with `nit:`.

| # | File | Line(s) | Comment |
|---|------|---------|---------|

---

### Verdict
- **Approve** / **Request changes** / **Comment only**
- One-line rationale.
```

### Step 4 — Ask before posting
> "Want me to post these comments on the PR? I can post all at once, or only High/Medium."

**Never post anything without explicit confirmation.**

If confirmed:
```bash
gh pr review <PR> --comment --body "..."
# for inline comments:
gh api repos/{owner}/{repo}/pulls/{pr}/comments --method POST ...
```
