---
name: "review"
description: "Structured code review against the project's ADRs, CONTEXT.md, layer conventions, and coding standards. Use when user runs $review, wants a code review, or implementation is complete and needs quality checking before QA."
metadata:
  category: code-quality
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Review

Conduct a structured code review against the project's own documented standards — not generic best practices. The goal is to catch issues that matter for this specific project.

## Process

1. Read `docs/CONTEXT.md` — domain terminology to check against.
2. Read `docs/adr/` — architectural decisions that code must respect.
3. Read `.codex/forge/CODING-STANDARDS.md` if it exists — project coding standards.
4. Read the active PRD from `docs/prd/active/` — intended behaviour to verify against.
5. Explore the changed or relevant code.
6. Produce a prioritised review report.
7. Ask: "Want me to fix any of these, or are you handling them manually?"

## Review Checklist

For each area, flag issues as P1 (blocking), P2 (should fix), or P3 (suggestion):

### Correctness
- [ ] Code does what the PRD user stories describe
- [ ] Edge cases from the PRD are handled
- [ ] Error states fail gracefully

### Domain Integrity
- [ ] Terminology matches `docs/CONTEXT.md` — no synonym drift
- [ ] Business rules match the domain model, not just the implementation

### Architecture
- [ ] No decisions contradict existing ADRs
- [ ] Layer boundaries respected (`[UI]` / `[DATA]` / `[LOGIC]` / `[SYNC]` / `[INFRA]`)
- [ ] Changes touching 3+ places flagged for review

### Code Quality
- [ ] No `innerHTML` in error handling code
- [ ] No native browser dialogs (`confirm` / `alert` / `prompt`)
- [ ] Event listeners scoped to correct containers
- [ ] No credentials in client-side code
- [ ] Silent failures have logging

### Standards
- [ ] Matches patterns in `.codex/forge/CODING-STANDARDS.md` (if exists)
- [ ] Consistent with existing codebase conventions

## Output Format

```markdown
## Code Review — YYYY-MM-DD

### P1 — Blocking
- [Issue]: [File/function] — [why it matters] — [suggested fix]

### P2 — Should Fix
- [Issue]: [File/function] — [why it matters] — [suggested fix]

### P3 — Suggestions
- [Issue]: [File/function] — [consideration]

### Passed
- [Area]: No issues found
```

## Rules

- Prioritise issues honestly — not everything is P1.
- Reference the specific ADR, CONTEXT term, or standard being violated.
- Do not fix anything without explicit instruction — this is advisory by default.
- Prefix the response with **"Advisory only — no changes made"** unless the user asks for fixes.
