# Write AC — Reference

Altitude rules, translation patterns, the AC document template, and Jira field mapping for `$write-ac`. The workflow and gates live in [SKILL.md](SKILL.md).

---

## Altitude — what sits at Capability level vs flows down

A Jira Capability is a portfolio-level container. Its acceptance criteria are **conditions of satisfaction**, not test steps. Keep the set small and outcome-defining; detail belongs on child Epics/Stories.

**Promote to Capability AC:**
- Every ORD **[KPP]** — a requirement whose failure constitutes system/program failure.
- Each *headline* functional outcome — the few PRD stories that define "this Capability is done" (typically the primary user outcome per BRD objective).

**Flow to child Epic/Story AC:**
- Detailed story-level criteria — happy-path variations, edge cases, error states.
- Per-story Given/When/Then beyond the headline outcome.

Rule of thumb: if removing the criterion would not make a stakeholder say "then the Capability isn't delivered," it belongs on a child issue, not the Capability.

---

## Translation — requirement → acceptance criterion

### Functional (PRD story → AC)

A PRD story's acceptance criteria are already in Given/When/Then. Copy the testable condition, carry the `PRD-NNN` ID, and drop the "As a… I want…" narrative — that is context, not a criterion.

PRD-002 story →
```
AC-001 (PRD-002): Given a returning user with a saved payment method,
  when they reach checkout, then they can complete the purchase without
  re-entering card details.
```

### Operational (ORD requirement → AC)

An ORD requirement is already `threshold + measurement method` — that *is* an acceptance criterion. Copy both halves verbatim; never drop the measurement method.

ORD-004 [KPP] →
```
AC-002 (ORD-004, KPP): p95 checkout latency ≤ 800ms under 500 concurrent
  users, verified by load test in staging.
```

Keep the source ID and the KPP marker in the AC text so traceability survives the move into Jira.

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
| AC-001 | [Given/When/Then or threshold+measurement] | PRD-002 | [test / measure] |
| AC-002 | [...] | ORD-004 (KPP) | [load test] |

## Child Epic / Story Acceptance Criteria
Detailed criteria that flow to child issues under the Capability.

### [Epic / Story title] — [PRD-NNN]
- AC-NNN (PRD-NNN): Given … When … Then …
- AC-NNN (PRD-NNN): [edge / error case]

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
| Source ID (PRD-NNN/ORD-NNN) | Keep inline in the AC text + the Forge↔Jira map in `$link-jira` |

Push is performed via the `jira` MCP through `$jira`, behind the typed `PUSH` gate in SKILL.md Phase 2. Child issues that do not yet exist in Jira are listed for the human to create — this skill does not auto-create issues.
