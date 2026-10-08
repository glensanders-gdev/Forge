# write-ord — Elicitation and Extraction

Phase 1 analysis aids: the lenses that decide **what to look for**, and the judgement that decides
what to split, consolidate and strip from a source statement. Wording is governed by
`standards/language.md`; destinations by [TEMPLATE.md](TEMPLATE.md).

---

## Elicitation lenses

Phase 1 analysis aids. **A lens finds a question, never an answer.** Every lens output is one of the
six governed forms below and nothing else — a lens that surfaces an unanswered question has done its
job, and closing that question by inference is the failure this section exists to prevent.

| A lens may produce | Conditions |
|---|---|
| A register row | Only where the source carries the tolerance and its evidence |
| `[TBD — source: "…"]` on an existing row | The requirement is real, the value is not stated |
| A §7.10 coverage gap | The sub-characteristic has no source material at all |
| An `ASM-NNN` | The assumption is explicit in the source, with an owner and a confirm-by date |
| A decision item (`D-NNN`, or a numbered `[D-TBD-N]`) | Two documented positions compete, or authority is unresolved |
| A `REF-NNN` | The question is real and another document or resolver group owns the answer |

**A lens that finds nothing is reported as *not evidenced*, never as satisfied.** The two are
different findings and only one of them is safe to act on.

### Conditional relevance

Run only the lenses whose trigger is present in the source. A lens with no trigger is not run, is
not reported, and is not a gap — the same rule the *(AI)* subsections follow at §7. Lens 1 and
lens 14 are unconditional; every other lens is gated by its trigger.

| # | Lens | Fires when | Probe | Findings land in |
|---|---|---|---|---|
| 1 | **Operational purpose** | Always | The operational outcome served; the problem prevented or reduced; the business consequence if unmet; the actor, team, customer, counterparty or process that benefits | `OBJ-NNN`; the breach clause inside the `Business Tolerance`; `Source` |
| 2 | **Lifecycle and state transition** | The source names statuses, states, lifecycle events or transitions | Starting state; triggering event; eligibility condition; authorised initiator; permitted transition; prohibited transition; resulting state; downstream, notification, reporting and billing consequence; rollback after failed processing; reversal after successful processing; audit evidence | §7.3.2 Integrity; §7.8.1; `BRL-NNN`; `SCN-NNN`; `IMP-NNN` |
| 3 | **Failure, degradation, retry, reconciliation** | The capability has a dependency, a queue, or a downstream consumer | Complete failure; partial failure; stale or unavailable data; dependency failure; timeout; duplicate processing; omitted processing; downstream rejection; partial propagation; inconsistent state; retry; retry exhaustion; escalation; reconciliation; last valid state preserved; exception visibility; degraded operation; recovery | §7.2 Reliability; §7.3.2 Integrity; §7.6.2 Analyzability; Rainy Day `SCN-NNN` |
| 4 | **Non-interference and concurrency** | The change shares records, locations, services or processes with other activity | Concurrent orders or transactions; shared record or location; race condition stated as a business consequence; unintended triggering of another workflow; inflight work blocked or delayed; unrelated attributes overwritten; isolation from the neighbouring processes the source names | §7.4.2 Coexistence; §7.3.2 Integrity; Edge Case `SCN-NNN` |
| 5 | **Operational workflow and service management** | People or teams perform operational work | Initiating actor; submission channel; receiving team; queue or assignment group; resolver group; reassignment; escalation; ageing; backlog visibility; SLA or OLA implication; pending or suspended treatment; manual hand-off; swivel-chair activity; operational notification; closure; rejection; rework; support evidence | §7.12; §7.6.3 Supportability; `IMP-NNN`; `REF-NNN` |
| 6 | **Processing mode** | More than one mode is in scope or implied — individual and bulk, or manual and automated | Individual processing; bulk processing; manual processing; automated processing; mode switching and who authorises it; human review; override; approval; reprocessing; bulk validation; partial bulk failure; bulk summary reporting; manual fallback | §7.8.1; §7.2.2 Fault Tolerance; `BRL-NNN`; `SCN-NNN` |
| 7 | **Role, authority and cross-party consequence** | More than one party, team or organisation touches the same record or service | Submitter; initiator; viewer; editor; approver; executor; reviewer; override authority; owner of the affected service or record; party notified; party financially or operationally affected | §7.3 Security; §7.7; `BRL-NNN`; decision item |
| 8 | **Access and entitlement** | The source states who may do what | Read; create; update; delete; approve; execute; override; administer; audit; bulk authority distinct from individual authority | §7.3.1 Confidentiality rows, with an optional entitlement view |
| 9 | **Reported measure** | The `standards/reporting.md` trigger fires | That file's class map in full, including the clock; every reporting consumer class it lists; whether each needed attribute, dimension and data element already exists | Per `standards/reporting.md`: outcome rows in §7, measure definitions at §14.2, consumers at §14.1, `DAT-NNN` at §14.3, rules at §13 |
| 10 | **Data governance and auditability** | Data drives an operational decision or a reported figure | Confirmed source; ownership; definition; lineage; transformation; rule version; effective date; the ISO/IEC 25012 characteristic and its tolerance; duplicate and omission control; attribution; retention; audit reconstruction; reconciliation between operational and reported views | `DAT-NNN`; §7.6.2 Analyzability; §7.3.3 |
| 11 | **Diagnostics and observability** | Monitoring, service health, assurance, testing or fault detection is in scope | How the condition is detected; diagnostic inputs; test outcomes; the evidence supporting a determination; isolated versus common-cause behaviour; correlation across related services, devices, locations or events; neighbouring-service comparison; false-positive and false-negative consequence; threshold consistency across channels; cross-channel outcome consistency; manual test availability; automated test use; operator visibility; escalation on diagnostic outcome; visibility of failed or inconclusive tests | §7.6.2 Analyzability; §7.2; §7.7; `BRL-NNN` |
| 12 | **Commercial and charging consequence** | A lifecycle, performance, eligibility or reporting change can affect what is charged, credited or rebated | Charge commencement; charge cessation; rebate eligibility; fee treatment; credit or adjustment; effective date; billing stop and restart; downstream billing notification; invoice representation; dispute and enquiry handling; reconciliation from source event through calculation to applied amount; effect on another party | `IMP-NNN`; `BRL-NNN`; §7.3.2 Integrity; §7.8.1; `REF-NNN` where commercial owns the answer |
| 13 | **Calendar and timing basis** | Any period, deadline, window, blackout or notification interval appears | Calendar basis; timezone; the holiday jurisdiction — state, territory, national or contractual; business-hour definition; commencement event; completion event; whether the starting day counts; cut-off time; weekend treatment; after-hours treatment; blackout dates; pause and resume | The `Business Tolerance` sentence itself, or a `[TBD]` on it |
| 14 | **Cross-requirement consistency** | Always — run last, before the summary is presented | See § *The consistency sweep* below | Consolidation, or a decision item |
| 15 | **Delivery and portfolio context** | The source explicitly names a programme, capability, epic or delivery item | Only what is explicit: BRD source; stakeholder source; business owner; programme or initiative; capability; epic; related delivery item; milestone; current scope decision; superseded or duplicate relationship | §11's write-back columns; §10.2 for an initiative this document neither depends on nor delivers |

### Six traps these lenses exist to catch

**Rollback is not reversal.** Rollback is what is true after processing *failed* — the last valid
record is unchanged. Reversal is what is true after processing *succeeded* and is later undone — a
new state, with its own trigger, authority, notification and billing consequence. A source that
states one has not stated the other, and a lifecycle carrying only rollback has an unwritten
obligation.

**A correctly processed rejection is not a failure.** An adverse determination, a "Not Met", a
failure to qualify — each is a Sunny Day with `Outcome: Adverse`, and what must be true then is a
separate obligation. Where the source supports it, also state the inconclusive or insufficient-data
behaviour and who reviews it. Testable acceptance criteria (§15) do not discharge this: where the
business requires a failed update to leave the last valid record unchanged, that is a register row
*and* a Rainy Day testable acceptance criterion.

**Bulk is not individual repeated.** Behaviour valid for one transaction does not carry to a batch,
and automation does not remove exception handling, attribution or human intervention. Where the
source states only the individual case, the bulk case is a gap, not an inference.

**A cross-party consequence is derived, and derived is not stated.** Where one party's action
changes another party's service, data, reporting, billing or rights, name the derived consequence
and take it to the gate for the business owner's explicit confirmation. Authority, attendance,
participation and ownership are never inferred from a role name.

**An engineering threshold is not a business tolerance.** Where the source gives a technical figure
and not the demand behind it, preserve the technical wording as `Source` evidence and raise the
missing tolerance at the gate. The same figure quoted in two channels is a consistency finding, not
a confirmation.

**"Real time", "near real time", "as soon as possible", "promptly", "always", "anytime", "x days"
and "agreed SLA" are unquantified** unless the source defines them, and a defined period is still
incomplete without its calendar basis. Preserve the rule the source actually states: a source that
lists Friday among prohibited dates has not made Friday a non-business day — record the rule and
flag the terminology.

### The consistency sweep

Run across all extracted statements before the Phase 1 Summary is presented. Check for: duplicate
requirements; overlapping requirements; conflicting thresholds; conflicting methodologies;
inconsistent status or state names and capitalisation; different triggers stated for the same
outcome; contradictory eligibility conditions; inconsistent populations; one actor affecting another
party without stated authority; a report definition that differs from the operational definition;
statements superseded or marked duplicate; statements already satisfied by existing capability; and
statements marked out of scope but still written as active commitments.

**Consolidate duplicates. Never silently resolve a conflict.** Consolidation loses nothing — it is
one commitment stated once. Resolution picks a winner, and that is a decision with an owner:
preserve both documented positions, name the affected requirements, and raise a decision item.

---

## Extraction — splitting, consolidating and transforming

Wording is governed by `standards/language.md` and is not restated here. What
follows is the extraction judgement that precedes it.

**Transforming a source statement.** Preserve the operational intent and the business rationale.
Drop the wrapper — *"the solution shall ensure"*, *"the system must"*, *"I want the ability to"*,
*"users can"* — and lead with the governed object, event, population, process or outcome, stated as
a delivered fact. Remove the technical mechanism wherever the business-visible outcome stands
without it; retain the mechanism as `Source` evidence, interface detail (§16), a dependency,
a constraint (§7.11), or referred response-side content (§10.3).

> ✗ `The solution shall ensure the transaction uses database rollback on failure`
> ✓ `The last valid record is unchanged after a failed update`

**Split a source statement only where its clauses differ in** actor, trigger, outcome, owner,
priority, source, verification condition, status, or business consequence. **Never split because
the sentence is long** — one commitment stated at length is still one commitment, and splitting it
manufactures rows that trace to nothing.

**Consolidate duplicates into one authoritative row**, without losing a materially different actor,
trigger, outcome, population or failure condition. Where any of those differ, the statements are not
duplicates.
