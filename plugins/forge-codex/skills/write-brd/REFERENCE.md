---
name: write-brd-reference
description: Output formats for $write-brd — the Phase 1 ingest summary, the document header, and the Phase 3 self-assessment report. Read when emitting either gate.
origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write BRD — output formats

The three things this skill emits. It holds **no criterion and no section template**: the BRD
anatomy, the objective form, the cost-of-failure form and the ten gate items are the standard's, read
at authoring time from the live pack or from [STANDARD.md](STANDARD.md).

---

## Phase 1 — ingest summary

```markdown
## BRD Ingest Summary — [change name]

**Standard:** BABOK v3 · **Pack version:** [vN.N, from the source that supplied it]
**Sources read:** [each, by path or description]

### Objectives drafted
| ID | Objective | Baseline | Target | By | Solution-vs-outcome |
|---|---|---|---|---|---|
| BO-1 | [outcome form] | [value or `[TBD — Owner, due YYYY-MM-DD]`] | [value or `[TBD]`] | [date] | Clean / rewritten from "[quoted source]" |

### Cost of failure
| Objective | Consequence | Source | 
|---|---|---|
| BO-1 | [what is lost] | [contract clause / incident ID / obligation, or **none found**] |

### Statements routed out of the BRD
| Statement | BABOK type | Destination |
|---|---|---|
| "[quote]" | Solution — non-functional | ORD, as business tolerance |
| "[quote]" | Solution — functional | No document in this chain — referred requirements register |

### Sizing read
[business units] · [objectives] · [stakeholders] · [impacted workflows and systems] → **S / M / L**

### Open questions — figures the source did not supply
| # | Question | Why it cannot be answered here |
|---|---|---|
| 1 | [question] | [the standard forbids inventing it, and nobody named has stated it] |

### Gate exposure, provisional
[Which of BH-1 – BH-10 the material as it stands does not yet reach, and which are declared gaps.]

---
Confirm to proceed to Phase 2, or supply corrections and gap-fills first.
```

**Every open question is a figure, an owner or a date the source did not state.** A question that is
really a drafting preference belongs in the draft, not at the gate.

---

## Phase 2 — document header

```markdown
# BRD-YYYY-NNN — [change name]

**Status:** Draft · **Priority:** [P1–P4]
**Executive sponsor:** [role] · **Author:** [name or role]
**Horizon:** [FYnn Hn – FYnn Qn] · **Standard:** BABOK v3
**Assessed against:** [standard path] · **Pack version:** [vN.N]
```

Sections follow the anatomy in the standard, in its order, with the five **★** sections populated or
carrying a declared gap.

---

## Phase 3 — self-assessment report

The report format in [GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md), with three changes that
follow from the reviewer being the author:

1. **The reviewer line says so.** `**Reviewer:** $write-brd — the author's own assessment, not an
   independent review.`
2. **A refusal is not recorded and overridden.** Name the absent bar items and offer to return to
   Phase 2. The protocol's authority note covers declaring *someone else's* document not-ready; it
   does not apply to your own.
3. **The closing line names the independent pass.** `Run $review-brd for the independent assessment —
   §8 names a reviewer who did not author the document as the highest-value Tier 1 control, and this
   assessment is not one.`

Everything else is the protocol's: four verdicts and no fifth, an evidence citation on every one, the
outcome derived by precedence rather than judged, and each declared gap named where it must reappear
downstream.
