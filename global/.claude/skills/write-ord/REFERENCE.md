# write-ord Reference

The rules both phases rely on — what the ORD is and is not, how a requirement's maturity is stated,
what makes a KPP — and the declared deviation from the requirements-documents pack. Split by when
the skill reads it:

| File | Holds | Read in |
|---|---|---|
| **REFERENCE.md** (this file) | Demand-side scope · requirement status taxonomy · KPPs · deviation map to the pack | Both phases |
| [TAXONOMY.md](TAXONOMY.md) | ISO/IEC 25010:2023 characteristics · ISO/IEC 25059:2023 AI extension · 2011→2023 changes | Phase 1 — classification and gap check |
| [ELICITATION.md](ELICITATION.md) | Elicitation lenses · consistency sweep · extraction judgement | Phase 1 — extraction |
| [TEMPLATE.md](TEMPLATE.md) | The eighteen-section ORD template · supporting views · worked register extract | Phase 2 — writing and self-check |

---

## Demand-side scope — what this ORD is, and is not

**The ORD states quantified business demand. It never states the technical target that satisfies
it.** See `~/.claude/standards/requirements/language.md` § *Demand, not design*. The ORD precedes
solutioning: architecture, security, operations and service management sit **downstream** and
answer this document. They do not contribute to it.

**Four artefacts, four questions.** The core ORD explains *what outcome is required*. The Business
Rules Appendix (§13) explains *how decisions are made*. The Reporting Requirements Appendix (§14)
explains *what reporting consumers need*. The design response explains *how it will be implemented*
— and is not this document.

Sections inherited from the DoD/DHS acquisition ORD — where the document covered an entire physical
system entering service — are not part of a 25010-anchored ORD covering process and system change.

| Classic section | Treatment |
|---|---|
| Staffing and organisational requirements | **Out of scope** — stated in §4.2, content raised is referred (§10.3) |
| Infrastructure and facilities | **Out of scope** — stated in §4.2, answered in the design response |
| Support model (tiers, FTE, rosters) | **Out of scope.** The operating model is the design response's to specify |
| Supportability of the system | **In scope**, under Maintainability — what must be observable, diagnosable and recoverable, and what a support function resolves without engineering |
| Operational hours and escalation expectations | **In scope**, as business demand at §7.12 — the tolerance, never the roster |

**§4.2 names all three exclusions in every ORD**, even where nobody raised them. A declared exclusion
is visible where a silent omission is not — the same rule applied to the nine characteristics.

---

## Requirement status taxonomy

**Scope never varies. Maturity does.** All nine ISO/IEC 25010:2023 characteristics appear in every
ORD. A characteristic with nothing to state carries an explicit statement of that fact, never an
omission. Status describes the maturity of a **business demand statement**, not of a technical
threshold — the ORD carries no technical thresholds.

| Status | Definition | Evidence required |
|---|---|---|
| **Committed** | The business owner has stated and agreed the tolerance, and it traces to an obligation, contract, incident record or explicit business decision | Owner name, date, forum, and the underlying source |
| **Provisional** | The tolerance derives from something real — an existing SLA, contract, incident history, an analogous service — but no business owner has confirmed it applies here | Source citation |
| **Assumed** | No business owner and no documentary source; the figure is a stated assumption | An `ASM-NNN` row that is testable, with a named owner, a confirm-by date, and the consequence if wrong |

**The document tier is the weakest status carried by any KPP-bearing requirement** — the KPPs
themselves, and the recovery, availability and capacity demands they depend on. A minor attribute at
`Assumed` does not set the tier; a KPP at `Assumed` does.

**An `Assumed` entry without an owner and a confirm-by date is not an assumption — it is an invented
number**, and it is the largest audit exposure an ORD carries. ISO/IEC/IEEE 29148:2018 requires
traceability, not finality: a TBD with an owner and a date conforms; a silent gap does not.

---

## Key Performance Parameters

A KPP is a requirement whose failure means the capability is **unfit for purpose**, not merely
degraded. State it as a **business-failure threshold** — the point at which the business consequence
becomes unacceptable, and what makes it unacceptable: a breached obligation, a contractual penalty,
an unrecoverable customer impact. That is what makes a KPP sourceable from contracts and incident
history rather than requiring an engineer.

**Every KPP carries threshold and objective as two labelled values** — the minimum acceptable and
the desired — inside its `Business Tolerance`. Collapsing *"restorable within one business day /
within four hours"* to a single figure is the most common way KPP intent is lost, and it happens
silently downstream after the author's involvement has ended.

Typical KPP candidates:

- The core business outcome cannot be produced at all.
- Populations cannot be reconciled.
- Results cannot be reproduced or audited.
- Records are duplicated or silently omitted.
- The change produces an unauthorised effect on existing customer, SLA or financial treatment.

**Not every Must is a KPP.** MoSCoW, `KPP` and `Status` are three orthogonal axes — see
`~/.claude/standards/requirements/tables.md`. A KPP that cannot reach at least `Provisional` inside the
window is the one item warranting escalation rather than quiet degradation.

---

## Deviations from the requirements-documents pack

`review-ord`'s criteria extract carries the pack's § *The demand-side ORD section template*, which
declares the ORD structure fixed at §1–§9 plus Appendices A–E. **From write-ord 3.0.0 this document
uses a different, business-first structure**, and the deviation is declared here rather than
discovered by a reviewer.

**Why.** Field use showed the pack's order reads as a design and governance specification: the
executive reads three sections before learning what outcome is wanted, and detailed controls crowd
the requirements an approver has to sign. The 3.0.0 order leads with the outcome, keeps the register
at executive altitude, and moves *how decisions are made* (§13) and *what reporting consumers need*
(§14) into appendices.

**Content is unchanged in kind; only its place moves.** Every item the pack's gate (OH-1 – OH-15)
assesses is still produced. A reviewer applying the pack resolves each pack section through this
map:

| Pack § | Pack section | This document |
|---|---|---|
| — | Executive Summary *(not in pack)* | **§1** — mandatory |
| 1.1 | Purpose | §2.1 |
| 1.2 | Business objective traced from the BRD | §2.2 |
| 2.1 | Business context | §2.3 |
| — | Target operational state *(not in pack)* | §2.4 |
| — | Operational problem statement *(not in pack)* | §3 |
| 1.3 | Operational scope, in and out | §4.1, §4.2 |
| 2.2 | Impact register | §4.3 |
| — | Operational actor register *(not in pack)* | §4.4 |
| 1.4 | Related documents | §4.5 |
| 1.5 | Definitions | §5 (with acronyms) |
| — | Operational objectives *(not in pack)* | §6 |
| 3.1–3.9 | The nine ISO/IEC 25010 characteristics | **§7.1–§7.9** — sub-numbering unchanged, so pack §3.x.y is §7.x.y |
| 3.10 | Coverage gaps | §7.10 |
| 4 | Operating environment and constraints | §7.11 |
| 5 | Operational hours and escalation tolerance | §7.12 |
| 6 | *Not used* — staffing | Declared out of scope in §4.2 |
| 7 | Service level requirements (view) | §7.13 |
| 8 | *Not used* — infrastructure | Declared out of scope in §4.2 |
| 9 | Trade-offs, risk and dependencies | §8 Decisions (8.1 open, 8.2 trade-offs and risks) · §10.1 Dependencies |
| — | Related initiatives *(not in pack)* | §10.2 |
| App. A | Traceability | §11 |
| App. B | Assumption register | **§9** — promoted to the body |
| App. C | Referred requirements | §10.3 |
| App. D | ORD → SOAP conformance | §17 |
| App. E | Scenario catalogue | §15 |
| 2.3 | Entry position record | §12 |
| — | Business rules *(pack: conditional, declared)* | §13 — every ORD, declared |
| — | Reporting detail *(not in pack)* | §14 — where `reporting.md` fires |
| — | Interface detail · Change history | §16 · §18 |

**The 25010 sub-numbering is the one thing deliberately kept.** §7.x.y equals pack §3.x.y in every
ORD, so the requirement-to-section map, the nine-characteristics quick reference and the
`reporting.md` / `ai.md` class maps translate by one digit and no lookup.

Also retained as extensions: `IMP-NNN.Treatment` (scope disposition, enum closed in `tables.md`),
and `MoSCoW` in the register (`/write-ac` gates AC altitude on it).

**Raise this to the pack separately.** A deviation declared is a deviation visible; one carried
silently becomes an apparent defect the first time someone reviews against the pack alone.
