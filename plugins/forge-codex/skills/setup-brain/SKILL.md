---
name: "setup-brain"
description: "Scaffold and audit the Karpathy second-brain knowledge model — a root knowledge space plus one space per project, each with Raw/ and Wiki/, a mandatory human-declared scope for every project space, and a pending-changes ledger for in-flight shared work. Use when user runs $setup-brain, sets up the knowledge base on a new machine, or when project spaces need scope declared or the structure audited."
metadata:
  category: knowledge
  origin: Knowledge model adapted from Andrej Karpathy's second-brain pattern (Raw sources compiled into a curated Wiki)
---

# Brain Setup

**Mode: [HITL]** — scope declarations and folder moves require direct
human answers; automated messages and hook output do not count.

Set up or audit the second-brain model. Every knowledge space follows the same pattern:
`Raw/` holds unedited source material, `Wiki/` holds curated compiled articles, and
`$ingest` moves material from one to the other.

| Space | Holds |
|-------|-------|
| Root | Knowledge relevant in every context, and the destination a shared project's Wiki merges into |
| Company | Company knowledge, and the merge destination for any project scoped to that company |
| Project | One project's knowledge, segregated until the project ships |

The root space is `~/.codex/forge/knowledge/`, the company space is
`~/.codex/forge/companies/[active_company]/knowledge/`, and a project space is `projects/[name]/`
beneath either. (`systems/` and `learning/` under the root space belong to `$add-system` and
`$teach`.)
Where no root space exists yet, create `knowledge/Raw/` and `knowledge/Wiki/` at
the repository root; a project space is `projects/[name]/` beneath it.

**The shared space** is where a shared project's Wiki merges when the project ships. That is the
root space, or the company space wherever `active_company` is set.
A private project's Wiki never reaches it.

**Scope** decides whether a project's knowledge ever leaves its own folder. The sole source of
truth is the `_scope.md` marker in the project space (template in FORMATS.md), and **absence means
restricted**: a project space without `_scope.md` is never shared, moved, or compiled into the
shared space — the safe state is the zero-effort state.

- `private` — its Wiki never merges outward and nothing in it is copied out, permanently. A
  project declared private stays private, and it lives under the root space's
  `projects/` even while `active_company` is set — a hobby or side project stays personal
  regardless of which employer context is active.
- `shared` — its Wiki merges into the shared space when the project ships, and stays segregated
  until then. It lives under the company space's `projects/`, and `shared_with:`
  is valid only when it names an existing `~/.codex/forge/companies/[name]/` — otherwise refuse the
  declaration, point to `$add-company`, and leave the project restricted. The merge itself belongs
  to `$deploy` post-deployment cleanup (backlogged 2026-07-13), not this skill.
- Scope is declared one project at a time by a direct human answer. With no
  company configured, `private` is the only declarable scope — still asked explicitly per project,
  never assumed.

## Process

1. **Read state** — every project space beneath the root space, plus
   `active_company` in `~/.codex/forge/preferences.md` and every project space beneath the company
   space.
2. **Verify the root space** — create only what is missing: `Raw/_compiled.log`,
   `Wiki/_index.md`, `Wiki/_changelog.md` (templates in FORMATS.md). Complete when all three
   exist. Where `active_company` is set, verify the company space the same way.
3. **Verify the shared space's ledger** — `Wiki/pending-changes.md` (template in FORMATS.md),
   created once at least one project is scoped `shared`.
4. **Declare scope for every project space lacking `_scope.md`** — present its name and current
   location, ask for its scope, and wait for a direct human answer. On a valid answer, write
   `_scope.md`. Complete when every project space either has a marker or its unanswered question is
   flagged as restricted in the report.
5. **Report** — spaces verified, files created, scopes declared, spaces left restricted (blocking —
   re-asked next run), moves made, and open pending-changes rows.

## Misplaced Project Spaces

A shared-scoped project sitting under the root space, or a private-scoped project sitting under a
company space, is flagged at step 4 and resolved before the report. For each: state source and
destination paths, warn that moving into a git-synced company directory shares the content with the
team on the next `$sync-company`, and move only on a typed `CONFIRM` for that specific project.

## Scope Changes

Re-declaring `private` → `shared` reruns the steps above for that project, under the same gates.
**`shared` → `private` is forbidden in this skill** — the content may already exist in git history
and on a remote, where no move removes it. State this and stop: reclaiming knowledge that has
already been shared is a manual human action outside this skill.

## Pending Changes

The shared space's `Wiki/pending-changes.md` is the human's ledger of knowledge changes expected
from in-flight shared projects — status `Potential` or `Confirmed`, resolved only when the project
ships and its Wiki merges. This skill maintains the file and surfaces open rows in every report;
adding rows as changes crystallise is the human's discipline until `$ingest` is
patched to prompt for it (backlog).

## Rules

- Scope is declared by a direct human answer, never inferred or defaulted — ask and wait.
- Treat a project space without `_scope.md` as restricted: never share, move, or compile its
  knowledge into the shared space.
- Never accept `scope: shared` naming a company with no `~/.codex/forge/companies/[name]/`.
- Every folder move requires a typed `CONFIRM` for that specific project.
- Never change scope `shared` → `private` — manual action outside the skill.
- Setup is additive: create missing files only; leave every existing file untouched.
- Project Wiki content stays in the project space until the project ships — link to articles in
  the shared space, don't copy content across spaces.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No project spaces exist yet | Verify the root space and report — there is nothing to scope. |
| No `active_company` set | Verify the root space only; `private` is the only declarable scope — still asked per project, never assumed. |
| Declared company doesn't exist locally | Refuse the declaration, point to `$add-company`, leave the project restricted. |
| No human answer to a scope question | Leave the marker absent — the space stays restricted; flag as blocking and re-ask next audit. |
| A tracked project has no knowledge space yet | No scope needed yet — nothing to protect; point to `$add-project` when knowledge starts. |
| Asked to change scope shared → private | Refuse — state the already-published reason and stop; manual action outside the skill. |
| A template's target file already exists | Leave it untouched; note "exists — skipped" in the report. |
| Asked to merge a shipped project's Wiki | Out of scope — it belongs to whatever ships the project, `$deploy` post-deployment cleanup (backlog, 2026-07-13). |
