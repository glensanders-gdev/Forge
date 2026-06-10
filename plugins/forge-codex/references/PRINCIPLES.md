# Forge Design Principles

The philosophy behind the Forge framework. Read this before writing a new skill — it explains why the framework is shaped the way it is and should guide any addition or change.

Forge draws on techniques and skills by Matt Pocock (AIHero.dev / github.com/mattpocock/skills), adapted for structured software delivery.

---

## 1. The AI Executes. The Human Decides.

The AI is a disciplined co-worker, not an autonomous agent. It follows process, keeps records, runs checklists, and flags when something is missing. Every significant decision — what to build, whether to ship, how to handle a failure — requires a human to confirm it explicitly.

This principle is reflected throughout Forge:
- Every skill that touches production requires `CONFIRM`, `APPROVE`, `GO`, or `ROLLBACK [version]` typed by a human
- `$approve`, `$deploy`, `$go-nogo`, `$rollback` all have hard confirmation gates
- No skill auto-reverses, auto-deploys, or auto-decides on behalf of the human

When writing a new skill: if the action is consequential or irreversible, it needs a human gate. If it's mechanical and repeatable, it can be AFK.

---

## 2. Negative Space Programming

Borrowed from visual art — in painting, the space *around* a subject defines it as much as the subject itself. In programming with AI, **what you explicitly prohibit is as important as what you specify**.

The AI will fill whatever space it is given. Defining constraints — what never to do, what to never skip, what to always check first — produces more consistent, safer, and more predictable output than positive instructions alone.

Forge applies this everywhere:
- `ERROR-HANDLING.md` — "Never use `innerHTML` in error handlers"
- `SECURITY.md` — "Never store API keys in source code"
- `$build` — "Never deploy. Never auto-rollback."
- `$pii-check` — "Never reproduce actual PII values"
- `known-issues.md` `Do Not Attempt` entries — explicit negative space per system

When writing a new skill: every skill should have explicit "never" rules, not just "do this" instructions.

---

## 3. HITL and AFK Are Explicit, Not Implied

Every unit of work is labelled. `[HITL]` — Human in the Loop — means a person must be present. `[AFK]` — Away from Keyboard — means the AI can proceed autonomously. These are not suggestions; they are load-bearing labels that affect how `$build` executes, how the sprint is planned, and what the stakeholder view shows.

Skills should declare their execution mode clearly. A skill that pauses mid-way for human input without labelling itself HITL creates confusion.

---

## 4. Smart Zone Thinking

Every unit of work should be sized to fit within a context window in one pass. The smart zone is approximately 100k tokens. Tasks that exceed this are split before they are executed — not discovered to be too large mid-build.

This is why `$estimate` exists before `$build`, why `$break-down` is a first-class skill, and why `$build` checks token estimates before executing each ticket. A task that cannot be completed in one context window is not one task — it is several.

---

## 5. Structure Is the Default

The framework enforces structure not as overhead but as protection. A plan that skips the grill phase produces a PRD built on assumptions. A release that skips Go/No Go has no gate. A feature that skips PII check may ship a compliance risk.

Every phase exists because its absence causes a known class of failure. When in doubt, keep the gate rather than remove it.

The pipeline begins at Phase 0 (front-gate) — a non-technical stakeholder intake gate that precedes developer involvement. It ensures ideas are captured in a structured Request Brief before they reach the engineering workflow, preventing scope that was never properly articulated from entering the build pipeline.

---

## 6. Reference, Don't Duplicate

Information should live in one place. `AGENTS.md` references `CODING-STANDARDS.md` rather than containing it. `HANDOFF.md` references the kanban rather than reproducing ticket status. The `$handoff` skill references artifact paths rather than copying their content.

Duplication creates drift. When the PRD changes and a summary somewhere else doesn't, the inconsistency is worse than having no summary. Single source of truth, always.

---

## 7. Estimates Are Signals, Not Contracts

Token cost bands and story points are calibration tools, not commitments. An XL estimate signals "break this down before building." A consistent pattern of M estimates landing in the upper band signals "adjust the band boundaries." The estimate is a conversation starter, not a deadline.

This is why `$estimate` always presents a table for human confirmation rather than writing estimates automatically — the human calibrates the signal, the AI doesn't own it.

---

## 8. Every Decision Gets Recorded

Decisions that get made verbally and forgotten are the primary cause of "why did we do it this way?" six months later. Forge records decisions in ADRs, DEVLOG session notes, and the registry. The `known-issues.md` records what was deferred and why. The `kanban-archive.md` records estimated vs actual token costs.

The framework is designed so that the cost of recording a decision is lower than the cost of not having it recorded.

---

## Applying These Principles

When adding a new skill, ask:

1. Where is the human gate — what requires explicit confirmation?
2. What are the explicit "never" rules — the negative space?
3. Is the execution mode declared — HITL or AFK?
4. Does this fit in a smart zone — or does it need a break-down option?
5. Is any information duplicated that should be referenced instead?
6. What gets recorded and where?

---

## Further Reading

For a detailed operating model applying these principles to team processes, architecture, and hiring, see the `ai-first-engineering` skill. It covers what changes when AI generates most of the implementation output and how Forge's pipeline embodies each principle.
