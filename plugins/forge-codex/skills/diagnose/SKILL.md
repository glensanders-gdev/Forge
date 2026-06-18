---
name: "diagnose"
description: "Systematically diagnose a failing ticket, bug, or repeated error. Use when $diagnose is invoked manually, or when the AI has failed the same ticket twice during implementation."
metadata:
  category: code-quality
  version: 1.0.0
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Diagnose

Systematically investigate a failure before attempting another fix. Stop the implementation loop and think before acting.

## Trigger Conditions

- Human runs `$diagnose` explicitly at any time
- AI has failed the same ticket twice — proactively suggest: "I've failed this twice. Want me to run `$diagnose` before continuing?"

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
10. **Log to metrics** — append one row to `docs/metrics/metrics-log.md` (see Metrics Logging below).

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

## Metrics Logging

After step 9, append one row to `docs/metrics/metrics-log.md`.
Create the file and section header if they don't exist.

**Section header (create if absent):**
```markdown
## Diagnose Events

| Date | Ticket | Trigger | Root Cause | Resolution |
|------|--------|---------|------------|------------|
```

**Append row:**
```
| YYYY-MM-DD | #N short-title | Explicit / Failed twice | Implementation bug / Design flaw / Missing context / External dependency / Other | Resolved / Escalated / Design change required |
```

- **Trigger**: `Explicit` when human invoked `$diagnose` directly; `Failed twice` when AI self-suggested after two failed attempts.
- **Root Cause**: use the most accurate category; `Other` if none fit.
- **Resolution**: `Resolved` if fix applied and verified; `Escalated` if surfaced without fix; `Design change required` if an ADR/PRD amendment was flagged.

Log silently — do not mention to the user.

---

## Rules

- Never guess-and-check. Form a hypothesis before making any change.
- If root cause is unclear after investigation, surface it to the human rather than applying a speculative fix.
- If the diagnosis reveals a design flaw (not just a bug), flag it and consider whether a new ADR or PRD amendment is needed.
- Keep the diagnosis report in the ticket comment or append to `docs/DEVLOG.md` for the current session.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Same ticket has failed twice | Proactively suggest `$diagnose` before another fix attempt. |
| Tempted to guess-and-check | Stop — form at least two ranked hypotheses before changing anything. |
| Failure can't be reproduced | Collect more symptoms before hypothesising — don't fix blind. |
| Root cause unclear after investigation | Surface it to the human — never apply a speculative fix. |
| Diagnosis reveals a design flaw, not a bug | Flag it and consider whether a new ADR or PRD amendment is needed. |
| Proposed fix is a significant change | Get human confirmation before implementing. |
