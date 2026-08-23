# ADR-0003: AI requirements extend the existing pack — no peer AI document

**Date:** 2026-08-21
**Status:** Active

## Context

The requirements pack (BRD → PRD → ORD → AC) is aligned to BABOK v3, ISO/IEC/IEEE 29148:2018 and
ISO/IEC 25010:2023, with wording and presentation owned by the shared rulesets in
`rules/requirements/`. Nothing in it addresses a solution whose delivered behaviour is *learned or
generated* rather than specified.

Research (`docs/research/requirements-for-ai-solutions.md`, 2026-08-21) established three things
that force a decision now rather than at first AI project:

1. **The standards bodies answered this as an extension, not a replacement.** ISO/IEC 25059:2023 is
   the quality model for AI systems inside the same SQuaRE series as 25010 — it adds
   sub-characteristics (functional adaptability, robustness, user controllability, transparency,
   intervenability) and inherits the rest unchanged. ISO/IEC/IEEE 29148 is not superseded.
2. **One genuine change to the criterion grammar exists.** Verifiability over generated behaviour
   is evidenced by a threshold on a named held-out evaluation set, not by a single pass/fail
   assertion. Written loosely, this is indistinguishable from the hedge `language.md` exists to
   prevent — non-determinism is the most plausible excuse yet available for writing `may` into a
   criterion.
3. **Regulation supplies requirement classes directly.** EU AI Act Articles 9–15 and Annex IV read
   as a register. Regulation (EU) 2026/1744 (Digital Omnibus on AI, in force 27 July 2026) deferred
   the Annex III high-risk obligations to 2 December 2027 and Annex I to 2 August 2028 — the
   deadline moved, the content did not.

This is hard to reverse for the same reason ADR-0001 was: the choice determines the ID namespace,
what each skill reads, and the shape of every document authored from here.

## Options Considered

1. **A peer AI requirements document (an "ARD")** — a fourth document alongside BRD/PRD/ORD holding
   everything AI-specific. Rejected: 25059 is explicitly a delta on 25010 and our ORD §3 is already
   keyed to 25010, so a peer would duplicate ~80% of the ORD template to carry a ~20% delta,
   fragment the ID namespace, and age independently of its sibling — the exact drift ADR-0001's
   shared-ruleset amendment was written to stop. It also lets AI work route around the normal
   pipeline, which is where inconsistent requirements come from.
2. **Fold the AI clauses into `language.md` and `tables.md`** — no new file. Rejected: both are
   unconditional baselines applied to every document. AI clauses are *conditional* — they apply only
   when a component's behaviour is learned or generated — and mixing a conditional ruleset into an
   unconditional one either dilutes the baseline or forces every author to skip sections.
3. **Extend in place via a third shared ruleset** *(chosen)* — `rules/requirements/ai.md`, cited by
   path from the four requirement skills exactly as its two siblings are, carrying the evaluative
   criterion form, the AI-specific register schemas, and the class-to-section map. The ORD §3
   taxonomy takes the 25059 sub-characteristic patch; the PRD takes intended purpose and prohibited
   uses.
4. **Defer until a real AI project lands** — rejected as the decision, retained as the rule for
   *scope*. Deciding the shape now costs one ruleset; deciding it under a conformity deadline in
   2027 costs a retrofit of every document authored in between. Individual schemas with no current
   consumer are still deferred (see Decision).

## Decision

- **No new document type.** AI-specific requirements live in the existing BRD/PRD/ORD, in the
  sections the class-to-section map in `rules/requirements/ai.md` assigns.
- **`rules/requirements/ai.md` is the third shared ruleset**, conditional on the trigger test
  ("a delivered component whose behaviour is learned or generated rather than specified"), and
  cited by path from `/write-brd`, `/write-prd`, `/write-ord`, `/write-reqs` and `/write-ac`. It
  never restates `language.md` or `tables.md` and never relaxes them.
- **The criterion grammar gains one form, not an exemption** — the evaluative criterion, which
  names its evaluation set, scorer, threshold and floor. The modal ban, the "the system" ban and
  the vagueness ban apply to it unchanged.
- **ID namespace extended** to `EVL-NNN` (evaluation sets) and `MDL-NNN` (model dependencies),
  keeping the flat-sequential, never-reused, never-theme-encoding properties of ADR-0001 and its
  exclusion of single-letter prefixes.
- **ORD §3 carries the ISO/IEC 25059 delta** as sub-characteristics of the existing nine, with the
  AI Act Article 9–15 mapping recorded in the requirement-to-section map. §3 is not restructured.
- **The PRD owns intended purpose and prohibited uses** — it already owns the scope boundary and
  Out of Scope; these are two subsections, not a restructure. The BRD records the risk
  classification decision once.
- **Deferred, deliberately:** a data-as-subject schema per the ISO/IEC 5259 series. For
  inference-only work against a consumed service it is dead weight, and the series warrants proper
  reading before a schema is committed.

## Reason

25059's own structure is the strongest available argument: the body that had every opportunity to
define a separate AI quality model chose to extend 25010 instead, because AI systems are still
systems. Mirroring that keeps one traceability chain, one ID namespace and one set of documents to
teach — and it means the pack's existing alignment to 25010 becomes an asset at the 2027 deadline
rather than a liability.

A separate conditional file (option 3 over option 2) follows the precedent set by ADR-0001's
amendment: rules that neither sibling can own without the other drifting live in
`rules/requirements/`, and a ruleset that applies sometimes is legible only when its trigger is
stated at the top of its own file.

## Consequences

- **Easier:** an AI project uses the same pipeline, the same IDs and the same review gates as any
  other; conformity evidence for AI Act Articles 9–15 falls out of the ORD register rather than
  being assembled separately; the 25010 → 25059 patch is additive, so documents already authored
  stay valid.
- **Harder / cost incurred:** five skills gain a citation line and a version bump; `tables.md` gains
  two namespace rows; `write-ord/REFERENCE.md` §3 and `nine-characteristics-quickref.md` need the
  25059 sub-characteristics, and the quickref stops being a clean "nine" once patched. An author
  must now make a trigger judgement ("is this component's behaviour learned or generated?") that
  did not exist before — a wrong "no" silently skips the whole ruleset.
- **Boundary that must not blur:** `ai-first-engineering` governs AI as the *author* of the
  solution; `rules/requirements/ai.md` governs AI as the *subject* of the requirement. The two
  share a word and nothing else.
- **Watch item:** the ISO/IEC 25059 second edition completed DIS enquiry in March 2026 and awaits
  member-body vote. Its AI *service* quality model (traceability, service adaptability,
  customizability) is the part most relevant to consumed-as-a-service AI, which is most of our
  exposure. Re-check before the §3 patch is treated as stable.

Informed by `docs/research/requirements-for-ai-solutions.md`. Extends ADR-0001 (namespace, shared
ruleset placement); supersedes nothing.
