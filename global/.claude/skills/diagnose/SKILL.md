---
name: diagnose
version: 1.0.0
description: Systematically diagnose a failing ticket, bug, or repeated error. Use when /diagnose is invoked manually, or when the AI has failed the same ticket twice during implementation.
---

# Diagnose

Systematically investigate a failure before attempting another fix. Stop the implementation loop and think before acting.

## Trigger Conditions

- Human runs `/diagnose` explicitly at any time
- AI has failed the same ticket twice — proactively suggest: "I've failed this twice. Want me to run `/diagnose` before continuing?"

## Process

1. **Collect symptoms** — what exactly is failing? Error messages, unexpected output, wrong behavior.
2. **Read relevant context** — the failing ticket in `docs/kanban.md`, related research in `docs/research/`, relevant CONTEXT.md terms.
3. **Explore the codebase** — trace the failure path. Find where expectation diverges from reality.
4. **Form hypotheses** — list at least 2 possible root causes, ranked by likelihood.
5. **Test hypotheses** — starting with the most likely, investigate each without making changes yet.
6. **Confirm root cause** — state clearly what is wrong and why.
7. **Propose fix** — describe the fix before implementing it. Get human confirmation if it's a significant change.
8. **Implement and verify** — make the fix, confirm it resolves the failure.
9. **Update kanban** — note the diagnosis and fix in the ticket.

## Diagnosis Report Format

```markdown
## Diagnosis: [Ticket #N — Short Description]

**Date:** YYYY-MM-DD

### Symptoms
[What was observed failing]

### Root Cause
[What was actually wrong]

### Hypotheses Considered
1. [Hypothesis A] — ruled out because [reason]
2. [Hypothesis B] — confirmed because [reason]

### Fix Applied
[What was changed and why]

### Verification
[How the fix was confirmed to work]
```

## Rules

- Never guess-and-check. Form a hypothesis before making any change.
- If root cause is unclear after investigation, surface it to the human rather than applying a speculative fix.
- If the diagnosis reveals a design flaw (not just a bug), flag it and consider whether a new ADR or PRD amendment is needed.
- Keep the diagnosis report in the ticket comment or append to `docs/DEVLOG.md` for the current session.
