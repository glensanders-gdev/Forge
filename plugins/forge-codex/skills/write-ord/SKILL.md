---
name: "write-ord"
description: "Synthesize a call transcript, document, conversation context, or structured notes into a compliant Operational Requirements Document (ORD) organised by ISO/IEC 25010:2023 quality characteristics. Use when the user runs $write-ord, provides a transcript or document to convert into an ORD, or wants to formalise operational requirements from a conversation."
metadata:
  category: pipeline
  version: 1.1.0
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write ORD

Synthesize source material into a structured Operational Requirements Document aligned with ISO/IEC 25010:2023. Runs in two phases with a mandatory confirmation gate between them.

See [REFERENCE.md](REFERENCE.md) for the ISO/IEC 25010:2023 characteristic taxonomy and the full ORD section template.

---

## Phase 1 — AFK Ingest [AFK]

Runs unattended. Extracts and classifies all operational requirements from source material.

### Inputs accepted

- Call transcript (paste or file path)
- Meeting notes or interview notes
- Existing document (Word export, PDF text, markdown)
- Current conversation context
- Any combination of the above

### Phase 1 Process

1. Read all provided source material in full.
2. Read the BRD if one exists (`docs/brd/`) — capture the business objectives this ORD must trace up to. If absent, note it; requirements will trace to their proximate operational source (the source quote or named stakeholder) instead. **Do not read the PRD** — a standalone ORD is a *sibling* of the PRD, not its child; both derive from the BRD. Joint PRD+ORD authoring is the separate `/write-reqs` workflow.
3. Extract every statement that implies an operational need — performance, availability, support, staffing, recovery, compliance, interfaces, security.
4. **Tag provenance as you extract.** For every operational need, record its origin — the BRD objective ID if a BRD exists, otherwise the source quote or named stakeholder. This feeds the BRD Objective and Source columns of the traceability matrix in Phase 2 — capture it now rather than reconstructing it later.
5. Classify each extracted statement against the ISO/IEC 25010:2023 nine characteristics (see [REFERENCE.md](REFERENCE.md)). Flag statements that are too vague to classify.
6. Identify gaps: which characteristics have no coverage in the source material. If a BRD exists, also identify BRD objectives with no resulting operational requirement (coverage gaps).
7. Identify Key Performance Parameters (KPPs) — requirements whose failure constitutes system/program failure. Mark these explicitly.
8. Present the Phase 1 Summary and pause.

### Phase 1 Summary Format

```
## ORD Ingest Summary — [System / Project Name]

### Source Material Processed
- [List each source, including the BRD if found]

### BRD Objectives (origin of scope)
| BRD Objective ID | Business need | Covered by this ORD? |
|---|---|---|
| [BRD-NN or "no BRD found"] | [need] | Yes / Partial / N/A |

### Extracted Requirements by ISO/IEC 25010 Characteristic
| Characteristic | Requirements Found | KPP Candidates | Vague / Needs Clarification |
|---|---|---|---|
| Performance Efficiency | N | N | N |
| Reliability | N | N | N |
| Security | N | N | N |
| [etc.] | | | |

### Coverage Gaps
Characteristics with no source material: [list]
These sections will be scaffolded as TBD in the ORD and flagged for stakeholder input.
If a BRD exists: BRD objectives with no resulting operational requirement: [list, or "none"].

### Vague Statements Requiring Clarification
- "[Quote from source]" — needs: [specific missing detail]

### Proposed System Name
[Inferred from source material or flagged as unknown]

---
Confirm to proceed to Phase 2, or provide corrections and gap-fills before I write the ORD.
```

---

## Phase 2 — HITL Write [HITL]

Runs after human confirms Phase 1 summary. Writes the ORD using the template in [REFERENCE.md](REFERENCE.md).

### Phase 2 Process

1. Incorporate all corrections and gap-fills from the Phase 1 confirmation.
2. Write the ORD following the structure in [REFERENCE.md](REFERENCE.md), populating each section from classified requirements.
3. **Assign every requirement a stable ID** — `ORD-001`, `ORD-002`, … flat and sequential in order of first appearance. The ID never encodes the 25010 characteristic (that lives in the matrix), so re-classifying a requirement never churns its ID. IDs are retired when a requirement is dropped — never reused.
4. For every requirement, write it in testable form: quantified threshold + measurement method. If source material only gives a vague statement, write the requirement with a `[TBD — source: "quoted vague statement"]` placeholder.
5. Mark KPPs explicitly in Section 3 with a **[KPP]** tag.
6. **Populate the Requirements Traceability Matrix (Appendix B)** — one row per `ORD-NNN`: requirement ID → ISO/IEC 25010 characteristic → BRD objective (or `—` if no BRD) → provenance source. Flag any requirement with no BRD objective and no source as **orphan scope**, and any BRD objective with no resulting requirement as a **coverage gap**. Do not silently resolve either.
7. Save to `docs/ord/[system-name]-ORD.md`.
8. Present a coverage summary: which ISO/IEC 25010 characteristics are fully specified, partially specified, or TBD — plus traceability completeness (requirements traced to a BRD objective vs orphan; BRD objectives covered vs gaps).

### Phase 2 Output

- ORD document at `docs/ord/[system-name]-ORD.md`
- Coverage summary in the terminal showing characteristic completeness

---

## Rules

- Never write the ORD without Phase 1 confirmation — the gate is mandatory.
- Never invent requirements not present in or inferable from the source material — use TBD placeholders instead.
- Never leave a requirement in vague form ("should be reliable") — either quantify it or mark it TBD with the source quote.
- Never omit the KPP designation — at least one KPP must be identified or the ORD must note "KPPs not yet designated."
- Never write a requirement without a stable `ORD-NNN` ID, and never reuse a retired ID.
- Never leave the traceability matrix unpopulated — every requirement gets a row; flag orphan requirements and BRD coverage gaps rather than hiding them.
- Never read or trace to a PRD — a standalone ORD is a sibling of the PRD, both deriving from the BRD. Joint PRD+ORD authoring is the `/write-reqs` workflow.
- Never ask the user questions during Phase 1 — extract, classify, then present.
- If no system name can be determined from the source material, flag it in Phase 1 Summary and use `[SYSTEM-NAME-TBD]` in the draft.

## Failure Modes

| Condition | Behaviour |
|---|---|
| Source material is a raw audio transcript with filler words | Clean filler before extracting; note transcript quality in Phase 1 Summary |
| Source has no operational content (e.g. a sales deck) | Stop. Report: "No operational requirements found in source material. An ORD requires performance, support, or operational constraint content." |
| All characteristics are gaps | Proceed — scaffold TBD ORD and note it is a shell requiring stakeholder workshops |
| ORD already exists at the target path | Stop. "An ORD already exists at docs/ord/. Confirm overwrite or provide a new name." |
| Requirements conflict (e.g. 99.99% uptime but no DR budget) | Flag the conflict in Phase 1 Summary — do not silently resolve it |
| No BRD found | Note "No BRD found." Proceed — trace each requirement to its proximate operational source (source quote / stakeholder) instead of a BRD objective. |
| BRD objective produces no requirement, or a requirement has no source/objective | Flag in the traceability matrix as a coverage gap (orphaned objective) or orphan scope (sourceless requirement). Do not silently resolve. |
