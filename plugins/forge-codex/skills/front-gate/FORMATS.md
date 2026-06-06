# Request Brief — Output Format

Used by `$front-gate` Phase 3. Write the brief in the requestor's voice — plain language, not AI-formal language.

---

```markdown
---
status: draft | pending-jira
---

# Request Brief — [Brief one-line title]

**Submitted:** YYYY-MM-DD
**Requested by:** [Name or role if provided, otherwise omit]

---

> [One sentence from the Brief Summary — Q7 — placed here as the executive hook]

---

## Problem Statement

[Q1 answer — what is going wrong or what opportunity is being missed. In the requestor's words.]

## Objective

[Q2 answer — what success looks like after delivery. In the requestor's words.]

## Metrics *(optional)*

| | Baseline | Goal |
|---|---|---|
| [Measure] | [Current state] | [Target state] |

*Not provided* — if the requestor did not supply metrics.

## What Is Needed from the Team

[Q4 answer — what the team is being asked to do. Specific and actionable.]

## Risk & Cost of Doing Nothing

[Q5 answer — what happens in 6–12 months if this is not actioned.]

## Negative Impacts

[Q6 answer — risks, disruptions, or downsides the team will need to plan for.]

---

## System Notes

*Include this section only if one or more systems were named during intake.*

| System | Constraint | Source |
|--------|------------|--------|
| [System name] | [Constraint text] | known-issues.md / stakeholder-feedback.md |

*No system constraints identified.* — if no relevant knowledge base entries were found.

---

> **Note:** This brief was prepared by the Front Gate intake process. It captures the request as stated — it does not commit to a solution or timeline. The receiving team should run `$idea` or `$grill-with-docs` to assess feasibility before responding.
```

---

## Rules

- `status` in frontmatter is always one of `draft` or `pending-jira` — set from Phase 5 selection, never omit
- Metrics section: omit the table entirely if "Not provided" — do not show an empty table
- System Notes section: omit entirely if no systems were named
- Write in the requestor's voice — do not rewrite into AI-formal language
- Do not add commentary, recommendations, or solution hints to the brief
- Constraints flagged with ⚠️ during grilling must appear in the System Notes table
