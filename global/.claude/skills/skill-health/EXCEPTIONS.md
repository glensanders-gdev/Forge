# Skill Health — Declared Exceptions

The register of findings `/skill-health` reports at a reduced severity because a maintainer
granted the exception deliberately. Read in Phase 1; nothing outside this skill reads it.

**An exception lowers a finding's severity. It never removes the finding from the report.**
A suppressed check is a check nobody can audit — the reader loses the ability to tell an
exception that was granted from one that was never noticed, and the grant itself becomes
invisible the moment the person who made it moves on. Every row here still appears in the
report, at ℹ️ Info, carrying its reason.

---

## Register

| Skill | Check | Granted | Invariant | Reason |
|---|---|---|---|---|
| `write-ord` | `frontmatter_versions` | 2026-09-08 | Frontmatter `version:` equals the `write-ord` value in `manifest.json` | `write-ord` is published to `glensanders-gdev/skills`, where `manifest.json` does not travel with the skill. The version is carried in frontmatter at the maintainer's instruction so a reader of the public artefact can tell which version they hold. Granted at v4.9.0 |

---

## What a row means

- **`Skill`** — exactly one skill. An exception is never granted portfolio-wide. A check that
  needs exempting everywhere is a wrong check, and the fix belongs in the check.
- **`Check`** — exactly one tally name from the Phase 2 list in [SKILL.md](SKILL.md). A row
  naming a check that does not exist is a stale row, not a silent pass.
- **`Granted`** — the date the exception was made, so the register's age is as visible as the
  `RESERVED-NAMES.md` stamp's. An old grant is not wrong; an old grant nobody has looked at is
  worth less than it appears.
- **`Invariant`** — what must still hold for the exception to stand. **A row without one is not
  an exception, it is a waiver**, and the check reports it at its own severity. The exception
  buys relief from the *finding*; it never buys relief from the failure the finding exists to
  catch.
- **`Reason`** — why the exempted state is deliberate, in enough words that a reader who was not
  in the room can decide whether it still holds. "At the maintainer's instruction" alone is a
  record of who, not of why.

---

## How `/skill-health` reads this

| State | Reported as |
|---|---|
| Skill trips the check · row present · invariant holds | ℹ️ Info — declared exception, quoting its reason and grant date |
| Skill trips the check · row present · invariant broken | 🔴 Critical — the exception has drifted, and it is the state the check exists to prevent |
| Skill trips the check · no row | The check's own severity, unchanged |
| Row present · skill does not trip the check | ℹ️ Info — stale exception, remove the row |

**The broken-invariant case is Critical rather than Amber, and higher than the finding it
exempts.** An ordinary Amber says a rule was not followed. A broken invariant says a rule was
deliberately set aside on a promise, and the promise has failed — which is worse than never
having granted it, because the finding that would have caught it is the one being suppressed.

**`frontmatter_versions` is the sharpest case of that.** The check exists because a frontmatter
copy of a version drifts from `manifest.json` silently. An exempted skill has two copies by
design, so the exception is conditioned on their agreement — and where they disagree,
`manifest.json` stays authoritative and the frontmatter copy is corrected to match it.
That is the opposite of the instruction for an unexempted skill, whose fix is to delete the
line. Both are the same principle applied to different situations: one source of truth, and
where a second copy is unavoidable, it is a copy and never a claim of its own.

---

## Never

- Never grant an exception in the skill being audited — a `<!-- skill-health: ignore -->` marker
  in a `SKILL.md` puts the grant where only the exempted file records it, and the register that
  makes the portfolio's exceptions countable in one place stops being complete.
- Never grant one without an invariant. A finding with nothing left to check is not exempted, it
  is deleted.
- Never grant one to the whole portfolio, to a category, or by wildcard.
- Never let an exception remove a finding from the report — the severity drops, the row stays.
- Never treat a stale row as harmless. An exception outliving the condition it was granted for
  is a standing licence nobody remembers issuing.
