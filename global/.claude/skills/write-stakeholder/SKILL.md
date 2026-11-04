---
name: write-stakeholder
category: pipeline
standalone: true
description: Add stakeholder requirements to an existing BRD — operational accountabilities, high-level business rules, business policies and compliance mandates, written system-neutral in a strict declarative blueprint, anchored to business capability and process-step headings, with SR-[DOMAIN]-[PROCESS]-NNN IDs, versioned anchors to externally mastered rules, and baseline appendix tables for anything un-mastered. Writes its own -SR.md file beside the BRD from /write-brd-v2, which it reads and never edits — the requirements, a routing register for every statement it declines, and traceability in both directions. Use when a BRD needs its stakeholder requirements, or when /write-stakeholder is run.
---

# Write Stakeholder Requirements

Generate operational accountability frameworks, high-level business rules, business policies and
compliance mandates, **completely independent of technical solutions**. Anchor every requirement to a
clear business capability and process lifecycle, to eliminate documentation sprawl and expose gaps.

It does not describe solution design.

Execution mode: **[HITL]** — elicit one question at a time, then write a separate `-SR.md` file
behind a confirmation gate.

**Where this sits** (context for the author, not part of the output):

| Step | Activity | Skill |
|---|---|---|
| 1 | BRD created — usually already done, and the primary input | `/write-brd-v2` |
| 2 | Stakeholder requirements and traceability, in a separate `-SR.md` file | **this skill** |
| 3 | Business solution requirements — functional and non-functional | `/write-prd`, `/write-ord` |
| 4 | Technical specifications — SOAP, SAR, technical epics | downstream |
| — | Readiness review of both files for ORD development | `/review-brd-v2`, after this skill |

**Authoring standards** — `~/.claude/standards/requirements/language.md` and `tables.md`. This skill
is stricter than `language.md` on modals and adds its own ID form; both are recorded deviations (see
Rules).

---

## Inputs read from the BRD

Read `docs/brd/[change-name]-BRD.md` in full before anything else. This skill **reads** the sections
below and never rewrites them:

| BRD section | Used for |
|---|---|
| §2.1 Objectives | Every requirement traces to a `BO-N` |
| §3 Stakeholders | Every requirement names the stakeholder whose need it is |
| §4 Scope | A requirement outside In Scope is flagged, never written |
| §5 Design Principles & Constraints | A requirement restating a principle or constraint is removed |

Where a new fact belongs in one of those sections — a stakeholder missing from §3, a boundary missing
from §4 — raise it at the confirmation gate for the author to add. Never edit those sections from
here.

---

## Process

1. **Map the domain context.** Identify the overarching business capability (Governance, Billing,
   Order Management…) and the process step or lifecycle stage (Triage New Case, Reporting…) being
   analysed. Align to company or industry conventions. Each becomes a heading.
2. **Isolate core entities.** Identify the business roles, data assets or operational actors
   governed within that context.
3. **Apply the blueprint formula.** Construct each requirement line from the declarative blueprint
   below.
4. **Audit for solution fluff.** Strip software-centric vocabulary ("system", "button", "screen") and
   passive capability loopholes ("must be able to"). Run the paper process test on every row.
5. **Link out reference assets.** Reference externally mastered policy libraries by a versioned
   anchor, or map un-mastered criteria into a baseline appendix table.
6. **Codify with taxonomy IDs.** Assign `SR-[DOMAIN]-[PROCESS]-NNN`.
7. **Trace.** Write the traceability section — each requirement to the `BO-N` it serves and the stakeholder who holds it,
   and each `BO-N` onward to the ORD tolerance expected to quantify it, leaving an explicit blank
   where none exists yet.
8. **Confirm, then write.** Present the requirement tables, the routing register and the traceability
   rows, and wait for confirmation. Then write `docs/brd/[change-name]-SR.md`, assigning its Doc ID
   `SRD-YYYY-NNN` and recording the BRD's Doc ID in `brd` and its `Version` in `brd_version`. Never edit the BRD. After saving, name
   `/review-brd-v2` as the next step.

---

## Rules

### The paper process test

Every requirement stays system-neutral. **If the rule cannot be executed manually through a paper
folder or an email Work Instruction (WI), it is a solution specification, not a stakeholder
requirement.** Route it (see *Routing register*).

### The blueprint formula

Every statement body maps exactly to:

```
[Business Entity/Role] + [is / are / retains / provides / is accountable for]
  + [Mandatory State or Condition] + [to ensure / so that] + [Business Outcome].
```

- **Pure declarative voice.** Present tense, stated as fact.
- **Banned in the statement:** `must` · `should` · `shall` · `can` · `could` · `would` · `may` ·
  `might` · `able to` · `require` · `requires` · `need` · `needs`. Write "All historical data is
  consolidated", never "All data must be consolidated"; write "the entity is populated with data",
  never "the entity requires data".
- **Never write** "the system", "the platform", "the application", a product name or a UI component.
- The `[to ensure / so that]` clause is mandatory. Where the source gives no outcome, ask for it.

### Taxonomy structure

- Requirements sit under Markdown headings: `###` for the business capability or domain, `####` for
  the process step or sub-capability.
- IDs follow `SR-[DOMAIN]-[PROCESS]-[3-digit sequence]` — `SR-OPS-TRIAGE-001`. `DOMAIN` and `PROCESS`
  are short upper-case codes matching the headings. Sequences restart per process step, and a retired
  ID is never reused.

### Rule and attribute isolation

- **Never quote fluid tables, business-rule parameters or regulatory clauses inline.** Reference the
  governing document by a **versioned context snapshot anchor** — "…in accordance with Business Rule
  Matrix v2.3".
- **Never list data elements, classifications or entities inline.** Reference a baseline appendix
  table by its anchor — "Attributes listed in Appendix BRM-TU-02".
- **Specific anchor labels.** The bold label before each reference names the aspect it governs —
  "Ticket selection criteria", "Evidence categories". Never use "Governed by:", "Reference:",
  "Source:" or "Policy Linkage:".
- **Never invent a document ID or version.** An external document whose ID or version is unknown is
  anchored as `[TBD — @owner, YYYY-MM-DD]`.

### Architecture-free guardrail

Requirements dictate operational policies and business mandates, not software architecture. Never
prescribe data aggregation schemas, parent/child record structures or system boundaries. Focus on
accountabilities and operational limits.

### Testable

Every requirement gives a point that can be demonstrated in Business Readiness Testing (BRT) or a
Go/No-Go operational review.

### Priority

`Priority` is MoSCoW — **Must**, **Should**, **Could** or **Won't**. These are controlled values in a
column, not modals in the statement, and are permitted. Never leave the cell blank: an unknown
priority is `[TBD — @owner, YYYY-MM-DD]`.

### Single source of truth

- A requirement that restates an objective, a scope row, a design principle or a constraint is
  removed.
- A rule, threshold or attribute list is stated once — in its appendix table or its external master —
  and every requirement that relies on it cites the anchor.

### Routing register

What this skill declines to carry is **recorded, not dropped**. No document downstream catches a
discarded statement.

| Statement raised | Type | Routed to |
|---|---|---|
| "[quoted as raised]" | Solution — functional | PRD |
| "[quoted as raised]" | Solution — non-functional | ORD, as a business tolerance |
| "[quoted as raised]" | Business rule | Baseline appendix table, or its external master |

### Sourced content only

- **Never invent a figure, owner, date, document ID or version.** Write `[TBD — @owner, YYYY-MM-DD]`,
  or `[TBD — Unowned]` where nobody will close it.
- Output only the requested content. Never add narrative or reasoning, and never name or cite
  informal sources — transcripts, chats, emails.

### Recorded deviations

| From | Deviation | Why |
|---|---|---|
| `language.md` modal ban | Also bans `must`, `shall`, `require(s)`, `need(s)` in statements | Declarative voice leaves no slot for an obligation verb |
| `tables.md` ID namespaces | `SR-[DOMAIN]-[PROCESS]-NNN` encodes a theme, and replaces `BR-N` | IDs carry their capability and process for navigation. Needs an ADR before this skill is registered |
| BRD standard stakeholder form | "[Stakeholder] requires [outcome]" becomes the blueprint; the stakeholder moves to traceability | The governed entity leads the sentence; who holds the need is a trace |

---

## Output format

Written to its own file, `docs/brd/[change-name]-SR.md`, beside the BRD it reads. The BRD's §8 and
§9 already point here; this skill never edits the BRD.

```markdown
---
status: Draft
doc_id: SRD-YYYY-NNN
brd: BRD-YYYY-NNN
brd_version: "[the BRD's Version when this file was written]"
Author:
Version: "0.1"
---
# <Project Name> Stakeholder Requirements

Stakeholder requirements and traceability for BRD-YYYY-NNN, `[change-name]-BRD.md`.

## 1 Stakeholder Requirements

### [Business Capability / Domain name]
[Optional one-line description of the domain's scope.]

#### [Process Step / Sub-capability name]

| ID | Title | Requirement | Priority |
|---|---|---|---|
| SR-[DOM]-[PROC]-001 | [Noun-phrase capability title] | [Entity/Role] [is/are/retains/provides/is accountable for] [state or condition] [to ensure / so that] [business outcome].<br><br>**[Specific aspect governed]:** [versioned anchor to an external master, or to an appendix table] | [Must/Should/Could/Won't] |

## 2 Routing Register

| Statement raised | Type | Routed to |
|---|---|---|

## 3 Traceability

### 3.1 Stakeholder requirement to objective

| SR | Objective | Stakeholder (BRD §3.2) |
|---|---|---|
| SR-[DOM]-[PROC]-001 | BO-N, or **none — unfunded** | [team/function from BRD §3.2] |

### 3.2 Objective to ORD tolerance

| Objective | Stakeholder requirements | ORD tolerance |
|---|---|---|
| BO-N | [SR IDs, or **none**] | [ORD-TBD — written back by /write-ord] |

## Appendix [BRM-XX-NN] — [Baseline table title]

**Version:** [v1.0] · **Owner:** [@owner] · **Authority:** [Approved, or Working draft]

| [Attribute / criterion] | [Definition] |
|---|---|
```

- `brd` carries the Doc ID of the BRD this file belongs to, and is what `/review-brd-v2` matches on.
- `brd_version` records the BRD version this file was written against. A BRD revised afterwards
  shows as stale at review.
- Every `BO-N` in the BRD has a §3.2 row, including those no requirement serves.
- The anchor label line is optional and appears only where a rule or attribute list is referenced.
- An objective with no requirement, and a requirement with no objective, each keep their row with an
  explicit **none** — the blank row is the finding.

## Master examples

### Case Management & Operations

#### Raise & Triage

| ID | Title | Requirement | Priority |
|---|---|---|---|
| SR-CASE-RAISE-001 | Operational resource allocation | Case management team leaders are accountable for assigning work and managing operational workloads to ensure fair capacity distribution and alignment of staff skillsets. | Must |
| SR-CASE-RAISE-002 | Case information completeness | Targeted Upgrades cases are populated with the complete business information supplied in the originating request, so that case managers hold sufficient context to assess, manage and report on the customer matter.<br><br>**Information captured:** Attributes listed in Appendix BRM-TU-02. | Must |
| SR-CASE-RAISE-003 | Multi-location enterprise support | Multi-site enterprise migrations are tracked at the customer level as well as the site level, so that complex business accounts are visible as a whole. | Should |

### Compliance & Governance

Cross-functional requirements governing safety boundaries, legal mandates and policy enforcement
across the lifecycle.

#### Customer Protection

| ID | Title | Requirement | Priority |
|---|---|---|---|
| SR-GOV-PROTECT-001 | Priority customer protection | Vulnerable Customer (VC) matters are managed exclusively by the specialised PA/VC team to ensure regulatory compliance and specialised care.<br><br>**Vulnerable customer handling obligations:** Regulatory Compliance Code VOL-2026-v4.1, Clause 12.2. | Must |

### Analytics & Performance

Cross-functional requirements governing data visibility, historical tracking and metrics extraction.

#### Operational Reporting

| ID | Title | Requirement | Priority |
|---|---|---|---|
| SR-ANA-REPORT-001 | Operational case context | All historical and active operational information relating to a deferred migration is consolidated, so that caseworkers have complete visibility when making case decisions.<br><br>**Data entities in scope:** Operational Data Dictionary Map ODD-08, v3.0 Baseline. | Must |

---

## Verification gate

Before presenting the confirmation, check every row and fix what fails.

| Check | Fails when |
|---|---|
| **Paper process test** | The rule cannot be run from a paper folder or an email WI |
| **Blueprint** | The statement does not parse as entity + verb + condition + to ensure/so that + outcome |
| **Banned words** | The statement carries a modal, `require(s)`, `need(s)` or `able to` |
| **System-neutral** | The text names a system, application, product or UI component |
| **Isolated** | A rule parameter, clause text or attribute list sits inline |
| **Anchored** | A reference has no version, or carries a generic label |
| **Headed** | A row sits outside a capability and process-step heading |
| **Traced** | A requirement is missing from §3.1, or a BRD `BO-N` is missing from §3.2 |
| **In scope** | A requirement falls outside BRD §4.1 |
| **Not sprawl** | A requirement restates an objective, scope row, principle or constraint |
| **Prioritised** | `Priority` is blank |
| **Nothing dropped** | A declined statement is absent from the routing register |

---

## Failure Modes

| Condition | Behaviour |
|---|---|
| No source information, scenario or operational scope provided | Halt. Ask: "What business domain or operational capability are we writing requirements for?" |
| No BRD exists | Say so and offer `/write-brd-v2`. Without objectives, nothing here can be traced |
| An `-SR.md` file already exists for this BRD | Stop: "Stakeholder requirements already exist at docs/brd/[change-name]-SR.md. Confirm replace, or name the requirements to add." |
| A blueprint part is missing — no actor, or no "so that" outcome | Ask exactly one targeted question for the missing part before writing the row |
| The stakeholder uses UI language ("the user clicks submit to save") | Reverse-engineer the business rule into the blueprint and strip the UI mechanics. Record the original in the routing register. Where the rule is not apparent, check with the user |
| A requirement serves no objective | Keep it in §3.1 as **none — unfunded** and raise it at the gate. Never attach it to the nearest objective |
| A requirement falls outside scope | Raise it at the gate. Never write it, and never widen scope from here |
| The stakeholder holding a need is not in BRD §3 | Raise it for the author to add to the BRD. Never edit the BRD from here |
| A referenced external document has no known version | Anchor it as `[TBD — @owner, date]`. Never assume a version |
| Two sources state the same rule differently | Surface both. Never choose one |
| A requirement could be read two ways with different outcomes | Name the decision hidden in it, and who decides it. Never pick a reading |
