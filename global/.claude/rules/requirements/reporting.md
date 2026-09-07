# Requirements — Reporting and Data

> Applies **in addition to** [language.md](language.md) and [tables.md](tables.md) whenever a change
> introduces, alters or retires a **measure that is reported** — to a regulator, a counterparty, an
> auditor, or internally where a decision or an obligation turns on the figure. Neither sibling is
> relaxed here. Read the scope boundary in [README.md](README.md) first — these rules govern
> generated document content, not skill instruction prose.

## When this file applies

**Trigger test:** does the change create, change or remove a **number somebody reports**? One such
measure anywhere in scope triggers the file for the requirements that touch it; requirements that
carry no reported measure are unaffected.

It does **not** fire for a system that merely stores or displays data. The trigger is the reported
measure and the obligation behind it — the thing that must still be defensible when someone asks how
the figure was produced eighteen months later.

Per the same reasoning as ADR-0003 there is **no separate reporting requirements document**.
Everything below lands in the existing register, in the section the class map assigns.

## The Rule

**A reported measure is not specified until its population, its rules, its lineage and its
correction path are stated. The figure alone is a display; the four together are a measure.**

The failure this file exists to prevent is a requirement that names an output — *"a monthly
compliance report is produced"* — and leaves unstated which records it counts, which it excludes,
which version of the rules produced it, and what happens when it is later found wrong. Every one of
those is discovered during an audit rather than during design.

## The measure definition

A requirement over a reported measure is a declarative end state carrying four parts. Missing any
one, the figure is unreproducible.

| Part | Supplies | Never written as |
|---|---|---|
| **Population** | which records are in, which are out, and on what evidence | "all relevant records" |
| **Rule set and version** | the `BRL-NNN` rules that classify and calculate, and which version was in force | "as per the business rules" |
| **Lineage** | the source of each input and the identifier that survives to the output | "sourced from the data warehouse" |
| **Correction path** | what happens when a published figure is later found wrong | omitted, because it has not happened yet |

> ✗ `A monthly compliance report is produced`
> ✓ `The monthly compliance figure counts every service order closed in the calendar month, excluding orders cancelled by the customer, classified under the BRL-004 rule set version in force at closure, and each counted order is traceable to its source record by a stable identifier that survives restatement.`

**Do not nominate a system or dataset as authoritative unless the source material confirms that
status.** Which system is the book of record is a governance fact, not a drafting choice.

## Data quality — the anchor

**ISO/IEC 25012** (data quality model) is the taxonomy for data requirements, and it sits in the same
SQuaRE series as the ISO/IEC 25010:2023 characteristics the ORD's §3 is already keyed to.
**ISO/IEC 25024** supplies the measurement side. Use their characteristic names rather than coining
local ones, exactly as [ai.md](ai.md) defers to ISO/IEC 22989:2022 for AI vocabulary.

A data requirement states a quality characteristic **of a named data element**, quantified, with the
consequence of breach — not a general aspiration that data is good.

## Where reporting and data requirement classes live

The class map. A row that does not appear here has no reporting-specific home and follows the normal
rules.

| Requirement class | Home |
|---|---|
| The reported measure itself — population, threshold, obligation behind it | ORD § 3.8.1 Functional Completeness |
| Accuracy, completeness, currentness of a named data element | ORD § 3.8.1, keyed to a `DAT-NNN` row |
| Reproduction of a historical figure under the rules in force at the time | ORD § 3.6.2 Analyzability |
| Lineage — source of each input, identifier surviving to the output | ORD § 3.6.2 Analyzability |
| Reconciliation — source, included, excluded, exception populations | ORD § 3.8.1 |
| Duplicate and omission control | ORD § 3.3.2 Integrity |
| Restatement and correction of a published figure | ORD § 3.6.1 Modifiability |
| Who may read the report, and at what granularity | ORD § 3.3.1 Confidentiality |
| Report availability and timeliness against the obligation | ORD § 3.1.1 Time Behavior |
| Retention of the figure and its supporting records | ORD § 3.3.3 Non-repudiation and Accountability |
| Definition and rule ownership, effective dating | ORD § 3.6.1, with the rules themselves as `BRL-NNN` |
| Exception visibility — what could not be determined, and why | ORD § 3.8.1 |

**Nothing here adds a §3 subsection.** Reporting requirements are ordinary operational requirements
whose *content* this file governs; they land in the 25010 subsections that already exist. A parallel
reporting section would restate the register.

## Canonical schema

### Data element register

| ID | Data element | Used by | Quality characteristic | Tolerance | Source | Lineage | Owner |
|---|---|---|---|---|---|---|---|
| DAT-NNN | [named element] | [ORD-NNN, …] | [ISO/IEC 25012 characteristic] | [declarative, quantified] | [system or process of origin, where confirmed] | [how it reaches the output] | [named, or TBD with confirm-by] |

- **`Quality characteristic` uses ISO/IEC 25012's names** — accuracy, completeness, consistency,
  credibility, currentness, accessibility, traceability and the rest. Verify the list against the
  standard before citing conformance; see the stamp below.
- **`Tolerance` is a business tolerance**, not a technical one: *"a closure timestamp is accurate to
  the calendar day, beyond which the monthly boundary is wrong"* — never *"timestamp precision
  ≤ 1s"*. [language.md](language.md) § *Demand, not design* applies unchanged.
- **`Source` is `[TBD]` until confirmed.** Nominating a system as the book of record on drafting
  authority is the most common way this register becomes wrong.

## Reconciliation

Where a measure is reported against an obligation, the register carries requirements establishing:
the **source population**; the **included**, **excluded** and **exception** populations; **duplicate
and omission control**; **record-level** and **aggregate** reconciliation; **variance treatment**;
and **restatement treatment**.

**A report is not represented as reconciled while unresolved variances remain**, unless an approved
tolerance explicitly permits it — and that tolerance is itself a register row with a named approver,
never an assumption.

## Competing methodologies

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
  [tables.md](tables.md) § *Scenario*.

**A methodology conflict is never recorded as an assumption.** An assumption is a thing believed
true pending confirmation; a live disagreement between two documented practices is a decision
somebody owns, and filing it as an assumption removes the owner.

## Standards of record

| Standard | Status here |
|---|---|
| **ISO/IEC 25012** | Data quality model. The taxonomy for `DAT-NNN` rows. Same SQuaRE series as ISO/IEC 25010:2023. |
| **ISO/IEC 25024** | Data quality measurement. The measurement side of 25012. |
| **ISO/IEC 20000-1:2018** | IT service management. Source of the service-reporting obligations behind report timeliness and availability rows. |
| **ISO/IEC/IEEE 29148:2018** | Unchanged. Only the evidence satisfying *verifiable* is elaborated here. |
| **OMG DMN** | Decision model and notation. Supplies the decision / decision-logic separation the `BRL-NNN` register uses. |
| **OMG SBVR** | Semantics of business vocabulary and business rules. The vocabulary source where a rule needs one. |
| ISAE 3402 / ASAE 3402 | Assurance over service-organisation controls. **Not a requirements standard.** The reconciliation discipline above is drawn from control practice and is cited as practice, never as an obligation this file imposes. |
| DAMA-DMBOK, BABOK v3 | Practitioner bodies of knowledge. Useful as checklists; neither is cited as the authority for a requirement. |

### Verification stamp

**Adopted from knowledge, not from the standard texts.** The anchors above were selected on the
strength of their scope, and the specific claims below have **not** been checked against the
published documents. This file follows [ai.md](ai.md)'s stamp convention so the gap is visible
rather than assumed.

| Claim | Status |
|---|---|
| ISO/IEC 25012 defines the data quality characteristic names used by `DAT-NNN` | **Unverified** — read the characteristic list before citing conformance |
| An AS/NZS adoption of ISO/IEC 25012 exists | **Unknown.** [ai.md](ai.md) requires the AS designation to be cited where one exists — check before an Australian document cites the ISO number alone |
| ISO/IEC 20000-1:2018 carries the service-reporting clauses attributed to it | **Unverified** |
| DMN's decision / decision-logic separation matches the `BRL-NNN` `Required Decision` column | **Unverified** |

- **Owner:** the maintainer of this ruleset.
- **Re-verify:** before any document authored under this file claims conformance to 25012, 25024 or
  20000-1, and at minimum annually.

## Never

- Never state a reported measure without its population — "all relevant records" specifies nothing.
- Never state a measure without naming the rule set version that produced it.
- Never nominate a system or dataset as authoritative unless the source material confirms it.
- Never represent a report as reconciled while unresolved variances remain, absent an approved
  tolerance carried as its own row with a named approver.
- Never omit the correction path because the figure has not yet been wrong.
- Never record a methodology conflict as an assumption — it is a decision, and it has an owner.
- Never choose between competing methodologies without decision authority.
- Never mint a `D-NNN` here — `/raid` owns the decision namespace.
- Never coin a data quality term where ISO/IEC 25012 supplies one.
- Never state a technical data tolerance where a business one belongs (see [language.md](language.md)).
- Never add a §3 subsection for reporting — these are ordinary requirements in existing subsections.
- Never cite ISAE/ASAE 3402, DAMA-DMBOK or BABOK as the authority for a requirement.
