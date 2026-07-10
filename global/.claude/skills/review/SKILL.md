---
name: review
category: code-quality
version: 2.0.0
description: Two-axis structured code review of a pinned diff — a Spec axis (does the change fulfil its originating requirement) and a Standards axis (project docs + an immutable code-smell baseline), judged by isolated parallel sub-agents and reported without merging. Runs per-ticket after /build and on demand. Advisory by default.
origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills)
---

# Review

Review a **pinned diff** along two independent axes and report them separately. A change can pass one axis and fail the other — ship the feature but drift on quality, or write clean code that solves the wrong problem — so the axes are judged in isolation and never blended into a single list.

Execution mode: **[AFK]** advisory — the review runs autonomously and produces a report; it changes no code unless a human explicitly asks. When wired into `/build` it fires per ticket; it is also human-invokable any time via `/review`.

> Adapted from Matt Pocock's `code-review` skill (github.com/mattpocock/skills). Forge keeps the two-axis + isolated-sub-agent structure, the fixed-point diff, and the Fowler smell baseline; it translates the git plumbing to Forge's kanban-driven ticket diffs, its own P1/P2/P3 severities, and its ADR/CONTEXT/PRD sources of truth.

## Pipeline Position

```
/build (per ticket: /tdd → /review) → /qa-plan → /pii-check → /approve
```

`/build` calls this skill on each ticket's diff once its `/tdd` cycle goes green, before moving to the next ticket. Run standalone at any time to review an arbitrary diff.

## The Two Axes

| Axis | Question it answers | Sources |
|------|--------------------|---------|
| **Spec** | Does the diff actually deliver the requirement it was written for — no missing behaviour, no scope creep, no incorrect implementation? | Active PRD user stories, the ticket brief, `docs/testplan-*`, referenced ADRs |
| **Standards** | Does the diff conform to how *this project* writes code, and is it free of baseline code smells? | `docs/CONTEXT.md`, `docs/adr/`, `.claude/CODING-STANDARDS.md`, active language rules, `.claude/rules/`, plus the immutable [smell baseline](smell-baseline.md) |

The axes stay separate on purpose. Do not let a strong Spec result excuse a Standards problem, or vice versa.

## Process

### Step 1 — Pin the fixed point

Establish the exact diff under review. Never review the whole codebase blind.

- **Inside `/build`:** the fixed point is the ticket's own changes — the files written during this ticket's `/tdd` cycle. Review only those.
- **Standalone:** take the reference the user gives (commit SHA, branch, tag). Confirm it resolves and yields a non-empty diff (`git diff <fixed-point>...HEAD`, three-dot merge-base). If no reference is given, ask which diff to review — do not guess.

If the diff is empty, stop and say so.

### Step 2 — Identify the Spec source

Find what the change was supposed to do, in priority order:

1. The active PRD user stories in `docs/prd/active/` and the ticket brief driving this build.
2. An issue or requirement referenced in the ticket or commit messages.
3. A matching spec under `docs/`, `docs/testplan-*`, or `specs/`.
4. If none is found, ask the human what requirement this diff serves — a Spec review with no spec is not a Spec review.

### Step 3 — Identify the Standards sources

Gather the project's own documented standards first — `docs/CONTEXT.md` (domain terms), `docs/adr/` (architectural decisions), `.claude/CODING-STANDARDS.md`, and the active language rules under `.claude/rules/`. Then layer the immutable [smell baseline](smell-baseline.md) underneath them.

**The repo overrides.** Documented project standards always win over the baseline. If a project doc endorses a pattern the baseline calls a smell, the doc wins — do not flag it. **Skip anything a linter or formatter already enforces** — tooling owns those; a review that repeats them is noise. Every baseline smell is a *judgment call*, never a hard violation.

### Step 4 — Run both axes in isolation

Judge the two axes independently so neither contaminates the other. Delegate each to its own sub-agent with a separate prompt and no shared working context (per the model-selection rule — this is parallelisable sub-reasoning, so keep the main thread on Opus and route each axis to its own sub-agent):

- **Spec sub-agent** — given only the diff and the Spec sources, find: behaviour required but missing, behaviour added beyond the requirement (scope creep), and behaviour implemented incorrectly against the stated intent.
- **Standards sub-agent** — given only the diff and the Standards sources, find: violations of documented project standards (cite the exact ADR / CONTEXT term / standard), and un-overridden, non-tooling smells from the baseline.

Neither sub-agent sees the other's findings.

### Step 5 — Aggregate without merging

Present both axes under separate headings, in their own severity order. Do not merge them into one list and do not re-rank one axis by the other. A human reads the two axes side by side and decides.

## Severity

Within each axis, rank findings honestly:

- **P1 — Blocking**: the requirement is not met, or a documented standard / ADR is violated. Must be resolved before the ticket is considered done.
- **P2 — Should fix**: real problem, not blocking — a smell worth removing, a minor scope drift.
- **P3 — Suggestion**: judgment-call improvement.

Documented-standard breaches and Spec misses are the only things that reach P1. Baseline smells are P2 at most unless they cause an actual correctness or ADR problem.

## Output Format

```markdown
## Code Review — [ticket #N or fixed-point ref] — YYYY-MM-DD
Advisory only — no changes made.

### Spec Axis — does it fulfil the requirement?
**P1 — Blocking**
- [Missing/incorrect behaviour]: [file:line] — [which PRD story / requirement] — [what's wrong]
**P2 — Should Fix**
- ...
**P3 — Suggestions**
- ...
**Passed**: [what the diff correctly delivers]

### Standards Axis — does it match how we write code?
**P1 — Blocking**
- [Violation]: [file:line] — [exact ADR / CONTEXT term / standard cited] — [fix]
**P2 — Should Fix**
- [Smell name]: [file:line] — [why] — [remedy]
**P3 — Suggestions**
- ...
**Passed**: [areas clean]
```

Close with: *"Want me to fix any of these, or are you handling them manually?"*

## Rules

- Never merge the two axes into one list, and never re-rank one axis by the other — report them separately.
- Never review the whole codebase blind — always pin a fixed point first.
- Never flag anything a linter or formatter already enforces.
- Never flag a baseline smell the project's own docs explicitly endorse — the repo overrides.
- Never treat a baseline smell as a hard violation — smells are judgment calls; only documented-standard breaches and Spec misses are P1.
- Never fix anything without explicit instruction — advisory by default; prefix the report with **"Advisory only — no changes made"** unless the user asked for fixes.
- Never manufacture P3s to look thorough — if an axis is clean, say so under **Passed**.
- Always cite the specific ADR, CONTEXT term, standard, or PRD story a finding violates — an uncited finding is an opinion.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No fixed point / empty diff | Ask which diff or ref to review — never review the whole codebase blind, never proceed on an empty diff. |
| No PRD, ticket brief, or spec found | Run the Standards axis only; state plainly that the Spec axis was skipped for lack of a requirement to check against. |
| No ADRs, CONTEXT.md, or coding standards exist | Run the Standards axis against the [smell baseline](smell-baseline.md) and the codebase's own conventions; state that no documented project standards were available. |
| Sub-agents unavailable in this environment | Run both axes inline on the main thread, but keep them as two separate passes with separate reports — do not collapse them into one. |
| User asks for fixes mid-review | Leave advisory mode only on explicit instruction; apply fixes for the named findings only. |
| Both axes clean | Say so plainly under **Passed** on each axis — never invent findings. |
