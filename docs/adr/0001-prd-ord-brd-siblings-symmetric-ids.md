# ADR-0001: PRD and ORD are BRD siblings with symmetric flat IDs

**Date:** 2026-06-19
**Status:** Active

## Context

Forge has two requirements-document skills aligned to formal standards: `/write-prd`
(ISO/IEC/IEEE 29148:2018) and `/write-ord` (ISO/IEC 25010:2023). As the pair was hardened
against requirements-quality standards, three coupled questions surfaced that the two skills
had to answer the *same* way to stay coherent:

1. **How do the documents relate?** Is the flow a linear chain `BRD → PRD → ORD` (so the ORD
   derives from the PRD), or something else?
2. **How are requirements identified?** `/write-prd` shipped with `US-NN` story IDs;
   `/write-ord` had a traceability-matrix appendix referencing `[Req ID]` but assigned no IDs
   at all, so its matrix was structurally unfillable.
3. **Where does joint authoring live?** Teams sometimes write a PRD and ORD together from a
   single source, sometimes only one.

These are hard to change once chosen: IDs are baked into every document authored by the
skills and into both traceability matrices, and the relationship model determines what each
skill reads and traces to. Getting them wrong means a second disruptive rename later (this
ADR records the *first* such rename — `US-NN` → `PRD-001`).

## Options Considered

**Relationship model**
1. **Linear chain `BRD → PRD → ORD`** — ORD reads the PRD and traces to PRD stories. Matches
   the original handoff framing. Couples the two skills: a standalone ORD can't be written
   without a PRD, and the ORD inherits PRD scope decisions.
2. **Siblings under the BRD** *(chosen)* — BRD is the single origin; PRD ("what") and ORD
   ("how it runs") are independent derivations, each written standalone after the BRD. Neither
   reads the other.

**Requirement ID scheme**
1. **Keep `US-NN` (PRD) + add `ORD-<CHAR>-NN`** — minimal rework; characteristic embedded in
   the ORD ID. But the ID churns whenever a requirement is re-classified (e.g. Reliability →
   Security), breaking traceability; and `US-` vs `ORD-` is asymmetric.
2. **Symmetric flat `PRD-001` / `ORD-001`** *(chosen)* — rename `US-NN` → `PRD-001`; flat
   sequential IDs in both. Costs a rename of the just-shipped `/write-prd`, but the IDs are
   stable under re-classification (the 25010 characteristic lives in a matrix column, not the
   ID) and the two schemes mirror each other.

**Joint authoring**
1. **Conditional branch inside `/write-ord`** — one skill reads a PRD if present. Rejected:
   conflicts with the sibling model and overloads a standalone skill.
2. **Separate `/write-reqs` skill** *(chosen, backlogged)* — a composite that authors PRD and
   ORD together from one source, owning the full bidirectional `BRD ↔ PRD ↔ ORD` traceability,
   the shared ID namespace, and the reciprocal NFR-home rule. Should orchestrate the two
   existing skills rather than duplicate them.

## Decision

- **BRD is the single origin. PRD and ORD are siblings**, each authored standalone after the
  BRD. `/write-ord` reads the BRD if present and tags provenance, and explicitly does **not**
  read or trace to a PRD.
- **Requirement IDs are flat and sequential and symmetric**: `PRD-001` for PRD user stories
  (renamed from `US-NN`), `ORD-001` for ORD requirements. The IDs never encode the document's
  theme or quality characteristic.
- **Joint PRD+ORD authoring is a separate skill, `/write-reqs`** (backlogged), not a branch in
  either standalone skill. It assigns prefix by requirement nature — functional/"what" →
  `PRD-001`, operational/NFR/"how it runs" → `ORD-001`.

## Reason

The sibling model reflects how the documents are actually produced — frequently one without
the other — and keeps each skill simple and independently usable; coupling the ORD to a PRD
would force linkage that often doesn't exist. Flat symmetric IDs are stable under
re-classification (the failure mode of the characteristic-embedded alternative) and make the
two skills legible as a matched pair, which justified the one-time `US-NN` → `PRD-001` rename.
Isolating joint authoring in `/write-reqs` keeps the cross-document traceability and NFR-home
complexity in one place instead of half-baking it into both standalone skills (DRY), and
preserves parity with how `/write-prd` already handles "BRD present vs absent" as a conditional
rather than a second skill.

## Consequences

- **Easier:** authoring a PRD or ORD on its own; reading the two skills as symmetric siblings;
  stable requirement IDs that survive re-classification; a single home (`/write-reqs`) for the
  full chain when it is eventually built.
- **Harder / cost incurred:** `/write-prd` required a breaking ID rename (`US-NN` → `PRD-001`,
  shipped as v2.1.1) and any documents already authored with `US-NN` IDs are now on the old
  scheme. The full bidirectional `BRD ↔ PRD ↔ ORD` traceability is deferred until `/write-reqs`
  exists — standalone documents trace only to the BRD (PRD column in the ORD matrix is `—`).
- **Open dependency:** `/write-reqs` design hinges on whether a Forge skill can cleanly invoke
  another skill (orchestrate vs inline) — unresolved, captured in the backlog.

Shipped in Forge v3.12.0 (`/write-ord` v1.1.0, `/write-prd` v2.1.1) via
[PR #19](https://github.com/glensanders-gdev/Forge/pull/19). Design grilled and recorded in
`~/.claude/knowledge/learning/requirements-documents/` (LR-0005, LR-0006).
