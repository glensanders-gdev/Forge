# review-ord — criteria extract

> **Generated file. Never hand-edit.** Produced by `tools/build-review-criteria.py`
> from the requirements-documents pack, which is the single source of truth for
> everything below. Editing this file puts it out of step with the pack; regenerate
> instead.

**Pack version:** v1.9 · **Pack commit:** `719eecb78e35`
**Generated:** 2026-09-02 · **Content hash:** `d42f01562ab54517`

**Quote the version in every review this extract is used for.**
A reader needs to know which revision was applied — a verdict, and a document
authored to a bar, are only meaningful against a named one, and that is the pack's
own thesis applied to itself.

**Where the live pack is present, it wins.** This extract exists so the skill runs
for someone who does not hold the pack. It is a pinned copy, not an authority: where
it and the pack disagree, the pack is right and this file is stale.

---

<!-- from reference/ord-intake-standard.md -->

### 7.1 Must produce — Definition of Ready

The gate the ORD is assessed against before it is handed to solution architecture. It is the ORD's exit criterion, and it mirrors the BRD's own handoff gate one hop upstream — the BRD standard carries that one, because a document's readiness is its author's to establish.

**Assessed by the convenor before handoff, and the verdict is recorded with the document.**

**What puts an item on the bar.** An item is on the bar where its absence makes the next document — here the SOAP — **unwritable**, not merely less mature. Everything whose absence the maturity tier can absorb is a supporting item. The BRD gate applies the same rule one hop upstream, and the `[TBD]` treatment stated there governs here too: a value is met; a `[TBD]` with a named owner and a date is a declared gap that propagates rather than disappearing; a `[TBD]` without both is an absence.

**This split is a change from v1.2, and it is a change of substance rather than layout.** Until v1.3 all thirteen items sat in one undifferentiated "must produce" list. Six now sit below the bar — data volumes and retention, the assumption register, the named business decision-maker, open questions, dependencies, and the proposed acceptance criterion. The reason is that architecture demonstrably designs without them, whereas it cannot design without the seven above: the six protect the convenor, the chain and the tier declaration, which is a different and lesser claim than making the SOAP writable. **Recorded here because a Definition of Ready that quietly sheds six items is worse than one that never had them.** Reject the split and restore the flat thirteen if you disagree — but not silently.

#### The bar — seven items, and their absence is a refusal

Architecture cannot design against a document missing any of these.

| # | Required | Absent means |
|---|---|---|
| **OH-1** | All nine ISO/IEC 25010 characteristics present, each carrying a status per §5. A characteristic with nothing to state carries an explicit statement | An absent characteristic is invisible to a reviewer and is typically discovered during an incident |
| **OH-2** | Operational scope in **and out**, with the out-list explicit | The most common cause of silent scope growth |
| **OH-3** | **Impact register** — the L4 workflows and systems touched, each row carrying its kind and a **named owner** (§2.3). Identification and routing, never design | Impacts are discovered at cutover by the team that owns the system — the latest and most expensive point to find one |
| **OH-4** | Operational demand quantified as **business tolerance** (§2.1), each traced to a contract, obligation or incident record | A tolerance traced to no consequence is an invented figure. Architecture designs against a number nobody can defend |
| **OH-5** | KPPs tagged, each carrying **threshold and objective** as two labelled values | Threshold/objective collapse, one hop past the convenor's involvement. The KPP intent is lost silently downstream |
| **OH-6** | Regulatory, compliance, security and consumer obligations touched, **named specifically** | The obligation reaches design as a category rather than a clause, and is answered generically or not at all |
| **OH-7** | Traceability from every requirement to a BRD objective, or an **explicit orphan-scope flag** | Nobody can assess downstream impact when the objective changes |

#### Supporting items — absent, these are recorded and drive the tier

| # | Required | Absent means |
|---|---|---|
| **OH-8** | **Assumption register** with owners and confirm-by dates | The maturity tier is not declarable, because the thing it declares is untracked |
| **OH-9** | **Open questions** with owners and due dates | An ORD with zero open questions after a compressed elicitation is more likely concealing them than to have resolved them |
| **OH-10** | Known **dependencies** on other programs, named | A dependency discovered after design sign-off is redesign, not adjustment |
| **OH-11** | Data **volumes and retention** as operational facts — capacity and compliance inputs, not data design | Capacity and retention are sized on assumption |
| **OH-12** | A **proposed acceptance criterion per requirement**, in final form with provenance embedded (§6.2) — supplied whether or not the convenor authors the Capability AC | The provenance is re-derived downstream, or lost |
| **OH-13** | Named **business decision-maker** and their pre-approved decision boundaries | Acceptance of delivered work has no holder other than the author. **This is a Tier 1 control at §8, listed there as one to be established** — its absence is normal today and is recorded rather than treated as an authoring failure |

#### The four outcomes

| Outcome | Condition | What follows |
|---|---|---|
| **Ready for handoff** | OH-1 – OH-13 met, no declared gaps | Handed to solution architecture. §6.3 conformance review scheduled against E7 |
| **Handed off with recorded gaps** | OH-1 – OH-7 met; one or more items outstanding, **each with a named owner and a date** — a declared gap on a bar item, a supporting item outstanding, or both | Handed off. The gaps are recorded under §3.3 and are reflected in the committed maturity tier where they reach a KPP-bearing requirement |
| **Handed off with an unowned gap** | OH-1 – OH-7 met; an outstanding item has **no owner to carry it** | Handed off. The item is recorded under §3.3 and **raised with the approving GMs at sign-off rather than referred, because a referral needs a recipient** (§7.2). It stays open until someone accepts it, and that it stayed open is the finding |
| **Not ready for handoff** | Any of OH-1 – OH-7 absent | Handoff declared not-ready, with the absent items named |

**Where more than one row applies, the outcome is the most serious of them** — the refusal first, then the unowned gap, then recorded gaps. This mirrors the BRD gate one hop upstream, whose worked assessment carries declared gaps and an unowned one together and lands on the third outcome.

**The second row covers a declared gap wherever it sits, including on the bar.** A bar item carrying `[TBD]` with an owner and a date is met *for the bar*, but the document is not gap-free — so it is neither the first outcome nor a refusal. Reading the row as supporting-items-only left that document matching no outcome at all.

The third outcome is not a softer version of the second. An item outstanding *with* an owner is a scheduling problem; an item nobody will own is a finding about the organisation, and §7.2's rule that a referral needs a recipient is what forces it to stay visible instead of being closed by assignment to a group.

**The third outcome requires the Tier 1 control "right to declare an ORD not-ready and refuse handoff" (§8), which this standard states is not currently held.** Where it is not held, the outcome is *recorded* rather than exercised: the document is handed off, the absent bar items are recorded at §3.3, and the accumulation of those records across cycles is the evidence for establishing the control. This is the same position the BRD gate takes one hop upstream, and for the same reason — every mechanism in this standard produces a record rather than exercising a veto, because a record is available to someone holding no authority.

#### What the ORD does not supply

A Capability is refinable only when this content exists too — and **the ORD is not its home.** It belongs to the BRD and to the functional requirements document, and an ORD that absorbs it is mislabelled.

| Content | Home |
|---|---|
| Problem statement and target outcome | **BRD** |
| Business rules and decision logic, including edge cases and exception handling | **Functional requirements** |
| Data entities, ownership and quality expectations | **Functional requirements** |
| Business-observable functional acceptance criteria | **Functional requirements** |

**Where no functional requirements document is produced in the chain** — which is the current position, though the standard for one exists (§1.1) — the right-hand column has no home. In practice one of two things then happens: the ORD silently absorbs functional content and stops being an ORD, or the technology BA infers the business rules during Epic decomposition. The second is the more damaging, because inferred rules are indistinguishable from elicited ones once written into an Epic, and nobody reviews them against a business stakeholder. Where this is the case, apply §7.2 — and note that requirements belonging to non-technology resolver groups fail the same way, for the same reason.

---

<!-- from reference/ord-intake-standard.md -->

### 7.3 Must refuse to produce

1. Solution design — system selection, architecture, integration approach, technology choice
2. **Epic or story decomposition** — this is the boundary itself
3. **Technical targets of any kind** — availability percentages, latency figures, RTO/RPO values, capacity numbers. These are architecture's response to the ORD, not its content (§2.1). Stating one pre-empts the review the document exists to inform
4. Interface and data mapping specifications
5. Estimates and delivery sequencing
6. **"Just write the Epics too while you're there."** The most common breach in this standard, and it invariably arrives framed as a favour. Accepting it merges the requirement author with the requirement decomposer, removes the last remaining separation in the chain, and adds unbudgeted work that no capacity model accounts for.
7. Sole acceptance of delivered work — route through the named business decision-maker

---

<!-- from reference/ord-intake-standard.md -->

## 5. Requirement status taxonomy

**Scope never varies. Maturity does.**

All nine ISO/IEC 25010:2023 characteristics appear in every ORD, without exception. A characteristic with nothing to say carries an explicit status, never an omission — an absent section is invisible to a reviewer and is typically discovered during an incident.

Every requirement carries one of three statuses:

Status describes the maturity of a **business demand statement**, not of a technical threshold — the ORD carries no technical thresholds (§2). The document-level tier that aggregates these statuses is forecast at assignment by §4.7 and continues to move after handoff by §4.8.

| Status | Definition | Evidence required |
|---|---|---|
| **Committed** | The business owner has stated and agreed the tolerance, and it is traceable to an obligation, contract, incident record or explicit business decision | Owner name, date, forum, and the underlying source |
| **Provisional** | The tolerance is derived from something real — an existing SLA, contract, incident history, an analogous service — but no business owner has yet confirmed it applies here | Source citation |
| **Assumed** | No business owner and no documentary source; the figure is a stated assumption | Assumption statement (testable), named owner to confirm, confirm-by date, consequence if wrong |

### The tier rule, stated once

Three things in this standard set a tier, and they are one rule seen at three points in time. Stated together so they cannot drift apart:

| | Rule | When |
|---|---|---|
| **The rule** | The tier is the **weakest status carried by any KPP-bearing requirement** — the KPPs themselves, and the recovery, availability and capacity demands they depend on. A minor attribute at Assumed does not set the tier; a KPP at Assumed does | At any moment |
| **The forecast** | §4.7 predicts that weakest status from size, allocation and available days, before any requirement exists | At assignment |
| **The trajectory** | §4.8 tracks it after handoff as refinement closes assumptions | After delivery |

**"Set by the weakest input" is the forecast, not the rule.** Inputs drive what status the KPPs can reach inside the window; they do not set the tier directly. Where a document's actual KPP statuses disagree with the forecast, the actual statuses win and the forecast was wrong.

**Three statuses, four tiers — the labels do not map one-to-one.** Tiers A, B and C are named for the weakest KPP-bearing requirement status the document carries. **Tier D — Indicative has no counterpart here, and that is the point:** it denotes a document produced without a decision workshop, so no requirement in it has been confirmed by anybody. Its entries are Assumed by status; what Tier D adds is that nobody has seen them. Do not read "Indicative" as a fourth requirement status.

**Rule.** An Assumed entry without an owner and a confirm-by date is not an assumption. It is an invented number, and it is the single largest audit exposure in an ORD. A figure traceable only to analyst judgement is not defensible.

**Rule.** ISO/IEC/IEEE 29148:2018 requires **traceability, not finality**. A TBD with an owner and a date is standards-compliant. A silent gap is not. Declaring an assumption transfers the open item to its named owner; concealing one retains it as the author's defect.

**Rule.** Silence does not constitute agreement for any KPP-bearing requirement. For lesser attributes a disclosed silence convention may be used, provided the convention was stated in advance.

---

<!-- from reference/ord-intake-standard.md -->

### 5.2 KPPs

Key Performance Parameters — requirements whose failure means the system has failed rather than degraded — must be identified by **Day 2**. They cannot be located at write-up, because their purpose is to signal to architecture, early, which demands are the load-bearing ones.

KPPs are stated as **business-failure thresholds**: the point at which the business consequence becomes unacceptable, and what makes it unacceptable — a breached obligation, a contractual penalty, an unrecoverable customer impact. This is what makes a KPP sourceable from contracts and incident history rather than requiring an engineer, and it is why KPP identification is achievable inside a business-side elicitation window.

Where a KPP cannot reach at least **Provisional** within the window, that is the one item that warrants escalation rather than quiet degradation — because it is the demand architecture most needs bounded before it commits to a design.

**Threshold and objective** — the minimum acceptable and the desired — are carried as two labelled figures at every altitude: ORD, Capability acceptance criteria and Epic. Collapsing "restorable within one business day / within four hours" into a single figure is the most common way KPP intent is lost, and it happens silently downstream, after the convenor's involvement has ended.

---

<!-- from reference/ord-intake-standard.md -->

### 2.1 Quantified in business terms, not technical terms

A requirement can be fully quantified and testable — as ISO/IEC/IEEE 29148:2018 requires — without presupposing a design. The discipline is to quantify the **business tolerance**, not the engineering figure that satisfies it.

| Business demand (belongs in the ORD) | Technical target (architecture's response, downstream) |
|---|---|
| An agent must retrieve a customer's account without the customer noticing a wait | Sub-200ms API response, 99th percentile |
| Service must be restorable within one business day; beyond that, obligation X is breached at cost Y | RTO 4h, active-active across two zones |
| No more than one working day of transactions may be lost in any failure | RPO 1h |
| Field technicians must complete a job with no connectivity for up to 30 minutes | Offline cache with conflict resolution on reconnect |

Every left-hand statement is quantified, testable, and traceable to a business source — a contract, a regulatory obligation, an incident cost, a named stakeholder. **None of them requires an architect to write.** That is why this document can be produced by a business-side role without architecture input: the sources are business sources.

**Rule.** Where the ORD states a technical target, it pre-empts the review it exists to inform. This is the same antipattern as a BRD naming a solution (§3.4), one level down: the figure is asserted rather than derived, and architecture's review becomes a ratification of a number a business analyst chose. Supply the demand; let architecture supply the target.

---

<!-- from reference/traceability-matrix.md -->

## The five checks a matrix makes visible

The matrix is not documentation for its own sake — it is a **review instrument**. Each failure is a
specific, nameable defect.

| Scan | Question | A failure means… |
|---|---|---|
| **Baseline gap** | Does every tolerance state the position it improves on? | The tolerance cannot be sized or challenged — and is probably invented |
| **Coverage gap** | Does every business objective trace down to at least one tolerance? | A funded objective with no operational demand stated — it will not be bounded |
| **Conformance gap** | Does every ORD tolerance have a SOAP response answering it? | Demand documented and then not answered — the failure the ORD exists to prevent |
| **Translation gap** | Does every Capability AC carry the threshold *and* the objective from the tolerance it derives from? | Threshold/objective collapse — KPP intent lost silently downstream |
| **Verifiability gap** | Does every Epic AC map to a test? | "Done" is opinion — QA and engineering disagree late |

> **The conformance gap is the one this pack is built around.** An empty SOAP cell against a
> populated tolerance is demand stated and answer outstanding, and it is visible here and nowhere
> else. The translation gap is the second-most valuable: Capability ACs derive from the SOAP rather
> than from the ORD, so a criterion can be well-formed, testable, and still have quietly dropped the
> business threshold it exists to protect.

> **Anti-pattern: duplicating a requirement across columns "to be safe".** A requirement is authored
> in exactly one document; the matrix *links* to it, never restates it. Two copies drift, and which
> one is authoritative can no longer be established.

---

## Keeping it alive

- **IDs are stable and never reused.** A retired requirement's number is retired with it — withdraw
  `ORD-21` and the next requirement is `ORD-22`, never `ORD-21` again. The matrix is only
  trustworthy if an ID always means the same thing.
- **A tolerance changes by version, not in place.** ORD-04 moved from 12 hours to 24 on evidence
  from INC-5012 and became v1.1 — and any Capability AC that had already consumed the original value
  requires review. The matrix is where that consequence is visible.
- **The SOAP column starts empty and stays empty until architecture responds.** An empty cell against
  a populated tolerance is the pack's most useful single indicator.
- **Tests start as `TBD`** and are back-filled when the test plan is written — an empty Test entry
  is a coverage signal, not an error.
- **Appendix A of the ORD carries the BRD-to-tolerance half** and appendix D the conformance half;
  this page is the teaching and whole-chain view. Where the convenor does not hold the pen
  downstream, the right-hand columns are observed rather than authored — and a divergence between
  the Capability AC and the criterion the ORD proposed is exactly what this view makes detectable.
- **Update on every scope change.** A new tolerance with no matrix row is the first sign of demand
  that will not be answered.

---

*Worked example continuous with [BRD-2026-041](#brd) and the [worked example ORD](#example). The
chain and its artefact owners are from [§1 Purpose and the chain](#purpose). Standards: BABOK v3 ·
ISO/IEC 25010:2023 · ISO/IEC/IEEE 29148:2018 (the unadopted functional half).*

---

<!-- from reference/nine-characteristics-quickref.md -->

# Quick Reference — The Nine ISO/IEC 25010:2023 Quality Characteristics

> Desk reference for authoring and reviewing ORDs. Every operational requirement maps to exactly one characteristic below. A characteristic with no requirement is a *deliberate, documented* gap — not an oversight.
> Based on ISO/IEC 25010:2023. ORD template section numbers shown in the right column.

**Read the "typical ORD content" column as subject matter, not as form.** In a **demand-side ORD** — one written ahead of solutioning — each item appears as a quantified *business tolerance*, never as the technical figure that satisfies it. Reliability is *"service restorable within one business day, beyond which obligation X is breached"*, not *"RTO 4h"*. The figures named below are what the SOAP derives in response, and stating one in the ORD pre-empts the review the document exists to inform.

Where the design already exists and the ORD documents a service in or entering service, the technical figures are the appropriate content. Establish which you are writing first — the test is in the requirement-to-section map.

| # | Characteristic | Answers | Sub-characteristics | Typical ORD content | Template §  |
|---|---|---|---|---|---|
| 1 | **Functional Suitability** | Does it do the right things? | Completeness, Correctness, Appropriateness | Operational scope at go-live; what may be phased | 3.8 |
| 2 | **Performance Efficiency** | Fast & efficient enough? | Time Behavior, Resource Utilization, **Capacity** | Response times, throughput, peak concurrent users | 3.1 |
| 3 | **Compatibility** | Coexists with other systems? | Coexistence, Interoperability | Interface table, protocols, failure-on-integration behaviour | 3.4 |
| 4 | **Interaction Capability** *(was Usability)* | Can users operate it? | Operability, Learnability, Accessibility, Inclusivity, Self-Descriptiveness | Operator training, WCAG compliance, self-service | 3.7 |
| 5 | **Reliability** | Does it stay up? | Availability, Fault Tolerance, **Recoverability**, Faultlessness | Uptime, MTBF, MTTR, RTO, RPO, degraded-mode | 3.2 |
| 6 | **Security** | Is data protected? | Confidentiality, Integrity, Non-repudiation, Accountability, Authenticity, Resistance | Compliance frameworks, encryption, access control, pen-test cadence | 3.3 |
| 7 | **Maintainability** | Changed safely? | Modularity, Reusability, Analyzability, Modifiability | Patch cadence, change windows, observability | 3.6 |
| 8 | **Flexibility** *(was Portability)* | Adapts & scales? | Adaptability, Installability, Replaceability, **Scalability** | Hosting model, elasticity, multi-region, upgrade/rollback | 3.5 |
| 9 | **Safety** *(new top-level, 2023)* | Protects from harm? | Operational Constraint, Risk Identification, Fail Safe, Hazard Warning, Safe Integration | Fail-safe behaviour, hazard alerting — safety-critical only | 3.9 |

## Where KPPs usually live
Key Performance Parameters — requirements whose failure constitutes **system failure** — most often sit under **Reliability** (Availability, Recoverability) and **Performance Efficiency** (Capacity). See `kpp-identification-guide.md`.

## What changed from 2011 → 2023
| Change | 2011 | 2023 |
|---|---|---|
| Top-level count | 8 | 9 |
| New characteristic | — | **Safety** |
| Renamed | Usability | Interaction Capability |
| Renamed | Portability | Flexibility |
| New sub-characteristics | — | Inclusivity, Self-Descriptiveness, Resistance, Scalability |
| Replaced sub-characteristic | Maturity | Faultlessness |
| Replaced sub-characteristic | UI Aesthetics | User Engagement |

## The two sorting tests (when a requirement is ambiguous)
1. **Ownership test** — who approves a change to this requirement? The business that carries the operational consequence → ORD. Product → functional requirements, which **no document in this chain receives**; record and route it rather than absorbing it.
2. **Audience test** — who reads it: engineering to *build*, or ops to *run*? Run → ORD.

*Source: ISO/IEC 25010:2023.*

---

<!-- from reference/kpp-identification-guide.md -->

# KPP Identification Guide

> How to find and tag Key Performance Parameters in an ORD. The standard requires at least one KPP to be designated (or an explicit note that none are).

## Definition
A **Key Performance Parameter (KPP)** is a requirement whose failure constitutes **system or program failure** — regardless of how well everything else performs. KPPs answer: *"If we miss this, is the system a failure?"* If yes, it is a KPP.

## The test
For each requirement, ask in order:
1. **Mission-critical?** Would missing this threshold make the system unfit for its core purpose?
2. **Binary on failure?** Does breaching it cause failure (not just degradation)?
3. **Non-substitutable?** Is there no acceptable workaround or compensating control?

Three "yes" answers → **[KPP]**. Tag it explicitly in ORD §3 with the **[KPP]** marker.

## Defect vs system failure — the distinguishing line
| Symptom | Classification | Why |
|---|---|---|
| A monthly report renders slowly | Defect (missed target) | Annoying, not fatal; system still does its job |
| A payment is silently lost | System failure | Violates the system's core purpose |
| Login takes 4s instead of 2s | Defect | Degraded, still operable |
| Data centre outage exceeds RTO with no failover | System failure | Business cannot operate |

Only the second kind earns a **[KPP]** tag.

## Where KPPs cluster (by 25010 characteristic)
- **Reliability → Availability** — e.g. *99.99% uptime* for a trading or payments platform.
- **Reliability → Recoverability** — e.g. *RPO = 0 (zero data loss)* for financial transactions.
- **Performance Efficiency → Capacity** — e.g. *must sustain 10,000 concurrent users at peak* for a system whose purpose is mass access.
- **Security** *(occasionally)* — e.g. a regulatory control whose breach shuts the service down (a compliance KPP).
- **Safety** *(safety-critical systems)* — e.g. *must fail to a safe state within 200 ms*.

## State a KPP as a business-failure threshold, not as a technical target

**This is the single most common defect in KPP authoring.** In a demand-side ORD the KPP states *the point at which the business consequence becomes unacceptable, and what makes it unacceptable* — a breached obligation, a contractual penalty, an unrecoverable customer impact. The engineering figure that satisfies it is derived in the SOAP.

Writing it this way is what makes a KPP sourceable from contracts and incident history rather than requiring an engineer, and it is why KPP identification is achievable inside a business-side elicitation window.

| Business-failure threshold — the KPP | Technical target derived from it — **not** the KPP |
|---|---|
| A payment accepted from a customer is never lost, at any volume | RPO = 0 for transaction records |
| Payment acceptance is unavailable for no more than the period beyond which merchant agreement clause X is breached | 99.99% monthly availability |
| Enrolment is completed by every applicant within the published enrolment window | Peak capacity 10,000 concurrent users |
| Service is restored within one business day; beyond that, obligation X is breached at cost Y | RTO 4h, active-active across two zones |

## Worked examples

| Requirement | KPP? | Reasoning |
|---|---|---|
| A payment accepted from a customer is never lost | **Yes** | A lost payment is unrecoverable harm and violates the core purpose |
| Payment acceptance is available within the tolerance the merchant agreement sets | **Yes** | Sustained unavailability breaches a contract the business is held to |
| Every applicant completes enrolment inside the published window | **Yes** | Failing the peak the service exists to serve is failure, not degradation |
| A monthly report is available without the reader waiting | No | Slow is a defect, still operable |
| Quarterly accessibility audit passes | No | Important compliance, not system-fatal |

## Threshold and objective — two labelled values, always

Every KPP carries **threshold** (the minimum acceptable) and **objective** (the desired) as two labelled figures, at every altitude: ORD, Capability acceptance criteria and Epic.

Collapsing *"restorable within one business day / within four hours"* into a single number is the most common way KPP intent is lost, and it happens silently downstream after the convenor's involvement has ended.

## Authoring rule
- Tag every KPP in ORD §3 with **[KPP]**.
- If genuinely none apply, state explicitly: *"KPPs not yet designated"* — never leave it silent.
- KPPs are identified by **day 2**, not at write-up: their purpose is to signal early to architecture which demands are load-bearing.
- KPPs are the first requirements stakeholders sign off, because they define what "success" means.
- Where a KPP cannot reach at least **Provisional** inside the window, that is the one item warranting escalation rather than quiet degradation.

*Source: ISO/IEC 25010:2023; standard ORD authoring practice.*

---

<!-- from reference/requirement-to-section-map.md -->

# Requirement → ORD Section Map

> Given a raw requirement, where does it go in the ORD? This maps common requirement phrasings to the standard ORD template sections (ISO/IEC 25010:2023). Use it while authoring or reviewing.

**Two ORD models exist, and the scope differs.** Where the ORD is authored on the demand side and **precedes** solutioning, it states quantified *business tolerance* and carries no technical targets, no staffing and no infrastructure — see the ORD Intake and Maturity Standard §2.1 and §2.2, and the out-of-scope rows at the foot of this table. Where the ORD documents a service whose design already exists, technical figures are the appropriate content. Establish which one you are writing before using this map.

## Which model am I writing? The test

**Does architecture's answer to this document already exist?**

- **No — the ORD precedes solutioning.** Demand-side model. State quantified business tolerance; carry no technical target, no staffing, no infrastructure, no support model. Use the template below.
- **Yes — the design is settled and this documents a service entering or in service.** Technical figures are the appropriate content, and the classic template's staffing, infrastructure and support-model sections apply.

Everything below assumes the demand-side model unless a row says otherwise.

## The demand-side ORD section template

Fixed structure. **Section 3 keeps its numbering unchanged**, so every §3.x reference in this map, in the nine-characteristics quick reference and in the traceability matrix continues to resolve.

| § | Section | Contents |
|---|---|---|
| **1** | Introduction | Purpose · the business objective traced from the BRD · operational scope in and **out**, with the out-list explicit · related documents · definitions |
| **2** | Operational concept and impact | 2.1 business context · **2.2 impact register** — the workflows and systems touched, each with kind and named owner · 2.3 entry position record |
| **3** | Operational requirements | 3.1–3.9, one subsection per ISO/IEC 25010:2023 characteristic. **All nine appear**, every time |
| **4** | Operating environment and constraints | Regulatory, contractual and policy constraints carrying operational weight |
| **5** | Operational hours and escalation tolerance | The business tolerance for availability of support — *the tolerance, never the roster* |
| **6** | *Not used* | **Staffing and organisational requirements — out of scope.** Route to the referred requirements register |
| **7** | Service level requirements | The tolerances that carry a contractual or reporting obligation, restated as a view of §3 |
| **8** | *Not used* | **Infrastructure and facilities — out of scope.** Answered in the SOAP |
| **9** | Trade-offs, risk and dependencies | Accepted trade-offs with the business consequence of each · open questions with owner and due date · the dependency register, carrying model and service dependency detail where a component's behaviour is learned or generated |
| **App. A** | Traceability | Every requirement to a BRD objective, or an explicit orphan-scope flag |
| **App. B** | Assumption register | Owners, confirm-by dates, consequence if wrong |
| **App. C** | Referred requirements register | What this ORD will not deliver, and who it went to |
| **App. D** | ORD→SOAP conformance | Completed when the SOAP is issued |

**Sections 6 and 8 are numbered and left empty on purpose.** Renumbering around them would break every existing §-reference, and a declared gap is visible where a silent omission is not — the same rule this standard applies to the nine characteristics, applied to its own template.

## Decision flow
1. Is it a **non-functional, measurable** statement about running the system in production? → it belongs in the ORD (otherwise it is a BRD business need, or functional content — for which no document exists in this chain; record and route it).
2. Map it to its **ISO/IEC 25010 characteristic** (see `nine-characteristics-quickref.md`).
3. Drop it into the matching **template section** below.
4. Write it in **testable form**: quantified threshold + measurement method. If vague, use `[TBD — source: "quoted statement"]`.

## Phrasing → section lookup
| If the requirement mentions… | Characteristic | ORD Section |
|---|---|---|
| uptime, availability %, SLA, MTBF | Reliability | 3.2.1 Availability |
| RTO, RPO, disaster recovery, failover, backup restore | Reliability | 3.2.3 Recoverability |
| behaviour under partial failure, degraded mode | Reliability | 3.2.2 Fault Tolerance |
| response time, latency, P95/P99, throughput, TPS | Performance Efficiency | 3.1.1 Time Behavior |
| CPU/memory/storage/network limits | Performance Efficiency | 3.1.2 Resource Utilization |
| concurrent users, peak volume, data growth | Performance Efficiency | 3.1.3 Capacity |
| encryption, data classification, access control | Security | 3.3.1 Confidentiality |
| audit logging, tamper protection | Security | 3.3.2 Integrity / 3.3.3 Non-repudiation |
| MFA, SSO, certificates | Security | 3.3.4 Authenticity |
| pen-test cadence, vulnerability patch SLA | Security | 3.3.5 Resistance |
| HIPAA, PCI-DSS, ISO 27001, SOC 2, FedRAMP | Security | 3.3.6 Compliance Frameworks |
| external system interface, protocol, API integration | Compatibility | 3.4.1 Interoperability |
| shared infrastructure, no harm to co-hosted systems | Compatibility | 3.4.2 Coexistence |
| elasticity, autoscaling, multi-region, growth projection | Flexibility | 3.5.1 Scalability |
| cloud/hosting model, environment portability | Flexibility | 3.5.2 Adaptability |
| deployment, upgrade, rollback | Flexibility | 3.5.3 Installability |
| change window, patch cadence, config management | Maintainability | 3.6.1 Modifiability |
| monitoring, observability, instrumentation | Maintainability | 3.6.2 Analyzability |
| WCAG, assistive technology | Interaction Capability | 3.7.1 Accessibility |
| operator training, time-to-competency | Interaction Capability | 3.7.2 Learnability |
| runbooks, in-system help, documentation | Interaction Capability | 3.7.3 Self-Descriptiveness |
| what functions must exist at go-live | Functional Suitability | 3.8.1 Functional Completeness |
| fail-safe state, hazard alerting (safety-critical) | Safety | 3.9 |
| what support must be able to observe, diagnose and resolve without engineering | Maintainability | 3.6.2 Analyzability |
| operational hours and escalation *tolerance* — the business consequence of a gap | *(business demand)* | 5. Operational hours and escalation tolerance |
| incident severity, response/resolution targets — **as the business tolerance for each**, never the response process | *(business demand)* | 5. Operational hours and escalation tolerance |
| SLA metrics table, breach reporting | *(operational)* | 7. Service Level Requirements |
| accepted trade-offs, assumptions, dependencies | *(operational)* | 9. Trade-offs and Risk |
| which processes or workflows are impacted, and who owns each | *(elicited impact)* | **2.2 Impact register** |
| which systems are impacted, and who owns each | *(elicited impact)* | **2.2 Impact register** |
| **what a workflow or a system becomes** | — | **Not in the ORD** → the design response |
| **business rules, decision logic, edge cases, exception handling** | — | **Not in the ORD** → functional requirements |
| **support tiers, rosters, on-call staffing, helpdesk FTE** | — | **Not in a 25010-anchored ORD** → referred requirements register |
| **roles, FTE, certifications, handover criteria** | — | **Not in a 25010-anchored ORD** → referred requirements register |
| **hosting, hardware, physical security of infrastructure** | — | **Not in a 25010-anchored ORD** → referred requirements register |

## AI components — additional phrasings

> Applies only where a component's behaviour is **learned or generated** rather than specified.
> Background and the standards behind it: `ai-standards-map.md`. **No section is added and none is
> renumbered** — ISO/IEC 25059:2023 extends ISO/IEC 25010:2023 with sub-characteristics, so every
> row below lands in a §3.x that already exists.

| If the requirement mentions… | Characteristic (sub) | ORD Section |
|---|---|---|
| behaviour under unseen, out-of-distribution or adversarial input | Reliability (Robustness) | 3.2 |
| prompt injection, jailbreak, model-specific attack surface | Security | 3.3.5 Resistance |
| accuracy, quality or error rate of a generated output | Functional Suitability | 3.8 |
| difference in error rate between groups or cases — fairness, unfair bias | Functional Suitability | 3.8 |
| behaviour changing as the component learns from data or prior actions | Functional Suitability (Functional adaptability) | 3.8 |
| a user stopping, overriding or correcting the component | Interaction Capability (User controllability) | 3.7 |
| an operator intervening to prevent harm | Interaction Capability (Intervenability) | 3.7 |
| what is disclosed about the component to those relying on it; output labelled as AI-generated | Interaction Capability (Transparency) | 3.7 |
| why a specific output was produced, and to which audience | Interaction Capability | 3.7 |
| a named person able to interpret, override and stop the component | *(business demand)* | 3.7, and the tolerance in 5 |
| inference logging, retention of inputs and outputs for audit | Maintainability | 3.6.2 Analyzability |
| degradation with no code change; re-measurement cadence after a model or prompt change | Maintainability | 3.6.2, with the reporting obligation in 7 |
| provenance, labelling method or licensing of training data | *(constraint)* | 4. Operating environment and constraints |
| reliance on a named external model, version, or provider | *(operational)* | 9. Trade-offs, risk and dependencies |
| **the evaluation set, the scorer and the pass mark** | — | **Not authored in a demand-side ORD** → derived by the design response, recorded at App. D |
| **which model, provider or technique is used** | — | **Not in the ORD** → the design response |

**The last two rows carry the same boundary as an RTO.** On the demand-side model the ORD states
the quantified business tolerance and the response derives the figure:

| Statement | Treatment |
|---|---|
| *"An unsupported claim reaching a customer is unacceptable above X per thousand, because obligation Y"* | **In scope** — a business tolerance, sourced to an obligation |
| *"A generated response a customer acts on is reviewable by a named officer within the complaint window"* | **In scope** — the tolerance for oversight |
| *"Answer quality scores ≥ 4.0 of 5 on the Q2 evaluation set, judged by a calibrated model-as-judge"* | **Out of scope** — the set, the scorer and the mark are the response's to derive |
| *"Retrieval is re-ranked and the model is pinned to version N"* | **Out of scope** — the design's to specify |

_Avoid_: writing a quality threshold with no named evaluation set anywhere in the chain. It is
unmeasurable at verification wherever it sits — the demand-side rule routes it to the response, it
does not excuse it.

_Avoid_: letting non-determinism reintroduce a hedge. `may`, `might`, `should`, `could` and `would`
remain banned in a requirement. **Variability belongs in the threshold, never in the verb.**

## The evaluation threshold — population is demand-side, instrument is response-side

The rows above route the set, the scorer and the pass mark to the design response. That raises the
question the boundary has to answer: **what makes an ORD row verifiable when the instrument does not
yet exist?**

**The ORD names the population. The response draws the set from it.**

| Element | Side | Why |
|---|---|---|
| The class of output that is unacceptable | Demand | The business defines the harm |
| The **population** it is judged over | Demand | The business decides which cases matter |
| The rate, in the business's own consequence unit | Demand | Sourced to an obligation or an incident record |
| The **held-out set** drawn from that population | Response | A sample is a design choice |
| The scorer or judge, and its calibration | Response | An instrument, not a demand |
| The pass mark and the sampling method | Response | Derived from the tolerance, not equal to it |

This is the standard every other requirement in §3 already meets. *"Within two billing cycles"* and
*"per calendar month"* each name a measurement population, and neither names the monitoring tool. A
threshold on generated output is held to that rule, not to a stricter one.

**§3 carries no `Verification` column, so the population belongs inside the tolerance sentence** —
the same place *"two billing cycles"* sits:

| Ref | Ver | Business tolerance | KPP | Status | Owner | Source |
|---|---|---|---|---|---|---|
| ORD-NN | 1.0 | An unsupported claim reaching a customer in a rebate-eligibility answer is unacceptable above 2 per thousand answers. **Threshold:** 2 per thousand. **Objective:** 0.5 per thousand | | Provisional | GM Customer Care | [TBD — source: "we can't have it telling customers things that aren't true"] |

The instrument that measures it — the held-out set, the scorer, the pass mark — is **derived by the
design response and recorded at Appendix D** when the SOAP answers. The ORD does not author it.
**Appendix D is where an evaluation set is recorded; no fifth appendix is added.**

**A population is quantifiable, or it is a hedge.** *"Customer-facing determinations"* names no
boundary and fails at verification exactly as *"fast"* does. A population states what is counted,
over what window, and what is excluded — *"rebate-eligibility answers issued to a customer within a
billing period, excluding internal test traffic"*. Where it cannot yet be stated, write
`[TBD — source: …]` and leave the gap visible rather than narrowing it by invention.

**Acceptance at go-live is not final acceptance, and Appendix D does not follow the component into
service.** A component whose behaviour is learned or generated degrades with no change to the code,
so it is re-measured — and each re-measurement produces a new instrument. **Appendix D receives none
of them.** It records the instrument as at SOAP issue and completes there, on the same rule that ends
the ORD's influence at that hop.

The ORD therefore carries the *obligation*, never the log. The obligation is a requirement at §3.6.2,
with its reporting tolerance in §7:

> *Degradation in rebate-eligibility answer quality against ORD-NN is detected and reported within
> [TBD — source: "we'd want to know quickly if it started drifting"] of occurrence.*

**Where the re-measurement records live is outside this document** — in the **operate record**
(defined in `GLOSSARY.md`), which the design response establishes and whose accountable owner is
named in the SOAP. Stated rather than omitted: a declared boundary with a named owner can be checked
at handoff, whereas an implied one is discovered when somebody goes looking for a log that was never
anyone's to keep.

_Avoid_: reading *"the set is the response's"* as *"the set is optional"*. The rule routes the
instrument; it does not excuse its absence. A tolerance whose population is unnamed is unmeasurable
on either side of the hop.

## A model or provider dependency — where it lands, and when it lands nowhere

**Who chooses the model decides whether the ORD carries it at all.**

| Case | Treatment |
|---|---|
| The design response selects the model | **No ORD row.** The ORD cannot name what the response has not yet chosen. It appears in the SOAP, and Appendix D records its conformance |
| A model or service is already in use, and this ORD is written against it | A `DEP-` row in **§9**, with the detail table below |
| A model or provider is **mandated** — enterprise agreement, sovereignty or licensing constraint | The mandate is a **§4** constraint; the dependency is a `DEP-` row in **§9** |

Where a `DEP-` row exists, the four attributes a learned or generated component adds are carried in a
detail table keyed to it — the same shape the pack uses for per-interface technical attributes, and
carrying specification rather than commitment. The binding statement stays the `DEP-` row.

| DEP# | Model or service | Version | Pinned | Deprecation notice contracted | Behaviour when unavailable |
|---|---|---|---|---|---|

_Avoid_: routing a model **dependency** to the referred requirements register. Appendix C records
what this ORD **will not deliver**, and who it went to; a dependency is carried, not referred, and
filing it there removes it from the document that depends on it.

**The exception is a different thing wearing the same name.** A *requirement about* the model that
this ORD will not deliver — a retraining cadence owned by a data-science function, a provider
contract variation owned by commercial — is referred content and belongs at Appendix C. The
dependency stays at §9; the requirement goes to its resolver. Both rows can exist for one model, and
where they do **the §9 row names the Appendix C row** — as `DEP-02` names `REF-01` in the worked
example. The link is deliberately single-directional: Appendix C's schema carries no dependency
column, so §9 is where the association lives. Do not add the reverse without adding the column.

## EU AI Act Articles 9–15 → ORD section

> Applies where the component is classified high-risk. **Classification is a BRD decision**, recorded
> once for the chain below it. Annex III high-risk obligations apply from 2 December 2027 and Annex I
> from 2 August 2028; Article 50 transparency, the general-purpose obligations and the Article 5
> prohibitions are live now.
>
> This maps the article to where the *requirement* lands. Conformity evidence, technical
> documentation (Art. 11 / Annex IV) and the quality management system are assembled elsewhere —
> the ORD supplies rows to them, it does not become them.

| Article | Requires | ORD Section |
|---|---|---|
| **9** Risk management system | Risk identified, evaluated and mitigated across the lifecycle | 9. Trade-offs, risk and dependencies; assumption register |
| **10** Data and data governance | Governance over training, validation and test data — origin, preparation, labelling, assumptions, suitability | 4. Operating environment and constraints |
| **11** Technical documentation | The Annex IV file | *Outside the ORD* — the ORD is one input |
| **12** Record-keeping | Automatic logging of events over the system's lifetime | 3.6.2 Analyzability, with retention in 4 |
| **13** Transparency to deployers | Information sufficient for a deployer to interpret and use the output | 3.7 |
| **14** Human oversight | A person able to interpret, override and stop the system, with the authority to do so | 3.7, with the tolerance in 5 |
| **15** Accuracy, robustness, cybersecurity | Declared accuracy and its metrics; resilience to error and to adversarial input | 3.8 accuracy · 3.2 robustness · 3.3 cybersecurity |
| **50** Transparency for generated content | Disclosure that content is AI-generated; machine-readable marking | 3.7 |

_Avoid_: treating the deferral of the high-risk dates as a reason to defer the rows. A register
already carrying data governance, logging, oversight and accuracy needs no retrofit in 2027; one that
does not, does — and the retrofit falls due under a conformity deadline.

_Avoid_: an oversight or record-keeping requirement written in the passive with no actor.
"Oversight is provided" names nobody and binds nobody — these are the rows where the actor is
load-bearing, so name them and write them active.

## Note on Sections 5–9
Sections 1–2 (Introduction, Operational Concept) and 4–9 (Environment, Escalation tolerance, SLAs, Risk) are **operational framing**, not 25010 characteristics. Section 3 is the only one organised strictly by the nine characteristics. Don't force business-demand content such as escalation tolerance into a 25010 bucket — it has its own home.

**Staffing, infrastructure and the support *model* are a different matter: they are not framing, they are out of scope.** All nine ISO/IEC 25010 characteristics are logical quality attributes, and these three sections are inherited from the acquisition-era ORD that covered an entire physical system entering service. The distinction that resolves the disputes:

| Statement | Treatment |
|---|---|
| *"Restoration of a failed order is available without re-keying"* | **In scope** — a logical tolerance |
| *"Support is available 07:00–19:00, and a gap beyond 4 hours breaches obligation X"* | **In scope** — the tolerance, sourced to an obligation |
| *"Tier 2 support is staffed at 4 FTE on a follow-the-sun roster"* | **Out of scope** — the roster is the design's to specify |
| *"The service is hosted active-active across two availability zones"* | **Out of scope** — answered in the design response |

**Record what is out of scope — never silently omit it.** A requirement dropped because it fell outside the document is indistinguishable from one nobody raised. Registered against a named recipient, it is a handoff.

*Boundary source: ORD Intake and Maturity Standard §2.2 and §7.2.*

*Source: ISO/IEC 25010:2023; standard ORD template. AI rows: ISO/IEC 25059:2023 and Regulation (EU)
2024/1689 as amended — see `ai-standards-map.md`.*

---

<!-- from reference/example-ORD.md -->

# Operational Requirements Document

## Missed Appointment Rebate — Acme Communications

**Document version:** 1.1 · **Date:** 2026-08-07 · **Status:** Issued for approval
**ORD convenor:** [name] · **Approving GMs:** GM Field Operations, GM Customer Care, GM Billing
**Endorsing:** Service Management, Regulatory Affairs, Solution Architecture
**Anchors:** ISO/IEC 25010:2023 · ISO/IEC/IEEE 29148:2018 · BABOK v3

> ### Maturity tier: B — Provisional (confidence: conditional)
>
> Both KPPs are sourced from the customer contract and 18 months of incident history but are not
> yet owner-committed. Three assumptions remain open, listed at Appendix B with owners and
> confirm-by dates.
>
> **The date serves architecture engagement, which requires Tier B. The achievable tier meets
> the sufficient tier and there is no gap to close.**
>
> Confidence is **conditional** because the time ratio sits within 0.05 of its band floor —
> 25 available working days against a 31-day lead time for a Medium change at 60% allocation
> with a contested rule set live. One slip drops this to Tier C.
>
> Approving this document is acceptance of the rework exposure that Tier B describes.

---

> **This is a worked exemplar.** It demonstrates the **demand-side ORD** — authored ahead of
> solutioning, stating quantified *business tolerance* rather than technical targets, and
> carrying no staffing, hosting or support-model content. It follows the demand-side section
> template: §3 holds the nine characteristics at their standard numbering, and §6 and §8 are
> numbered and left empty because this document's scope rules them out. Requirements are
> illustrative but realistic. Copy the shape, not the figures.
>
> An ORD documenting a service whose design already exists is a different document and states
> technical figures legitimately. The test for which of the two you are writing is in the
> requirement-to-section map.

### Document control

| Version | Date | Author | Change |
|---|---|---|---|
| 0.9 | 2026-08-01 | ORD convenor | Issued for review following the decision workshop |
| 1.0 | 2026-08-05 | ORD convenor | Review corrections incorporated; assumption register closed to three open items |
| 1.1 | 2026-08-07 | ORD convenor | ORD-04 tolerance moved from 12 to 24 hours on evidence from INC-5012, raised by GM Field Operations 2026-08-06. Capability acceptance criteria that consumed the original value require review |

**Every requirement carries a status and a version.** A status or value change is a dated entry
in this table recording what changed, who committed it, and which assumption it closed.

---

## 1. Introduction

### 1.1 Purpose

States what Acme Communications requires operationally of the missed-appointment rebate change:
which processes and systems the change touches, who owns each, and the operational tolerances
that hold whatever design answers this document.

### 1.2 The business objective this traces to

From the BRD (BRD-2026-041 — §4 objectives, §8 business requirements, §9 constraints), the three
load-bearing elements:

| | Element | Value |
|---|---|---|
| B1 | Objective with baseline and target | Complaints arising from missed installation appointments are reduced from 1,840 per quarter (FY25 Q4 baseline) to fewer than 900 per quarter by FY27 Q2 |
| B2 | Outcome, not solution | A customer whose installation appointment is missed receives the contracted rebate without contacting Acme |
| B3 | Constraints with operational weight | Consumer contract clause 14.3 — rebate payable within two billing cycles of the missed appointment. Field services agreement §9 — contractor attendance data supplied within 24 hours |

### 1.3 Operational scope

**In scope.** The operational behaviour of appointment completion, rebate determination, rebate
application and customer notification, across Field Operations, Customer Care and Billing.

**Out of scope — stated explicitly, because an absent out-list is the most common cause of
silent scope growth:**

- Rebate eligibility rules, thresholds and exception handling — functional requirements (Appendix C, REF-01)
- The target-state design of any impacted workflow — an output of the SOAP, not of this document
- **Technical targets of any kind** — availability percentages, recovery times, latency and capacity figures. These are the SOAP's to derive from the tolerances at §3
- Contact-centre staffing and rostering (Appendix C, REF-04)
- Hosting, infrastructure and physical security of any impacted system
- Commercial renegotiation of the field services agreement (Appendix C, REF-05)

### 1.4 Related documents

BRD-2026-041 · Consumer contract v11 clauses 14.1–14.6 · Field services agreement (2024) ·
Incident records INC-4471, INC-5012, INC-5388 · Process inventory extract, Order-to-Activate L4 set

### 1.5 Definitions

**Missed appointment** — a booked installation appointment at which no field operative attended
within the contracted window. **Rebate** — the credit payable under consumer contract clause
14.3. **SOAP** — Solution on a Page, solution architecture's answer to this document. **L4** —
the lowest-level workflow modelled in the Acme process repository; see the note at §2.2.

---

## 2. Operational concept and impact

### 2.1 Business context

Acme books installation appointments and dispatches field operatives, directly and through
contracted partners. Where an operative does not attend within the contracted window, consumer
contract clause 14.3 obliges Acme to credit the customer. Today that credit is issued only when
a customer complains, which is the source of the complaint volume B1 exists to reduce.

### 2.2 Impact register

What this change touches, and who is accountable for each. **Identification and routing only —
this register records *that* an item is in play and *who* owns it, never what it becomes.**

Tier numbers below belong to the **Acme process repository** scheme, not to APQC or eTOM; an
unqualified tier number is ambiguous to a downstream reader.

| Ref | Kind | Impacted item | Owner | Nature of impact | Referred |
|---|---|---|---|---|---|
| IMP-01 | L4 workflow | Appointment booking and confirmation | Process owner, Customer Care | Appointment records become the evidence base for a rebate determination | — |
| IMP-02 | L4 workflow | Field job dispatch and attendance capture | Process owner, Field Operations | Attendance and non-attendance are recorded distinguishably, which they are not today | REF-02 |
| IMP-03 | L4 workflow | Rebate determination and application | Process owner, Billing | New decision point in an existing workflow | REF-02 |
| IMP-04 | L4 workflow | Customer contact and complaint handling | Process owner, Customer Care | Agents answer rebate queries; the escalation path changes | REF-03 |
| IMP-05 | System | Workforce management platform | Application owner, Field Operations | Source of attendance data | — |
| IMP-06 | System | Billing engine | Application owner, Billing | Applies the credit; holds the billing-cycle boundary | — |
| IMP-07 | System | Customer notification service | **Unowned — open** | Issues the rebate notification | — |
| IMP-08 | System | CRM / customer record | Application owner, Customer Care | Holds the appointment record and the contact history | — |
| IMP-09 | System | Contractor portal | Application owner, Field Operations | Third-party attendance submission | REF-05 |

**IMP-07 carries no named owner.** The notification service appears in the estate with its owning
team recorded as vacant. The row stays open — it is a finding about Acme's ownership records
rather than about this change, and it is raised with the approving GMs at sign-off rather than
referred, because a referral needs a recipient.

**What this register is not.** It does not state what any workflow or system becomes. The
target-state workflows and the integration approach are the SOAP's to produce, and drawing them
here asserts the answer rather than deriving it.

### 2.3 Entry position

Recorded at assignment. This is a record, not an escalation.

| # | Input | Status at assignment |
|---|---|---|
| E1 | BRD, or the three load-bearing elements | **Received** — BRD-2026-041 |
| E2 | Business stakeholder list | **Received** on day 3, two days after assignment |
| E3 | Named approving GMs | **Received** |
| E4 | Contracts, obligations, SLAs, incident history | **Received** |
| E5 | Confirmed date and the milestone it serves | **Received** — architecture engagement |
| E6 | Confirmed allocation percentage | **Received** — 60% |
| E7 | Notification when the SOAP is issued | **Agreed** with Solution Architecture |
| E8 | As-is process inventory with named owners | **Received** — Order-to-Activate L4 extract |
| E9 | System estate with named owners | **Partial** — no named owner for the notification service (IMP-07) |

**Size:** M — three business units, five objectives, eight stakeholders (BRD §5's nine rows less
the affected-customer group, which is not consulted directly), nine impacted workflows and systems. **Allocation:** 60%. **Available working days:** 25. A rebate eligibility rule set
was in obligation-dependent refinement at assignment, so the contested lead-time table applies.
**Committed tier: B**, conditional.

---

## 3. Operational requirements

Organised by ISO/IEC 25010:2023 characteristic. **All nine appear.** A characteristic with
nothing to state carries an explicit statement, never an omission.

**On the numbering.** This exemplar identifies every requirement by its `ORD-NN` reference and
groups them at the characteristic level, §3.1–§3.9. The sub-characteristic level — §3.1.1 Time
Behavior, §3.3.6 Compliance Frameworks and the rest — is defined in the requirement → section map
and is what an external citation such as *"Checkout ORD §3.3.6"* refers to. Both are correct: the
`ORD-NN` reference is what the traceability chain carries, and the §3.x.y number is what locates a
requirement in the template. A document with enough requirements to need the third level uses it.

Every requirement is a **business tolerance** — quantified, testable, and traced to a contract,
an obligation or an incident record. None states a technical target: availability percentages,
recovery times, latency and capacity figures are the SOAP's to derive in response.

**[KPP]** marks a requirement whose failure constitutes failure of the change rather than
degradation. Each carries **threshold** (minimum acceptable) and **objective** (desired) as two
labelled values.

### 3.1 Performance Efficiency

| Ref | Ver | Business tolerance | KPP | Status | Owner | Source |
|---|---|---|---|---|---|---|
| ORD-01 | 1.0 | A customer-care agent establishes a customer's rebate position within the customer's call, without a transfer or a call-back | | Provisional | GM Customer Care | INC-4471 · complaint theme analysis FY25 Q4 |
| ORD-02 | 1.0 | Rebate determination absorbs a peak of one day's national installation volume arriving in a single reconciliation window | | Assumed | GM Field Operations | Assumption ASM-02 |

### 3.2 Reliability

| Ref | Ver | Business tolerance | KPP | Status | Owner | Source |
|---|---|---|---|---|---|---|
| ORD-03 | 1.0 | A rebate owed under clause 14.3 is applied within two billing cycles of the missed appointment. **Threshold:** two cycles. **Objective:** one cycle | **[KPP]** | Provisional | GM Billing | Consumer contract cl. 14.3 |
| ORD-04 | **1.1** | Rebate determination continues through a 24-hour interruption to any single attendance source, and no determination is lost. **Threshold:** 24 hours. **Objective:** 72 hours | **[KPP]** | Provisional | GM Field Operations | INC-5012 — 19-hour contractor portal outage, 2,300 jobs unreconciled |
| ORD-05 | 1.0 | A missed appointment already determined as rebate-owing is not re-determined, and no customer receives a duplicate credit | | Committed | GM Billing · 2026-07-29, Rebate Design Forum | Consumer contract cl. 14.5 |

*Proposed acceptance criterion, ORD-03:* `Rebate applied within two billing cycles (threshold) / one cycle (objective) [ORD-03 · v1.0 · Provisional · owner: GM Billing · confirm by 2026-08-29]`

### 3.3 Security

| Ref | Ver | Business tolerance | KPP | Status | Owner | Source |
|---|---|---|---|---|---|---|
| ORD-06 | 1.0 | A rebate credit is attributable to the appointment record, the attendance evidence and the person or process that applied it, for seven years | | Committed | GM Billing · 2026-07-29 | Records retention policy; consumer contract cl. 14.6 |
| ORD-07 | 1.0 | Contractor attendance data is visible only to the contracting party that submitted it | | Provisional | GM Field Operations | Field services agreement §12 |

### 3.4 Compatibility

| Ref | Ver | Business tolerance | KPP | Status | Owner | Source |
|---|---|---|---|---|---|---|
| ORD-08 | 1.0 | A rebate determination made while an upstream source is unavailable is reconciled without manual intervention once that source returns | | Provisional | GM Billing | INC-5388 |
| ORD-09 | 1.0 | Contractor attendance submitted through the existing contractor channel is accepted without change to the contractor's own process | | Assumed | GM Field Operations | Assumption ASM-03 |

### 3.5 Flexibility

| Ref | Ver | Business tolerance | KPP | Status | Owner | Source |
|---|---|---|---|---|---|---|
| ORD-10 | 1.0 | A change to the rebate amount or the qualifying window is in effect within one billing cycle of the contract change taking effect, without a release | | Provisional | GM Billing | Consumer contract cl. 14.3 — amended twice since 2023 |

### 3.6 Maintainability

| Ref | Ver | Business tolerance | KPP | Status | Owner | Source |
|---|---|---|---|---|---|---|
| ORD-11 | 1.0 | A rebate not applied is diagnosable by Billing operations to the point of failure, without engineering involvement | | Provisional | GM Billing | INC-5012 post-incident review |
| ORD-12 | 1.0 | The rebate position of any appointment is reportable for a regulatory enquiry within one business day | | Committed | GM Billing · 2026-07-29 | Regulatory Affairs standing requirement |

### 3.7 Interaction Capability

| Ref | Ver | Business tolerance | KPP | Status | Owner | Source |
|---|---|---|---|---|---|---|
| ORD-13 | 1.0 | A customer establishes their rebate position through the channel they already use, without a separate account or a new channel | | Provisional | GM Customer Care | BRD-2026-041 §8 BR-2 |
| ORD-14 | 1.0 | A customer-care agent reaches competency on rebate handling within one shift | | Assumed | GM Customer Care | Assumption ASM-01 |

### 3.8 Functional Suitability

| Ref | Ver | Business tolerance | KPP | Status | Owner | Source |
|---|---|---|---|---|---|---|
| ORD-15 | 1.0 | A missed appointment is determinable from data captured during the field job, with no re-keying by a field operative or an agent | | Committed | GM Field Operations · 2026-07-29 | Rebate Design Forum decision |
| ORD-16 | 1.0 | At go-live, rebate determination covers residential installation appointments. Business and assurance appointments are phased | | Committed | GM Customer Care · 2026-07-29 | BRD-2026-041 §7 |

### 3.9 Safety

**No safety requirement is identified.** The change carries no risk of physical harm and is not
safety-critical. Stated rather than omitted: an absent characteristic is invisible to a reviewer
and is typically discovered during an incident.

### Requirement status summary

| Status | Count | Meaning |
|---|---|---|
| Committed | 5 | The business owner has agreed the tolerance and it traces to a source |
| Provisional | 9 | Sourced from real evidence; no owner has yet confirmed it applies here |
| Assumed | 3 | No owner and no documentary source; a stated assumption with a confirmer and a date |

**The tier is the weakest status carried by any KPP-bearing requirement** — not the average, and
not the weakest status anywhere in the document. Both KPPs (ORD-03, ORD-04) are Provisional,
which sets Tier B. ORD-02 is Assumed and sits in a KPP-bearing area — capacity — so its
confirm-by date of 2026-08-29 is the one that governs whether the tier holds.

---

## 4. Operating environment and constraints

| Constraint | Type | Operational consequence |
|---|---|---|
| Consumer contract cl. 14.3, 14.5, 14.6 | Contractual | Sets the rebate obligation, the duplicate-credit prohibition and the retention period. Source of ORD-03, ORD-05 and ORD-06 |
| Field services agreement §9, §12 | Contractual | Attendance data timeliness and contractor data segregation. Source of ORD-04 and ORD-07 |
| Regulatory enquiry response obligation | Regulatory | Source of ORD-12 |
| Billing cycle boundary — monthly, per customer | Business calendar | Fixed, and not a design choice. It bounds every tolerance expressed in cycles |

---

## 5. Operational hours and escalation tolerance

Stated as business tolerance. **The support model, tiers, rosters and staffing that meet it are
the SOAP's to specify and are out of scope here** (Appendix C, REF-04).

| Ref | Ver | Business tolerance | Status | Owner | Source |
|---|---|---|---|---|---|
| ORD-17 | 1.0 | A rebate query raised by a customer is answerable during the hours the customer contact channel operates, with no gap in which the rebate position is unobtainable | Provisional | GM Customer Care | INC-4471 |

---

## 6. Staffing and organisational requirements

**Not used.** Out of scope for a demand-side ORD — staffing is not a logical system property.
The section number is retained so that references to §7 and §9 stay stable and the omission is
declared rather than silent. Staffing content raised during elicitation is at Appendix C, REF-04.

---

## 7. Service level requirements

*View of §3. Values are authoritative in the referenced rows; this table adds no new commitments.*

| Ref | Tolerance carrying a contractual or reporting obligation | Obligation |
|---|---|---|
| ORD-03 | Rebate applied within two billing cycles | Consumer contract cl. 14.3 |
| ORD-06 | Attribution retained for seven years | Consumer contract cl. 14.6 |
| ORD-12 | Rebate position reportable within one business day | Regulatory Affairs |

---

## 8. Infrastructure and facilities

**Not used.** Out of scope for a demand-side ORD — hosting, hardware and physical security are
answered in the SOAP. The section number is retained for the same reason as §6.

---

## 9. Trade-offs, risk and dependencies

| Trade-off or risk | Business consequence | Accepted? |
|---|---|---|
| Rebate determined from attendance data of known imperfect quality (DEP-01) | A small number of rebates are issued where an operative did attend | Yes — the cost of over-issuing sits materially below the complaint cost B1 quantifies |
| Business and assurance appointments phased to a later release (ORD-16) | Business customers continue to rely on complaint-driven credits until phase 2 | Yes — GM Customer Care, 2026-07-29 |

**Open questions**

| ID | Question | Owner | Due |
|---|---|---|---|
| OQ-01 | Does clause 14.3's "two billing cycles" run from the missed appointment or from its confirmation? | Regulatory Affairs | 2026-08-15 |
| OQ-02 | Who owns the customer notification service (IMP-07)? | GM Customer Care | 2026-08-22 |

**Dependencies**

| ID | Dependency | Type | Owner | Needed by | Status |
|---|---|---|---|---|---|
| DEP-01 | Contractor portal data-quality remediation, in the Field Systems programme | Internal | Programme lead, Field Systems | Design sign-off | At risk |
| DEP-02 | Regulatory Affairs interpretation of clause 14.3, which blocks REF-01 and OQ-01 | Internal | Head of Regulatory Affairs | 2026-09-05 | Open |

**Model and service dependency detail — illustrative, no row populated.** This change carries no
component whose behaviour is learned or generated, so nothing here binds. The table appears because
the shape is part of the standard: where a `DEP-` row names a model or an AI service **already in use
or mandated**, these attributes are carried against it. Keyed to the `DEP-` row, which remains the
binding statement — this table carries specification, not commitment. A model the *design response*
selects has no row here at all; it is answered in the SOAP.

| DEP# | Model or service | Version | Pinned | Deprecation notice contracted | Behaviour when unavailable |
|---|---|---|---|---|---|
| — | *No component with learned or generated behaviour in this change* | — | — | — | — |

---

## Appendix A — Traceability

| ORD ref | Business tolerance | Traces to — BRD objective, via business requirement | Orphan? |
|---|---|---|---|
| ORD-03 [KPP] | Rebate applied within two billing cycles | §4 BO-1, via §8 BR-1 | No |
| ORD-04 [KPP] | Determination survives a 24-hour source interruption | §4 BO-1, via §8 BR-1 | No |
| ORD-10 | Rebate parameters changeable without a release | §4 BO-3, via §8 BR-3 | No |
| ORD-13 | Rebate position established through an existing channel | §4 BO-2, via §8 BR-2 | No |
| ORD-15 | Missed appointment determinable without re-keying | §4 BO-2, via §8 BR-1 | No |

All references are to BRD-2026-041. **Every row resolves to an objective**, not to a business
requirement — a tolerance tracing only as far as a `BR-` has no funded outcome behind it, and the
`via` column is what makes that visible rather than assumed.

*The full matrix covers all seventeen requirements. Every requirement traces to a BRD objective
or carries an explicit orphan-scope flag.*

## Appendix B — Assumption register

| ID | Assumption | Owner to confirm | Confirm by | Consequence if wrong |
|---|---|---|---|---|
| ASM-01 | Agent competency on rebate handling is reachable within one shift | Head of Care Enablement | 2026-08-22 | Training load exceeds the L&D allocation; ORD-14 moves and REF-03 grows |
| ASM-02 | One day's national installation volume is the realistic reconciliation peak | GM Field Operations | 2026-08-29 | ORD-02 understates capacity demand. Architecturally significant — moving it after design sign-off is redesign, not adjustment |
| ASM-03 | Contractors submit attendance through the existing channel without process change | Contract Manager, Field Services | 2026-09-05 | REF-05 becomes a commercial negotiation on the critical path |

**Expected trajectory.** These three are expected to reach Committed by 2026-09-05. On that date
the document's knowledge is Tier A even though the document itself remains Tier B — there is no
mechanism that records the improvement, which is why the trajectory is stated here.

## Appendix C — Referred requirements register

Content raised during elicitation that **this ORD will not deliver**. Outside the ORD's scope; no
row is classified against an ISO/IEC 25010 characteristic, and no row becomes a requirement of
this document.

| Ref | Requirement | Raised by | Kind | Related impact | Resolver group | Referred to | Date | Status |
|---|---|---|---|---|---|---|---|---|
| REF-01 | Rebate eligibility rules — qualifying window, customer-cancellation exclusions, partial-attendance treatment, exception handling | GM Customer Care | Functional | IMP-03 | **None in chain** | Programme lead | 2026-07-22 | **Referred, not accepted** |
| REF-02 | Target-state design of the attendance-capture and rebate-determination workflows | Process owner, Field Operations | Wrong resolver | IMP-02, IMP-03 | Process architecture, after the SOAP | Process architecture lead | 2026-08-01 | Referred |
| REF-03 | Agent training and knowledge-base content for rebate queries | GM Customer Care | Wrong resolver | IMP-04 | Learning and Development | Head of Care Enablement | 2026-08-01 | Accepted |
| REF-04 | Additional contact-centre capacity for the first two billing cycles after go-live | GM Customer Care | Out of scope — staffing | IMP-04 | Workforce planning | Workforce planning manager | 2026-08-01 | Referred |
| REF-05 | Variation to the field services agreement covering attendance data timeliness | Contract Manager | Wrong resolver | IMP-09 | Commercial | Contract Manager, Field Services | 2026-08-04 | Referred |

**REF-01 is the row to read.** Rebate eligibility is a body of business rules — *when the customer
cancels within four hours, then…* — and business rules are functional requirements. No functional
requirements document is produced in this delivery chain, so there is no resolver group to refer
them to and the row stays open. **Unless it is closed, those rules are inferred during Epic
decomposition rather than elicited.** An inferred rule and an elicited rule are indistinguishable
once written into an Epic, and only one of them was checked with the business.

Nine weeks of Regulatory Affairs and Legal discussion have produced agreement on four of the seven
rule areas. That agreement currently lives in meeting notes.

## Appendix D — ORD to SOAP conformance

**Completed when the SOAP is issued.** One row per requirement, recording whether the SOAP
answered it: **Met**, **Met at threshold but not objective**, **Not met — trade-off proposed**,
or **Unanswered**.

| ORD ref | Business tolerance stated | SOAP response | Conformance |
|---|---|---|---|
| ORD-03 | Rebate applied within two billing cycles | *pending* | *pending* |
| ORD-04 | Determination survives a 24-hour source interruption | *pending* | *pending* |

**An unanswered KPP is escalated rather than recorded.** Nothing downstream reads this document —
a business demand not carried into the SOAP is absent from every artefact anyone downstream will
read.

**Where a tolerance governs generated output, the SOAP response is the evaluation instrument.**
Appendix D is where an evaluation set is recorded, and **the pack adds no appendix for it**.
Illustrative, since this change carries no such requirement:

| ORD ref | Business tolerance stated | SOAP response | Conformance |
|---|---|---|---|
| *ORD-NN* | *An unsupported claim reaching a customer in a rebate-eligibility answer is unacceptable above 2 per thousand answers* | *Held-out set drawn from customer-facing rebate answers, scored by a calibrated judge, at a stated pass mark* | *pending* |

**Conformance turns on whether the set answers the stated population**, not on whether a set exists.
A set drawn from data the component was tuned against satisfies no tolerance, and a set drawn from a
narrower population than the one the tolerance names answers a different question.

**This appendix records the instrument as at SOAP issue, and completes there.** A component whose
behaviour is learned or generated is re-measured after issue, and each re-measurement produces a new
instrument — **none of which lands here.** The obligation to re-measure is a requirement at §3.6.2
with its reporting tolerance at §7; the records of those re-measurements live in the **operate
record** — defined in `GLOSSARY.md`, established by the design response, with its accountable owner
named in the SOAP. Declared rather than omitted, so the boundary and its owner can both be checked at
handoff instead of discovered when someone looks for a log nobody kept.

*The illustrative rows above and at §9 are placeholders for a worked AI exemplar that is not yet
written. This document is the Acme rebate change and carries no AI component.*
