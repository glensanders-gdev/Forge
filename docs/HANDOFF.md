# Handoff: Forge Framework Development

**Last updated:** 2026-05-24
**Session type:** Framework build — skills, rules, and company config
**Prepared by:** /handoff

---

## Current Ticket

No active kanban ticket — this is a Forge framework development session on branch
`claude/forge-learning-on-go-STAq0`. All changes committed and pushed.

---

## What Just Happened

A full framework build session adding metrics tracking, new skills (/continue, /pir),
a major /company-add rewrite with 7-topic operational config grilling, and promotion
of instinct-001 to a universal git-safety rule. All commits pushed to remote.

Key artifacts updated this session:

**New skills:**
- `global/.claude/skills/continue/SKILL.md` — session resumption from HANDOFF.md
- `global/.claude/skills/pir/SKILL.md` — Post Implementation Review (project or PI scope)

**New rule:**
- `global/.claude/rules/common/git-safety.md` — confirm before push (promoted from instinct-001)

**Major rewrites:**
- `global/.claude/skills/company-add/SKILL.md` — 7-topic operational config grilling (cadence, team locations/holidays, freeze periods, compliance tier, external approval, deploy chain, AI policy)
- `global/.claude/skills/dashboard-tokens/SKILL.md` — 5-section health dashboard (Token & Cost, Quality, Pipeline & Velocity, Knowledge Base, Health)

**Updated skills (metrics logging hooks):**
- `global/.claude/skills/critic/SKILL.md` — appends to docs/metrics/metrics-log.md
- `global/.claude/skills/lookup/SKILL.md` — appends to metrics-log.md
- `global/.claude/skills/diagnose/SKILL.md` — appends to metrics-log.md
- `global/.claude/skills/sprint-end/SKILL.md` — appends to metrics-log.md; retro to company dir

**Updated skills (company config wiring):**
- `global/.claude/skills/go-nogo/SKILL.md` — freeze periods, compliance tier, external approval gate
- `global/.claude/skills/standup/SKILL.md` — freeze period warnings, public holiday locale flags
- `global/.claude/skills/sprint-start/SKILL.md` — holiday/freeze check in sprint period
- `global/.claude/skills/security-assessment/SKILL.md` — compliance tier behaviour table
- `global/.claude/skills/fy-review/SKILL.md` — PIR as data source; AI assistance metrics added
- `global/.claude/skills/handoff/SKILL.md` — clarified vs /debrief vs /save-state
- `global/.claude/skills/debrief/SKILL.md` — session close hierarchy clarified
- `global/.claude/skills/sprint-end/SKILL.md` — sprint retro written to company directory

---

## Next Action

Run `/critic` on the full set of new and updated skills from this session to catch
any P1/P2 issues before the branch is merged — particularly:
- /company-add (large rewrite, complex grilling flow)
- /pir (new skill, complex HITL flow)
- /continue (new skill, staleness check logic)
- /dashboard-tokens (rewrite, 14 panels, graceful empty states)

---

## Context the Next Session Will Need

- Branch: `claude/forge-learning-on-go-STAq0` — all work is on this branch, not merged to main
- instinct-001 promoted to rule — `~/.claude/instincts/` updated locally (not in Forge repo)
- git-safety rule is now active — confirm before every push (summarise commits, ask yes/no)
- The /pir skill notes that PIR documents feed /fy-review; /fy-review was updated to read from `~/.claude/companies/[active_company]/pir/` as a data source
- /sprint-end now writes retros to the company directory — this is a behaviour change for existing installs

---

## Open Decisions

- **PR to main**: The branch `claude/forge-learning-on-go-STAq0` has not been merged. Decision on whether/when to open a PR is pending.
- **`/deploy` skill**: Should be updated to read `deployment_chain` and `deployment_manual_gates` from company config — noted as a future task, not yet implemented.
- **`/build` skill**: Should read `ai_human_signoff_required` from company config to add a HITL gate — noted in /company-add confirm output but not yet implemented in /build.
- **`/pii-check` skill**: Should surface `ai_data_restrictions` from company config — noted but not yet implemented.

---

## Blockers

None.

---

## Suggested Skills for Next Session

1. `/critic` — run across the new and rewritten skills from this session before merge
2. `/continue` — use this at the start of the next session to resume cleanly from this handoff
3. `/grill-with-docs` — if starting a new feature area; the framework has grown significantly and may benefit from a fresh capability review

---

💡 Did anything this session produce a pattern worth capturing?
   Run /user:learn to capture it before it's forgotten.
