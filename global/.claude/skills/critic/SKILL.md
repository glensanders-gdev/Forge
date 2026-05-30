---
name: critic
category: code-quality
description: Critically evaluate the current framework, plan, PRD, skill, or design. Surfaces weaknesses, risks, inconsistencies, and gaps with honest prioritised feedback. Use when user runs /critic, wants critical feedback, or asks for an honest evaluation of something.
---

# Critic

Provide an honest, prioritised critical evaluation of whatever is in scope — the Forge framework itself, a PRD, a plan, a skill, a design decision, or a codebase. No sycophancy. Surface what is actually wrong or risky.

## When to Use

- User runs `/critic` explicitly
- User asks "what's wrong with this", "stress test this", "what am I missing"
- End of a significant design phase before committing to implementation
- After a PRD is written but before Kanban is generated

## Process

1. **Establish scope** — what is being critiqued? If not stated, ask once.
2. **Read relevant context** — PRD, ADRs, CONTEXT.md, kanban, skill files, or whatever is in scope.
3. **Evaluate across four dimensions** (see below).
4. **Produce a prioritised critique report.**
5. **Ask:** "Want to work through any of these?"

## Four Dimensions of Critique

### 1. Correctness
Does it do what it claims? Are the facts, assumptions, and logic sound?
- Stated behaviour vs actual behaviour
- Assumptions that haven't been validated
- Internal contradictions

### 2. Completeness
What is missing?
- Unhandled edge cases or error states
- Gaps in coverage (user stories, skill failure modes, scope boundaries)
- Things that are implied but never defined

### 3. Consistency
Does it hold together?
- Terminology conflicts with CONTEXT.md
- Decisions that contradict existing ADRs
- Conventions applied inconsistently across files or skills

### 4. Risk
What could go wrong?
- Terminal states or irreversible actions without guards
- Ambiguity that will cause the AI to improvise badly
- Dependencies on things that don't exist yet
- Scope that will drift without discipline

## Output Format

```markdown
## Critique — [Subject]

### Strengths Worth Keeping
[What is genuinely good and should be preserved]

### P1 — Critical Issues
[Blocking problems that must be addressed]
- [Issue]: [Why it matters] — [Suggested fix]

### P2 — Should Fix
[Important but not blocking]
- [Issue]: [Why it matters] — [Suggested fix]

### P3 — Worth Considering
[Lower priority improvements or open questions]
- [Issue or question]

### Priority Fix Order
[Ordered list of recommended next actions]
```

## Metrics Logging

After presenting the critique, append one row to `docs/metrics/metrics-log.md`.
Create the file and the section header if they don't exist.

**Section header (create if absent):**
```markdown
## Critic Sessions

| Date | Subject | P1 | P2 | P3 | Total |
|------|---------|----|----|-----|-------|
```

**Append row:**
```
| YYYY-MM-DD | [brief description of subject] | N | N | N | N |
```

If `docs/metrics/` doesn't exist, create the directory. Log silently — do not mention to the user.

---

## Rules

- Be honest — the value of this skill is in what it finds, not in being kind.
- Every P1 must have a concrete suggested fix, not just a diagnosis.
- Do not implement any fixes — this skill is advisory only. Prefix with **"Advisory only — no changes made."**
- If the subject has no significant weaknesses, say so clearly and explain why — don't invent problems.
- Reference specific files, sections, or decisions when calling something out.
