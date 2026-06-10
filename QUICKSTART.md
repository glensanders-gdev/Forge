# Forge Quick Start

**5 minutes to your first feature.**

See `INSTALL.md` for full installation details. This guide assumes Forge is already installed.

**Invocation syntax:** Claude Code uses `/user:skill-name`; Codex uses `$skill-name`. The workflow and artifacts are otherwise kept at parity.

---

## Step 1 — Start a new idea (2 min)

Open Claude Code anywhere and type:

```
/user:idea
```

Pitch your idea. The agent will grill you on the problem, baseline, targets, and approach — one question at a time. At the end, type `ACCEPT` to proceed.

---

## Step 2 — Create the project (1 min)

```
/user:create-project
```

The agent derives a repo name, asks public or private, then creates the repo, scaffolds Forge, and pushes to your remote. Fill in `CLAUDE.md` with your project details when prompted.

---

## Step 3 — Design the solution (2 min)

```
/user:grill-with-docs
```

Stress-test the design against your domain model and codebase. One question at a time — the agent recommends an answer for each and updates `CONTEXT.md` inline as terms are resolved. When you confirm shared understanding, it suggests moving to `/write-prd`.

---

## Step 4 — Write the PRD

```
/user:write-prd
```

The agent explores the codebase (AFK), presents a scope summary, you confirm, it writes the PRD.

---

## Step 5 — Open a sprint and build

```
/user:sprint-start
/user:build
```

`/sprint-start` captures your goals. `/build` executes the AFK tickets in sequence — running TDD for each, pausing at HITL tickets.

---

## Step 6 — QA and ship

```
/user:qa-plan
/user:pii-check
/user:approve
```

Work through the QA checklist, review PII findings, then type `APPROVE` to close the feature.

---

## The essential commands

| When | Command |
|------|---------|
| Non-technical stakeholder submitting an idea | `/user:front-gate` |
| New idea (developer) | `/user:idea` |
| Create project (after idea accepted) | `/user:create-project` |
| Design / planning phase | `/user:grill-with-docs` |
| Ad-hoc stress-test | `/user:grill-me` |
| Plan | `/user:write-prd` |
| Start sprint | `/user:sprint-start` |
| Build | `/user:build` |
| QA | `/user:qa-plan` + `/user:pii-check` |
| Ship | `/user:approve` |
| Forgot a command | `/user:commands` |

---

## Tips

- **Stuck mid-session?** Run `/user:handoff` to save state and pause cleanly. For end-of-day full close (updates kanban + DEVLOG), use `/user:debrief`.
- **Something broken?** Run `/user:diagnose` — the agent forms a hypothesis before touching anything.
- **Scope creeping?** Run `/user:scope-check` to force an explicit decision.
- **Existing project?** Skip steps 1–2 and run `/user:onboard` instead.
- **Setting up for a company?** Run `/user:company-add [name]` to configure sprint cadence, holidays, freeze periods, compliance tier, and AI policy. Add `--quick` to apply all defaults in under 30 seconds.
