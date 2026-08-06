---
name: roap-formats
description: Section schemas and the ROAP page template. Read at Phase 3 of $roap when drafting the page.
origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# ROAP Formats

## Section Schemas

| # | Section | Cap | Form |
|---|---------|-----|------|
| 1 | Role Title | 2–5 words | Position title as it appears on the org chart |
| 2 | Team | 1 line | Team name + parent function |
| 3 | Reports To | 1 line | Position title; dotted line noted separately |
| 4 | Role Purpose | ≤ 60 words | Declarative present; names the role, not "the system" |
| 5 | Key Accountabilities | 4–6 | Outcome owned, ≤ 25 words each |
| 6 | Success Measures | 3–5 | Metric, threshold, or named evidence; no modals |
| 7 | Typical Activities & Allocation | 4–7 | Activity + %, totalling exactly 100% |
| 8 | Development Focus Areas | 2–3 | Capability + why the role needs it |
| 9 | Key Relationships | 3–7 | Counterpart position/team, purpose, frequency |

Whole page ≤ 600 words. A `[TBD]` is a legitimate cell value; an invented one is not.

---

## Template

```markdown
---
role: [Role Title]
team: [Team]
reports_to: [Position title]
branch: design | document
date: YYYY-MM-DD
status: draft
---

# Role on a Page — [Role Title]

| | |
|---|---|
| **Team** | [Team, parent function] |
| **Reports to** | [Position title] |
| **Dotted line** | [Position title, or —] |

## Role Purpose

[≤ 60 words.]

## Key Accountabilities

1. [Outcome owned.]
2. [Outcome owned.]
3. [Outcome owned.]
4. [Outcome owned.]

## Success Measures

| Measure | Evidence |
|---|---|
| [Declarative statement carrying its threshold.] | [Source, report, or system the evidence comes from.] |

## Typical Activities & Allocation

| Activity | Allocation |
|---|---|
| [Activity] | [N]% |
| **Total** | **100%** |

## Development Focus Areas

- **[Capability]** — [why the role needs it.]
- **[Capability]** — [why the role needs it.]

## Key Relationships

| Counterpart | Purpose | Frequency |
|---|---|---|
| [Position or team] | [What the role needs from them or owes them] | [Cadence] |
```

---

## Worked Example — Success Measures

The measure column is where a ROAP most often goes soft. Both rows below came from the same conversation.

| ✗ As first offered | ✓ After the probe |
|---|---|
| Effective stakeholder management | Stakeholder satisfaction rating of 4+ in the half-yearly delivery survey |
| Should reduce rework | Rework attributable to requirements defects is under 10% of delivered stories |
| Good documentation | Every initiative entering build carries signed acceptance criteria |

The rewrite is the same claim with a number and a place to look it up — nothing was invented, the threshold came from the human.
