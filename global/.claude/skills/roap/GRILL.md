---
name: roap-grill
description: The nine ROAP questions, with form requirement, example answer, and probe. Read at Phase 2 of /roap.
---

# The Nine Questions

Ask in order, one at a time. For each: put the question, then the example, then wait.

The **probe** column of each question is the grill — use it whenever the answer misses the form, is generic enough to fit any role, or describes a person rather than a position. Probe once per question, then move on.

**Branch:** on the **document** branch, probe for evidence — what happened, how often, last month. On the **design** branch, probe for intent — what this role owns that no existing role owns today.

---

### Q1 — Role Title

> "What is the role called? Use the title that would appear on the org chart, not a description of the work."
>
> *Example: "Senior Business Analyst."*

**Form:** a position title, 2–5 words, no seniority ambiguity.
**Probe:** if the title is internal jargon or invented for the exercise — "Would someone outside your team know what that title does? What is the nearest standard title?"

---

### Q2 — Team

> "Which team does this role sit in, and where does that team sit in the wider structure?"
>
> *Example: "Delivery Enablement, within the Technology & Transformation function."*

**Form:** team name plus its parent function.
**Probe:** if the role is split across teams — "Which team carries the headcount? Name the others under Key Relationships instead."

---

### Q3 — Reports To

> "What position does this role report to? Give the title, not the person's name."
>
> *Example: "Delivery Enablement Manager."*

**Form:** a position title. Note any dotted-line reporting separately.
**Probe:** if a person is named — "What is that position's title?" If two lines are given — "Which line owns performance and priorities? The other is the dotted line."

---

### Q4 — Role Purpose

> "In two or three sentences — why does this role exist? What is different about the organisation because someone holds it?"
>
> *Example: "Senior Business Analyst exists to turn ambiguous business demand into requirements a delivery team can build against. It holds the line between what stakeholders ask for and what the platform can support, so that scope is agreed before build starts rather than discovered during it."*

**Form:** ≤ 60 words, declarative present, names the role rather than "the system" or "this position".
**Probe:** if the purpose would fit any role in the team — "Swap the title for a colleague's and it still reads true. What is only true of *this* role?"

---

### Q5 — Key Accountabilities

> "What outcomes does this role own — the things that are this role's fault if they go wrong? Aim for four to six."
>
> *Example: "Requirements quality for all in-flight initiatives. Stakeholder agreement on scope before build. Traceability from business need to delivered feature. Impact assessment on proposed changes."*

**Form:** 4–6 items, each ≤ 25 words, each an **outcome owned**, not a task performed. "Runs workshops" is a task; "Stakeholder agreement on scope before build" is an accountability.
**Probe:** for each task-shaped answer — "What outcome do those add up to?" For a thin list — "If this role goes unfilled for three months, what stops working? What else?"

---

### Q6 — Success Measures

> "How do you tell, at the end of a year, that this role has gone well? Give three to five measures, each with a number or a piece of evidence you could actually point at."
>
> *Example: "Rework attributable to requirements defects is under 10% of delivered stories. Every initiative entering build has signed acceptance criteria. Stakeholder satisfaction rating of 4+ in the half-yearly delivery survey."*

**Form:** 3–5 measures. Every measure carries a metric, threshold, or named evidence source, and is written in the declarative present with no modals (`~/.claude/rules/requirements/language.md`).
**Probe:** for an adjective measure — "How would you evidence that in a review conversation? What would you show?" If nothing exists, record `[TBD — source: "quoted answer"]` and move on rather than inventing a threshold.
**Cross-check:** every accountability from Q5 is visible in at least one measure. Name any that is not: "Nothing here tells you whether [accountability] went well — is that measurable, or is it a gap?"

---

### Q7 — Typical Activities & Allocation

> "How does the time actually go? List four to seven activities and the rough percentage of time each takes — it needs to total 100%."
>
> *Example: "Requirements elicitation and workshops 30%. Documentation and acceptance criteria 25%. Stakeholder management 20%. Delivery team support during build 15%. Continuous improvement and coaching 10%."*

**Form:** 4–7 activities, each with a percentage, totalling **exactly 100%**.
**Probe:** run the total aloud after the answer. Over 100% — "That is [N]%. Which activity gives up the difference?" Under 100% — "That leaves [N]% unaccounted. What fills it?" On the document branch, if the split looks aspirational — "Is that last month, or last month as you would have liked it?"
**Cross-check:** an accountability with no supporting activity, or an activity over 25% supporting no accountability, gets named before moving on.

---

### Q8 — Development Focus Areas

> "What does someone in this role need to build to do it well — capabilities the role stretches, not gaps in the current person? Two or three."
>
> *Example: "Commercial literacy — reading vendor contracts well enough to spot obligations that constrain scope. Facilitation at executive level. Data modelling fundamentals."*

**Form:** 2–3 capability areas, each naming the capability and why the role needs it.
**Probe:** if the answer names a person's weaknesses — "Treat the role as vacant. What would the strongest candidate still have to learn here?"

---

### Q9 — Key Relationships

> "Who does this role have to work with to succeed? Give the position or team, what the relationship is for, and how often."
>
> *Example: "Product Owner — agrees scope and priority, weekly. Solution Architect — validates feasibility, per initiative. Vendor delivery lead — confirms contractual constraints, monthly."*

**Form:** 3–7 relationships, each with counterpart (position or team), purpose, and frequency. Positions, never names.
**Probe:** if only internal relationships appear — "Anyone outside the team or outside the organisation?" If purpose is vague — "What does this role need *from* them, or owe *to* them?"

---

## After Q9

Replay the page in summary — purpose, accountability count, measure count, allocation total — and confirm before drafting:

```
Nine sections captured: [N] accountabilities, [N] measures, allocation totals 100%, [N] relationships.
[Any [TBD] items listed here.]

Ready to draft the page?
```
