# /write-prd — single-file paste bundle

Paste this whole file into a chat assistant as one message, or attach it as one file, then
give it your source material. It is the complete `/write-prd` skill: `SKILL.md` first, then every
file it cites, each under a heading carrying that file's name. A citation such as
`TEMPLATE.md` or `tables.md` means that part of this file, not a file to go and find.

A step that runs a script (`scripts/...`) cannot run in a chat. Skip that step and state in
the output that it was skipped; never produce the script's output by hand.

**Generated — do not edit.** Regenerated from the skill on every release.

## Contents

- `SKILL.md`
- `STANDARDS.md`

---

# `SKILL.md`

---
name: write-prd
category: pipeline
description: Synthesize the current conversation, grill session, research, and prototype findings into a structured PRD aligned with ISO/IEC/IEEE 29148:2018 — the functional demand document sitting between the BRD and the SOAP, stating what is built and for whom and carrying no technical figure. Executes in two phases — AFK explore then HITL write — with a confirmation gate between them. Use when user runs /write-prd or when grill-me confirms shared understanding is reached.
---

# Write PRD

Synthesize everything known into a structured PRD. The user runs `/user:write-prd` once — the skill manages both phases internally.

Execution mode: Phase 1 **[AFK]** · Phase 2 **[HITL]**. There are **three** human gates, and none of
them is optional: the Phase 1 summary confirmation, the estimate confirmation before the document is
written, and the typed `CONFIRM` before `/prototype` is removed from the working tree.

## Where this document sits

The chain is **BRD → PRD → SOAP → ORD → SAR**.

The PRD is the **functional demand document**: what is built and for whom. It is answered by the
SOAP, which is where the technical design lives. Two consequences govern everything below.

- **The PRD carries no technical figure and no architecture.** Apply the *existence test*: does
  architecture's answer already exist? Where it does, cite the SOAP. Where it does not, the figure is
  the SOAP's to produce and stating it here pre-empts the hop that exists to produce it.
- **Operational tolerance is not this document's.** It belongs to the BRD's cost-of-failure
  statements, which `/write-brd` makes mandatory and from which every downstream tolerance derives.
  The ORD sits two hops downstream, after the SOAP, so **it does not exist when this PRD is written**
  and cannot be cited at authoring time.

**SAR closes the chain but takes nothing from this document.** It is an architecture review gate: it
reviews the solution, not the demand, so the PRD carries no SAR reference and the traceability matrix
has no SAR column. Verification of the stories themselves is the `Test` column's job.

**Authoring standards — read before writing any requirement:**
- `language.md` — wording, voice, banned modals and constructions
- `tables.md` — presentation, canonical schemas, ID namespaces
- `ai.md` — **conditional.** Applies on top of both, and relaxes
  neither, where the trigger test fires: a delivered component whose output for a given input is not fully determined by written logic — a trained model, an LLM call, a retrieval-augmented pipeline, an agent, or a third-party AI service consumed as an API. It supplies the evaluative criterion
  form, the `EVL-NNN` / `MDL-NNN` schemas, and the class map that puts intended purpose and
  prohibited uses in this document. Apply the test in Phase 1 — a wrong "no" silently skips the
  whole ruleset, and nothing downstream catches it. **This document cites `EVL-NNN` and `MDL-NNN`
  and never mints them** — the ORD owns both namespaces and this skill runs first, so a criterion
  needing a set that does not exist yet carries `[EVL-TBD — <what must be measured, and on what>]`
  for `/write-ord` to write back. Prefix such a criterion **[AI]**.

These are authoritative and shared with `/write-ord`, `/write-reqs` and `/write-ac`. Never restate them here.

Each standard named above is a part of `STANDARDS.md`, beside this file — a citation such as
`tables.md` means the part of that document carrying that name, not a separate file to find.

**If an authoring standard above cannot be read, stop and name it.** The register and criteria
schemas, the modal ban and the scenario values live there and nowhere else. Drafting them from
memory produces a document that looks conformant and is not, and no reviewer can see the
difference. An unreadable standard is a blocked run, never a degraded one.

## Sourcing the PRD standard

Read the standard; do not recall it. The live pack where it is held —
`$FORGE_REQ_PACK/reference/prd-standard.md`, else `requirements-documents/reference/prd-standard.md`
searching up from the working directory.
**Name the pack version in the Phase 1 summary and in the PRD header.** Where the pack is not
readable, say so in the summary and author from this skill alone — never claim a pack version that
was not read.

**Two declared divergences from that page. State them wherever they bite; never diverge silently.**

| The pack page says | This chain | Which wins |
|---|---|---|
| The PRD is *defined, not adopted*; functional detail is held in the referred requirements register | The PRD is adopted and sits between the BRD and the SOAP | **This chain**, on placement and adoption. The register's functional rows are this document's intake, not its substitute |
| The PRD and the ORD are siblings, both answered by one SOAP; a criterion cites the ORD tolerance | The ORD is downstream of the SOAP; tolerance is cited from the BRD's cost-of-failure | **This chain**, on the citation target |
| Requirement form — the 29148 characteristics, the ★ sections, the anatomy | unchanged | **The pack** |

Where the pack and `standards/requirements/*` meet, the rules win on **form** — criteria are noun-first
declarative rows per `tables.md`, not the pack's Given/When/Then — and the pack wins on **what a PRD
must contain**. Both are deliberate; see the criteria note in the template.

---

## Phase 1 — Explore [AFK]

Runs unattended. Gathers all context needed to write the PRD without asking the user anything.

### Phase 1 Process

0. **Check for a joint-authoring brief.** When invoked by `/write-reqs`, a brief accompanies the invocation carrying the PRD-bound half of the classified source. Treat that half as the **extraction scope** — not a hint. Operational statements in the brief are **not** co-authored into a sibling ORD under this chain: route them to the BRD's cost-of-failure per step 6 and name the destination. Suppress the standalone next-steps block at the end of Phase 2; `/write-reqs` owns sequencing. Absent a brief, this is a standalone run; proceed from step 1 as normal.
1. **Source the PRD standard** per *Sourcing the PRD standard* above, and note the pack version (or that the pack was unreadable) for the summary.
2. Read `docs/CONTEXT.md` — domain glossary and terminology.
3. Read grill session summary from the current conversation or `docs/DEVLOG.md`.
4. Read any `docs/research/*.md` files relevant to this feature.
5. Read `/prototype/LOGIC.md` and `/prototype/UI.md` if they exist. A UI spike's **§ Structural Accessibility Constraints** is not narrative — it records what the chosen layout fixes that Implementation cannot undo, and each such constraint becomes a `CON-NNN` row in § Solution Constraints below. Carrying it as prose loses it.
6. **Read the BRD** if one exists (`docs/brd/`) and capture two things:
   - the **objectives (`BO-N`) and business requirements (`BR-N`)** this feature traces up to — these are the IDs `/write-brd` emits, not `BRD-NN`;
   - the **cost-of-failure statements**, which are where operational tolerance lives in this chain. A story that depends on a tolerance cites the BRD statement; it never states a figure and never forward-cites an ORD section that does not exist yet.

   If no BRD exists, note it; PRD requirements trace to their proximate input (grill / research / prototype) instead, and any operational tolerance surfaced here is flagged as **belonging upstream** rather than absorbed.
7. **Read the referred requirements register** if one exists. Functional rows held there are rows that were elicited with nowhere to go — under this chain the PRD is their home, so pull them into extraction scope and mark them as register intake in the provenance table.
8. **Tag provenance as you extract.** For every need or capability, record its source (`BO-N` / `BR-N`, register row, grill-session decision, `docs/research/*.md §`, prototype finding, or named stakeholder). This feeds the traceability matrix in Phase 2 — capture it now rather than reconstructing it later.
9. **Explore the codebase for feasibility only.** 29148 requires each requirement to be *Feasible*; reading the code is how that judgement is evidenced. It is **not** design work, and none of it lands in the PRD as architecture — module decomposition, interface shape and schema are the SOAP's, one hop downstream. Record what makes a story infeasible or costly, not how it will be built.
10. **Determine the delivery mode**, and name the **delivery route** beneath it. The mode decides whether the PRD carries an AI token estimate at all; the route is what makes the mode checkable.
    - **AI-assisted** — the solution is built with AI-generated code. Token cost is a real budget line, the smart-zone limit applies, and the T-shirt band drives `/break-down`.
    - **Conventional** — routes: **in-house team**, **vendor**, **bought**, or **configured**. **Token cost is meaningless here and is not estimated.** Story points still apply: they size the work for PI planning regardless of who or what writes the code. Name the route — sizing a bought product is a different conversation from sizing in-house build effort, and the mode alone hides that.

    **Two determining signals only, in this order:**
    1. An explicit statement in the source or the BRD.
    2. The delivery agent named for this work — a vendor or a non-engineering department determines *Conventional*.

    Where neither fires, the mode is **not determined**. Repository context is **not** a determining signal: almost every repo this skill runs in is agent-driven, so treating that as evidence would make the mode auto-resolve to AI-assisted every time and the human would never see the question. Offer it as a *suggestion* in Open Questions — "no statement found; this repo is agent-driven, so AI-assisted is likely — confirm" — and let the human settle it at the gate.
11. **Apply the AI trigger test** from `ai.md` — is any delivered component's
    behaviour learned or generated rather than specified? Answer it explicitly and state the answer
    in the Phase 1 Summary; do not leave it unasked. Where it fires, that ruleset governs the
    criteria for every story touching such a component, and this document owns the intended purpose
    and the prohibited uses. Judge the **delivered solution**, never the toolchain that builds it —
    AI-assisted delivery mode (step 10) is not a trigger, and the two questions are independent.
12. Produce a **Phase 1 Summary** and pause for human confirmation.

### Phase 1 Summary Format

```markdown
## PRD Explore Summary — [Feature Name]

**Standard:** ISO/IEC/IEEE 29148:2018 · **Pack version:** [vN.N, or "pack not readable — authored from skill alone"]
**Chain position:** BRD → **PRD** → SOAP → ORD → SAR

### Source Material Read
- [List of files read, including the BRD and the referred requirements register if found]

### BRD Objectives and Business Requirements (origin of scope)
| BO / BR | Business need | Covered by this PRD? |
|---------|---------------|----------------------|
| [BO-N / BR-N, or "no BRD found"] | [need] | Yes / Partial / N/A |

### Extracted Needs by Source (provenance)
| Need / capability | Source | Proposed story |
|-------------------|--------|----------------|
| [need] | [BO-N / BR-N / register row / grill / research § / prototype / stakeholder] | [PRD-NNN] |

### Operational Tolerance Encountered (routed, not absorbed)
Tolerance belongs to the BRD's cost-of-failure; the figure answering it belongs to the SOAP.
| Statement found | Cited from | Or: routed to |
|-----------------|-----------|---------------|
| [what the source said] | [BRD cost-of-failure ref] | [raise against the BRD — no BRD statement covers it] |

### Feasibility Findings
[What the codebase says about whether these stories are achievable, and at what cost. Constraints
and risks only — no module decomposition, no interface or schema design. Those are the SOAP's.]

### Scope Boundary
**In:** [What will be built]
**Out:** [What will not be built]

### AI Trigger — `ai.md`
**Fired:** Yes — [components whose behaviour is learned or generated] | No — [why the test does not fire]
This asks about the **delivered solution**, not the toolchain. It is independent of Delivery Mode below.
[Where fired:] **Intended purpose:** [PRD § Scope boundary owns it] · **Prohibited uses:** [PRD § Out of Scope owns it]
[Where fired:] **Evaluation sets needed:** [EVL-NNN candidates, or "none identified — TBD at the gate"]

### Delivery Mode
**Mode:** AI-assisted | Conventional | **Not determined — settle at this gate**
**Route:** [in-house team / vendor / bought / configured — Conventional only]
**Evidence:** [the source statement or the named delivery agent, quoted. "Neither found" where the mode is undetermined — repository context is not evidence.]
**Estimates to be produced:** [token band + story points | story points only — token cost does not apply]
**Sections this decides:** [Task List form, Definition of Done rows, and the next-steps block, as well as the estimate table]

### Open Questions
[Anything that needs human input before writing the PRD]

---
Confirm this scope to proceed to Phase 2, or provide corrections.
```

---

## Phase 2 — Write [HITL]

Runs after human confirms Phase 1 summary. Writes the PRD and cleans up.

### Phase 2 Process

1. Incorporate any corrections from the human's Phase 1 confirmation.
2. Check `~/.claude/knowledge/company/style-guide.md` — if populated, apply its tone, terminology, and formatting standards when writing the PRD. If it is a placeholder, proceed without it.
3. **Generate per-story estimates** — one row per story, not per module. Sizing by module would require a module decomposition, and that decomposition is the SOAP's; a story is estimable under INVEST without one.

   **The delivery mode confirmed at the Phase 1 gate decides which table is produced.**

   **AI-assisted** — token cost band (S/M/L/XL) and story points (1/2/3/5/8/13):
     ```
     ## Story Estimates — [Feature Name]   ·   Delivery mode: AI-assisted

     | Story | Token Cost | Story Points | Reasoning |
     |-------|-----------|-------------|-----------|
     | PRD-001 [short title] | M (20–80k) | 5 | [one sentence] |
     | PRD-002 [short title] | S (<20k) | 2 | [one sentence] |
     | PRD-003 [short title] | L (80–200k) | 8 | [one sentence] |
     | **Total** | **L** | **15pts** | |

     ⚠️ XL items: [none / PRD-00N requires /break-down before /build]

     Confirm or adjust before I write the PRD.
     ```
   - Flag any XL stories — they require `/break-down` before `/build` can execute them

   **Conventional** — story points only. **No token band, no T-shirt size, no XL/`/break-down` flag.** Token cost measures what it costs an AI to write the code; where people, a vendor or a configuration change deliver the work, the number measures nothing and a band printed anyway reads as a budget someone will plan against:
     ```
     ## Story Estimates — [Feature Name]   ·   Delivery mode: Conventional

     | Story | Story Points | Reasoning |
     |-------|-------------|-----------|
     | PRD-001 [short title] | 5 | [one sentence] |
     | PRD-002 [short title] | 2 | [one sentence] |
     | **Total** | **7pts** | |

     Token cost not estimated — not an AI-assisted delivery.

     Confirm or adjust before I write the PRD.
     ```
   - The smart-zone limit is a token-budget rule, so it does not apply. A story that is simply too large is still flagged for `/break-down` on story points alone — say which it is, and never present it as an XL token band.

   **Do not proceed to step 4 without confirmation** — the totals land in the PRD header, so they must be settled before the document is written, not patched in afterwards.
4. **Write the PRD** using the template below, incorporating the confirmed estimates. Add story points to the stakeholder label for PI planning — they apply under either delivery mode; token bands, where they exist at all, stay internal. **Enforce the pack's three ★ sections before finalising** — they are the gaps the standard exists to close:
   - **★ Success Metrics present** — at least one measurable metric (Metric / Baseline / Target / Measurement), with one marked **primary**. These are **product outcome metrics, not operational targets**: a metric measuring whether the feature achieved its purpose belongs here; the latency or availability figure that makes it attainable is the SOAP's. If none genuinely apply, write `Success Metrics: none — [reason]` explicitly; never omit the section.
   - **★ Every user story has ≥1 acceptance criterion** — block finalisation if any story has none. Warn (do not block) if a story carries only `Sunny Day` criteria with no `Rainy Day` or `Edge Case` row, and name the missing scenario: *"PRD-003 is Sunny Day only — no Rainy Day criterion states what is true when the payment service is unavailable."* A story specified for fair weather alone is specified for the demo, not for production.
   - **★ Traceability populated** — every story has a stable ID (`PRD-NNN`), a MoSCoW priority, and traces up to a `BO-N` / `BR-N` or a named proximate source.
   Each requirement meets the ISO/IEC/IEEE 29148:2018 characteristics — necessary, appropriate, unambiguous, complete, singular, feasible, verifiable, correct, conforming — as modified by the two deviations recorded in `language.md`. Rewrite vague requirements ("fast", "intuitive") into testable form or flag them.
   **Scan the draft for pre-empted SOAP content before saving.** Any latency figure, availability percentage, RTO/RPO, module decomposition, interface contract or schema is a boundary breach — remove it, and where the demand behind it is real, restate it as observable behaviour or route it to the BRD's cost-of-failure.
5. Save to `docs/prd/active/[feature-name].md`.
6. Add Phase 2 kanban tickets to `docs/kanban.md`. These track **this skill's own authoring work**, which is AI-run under either delivery mode — do not branch them on `Delivery Mode`, and carry an estimate tag only where one was produced:
   ```
   - [ ] [AFK]  #N   Explore sources and feasibility for PRD — write-prd phase 1
   - [x] [HITL] #N+1 Confirm scope and estimates, write PRD — write-prd phase 2
   ```
7. **Preserve, then clean up `/prototype`** if it exists. Do **not** delete the spike outright — first commit it to a throwaway branch `prototype/[feature-name]` so the exploration survives as primary-source evidence (Principle 8), and record a pointer to that branch in the PRD's Further Notes section.

   Removing `/prototype` deletes files from the working tree, so it is gated:

   ```
   ## Prototype cleanup — [feature-name]
   Preserved on branch: prototype/[feature-name]  (commit [sha])
   Pointer recorded in: docs/prd/active/[feature-name].md § Further Notes
   To delete from working tree: [N files]

   Type CONFIRM to remove /prototype, or SKIP to leave it in place.
   ```

   If a git branch can't be created (e.g. not a git repo), leave `/prototype` in place and note it — never destroy the only copy, and never present this gate when preservation failed.
8. Suggest next steps in order. **The first applies under either delivery mode; the rest are the build path and apply under `AI-assisted` only.**
   - Hand the PRD to the **SOAP** hop — it is the document that answers this one, and every `SOAP Ref` cell in the traceability matrix stays `TBD` until it does.
   - Run `/testplan` to design the testing strategy before implementation begins — this also **back-fills the `TBD` Test column** in the PRD's Traceability Matrix. Under `Conventional` this is still worth running for the Test column, but its output describes verification the delivering party performs, not tests this repo will write.
   - Then run `/to-tickets` (the Kanban stage) to convert the PRD task list into tracked vertical-slice tickets in `docs/kanban.md`. **`AI-assisted` only** — under `Conventional` the delivering party owns its own plan.

   **State the downstream limitation when the mode is `Conventional`.** `/estimate`, `/break-down`, `/to-tickets` and `/build` do not yet read `Delivery Mode` and assume AI-assisted delivery — `/break-down` in particular is built on the 100k-token smart zone. Say so when handing off, so the mode is carried by a human rather than silently lost at the next skill.

---

## PRD Template

**Two lines are conditional and must not be emitted as written.** `Estimate (AI Token Cost)` is
omitted entirely when `Delivery Mode` is `Conventional` — omitted, not filled with `N/A`, because a
populated-looking field gets planned against. `Route` is present under `Conventional` only. Resolve
both before saving; never copy this instruction into the document.

```markdown
# PRD: [Feature Name]

**Date:** YYYY-MM-DD
**Status:** Active
**Standard:** ISO/IEC/IEEE 29148:2018 · **Pack version:** vN.N (or "pack not read")
**Chain position:** BRD → **PRD** → SOAP → ORD → SAR
**Sprint:** Sprint-NN (or "Not sprint-tracked")
**PI:** PI-N [Name] (or "Not PI-tracked")
**Target Release:** PI-N-RN (or "Standalone" or "Not assigned")
**Author:** [Human name or the authoring agent]

**Stakeholder Label:** [External-facing feature name for stakeholder communication]
**Delivery Type:** Iterative | Fixed Scope | Fixed Deadline | Fixed Both
**Delivery Mode:** AI-assisted | Conventional
**Route:** in-house team | vendor | bought | configured
**Priority:** P1 Critical | P2 High | P3 Normal | P4 Low
**Due Date (Internal):** YYYY-MM-DD (or "None")
**Due Date (External):** YYYY-MM-DD (or "None")
**Estimate (AI Token Cost):** S | M | L | XL
**Estimate (Story Points):** N pts (or "Not estimated")
**Estimate Status:** Current | Stale | Not estimated
**Last estimated:** YYYY-MM-DD

> `Delivery Type` and `Delivery Mode` are different axes and neither substitutes for the other.
> Type is how scope and date are held (Iterative, Fixed Deadline…); Mode is who or what builds it.
> A Fixed Deadline feature delivered by a vendor is `Fixed Deadline` + `Conventional`.

---

## Problem Statement

[The problem from the user's perspective. What pain exists today?]

## Solution

[The solution from the user's perspective. What will exist when this is done?]

## Success Metrics ★

[Measurable targets that define success. Mark one as primary; others are secondary/guardrail (must not regress). If none genuinely apply, write "none — [reason]".]

| Metric | Baseline | Target | Measurement method | Type |
|--------|----------|--------|--------------------|------|
| [e.g. checkout abandonment] | [23%] | [≤ 14%] | [funnel analytics, 30-day] | Primary |
| [e.g. checkout errors] | [0.4%] | [no regression] | [error telemetry] | Guardrail |

> **Product outcome metrics, not operational targets.** A metric here measures whether the feature
> achieved its purpose. The latency budget, availability percentage or throughput figure that makes
> it *attainable* is the SOAP's answer, one hop downstream — it is not restated here.

## Users & Stakeholders

[Each actor referenced in a story below. May be a user segment, job title/role, or stakeholder.]

| Actor | Description | Type |
|-------|-------------|------|
| [e.g. Returning shopper] | [one line: who they are, what they need] | Primary |
| [e.g. Compliance officer] | [one line] | Stakeholder |

## Scope Boundary

States what is in. A PRD carrying only an exclusions table leaves "in" to be inferred from the
stories, which is how scope creeps without anyone editing a document.

**In:** [what is being built, in user terms]

**Out:** see § Out of Scope. Exclusions are binding, so they live in one place as rows — restating
them here would put the same commitment in two independently editable spots.

## User Stories & Acceptance Criteria ★

The **story** is narrative — it carries intent, and the "so that" is the business outcome.
The **criteria** are declarative rows — they carry what is true once the story is delivered.
Keep stories at capability granularity; push detail into the criteria.

**PRD-001 — Reuse saved payment details at checkout**
**MoSCoW:** Must
As a returning customer, I want to pay without re-entering my card, so that checkout completes in fewer steps.

*Each criterion below states what is true for PRD-001 under one condition — fair weather, foul
weather, and the boundaries.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-001.1 | Checkout for a returning customer with a saved payment method completes without card re-entry. | Sunny Day |
| PRD-001.2 | Payment-service timeout leaves the basket intact and the customer on the checkout page. | Rainy Day |
| PRD-001.3 | A saved card past its expiry date is rejected at checkout and re-entry is requested. | Edge Case |

> **Criteria are noun-first declarative statements** per `language.md` — state what
> is true, not what a user *can* do. Not *"Then they can complete the purchase"*: `can [verb]` is
> banned, and a criterion saying a customer *can* do something cannot fail a test. This is a
> **declared divergence from the pack**, which writes criteria as Given/When/Then: the rules win on
> form because the modal ban is unenforceable inside a `Then` clause, and the pack wins on everything
> the criterion must *do* — testable, singular, covering Sunny Day, Rainy Day and Edge Case.
>
> **The three scenario labels come from the pack**, whose coverage rule reads "cover Sunny Day, Rainy
> Day and Edge Case — at minimum" and whose § *The three scenarios* defines each one. This skill does
> not name them independently; read the pack. A PRD or reader carrying the pre-2026-08 wording maps
> one-to-one — Sunny Day = happy path, Rainy Day = error state, Edge Case = edge case.
>
> **They state observable behaviour and cite the rest.** No latency figure, availability percentage,
> encryption mechanism or recovery target. Where a story depends on one, cite the BRD cost-of-failure
> statement that establishes the tolerance — the figure answering it is the SOAP's.

**PRD-002 — [short title]**
**MoSCoW:** Must | Should | Could | Won't
As a [role], I want [capability], so that [outcome].

*Each criterion below states what is true for PRD-002 under one condition — fair weather, foul
weather, and the boundaries.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-002.1 | [what is true when everything works] | Sunny Day |
| PRD-002.2 | [what is true when a dependency fails, times out, or refuses] | Rainy Day |
| PRD-002.3 | [what is true at a boundary — empty, maximum, expired, first, last] | Edge Case |

- Story IDs are flat and sequential — `PRD-001`, `PRD-002`, … in order of first appearance, never encoding the story's theme. Criterion IDs are `PRD-NNN.N` within their story, so `/write-ac` maps each `AC-NNN` to a precise criterion rather than a whole story.
- `Scenario` is `Sunny Day` / `Rainy Day` / `Edge Case` — **the same requirement examined under three conditions**, not three kinds of criterion. Sunny Day: everything available and behaving. Rainy Day: something failing — dependency down, timeout, refusal. Edge Case: a valid but boundary condition — empty, maximum, expired, first, last. The column is `Scenario`, never `Type`: a reader who sees `Type` asks what kind of criterion this is, and the answer is always "an acceptance criterion".
- A story with only `Sunny Day` rows triggers the coverage warning at finalisation — it has been specified for the demo, not for production. Name the missing weather in the warning rather than reporting a count.
- The labels describe the condition, never the certainty. A `Rainy Day` criterion states what *is* true when the dependency fails — the modal ban in `language.md` applies to all three scenarios equally.
- `MoSCoW` gates altitude in `/write-ac`: `Won't` produces no AC at all, `Could` never reaches Capability level. It is a per-story scope decision, distinct from the document-level `Priority:` field, which ranks this whole feature against other features for PI planning. Never collapse the two.
- IDs are retired when a story or criterion is dropped — never reused.

## Solution Constraints & SOAP References

**Not a design section.** Module decomposition, interface contracts, schemas and technical figures
belong to the SOAP, which answers this document. Two things only live here:

| ID | Constraint or reference | Type | Why it binds the solution |
|----|-------------------------|------|---------------------------|
| CON-NNN | [e.g. must integrate with [named system] — mandated by contract] | Demand-side given | [regulatory / contractual / business mandate, with its source] |
| CON-NNN | [e.g. [Product] reflows to 320 CSS px without two-dimensional scrolling — the chosen layout is single-column by decision] | Demand-side given | [WCAG 2.2 AA, SC 1.4.10; structural, fixed at `/prototype` variant selection] |
| — | [e.g. [System] SOAP §N answers PRD-001's tolerance] | SOAP reference | [an answer that already exists and is cited, not restated] |

- A **demand-side given** is a constraint the business imposes regardless of design — a named system
  that must be integrated with, a regulatory obligation, a contractual commitment. It states the
  constraint and its source, never how it is met. It **binds**, so it carries a `CON-NNN` ID per
  `tables.md`; a SOAP reference is a citation, not a commitment, and carries `—`.
- A **SOAP reference** is only valid where the SOAP already exists. Apply the existence test: where
  architecture's answer does not yet exist, the figure is not this document's to invent.
- A **structural accessibility constraint** carried out of `/prototype` is a demand-side given like any other: the accessibility floor is regulatory in source (in Australia, WCAG 2.2 Level AA under the Disability Discrimination Act 1992 for any public-facing service), and the layout that satisfies it was fixed when the variant won. Cite the SC and name it structural, so a reader knows it cannot be traded away at build time. Implementational accessibility — contrast, names and roles, live regions — is not a `CON-NNN`; it is ordinary delivery work and belongs to `/accessibility`.
- Where neither applies, write `None` and let the SOAP hop do its work.

Do NOT include file paths or code snippets — these go stale quickly, and they are not demand.

## Task List

**This section takes its form from `Delivery Mode`.** `[AFK]` means an AI agent executes it
unattended, so the tag is meaningless where no AI is building the solution.

**Under `AI-assisted`:**

### HITL Tasks (Human-in-the-Loop)
Tasks that require a human to be present.

- [ ] [HITL] #1 [Task description]

### AFK Tasks (Away from Keyboard)
Tasks the AI agent can execute autonomously.

- [ ] [AFK] #2 [Task description] `blocked-by: #1`

**Under `Conventional`:** drop the HITL/AFK split — every task has a human owner. The delivering
party owns its own plan; this list is the demand side's view of it, not a substitute for it.

| # | Task | Owner | Blocked by |
|---|------|-------|------------|
| 1 | [task description] | [role or named party] | — |

## Testing Decisions

- What makes a good test for this feature (test external behaviour, not implementation details)
- Which stories carry automated coverage, and which are verified by demonstration or inspection
- Any prior art in the codebase to reference

## Definition of Done

Always:

- [ ] Every story's acceptance criteria verified
- [ ] Success-metric instrumentation live before launch (or explicitly waived)
- [ ] All human sign-offs obtained

**Under `AI-assisted`, add:**

- [ ] All tasks on the Kanban board marked complete
- [ ] All HITL tasks signed off by human
- [ ] Tests passing
- [ ] README updated if user-facing behaviour changed
- [ ] `/approve` issued by human after QA

**Under `Conventional`, add:** the delivering party's own completion evidence — acceptance test
results, a vendor sign-off, or a configuration record — named explicitly rather than assumed.

## Out of Scope

Exclusions are binding — they get cited in scope disputes — so they are rows, not prose. They carry
no ID: nothing traces *to* an exclusion, so an ID would never be referenced.

| Excluded | Reason | Revisit when |
|----------|--------|--------------|
| [what is not being built] | [why it is out] | [trigger, or "not planned"] |

## Assumptions & Dependencies

Carries forward the assumptions table from `/idea` with its Status — never collapse it to prose.
`If false` is mandatory. On falsification set `Status: Falsified`, run `/raid add risk`, and record
the `R-NNN` in `If false` (the RAID log has no Assumptions quadrant). Where no RAID log exists,
carry `[R-TBD]` with the owner and the consequence rather than dropping the row.

| ID | Assumption | Status | If false | Owner |
|----|-----------|--------|----------|-------|
| ASM-NNN | [declarative statement] | Unvalidated / Validated / Falsified | [consequence] | [role] |

**Cite the BRD's cost-of-failure for operational tolerance** — e.g. "the consequence of the rebate
determination being unavailable is stated in [change] BRD §11". The ORD sits after the SOAP in this
chain and does not exist when this PRD is written, so it cannot be cited here. Where a tolerance is
needed and no BRD statement covers it, record it as a dependency with `Status: Open` and raise it
against the BRD — never absorb it into this document as a figure.

| ID | Depends on | Type | Owner | Needed by | Status |
|----|-----------|------|-------|-----------|--------|
| DEP-NNN | [named system, team, or deliverable] | Internal / External / Vendor | [role] | [date or milestone] | Open / Met / At risk |

Write `None` in place of a table only when genuinely empty.

## Further Notes

[Anything else relevant — links, open questions for later. Sources go in References.]

## References

Every source this PRD cites — the BRD, the ORD, contracts, legislation, standards, research —
in the reference-list form of `tables.md` § *Reference list*, with citation forms from
`language.md` § *Citing Sources*. One row for each source cited, and none that nothing cites.
`None cited` where there is none.

| Cited as | Full citation | Type |
|---|---|---|

## Appendix: Traceability Matrix ★

Full-chain, bidirectional, running **BRD → PRD → SOAP**. Two columns are scaffolded `TBD` and
back-filled at the hop that answers them: `Test` when `/testplan` runs, `SOAP Ref` when the SOAP
answers this document.

Unlike the ORD — whose register carries provenance in each requirement row — a PRD story is
narrative, so provenance has no row to live in. This matrix is that home, not a duplicate of it.

| BRD Objective | Business Req | Proximate Source | PRD Req ID | Acceptance Criteria (summary) | Test | SOAP Ref |
|---------------|--------------|------------------|------------|-------------------------------|------|----------|
| [BO-N or —] | [BR-N or —] | [register row / grill / research § / prototype / stakeholder] | [PRD-NNN] | [one line] | [TBD / T-NN] | [TBD / SOAP §N] |

- IDs are the ones `/write-brd` emits: `BO-N` for objectives, `BR-N` for business requirements.
  **Never `BRD-NN`** — no skill in this chain produces that form.
- **There is no ORD column.** The ORD is reached through the SOAP, not directly from here; a PRD
  story that traced straight to an ORD requirement would skip the hop that produces the design.
- A story with no `BO-N`/`BR-N` and no proximate source is **orphan scope** — flag it.
- A BRD objective with no resulting story is a **coverage gap** — flag it.
- A `SOAP Ref` still `TBD` after the SOAP is issued is a **conformance gap** — the demand was stated
  and never answered. Flag it rather than closing the row.
```

---

## Rules

- Never write `Happy path`, `Happy Path`, `Error`, `Error Case` or `Edge` as a scenario value, and never head that column `Type`. The values are `Sunny Day`, `Rainy Day` and `Edge Case`; the column is `Scenario`. This holds in the criteria tables, in the Phase 1 summary, in the coverage warning, in the traceability matrix's criteria summaries, and in any sentence of prose naming them — a stakeholder reads these words aloud, and one reverted label undoes the reason the naming exists. Check the finished document for the old terms before presenting it.
- Never write the PRD without Phase 1 confirmation — the gate is mandatory.
- Never ask the user questions during Phase 1 — gather, then present.
- Never finalise a PRD with an empty Success Metrics section — require at least one measurable metric, or an explicit `none — [reason]`.
- Never finalise a PRD with a user story that has no acceptance criterion.
- Never write a requirement in unverifiable or hedged form — see `language.md`. Quantification alone is not enough: a quantified requirement carrying `should` or `can` still fails. Quantify, write it as a declarative end state, or flag it as `[TBD — source: "quoted vague statement"]`.
- Never delete `/prototype` from the working tree without a typed `CONFIRM`, and never present that gate unless preservation to the throwaway branch already succeeded.
- Never write a story without a MoSCoW priority — `/write-ac` gates altitude on it, and an unset priority silently bypasses that gate.
- Never record an assumption without an `If false` consequence, and never leave a falsified assumption unescalated — set `Status: Falsified` and raise it via `/raid add risk`.
- Never emit the standalone next-steps block when invoked with a `/write-reqs` brief — sequencing is owned there, once.
- Never reuse a retired story ID — retire and move on.
- **Never state a technical figure or a design.** No latency budget, availability percentage, RTO/RPO, throughput target, encryption mechanism, module decomposition, interface contract or schema. Apply the existence test: where architecture's answer does not already exist, stating it here pre-empts the SOAP hop that exists to produce it.
- **Never cite an ORD section.** The ORD is downstream of the SOAP and does not exist when this PRD is written. Operational tolerance is cited from the BRD's cost-of-failure; where no BRD statement covers it, raise it against the BRD rather than absorbing it here.
- **Never write `BRD-NN`.** `/write-brd` emits `BO-N` objectives and `BR-N` business requirements; a PRD tracing to `BRD-NN` traces to IDs nothing produces.
- **Never diverge from the pack silently.** The two divergences are declared in *Sourcing the PRD standard* and restated where they bite. A third one found mid-authoring is declared at the Phase 1 gate, not absorbed.
- **Never claim a pack version that was not read.** Where the pack is unreadable, say so in the summary and in the PRD header.
- Never size by module — a module decomposition is the SOAP's. Estimate per story.
- **Never produce a token estimate or a T-shirt band for a conventionally-delivered solution.** Token cost measures what it costs an AI to write the code; where people, a vendor or a configuration change deliver it, the band measures nothing and will be planned against as though it did. Omit the header line rather than writing `N/A` into it.
- **Never assume the delivery mode, and never read it off repository context.** Only an explicit statement or a named delivery agent determines it; an agent-driven repo is a suggestion to confirm, not evidence. Absent both, write `Not determined` and let the human settle it at the gate — the mode decides the estimate table, the Task List form, the Definition of Done rows and the next-steps block.
- **Never emit a conditional instruction into the document.** The template's conditional lines are resolved before saving — an emitted `omit this line when…` or an unresolved `Route:` under AI-assisted is a template artefact, not a PRD.
- If Phase 1 uncovers a significant unknown that blocks scoping, surface it in Open Questions and wait.
- Do not clean up `/prototype` until Phase 2 is complete and confirmed — and never before it is preserved on its `prototype/[feature-name]` throwaway branch with a pointer recorded in the PRD.
- The `Sprint:` field in the PRD must be filled — check `~/.claude/sprints/calendar.md` for the current sprint.

## Idea Diagram Update

If an idea in `~/.claude/ideas/active/` is linked to this project:

After Phase 2 is complete and PRD is written:
1. Read `~/.claude/ideas/active/[idea-name]/diagram.mmd`
2. Update to reflect the confirmed scope, stories, and solution constraints from the PRD
3. Save updated version as `diagram.mmd` (current)
4. Save snapshot as `diagram-v3-prd.mmd`
5. Update the diagram version history table in `idea.md`

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No grill session summary found | Note it. Proceed using current conversation context only. Flag in PRD: "No prior grill session — scope may need validation via `/critic`." |
| `CONTEXT.md` missing | Note it. Proceed — flag any terms used in PRD that should be added to CONTEXT.md. |
| No BRD found | Note "No BRD found." Proceed — trace each story to its proximate source (grill / research / prototype / stakeholder) in the matrix instead of a `BO-N`. Flag that operational tolerance now has no upstream home, so any encountered is recorded as an open dependency rather than absorbed. |
| PRD standard pack unreadable | Note it in the Phase 1 summary and write `Pack version: pack not read` in the PRD header. Author from this skill alone. Never assert a version that was not read. |
| A source supplies a technical figure (latency, availability, RTO, throughput) | Do not carry it into the PRD. Restate the demand behind it as observable behaviour, and route the tolerance to the BRD's cost-of-failure. Where the figure is genuinely already decided, cite the existing SOAP instead of copying the number. |
| A story needs a tolerance and no BRD cost-of-failure covers it | Record a dependency with `Status: Open` naming the BRD as the destination, and surface it at the Phase 1 gate. Never invent the tolerance and never state it as a PRD figure. |
| Referred requirements register holds functional rows for this feature | Pull them into extraction scope and mark them as register intake in the provenance table. They are rows that were elicited with nowhere to go; this document is their home. |
| Source material only supports a design, not a demand | Stop before writing. A PRD that is a restatement of a chosen solution has skipped the hop it exists to feed. Report it in Open Questions and put the missing user-facing outcome to the human at the Phase 1 gate — do not interrupt Phase 1 to ask. |
| Feature has no measurable success metric | Do not silently omit. Write `Success Metrics: none — [reason]` and flag for the human to confirm the feature is genuinely unmeasurable. |
| A user story has no acceptance criterion | Block finalisation. Prompt for criteria; do not write the PRD until every story has at least one. |
| A BRD objective produces no story, or a story has no source | Flag in the Traceability Matrix as a coverage gap (orphaned objective) or orphan scope (sourceless story). Do not silently resolve. |
| Active PRD already exists | Stop. "An active PRD already exists at docs/prd/active/. Complete or archive it before writing a new one." |
| Phase 1 exploration finds no relevant codebase | Note "Codebase appears empty or not yet scaffolded." Proceed with a greenfield assumption — state it explicitly. |
| Sprint field cannot be determined | Set to "Not sprint-tracked" and flag for human to update. |
| Estimate confirmation not given | Do not write PRD until estimates are confirmed — prompt once more. |
| Neither determining signal fires — no statement, no named delivery agent | Record `Mode: Not determined` and put it in Open Questions. Repository context is not a determining signal, so offer it as a suggestion ("this repo is agent-driven, so AI-assisted is likely — confirm") and wait for the human. It decides four sections, not just the estimate. |
| Delivery mode is Conventional | Produce story points only, and name the route. Omit the `Estimate (AI Token Cost)` header line and the token column, drop the XL/`/break-down` flag (the smart zone is a token-budget rule), use the owner-tagged Task List, add the delivering party's completion evidence to the Definition of Done, and mark `/to-tickets` as not applicable. A story too large on points alone is still flagged, named as such. |
| `Delivery Mode` is `Conventional` and the PRD is handed downstream | State that `/estimate`, `/break-down`, `/to-tickets` and `/build` do not read the mode and assume AI-assisted delivery. The mode is carried by a human until they do — say so rather than letting it be lost silently. |
| Mode is Conventional but the source quotes a token or AI-cost figure | Do not carry it into the PRD. Note it in Open Questions — a token figure against non-AI delivery is either a mis-stated mode or a number nobody can act on. |
| Mode changes after the PRD is written (e.g. work moves to a vendor) | Re-run the estimate step for the new mode and replace the header block wholesale. Never leave a stale token band beside a conventional delivery. |
| Invoked by `/write-reqs` with a joint-authoring brief | Treat the brief's PRD-bound half as the extraction scope. Route its operational statements to the BRD's cost-of-failure and name the destination — do not treat them as a sibling ORD's half. Suppress the standalone next-steps block; `/write-reqs` owns sequencing. **`/write-reqs` still describes PRD and ORD as co-authored siblings and has not been reworked for this chain — say so when a brief arrives.** |
| Brief received but a listed need cannot be placed in a story | Stop before writing. Report it to `/write-reqs` as unclassified — do not silently drop it or invent a story for it. |
| Source states no MoSCoW for a story | Write `TBD` and surface it at the Phase 1 gate. Never default to `Must`. |
| `/prototype` cleanup `CONFIRM` declined or answered `SKIP` | Leave `/prototype` in place. The PRD still stands; note in Further Notes that the spike remains in the working tree. |

---

# `STANDARDS.md`

# Authoring Standards

The standards `/write-prd` cites, gathered into one document so the skill works where
there is no filesystem to read them from. Each part keeps the name of the file it came
from: a citation such as `tables.md` means the part below with that name.

- **`README.md`** — Requirements Rules
- **`language.md`** — Requirements Language
- **`tables.md`** — Requirements Tables
- **`ai.md`** — Requirements — AI Solutions *(conditional)*
- **`reporting.md`** — Requirements — Reporting and Data *(conditional)*
- **`llm-companion.md`** — Requirements — LLM Companion

---

## `README.md`

Authoring standards for requirements documents — how a requirement is *worded* and how it is
*presented*. Consumed by `/write-brd`, `/write-prd`, `/write-ord`, `/write-reqs`, and `/write-ac`.

```
standards/requirements/
├── README.md      ← this file
├── language.md    ← voice and tone, sentences and word choice, numbers and dates, citing sources, modality, banned constructions
├── tables.md      ← table-first presentation, document structure, reference list, canonical schemas, ID namespaces
├── ai.md          ← conditional: learned or generated behaviour (see trigger test)
├── reporting.md   ← conditional: a measure that is reported (see trigger test)
└── llm-companion.md ← the machine-readable companion /write-brd and /write-ord write beside the document
```

`language.md` and `tables.md` are unconditional — every requirements document obeys both.

`ai.md` and `reporting.md` are **conditional**: each applies on top of the unconditional two, and
neither relaxes either. They are independent — a change can fire both, one, or neither.

| File | Fires when | Adds |
|---|---|---|
| `ai.md` | a delivered component's behaviour is learned or generated rather than specified | the evaluative criterion, `EVL-NNN` / `MDL-NNN`, the ISO/IEC 25059 class map |
| `reporting.md` | the change creates, alters or retires a measure somebody reports | the measure definition, `DAT-NNN`, the ISO/IEC 25012 data-quality anchor |

`llm-companion.md` governs no requirement. It defines the `.llm.md` view `/write-brd` and
`/write-ord` generate from the saved document for a language model to consume — a view that adds,
drops and rewords nothing, and is never the reviewed artefact.

See ADR-0003 for why AI requirements extend the pack rather than forming a fourth document;
`reporting.md` follows the same precedent rather than adding a reporting document.

### Why this lives in `standards/`, not `rules/`

`rules/common/` is the always-applied baseline for **code**. `rules/[lang]/` is activated
per-project via `/lang-rules`. Neither fits: these rules govern **documents**, and they apply
whenever a requirements document is authored regardless of the project's language or whether
any code exists yet.

This ruleset is not auto-loaded. The requirement skills cite it by path, per PRINCIPLE 6
(reference, don't duplicate). It exists so the sibling documents share one definition of a
requirement's form — neither `/write-prd` nor `/write-ord` can own it without the other
drifting, and `/write-reqs` is barred from owning templates.

It cannot sit under `rules/`. Claude Code and VS Code load every file under
`~/.claude/rules/` without `paths:` frontmatter into every session, so a ruleset kept there is
paid for in every session whether or not a requirements document is in play. Neither loads
`~/.claude/standards/`. A path-scoped pointer in `~/.claude/rules/`, named `requirements`, covers
the gap: it loads only when a session reads a document under `docs/brd/`, `docs/prd/`, `docs/ord/`
or `docs/ac/`, and names these files, so a requirements document edited outside a skill still
meets them.

### Scope boundary — read this first

These rules govern **generated document content only**.

They do **not** apply to the skills' own instruction prose. A skill instruction such as
"at least one KPP must be identified" is correct and stays. Applying the language rules to the
skill files themselves would strip the directives that make the skills work.

| Text | Governed? |
|---|---|
| A requirement, criterion, assumption or commitment written into a PRD/ORD/AC document | Yes |
| A skill's instructions to Claude, its rules, its failure-mode table | No |
| Template placeholder text and worked examples inside a template | Yes — examples teach the form |
| Narrative context sections (background, mission, operational scenarios) | Partially — see `language.md` § Narrative sections |

`ai.md` adds one boundary of its own: it governs AI as the **subject** of a requirement. AI as the
**author** of the solution is `ai-first-engineering`, which is not a requirements ruleset and is not
governed here.

### Enforcement

`/check-style` reads `~/.claude/knowledge/company/style-guide.md`, not this ruleset — a company
style guide may add to these rules but never relaxes them. Where the two conflict, the stricter
requirement wins and the conflict is flagged rather than silently resolved.

**One exception: locale.** A company style guide's `Locale` section *replaces* the Australian
defaults in `language.md` § *Locale Conventions* (spelling, dictionary, prose dates, times,
financial year). Replacing them is not a relaxation, so the stricter-wins rule does not apply to
them. With no `Locale` section, or an incomplete one, the Australian defaults stay in force.


---

## `language.md`

> Governs the wording of requirements, acceptance criteria, and commitments in generated
> documents. Read the scope boundary in `README.md` first — these rules do **not**
> apply to skill instruction prose.

### The Principle

**Describe the delivered world as a fact, not the project's intentions about it.**

A requirement states how things *are* once the solution is in place. Written that way it is
either true or false at verification time, and there is no hedge to argue about.

| Instead of | Write |
|---|---|
| The system should respond within 3 seconds | Search results are returned within 3 seconds |
| We will encrypt data in transit | Data in transit is encrypted using TLS 1.3 |
| Users may be notified of despatch | Customer despatch notification is issued within 5 minutes |
| The service shall be available 99.9% of the time | Service availability is 99.9% per calendar month |

### Voice and Tone

Adopted from the Australian Government Style Manual, *Voice and tone*
(stylemanual.gov.au, page updated 21 October 2025). Here, **voice** means who the document speaks
as. That is a different thing from the grammatical active or passive voice covered in
§ *Voice by Altitude* below.

**Voice: the definitive source.** A requirements document uses the Style Manual's basic government
voice. It is respectful, clear and direct, and objective and impartial. A company style guide may
set a house voice on top of this (see `README.md` § *Enforcement*), but it never
replaces it.

**Tone: formal.** The Style Manual puts policies, reports and legal writing in formal tone, and a
document that carries commitments belongs in that group. Formal tone does not excuse unclear
writing: plain language applies at every level of formality.

| Element of tone | In a generated requirements document |
|---|---|
| Word choice | Everyday words. No contractions, metaphor, idiom or slang, and words keep their dictionary meaning. Every acronym and piece of internal shorthand is defined on first use and in the Glossary |
| Viewpoint | Third person and impersonal. No `I`, `we`, `our` or `you`, because a requirements document has many readers and `you` names none of them. Name the party instead, as the "the system" ban already requires for components |
| Grammar | Short sentences, one idea each. § *Voice by Altitude* sets the form for each element |
| Formality | Formal throughout, executive summary included |

**Clear and direct.** Narrative prose uses the active voice with a named actor. An unfavourable
position is stated plainly: an exclusion, a `Won't`, an Adverse outcome or a refused request leads
with the answer, not with the process that produced it.

| Instead of | Write |
|---|---|
| Items not meeting first-round criteria are deemed unsuccessful subject to FMC review | Bulk reassignment is out of scope for this release |
| Unfortunately the legacy platform is a mess and constantly falls over | The current dispatch service had 14 unplanned outages in the 12 months to June 2026 |

**Objective and impartial.** State facts with a benchmark, not opinion. An evaluative adjective or
adverb (`just`, `significantly`, `dramatically`, `unfortunately`, `obviously`, `simply`,
`seamless`, `world-class`) carries a judgement the source did not make. `only` is evaluative when
it judges an amount (`only 15 outages`). It is not evaluative when it limits a scope (`visible only
to the submitting party`), which is a precise restriction and stays. Replace it with the
baseline, the comparison or the source that supports it. A problem statement presents the
evidence and does not assign blame to a team, a vendor or an earlier decision.

**Respectful.** Inclusive language. The document neither talks down to its reader nor addresses
them familiarly.

**Exempt from this section:** verbatim source quotations, such as the text inside
`[TBD — source: "…"]` or a quoted stakeholder statement, which keep the speaker's own words, and
controlled vocabulary such as the MoSCoW value `Won't`.

### Voice by Altitude

Two registers. Applying the wrong one at the wrong level is the most common error.

| Element | Form | Example |
|---|---|---|
| Capability / feature name | **Noun phrase** | `Customer despatch notification` |
| Requirement or story title | **Active, verb-first** | `Notify customer of despatch` |
| "I want" clause | **Active, verb-first**, solution-agnostic | `Notify the customer when despatch occurs` |
| Acceptance criterion | **Noun-first, passive, declarative** | `Despatch notification is issued within 5 minutes of consignment scan` |
| ORD register row | **Active, verb-first** `Requirement Title`; **noun-first, passive** `Business Tolerance` carrying its own value | `Notify customer of despatch` / `Despatch notification is issued within 1 business hour of consignment scan, beyond which the delivery promise is breached` |

Titles command. Criteria state. The criterion form is deliberate: leading with the noun and
using the passive leaves **no grammatical slot for a modal verb**, so the failure this ruleset
exists to prevent becomes hard to write rather than merely discouraged.

### Banned in Generated Requirements

**Modals — never appear in a requirement, criterion, or commitment:**
`could` · `should` · `would` · `may` · `might`

They make the statement unfalsifiable: a criterion that *may* be met cannot fail a test.

**`shall` — permitted but avoided.** It is not ambiguous, but the declarative present is
shorter and reads as a fact rather than an obligation. Prefer the rewrite; do not treat an
existing correct `shall` as a defect.

**Constructions — never:**
`allow me to` · `allows the user to` · `enables` · `is able to` · `can [verb]`

These describe a capability the solution grants rather than an outcome that is true. `can` is
the most common offender and the easiest to miss:

> ✗ `Then they can complete the purchase without re-entering card details`
> ✓ `Purchase completion is available to a returning customer without card re-entry`

**Never write "the system"** — or "the platform", "the application", "the solution". Name the
product, service, or component. Where no name exists yet, use the `[SYSTEM-NAME-TBD]`
placeholder the skill already defines, and resolve it before the document is approved.

### Demand, not design

**Quantify the business tolerance, not the engineering figure that satisfies it.**

A requirement can be fully quantified and testable — as ISO/IEC/IEEE 29148:2018 requires — without
presupposing a design. The discipline is one level down from the rule that a BRD never names a
solution.

| Business demand (belongs in the requirement) | Technical target (the design response, downstream) |
|---|---|
| An agent retrieves a customer's account without the customer noticing a wait | Sub-200ms API response at the 99th percentile |
| Service is restorable within 1 business day; beyond that, obligation X is breached at cost Y | RTO 4h, active-active across two zones |
| No more than 1 working day of transactions is lost in any failure | RPO 1h |
| A field technician completes a job through a 30-minute connectivity gap | Offline cache with conflict resolution on reconnect |

Every left-hand statement is quantified, testable and traceable to a business source — a contract, a
regulatory obligation, an incident cost, a named stakeholder. **None requires an architect to
write.** That is what makes a requirements document producible by a business-side role.

**Where a document states a technical target, it pre-empts the review it exists to inform.** The
figure is asserted rather than derived, and the design review becomes ratification of a number an
analyst chose. Supply the demand; let the design response supply the target.

**This is not a ban on numbers.** A tolerance without a number is a vagueness defect under the next
section. The test is not *is there a figure* but *whose figure is it* — the business's tolerance, or
the engineer's answer to it.

### Vagueness

Unquantified adjectives are not requirements: `fast`, `reliable`, `intuitive`, `robust`,
`scalable`, `secure`, `user-friendly`. Either give a threshold and a measurement method, or
write `[TBD — source: "quoted vague statement"]` and leave the gap visible. Never quantify by
invention.

Quantification alone is **not** sufficient — "The system should respond within 3 seconds" is
quantified and still fails this ruleset. Both the number and the form are required.

### Sentences and Word Choice

Adopted from the Australian Government Style Manual: *Sentences*, *Plain language and word
choice* and *Clear language and writing style*.

**Length.** Sentences average 15 words, and none is longer than 25. This applies to narrative
prose and to every register cell. A longer statement is split into separate sentences or a list,
and a tolerance that needs more is carrying mechanism, which belongs in a cited `BRL-NNN`. An ID
or a cited reference counts as one word.

**Structure.**
- Subject, verb, object, in that order. A modifier goes after the main clause, never inside it.
  Write `Notification is issued within 1 hour of scan`, not `Notification is, within 1 hour of
  scan, issued`.
- Positive statements. State what is true, not what is not, and never use a double negative
  (`not unacceptable`). A prohibition is written as one, plainly.
- Never use `if` and `unless` in the same sentence. Split the conditions, or put them in a
  business rule.
- `other than` goes directly after the term it qualifies, so the exception is unambiguous.
- No `such … as` (`such steps as are appropriate`) and no `being` as a joining word. Use `and`.
- No `there is` or `there are` when they add words but no meaning.
- No more than 3 nouns or adjectives in a row. `Customer despatch notification` is the limit.
  `Customer despatch notification exception reporting` is a noun train, so rewrite it as a clause.

**Verbs over hidden verbs.** Write `decide`, not `make a decision`, and `consider`, not `give
consideration to`. This does not conflict with § *Voice by Altitude*: a criterion starts with a
noun *subject*. What this rule bans is a verb turned into a noun inside the sentence.

**Cut unnecessary words.** Each word has a job. Adverbs and adjectives go first. Then check that
the sentence still means the same and is still grammatical.

**Everyday words.** Use the plain alternative unless a term is defined in the Glossary or taken
from a standard this ruleset cites (ISO/IEC/IEEE 24765, ISO/IEC 25010). A defined term keeps its
defined form: `impact` names an `IMP-NNN` row and stays.

| Instead of | Write |
|---|---|
| in order to | to |
| prior to / subsequent to | before / after |
| commence / cease | start / stop |
| utilise | use |
| in the event that | if |
| due to the fact that / as a consequence of | because |
| in relation to / with regard to / in respect of | about |
| pursuant to | under |
| until such time as | until |
| ascertain | find out |
| approximately | about |
| a number of | the number itself, or `some` |
| at a later date | the date, or the timeframe |
| leverage | use, build on |
| deliver / drive (an outcome) | the actual verb: `reduce`, `increase`, `replace` |
| impact (verb) | affect |
| require (verb) | state the end state that is needed |

**Shortened forms.**
- Write the full term first, with the acronym in brackets after it: `Network Operations Centre
  (NOC)`. A shortened form that is better known than its full form goes first, with the expansion
  after it.
- Every acronym goes in the Glossary. A register row is read on its own, so an acronym in a row
  is also defined in the Glossary, not only in an earlier paragraph.
- A term used only once or twice is written in full and not shortened.
- No plural or possessive form at the point of definition, and no full stops inside or after an
  acronym.

**Reading level.** The executive summary and the narrative sections aim for a lower-secondary
reading level (WCAG 2.2 success criterion 3.1.5). Specialist content is supported with the
Glossary and a short summary in plain terms. It is never written down to.

### Numbers, Dates and Units

Adopted from the Style Manual, *Grammar, punctuation and conventions* § *Numbers and
measurements*.

**Numerals.**
- In prose, numbers from 2 up are numerals, and `zero` and `one` are words.
- **Every number in a register cell is a numeral**, `0` and `1` included. So is every number with
  a unit, every comparison, decimal, percentage, date, time and series. A tolerance is a
  measurement, so `1 business hour` and `4 business days` are correct.
- Never start a sentence with a numeral. Reword it: `Rates made up 55% of revenue`, not `55% of
  revenue came from rates`.
- Numbers of 4 or more digits use commas, never spaces: `2,500`. Large rounded numbers use a
  numeral and a word: `2.5 million`, `$50 million`.

**Percentages.** A numeral with no space before `%`: `99.5%`. Use decimals, not fractions. Write
the noun as `percentage`, and `per cent` as 2 words. **Never describe a change as a percentage
alone.** State the baseline and the new value, as the BRD objective schema already requires. A
percentage can sit next to them but never replaces them.

**Dates and times in prose** (locale default, see § *Locale Conventions*).
- Day, month, year, with no comma or ordinal: `15 October 2026`, `Thursday 15 October 2026`.
- Spans: `from 3 to 21 December`. Financial years use an en dash: `the 2026–27 financial year`.
- Times use a colon and a lower-case `am`/`pm`: `9:30 am`, `2 pm`. Use `noon` and `midnight`,
  never `12 am` or `12 pm`. The 24-hour clock is used where the operation already runs on it.
- A tolerance that depends on a time zone names it.

**Dates in register cells** use `yyyy-mm-dd` (see § *Recorded Deviations from the Australian
Government Style Manual*).

**Units.** Numerals with the SI symbol and a non-breaking space: `30 km`, `500 kg`. A symbol the
reader may not know is spelt out at first use, with the symbol in brackets after it. Symbols take
no full stop and no plural form.

### Punctuation, Capitalisation and Spelling

Adopted from the Style Manual, *Grammar, punctuation and conventions* § *Punctuation* and
§ *Spelling*.

**Minimal punctuation.**
- No full stop at the end of a heading, a caption or a list item that is not a full sentence.
- No semicolons at the end of list items.
- One space after a full stop, never two.
- A sentence that needs a lot of punctuation is too long. Split it.

**Capitals.** Sentence case in all free text. Capitals go on proper nouns only. A role or position
named in prose is lower case (`the regulatory reporting manager`) unless it is a title the
organisation sets in legislation or policy. Fixed labels keep their form (see deviations below).

**Spelling** (locale default, see § *Locale Conventions*). Australian English, from one Australian
dictionary used consistently: the Macquarie Dictionary, unless the company style guide names the
Australian Oxford. Where a word has more than one spelling, use the first one listed. `-ise`
endings, `per cent`, and `judgement` (but `judgment` in legal material).

### Locale Conventions

**The Australian locale is on by default.** The rules marked *locale default* above are the only
ones in this file that depend on where the document is written and read:

| Convention | Australian default |
|---|---|
| Spelling and dictionary | Australian English, Macquarie Dictionary, first listed spelling |
| Dates in prose | `15 October 2026`, with no comma or ordinal |
| Times | `9:30 am`, `2 pm`, `noon`, `midnight` |
| Financial year | `2026–27`, running 1 July to 30 June |
| Percentage in words | `per cent` |

**Before drafting, read `~/.claude/knowledge/company/style-guide.md`.** If the file is missing,
is a placeholder or has no `Locale` section, the Australian defaults apply and nothing is
reported.

**A company style guide can replace this whole table.** It does so with a `Locale` section that
states a value for every row, for example US English with Merriam-Webster and `October 15, 2026`.
A partial `Locale` section replaces nothing: the rows it leaves out would fall back to Australian
values and the document would mix 2 conventions. A partial section is reported as a finding and
the Australian defaults stay in force.

**Nothing else in this file is a locale rule.** Plain language, sentence length, numerals,
objective tone, acronym handling and every deviation apply whatever the locale. A `Locale`
section that tries to change them is a relaxation, and § *Enforcement* in `README.md`
refuses it.

Register cells date as `yyyy-mm-dd` in every locale.

### Citing Sources

Adopted from the Australian Government Style Manual, *Referencing and attribution*
(stylemanual.gov.au). Every source a document relies on is cited in a form a reader can find, and
every citation resolves to a row in the reference list (`tables.md` § *Reference list*).

**The system is author–date.** The Style Manual prefers it to footnotes for accessibility, and it
survives the move into tables and the `.llm.md` companion. No footnotes or endnotes are used.

| Source | In text and in `Source` cells | Notes |
|---|---|---|
| Act of parliament | *Privacy Act 1988* (Cth) at first mention, then Privacy Act | Title case, with the year and the jurisdiction. Italic at first mention only |
| Pinpoint in an Act | Privacy Act s 6, subs 6(1), para 6(1)(a), Pt 3, Sch 1 | No full stops. In running prose, write `section 6` in full |
| Delegated legislation or a code | The same pattern as an Act | Use the authorised title from the jurisdiction's legislation register |
| Standard | ISO/IEC 25010:2023 | The designation and year. Cite the AS or AS/NZS adoption where one exists (`ai.md` § *Standards of record*) |
| Contract or agreement | Retail service agreement cl 14 | `cl` for a clause and `Sch` for a schedule, from the contract's own numbering |
| Report, webpage or dataset | (Acme Communications 2026) | Author and year with no comma. `n.d.` with no date, and `et al.` for 3 or more authors |
| Internal record | Incident record INC-2291 | The record's own identifier, so the owning system can find it |

**First mention, then the short form.** An Act takes its full short title in italics at first
mention, and the short form after that. A shortened form that does more than drop the year goes
in brackets at first mention: *Work Health and Safety Act 2011* (Cth) (WHS Act). The `Cited as`
column of the reference list holds the short form.

**Shortened forms.** `s`, `ss`, `subs`, `para`, `cl`, `Pt`, `Div`, `Sch`, `p` and `pp` take no full
stop. `n.d.` and `et al.` keep theirs. Never use `ibid.`, `op. cit.`, `loc. cit.` or `id.`: repeat
the short form instead.

**Quote exactly.** A quoted source keeps its own words, spelling and acronyms. An unexplained
acronym in a quote gets its expansion in square brackets.

### Narrative Sections

Background, mission context, operational scenarios and day-in-the-life narratives are prose by
design and are exempt from the noun-first criterion form. They remain subject to the modal ban
and the "the system" ban, and they must never introduce a commitment that does not also appear
as a row (see `tables.md`).

### Recorded Deviations from ISO/IEC/IEEE 29148:2018

`/write-prd` cites 29148. This ruleset deviates from it twice, deliberately:

1. **Declarative present is preferred over `shall`.** 29148 makes `shall` the canonical binding
   verb. We prefer the end-state form because it is shorter and verifiable as a statement of
   fact. `shall` remains valid, so this is a preference, not a conflict.

   **The same deviation applies to the INCOSE *Guide to Writing Requirements*,** which is more
   prescriptive than the ISO text on this point and is the practitioner authority most likely to be
   cited against a document authored under these rules. Recording the deviation once, against both
   sources, is deliberate: a deviation noted against 29148 alone silently extends to INCOSE, which
   is how a documented choice becomes an apparent defect in review.
2. **Passive voice is mandated for acceptance criteria.** 29148 recommends active voice on the
   grounds that passive hides the actor. Accepted and mitigated: where the actor is
   load-bearing — authorisation, non-repudiation, audit, and anything in ORD §7.3 Security —
   name the actor explicitly and use the active voice. Elsewhere the passive is what makes
   noun-first possible once "the system" is banned.

Neither deviation is silent: any document claiming 29148 conformance cites this file.

### Recorded Deviations from the Australian Government Style Manual

The Style Manual is written for content that tells a reader what to do. A requirements document
states what is true once a change is delivered, and it is verified against that statement. Four
deviations follow from the difference. Each is deliberate:

1. **Passive voice in acceptance criteria and Business Tolerance cells.** The Style Manual's own
   counter-example, `Applications are assessed within 30 days`, is the exact form this ruleset
   requires of a criterion. It names no actor because the actor belongs to the design response,
   not the demand. The mitigation is the one in the 29148 deviation 2: where the actor is
   load-bearing, name it and use the active voice. Titles and narrative prose use the active voice,
   as the Style Manual says.
2. **No second person.** The Style Manual recommends `we` and `you` where they suit the voice and
   tone. Its tone guidance puts reports and policies in formal tone, which uses the third person,
   and a requirements document is one of those.
3. **Fixed labels keep title case.** Section headings, column names, controlled values (`Sunny
   Day`, `Must`, `Provisional`) and role names in `Owner` cells are labels that reviewers, other
   skills and tooling match on exactly. They keep the form their schema gives them. Sentence case
   applies to all other text.
4. **Register cells date as `yyyy-mm-dd`.** The Style Manual uses `15/10/2026` in tables. Register
   dates are sorted, compared and read outside Australia, and the Style Manual accepts
   international standards for data. Prose uses `15 October 2026`.

**Not aligned to ASD-STE100.** Simplified Technical English mandates active voice and the
imperative, and governs technical *documentation* (procedures, manuals), not requirements.
Downstream operational artefacts — runbooks, operator and field procedures — may adopt STE
independently; requirements documents do not.

### Never

- Never use `could`, `should`, `would`, `may`, or `might` in a requirement, criterion, or commitment.
- Never state a technical target where a business tolerance belongs — no RTO, RPO, latency figure,
  availability percentage, instance count or protocol choice in a demand-side requirement.
- Never coin a term where ISO/IEC/IEEE 24765 (systems and software vocabulary) or, for AI,
  ISO/IEC 22989:2022 supplies one. Record the adopted term in the project glossary.
- Never write `enables`, `is able to`, `allows … to`, or `can [verb]` in a criterion.
- Never refer to "the system", "the platform", "the application", or "the solution".
- Never treat quantification as sufficient — a hedged number is still a hedge.
- Never invent a threshold to avoid writing `[TBD]`.
- Never use a contraction, metaphor, idiom or slang in a generated document, except as controlled
  vocabulary or inside a verbatim quotation.
- Never write in the first or second person (`I`, `we`, `our`, `you`) outside a verbatim quotation.
- Never use an evaluative adjective or adverb that has no benchmark, and never assign blame in a
  problem statement.
- Never use an acronym or internal shorthand that is not defined on first use.
- Never bury an unfavourable position under the process that produced it.
- Never write a sentence longer than 25 words, in prose or in a register cell.
- Never use a double negative, or `if` and `unless` in the same sentence.
- Never string more than 3 nouns or adjectives together.
- Never write a number in a register cell as a word, and never start a sentence with a numeral.
- Never describe a change as a percentage alone. State the baseline and the new value.
- Never mix spellings or date formats. Use the active locale, which is Australian unless a
  complete company `Locale` section replaces it.
- Never cite a source in a form the reference list does not hold, and never use a footnote.
- Never use `ibid.`, `op. cit.`, `loc. cit.` or `id.`.
- Never apply these rules to the skills' own instruction prose (see `README.md`).


---

## `tables.md`

> Governs how requirements are *presented* in generated documents. Pairs with
> `language.md`, which governs how they are worded.

### The Rule

**Every binding statement is a row in a table with a stable ID. Prose carries narrative only.**

A statement is **binding** if someone could later be held to it. The test: *could this be
cited in a review, an audit, an SLA dispute, or an acceptance test?* If yes, it is a row.

This is deliberately narrower than "tabularise everything". Prose sections earn their place and
are made worse by tabulation — background, mission context, system overview, and day-in-the-life
operational scenarios stay as prose. What they must never do is introduce a commitment that does
not also appear as a row somewhere.

### Canonical Schemas

Use these exactly. A document that invents a column set drifts from its sibling, which is the
failure this file exists to prevent.

#### Requirement register — the demand-side ORD

Every operational requirement, in every section. The subsection heading supplies the ISO/IEC 25010
characteristic, so there is no characteristic column.

| ORD# | Ver | Requirement Title | Business Tolerance | KPP | MoSCoW | Status | Owner | Source |
|---|---|---|---|---|---|---|---|---|
| ORD-NNN | 1.0 | [active, verb-first] | [declarative end state, carrying its own quantified value] | [KPP] or blank | Must | Committed | [named business owner] | [contract, obligation, incident record, or BU/Function/Name] |

**Column-name equivalence.** The requirements-documents pack writes the first column `Ref` and uses
sentence case (`Requirement title`, `Business tolerance`). They are the same columns; `ORD#` is used
here for consistency with `PRD#` and `BRD#` elsewhere in this file. `MoSCoW` is an extension the
pack does not require — see below.

**The register states business demand, never the technical target that satisfies it.** *"Service is
restorable within one business day, beyond which obligation X is breached"* is a requirement;
*"RTO 4h"* is the design response to it. See `language.md` § *Demand, not design*.

- **`Requirement Title` is active and verb-first** — `Restore service within one business day` —
  while `Business Tolerance` is noun-first and passive. That split is the existing rule in
  `language.md` § *Voice by Altitude*, applied at one altitude: titles command,
  criteria state. It is not a summary of the tolerance and never carries a value of its own.
- **`Business Tolerance` is written at executive altitude.** The test: *could an executive
  understand it without understanding reporting, governance, architecture or implementation?* If
  not, it states the outcome and the breach consequence, and the detail moves to a `BRL-NNN` rule
  (§13) or a §14 reporting definition the row cites — *"published results are auditable and
  reproducible"*, not *"each included, excluded and exception record retains a stable identifier
  linking …"*. Moving detail never drops it.
- **`Business Tolerance` carries its own quantified value.** No separate threshold column — under
  `language.md` the requirement is a declarative end state, so the number is part of
  the sentence. Prefix **[AI]** where `ai.md` governs the row.
- **`KPP` is a column, not a prefix.** A KPP carries **threshold** (minimum acceptable) and
  **objective** (desired) as two labelled values inside `Business Tolerance`; collapsing them to one
  figure is how KPP intent is lost downstream. `[AI]` remains a prefix — it records which ruleset
  governs the row's form, which is not a property a column should imply is severity.
- **`Status` is `Committed` / `Provisional` / `Assumed`** — the maturity of the demand statement, not
  of a technical threshold. An `Assumed` row without a named owner and a confirm-by date in the
  assumption register is an invented number, not an assumption.
- **`Owner` is the named business owner of the tolerance.** Not the delivery team and not the
  operating team — both are response-side and neither is knowable at ORD time.
- **`Ver` is the requirement's own version**, not the document's. It rises when the tolerance
  changes after first issue, and it is what makes inline provenance work: a proposed acceptance
  criterion carries `[ORD-003 · v1.0 · Provisional · owner: … · confirm by …]` so the criterion's
  standing travels with it to whoever writes the Capability AC. Without it a downstream reader
  cannot tell an agreed tolerance from a revised one.
- **Traceability is not a register column.** The up-link — the `OBJ-NNN` objective and the BRD
  objective it serves via its business requirement — lives once, in §11 Traceability. Carrying it in both
  places is the restatement the § *View Tables* rule forbids. A row tracing only as far as a `BR-N`
  has no funded outcome behind it, which is what §11's `via` makes visible.
- **`Source` is the evidence, not the speaker alone.** A contract clause, a regulatory obligation, an
  incident record or an `ASM-NNN`. Where the only source is a stakeholder, name Business Unit,
  Function and Name.
- **There is no `Verification` column.** The measurement *population* belongs inside the tolerance
  sentence; the *instrument* that measures it is the design response, recorded at §17 when
  the SOAP is issued. A demand-side ORD that names its own instrument has pre-empted the review it
  exists to inform.

**MoSCoW, `KPP` and `Status` are three orthogonal axes and all three are kept.** A KPP is a
business-failure threshold; a Must is required for this release; a Status is how well evidenced the
statement is. Most KPPs are Musts; most Musts are not KPPs; a KPP may sit at any status, and one at
`Assumed` is the single item that warrants escalation.

**`Should` and `Could` as MoSCoW values are not a `language.md` violation.** That rule bans hedging
verbs inside requirement *text*; a controlled enum in a priority column is unambiguous. Do not
"correct" it. **MoSCoW is DSDM, and KPP is US DoD JCIDS** — neither is ISO-backed. Both are retained
as house convention; neither is cited as a standards obligation.

#### Prioritisation and status definitions

**Emitted verbatim into every ORD at §5.2**, so a reader meets the three axes defined before meeting
the register. In the ORD the table is headed as a **view** of this section, so the LLM companion
omits it — the companion's own Vocabulary already carries these definitions. Never reworded per document — the definitions are what make one ORD's `Must` mean the
same as another's.

| Column | Value | Definition | Assigned by |
|---|---|---|---|
| MoSCoW | **Must** | Required for this release. The release is not accepted without it. | Product Manager |
| MoSCoW | **Should** | Important and of significant value. The release is accepted without it. | Product Manager |
| MoSCoW | **Could** | Desirable. Delivered where capacity allows. | Product Manager |
| MoSCoW | **Won't (this release)** | Raised, recorded and deliberately deferred. It stays in the register for a later release and carries no acceptance criterion. | Product Manager |
| KPP | **[KPP]** | A business-failure threshold: failure means the capability is unfit for purpose, not merely degraded. Carries a threshold (minimum acceptable) and an objective (desired). Independent of MoSCoW — most KPPs are Musts, most Musts are not KPPs. | Business owner, at the Phase 1 gate |
| Status | **Committed** | The business owner has stated and agreed the tolerance, and it traces to an obligation, contract, incident record or business decision. | Evidence |
| Status | **Provisional** | The tolerance derives from a real source — an SLA, contract, incident history, analogous service — not yet confirmed by the owner for this change. | Evidence |
| Status | **Assumed** | No owner confirmation and no documentary source; rests on an `ASM-NNN` with a named owner and a confirm-by date. | Evidence |
| Rule status | **Confirmed** | The rule owner has agreed the business rule as written in §13. | Rule owner |
| Rule status | **Provisional** | A source states the rule, but its owner has not confirmed it for this change. The same word as the requirement status, applied to a rule. | Evidence |
| Rule status | **Unresolved** | The rule is not decided. `Rule` carries a `[TBD]`, and the row cites the decision item that settles it. | Evidence |

**`Won't` is not out of scope.** A `Won't` item is in this document's scope and deferred; an
out-of-scope item is never delivered by this document (ORD §4.2). **An item removed from scope after
agreement is descoped, and descoping is a scope change, not a priority** — it is recorded as a §4.2
exclusion with a §18 change-history entry stating when, by whom and why, never as a `Won't`.

**Delivery Agent, Operational Owner, Timing and Verification are deliberately absent.** Each names
something the demand side does not know and cannot commit: who will build it, who will run it, when
it will be scheduled, and what instrument will prove it. Timing lives at the objective
(`OBJ-NNN` § *Target Date*), which the requirement inherits through §11. Traceability and the
written-back downstream links both live in §11 Traceability, not in the register.

**`MoSCoW` is an extension to the demand-side standard.** The standard does not require it; these
rules keep it because `/write-ac` gates AC altitude on it. It is business prioritisation, so it sits
on the demand side legitimately — but an ORD authored to the pack alone carrying no `MoSCoW` column
is conforming, not defective.

#### Operational objective

The outcome layer between a BRD objective and an operational requirement. Every register row traces
to one.

| ID | Objective | Baseline | Target | Target Date | Traces to |
|---|---|---|---|---|---|
| OBJ-NNN | [operational outcome, never the solution] | [current measurable position] | [required outcome] | [date or milestone] | [BO-N via BR-N] · [ORD-NNN, …] |

`Baseline`, `Target` and `Target Date` are measures under ISO/IEC 25022 / 25023. Where any of the
three is unavailable, write `[TBD — source: "quoted vague statement"]` and leave the gap visible.
**Never invent a baseline** — an objective whose baseline is guessed cannot show improvement.

#### Scenario

Requirement-level scenarios and the consolidated scenario catalogue are **one table**, keyed by
`ORD#`. Building a second catalogue would restate every row.

| ID | ORD# | Scenario | Outcome | Condition | Expected end state |
|---|---|---|---|---|---|
| SCN-NNN | ORD-NNN | Sunny Day | Favourable | [in-distribution, everything available] | [declarative end state] |
| SCN-NNN | ORD-NNN | Sunny Day | Adverse | [processing succeeds, result is unfavourable] | [declarative end state] |
| SCN-NNN | ORD-NNN | Rainy Day | — | [dependency down, data unavailable, retrieval failed] | [declarative end state] |
| SCN-NNN | ORD-NNN | Edge Case | — | [empty, maximum, expired, first, last] | [declarative end state] |

**`Scenario` and `Outcome` are two axes, not one.** `Scenario` is the condition the *capability* is
put through — the three values in this file, unchanged. `Outcome` is whether the *subject being
measured* passes or fails, and it applies only on a Sunny Day: a determination that runs correctly
and returns bad news is not a capability failure. That is why a fourth `Scenario` value was not
added — it would conflate the two axes.

- **`Outcome` is `Favourable` / `Adverse`, and `—` where the axis does not apply.** A Rainy Day has
  no outcome because nothing was determined.
- **A determination, measurement or eligibility requirement carrying only a Favourable Sunny Day row
  is incomplete.** What must be true when the answer is unfavourable is a separate obligation, and
  it is the one most often left unstated.
- Each row stays a declarative statement under `language.md`. A Rainy Day row states
  what *is* true when the dependency fails, never what might happen.
- A story or requirement whose scenarios are all `Sunny Day` has been specified for the demo, not
  for production.

#### Business rule

**The ORD states what must happen; the business rule register states how decisions are made.**
Every ORD carries the register at §13, grouped into three, whether or not a functional requirements
document follows — a requirement that embeds its classification, cut-off or reconciliation logic has
been written at the wrong altitude, and the register is where that detail goes instead. Where a PRD
in the chain already states a rule, the row cites the PRD criterion (`PRD-NNN.N`) and restates
nothing — the PRD states rules as criteria and never mints `BRL-NNN`.

| ID | Group | Rule Type | Required Decision | Rule | Status | Owner | Effective Date | Affects |
|---|---|---|---|---|---|---|---|---|
| BRL-NNN | Classification / Reporting / Governance | [from the group's types below] | [what must be determined] | [the rule as the business states it, or `[TBD — source: "…"]` while unresolved] | Confirmed / Provisional / Unresolved | [named, or TBD with confirm-by] | [where supplied] | [ORD-NNN, …] |

| Group | Rule types |
|---|---|
| **Classification** | Inclusion · Exclusion · Cohort assignment · Eligibility |
| **Reporting** | Reporting period · Cut-off · Late-arriving data · Calculation · Restatement |
| **Governance** | Reconciliation · Exception handling · Evidence retention · Rule versioning |

- **`Owner`, `Status` and `Affects` are mandatory on every row** — a rule with no affected
  requirement governs nothing, and one with no owner has nobody to change it.
- **Business rules are functional content carried by the ORD by design.** State that in the §13
  lead so a reviewer reading against a scope that excludes them sees a declaration, not an absorption.

- **`Required Decision` and `Rule` are OMG DMN's two levels, kept in two columns.** The decision
  is what must be determined — *whether a complaint counts in the measure*. The rule is the decision
  logic in the business's own words — *a complaint withdrawn by the customer is excluded*. The ORD
  carries both: the executive-altitude test moves this logic out of the requirement, and this column
  is where it lands.
- **`Rule` is business policy, never implementation design.** No query, field name, system
  behaviour, decision-table encoding or algorithm — those are how the delivered solution applies the
  rule, and belong to the design response. The test: a business owner reads it and agrees or
  disagrees without asking how it is built.
- **An `Unresolved` row carries `[TBD — source: "…"]` in `Rule`**, never a drafted answer. Where two
  documented positions compete, both go in the decision item the row cites, not in `Rule`.
- An `Unresolved` rule affecting a KPP-bearing requirement is raised via `/raid add decision`.

#### Decision

Every unresolved business decision is a first-class row — never an assumption embedded in a
requirement. ORD §8.1.

| ID | Decision required | Affects | Options | Owner | Required by | Status | Resolution |
|---|---|---|---|---|---|---|---|
| D-NNN | [what must be decided] | [ORD-NNN, BRL-NNN, …] | [the documented positions] | [named] | [date] | Open / Resolved / Superseded | [the decision taken, by whom and when — blank only while Open] |

`/raid` owns `D-NNN`. Where no RAID log exists, the ID cell carries a **numbered placeholder** —
`[D-TBD-1]`, `[D-TBD-2]`, flat and sequential in order of first appearance — and the row is kept.
The number is what lets a `BRL-NNN` or `ORD-NNN` row cite *which* open decision governs it; it is
local to the document and is replaced, everywhere it is cited, when `/raid` mints the real ID.
A `Resolved` row is kept, not deleted — the resolution is the record the affected requirements
were changed against.

#### Related initiative

Adjacent work this document neither depends on nor delivers. ORD §10.2. **No ID — the initiative
name is the key**, on the operational-actor reasoning: it identifies, and commits nothing.

| Initiative | Relationship | Owner | Routed items | Status |
|---|---|---|---|---|
| [named programme, project or change] | Overlaps / Feeds / Consumes / Supersedes | [named] | [REF-NNN, …, or —] | [as reported by its owner] |

**Four registers, four tests — never one table:**

| It is a… | When |
|---|---|
| **Dependency** (`DEP-NNN`) | This document's outcome cannot be delivered until it is |
| **Related initiative** | It touches the same scope, but this document's outcome does not wait for it |
| **Referred requirement** (`REF-NNN`) | Content raised here that another owner delivers |
| **Out-of-scope item** (§4.2, `IMP.Treatment`) | Deliberately excluded, and delivered by nobody as a result of this document |

#### Impact register

What the change touches and who owns it. Identification and accountability — never target state.

| ID | Impact | Kind | Treatment | Owner | Referred |
|---|---|---|---|---|---|
| IMP-NNN | [named L4 workflow or system in the current estate] | Process / System | Addressed / No change required / Out of scope | [named owner] | [REF-NNN or —] |

Naming the as-is estate is identification; naming the to-be estate is design. A row says what is
touched, who owns it, and whether **this document** addresses it — and says nothing about what
becomes of it. **Where tier numbers are cited, name the scheme they belong to** — an unqualified
"L4" resolves differently in APQC, eTOM and a house scheme.

**`Treatment` is a scope disposition, and the enum is closed.** Three values, no others:

| Value | Means |
|---|---|
| `Addressed` | This document carries requirements for the impact |
| `No change required` | The impact was identified and assessed as needing nothing |
| `Out of scope` | Identified, and deliberately excluded from this document |

**A design disposition is not a treatment.** *Migrated*, *decommissioned*, *extended*, *replaced*,
*rebuilt* — each names what becomes of the impact, which is the response's answer and not the
demand's. A row carrying one has crossed the line this register exists to hold.

**`Referred` is the pointer, `Treatment` is the disposition, and neither substitutes for the
other.** A referred impact still carries a treatment — usually `Out of scope`, because referral is
what happens *after* this document excludes it. Reading a populated `Referred` cell as a treatment
loses the distinction between an exclusion that went somewhere and one that did not.

**Where a document states an exclusion for a named impact, this cell is the authoritative value**
and any prose scope statement is a view of it. Prose keeps the exclusions that are not impacts —
populations, geographies, timeframes — which have no row to be authoritative in.

`Treatment` is additive. A register predating it reads `[TBD]` in that cell and is not retrofitted;
the value is written when the document is next reissued.

#### Operational actor

Who and what the operational process runs through. **Identification, like the impact register** —
never authority the source did not state, and never a target operating model.

| Actor | Kind | Operational role | Owner |
|---|---|---|---|
| [named person-role, system or organisation] | User / System / Party | [what it does in the operational process] | [named owner, or TBD with confirm-by] |

- **`Kind` is `User` / `System` / `Party`.** `Party` is an external organisation — a retail service
  provider, a contractor, a regulator. Without it a cross-party consequence has no subject to name,
  and cross-party consequence is the class most often left derived and unconfirmed.
- **This table carries no ID, and that is deliberate.** The actor name is the key. An actor row
  identifies a subject; it commits nothing, so nothing traces *to* it — which is the test the
  § *Statements that carry no ID* rule applies, and this row sits outside that list rather than
  extending it. A prefix here would buy reference precision and cost a namespace every sibling
  skill must avoid colliding with.
- **Governance roles are not actors.** The SME who informed the document, the business owner who
  approves it and the convenor who wrote it belong in the document header and the entry-position
  record. A table mixing *the billing platform* with *the SME who reviewed this* serves neither
  purpose.
- **Notification is a view, not a column.** Who is told what, and when, cites the requirement rows
  that carry it.
- `Owner` accepts `[TBD]` with a confirm-by date. Where no stakeholder list arrives at assignment,
  a `[TBD]` per actor is what makes the absence countable; one entry-position row is not.

#### Referred requirement

Content raised during elicitation that this document will not deliver. No row is classified against
a 25010 characteristic and no row becomes a requirement of this document.

| ID | Requirement | Raised by | Kind | Related impact | Resolver group | Referred to | Date | Status |
|---|---|---|---|---|---|---|---|---|
| REF-NNN | [what was raised] | [name] | Functional / Wrong resolver / Out of scope | [IMP-NNN] | [group, or **None in chain**] | [named recipient] | [date] | Referred / Accepted / **Referred, not accepted** |

An omitted requirement is indistinguishable from one nobody had; a referred requirement with a named
recipient is a handoff. **`Resolver group: None in chain` is a real answer** and the row stays open —
it is the visible form of a gap in the delivery chain, not a defect in the document.

#### PRD story criteria

A PRD story is deliberately narrative — "As a … I want … so that …" carries intent and the business
outcome, which a register row cannot. Its **acceptance criteria** are rows:

| ID | Acceptance Criterion | Scenario |
|---|---|---|
| PRD-NNN.N | [declarative statement of what is true once delivered] | Sunny Day / Rainy Day / Edge Case |

- Criterion IDs are `PRD-NNN.N` within their story, so `/write-ac` maps each `AC-NNN` to a precise
  criterion rather than a whole story.
- A criterion over learned or generated behaviour is prefixed **[AI]** in the `Acceptance Criterion`
  cell and follows `ai.md` as well as this file.
- The story carries a `MoSCoW` priority; `/write-ac` gates altitude on it exactly as it does for
  ORD register rows.
- **`Scenario` names the weather the requirement is being put through**, not a category of criterion.
  The three values are the same requirement examined under three conditions, which is why the column
  is `Scenario` and not `Type` — a reader who sees `Type` asks what kind of criterion this is, and
  the answer is always "an acceptance criterion".

| Value | The requirement under | Answers |
|---|---|---|
| **Sunny Day** | Everything available and behaving | What is true when it works |
| **Rainy Day** | Something failing — dependency down, timeout, refusal | What is true when it breaks |
| **Edge Case** | A valid but boundary condition — empty, maximum, expired, first, last | What is true at the limits |

- `Scenario` makes the Sunny-Day-only coverage warning mechanically checkable: a story whose criteria
  are all `Sunny Day` has been specified for the demo, not for production.
- **These are labels for the condition, not a licence to hedge.** Each row stays a declarative
  statement under `language.md` — a Rainy Day criterion states what *is* true when the
  dependency fails, never what *might* happen.
- **A determination or eligibility story carries two Sunny Day criteria** — one where the answer is
  favourable and one where it is adverse. The capability succeeding and returning bad news is not a
  Rainy Day, and stating only the favourable case leaves the larger obligation unwritten. See
  § *Scenario* above for the `Outcome` axis; a PRD story may carry the column or say it in the
  criterion, but it states both cases either way.

#### Reference list

One table holds every source the document cites: the ORD's §4.5, the BRD's Appendix B and the
PRD's § *References*. The citation forms are in `language.md` § *Citing Sources*.

| Cited as | Full citation | Type |
|---|---|---|
| Privacy Act | Privacy Act 1988 (Cth) | Legislation |
| ISO/IEC 25010:2023 | ISO/IEC (2023) *ISO/IEC 25010:2023 Systems and software engineering — Systems and software Quality Requirements and Evaluation (SQuaRE) — Product quality model*, International Organization for Standardization, Geneva | Standard |
| Retail service agreement | Acme Communications and Retailer Pty Ltd (2025) *Retail service agreement*, version 4.2, unpublished | Contract |
| Acme Communications (2026) | Acme Communications (2026) *Missed appointment rebate review*, unpublished internal report | Report |

- **`Cited as` is the exact form used in `Source` cells and in prose.** A reader who finds the
  short form anywhere in the document finds it in this column.
- **Every cited source has a row, and every row is cited.** A source with no row is an
  untraceable claim. A row that nothing cites is padding.
- Rows are in alphabetical order of `Cited as`. `Type` is one of `Legislation`, `Standard`,
  `Contract`, `Report`, `Webpage`, `Dataset` or `Internal record`.
- `Full citation` follows the Style Manual's author–date form for its type. Act titles are roman
  in this table, although they are italic at first mention in text. A source with no date
  takes `n.d.`, and a webpage carries its accessed date.
- **A document that cites no source says so** with a single row: `None cited`. A list left out
  hides whether anything was cited.
- `ASM-NNN`, `D-NNN` and other register IDs are not listed. They already resolve inside the
  document or the RAID log.

#### Statements that carry no ID

Two kinds of binding row are deliberately ID-less, because nothing ever traces *to* them:

- **Exclusions** (PRD § Out of Scope) — cited in scope disputes, never referenced by another row.
- **Coverage gaps** (ORD § 7.10) — a record of absence; the ID would belong to a requirement that
  does not exist.

Everything else that binds carries an ID. Do not extend this list to avoid assigning one.

#### Interface detail

Per-interface technical attributes, keyed to a register row by `ORD#`. Specification, not
commitment — the binding statement is the register row, so this carries no priority or timing.

| ORD# | Integrated System | Interface Type | Protocol | Data Exchanged | Direction | Failure Behavior |
|---|---|---|---|---|---|---|

#### Assumption

Carries forward the table `/idea` already produces, so an assumption tracked at idea stage keeps
its identity and lifecycle into the requirements documents rather than collapsing back to prose.

| ID | Assumption | Status | If false | Owner | Confirm by |
|---|---|---|---|---|---|
| ASM-NNN | [declarative statement] | Unvalidated / Validated / Falsified | [consequence] | [named role] | [date] |

`If false` is mandatory — an assumption with no stated consequence is a note, not an assumption.

**`Owner` and `Confirm by` are mandatory wherever a register row cites the assumption as its
`Source`.** A requirement at `Status: Assumed` resting on an assumption with no named owner and no
date is an invented number, and it is the largest audit exposure a requirements document carries.
ISO/IEC/IEEE 29148:2018 requires traceability, not finality: a TBD with an owner and a date
conforms; a silent gap does not.

**Escalation:** The RAID log is Risks, Actions, Issues, Decisions — it has **no Assumptions
quadrant**. A falsified assumption therefore has no home in RAID and must be raised as a risk:
set `Status: Falsified`, run `/raid add risk`, and record the `R-NNN` in the `If false` cell.

#### Dependency

| ID | Depends on | Type | Owner | Needed by | Status |
|---|---|---|---|---|---|
| DEP-NNN | [named system, team, or deliverable] | Internal / External / Vendor | [role] | [date or milestone] | Open / Met / At risk |

### ID Namespaces

Authorised prefixes. See ADR-0001 for the requirement prefixes and their extension.

| Prefix | Owns | Assigned by |
|---|---|---|
| `BO-N` | Business objectives | `/write-brd` |
| `BR-N` | Business requirements | `/write-brd` |
| `PRD-NNN` | Functional requirements / user stories | `/write-prd` |
| `CON-NNN` | Solution constraints — demand-side givens (regulatory, contractual, mandated integration) | `/write-prd` |
| `ORD-NNN` | Operational requirements | `/write-ord` |
| `AC-NNN` | Acceptance criteria | `/write-ac` |
| `OBJ-NNN` | Operational objectives — the outcome layer every ORD row traces to | `/write-ord` |
| `BRL-NNN` | Business rules — every ORD, see § *Business rule* | `/write-ord` |
| `SCN-NNN` | Scenarios — requirement-level and catalogue, one namespace | `/write-ord` |
| `IMP-NNN` | Impacts — workflows and systems touched, with named owners | `/write-ord` |
| `REF-NNN` | Referred requirements — raised here, delivered elsewhere | `/write-ord` |
| `DAT-NNN` | Data elements — conditional, schema in `reporting.md` | `/write-ord` |
| `ASM-NNN` | Assumptions | whichever document records it |
| `DEP-NNN` | Dependencies | whichever document records it |
| `EVL-NNN` | Evaluation sets — schema in `ai.md` | `/write-ord` (the PRD cites, never mints — see below) |
| `MDL-NNN` | Model / provider dependencies — schema in `ai.md` | `/write-ord` (as above) |

`EVL-NNN` and `MDL-NNN` were added by ADR-0003 and apply only where `ai.md` is triggered.
**Both have exactly one assigning skill, like every other prefix here.** `/write-reqs` authors the
PRD before the ORD, so a PRD needing a set that does not exist yet writes `[EVL-TBD — <what must be
measured>]` and `/write-ord` writes the real ID back — the same mechanism as `Capability` and `Epic`.
Where no ORD is produced at all, the PRD holds the registers and assigns the IDs, and says so.

All are flat and sequential in order of first appearance, never encode a theme or characteristic,
and are never reused once retired. `BO-N` and `BR-N` are single-digit-sequential per BRD, matching
the form `/write-brd` emits — do not re-pad them to three digits.

**Do not use single-letter prefixes.** `/raid` owns `R-`, `A-`, `I-`, `D-` for Risks, Actions,
Issues and Decisions — `A-NNN` for assumptions would collide with Actions.

### Coverage Gaps — the collapse rule

A gap must stay visible, but a stub table per absent subsection buries the document. A
requirements document authored from thin source material can easily have more empty tables than
populated ones.

**Do not scaffold an empty table per absent subsection.** Instead:

- A subsection with **at least one** requirement gets its table, populated.
- A sub-characteristic with **no** requirement is omitted from the body entirely, and listed as one
  row in a single **Coverage Gaps** table at the end of the section.

**The collapse applies at sub-characteristic level only. All nine ISO/IEC 25010:2023 characteristics
appear in every ORD, without exception** — §7.1 through §7.9, each present even where it carries
nothing. A characteristic with nothing to state carries an explicit statement of that fact and its
status, never an omission. The two rules are not in tension: a characteristic is a heading a
reviewer checks for, and its absence is invisible; a sub-characteristic is a table, and thirty empty
ones bury the document.

| Absent subsection | Reason | Action |
|---|---|---|
| [e.g. 3.5.4 Replaceability] | No source material | Stakeholder workshop |

A requirement known to exist but unquantified is **not** a coverage gap — it is a populated row
carrying `[TBD — source: "quoted vague statement"]`.

### View Tables

Where a commitment is genuinely needed in two places — an SLA summary restating availability, an
incident-response table restating recovery targets — the second occurrence is a **view**, not a
second source of truth.

A view table restates the `ID` and the agreed value by reference and introduces **no new
numbers**. Head it explicitly:

> *View of Section 7. Values are authoritative in the referenced rows; this table adds no new commitments.*

Two tables carrying the same commitment at independently editable values is the defect this
prevents.

### Document Structure

Adopted from the Australian Government Style Manual, *Structuring content* (stylemanual.gov.au).
§ *The Rule* above decides *whether* something is a table. This section governs how headings,
paragraphs, lists and tables are put together.

**Order: most important first.** Each document leads with its executive summary or problem
statement, and each section leads with its main point. Supporting detail, mechanism and evidence
follow, and the appendices take what an executive does not need to read.

**Headings.**
- Under 70 characters, starting with the keyword. Never a question, and never an empty heading
  such as `Other` or `More information`.
- No more than 4 levels, and no level skipped. Section numbers go no deeper than 3 levels
  (`7.4.1`).
- A level used once is a stranded heading. Use at least 2 headings at that level, or none.
- At least 1 sentence between a heading and the next heading.
- Headings at the same level share a grammatical form, either all noun phrases or all verb
  phrases.

**Paragraphs.**
- One topic per paragraph. A new topic starts a new paragraph.
- The first sentence says what the paragraph is about. The first paragraph of a section
  summarises the section.
- No more than 6 sentences. A longer paragraph becomes 2 paragraphs or a list.
- A paragraph never starts with a pronoun whose noun is in an earlier paragraph.

**Lists.**
- A lead-in introduces every list. A lead-in phrase ends with a colon.
- Items share a grammatical form, and words repeated in every item move to the lead-in.
- **Fragment list:** items complete the lead-in. They start lower case, take no end punctuation,
  and only the last item takes a full stop. Lead-in and item together stay within 25 words.
- **Sentence list:** each item is 1 full sentence, with a capital and a full stop.
- Never end an item with `;`, `,`, `and` or `or`. Never end a list with `etc.`: write `for
  example` or `including` in the lead-in instead.
- Numbered lists only where the order matters. No more than 2 levels.

**Tables.**
- The text introduces every table and says what it shows. The text interprets the table and
  never repeats its data.
- Each column holds one kind of content in one grammatical form. Headings sit in the first row,
  and row labels in the first column.
- No merged cells and no tables inside tables. Meaning is never carried by colour, bold or
  position alone.
- No empty cells: `None`, `—` (for an axis that does not apply, as § *Scenario* defines), or the
  declared-gap markers this file defines.

**Links.**
- Link text names the destination and makes sense on its own. Never `click here` or `this
  page`.
- A link to a file names its type and size: `Annual report 2025–26 [PDF 1.9 MB]`. Link to the
  landing page where there is one.

**Callouts.** A `>` callout carries a view note, a rule statement or a test. It is used
sparingly and never holds a binding statement, because a callout is not a row.

#### Recorded deviations from the Style Manual

1. **Numbered headings.** The Style Manual numbers headings only for sequences. Requirements
   documents number their sections because a section number is a stable address that other
   documents, reviews and the `.llm.md` companion cite. Numbering stops at 3 levels, which is
   the Style Manual's own limit. A template's fixed sections are kept as the template gives them,
   even where one level holds a single heading.
2. **A table for 1 item.** The Style Manual puts 1 or 2 items in text rather than a table. A
   binding statement is a row with an ID however few there are, because § *The Rule* is about
   citability, not volume. The Style Manual's rule applies to everything that does not bind.
3. **One reference list.** The Style Manual lists legislation and legal cases under their own
   headings. A requirements document keeps one table and sorts it with the `Type` column.

### Never

- Never cite a source without a row in the reference list, or keep a row that nothing cites.
- Never write a heading as a question, or skip a heading level.
- Never let a paragraph run past 6 sentences or cover 2 topics.
- Never end a list item with `;`, `,`, `and` or `or`, and never end a list with `etc.`.
- Never merge table cells, or carry meaning by colour, bold or position alone.
- Never write link text that only makes sense in its sentence.
- Never add a fourth `Scenario` value. A capability that runs correctly and returns an unfavourable
  answer is a Sunny Day with `Outcome: Adverse` — condition and outcome are two axes, and collapsing
  them into one column is what a fourth value would do.
- Never leave a determination, measurement or eligibility requirement with only a Favourable Sunny
  Day scenario. What is true when the answer is adverse is a separate obligation.
- Never write a design disposition into `Treatment` — *migrated*, *decommissioned*, *extended* and
  *replaced* each name what becomes of an impact, which is the response's answer and not the
  demand's. The enum is three values and it is closed.
- Never read a populated `Referred` cell as a treatment, and never leave a referred impact without
  one — referral is what happens after an exclusion, not the exclusion itself.
- Never give the operational actor table an ID prefix, and never put a governance role in it.
- Never put `Delivery Agent`, `Operational Owner`, `Timing` or `Verification` in the ORD register —
  each is response-side, and stating one pre-empts the design review the document exists to inform.
- Never state a technical target where a business tolerance belongs (see `language.md`).
- Never collapse a KPP's threshold and objective into a single figure.
- Never carry an `Assumed` row whose assumption has no named owner and no confirm-by date.
- Never omit one of the nine ISO/IEC 25010 characteristics from an ORD — collapse sub-characteristics
  to the Coverage Gaps table, never the characteristic itself.
- Never embed classification, cut-off, calculation, reconciliation or retention logic in a register
  row — state the outcome and cite the `BRL-NNN` rule.
- Never carry a business rule without an owner, a status and the requirements it affects.
- Never record a dependency, a related initiative, a referred requirement and an out-of-scope item
  in one table — each has its own register and its own test.
- Never leave an unresolved business decision as an assumption inside a requirement — it is a
  decision row with an owner.
- Never write `Happy path`, `Happy Path`, `Error`, `Error Case` or `Edge` as a scenario value, and
  never head the column `Type`. The three values are `Sunny Day`, `Rainy Day` and `Edge Case`, and
  the column is `Scenario` — written exactly so, capitalised so, in every document and in every
  sentence of prose that names them. These are the words a stakeholder reads aloud; reverting one
  of them mid-document is the failure this rule exists to prevent.
- Never write a binding statement as free-text prose, in any section.
- Never give a table row a commitment without a stable ID.
- Never invent a column set where a canonical schema exists.
- Never restate a value in a second table — reference the ID and mark the table as a view.
- Never scaffold an empty table per absent subsection — use the Coverage Gaps table.
- Never use a single-letter ID prefix (collides with `/raid`).
- Never mint an ID from a prefix this table assigns to a different skill — write the `[TBD]` form and
  let the owning skill write it back.
- Never silently drop a gap to keep a document looking complete.


---

Everything below this line is **conditional**. Each part fires only where its own trigger
test does, and the tests are independent -- a change can fire both, one, or neither. Where
you have answered both and neither fired, the parts above are the whole of the standard.

---

## `ai.md`

> Applies **in addition to** `language.md` and `tables.md` whenever a
> delivered component's behaviour is learned or generated rather than specified. Neither sibling is
> relaxed here. Read the scope boundary in `README.md` first — these rules govern
> generated document content, not skill instruction prose.

### When this file applies

**Trigger test:** a delivered component whose output for a given input is not fully determined by
written logic — a trained model, an LLM call, a retrieval-augmented pipeline, an agent, or a
third-party AI service consumed as an API. One such component anywhere in scope triggers the file
for the requirements that touch it; deterministic requirements in the same document are unaffected.

**Not triggered by AI used to build the solution.** `ai-first-engineering` governs AI as the
*author* of code. This file governs AI as the *subject* of the requirement. The requirement subject
is always the delivered system, never the toolchain that produced it.

Per ADR-0003 there is **no separate AI requirements document**. Everything below lands in the
existing BRD, PRD and ORD, in the section the class map assigns.

### The Rule

**Non-determinism changes the evidence a requirement needs. It never changes the grammar it is
written in.**

The declarative end-state form, the modal ban, the "the system" ban and the vagueness ban all apply
unchanged. Probabilistic behaviour is the most plausible excuse yet available for writing `may` into
a criterion — which is exactly why it is refused here. **Variability belongs in the threshold, never
in the verb.**

### The evaluative criterion

A requirement over learned or generated behaviour is a declarative end state carrying four parts.
Missing any one of them, the statement is unfalsifiable at verification time.

| Part | Supplies | Never written as |
|---|---|---|
| **Behaviour** | the end state, stated so that variability is expected | "the output is correct" |
| **Threshold on a named set** | the scorer, the number that passes, and the `EVL-NNN` set it is measured on | "high quality", "a representative sample" |
| **Floor** | the worst *single case* tolerated on the scored scale, alongside the mean | omitted because the mean passes |
| **Review hook** | what happens to a case below threshold — who or what handles it | omitted because the mean passes |

**The floor is scalar. A categorical prohibition is a different obligation and does not live here.**
An output that is unacceptable *at any rate* — a leaked secret, a medical instruction from a
component not cleared to give one, a protected-attribute inference — is not a low score to be
averaged against. Scoring it at all implies a rate at which it passes. It is a **separate register
row** in ORD § 7.9.3 Prohibited Outputs — or § 7.3 Security where the prohibition is a disclosure
rather than a hazard, in one place and not both — stating the prohibited output, a tolerance of zero,
and its own verification method; the `EVL-NNN` row references that row's ID in `Prohibited outputs` and
restates no value. Conflating the two is how a prohibition becomes a percentage.

> ✗ `The model should rarely hallucinate`
> ✗ `Summarisation accuracy is acceptable under normal load`
> ✗ `Answer quality scores ≥ 4.0 of 5` *(no named set — unmeasurable at verification)*
> ✓ `Meeting-summary quality scores ≥ 4.0 of 5 mean on evaluation set EVL-004, with no individual case below 2.5 and an unsupported-claim rate below 3%. A case scoring below 2.5 is routed to human review before release.`

**A threshold measured on training data is not a threshold.** Every `EVL-NNN` set is held out from
whatever tuned the component.

**The ORD owns both registers; the PRD cites and never mints.** `EVL-NNN` and `MDL-NNN` are assigned
by `/write-ord` alone, exactly as `ORD-NNN` is — two skills allocating from one flat sequential
namespace with no coordination is how IDs collide, and `/write-reqs` authors the PRD *before* the
ORD, so a PRD minting its own would guarantee it. A PRD criterion needing a set it cannot yet name
writes **`[EVL-TBD — <what must be measured, and on what>]`**, and `/write-ord` resolves it to a real
ID when it builds the register — the same write-back the `Capability` and `Epic` columns already use
in `tables.md`. An unresolved `[EVL-TBD]` at the PRD gate is a visible hole, which is the
point; an invented `EVL-007` is not.

**Where no ORD is produced**, the PRD holds both registers itself and assigns the IDs — the rule
above prevents *concurrent* allocation, not allocation. Say so in the document rather than leaving a
reader to infer which skill owns the namespace.

**Where no evaluation set exists yet**, the `[TBD — source: "quoted vague statement"]` rule from
`language.md` applies unchanged. Never invent a threshold, a set size, or a scorer to
avoid writing TBD.

**The two TBD forms mark different holes; do not substitute one for the other.**

| Form | Means | Resolved by |
|---|---|---|
| `[TBD — source: "quoted vague statement"]` | the source never gave a threshold — there is nothing to measure yet | a stakeholder decision |
| `[EVL-TBD — <what must be measured, and on what>]` | the threshold is known, the **set** that proves it is not built or not yet numbered | `/write-ord`, writing the real `EVL-NNN` back |

Writing the first where the second is true hides a known measurement behind a stakeholder question
and it never gets built.

### Marking an AI-governed row

**Prefix `Business Tolerance` with `[AI]`** on every ORD register row this file governs, and
prefix the `Acceptance Criterion` cell the same way on a PRD criteria row. The trigger is
per-component, so an ORD holds governed and ungoverned rows side by side and a finished register
otherwise gives a reviewer no way to tell which is which — this ruleset becomes uncheckable at
exactly the point someone tries to check it.

- **`[AI]` stays a prefix; `KPP` is a column.** The two were once both prefixes, written
  `[KPP][AI]`. Under the demand-side register in `tables.md`, `KPP` has its own column
  because a KPP carries threshold and objective as two labelled values and a prefix cannot hold
  them. `[AI]` remains a prefix deliberately: it records which *ruleset governs the row's form*,
  which is not a property a column should imply is severity. **A row can be both** — the `KPP`
  column reads `[KPP]` and the tolerance begins `[AI]`.
- **An ORD authored before that change carries `[KPP][AI]` inline.** Read it as the same marking;
  do not rewrite the source document.
- **`[AI]` is not a priority and not a MoSCoW value.** It records which ruleset governs the row's
  form. A `[AI]` row is still `Must` / `Should` / `Could` / `Won't` like any other.
- **A row carrying `[AI]` and no `EVL-NNN` reference is incomplete** — that is precisely what the
  marker makes visible, and a reviewer is entitled to reject it on sight.

### Where AI requirement classes live

The class map. A row that does not appear here has no AI-specific home and follows the normal rules.

| Requirement class | Home | Origin |
|---|---|---|
| Risk classification decision | BRD | AI Act Art. 6 |
| Intended purpose | PRD § Scope boundary | AI Act Art. 11 / Annex IV |
| Prohibited uses | PRD § Out of Scope | AI Act Art. 11 |
| User-facing quality or accuracy outcome | PRD story criteria | 29148 |
| Functional adaptability | ORD § 7.8.3 Functional Adaptability | 25059 |
| Accuracy and fairness thresholds (operational) | ORD § 7.8.2 Functional Correctness, as `[AI]` rows | 25059, AI Act Art. 15 |
| Robustness — out-of-distribution and adversarial input | ORD § 7.2.5 Robustness | 25059, AI Act Art. 15 |
| User controllability and intervenability | ORD § 7.7.4 User Controllability and Intervenability | 25059 |
| Transparency, explainability, output labelling | ORD § 7.7.5 Transparency and Explainability | 25059, AI Act Arts. 13, 50 |
| Human oversight — who intervenes, when, with what authority | ORD § 7.7.4 and § 7.12 Operational Hours and Escalation Tolerance | AI Act Art. 14 |
| Record-keeping and inference logging | ORD § 7.6.4 Record-Keeping and Inference Logging, § 7.6.2 Analyzability | AI Act Art. 12 |
| Data governance, provenance, labelling method | ORD § 7.11 Operating Environment and Constraints | AI Act Art. 10, ISO/IEC 5259 |
| Drift detection and re-verification cadence | ORD § 7.8.3, § 7.6.2 Analyzability, § 7.13 Service Level Requirements | ISO/IEC 5338 |
| Model and provider dependency | ORD § 10.1 Dependencies, keyed to `MDL-NNN` | — |
| Prompt-injection and model-specific attack surface | ORD § 7.3.7 Prompt Injection and Model Attack Surface | AI Act Art. 15 |
| Prohibited output — unacceptable at any rate, zero tolerance | ORD § 7.9.3 Prohibited Outputs, or § 7.3 Security where it is a disclosure | AI Act Art. 15 |
| Evaluation sets and model dependencies (registers) | ORD § 10.1 Dependencies, keyed to `EVL-NNN` / `MDL-NNN` | — |

**The ORD subsections named above are defined in** `skills/write-ord/TAXONOMY.md` § *ISO/IEC
25059:2023 — AI Extension* and are scaffolded in its §7 template marked *(AI — 25059)*. They are
conditional on this file's trigger test: where it does not fire they do not apply, and are omitted
from the body *and* from the §7.10 Coverage Gaps table — an inapplicable subsection is not a gap.

**§7.8.2 Functional Correctness is the exception** — a 25010 subsection present in every ORD. Accuracy
and fairness land there as `[AI]` rows beside any deterministic correctness tolerance, so the trigger
not firing removes those rows and never the subsection.

**Where no PRD is produced**, intended purpose and prohibited uses are held in the ORD's scope
section rather than dropped. The class map assigns a *home*, not a document that must exist.

**Where the actor is load-bearing — human oversight, intervention authority, record-keeping — name
the actor and use the active voice**, per the second recorded deviation in
`language.md`. "Oversight is provided" names nobody and binds nobody.

### Canonical schemas

Both are registers. A requirement row still carries its own value in its own sentence and
references the register by ID — the § View Tables rule in `tables.md` applies, so a
threshold is never restated in two independently editable places.

#### Evaluation set register

| ID | Evaluation set | Size | Held out from | Scorer | Threshold | Floor | Prohibited outputs | Re-run trigger | Owner |
|---|---|---|---|---|---|---|---|---|---|
| EVL-NNN | [named set] | [n cases] | [what it is held out from] | [deterministic check / embedding similarity / LLM-judge with its calibration set, statistic and minimum] | [pass value] | [worst single case tolerated] | [ORD-NNN row IDs, or —] | [what forces a re-run] | [role] |

- **`Scorer` names the method, not the intent.** An LLM-judge row states what it was calibrated
  against; an uncalibrated judge is a `[TBD]`, not a scorer.
- **"Calibrated" is an unquantified adjective unless it carries a number.** This file bans
  "explainable" and "monitored" for exactly this reason and takes no exemption for its own vocabulary.
  A judge-based `Scorer` cell names three things: the **human-annotated calibration subset**, the
  **agreement statistic** used against it, and the **value achieved with the minimum required** —
  for example *"LLM-judge, calibrated on 120 human-annotated cases, Krippendorff's α = 0.81 against
  two annotators, minimum 0.80"*. Krippendorff's own convention — α ≥ 0.800 to rely on a variable,
  0.667 ≤ α < 0.800 for tentative conclusions only — is a reasonable default where the project has
  not set its own; record the choice rather than assuming the reader shares it. A judge whose
  agreement is asserted but not measured is a `[TBD]`, the same as an uncalibrated one.
- **`Re-run trigger` is mandatory** — an evaluation with no trigger is a launch gate, not a
  requirement. At minimum: any model version change, any prompt change, any change to an upstream
  data source.
- **`Prohibited outputs` holds row IDs, never values.** It points at the ORD § 7.9 / § 7.3 rows
  carrying the categorical prohibitions this set is scored alongside, per the § View Tables rule in
  `tables.md`. `—` is a real answer meaning *considered, none apply* — it is not the same
  as leaving the cell blank, and the column exists so the question is asked rather than assumed.

#### Model dependency

| ID | Component | Provider | Model / version | Pinned | Deprecation notice | Fallback behaviour | Re-evaluation trigger |
|---|---|---|---|---|---|---|---|
| MDL-NNN | [what depends on it] | [provider] | [model id and version] | Yes / No | [notice period, or "none contracted"] | [what happens when unavailable] | [EVL-NNN re-run] |

A model version named inside a requirement row without a matching `MDL-NNN` row is an
untracked dependency. `Pinned: No` with `Deprecation notice: none contracted` is a risk — raise it
via `/raid add risk` rather than leaving it in the table alone.

### Shelf life

A requirement over learned behaviour degrades with no change to the code — data drift, model
deprecation, a provider's silent update. **Acceptance at go-live is not final acceptance.**

- Every `EVL-NNN` row carries its re-run trigger, and the re-verification cadence is an ORD register
  row in its own right, not a note in the support model.
- A drift threshold is quantified like any other requirement, with its measure named
  (for example a population-stability index band), never as "drift is monitored".
- **Every drift or quality alert names its runbook.** An alert with no documented response is
  observability, not an operational requirement.

### The scenario triad for AI

The three values in `tables.md` are unchanged — `Sunny Day`, `Rainy Day`, `Edge Case`.
For a generated-behaviour requirement they read as:

| Value | The component under |
|---|---|
| **Sunny Day** | In-distribution input, component available, confidence above threshold |
| **Rainy Day** | Component unavailable or timed out, confidence below threshold, refusal, fallback path taken |
| **Edge Case** | Out-of-distribution or adversarial input, prompt injection, unrepresented cohort, empty or maximum-length context |

A story whose criteria are all Sunny Day has been specified for the demo. For a generated-behaviour
component that warning is sharper than usual: the Sunny Day path is the one the vendor already
demonstrated.

### Standards of record

| Standard | Status here |
|---|---|
| ISO/IEC 25010:2023 | The ORD §7 taxonomy this file extends. Australian adoption: **AS/NZS ISO/IEC 25010:2025**. |
| ISO/IEC 25059:2023 | Extends the ORD's ISO/IEC 25010:2023 taxonomy — adds functional adaptability, robustness, user controllability, transparency, intervenability. Does not replace it. Second edition under member-body vote. Australian adoption: **AS ISO/IEC 25059:2024**. |
| ISO/IEC/IEEE 29148:2018 | Unchanged for the PRD. The good-requirement characteristics hold; only the evidence satisfying *verifiable* changes. |
| ISO/IEC 22989:2022 | Vocabulary. Adopt its terms rather than coining local ones — record them in the project glossary. |
| ISO/IEC 23894 | AI risk management. Feeds ORD § 8.2 and `/raid`. |
| ISO/IEC 5338 | AI system life-cycle processes. Feeds ORD § 7.12 and § 7.13. |
| EU AI Act — Regulation (EU) 2024/1689, as amended by (EU) 2026/1744 | Supplies requirement classes (Arts. 9–15, Annex IV), not document structure. Application dates are in the stamp below, verified 2026-08-24. |
| ISO/IEC 42001:2023 | Organisational management system, above the document layer. Out of scope for this file. |
| ISO/IEC 5259 series | Data quality for ML. A data-as-subject schema is deferred per ADR-0003. |

#### Regulatory dates — verification stamp

**Dates move; a rules file does not notice.** These are recorded once, here, with their provenance,
so no requirement document restates them and no author cites them believing they were checked today.

The research behind this file is **deliberately not published with these rules.** The workspace
`docs/` holds company-internal material and is not published with the framework, as the
`requirements-documents` pack is not. Its findings are restated here and in ADR-0003, which are
tracked; the source is not, by choice.

| Obligation | Date as recorded | Status |
|---|---|---|
| AI Act Art. 5 prohibitions, GPAI obligations, Art. 50 transparency duties | in force | cited |
| Annex III high-risk obligations | 2 December 2027 | cited — deferred from the original date by the amending regulation below |
| Annex I high-risk obligations | 2 August 2028 | cited — deferred as above |

- **Last verified:** 2026-08-24, by **Glen Sanders**, against the European Commission's own
  announcement of the amending regulation entering into force —
  <https://digital-strategy.ec.europa.eu/en/news/ai-omnibus-enters-force> — which states the
  2 December 2027 and 2 August 2028 dates directly.
- **Amending instrument:** Regulation (EU) 2026/1744 (Digital Omnibus on AI), adopted 8 July 2026,
  published OJ 24 July 2026, in force 27 July 2026. CELEX `32026R1744`, ELI
  <https://eur-lex.europa.eu/eli/reg/2026/1744/oj/eng>. It amends Regulation (EU) 2024/1689 (the AI
  Act), ELI <https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng>.
- **What was not done:** the consolidated **Article 113** text was not read. EUR-Lex returned its
  Official Journal navigation page rather than the document on three URL forms, so the dates above
  rest on the Commission's announcement plus consistent independent legal analyses, not on the
  article itself. That is a strong chain and it is not the primary text. **Read Article 113 before
  certifying conformity**, and record it here.
- **Owner:** **Glen Sanders**, as maintainer of this ruleset. Re-verify on any amending regulation,
  and at minimum annually.
- **Deferral changes the deadline, not the content.** A register already carrying data governance,
  logging, human oversight and accuracy rows needs no retrofit in 2027; one that does not, does. The
  dates govern *when* evidence is demanded, never whether the classes above apply.

#### Australian adoptions and instruments

Recorded because this pack is authored in an Australian context. **Cite the AS designation where one
exists** — it is the same text, and it is the one an Australian auditor asks for.

| Instrument | Status here |
|---|---|
| **AS/NZS ISO/IEC 25010:2025** | Identical adoption of ISO/IEC 25010:2023 — the taxonomy the ORD's §7 is keyed to. Cite this designation in an Australian document. |
| **AS ISO/IEC 25059:2024** | Australian adoption of ISO/IEC 25059:2023 — the AI extension this file applies. Cite alongside the ISO designation. |
| **AS ISO/IEC 42001:2023** | Identical adoption, February 2024. Organisational management system, above the document layer — out of scope for this file, as its ISO parent is. |
| ISO/IEC/IEEE 29148:2018 | **No Australian adoption identified.** Cite the ISO/IEC/IEEE designation. |
| **Voluntary AI Safety Standard (VAISS)** — DISR, 10 guardrails | **Voluntary. Binds nothing.** Useful as a checklist against the class map; never cite a guardrail as the authority for a requirement. |
| **Guidance for AI Adoption (GfAA)** — October 2025, six practices | Voluntary; supersedes VAISS in practice. Same treatment. |
| Proposed mandatory guardrails for high-risk AI, September 2024 | **Shelved.** Do not author against them. |
| **National AI Plan**, 2 December 2025 | Policy direction, not law: existing legislation and sector regulators, supported by voluntary guidance and the Australian AI Safety Institute. **There is no Australian AI Act.** |

**Watch item — an Australian AI standard to be legislated.** An Office of AI was established in the
Department of the Prime Minister and Cabinet, and on 15 July 2026 the Prime Minister announced an
intent to legislate an Australian AI standard — for consideration by National Cabinet in August 2026,
with legislation expected early 2027. Published scope centres on **large AI data centres** — energy,
water, and copyright protections for Australian creators — not on requirement classes for an AI
system generally. **None of it is law yet**, and nothing in this file's class map derives from it.
Re-check before the next document cycle; the owner named above owns this too.

**The practical consequence for an Australian project.** The binding classes in the map above come
from the **EU AI Act**, and apply only where a system falls within its scope. A purely domestic
Australian system currently has **no mandatory AI-specific requirement classes**: it is governed by
existing law — privacy, consumer, anti-discrimination, sector regulation — plus whatever the
organisation adopts voluntarily. Name which regime applies in the document rather than importing the
AI Act by default. The evaluative criterion, the evaluation-set discipline and the shelf-life rule in
this file are **engineering practice, not regulation**, and apply either way.

### Never

- Never create a separate AI requirements document — the classes above have homes (ADR-0003).
- Never let non-determinism justify a modal. `may`, `might`, `should`, `could` and `would` stay
  banned, and the excuse for reaching for them is stronger here than anywhere else.
- Never state a threshold without naming the evaluation set it is measured on.
- Never measure a threshold on data the component was tuned against.
- Never write a mean with no floor — an average that passes hides the case that harms someone.
- Never score a categorical prohibition — an output unacceptable at any rate is a zero-tolerance
  register row of its own, never a floor on a scale that implies a passing rate.
- Never mint an `EVL-NNN` or `MDL-NNN` outside the ORD where an ORD exists — write `[EVL-TBD — …]`
  and let `/write-ord` write it back.
- Never call a judge "calibrated" without naming the calibration set, the agreement statistic and
  the minimum required.
- Never leave an AI-governed row unmarked — `[AI]` is what makes this ruleset checkable by someone
  who was not in the room.
- Never move `[AI]` into the `KPP` column, and never collapse the two markings into one — they
  record different things: severity, and which ruleset governs the row's form.
- Never cite an AI Act application date for a conformity certification without reading the
  consolidated Article 113 — the stamp above records exactly what was and was not checked.
- Never cite a VAISS or GfAA guardrail as the authority for a requirement. Both are voluntary; a
  requirement naming one as its source names no obligation.
- Never import the EU AI Act's classes into a purely domestic Australian system by default — name
  the regime that applies and why.
- Never cite an ISO designation alone where an AS adoption exists — an Australian auditor asks for
  the AS number.
- Never record an evaluation set with no re-run trigger.
- Never name a model version in a requirement without a matching `MDL-NNN` row.
- Never treat go-live acceptance as final for a component whose behaviour is learned or generated.
- Never write "drift is monitored", "the model is explainable", or "human oversight is in place" —
  each is an unquantified adjective in disguise. Give the measure and the actor, or write `[TBD]`.
- Never apply this file to AI-assisted *authoring* of the solution — that is `ai-first-engineering`.


---

## `reporting.md`

> Applies **in addition to** `language.md` and `tables.md` whenever a change
> introduces, alters or retires a **measure that is reported** — to a regulator, a counterparty, an
> auditor, or internally where a decision or an obligation turns on the figure. Neither sibling is
> relaxed here. Read the scope boundary in `README.md` first — these rules govern
> generated document content, not skill instruction prose.

### When this file applies

**Trigger test:** does the change create, change or remove a **number somebody reports**? One such
measure anywhere in scope triggers the file for the requirements that touch it; requirements that
carry no reported measure are unaffected.

It does **not** fire for a system that merely stores or displays data. The trigger is the reported
measure and the obligation behind it — the thing that must still be defensible when someone asks how
the figure was produced eighteen months later.

Per the same reasoning as ADR-0003 there is **no separate reporting requirements document**.
Requirements land in the existing register, in the section the class map assigns; the detail that
makes them reproducible lands in the ORD's **§14 Reporting Requirements Appendix** — see
§ *Altitude — outcome in the register, detail in the appendix*.

### The Rule

**A reported measure is not specified until its population, its clock, its rules, its lineage and
its correction path are stated. The figure alone is a display; the five together are a measure.**

The failure this file exists to prevent is a requirement that names an output — *"a monthly
compliance report is produced"* — and leaves unstated which records it counts, which it excludes,
when its clock starts and stops, which version of the rules produced it, and what happens when it is
later found wrong. Every one of those is discovered during an audit rather than during design.

### The measure definition

A requirement over a reported measure is a declarative end state carrying five parts. Missing any
one, the figure is unreproducible.

| Part | Supplies | Never written as |
|---|---|---|
| **Population** | which records are in, which are out, and on what evidence | "all relevant records" |
| **Clock** | the measurement period, and for an elapsed measure the start event, the stop event and any duration excluded from it | "monthly", with no period boundary and no stop event |
| **Rule set and version** | the `BRL-NNN` rules that classify and calculate, and which version was in force | "as per the business rules" |
| **Lineage** | the source of each input and the identifier that survives to the output | "sourced from the data warehouse" |
| **Correction path** | what happens when a published figure is later found wrong | omitted, because it has not happened yet |

**The clock is the part most often assumed and least often written.** For a period measure it states
the period boundary, the cut-off, and how a record arriving after the cut-off is treated. For an
elapsed measure it states what starts the clock, what stops it, and every interval excluded — a
pause, a hold, a suspension, a wait on a third party — because an elapsed figure with an unstated
exclusion cannot be reproduced by anyone who did not compute it. A period expressed in business days
carries its calendar basis: the timezone, and the holiday jurisdiction — state, territory, national
or contractual — that determines which days count.

> ✗ `A monthly compliance report is produced`
> ✗ `The monthly compliance figure counts every service order closed in the calendar month in the reporting entity's local time, excluding orders cancelled by the customer, classified under the BRL-004 rule set version in force at closure, counted to a cut-off five business days after month end …` — complete, but written at the wrong altitude: no executive can read it, and the register row has become the rule set
> ✓ Register row: `The monthly compliance figure is published within five business days of month end and is reproducible from its source records, beyond which obligation X §4 is breached` · §14.2 measure definition for that `ORD#`: population, clock, cut-off, lineage and correction path · §13 rules `BRL-004` (classification) and `BRL-009` (late-arriving closures and restatement)

### Altitude — outcome in the register, detail in the appendix

**The five parts are mandatory; where they are written is not the register.** A register row states
the business outcome a reporting consumer needs — published, on time, reproducible, auditable — and
the consequence of breach. The five-part measure definition is written once in the ORD's **§14.2**,
keyed by the `ORD#` it details, and the classification, cut-off, restatement and reconciliation
logic is written once as `BRL-NNN` rows in **§13**.

**The test for a register row:** *could an executive understand it without understanding reporting,
governance, architecture or implementation?* If not, the row states the outcome and cites the
§14.2 definition or the `BRL-NNN` that carries the detail. A measure missing any of its five parts
across row, definition and rules is still unspecified — moving detail to the appendix is never a
licence to drop it.

### Reporting consumers

**Reporting consumers are stakeholders even where no process changes for them.** A change to a
population, a clock or a rule changes every figure built on it, and the consumer of that figure
finds out when it moves. Identify each consumer class the source evidences:

| Class | Typically |
|---|---|
| Regulatory | A regulator, or an obligation reported to one |
| Contractual | A counterparty reported to under an agreement |
| Operational | Teams running the process from the figure |
| Management | Line management deciding from the figure |
| Executive | Executive and board reporting |
| Audit | Internal and external audit |

Each consumer is a row in §14.1 (schema below). Where a consumer's need is a commitment, it is also
a register row in the section the class map assigns, and the §14.1 row cites it. **A consumer class
with no evidence in the source is a question for the gate, never an inferred row.**

### New reporting data

**Never assume a reporting platform already holds what a new or changed measure needs.** Where a
measure needs an attribute, a dimension or a data element, its `DAT-NNN` row carries `Availability`:
`Existing — confirmed` only where the source confirms it, otherwise `New` or `Unconfirmed`. Where
any element is `New` or `Unconfirmed`, raise a candidate register row at the Phase 1 gate stating
that the data the reporting consumers need is captured and available for the measure — it becomes
a row only on the business owner's confirmation, under the usual status rules.

**Do not nominate a system or dataset as authoritative unless the source material confirms that
status.** Which system is the book of record is a governance fact, not a drafting choice.

### Data quality — the anchor

**ISO/IEC 25012** (data quality model) is the taxonomy for data requirements, and it sits in the same
SQuaRE series as the ISO/IEC 25010:2023 characteristics the ORD's §7 is already keyed to.
**ISO/IEC 25024** supplies the measurement side. Use their characteristic names rather than coining
local ones, exactly as `ai.md` defers to ISO/IEC 22989:2022 for AI vocabulary.

A data requirement states a quality characteristic **of a named data element**, quantified, with the
consequence of breach — not a general aspiration that data is good.

### Where reporting and data requirement classes live

The class map. A row that does not appear here has no reporting-specific home and follows the normal
rules.

| Requirement class | Home |
|---|---|
| The reported measure itself — population, threshold, obligation behind it | ORD § 7.8.1 Functional Completeness |
| The measurement clock — period boundary, start event, stop event, excluded duration | ORD § 7.8.1 |
| Cut-off, and treatment of data arriving after it | ORD § 7.8.1 |
| Granularity and the dimensions the measure is disaggregated by | ORD § 7.8.1 |
| Accuracy, completeness, currentness of a named data element | ORD § 7.8.1, keyed to a `DAT-NNN` row |
| Reproduction of a historical figure under the rules in force at the time | ORD § 7.6.2 Analyzability |
| Lineage — source of each input, identifier surviving to the output | ORD § 7.6.2 Analyzability |
| Reconciliation — source, included, excluded, exception populations | ORD § 7.8.1 |
| Duplicate and omission control | ORD § 7.3.2 Integrity |
| Restatement and correction of a published figure | ORD § 7.6.1 Modifiability |
| Who may read the report, and at what granularity | ORD § 7.3.1 Confidentiality |
| Report availability and timeliness against the obligation | ORD § 7.1.1 Time Behavior |
| Retention of the figure and its supporting records | ORD § 7.3.3 Non-repudiation and Accountability |
| Definition and rule ownership, effective dating | ORD § 7.6.1, with the rules themselves as `BRL-NNN` |
| Exception visibility — what could not be determined, and why | ORD § 7.8.1 |

**Nothing here adds a §7 subsection.** Reporting requirements are ordinary operational requirements
whose *content* this file governs; they land in the 25010 subsections that already exist. A parallel
reporting section in the body would restate the register. **The §14 appendix is not that section** —
it holds consumers, measure definitions, data elements, and transparency, audit and acceptance
evidence, and every binding statement in it cites an `ORD#`. Proposed acceptance criteria stay in
§11.

### Canonical schema

#### Data element register

Lands at ORD §14.3.

| ID | Data element | Kind | Used by | Quality characteristic | Tolerance | Availability | Source | Lineage | Owner |
|---|---|---|---|---|---|---|---|---|---|
| DAT-NNN | [named element] | Attribute / Dimension / Measure input | [ORD-NNN, …] | [ISO/IEC 25012 characteristic] | [declarative, quantified] | Existing — confirmed / New / Unconfirmed | [system or process of origin, where confirmed] | [how it reaches the output] | [named, or TBD with confirm-by] |

- **`Availability` defaults to `Unconfirmed`, never to `Existing`.** See § *New reporting data*.

- **`Quality characteristic` uses ISO/IEC 25012's names.** There are fifteen and this is all of
  them — **accuracy, completeness, consistency, credibility, currentness, accessibility,
  compliance, confidentiality, efficiency, precision, traceability, understandability,
  availability, portability, recoverability**. A characteristic outside this list is a coined term;
  see the *Never* list. The standard splits them into inherent, system-dependent, and both — that
  split is **not** reproduced here, because the sources consulted disagree on where
  understandability sits and the standard text was not read. The split does not affect which name a
  `DAT-NNN` row carries; see the stamp below before citing conformance.
- **`Tolerance` is a business tolerance**, not a technical one: *"a closure timestamp is accurate to
  the calendar day, beyond which the monthly boundary is wrong"* — never *"timestamp precision
  ≤ 1s"*. `language.md` § *Demand, not design* applies unchanged.
- **`Source` is `[TBD]` until confirmed.** Nominating a system as the book of record on drafting
  authority is the most common way this register becomes wrong.

#### Reporting consumer register

Lands at ORD §14.1. **No ID — the consumer name is the key**, on the same reasoning as the
operational actor register in `tables.md`: a consumer row identifies a subject and
commits nothing.

| Consumer | Class | Need | Measures used | Impact of this change | Owner |
|---|---|---|---|---|---|
| [named body, team or role] | Regulatory / Contractual / Operational / Management / Executive / Audit | [what they use the figure for] | [ORD-NNN, …] | [what moves for them, or "none — confirmed"] | [named, or TBD with confirm-by] |

#### Measure definition

Lands at ORD §14.2, one row per reported measure, keyed by the register row it details. **A
definition, not a commitment** — the binding statement is the `ORD#` row, so this carries no
priority, status or owner of its own.

| ORD# | Measure | Population | Clock | Rule set | Lineage | Correction path | Dimensions |
|---|---|---|---|---|---|---|---|

### Reconciliation

Where a measure is reported against an obligation, the document establishes — as `BRL-NNN` rules in
§13 (governance and classification groups), cited by the register row that states the outcome:
the **source population**; the **included**, **excluded** and **exception** populations; **duplicate
and omission control**; **record-level** and **aggregate** reconciliation; **variance treatment**;
and **restatement treatment**.

**A report is not represented as reconciled while unresolved variances remain**, unless an approved
tolerance explicitly permits it — and that tolerance is itself a register row with a named approver,
never an assumption.

### Competing methodologies

Where current operational practice differs from contractual, regulatory or documented reporting
practice, **both methodologies are preserved**. The document does not choose.

- Record each method and the decision criteria that distinguish them.
- Raise a decision item via `/raid add decision` and cite the `D-NNN` — this document never mints a
  decision ID.
- Identify the requirements and reported outcomes each method affects.
- Where interim direction has been given, record the approved interim method **and** the fact that
  it is interim.
- State the migration and historical-comparability consequence of each option.
- Where the difference is material to a reported figure, carry a comparison scenario under
  `tables.md` § *Scenario*.

**A methodology conflict is never recorded as an assumption.** An assumption is a thing believed
true pending confirmation; a live disagreement between two documented practices is a decision
somebody owns, and filing it as an assumption removes the owner.

### Standards of record

| Standard | Status here |
|---|---|
| **ISO/IEC 25012:2008** | Data quality model — fifteen characteristics. The taxonomy for `DAT-NNN` rows. Same SQuaRE series as ISO/IEC 25010:2023. Australian adoption: **AS/NZS ISO/IEC 25012:2013**, identical, reconfirmed 2024. |
| **ISO/IEC 25024:2015** | Data quality measurement. The measurement side of 25012. Australian adoption: **AS ISO/IEC 25024:2019** — **AS**, not AS/NZS. The series is not uniform; check each designation rather than pattern-matching off its sibling. |
| **ISO/IEC 20000-1:2018** | IT service management, third edition. **Clause 9.4 Service reporting** is the source of the service-reporting obligations behind report timeliness and availability rows — but the 2018 edition deliberately moved the detailed reporting requirements out of that clause and into the clauses where the reports are produced, so 9.4 is the hook and not the whole obligation. Amended by **ISO/IEC 20000-1:2018/Amd 1:2024**. Australian adoption: **AS/NZS ISO/IEC 20000.1:2019** — note the **dot** in the part number — reissued November 2024 incorporating Amendment No. 1. |
| **ISO/IEC/IEEE 29148:2018** | Unchanged. Only the evidence satisfying *verifiable* is elaborated here. |
| **OMG DMN 1.5** | Decision model and notation. §5.3.1 and clause 7 supply the decision / decision-logic separation the `BRL-NNN` register uses. 1.5 (August 2024) is the current formal version; 1.6 and 1.7 are beta and are not cited. |
| **OMG SBVR** | Semantics of business vocabulary and business rules. The vocabulary source where a rule needs one. |
| ISAE 3402 / ASAE 3402 | Assurance over service-organisation controls. **Not a requirements standard.** The reconciliation discipline above is drawn from control practice and is cited as practice, never as an obligation this file imposes. |
| DAMA-DMBOK, BABOK v3 | Practitioner bodies of knowledge. Useful as checklists; neither is cited as the authority for a requirement. |

#### Verification stamp

**Verified 2026-09-07 by Glen Sanders.** The four claims below were previously recorded as adopted
from knowledge and unchecked. Two are now confirmed against the publisher's own text; two rest on
national-body and distributor records because the ISO texts are paywalled and were not purchased.
Following `ai.md`'s convention, **what was not read is recorded as plainly as what was** —
this stamp narrows the gap and does not close it.

| Claim | Status | Checked against |
|---|---|---|
| ISO/IEC 25012 defines the data quality characteristic names used by `DAT-NNN` | **Verified — secondary sources only.** Fifteen characteristics; all names used in this file are among them | ISO catalogue abstract; a peer-reviewed application of 25012; the OMG DIDO wiki entry; iso25000.com |
| An AS/NZS adoption of ISO/IEC 25012 exists | **Verified — it does.** `ai.md`'s rule bites: **AS/NZS ISO/IEC 25012:2013**, identical adoption, current and reconfirmed 2024 | Standards Australia distributor record; corroborated by the scope statement of AS ISO/IEC 25024:2019, which names AS/NZS ISO/IEC 25012 as the source of the characteristics it measures |
| ISO/IEC 20000-1:2018 carries the service-reporting clauses attributed to it | **Verified — primary text.** Clause **9.4 Service reporting**, under clause 9 Performance evaluation. The foreword's change item (j) records that detailed reporting requirements were moved out of the service reporting clause into the clauses where the reports are produced | ISO's own redline preview of ISO/IEC 20000-1:2018 — table of contents and foreword |
| DMN's decision / decision-logic separation matches the `BRL-NNN` `Required Decision` and `Rule` columns | **Verified — primary text.** DMN §5.3.1 defines a decision as *the act of determining an output value from a number of input values, using logic defining how the output is determined*; clause 7 defines how the decision requirements level and the decision logic level relate. `Required Decision` states the first; `Rule` states the second in business terms, and implementation of the logic stays with the design response | OMG DMN 1.5 specification, §5.3.1 and clause 7 |

**What was not read.** ISO/IEC 25012:2008, ISO/IEC 25024:2015 and the body of ISO/IEC 20000-1:2018
are paywalled and were not purchased. Three consequences, none of them cosmetic:

1. **25012's normative definitions were not read** — only the characteristic *names* are
   corroborated. A `DAT-NNN` row naming a characteristic is safe from coining; a row asserting what
   that characteristic *means* is not yet grounded.
2. **The inherent / system-dependent / both split is unresolved.** Sources consulted disagree on
   whether *understandability* falls in the system-dependent group or the both group. The split is
   not reproduced in the `DAT-NNN` schema, so nothing in this file depends on it — but a document
   that reproduces the split is asserting something this stamp does not cover.
3. **Only 20000-1's front matter was read**, not clause 9.4's requirements. That the clause exists
   and is named *Service reporting* is confirmed; what it demands, in terms, is not.

**Still true, unchanged:** read the 25012 characteristic list before a document claims conformance
to 25012 or 25024.

**Two findings that were not claims and are recorded because they change what a document cites:**

- **ISO/IEC 20000-1:2018 has been amended** — `/Amd 1:2024`. A document citing the 2018 edition bare
  is citing a superseded state of the text.
- **The Australian designations are not uniform.** `AS/NZS ISO/IEC 25012:2013` and
  `AS/NZS ISO/IEC 20000.1:2019` are joint; `AS ISO/IEC 25024:2019` is Australian only. The
  20000 series uses a **dot** before the part number where the ISO original uses a hyphen. Each
  designation is checked, never inferred from its sibling.

- **Owner:** **Glen Sanders**, as maintainer of this ruleset.
- **Re-verify:** on any amendment or new edition of 25012, 25024, 20000-1 or DMN; before any
  document authored under this file claims conformance to 25012, 25024 or 20000-1; and at minimum
  annually. **Next due 2027-09-07.**

### Never

- Never state a reported measure without its population — "all relevant records" specifies nothing.
- Never state a measure without naming the rule set version that produced it.
- Never state an elapsed measure without its start event, its stop event and its excluded durations —
  an unstated exclusion makes the figure unreproducible by anyone who did not compute it.
- Never state a period measure without its cut-off and the treatment of data arriving after it.
- Never express a period in business days without its timezone and its holiday jurisdiction.
- Never nominate a system or dataset as authoritative unless the source material confirms it.
- Never represent a report as reconciled while unresolved variances remain, absent an approved
  tolerance carried as its own row with a named approver.
- Never omit the correction path because the figure has not yet been wrong.
- Never record a methodology conflict as an assumption — it is a decision, and it has an owner.
- Never choose between competing methodologies without decision authority.
- Never mint a `D-NNN` here — `/raid` owns the decision namespace.
- Never coin a data quality term where ISO/IEC 25012 supplies one — there are fifteen names and
  the register bullet lists all fifteen.
- Never cite an ISO designation alone where an AS or AS/NZS adoption exists — an Australian auditor
  asks for the AS number, and the designations in this series are not uniform.
- Never cite ISO/IEC 20000-1:2018 without its Amendment 1:2024.
- Never state a technical data tolerance where a business one belongs (see `language.md`).
- Never add a §7 subsection for reporting — these are ordinary requirements in existing subsections.
- Never write the five-part measure definition into a register row — the row states the outcome and
  the §14.2 definition carries the five parts.
- Never mark a data element `Existing — confirmed` without source confirmation.
- Never infer a reporting consumer the source does not evidence — raise the class at the gate.
- Never cite ISAE/ASAE 3402, DAMA-DMBOK or BABOK as the authority for a requirement.


---

## `llm-companion.md`

> Governs the **machine-readable companion** a requirements skill writes beside the document it
> authors. Applies to `/write-brd` and `/write-ord`. Pairs with `language.md` and
> `tables.md`, neither of which is relaxed here. Read the scope boundary in
> `README.md` first.

### What it is

The document a skill writes — `docs/brd/[change-name]-BRD.md`, `docs/ord/[system-name]-ORD.md` — is
written for a human reviewer. The companion is the **same content restructured for a language model**
to consume: pasted into a prompt, attached to an agent, or chunked into a retrieval index.

It is written to the same folder, with `.llm` before the extension:

| Document | Companion |
|---|---|
| `docs/brd/[change-name]-BRD.md` | `docs/brd/[change-name]-BRD.llm.md` |
| `docs/ord/[system-name]-ORD.md` | `docs/ord/[system-name]-ORD.llm.md` |

**The document is reviewed; the companion is not.** Review, sign-off and every gate read the
document. The companion is regenerated from it and carries no standing of its own.

### The Rule

**The companion is a view of the saved document. It adds no value, drops no row, and rewords
nothing.**

Everything a reviewer approved must reach the model unaltered, and nothing the reviewer did not see
may reach it at all. A companion that summarises is a second author; one that fills a gap is an
invented figure delivered to the reader least able to spot it.

Three things follow:

1. **Generate from the saved document alone** — never from the source material, the Phase 1 summary
   or the conversation. Anything true of the change but absent from the document is absent from the
   companion.
2. **Copy values verbatim.** Restructuring is permitted; rewording, summarising, merging and
   correcting are not. A defect in a value is fixed in the document and the companion regenerated.
3. **Every row survives.** Each table row in the document appears in the companion exactly once, and
   the count is reported.

The only text the companion carries that the document does not is the fixed **How to read** block
and the **Vocabulary** definitions below — both addressed to the consuming model, both defined here,
and neither carrying a requirement.

### Generating it

**The companion is generated by script, not written by hand.** `/write-ord` ships
`scripts/llm_companion.py`, which implements this file; `/write-brd` runs the same script from
`../write-ord/scripts/`. Standard-library Python 3.8 or later:

```bash
python3 scripts/llm_companion.py docs/ord/[system-name]-ORD.md --generator "/write-ord [version]"
```

A model asked to copy a thousand lines verbatim will reword some of them, and neither the model nor
its reader can see which. The script copies by construction and then proves it — the integrity check
below — so a companion that exists is a companion that passed.

**Exit 1 means refused, and nothing is written.** The reason names the first value that failed to
arrive or the row count that did not reconcile. Fix the document, or report the refusal; never
replace a refused companion with a hand-written one.

**Where no Python is available**, write the companion by hand to this file, run the integrity check
by hand, and say in the closing summary that the check was manual. A hand-written companion is the
fallback, never the default.

### Why a separate file

A requirements document is optimised for a reviewer: wide tables, cross-references by section
number, traceability in an appendix, and gaps recorded where they arise. Each of these costs a model
accuracy:

| Reviewer form | What a model loses | Companion form |
|---|---|---|
| A nine-column table | Which header a cell belongs to, once the row is far from the header | One record per row, each value labelled with its column |
| Traceability held once, in an appendix | The link, when the record and the appendix land in different chunks | The trace folded into the record it describes |
| `[TBD]` scattered through the body | That a gap exists — the model fills it from its own knowledge | Every gap indexed up front, and an instruction not to fill it |
| House vocabulary — `Assumed`, `[AI]`, KPP, `Sunny Day` | Its meaning; the model guesses | The terms this document uses, defined once |
| Section numbers as the only address | A stable citation | Every record keyed by its ID |

### Structure

Five sections, in this order, after YAML front matter.

#### Front matter

```yaml
---
doc_id: ORD-NNN or BRD-YYYY-NNN
doc_type: ORD | BRD
title: [document title, verbatim]
version: [document version]
status: [document status, verbatim]
tier: [ORD only — the document tier from the header]
companion_of: [file name of the document, relative to this file]
source_sha256: [SHA-256 of the saved document, or "unavailable"]
generated: YYYY-MM-DD
generator: [/write-brd or /write-ord, with the skill version]
authoritative: false
---
```

`source_sha256` is computed from the saved file — the script does it; by hand, `shasum -a 256` or
`sha256sum`. Where neither is available, write `unavailable`; never estimate or invent one. It is
how a later reader detects a companion gone stale against an edited document.

A field the document does not state — an ORD carries no Doc ID — reads `"[not stated in document]"`.

#### 1. How to read this document

Copy this block verbatim, substituting only `[BRD|ORD]`, the document file name and the doc ID —
or the document's title, where it carries no Doc ID.

```markdown
## 1. How to read this document

This file is a machine-readable view of [BRD|ORD] [doc_id], generated from `[file name]`. It is
not authoritative. Where this file and that document differ, the document is correct and this file
is stale; `source_sha256` in the front matter identifies the exact document version it was
generated from.

- Every record is keyed by a stable ID. Cite IDs, never section numbers or paraphrase.
- Values are copied verbatim from the document. Treat each value as a statement of fact about the
  delivered end state, exactly as worded.
- `[TBD]`, `Unowned — open` and every item listed in section 3 are unanswered questions. Do not
  fill, estimate, infer or default them. Where a task depends on one, name the item and stop.
- A value marked `Assumed` or `Provisional` is not yet agreed. Do not present it as committed.
- This document states business demand. It does not state, and must not be read as implying, a
  technical design, architecture, product, vendor or engineering target.
- Section 4 is narrative context. Section 5 holds the binding statements.
```

The block is instruction prose addressed to a model, not requirement content — the modal and
construction bans in `language.md` govern the records, not this block.

#### 2. Vocabulary

**Only the terms this document uses.** For each ID prefix, `Status` value, scenario value, marker
(`[AI]`, `[KPP]`, `[TBD]`, `[EVL-TBD]`, `[D-TBD]`) and enum that occurs in the records, one line
giving its meaning, taken from `tables.md`, `ai.md` or `reporting.md`.
A term that does not occur is not listed.

#### 3. Open items

One line per unanswered item, in document order, each naming the record or section it sits in:

- every `[TBD]`, `[EVL-TBD]`, `[D-TBD]` and `[SYSTEM-NAME-TBD]`, with its owner and date where the
  document gives them
- every `Unowned — open` row
- every `Assumed` or `Provisional` requirement, and every `Unvalidated` or `Falsified` assumption
- every coverage gap and every referred requirement with `Resolver group: None in chain`
- every open question, every dependency not `Met`, and every conformance still `pending`
- every prose sentence declaring a gap, carrying a `[TBD]` or leaving a placeholder such as
  `[name]` — **quoted whole**, never paraphrased

A BRD with no Doc ID lists that too; an ORD does not, because the ORD standard defines none.

Where there are none, write `None.` — never omit the section. An empty index and a missing one are
different claims.

#### 4. Context

Every prose section of the document, **copied verbatim** under its original number and heading, in
document order. Prose is not condensed: a summary is a reworded source.

#### 5. Records

One block per table row, grouped under a `### Table:` heading per table in document order. From the
pack's worked ORD:

```markdown
#### ORD-03 — Apply an owed rebate within two billing cycles

- table: 3.2 Reliability
- ref: ORD-03
- ver: 1.0
- requirement_title: Apply an owed rebate within two billing cycles
- business_tolerance: A rebate owed under clause 14.3 is applied within two billing cycles of the missed appointment. Threshold: two cycles. Objective: one cycle
- kpp: [KPP]
- status: Provisional
- owner: GM Billing
- source: Consumer contract cl. 14.3
- referenced_by: OBJ-01, SCN-01, SCN-02, SCN-03, SCN-04
- traceability:
  - ord_ref: ORD-03 [KPP]
  - business_tolerance: Rebate applied within two billing cycles
  - traces_to_brd_objective_via_business_requirement: §4 BO-1, via §8 BR-1
  - orphan: No
```

- **The key is the row's ID.** An ID-less row — an actor, a constraint, a coverage gap, an
  exclusion — is keyed by its table's first column, prefixed with the section number.
- **Field names are the document's column names** in lower snake case. Every column is written,
  including one the document leaves blank: `(blank in document)`. A missing field reads as a
  column that does not exist.
- **A table keyed by another record's ID is folded into that record**, never emitted as a second
  record under the same ID — traceability (ORD §11), interface detail and SOAP conformance
  each become a sub-list named for their table, every column included. A record with no row in a
  folded table says so: `traceability: (no row in document)`. A fold adds structure, never a value.
- **Every ID-keyed record carries `referenced_by`** — the IDs of other records whose cells name it:
  the objective it serves, the scenarios that examine it, the assumption it rests on. A link read
  from the document, never a value.
- **View tables are not emitted.** A table whose lead-in declares it a view — *"View of …"*,
  *"adds no new commitments"* — restates IDs it does not own. Name each omitted view in one line at
  the head of section 5.
- **Plain text only.** No HTML, no emoji, no decorative glyphs, no merged or multi-line cells. A
  glyph the document uses to mark meaning becomes words: ★ on a BRD section becomes
  `[often-missing section]`, which is what the BRD standard marks it for.

### Integrity check

Two checks, both before the companion is saved:

1. **Rows reconcile.** Table rows in the document equal records, plus rows folded into another
   record, plus rows of omitted views.
2. **Everything arrived.** Every prose line, and every data cell outside an omitted view, appears in
   the companion.

Either failing, the companion is not saved. Report the script's line in the skill's closing summary:

> `Companion: docs/ord/[name]-ORD.llm.md — 84 rows, 74 records, 7 folded, 1 view(s) omitted (3 rows), 25 open items.`

### Regeneration

**The companion is regenerated every time the document changes** — never edited by hand. Both
skills accept `--llm-only [document path]`, which reads an existing document and rewrites its
companion without running any phase. A companion whose `source_sha256` does not match its document is
stale, and the fix is regeneration, not an edit.

### Never

- Never generate the companion before the document is saved, or from anything but the saved file.
- Never hand-write a companion where the script can run, and never replace a refused one by hand.
- Never reword, summarise, merge, correct or reorder a value's content — restructure only.
- Never fill a `[TBD]`, an owner, a date or a blank cell in the companion. A gap is carried and indexed.
- Never add a value, a requirement, a link or a claim the document does not carry.
- Never drop a row. Rows and records reconcile, or the companion is not saved.
- Never carry gate verdicts, review findings or the Phase 1 summary — they are not in the document.
- Never hand-edit a companion, and never treat one as the reviewed artefact.
- Never estimate `source_sha256` — compute it, or write `unavailable`.
- Never emit a view table as records — name it and omit it.
