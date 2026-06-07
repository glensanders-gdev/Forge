---
name: standalone-release
category: pi-release
description: Prepare and execute a standalone release for urgent config changes or small fixes that cannot wait for the next monthly release. Lighter gate than monthly releases but still HITL. Use when user runs /standalone-release or a change needs to deploy outside the monthly cycle.
---

# Standalone Release

Deploy a small change or config update outside the monthly release cycle. Lighter process than a monthly release — but still intentional, auditable, and human-approved.

## Pipeline Position

Alternative to the full `/deploy` → `/go-nogo` release path for urgent out-of-cycle changes.

```
/approve  →  /standalone-release   (urgent fix, cannot wait for monthly cycle)
```

Follows: `/approve` (change must be approved before release)
Produces: entry in `docs/releases/deploy-log.md`
Related: `/deploy` (monthly release path), `/rollback` (revert if needed)

## Eligibility Rules

Before proceeding, verify:
- [ ] Change is at least 1 week away from a monthly release date (unless marked Critical)
- [ ] Deployment is on a weekday (flag if weekend — ask for explicit confirmation)
- [ ] Change is genuinely small and self-contained — not a feature that should wait for PI planning

If the change is within 1 week of a monthly release and not Critical, stop and ask: "This is within 1 week of a monthly release. Should this wait, or is it critical enough to proceed?"

## Process

1. **Establish scope** — what exactly is being deployed? Ask the user if not stated.
2. **Check eligibility** — verify rules above.
3. **Prepare the brief** — assemble deployment details.
4. **Save brief** to `docs/releases/PI-N-standalone-N.md`.
5. **Present to human** — ask: "Type CONFIRM to proceed with this standalone release, or anything else to cancel."
6. **Record decision** and update `~/.claude/pi/[current-pi]/plan.md` — add to Standalone Releases section.
7. **Update `stakeholder.md`** — add to Express Releases section.

## Standalone Release Brief Format

```markdown
# Standalone Release Brief: PI-N-S-N

**Date:** YYYY-MM-DD
**Prepared:** YYYY-MM-DD
**Type:** Standalone — [Config / Hotfix / Minor Feature]

---

## What Is Being Deployed

[Plain English description of the change]

**Stakeholder Description:** [One sentence for external communication]

---

## Affected Projects

| Project | Change | Tickets |
|---------|--------|---------|
| [repo] | [description] | #N, #N |

---

## Risk Assessment

**Risk Level:** Low / Medium / High
**Rollback Plan:** [How to revert if something goes wrong]
**Estimated Downtime:** [None / X minutes]

---

## Eligibility Check

- [ ] More than 1 week from monthly release (or marked Critical)
- [ ] Weekday deployment
- [ ] Self-contained change

---

## Decision

**Decision:** CONFIRMED / CANCELLED
**Decided by:** [Human name]
**Time:** HH:MM DD MMM YYYY
```

## Critical Override

If the human confirms a standalone within the 1-week blackout window:
- Mark the brief as `CRITICAL OVERRIDE`
- Record the reason explicitly
- Proceed only after `CONFIRM` is typed

## Rules

- Never deploy without `CONFIRM` from the human
- Always save the brief before recording the decision
- Rollback plan is mandatory — if the human cannot state one, flag it as a risk before proceeding
- Update both `plan.md` and `stakeholder.md` after every standalone release

## Deploy Log

After a confirmed standalone release, append to `docs/releases/deploy-log.md`:

```markdown
## Standalone Deployment — YYYY-MM-DD HH:MM

**Type:** Standalone — [Config / Hotfix / Minor Feature]
**Version:** [version or commit]
**Triggered by:** /standalone-release
**Status:** ✅ Success | ❌ Failed

**Health check:** ✅ Healthy (200) | ❌ Failed ([status]) | ⚠️ Not configured
**Stakeholder description:** [one-line stakeholder description from brief]
**Notes:** [any relevant notes]
```
