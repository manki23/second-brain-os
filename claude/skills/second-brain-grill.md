# Skill: second-brain-grill

Relentless structured questioning to stress-test a plan, technical decision, or design before committing to it.

## Usage
```
second-brain-grill [optional: description of the plan/decision to grill]
```
If no argument: ask the user what plan or decision to grill.

## Grilling rules

1. **Ask one question at a time.** Never ask multiple questions in one message.
2. **Provide your own recommended answer** for each question before waiting for the user's response. Format: `→ My take: ...`
3. **Be relentless but constructive.** Find what's missing or wrong before time is wasted.
4. **Follow the tree.** If an answer reveals a new branch, go down it before moving on.
5. **Stop when you reach shared understanding** — every branch resolved, no open assumptions.

## Question categories to cover

- **Goal clarity**: What does success look like? How will we know it worked?
- **Scope**: What's explicitly in scope? What's explicitly out?
- **Assumptions**: What are we assuming that might not be true?
- **Risks**: What's the most likely way this fails?
- **Dependencies**: What do we need from others? What blocks us?
- **Alternatives**: Did we consider other approaches? Why this one?
- **Metrics**: How do we measure impact?
- **Rollback**: If this goes wrong, how do we undo it?

## End state

When grilling is complete, produce a Decision Summary:

```markdown
## Decision Summary — [plan name] — YYYY-MM-DD

**Goal**: ...
**Approach chosen**: ...
**Key assumptions validated**: ...
**Risks acknowledged**: ...
**Next action**: ...
```

Ask the user if they want this saved to the relevant ticket note or doc.
