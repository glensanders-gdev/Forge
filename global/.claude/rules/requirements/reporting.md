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

**A reported measure is not specified until its population, its clock, its rules, its lineage and
its correction path are stated. The figure alone is a display; the five together are a measure.**

The failure this file exists to prevent is a requirement that names an output — *"a monthly
compliance report is produced"* — and leaves unstated which records it counts, which it excludes,
when its clock starts and stops, which version of the rules produced it, and what happens when it is
later found wrong. Every one of those is discovered during an audit rather than during design.

## The measure definition

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
> ✓ `The monthly compliance figure counts every service order closed in the calendar month in the reporting entity's local time, excluding orders cancelled by the customer, classified under the BRL-004 rule set version in force at closure, counted to a cut-off five business days after month end with later-arriving closures carried into a restatement of that month, and each counted order is traceable to its source record by a stable identifier that survives restatement.`

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
| The measurement clock — period boundary, start event, stop event, excluded duration | ORD § 3.8.1 |
| Cut-off, and treatment of data arriving after it | ORD § 3.8.1 |
| Granularity and the dimensions the measure is disaggregated by | ORD § 3.8.1 |
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
| **ISO/IEC 25012:2008** | Data quality model — fifteen characteristics. The taxonomy for `DAT-NNN` rows. Same SQuaRE series as ISO/IEC 25010:2023. Australian adoption: **AS/NZS ISO/IEC 25012:2013**, identical, reconfirmed 2024. |
| **ISO/IEC 25024:2015** | Data quality measurement. The measurement side of 25012. Australian adoption: **AS ISO/IEC 25024:2019** — **AS**, not AS/NZS. The series is not uniform; check each designation rather than pattern-matching off its sibling. |
| **ISO/IEC 20000-1:2018** | IT service management, third edition. **Clause 9.4 Service reporting** is the source of the service-reporting obligations behind report timeliness and availability rows — but the 2018 edition deliberately moved the detailed reporting requirements out of that clause and into the clauses where the reports are produced, so 9.4 is the hook and not the whole obligation. Amended by **ISO/IEC 20000-1:2018/Amd 1:2024**. Australian adoption: **AS/NZS ISO/IEC 20000.1:2019** — note the **dot** in the part number — reissued November 2024 incorporating Amendment No. 1. |
| **ISO/IEC/IEEE 29148:2018** | Unchanged. Only the evidence satisfying *verifiable* is elaborated here. |
| **OMG DMN 1.5** | Decision model and notation. §5.3.1 and clause 7 supply the decision / decision-logic separation the `BRL-NNN` register uses. 1.5 (August 2024) is the current formal version; 1.6 and 1.7 are beta and are not cited. |
| **OMG SBVR** | Semantics of business vocabulary and business rules. The vocabulary source where a rule needs one. |
| ISAE 3402 / ASAE 3402 | Assurance over service-organisation controls. **Not a requirements standard.** The reconciliation discipline above is drawn from control practice and is cited as practice, never as an obligation this file imposes. |
| DAMA-DMBOK, BABOK v3 | Practitioner bodies of knowledge. Useful as checklists; neither is cited as the authority for a requirement. |

### Verification stamp

**Verified 2026-09-07 by Glen Sanders.** The four claims below were previously recorded as adopted
from knowledge and unchecked. Two are now confirmed against the publisher's own text; two rest on
national-body and distributor records because the ISO texts are paywalled and were not purchased.
Following [ai.md](ai.md)'s convention, **what was not read is recorded as plainly as what was** —
this stamp narrows the gap and does not close it.

| Claim | Status | Checked against |
|---|---|---|
| ISO/IEC 25012 defines the data quality characteristic names used by `DAT-NNN` | **Verified — secondary sources only.** Fifteen characteristics; all names used in this file are among them | ISO catalogue abstract; a peer-reviewed application of 25012; the OMG DIDO wiki entry; iso25000.com |
| An AS/NZS adoption of ISO/IEC 25012 exists | **Verified — it does.** `ai.md`'s rule bites: **AS/NZS ISO/IEC 25012:2013**, identical adoption, current and reconfirmed 2024 | Standards Australia distributor record; corroborated by the scope statement of AS ISO/IEC 25024:2019, which names AS/NZS ISO/IEC 25012 as the source of the characteristics it measures |
| ISO/IEC 20000-1:2018 carries the service-reporting clauses attributed to it | **Verified — primary text.** Clause **9.4 Service reporting**, under clause 9 Performance evaluation. The foreword's change item (j) records that detailed reporting requirements were moved out of the service reporting clause into the clauses where the reports are produced | ISO's own redline preview of ISO/IEC 20000-1:2018 — table of contents and foreword |
| DMN's decision / decision-logic separation matches the `BRL-NNN` `Required Decision` column | **Verified — primary text.** DMN §5.3.1 defines a decision as *the act of determining an output value from a number of input values, using logic defining how the output is determined*; clause 7 defines how the decision requirements level and the decision logic level relate. The column states the first and excludes the second | OMG DMN 1.5 specification, §5.3.1 and clause 7 |

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

## Never

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
- Never state a technical data tolerance where a business one belongs (see [language.md](language.md)).
- Never add a §3 subsection for reporting — these are ordinary requirements in existing subsections.
- Never cite ISAE/ASAE 3402, DAMA-DMBOK or BABOK as the authority for a requirement.
