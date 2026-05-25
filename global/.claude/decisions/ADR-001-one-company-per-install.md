# ADR-001 — One Company Per Forge Install

**Status:** Accepted
**Date:** 2026-05-25
**Deciders:** Glen Sanders

---

## Context

Forge resolves company-specific paths (knowledge base, config, tools registry, rules)
at runtime by reading `active_company` from `~/.claude/preferences.md` and constructing
paths like `~/.claude/companies/[active_company]/knowledge/`.

The question arose: should a single Forge install support switching between multiple
company contexts (e.g. for a consultant working with several clients)?

---

## Decision

**One company per Forge install.** `active_company` is a single value. `/company-add`
blocks if a company is already configured. There is no `/company-switch` command.

---

## Reasons

1. **Unambiguous path resolution.** Every skill that reads knowledge, config, or tools
   resolves a single path. A multi-company model would require every skill to ask
   "which company?" or inspect context — adding conditional logic to 20+ skills.

2. **Knowledge contamination risk.** With multiple companies active, `/ingest`,
   `/lookup`, and `/add-system` could silently write to the wrong company's knowledge
   base. The cost of that mistake (sensitive client data crossing company boundaries)
   is high.

3. **Config conflicts.** Company config drives behaviour in `/build`, `/deploy`,
   `/go-nogo`, `/pii-check`, and `/standup`. Two companies with different compliance
   tiers, deployment chains, or AI policies cannot safely share a single active config.

4. **One machine = one context.** In practice, the overwhelming majority of users work
   for one employer at a time. Optimising for the common case is correct.

---

## Consequences

- Consultants or contractors working across clients must use separate machines,
  separate OS user accounts, or separate Forge installs (e.g. one per WSL distro).
- There is no runtime overhead from conditional company resolution in skills.
- The constraint is clearly documented at the `/company-add` pre-check rather than
  discovered by accident.

---

## Revisit Criteria

Revisit this decision if:
- Multiple users report the constraint as a significant blocker (not just an inconvenience)
- A clean multi-company design emerges that doesn't require conditional logic in every skill
- Claude Code adds native workspace/profile isolation that provides the boundary instead

---

## Alternatives Considered

**`/company-switch [name]`** — a command that updates `active_company` at runtime.
Rejected because it does not solve the knowledge contamination risk: if a user forgets
to switch before running `/ingest`, sensitive content lands in the wrong company repo.
A switch command makes the problem easier to trigger, not harder.

**Namespace prefix in every path** — skills accept a `--company [name]` flag.
Rejected because it would require updating every company-aware skill (20+) and would
make routine usage more verbose with no benefit for the common case.
