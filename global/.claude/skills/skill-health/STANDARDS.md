# Skill Health — Standards Register

The register of which skills apply which standards, and when each pairing was last reviewed.
`/skill-health` reads it in Phase 1 and never writes it. It is the impact list when a standard
changes. Grepping for a standard's path finds only the skills that cite it, and misses a skill that
applies a standard without naming it.

**A standard here is a file whose rules govern what a skill produces.** Two kinds are tracked:

- **On demand** — `standards/`. Nothing loads these. A skill that applies one has to cite it by
  path, or its rules never reach the session.
- **Always loaded** — `rules/common/`. Every session loads these, so a skill applies them without
  citing them. A citation is allowed but not required.

Language-specific rule sets (`rules/<lang>/`) govern project code rather than skills, and are not
tracked.

---

## Tracked standards

| Standard | Loading | Applies to |
|---|---|---|
| `standards/requirements/language.md` | On demand | `write-brd`, `write-prd`, `write-ord`, `write-ac`, `write-reqs`, `review-language`, `idea-ai`, `roap`, `testplan` |
| `standards/requirements/tables.md` | On demand | `write-brd`, `write-prd`, `write-ord`, `write-reqs`, `review-language`, `idea-ai`, `testplan`, `prototype` |
| `standards/requirements/ai.md` | On demand | `write-brd`, `write-prd`, `write-ord`, `write-ac`, `write-reqs`, `idea-ai` |
| `standards/requirements/reporting.md` | On demand | `write-ord` |
| `standards/requirements/llm-companion.md` | On demand | `write-brd`, `write-ord` |
| `rules/common/ai-use.md` | Always loaded | `add-company`, `write-article`, `write-brd`, `write-ord` |
| `rules/common/security.md` | Always loaded | `vibe-security`, `security-assessment`, `review-diff`, `tdd`, `build` |
| `rules/common/coding-style.md` | Always loaded | `push-standards`, `fix-one-thing`, `review-diff`, `tdd`, `build` |
| `rules/common/quality-checklist.md` | Always loaded | `test-coverage`, `review-diff`, `qa-plan` |
| `rules/common/research-first.md` | Always loaded | `tdd`, `build` |
| `rules/common/git-safety.md` | Always loaded | `git-guardrails`, `build`, `deploy`, `rollback`, `fix-one-thing` |
| `rules/common/model-selection.md` | Always loaded | `grill-me` |

## Declarations

| Skill | Standard | Relation | Reviewed | Note |
|---|---|---|---|---|
| `write-brd` | `standards/requirements/language.md` | Applies | 2026-10-08 | `/review-language --skill`. `STANDARD.md` is a generated pack extract and was not checked; its templates are reviewed at the pack |
| `write-prd` | `standards/requirements/language.md` | Applies | 2026-10-08 | `/review-language --skill` |
| `write-ord` | `standards/requirements/language.md` | Applies | 2026-10-08 | `/review-language --skill` |
| `write-ac` | `standards/requirements/language.md` | Applies | 2026-10-08 | `/review-language --skill` |
| `write-reqs` | `standards/requirements/language.md` | Applies | 2026-10-08 | `/review-language --skill`. No governed text |
| `review-language` | `standards/requirements/language.md` | Applies | — | |
| `idea-ai` | `standards/requirements/language.md` | Applies | — | |
| `roap` | `standards/requirements/language.md` | Applies | — | |
| `testplan` | `standards/requirements/language.md` | Applies | — | |
| `write-brd` | `standards/requirements/tables.md` | Applies | — | |
| `write-prd` | `standards/requirements/tables.md` | Applies | — | |
| `write-ord` | `standards/requirements/tables.md` | Applies | — | |
| `write-reqs` | `standards/requirements/tables.md` | Applies | — | |
| `review-language` | `standards/requirements/tables.md` | Applies | — | |
| `idea-ai` | `standards/requirements/tables.md` | Applies | — | |
| `testplan` | `standards/requirements/tables.md` | Applies | — | |
| `prototype` | `standards/requirements/tables.md` | Applies | — | |
| `handoff` | `standards/requirements/tables.md` | Reference | n/a | Cites its view-table and ID rules as an analogy for stream handoffs |
| `write-brd` | `standards/requirements/ai.md` | Applies | — | |
| `write-prd` | `standards/requirements/ai.md` | Applies | — | |
| `write-ord` | `standards/requirements/ai.md` | Applies | — | |
| `write-ac` | `standards/requirements/ai.md` | Applies | — | |
| `write-reqs` | `standards/requirements/ai.md` | Applies | — | |
| `idea-ai` | `standards/requirements/ai.md` | Applies | — | |
| `write-ord` | `standards/requirements/reporting.md` | Applies | — | |
| `write-brd` | `standards/requirements/llm-companion.md` | Applies | — | |
| `write-ord` | `standards/requirements/llm-companion.md` | Applies | — | |
| `add-company` | `rules/common/ai-use.md` | Applies | — | |
| `write-article` | `rules/common/ai-use.md` | Applies | — | |
| `write-brd` | `rules/common/ai-use.md` | Applies | — | |
| `write-ord` | `rules/common/ai-use.md` | Applies | — | |
| `vibe-security` | `rules/common/security.md` | Applies | — | |
| `security-assessment` | `rules/common/security.md` | Applies | — | |
| `review-diff` | `rules/common/security.md` | Applies | — | |
| `tdd` | `rules/common/security.md` | Applies | — | |
| `build` | `rules/common/security.md` | Applies | — | |
| `push-standards` | `rules/common/coding-style.md` | Applies | — | |
| `fix-one-thing` | `rules/common/coding-style.md` | Applies | — | |
| `review-diff` | `rules/common/coding-style.md` | Applies | — | |
| `tdd` | `rules/common/coding-style.md` | Applies | — | |
| `build` | `rules/common/coding-style.md` | Applies | — | |
| `test-coverage` | `rules/common/quality-checklist.md` | Applies | — | |
| `review-diff` | `rules/common/quality-checklist.md` | Applies | — | |
| `qa-plan` | `rules/common/quality-checklist.md` | Applies | — | |
| `tdd` | `rules/common/research-first.md` | Applies | — | |
| `build` | `rules/common/research-first.md` | Applies | — | |
| `git-guardrails` | `rules/common/git-safety.md` | Applies | — | |
| `build` | `rules/common/git-safety.md` | Applies | — | |
| `deploy` | `rules/common/git-safety.md` | Applies | — | |
| `rollback` | `rules/common/git-safety.md` | Applies | — | |
| `fix-one-thing` | `rules/common/git-safety.md` | Applies | — | |
| `grill-me` | `rules/common/model-selection.md` | Applies | — | |

---

## What a row means

**Tracked standards**

- **`Standard`** — a path relative to `~/.claude/`, which is `global/.claude/` in the repository.
  One file per row. A whole folder is never one standard, because drift is read per file.
- **`Loading`** — `On demand` or `Always loaded`, as above. It decides whether a skill has to cite
  the standard.
- **`Applies to`** — the skills that have to declare this standard. Coverage is checked against
  this list, not against citations, so a skill that applies a standard without naming it still
  shows up. The list is a maintainer's judgement and is widened by hand. A skill that applies a
  standard only by running another skill that reads it at run time, as `/review-brd` and
  `/review-ord` run `/review-language`, is left out: it holds no copy of the rules that could go
  stale.

**Declarations**

- **`Skill`** and **`Standard`** — exactly one of each. A skill that applies three standards has
  three rows.
- **`Relation`** — `Applies` when the standard's rules govern what the skill produces. `Reference`
  when the skill cites the standard for another purpose, such as an analogy. A `Reference` row is
  never checked for drift, and is never counted towards coverage.
- **`Reviewed`** — the date the skill was last checked against this standard, as `yyyy-mm-dd`, or
  `—` for never. For language rules the check is `/review-language --skill <name>`. For other
  standards it is a human read of the skill against the standard. `n/a` on `Reference` rows only.
- **`Note`** — what the review covered, and anything it left out.

## Updating a stamp

Update `Reviewed` only after the skill has been checked against the standard as it stands now,
and only after the standard's latest change is committed. Drift compares dates, not commits, so a
review stamped earlier on the same day as a later change to the standard would hide that change.
A stamp records that a review happened. It never records a fix, and a review that found defects is
stamped after the defects are fixed or logged.

Never update a stamp to clear a drift finding without the review. A stamp nobody earned is the
silent pass this register exists to prevent.
