---
name: "ai-first-engineering"
description: "Operating principles for teams delivering software with AI-assisted code generation. Shapes how planning, review, architecture, and testing work when AI generates a significant share of implementation output. Use during $grill-with-docs, $review, $write-prd, and $testplan to apply AI-first thinking to design and process decisions."
metadata:
  category: code-quality
  version: 1.0.0
  origin: Adapted from ECC (github.com/affaan-m/ECC) by Affaan Mustafa
---

# AI-First Engineering

Operating model for teams where AI agents generate a significant share of implementation output. The skills, habits, and expectations that change when AI writes most of the code.

Use during planning, architecture decisions, code review, and testplan design to apply AI-first thinking consistently.

---

## The Core Shift

In traditional engineering, the bottleneck is typing speed. In AI-first engineering, the bottleneck is **planning quality and verification discipline**. The agent can generate code faster than any developer — but only the human can ensure the right thing is being built and that it actually works.

**This is why Forge front-loads planning.** `$grill-with-docs`, `$write-prd`, and `$testplan` exist because the quality of what gets built is determined before `$build` runs, not during it.

---

## Process Principles

**1. Planning quality matters more than execution speed.**
Ambiguous requirements produce plausible-looking but incorrect code. Every assumption not surfaced in `$grill-with-docs` or the PRD becomes a defect. Invest in the front of the pipeline — it pays back in the build phase.

*Forge application:* Never skip `$grill-with-docs`. `$grill-me` is for ad-hoc stress-testing; `$grill-with-docs` is the planning standard because it checks the domain model.

**2. Measurable acceptance criteria, not vague descriptions.**
"The login should work" is not an acceptance criterion. "A user with valid credentials can authenticate and is redirected to `/dashboard` within 2 seconds" is. AI generates code to match the spec — the spec must be precise.

*Forge application:* PRD Definition of Done and testplan entries are the acceptance criteria. TC-NNN IDs make them traceable. Vague entries in the testplan produce vague tests.

**3. Eval coverage matters more than anecdotal confidence.**
"It worked when I tried it" is not a quality signal for AI-generated code. Regressions are the primary risk — the agent may fix one thing and break another without awareness. Automated test coverage is the defence.

*Forge application:* `$tdd` enforces red-green-refactor. The testplan defines coverage before build. `$qa-plan` verifies behaviour against the original spec, not against the implemented code.

**4. Review focus shifts from syntax to system behaviour.**
Linting and style are cheap to automate. Code review in AI-first teams should focus on: behaviour regressions, security assumptions, data integrity, failure handling, and rollout safety. Not semicolons.

*Forge application:* `$review` checks against ADRs, `CONTEXT.md`, and `CODING-STANDARDS.md` — not style. `$pii-check` covers data integrity. `$go-nogo` covers rollout safety.

**5. Raise the testing bar for generated code.**
Generated code is fluent — it looks correct and compiles cleanly while containing subtle logic errors. The testing bar must be higher, not lower, because the code is produced faster and in larger volumes.

*Forge application:* Required regression coverage for any touched domain. Explicit edge-case assertions in testplan. Integration checks at every interface boundary. XL tickets must be broken down — smart zone discipline prevents context overrun that degrades code quality.

---

## Architecture Requirements

Prefer architectures that are **agent-friendly**:

| Prefer | Avoid |
|--------|-------|
| Explicit module boundaries | Logic spread across hidden conventions |
| Stable, typed interfaces | Implicit contracts assumed from context |
| Deterministic, fast tests | Tests that require environmental state |
| Clear single responsibility | God modules that do everything |
| Explicit error paths | Silent failures |

The agent works best when each unit of work has a clear boundary, a clear interface, and clear success criteria. This is also what makes good architecture — AI-first thinking reinforces engineering fundamentals, not replaces them.

*Forge application:* `$break-down` splits tickets to respect module boundaries. ADRs record interface decisions explicitly. `$diagnose` investigates failures systematically — never guess-and-check.

---

## Code Review in AI-First Teams

Review for:

- **Behaviour regressions** — does this change break any existing behaviour?
- **Security assumptions** — are credentials handled correctly? Is user data scoped correctly?
- **Data integrity** — are edge cases handled? What happens with null, empty, or unexpected input?
- **Failure handling** — does the code fail safely? Are errors surfaced or swallowed?
- **Rollout safety** — can this be rolled back? Is it backward-compatible?

Minimise time spent on style issues already handled by `CODING-STANDARDS.md` and linting.

*Forge application:* `$review` uses this checklist. `$pii-check` covers data integrity specifically. `$go-nogo` is the final rollout safety gate.

---

## Testing Standard for Generated Code

| Standard | Detail |
|---------|--------|
| Regression coverage | Every domain touched by the feature must have regression tests |
| Edge-case assertions | Explicit tests for null, empty, boundary, and error conditions |
| Interface boundary checks | Integration tests at every boundary between modules |
| Behaviour tests | Tests describe observable behaviour, not implementation details |
| No untested XL tickets | XL tickets must be broken down — smart zone protects test quality |

*Forge application:* Testplan defines coverage before build. TC-NNN IDs track each case from definition through implementation to QA results. Actuals vs estimates in `kanban-archive.md` reveal where complexity was underestimated.

---

## Signals of Strong AI-First Engineers

Engineers who thrive in AI-first delivery:

- Decompose ambiguous work cleanly before asking the agent to build it
- Define measurable acceptance criteria in the testplan, not after the fact
- Produce high-signal PRDs that give the agent a shaped container to work within
- Enforce risk controls (Go/No Go, PII check, rollback plan) under delivery pressure
- Treat the agent's output as code to be reviewed, not code to be trusted

---

## Anti-Patterns in AI-First Teams

- **Vibe-building** — running `$build` on a poorly specified PRD and hoping it works
- **Skipping testplan** — "we'll write tests later" means regressions arrive in production
- **Rubber-stamp review** — approving AI-generated code without checking behaviour
- **Context overrun** — building XL tickets in one pass, producing degraded output in the second half
- **Missing the gate** — deploying without Go/No Go because the agent said it was ready

---

## Forge Pipeline Alignment

Every Forge phase embodies an AI-first principle:

| Phase | AI-First principle applied |
|-------|---------------------------|
| `$grill-with-docs` | Planning quality over execution speed |
| `$write-prd` + `$estimate` | Measurable acceptance criteria upfront |
| `$testplan` | Raise the testing bar before build |
| `$build` (with smart zone) | Bounded units produce higher-quality output |
| `$review` + `$pii-check` | Behaviour and data integrity over syntax |
| `$go-nogo` | Rollout safety gate — human decides |
| `kanban-archive.md` actuals | Eval coverage — did the estimates hold? |

## Rules

- This is an operating lens applied within other skills — it shapes decisions, it doesn't produce an artefact of its own.
- Never let execution speed override planning quality — front-load the pipeline.
- Treat AI-generated code as code to be reviewed, not trusted — never rubber-stamp.
- Never run `$build` on a vaguely specified PRD, and never deploy without the `$go-nogo` gate.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Tempted to skip `$grill-with-docs` or `$testplan` | Don't — planning quality is the bottleneck; skipping it ships regressions. |
| PRD has vague acceptance criteria | Sharpen them into measurable TC-NNN entries before build — vague specs produce vague code. |
| Review focuses on style/syntax | Shift focus to behaviour, security, data integrity, failure handling, and rollout safety. |
| An XL ticket is about to be built in one pass | Break it down first — context overrun degrades generated code quality. |
| "It worked when I tried it" offered as the quality signal | Insufficient — require regression and edge-case coverage. |
| Asked to produce a standalone deliverable from this skill | It's a lens, not a generator — apply it within another skill rather than emitting a document. |
