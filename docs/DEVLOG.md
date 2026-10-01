# DEVLOG — Forge Framework

---

## Session 2026-10-01 — only common rules load into every session

**Stream:** none — ad-hoc framework change, following §6 of the workspace research note `docs/research/copilot-as-forge-host.md`
**Version range:** 4.15.1 → 4.15.2 ([PR #90](https://github.com/glensanders-gdev/Forge/pull/90) open from `claude/requirements-standards` at `6510f27`; Auto-fix on; not yet merged)
**Goals this session:** Confirm whether Claude Code loads `~/.claude/rules/` into every session, measure the cost, choose a fix and ship it.
**Tickets Completed:** None on kanban — ad-hoc framework change.
**Decisions Made:** (1) Confirmed from the Claude Code docs and the installed v2.1.284 program: every `.md` under `~/.claude/rules/` without `paths:` frontmatter loads at launch, in every project. That was 18 files, about 27.7k tokens, 22.9k of them the requirements ruleset, whose README said it was not auto-loaded. (2) Option (b) chosen over `paths:` frontmatter on the six files (a) or a README correction (c): the ruleset moves to `global/.claude/standards/requirements/`, linked as `~/.claude/standards/`, which no host loads; the skills already cited it by path. Rules loaded at launch fall to about 4.9k tokens. (2a) `rules/typescript/` and `rules/README.md` were then path-scoped rather than moved — the TypeScript pack to `.ts`/`.tsx`/`.mts`/`.cts` files, the README to `.claude/rules/` folders. They matter exactly when such files are touched, `/lang-rules` copies packs from `~/.claude/rules/<lang>/`, and Codex's `lang-rules` override reads them from `coding-guidance/`. `/lang-rules` 1.1.0 scaffolds new packs with `paths:` frontmatter. Rules loaded at launch fall to about 2.9k, `common/` alone. (3) A path-scoped pointer, `rules/requirements.md` (`**/docs/{brd,prd,ord,ac}/**`), keeps a requirements document edited outside a skill tied to its standards, for about 110 tokens on a matching read. (4) `/update-forge` and `/install-forge` gain missing-link checks, because a pull cannot create a link for a new folder. (5) The standalone installer prints a notice for a leftover `~/.claude/rules/requirements/` and never deletes it. (6) Versioned as a patch, 4.15.2, per the CHANGELOG convention, which keeps it clear of the in-flight `fix-one-thing` 4.16.0. (7) Built in a separate worktree from `origin/main`: another session's uncommitted `fix-one-thing` work sits in the main checkout, and a rebuild there would have swept it into the generated trees.
**Assumptions Made:** A user-level rule's globs match relative to the working directory, and a path-scoped rule fires when a matching file is read, not written (docs, issue tracker and the installed program agree). VS Code takes `paths` as an array and attaches a scoped rule when the agent creates or modifies a matching file. The Auto-fix approval covers pushing CI fixes to the PR branch only.
**Blockers:** None — merge waits on CI and review.
**Next Up:** Merge PR #90, then in the same sitting pull into the main checkout and run `bash install.sh` (or `/update-forge`) to link `~/.claude/standards`. If `fix-one-thing` lands first as 4.16.0, renumber this to 4.16.1. After merge, a final pass on the research note's "once it merges" wording.
**Status:** In Progress — PR open

---

## Session 2026-09-27 — corrections become coding standards

**Stream:** `correction-standards` (opened and closed at debrief — `docs/handoffs/archive/2026-09-27-correction-standards.md`)
**Version range:** 4.13.0 → 4.15.0 ([PR #86](https://github.com/glensanders-gdev/Forge/pull/86) merged as `624fa18`; [PR #87](https://github.com/glensanders-gdev/Forge/pull/87) merged as `6e7c6e2`; CI parity green; standalone published to `glensanders-gdev/skills`)
**Goals this session:** Make `.claude/CODING-STANDARDS.md` grow from mistakes the agent makes, not only from pattern extraction at feature close; ship `/learn` standalone; roll the change out to existing projects.
**Tickets Completed:** None on kanban — ad-hoc framework change.
**Decisions Made:** (1) Capture is **write, then tell** — no confirmation before writing a correction entry; the one-line notice is the veto point, and the file is in git. (2) An instruction, not a hook — only the agent can recognise a correction. (3) Repeats add a date to the existing entry's `Source:` line rather than duplicating; misses of an active language rule write nothing; cross-project habits route to `/learn`. (4) `/learn`'s templates moved into its own folder — no installer ever seeded `~/.claude/instincts/`. (5) `/evolve` stays held; promotion text is fenced `forge-only`.
**Assumptions Made:** Rolling the section out to projects not built from the template needs a standards file and a load-before-code line, or recorded corrections are never read (confirmed by reading both projects' `CLAUDE.md`). Pushing the one-section change straight to each project's `main` — confirmed by the user.
**Blockers:** None
**Next Up:** Observe whether corrections are captured in the four projects' `.claude/CODING-STANDARDS.md` over the next few build sessions; resume `requirements-pack` (workspace stream, Active, last updated 2026-09-07).
**Status:** Complete

---

## Session 2026-06-19 — requirements-document skill alignment

**Version range:** 3.11.0 → 3.12.0 ([PR #19](https://github.com/glensanders-gdev/Forge/pull/19) squash-merged to main as `fadcfaf`; tag `v3.12.0` pushed; CI parity green)
**Goals this session:** Resume from HANDOFF — run the write-prd standards review on `/write-ord`; grill the gaps; implement and release.
**Tickets Completed:** None on kanban — ad-hoc standards-alignment.
**Decisions Made:** (1) **ADR-0001** (`docs/adr/0001-prd-ord-brd-siblings-symmetric-ids.md`) — BRD is the single origin; PRD and ORD are **siblings** (each standalone after the BRD), not a chain; requirement IDs are flat + symmetric (`PRD-001` / `ORD-001`); joint PRD+ORD authoring is a separate skill `/write-reqs` (backlogged P3). (2) Released `/write-ord` v1.1.0 publicly (was private WIP) — BRD-anchored Phase 1 + provenance, `ORD-001` IDs, operationalised BRD→ORD traceability matrix with orphan/coverage-gap flagging. (3) `/write-prd` v2.1.1 — renamed `US-NN` → `PRD-001` for symmetry; corrected stale manifest entry (2.0.0 → 2.1.1). (4) Released as one v3.12.0 commit on a branch (never to main directly); excluded prior-session `docs/*` edits from the focused release commit.
**Assumptions Made:** write-ord's privacy reversal (private → public) was an explicit user decision this session, overriding the prior "private WIP" handoff/memory note. Codex `plugin.json` version hand-bumped to 3.12.0 (build does not bump it).
**Blockers:** None
**Next Up:** `/write-reqs` (P3 backlog) — composite PRD+ORD skill; first resolve whether a Forge skill can invoke another skill (orchestrate vs inline). Otherwise greenfield — kanban clear, no active feature.
**Status:** Complete (v3.12.0 shipped — PR #19 merged, tag pushed, CI green)

---

## Session 2026-06-18 — skill-completeness sweep + health follow-ups

**Version range:** git tag v3.11.0 (latest); main HEAD `1f77e63` — no `forge_version` bump (documentation-only)
**Goals this session:** Resume the P3 skill-completeness sweep from HANDOFF; close out the remaining handoff open items
**Tickets Completed:** None on kanban — backlog-driven (P3 skill-completeness sweep, now Done in `~/.claude/backlog.md`)
**Decisions Made:** (1) Added a tailored `## Failure Modes` table to all 43 skills lacking one and `## Rules` to the 7 missing them — all 104 skills now carry both (PR #15). Used `scan-first` to verify against live files, catching two report drifts (write-a-skill already had Failure Modes; new `scan-first` skill needed one). (2) Resolved skill-health follow-ups — body attribution credits for accessibility/ai-first-engineering/context-health/knowledge-onboard, documented the `/grill-with-codex` + `$grill-with-claude` aliases in grill-with-peer, reconciled CHANGELOG coverage for critic v1.1.0 / ia v1.3.0 (PR #16). (3) Committed long-untracked repo files — CLAUDE.md, docs/context-health-report.md, docs/dashboard/ (PR #17). (4) Created + pushed annotated tags v3.10.1 and v3.11.0 on their PR merge commits, matching the v3.10.0 convention. (5) Refreshed the local `~/.claude/forge-version` stamp to true current state (3.11.0 / `a44f38f`) rather than fake or run stock /forge-update (which targets ~/forge, not this dev clone). Codex-native overrides forge-update + grill-with-peer updated in their own idiom; override hashes refreshed each time.
**Assumptions Made:** ccusage daily is a full-day machine total — folded this session into the existing 2026-06-18 token record rather than adding a second same-date entry (would double-count). Generated docs artifacts are tracked by repo convention (docs/tokens/*.md already committed), so docs/dashboard/ + context-health-report.md follow suit.
**Blockers:** None
**Next Up:** No active feature; kanban clear, backlog clear of started items (only the deferred api.md design tickets remain). Portfolio is 100% healthy per /skill-health. Next session is greenfield — pick up a new idea/feature or another backlog item.
**Status:** Complete (all handoff open items closed; 3 PRs merged, 2 tags pushed, CI green)

---

## Session 2026-06-18 — assimilation

**Version range:** 3.10.0 → 3.11.0 (PRs #12 and #13 merged to main)
**Goals this session:** Assimilate Matt Pocock's "Writing Great Skills" into `/write-a-skill`; assimilate his "teach" skill into Forge
**Tickets Completed:** None (no kanban tickets — assimilation-driven maintenance; both `/assimilate` runs delivered and merged)
**Decisions Made:** (1) Pocock skill-craft folded into `write-a-skill` as a new `CRAFT.md` reference + SKILL.md edits rather than a separate skill (v3.10.1, PR #12). (2) `/teach` added as a new `knowledge`-category skill with workspaces under `~/.claude/knowledge/learning/`, a single consolidated `FORMATS.md`, and explicit reuse of `/add-term` (glossary), `/research` (resources), and ADR/`/learn` (records) rather than duplicating them (v3.11.0, PR #13). Domain tension (personal upskilling vs software delivery) raised and user-confirmed before writing.
**Assumptions Made:** `plugins/forge-codex/.codex-plugin/plugin.json` version is hand-maintained — `build-forge-codex.ps1` does not bump it (confirmed: parity failed until bumped manually, saved to memory). Repo-root `CLAUDE.md` is untracked, so its skill-count edit was deliberately left out of PR #13 (confirmed by `git status`).
**Blockers:** None
**Next Up:** Skill completeness sweep (P3 backlog — 43 Failure Modes + 7 Rules sections, pipeline-core first); decide whether to commit the session docs trail and the carried untracked files; create/push `v3.10.1` and `v3.11.0` tags if treating as releases
**Status:** In Progress

---

## Session 2026-06-11

**Version range:** 3.9.0 → 3.9.0 (commits 4af34c5 → 32cbe96, PRs #9 and #10 merged)
**Goals this session:** Critic the framework (tiered governance / token optimisation / model selection); execute resulting backlog items; run health audits
**Tickets Completed:** None (no kanban tickets — backlog-driven maintenance; both global backlog items delivered)
**Decisions Made:** Tier system and per-ticket model selection dropped after critique — accepted trade-off: trivial fixes keep full pipeline ceremony; revisit if informal skill-bypassing becomes routine. Token recording moved to ccusage actuals at /debrief and /sprint-end (per-skill guessing retired). Version-mismatch sync policy: align to the higher version on either side.
**Assumptions Made:** ccusage daily totals are machine-wide for the day — attribution to a single feature noted in the token record (confirmed by ccusage output structure). forge-install override unaffected by frontmatter-only version bump (confirmed by diff review).
**Blockers:** None
**Next Up:** Skill completeness sweep (P3 backlog — 43 Failure Modes + 7 Rules sections, pipeline-core first); optionally dashboard-tokens template extraction; decide on untracked docs (context-health report, dashboard, root CLAUDE.md)
**Status:** In Progress

---

## Session 2026-06-01 — APPROVED ✓

**Feature:** Forge Junction-Based Sync (v3.7.0)
**Tickets Completed:** #1, #2, #3, #4, #5, #6, #7
**QA:** Waived — all 10 TCs deferred to future cycle; P1s partially verified during build session
**PRD:** Archived
**Status:** Approved
