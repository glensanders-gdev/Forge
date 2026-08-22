# ADR-0002: Action skills are verb-first; state skills keep noun shape

**Date:** 2026-08-22
**Status:** Accepted — rename sweep not yet executed

## Context

Forge has 113 skill names accumulated over 3 major versions with no naming convention. The
result is not merely untidy: **the same verb appears in both positions**, so a reader cannot
predict a skill's name from what it does.

| Verb | Verb-first | Verb-last |
|---|---|---|
| add | `add-project` `add-system` `add-term` | `backlog-add` `company-add` `tool-add` |
| update | `update-context` `update-readme` | `company-update` `dependency-update` `forge-update` |
| setup | `setup-confluence` | `brain-setup` |

Two things forced the question now:

1. **v3.25.0 renamed `/continue` → `/pickup` and `/review` → `/diff-review`** after both were
   found shadowed by Claude Code built-ins. `/diff-review` was chosen partly to join the
   existing `brd-review` / `ord-review` / `performance-review` family — which entrenched a
   verb-last pattern one release before this ADR proposed to reverse it.
2. **v3.27.0 added `RESERVED-NAMES.md`** and, with it, evidence about where the vendor's
   namespace is growing. The vendor occupies the `*-review` shape three times — `review`,
   `code-review`, `security-review` — and the `review-*` shape zero times. Forge has five names
   in the shape the vendor is expanding into.

A rename is the most expensive operation Forge has. Per v3.25.0 there is **no soft landing**: a
renamed skill's old name simply stops working, and a deprecation stub is not available as a
mitigation because a stub at the old name would be shadowed too. Every rename is a major
version and breaks every reference.

## Options Considered

**Reach of the convention**

1. **New skills only** — the convention governs what is written from now on; nothing is
   renamed. Zero cost, zero breakage. Rejected: leaves the review family in the vendor's
   expansion path and leaves `add-term` sitting beside `tool-add` indefinitely, so the
   unpredictability this ADR exists to fix persists forever.
2. **New skills plus the review family only** — five renames (~322 references), justified by
   collision avoidance rather than consistency; the remaining 21 verb-last actions accepted as
   legacy. This was the recommendation on cost grounds and was **not** chosen.
3. **Full retrospective sweep** *(chosen)* — every action skill moves to verb-first. 26 renames,
   ~2,300 references, 26 major versions. Buys a convention that is actually true of the
   portfolio rather than true of the newest third of it.

**Boundary — which names the convention governs**

1. **Every multi-word name** — no exemption. `skill-health` → `check-skills`,
   `token-report` → `report-tokens`. Maximally consistent and mechanically checkable. Rejected:
   it renames diagnostic names that read naturally as nouns and are referenced as artefacts
   ("the skill-health report") rather than invoked as commands.
2. **Actions governed, states exempt** *(chosen)* — a skill that performs an operation takes
   verb-first; a skill named for the artefact or condition it reports keeps its noun shape.
3. **Leave the boundary undefined** — settle edge cases as they arise. Rejected: this is how a
   convention gets applied inconsistently and then argued about per-skill.

## Decision

**Action skills are verb-first. State skills are exempt.**

The test: if the name answers *"what does it do"* it is an action and takes verb-first. If it
answers *"what is this"* it is a state and keeps its noun shape.

**Exempt as states** — 7 names, unchanged:

`skill-health` · `context-health` · `knowledge-health` · `qa-plan` · `qa-report` ·
`token-report` · `security-assessment`

Single-word names (`standup`, `commands`, `pickup`, `caveman`, `build`, `deploy`, …) are outside
the convention entirely — there is no order to get wrong.

**Renamed as actions** — 26 names. Every target below was checked against `RESERVED-NAMES.md`
(stamp 2026-08-22): none is shadowed, none is on the At Risk list, and none collides with an
existing Forge skill.

| Current | New | Note |
|---|---|---|
| `brd-review` | `review-brd` | |
| `ord-review` | `review-ord` | |
| `fy-review` | `review-fy` | |
| `diff-review` | `review-diff` | Second rename in two releases — see Reason |
| `performance-review` | `review-performance` | |
| `pii-check` | `check-pii` | |
| `scope-check` | `check-scope` | |
| `style-check` | `check-style` | |
| `tool-check` | `check-tools` | Plural — the skill audits the whole tool set |
| `backlog-add` | `add-backlog-item` | Names the item, not the register — `add-backlog` reads as "add a backlog" |
| `company-add` | `add-company` | |
| `tool-add` | `add-tool` | Singular — adds one tool |
| `sprint-start` | `start-sprint` | |
| `sprint-end` | `end-sprint` | |
| `pi-end` | `end-pi` | |
| `sprint-replan` | `replan-sprint` | |
| `pi-replan` | `replan-pi` | |
| `forge-init` | `init-forge` | Clear of the reserved `init` |
| `forge-install` | `install-forge` | |
| `forge-update` | `update-forge` | |
| `company-sync` | `sync-company` | |
| `company-update` | `update-company` | |
| `brain-setup` | `setup-brain` | |
| `knowledge-onboard` | `onboard-knowledge` | Knowledge is the object being onboarded, not the actor |
| `dependency-update` | `update-dependencies` | Plural — updates the dependency set |
| `security-resolve` | `resolve-findings` | Findings are what is resolved; `resolve-security` reads as resolving security itself |

Three targets depart from a literal word-order flip — `add-backlog-item`, `onboard-knowledge`
and `resolve-findings`. Each names the **object the skill acts on** rather than the register or
domain it sits in, which is what verb-first demands once the verb moves to the front. They were
raised as open wording and settled on adoption; a later change amends this table rather than
requiring a new ADR.

**This ADR does not execute the sweep.** The renames are follow-on work, sequenced separately.

## Reason

The full sweep was chosen over the cheaper review-family-only option because a convention that
governs one family and not the rest is not a convention — it is a second inconsistency layered
on the first. The stated goal is that a reader can predict a name from what the skill does, and
that property is binary: it holds for the portfolio or it does not hold at all. Paying 26 major
versions once buys it; paying 5 buys a tidier corner and leaves the confusion intact.

The review family carries an independent justification that survives even if the sweep is later
reversed: the vendor has claimed three names in the `*-review` shape and none in `review-*`, so
Forge's five `*-review` names sit in the demonstrated expansion path. Moving them out is
collision avoidance, and collision avoidance is the one justification strong enough to pay a
major version on its own — which is precisely the reasoning v3.25.0 used.

`diff-review` renaming twice in two releases is accepted deliberately. The v3.25.0 rename was
driven by a live collision and could not have waited for this ADR; the second move is driven by
a different reason, and `diff-review` is the newest of the five names and therefore carries the
least muscle memory. Renaming it now costs less than leaving one member of the family behind.

States are exempt because their names are used as nouns in prose and as artefact references
("read the skill-health report", "the token-report output"), not as imperatives. Forcing
`report-tokens` would make the skill name and the artefact name diverge, trading one class of
confusion for another.

## Consequences

- **Easier:** a name becomes predictable from behaviour; the same verb stops appearing in two
  positions; the review family leaves the vendor's expansion path; `/write-a-skill` gains a
  second mechanical naming check to sit beside the reserved-name gate.
- **Harder / cost incurred:** 26 major skill versions and ~2,300 references updated across
  skills, rules, commands, README, diagrams, and the generated Codex plugin. **No deprecation
  path exists** — every old name stops working the day the rename lands, including names with
  years of muscle memory behind them (`/sprint-start`, `/company-add`, `/forge-update`). Any
  external project, note, or automation referencing an old name breaks silently.
- **Sequencing risk:** the sweep touches nearly every file in the repo, so it conflicts with any
  concurrent branch. It is executed as one change, on a quiet tree, not incrementally.
- **Historical records are not rewritten.** Old names inside past CHANGELOG entries, README
  version-history rows, and prior ADRs record what shipped at the time and stay as they are —
  the rule established by v3.25.0 and reaffirmed here.
- **Follow-on:** `/write-a-skill` gains a convention check (action vs state, verb position) once
  the sweep lands; enforcing it before the portfolio complies would fail on 26 existing skills.
