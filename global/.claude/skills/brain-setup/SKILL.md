---
name: brain-setup
category: knowledge
description: Scaffold and audit the Karpathy second-brain knowledge model — three tiers (global, company, project) each with Raw/ and Wiki/, a mandatory human-declared scope (personal or company) for every project, and a company pending-changes record for in-flight work. Use when user runs /brain-setup, sets up the knowledge base on a new machine or new company, or when projects need scope declared or the tier structure audited.
origin: Knowledge model adapted from Andrej Karpathy's second-brain pattern (Raw sources compiled into a curated Wiki)
---

# Brain Setup

**Mode: [HITL]** — scope declarations and folder moves require direct human answers;
automated messages and hook output do not count.

Set up or audit the three-tier second-brain model. Every tier follows the same pattern:
`Raw/` holds unedited source material, `Wiki/` holds curated compiled articles, and
`/ingest` moves material from one to the other.

| Tier | Path | Holds |
|------|------|-------|
| Global | `~/.claude/knowledge/` | Knowledge relevant to you in every context, plus **personal** projects |
| Company | `~/.claude/companies/[active_company]/knowledge/` | Company knowledge, plus **company** projects |
| Project | `[tier]/projects/[name]/` | Project knowledge, segregated until the project deploys |

(`systems/` and `learning/` under the global tier belong to /add-system and /teach.)

**Scope** decides which tier a project lives under. The sole source of truth is the
`_scope.md` marker in the project's knowledge folder (template in FORMATS.md), and
**absence means company-restricted**: a project folder without `_scope.md` is never
shared, moved, or compiled into the global tier — the safe state is the zero-effort state.

- `personal` — lives under global `knowledge/projects/`, permanently. It never merges into
  a company tier, even while `active_company` is set — a hobby or side project stays
  personal regardless of which employer context is active.
- `company` — lives under the company `knowledge/projects/`. Valid only when `company:`
  names an existing `~/.claude/companies/[name]/` — otherwise refuse the declaration,
  point to /company-add, and leave the project restricted. Its Wiki stays segregated until
  the project deploys; the deploy-time merge belongs to /deploy post-deployment cleanup
  (backlogged 2026-07-13), not this skill.
- Scope is declared one project at a time by a direct human answer. With no company
  configured, `personal` is the only declarable scope — still asked explicitly per
  project, never assumed.

## Process

1. **Read state** — `~/.claude/preferences.md` (`active_company`) and the `projects/`
   folders of both tiers.
2. **Verify the global tier** — create only what is missing: `Raw/_compiled.log`,
   `Wiki/_index.md`, `Wiki/_changelog.md` (templates in FORMATS.md). Complete when all
   three exist.
3. **Verify the company tier** (skip when no `active_company`) — same three files plus
   `Wiki/pending-changes.md` (template in FORMATS.md).
4. **Declare scope for every project folder lacking `_scope.md`** — present its name and
   current location, ask for its scope, and wait for a direct human answer. On a valid
   answer, write `_scope.md`. Complete when every project folder either has a marker or
   its unanswered question is flagged as restricted in the report.
5. **Flag misplacements** — a company-scoped project under the global tier, or a
   personal-scoped project under a company tier. For each: state source and destination
   paths, warn that moving into a git-synced company directory shares the content with
   the team on the next /company-sync, and move only on a typed `CONFIRM` for that
   specific project.
6. **Report** — tiers verified, files created, scopes declared, folders left restricted
   (blocking — re-asked next run), moves made, and open pending-changes rows.

## Scope Changes

Re-declaring `personal` → `company` reruns steps 4–5 for that project, same gates.
**`company` → `personal` is forbidden in this skill** — the content may already exist in
company git history and on the team remote, where no move removes it. State this and stop:
reclaiming company-held knowledge is a manual human action outside Forge.

## Pending Changes

The company `Wiki/pending-changes.md` is the human's ledger of knowledge changes expected
from in-flight company projects — status `Potential` or `Confirmed`, resolved only when
the project deploys and its Wiki merges (the /deploy cleanup). This skill maintains the
file and surfaces open rows in every report; adding rows as changes crystallise is the
human's discipline until /ingest is patched to prompt for it (backlog).

## Rules

- Scope is declared by a direct human answer, never inferred or defaulted — ask and wait.
- Treat a project folder without `_scope.md` as company-restricted: never share, move, or
  compile its knowledge into the global tier.
- Never accept `scope: company` naming a company with no `~/.claude/companies/[name]/`.
- Never change scope `company` → `personal` — manual action outside the skill.
- Every folder move requires a typed `CONFIRM` for that specific project.
- Setup is additive: create missing files only; leave every existing file untouched.
- Project Wiki content stays in the project folder until deployment — link to company or
  global articles, don't copy content across tiers.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No `active_company` set | Verify the global tier only; `personal` is the only declarable scope — still asked per project, never assumed. |
| Declared company doesn't exist locally | Refuse the declaration, point to /company-add, leave the project restricted. |
| No human answer to a scope question | Leave the marker absent — the folder stays restricted; flag as blocking and re-ask next audit. |
| Registered project has no knowledge folder | No scope needed yet — nothing to protect; point to /add-project when knowledge starts. |
| Asked to change scope company → personal | Refuse — state the git-history reason and stop; manual action outside the skill. |
| A template's target file already exists | Leave it untouched; note "exists — skipped" in the report. |
| Asked to merge a deployed project's Wiki | Out of scope — /deploy post-deployment cleanup (backlog, 2026-07-13). |
