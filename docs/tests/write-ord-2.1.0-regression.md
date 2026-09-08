# /write-ord 2.1.0 — regression suite

Fifteen cases covering the elicitation lenses added in v4.9.0. Each states the **expected Phase 1
behaviour** (before the gate) and the **expected Phase 2 treatment** (after human confirmation).

**The suite's single invariant:** every case that adds a register row does so *only* where the
source carried the tolerance and its evidence. A case whose source is silent must produce a `[TBD]`,
a §3.10 gap, an `ASM-NNN`, a decision item, or a `REF-NNN` — never a row.

| # | Case | Expected Phase 1 | Expected Phase 2 |
|---|---|---|---|
| 1 | **Simple access requirement** — "field technicians view job history" | Lens 8 fires. Read/create/update/delete/approve/execute/override/administer/audit distinguished; bulk authority asked separately. Source states read only → the other verbs are gaps, not denials | One `ORD-NNN` at §3.3.1 Confidentiality. Unstated verbs stay `[TBD]` or listed at §3.10. No entitlement matrix unless it aids comprehension |
| 2 | **State-transition requirement** — order moves Pending → Active | Lens 2 fires. Starting state, trigger, eligibility, authorised initiator, permitted and prohibited transitions, resulting state, downstream/notification/reporting/billing consequence extracted. Rollback after failure and reversal after success reported **separately**; the one the source omits is a gap | Rows at §3.3.2 Integrity and §3.8.1; `BRL-NNN` for the eligibility decision; `SCN-NNN` per transition. A lifecycle view permitted, citing IDs only |
| 3 | **Bulk update with partial failure** | Lens 6 fires. Bulk validation, partial-failure treatment, bulk summary, manual fallback each asked. Source silent on bulk → reported as gaps, **never** carried across from the individual case | Individual requirement written. Bulk rows only where the gate supplied them; otherwise §3.10 rows with a named action |
| 4 | **Manual vs automated workflow** | Lens 6 and lens 5 fire. Mode switching, who authorises it, human review, override, approval, reprocessing extracted. Automation does **not** discharge exception handling or attribution | Rows at §3.8.1 and §3.2.2 Fault Tolerance. Operating-model design (tiers, rosters, queue structure) → Appendix C `REF-NNN`, never §5 or §6 |
| 5 | **Cross-party action affecting another party** — one RSP's change alters another's service | Lens 7 fires. Derived consequence **named** and taken to the gate for the affected business owner's explicit confirmation. Authority never inferred from a role name | Row only if confirmed at the gate. Unconfirmed → decision item at §9.2 with `[D-TBD]` where no RAID log exists |
| 6 | **Reported regulatory measure** | `reporting.md` trigger answered **Yes** explicitly. Five-part measure definition checked: population, **clock**, rule set and version, lineage, correction path. Elapsed measure → start event, stop event, excluded intervals. Period measure → boundary, cut-off, late-arriving treatment | Rows in the class-map subsections (no new §3 subsection). `DAT-NNN` register at Appendix H. Missing clock parts carried as `[TBD — source: "…"]` |
| 7 | **Conflicting methodologies** — operational practice vs contractual practice | Lens 14 and existing methodology detection both fire. **Both positions preserved.** Never filed as an assumption | Decision item at §9.2 citing `D-NNN` (or `[D-TBD]`), affected requirements named, comparison scenario carried where material to a reported figure |
| 8 | **Diagnostic threshold shared across channels** | Lens 11 fires. Threshold consistency across channels and cross-channel outcome consistency checked. Two different values for the same threshold → a **consistency finding, not a confirmation** | Rows at §3.6.2 Analyzability and §3.2. Divergence → decision item. False-positive/negative consequence recorded where stated, gap where not |
| 9 | **Source containing only technical targets** (RTO 4h, 99.95%) | Demand-side rewrite table populated. Where the business tolerance cannot be recovered, listed as a gap. Lens 11's engineering-threshold trap applies to diagnostic figures | Technical wording kept as `Source` evidence only. Tolerance `[TBD]`. **No technical figure reaches a `Business Tolerance` cell** |
| 10 | **Missing owner and missing threshold** | Every affected row `Provisional` at best, `Assumed` where no documentary source exists. E2/E3 entry-position gap recorded. Document tier computed from the weakest KPP-bearing status | `[TBD — source: "…"]` in the tolerance; no invented owner. Any `Assumed` row cites an `ASM-NNN` carrying owner, confirm-by and `If false` |
| 11 | **Source containing duplicate requirements** | Lens 14 consolidates. Statements differing in actor, trigger, outcome, population or failure condition are **not** duplicates and stay separate | One authoritative row per commitment. Section 7 and any view cite it; neither restates the value |
| 12 | **Correctly processed rejection** — application assessed and declined | Determination requirement flagged if it carries only a Favourable Sunny Day row. Adverse Sunny Day drafted. Inconclusive / insufficient-data behaviour asked where the source supports it | Two Sunny Day `SCN-NNN` rows (`Outcome: Favourable` / `Adverse`). Declined outcome **never** classed Rainy Day. No fourth scenario value |
| 13 | **Source containing a design prescription** — "the solution shall ensure database rollback" | Wrapper stripped; mechanism removed where the business-visible outcome stands alone. Rewrite recorded in the demand-side rewrites table | `A failed update leaves the last valid record unchanged` as the tolerance. Mechanism retained as `Source` evidence, Appendix E, a §4 constraint, or Appendix C |
| 14 | **Commercial or billing consequence** | Lens 12 fires. Charge commencement/cessation, rebate eligibility, effective date, billing stop/restart, downstream notification, invoice representation, dispute handling, reconciliation to applied amount asked. Source silent → **"not evidenced"**, never "no impact" | `IMP-NNN` for the touched billing workflow with its named owner; `BRL-NNN` where eligibility logic exists; `REF-NNN` where commercial owns the answer. No invented billing effect |
| 15 | **Supporting entitlement matrix** with `Yes*` / `No*` | Asterisk identified as an unwritten condition. Its meaning asked at the gate | Matrix carries a legend defining every decision value and distinguishing confirmed / denied / conditional / unresolved. The condition is written into the `BRL-NNN` or `ORD-NNN` row the cell cites, never into the matrix. Matrix headed as a view, introducing no new value |

## Invariants to re-check on any future edit

1. Two-phase gate mandatory; Phase 2 never begins before confirmation.
2. All nine ISO/IEC 25010 characteristics present; §6 and §8 numbered and empty.
3. Scenario values are `Sunny Day` / `Rainy Day` / `Edge Case`; `Outcome` is `Favourable` / `Adverse` / `—`.
4. No `Delivery Agent`, `Operational Owner`, `Timing`, `Verification` or `Rationale` column in the register.
5. `EVL-NNN` and `MDL-NNN` are minted here; `AC-NNN` and `D-NNN` are not.
6. `ai.md` and `reporting.md` triggers answered independently and explicitly.
7. MoSCoW never defaulted; KPP designation never self-served.
8. A lens with no trigger is not run and is **not** a coverage gap.
9. A lens that runs and finds nothing reports "not evidenced", never "satisfied".
10. Executive Summary, where written, restates no value a row carries.

---

## Addendum — structural additions (round 2)

| # | Case | Expected Phase 1 | Expected Phase 2 |
|---|---|---|---|
| 16 | **Source states a problem as a solution** — "we need a new portal" | Extracted, then flagged: names a product. Reported under "Problems stated as a solution rather than a problem" | §1.6 carries the rewritten problem, mechanism removed. Portal reference retained as `Source` evidence only |
| 17 | **Impact identified, treatment unstated** | `Treatment` is `[TBD]`, listed at the gate. **`No change required` never inferred from silence** | `[TBD]` in the cell unless the gate supplied the disposition |
| 18 | **Source states a design disposition** — "billing will be decommissioned" | Refused as a treatment. Wording kept as `Source` evidence | `Treatment` set from the scope enum; the decommission question referred (Appendix C) |
| 19 | **Impact excluded in both §1.3 prose and `Treatment`** | Consistency-sweep finding — one commitment, two editable places | `Treatment` authoritative. §1.3 becomes a view citing `IMP-NNN` |
| 20 | **Role name is the only evidence of authority** — "the approver signs off" | Actor recorded with operational role. Authority `[TBD]` — never inferred from the name | §2.6 row with `Owner` `[TBD]` + confirm-by. No authority requirement written |
| 21 | **Executive Summary re-tells §1.1 and §2.1** | n/a — Phase 2 defect | Summary omitted, or rewritten to why / tier / what is open. **It never describes the operating state** — that is §2.5 |
| 22 | **§2.5 cannot be written without naming a mechanism** | Source gave a solution, not a target state | §2.5 states what holds regardless of mechanism; the rest referred and flagged |
| 23 | **Form self-check on a first draft** | n/a | Rows checked and rows corrected both reported. **Zero corrections on a first draft means the check was not run** |
