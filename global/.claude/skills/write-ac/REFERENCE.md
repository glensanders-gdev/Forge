# Write AC — Reference

Altitude rules, translation patterns, the AC document template, and Jira field mapping for `/write-ac`. The workflow and gates live in [SKILL.md](SKILL.md).

---

## Altitude — what sits at Capability level vs flows down

A Jira Capability is a portfolio-level container. Its acceptance criteria are **conditions of satisfaction**, not test steps. Keep the set small and outcome-defining; detail belongs on child Epics/Stories.

**Promote to Capability AC:**
- Every ORD **[KPP]** — a requirement whose failure constitutes system/program failure. A KPP promotes from **any** register section, §3 through §8.
- Each *headline* functional outcome — the few PRD stories that define "this Capability is done" (typically the primary user outcome per BRD objective).

**Flow to child Epic/Story AC:**
- Detailed story-level criteria — Sunny Day variations, Rainy Day states, Edge Cases.
- Per-story criteria beyond the headline outcome — the `Rainy Day` and `Edge Case` rows, and any `Sunny Day` row that is detail rather than the defining outcome.

Rule of thumb: if removing the criterion would not make a stakeholder say "then the Capability isn't delivered," it belongs on a child issue, not the Capability.

### MoSCoW gate

**Both** sources carry MoSCoW — the ORD register as a column, the PRD as a per-story field. The gate
applies to each equally; a functional story is not exempt because its priority sits in a different
place. It runs **before** the tests above:

| MoSCoW | Outcome |
|---|---|
| `Won't` | **No AC at all.** Out of scope for this release — never translate it. Note it as deliberately excluded. |
| `Could` | Child issue only. Never a Capability AC, whatever else it satisfies. |
| `Should` | Child issue, unless it is a **[KPP]** — a KPP promotes regardless of priority. |
| `Must` | Eligible for Capability AC if it passes the KPP or headline-outcome test above. Not automatic — most Musts are child-issue detail. |

A `Must` is not a KPP and does not promote on priority alone. Most Musts are ordinary delivery scope.

### Delivery enablers do not promote

Requirements in §§5–8 are frequently *enablers* — staffing establishment, training currency,
on-call rosters, change-management cadence, patch windows, SLA governance, infrastructure
provisioning. They are binding, they carry `ORD-NNN`, and they are **not** conditions of
satisfaction for a Capability: no stakeholder says "the Capability isn't delivered" because
operator time-to-competency is 6 days rather than 5.

Enablers flow to child issues (or to the delivery plan) even when marked `Must`. The single
exception is an enabler explicitly tagged **[KPP]** — that promotes like any other KPP.

Test the *nature* of the requirement, not the section it sits in: a §4 data-residency KPP is a
genuine Capability AC; a §6 training commitment is not.

---

## Translation — requirement → acceptance criterion

### Functional (PRD story → AC)

A PRD acceptance criterion is already a declarative row. Carry it across verbatim with its
`PRD-NNN.N` ID; drop the "As a… I want…" narrative — that is context, not a criterion.

PRD-001.1 →
```
AC-001 (PRD-001.1): Checkout for a returning customer with a saved payment
  method completes without card re-entry.
```

> If a criterion arrives hedged — *"then they can complete the purchase"* — rewrite it to the
> declarative end-state form rather than carrying it through. `can [verb]` is banned by
> `language.md`, and a criterion saying a customer *can* do something cannot fail a test. A
> criterion inherits a requirement's meaning, never its defects.

### Operational (ORD requirement → AC)

An ORD register row is already a declarative statement plus a `Verification` method — that *is* an acceptance criterion. Carry the `Requirement Description` and the `Verification` across verbatim; never drop the verification method.

ORD-004 [KPP] →
```
AC-002 (ORD-004, KPP): p95 checkout latency ≤ 800ms under 500 concurrent
  users, verified by load test in staging.
```

Keep the source ID and the KPP marker in the AC text so traceability survives the move into Jira.

### Verbatim vs reference

These pull in opposite directions, so the boundary is fixed:

- **Carry verbatim:** the testable condition and its verification method. The AC lands in Jira, where the source document is not reachable — a criterion that cannot be read standalone is useless there.
- **Never carry:** the story narrative, the full register row, priority, timing, delivery agent, or comments. Those stay in the source.
- **The source document remains authoritative.** The AC is a carried copy, not a second source of truth. A value that needs changing is changed in the PRD/ORD and `/write-ac` re-run — never edited in the AC document.

---

## AC Document Template

Saved to `docs/ac/[capability-name]-AC.md`.

```markdown
# Acceptance Criteria: [Capability name]

**Date:** YYYY-MM-DD
**Jira Capability:** [CAP-NN or "not linked"]
**Sources:** [PRD path / "none"] · [ORD path / "none"]

## Capability Acceptance Criteria
Conditions of satisfaction for the Capability. KPPs + headline outcomes only.

| AC ID | Criterion | Source | Verification |
|-------|-----------|--------|--------------|
| AC-001 | [declarative testable condition, carried verbatim] | PRD-002 | [test / measure] |
| AC-002 | [declarative testable condition, carried verbatim] | ORD-004 (KPP) | [carried from the register's Verification] |

`Verification` is a carried copy — the source PRD/ORD stays authoritative. Change it there and
re-run `/write-ac`; never edit it here.

## Child Epic / Story Acceptance Criteria
Detailed criteria that flow to child issues under the Capability.

### [Epic / Story title] — [PRD-NNN]
- AC-NNN (PRD-NNN): [declarative testable condition]
- AC-NNN (PRD-NNN): [edge / error case, declarative]

## Traceability
| AC ID | Source req | Altitude | Jira issue |
|-------|-----------|----------|------------|
| AC-001 | PRD-002 | Capability | [CAP-NN / TBD] |
| AC-003 | PRD-005 | Story | [TBD] |

- An AC with no source req is invalid — every AC traces to a PRD-NNN or ORD-NNN.
- A KPP with no Capability AC is a gap — flag it.
```

---

## Jira Field Mapping

| AC location | Jira target |
|-------------|-------------|
| Capability AC | The Capability's Acceptance Criteria field (or description AC block) |
| Child Epic/Story AC | The corresponding child issue's Acceptance Criteria field |
| Source ID (PRD-NNN/ORD-NNN) | Keep inline in the AC text + the Forge↔Jira map in `/link-jira` |

Push is performed via the `jira` MCP through `/jira`, behind the typed `PUSH` gate in SKILL.md Phase 2. Child issues that do not yet exist in Jira are listed for the human to create — this skill does not auto-create issues.
