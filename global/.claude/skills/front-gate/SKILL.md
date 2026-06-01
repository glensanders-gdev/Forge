---
name: front-gate
category: ideation
description: Structured intake for non-technical users submitting an idea or request for team consideration. Interprets the idea in plain language, checks relevant system knowledge and contractual obligations, then grills the requestor one question at a time to produce a complete Request Brief. Output covers problem statement, objective, metrics (optional), team ask, risk of inaction, negative impacts, and brief summary. Use when a stakeholder or non-technical user wants to formally submit an idea or request, or runs /front-gate.
---

# Front Gate

Structured intake for non-technical idea submissions. Translates a raw idea into a complete Request Brief that a technical team can act on — without requiring the requestor to know how to write a PRD or understand the delivery pipeline.

---

## Usage

```
/front-gate                      ← start intake (provide idea in any form)
/front-gate "idea description"   ← start with the idea pre-stated
```

---

## Phase 1 [AFK] — Interpret and Orient

1. Accept the idea in any form — conversational, bullet points, one sentence, lengthy explanation.
2. Restate the idea back in 2–3 plain sentences and confirm:
   ```
   I understand you're looking at [plain-language restatement].

   Is that a fair summary, or would you like to adjust it before we continue?
   ```
   Wait for confirmation or correction before proceeding.

3. Identify any systems mentioned (explicitly or implicitly). For each:
   - Search `~/.claude/knowledge/systems/` for a matching system entry
   - If found: read `Wiki/overview.md` (What an AI Can/Cannot Do here), `Wiki/known-issues.md` (Do Not Attempt, Limitations), `Wiki/stakeholder-feedback.md` (Constraints Imposed)
   - Note any constraints relevant to the idea — carry into Phase 2, do not surface yet

Do not produce output during step 3.

---

## Phase 2 [HITL] — Grill

Ask one question at a time. For each question:
- Use plain, non-technical language — no jargon, no acronyms without explanation
- Provide a brief example answer to guide the requestor
- Wait for a full response before moving to the next question

**System conflict check:** After any answer that names a system, surface relevant constraints immediately before the next question:
```
⚠️ Note: [System name] has a known constraint — [constraint from known-issues.md or stakeholder-feedback.md].
   This may affect how the team can respond. Shall we note this in the brief?
```
Wait for acknowledgment, then continue.

### Q1 — Problem Statement
> "What problem or pain are you trying to solve? What's going wrong, or what opportunity are you missing out on?"
>
> *Example: "Our team spends 3 hours a week manually copying data between two systems. It's error-prone and delays reporting."*

### Q2 — Objective
> "If this request is approved and delivered, what does success look like? What changes for the better?"
>
> *Example: "Data flows automatically, reporting is same-day, and the manual step is eliminated."*

### Q3 — Metrics *(optional)*
> "Is there a way to measure where things stand today, and where you'd like them to be after this is delivered? Numbers help the team understand the scale of the problem — but skip this if you don't have them yet."
>
> *Example: Baseline — 3 hours per week lost to manual work, 2 reporting errors per quarter. Goal — 0 hours lost, 0 errors.*

If the requestor skips or says they don't have numbers, note "Not provided" and move on — do not press.

### Q4 — What Is Needed from the Team
> "What are you asking the team to actually do? Is this a new tool, a change to an existing process, a report, something built from scratch?"
>
> *Example: "We need the IT team to build an automated connection between System A and System B."*

### Q5 — Risk & Cost of Doing Nothing
> "What happens if this request is not acted on? What does the situation look like in 6 or 12 months if things stay as they are?"
>
> *Example: "The manual process will only grow as volume increases — we estimate 6 hours per week by year-end. One bad copy already caused a reporting error this quarter."*

### Q6 — Negative Impacts
> "Are there any risks or downsides to doing this? Who or what might be disrupted, and what would the team need to plan for?"
>
> *Example: "The integration would need a short downtime to set up. Teams relying on the current manual process would need retraining."*

### Q7 — Brief Summary
> "In one or two sentences — how would you describe this request to a senior leader who has 30 seconds to read it?"
>
> *Example: "We are requesting an automated data integration between System A and System B to eliminate a 3-hour weekly manual task and improve reporting accuracy."*

---

## Phase 3 [AFK] — Draft Brief

Compile all answers into the format defined in `FORMATS.md` in this skill directory.

- Write the brief in the requestor's voice — plain language, not the AI's voice
- Place any unresolved system constraints or contractual flags in a prominent warning block at the top

---

## Phase 4 [HITL] — Review

Present the full draft to the requestor:

```
Here is your Request Brief. Please review it and let me know if anything needs to change.

[brief content]

Does this accurately represent your request? (yes / edit / cancel)
```

If "edit": ask which section to revise, apply the change, re-present the full brief.
If "cancel": discard without writing to disk — use this when the brief itself is wrong. For a change of mind after approval, use Discard in Phase 5.

---

## Phase 5 [HITL] — Submission

Present the decision gate immediately after Phase 4 approval:

```
What would you like to do with this brief?

  [1] Submit to Jira  — flag for team submission via Jira
  [2] Save as draft   — save locally to submit or refine later
  [3] Discard         — exit without saving

Enter 1, 2, or 3.
```

### Option 1 — Submit to Jira

Save the brief to `docs/requests/YYYY-MM-DD-[slug].md` with `status: pending-jira` in frontmatter.
Create `docs/requests/` if it does not exist.

Confirm:
```
✅ Brief saved and flagged for Jira submission: docs/requests/YYYY-MM-DD-[slug].md

The receiving team or company integration will raise the Jira ticket.
```

### Option 2 — Save as Draft

Save the brief to `docs/requests/YYYY-MM-DD-[slug].md` with `status: draft` in frontmatter.
Create `docs/requests/` if it does not exist.

Confirm:
```
✅ Request Brief saved as draft: docs/requests/YYYY-MM-DD-[slug].md

Next steps for the receiving team:
- Review the brief
- Run /idea to explore feasibility
- Run /grill-with-docs if architectural context is needed before committing
```

### Option 3 — Discard

Exit without writing to disk. Confirm: "Brief discarded."

---

## Forge Integration Points

| Skill | Relationship |
|-------|-------------|
| `/idea` | Receiving team's first step after reviewing a front-gate brief |
| `/grill-with-docs` | Used by the technical team to stress-test the idea against codebase and domain context before committing |
| `/write-prd` | Downstream — the brief feeds into a PRD if the idea is approved for delivery |
| `/raid` | After saving the brief, if it surfaced risks or constraints (from system knowledge or stakeholder constraints), ask: "Log these as RAID risks? (yes/no / select)". Pre-populate each selected entry with Source `GATE-NNN` where NNN is derived from the saved brief filename. |
| `/ingest` | Contractual documents and stakeholder comms can be ingested to populate the knowledge base that front-gate consults |
| `knowledge/systems/*/Wiki/known-issues.md` | Primary source for system constraints surfaced during grilling |
| `knowledge/systems/*/Wiki/stakeholder-feedback.md` | Source for contractual obligations and stakeholder constraints |
| `knowledge/projects/*/Wiki/stakeholder-feedback.md` | Project-level stakeholder constraints also checked if a project is named |

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Requestor cannot articulate the problem | Ask: "Can you describe a recent situation where this caused difficulty?" — concrete examples unlock the statement |
| System mentioned has no knowledge base entry | Note it in the brief: "No knowledge record found for [system] — the receiving team will need to verify constraints directly." |
| Requestor wants to skip a required section | Explain the section is needed for the brief to be actionable. Offer a minimal answer if they're stuck. Metrics (Q3) is the only section that may be omitted. |
| Brief reveals a hard constraint (Do Not Attempt) | Surface prominently at the top of the brief: "⚠️ This request may conflict with a known constraint on [system]. The team will need to resolve this before proceeding." |
| `docs/requests/` cannot be created | Output the brief inline and ask the user to save it manually |
| Requestor provides metrics for only one of baseline or goal | Record what was provided, note the other as "not provided" — do not estimate or infer |
| Requestor does not enter 1, 2, or 3 at Phase 5 | Re-present the options once with no additional explanation |

---

## Rules

- Use plain, non-technical language throughout — no Forge terminology, no jargon in requestor-facing output
- Never pre-commit to a solution during the grill — this skill captures the request, not the answer
- Never skip the system constraint check if a system is named
- Never write the brief to disk without a Phase 5 selection — Phase 4 approval alone is not enough
- "cancel" in Phase 4 and "Discard" in Phase 5 are distinct exits: cancel means the brief is wrong; Discard means the requestor changed their mind after approving
- Never invent or infer constraints — only surface what is documented in the knowledge base
- All sections except Metrics are required — a brief missing a required section is incomplete
- Write the brief in the requestor's voice — do not rewrite their answers in AI-formal language
- Metrics may be left as "Not provided" — never press the requestor for numbers they don't have
