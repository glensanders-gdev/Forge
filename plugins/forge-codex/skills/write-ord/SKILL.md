---
name: "write-ord"
description: "Synthesize a call transcript, document, conversation context, or structured notes into a compliant Operational Requirements Document (ORD) organised by ISO/IEC 25010:2023 quality characteristics. Use when the user runs $write-ord, provides a transcript or document to convert into an ORD, or wants to formalise operational requirements from a conversation."
metadata:
  category: pipeline
  version: 1.4.0
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write ORD

Synthesize source material into a structured Operational Requirements Document aligned with ISO/IEC 25010:2023. Runs in two phases with a mandatory confirmation gate between them.

See [REFERENCE.md](REFERENCE.md) for the ISO/IEC 25010:2023 characteristic taxonomy and the full ORD section template.

**Authoring standards — read before writing any requirement:**
- `~/.codex/forge/rules/requirements/language.md` — wording, voice, banned modals and constructions
- `~/.codex/forge/rules/requirements/tables.md` — table-first presentation, canonical schemas, ID namespaces, the coverage-gap collapse rule

These are authoritative and shared with `$write-prd`, `$write-reqs` and `$write-ac`. Never restate them here.

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

0. **Check for a joint-authoring brief.** When invoked by `$write-reqs`, a brief accompanies the invocation carrying (a) the ORD-bound half of the classified source and (b) the NFR citations the PRD makes. Treat the brief's half as the **extraction scope** — not a hint — and do not re-extract functional needs already routed to the PRD. The brief's NFR citations exist so this ORD can own what the PRD cites without reading the PRD. Absent a brief, this is a standalone run; proceed from step 1 as normal.
1. Read all provided source material in full.
2. Read the BRD if one exists (`docs/brd/`) — capture the business objectives this ORD must trace up to. If absent, note it; requirements will trace to their proximate operational source (the source quote or named stakeholder) instead. **Do not read the PRD** — a standalone ORD is a *sibling* of the PRD, not its child; both derive from the BRD. Joint PRD+ORD authoring is the separate `$write-reqs` workflow, which supplies PRD NFR citations via the brief rather than by having this skill read the PRD.
3. Extract every statement that implies an operational need — performance, availability, support, staffing, recovery, compliance, interfaces, security.
4. **Tag provenance as you extract.** For every operational need, record its origin — the BRD requirement ID if a BRD exists, plus the source as Business Unit, Function and Name. These become the `BRD#` and `Source` columns of the register itself, so capture them now rather than reconstructing them later. Also capture, where the source states it: MoSCoW priority, required live date, and the department accountable for delivery.
5. Classify each extracted statement against the ISO/IEC 25010:2023 nine characteristics (see [REFERENCE.md](REFERENCE.md)). Flag statements that are too vague to classify.
6. Identify gaps at **sub-characteristic** level — check every sub-characteristic in the REFERENCE.md taxonomy, not only the subsections pre-scaffolded in the template. Characteristic-level checking hides gaps inside a partially-covered characteristic. If a BRD exists, also identify BRD objectives with no resulting operational requirement.
7. Extract **assumptions and dependencies** as first-class items. If an idea file exists at `~/.codex/forge/ideas/active/`, carry its `Assumptions to Validate` rows forward with their Status rather than restating them as prose — they keep their identity into this document.
8. Identify Key Performance Parameters (KPPs) — requirements whose failure constitutes system/program failure. Mark these explicitly.
9. Present the Phase 1 Summary and pause.

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
Sub-characteristics with no source material: [list]
These are omitted from the ORD body and listed once in the §3.10 Coverage Gaps table — not scaffolded as an empty table each.
If a BRD exists: BRD objectives with no resulting operational requirement: [list, or "none"].

### Assumptions and Dependencies
| Carried from | Assumptions | Dependencies |
|---|---|---|
| [idea file / source material / none] | N | N |

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
3. **Assign every requirement a stable ID** — `ORD-001`, `ORD-002`, … flat and sequential in order of first appearance. The ID never encodes the 25010 characteristic (the subsection heading supplies it), so moving a requirement between subsections never churns its ID. IDs are retired when a requirement is dropped — never reused.
4. **Write every requirement per the shared rules** — wording follows `rules/requirements/language.md`, the register schema follows `rules/requirements/tables.md`. A complete row is a declarative `Requirement Description` carrying its own quantified value, plus a `Verification` method; a quantified but hedged requirement fails. Where source material gives no value, write `[TBD — source: "quoted vague statement"]` — never invent one. Leave `Capability` and `Epic` as `—`; `$write-ac` writes them back.
5. **Every binding statement in Sections 3–8 is a row with an `ORD-NNN` ID** — not Section 3 alone. Operating environment, patch SLAs, alert thresholds, staffing commitments, SLA governance and infrastructure are requirements and carry IDs. Section 7 is a **view**: it cites existing IDs and introduces no new values. Mark KPPs by prefixing `Requirement Description` with **[KPP]** — MoSCoW priority is a separate column and does not replace it.
6. **Record assumptions and dependencies as tables** in §9.2 and §9.3 using the `ASM-NNN` / `DEP-NNN` schemas. Carry forward any `$idea` assumptions with their Status. Every assumption states `If false`.
7. **Check traceability against the register itself** — `BRD#` and `Source` live in every row, so there is no separate matrix to populate. Flag any row with `BRD#` = `—` **and** no `Source` as **orphan scope**, and any BRD requirement with no resulting register row as a **coverage gap**. Do not silently resolve either. Appendix B holds only the PRD cross-link and is omitted entirely for a standalone ORD; `$write-reqs` populates it.
8. Save to `docs/ord/[system-name]-ORD.md`.
9. Present a coverage summary: which ISO/IEC 25010 sub-characteristics are fully specified, partially specified, or listed in §3.10 — plus traceability completeness (requirements traced to a BRD objective vs orphan; BRD objectives covered vs gaps) and counts of assumptions and dependencies recorded.

### Phase 2 Output

- ORD document at `docs/ord/[system-name]-ORD.md`
- Coverage summary in the terminal showing characteristic completeness

---

## Rules

- Never write the ORD without Phase 1 confirmation — the gate is mandatory.
- Never invent requirements not present in or inferable from the source material — use TBD placeholders instead.
- Never leave a requirement in vague or hedged form — see `rules/requirements/language.md`. Quantification alone is not enough: "should respond within 3 seconds" is quantified and still fails. Quantify *and* write it as a declarative end state, or mark it TBD with the source quote.
- Never express a binding statement as free-text prose **anywhere in Sections 3–8** — not Section 3 alone. Every requirement is a register row; per-interface technical detail goes to Appendix E keyed by `ORD#`.
- Never split a value out of `Requirement Description` into its own column — the declarative end state carries its own number. Never leave `Verification` blank; `$write-ac` rejects the requirement.
- Never fill `Capability` or `Epic` at authoring time — `$write-ac` writes them back.
- Never put a commitment in `Comments` — if it binds, it belongs in `Requirement Description`.
- Never scaffold an empty table for a subsection with no requirement — omit the subsection and list it once in the §3.10 Coverage Gaps table.
- Never restate a value that already exists as a row — Section 7 and any other summary is a **view** citing existing IDs, never a second editable source of truth.
- Never self-serve the "KPPs not yet designated" note. If no KPP is identifiable from the source, raise it as an explicit question at the Phase 1 gate and record the human's answer — the designation is a human decision, not a default the draft can take for itself.
- Never write a requirement without a stable `ORD-NNN` ID, and never reuse a retired ID. Assumptions and dependencies use `ASM-NNN` / `DEP-NNN` — never a single-letter prefix, which collides with `$raid`.
- Never record an assumption without an `If false` consequence, and never leave a falsified assumption unescalated — set `Status: Falsified` and raise it via `$raid add risk`.
- Never restate `BRD#` or `Source` in a separate traceability matrix — they live in the register row. Flag orphan requirements and BRD coverage gaps against the register rather than hiding them.
- Never read or trace to a PRD — a standalone ORD is a sibling of the PRD, both deriving from the BRD. Joint PRD+ORD authoring is the `$write-reqs` workflow.
- Never ask the user questions during Phase 1 — extract, classify, then present.
- If no system name can be determined from the source material, flag it in Phase 1 Summary and use `[SYSTEM-NAME-TBD]` in the draft.

## Failure Modes

| Condition | Behaviour |
|---|---|
| Source material is a raw audio transcript with filler words | Clean filler before extracting; note transcript quality in Phase 1 Summary |
| Source has no operational content (e.g. a sales deck) | Stop. Report: "No operational requirements found in source material. An ORD requires performance, support, or operational constraint content." |
| All characteristics are gaps | Proceed — the body carries no requirement tables and every sub-characteristic is listed in §3.10. Note the ORD is a shell requiring stakeholder workshops. Do not pad it with empty tables. |
| Invoked by `$write-reqs` with a joint-authoring brief | Treat the brief's ORD-bound half as the extraction scope. Own the NFRs the PRD cites, using the brief's citations — still never read the PRD. Suppress the standalone next-steps block; `$write-reqs` owns what happens next. |
| KPP cannot be identified from source material | Ask at the Phase 1 gate. Do not write "KPPs not yet designated" on your own authority. |
| ORD already exists at the target path | Stop. "An ORD already exists at docs/ord/. Confirm overwrite or provide a new name." |
| Requirements conflict (e.g. 99.99% uptime but no DR budget) | Flag the conflict in Phase 1 Summary — do not silently resolve it |
| No BRD found | Note "No BRD found." Proceed — trace each requirement to its proximate operational source (source quote / stakeholder) instead of a BRD objective. |
| BRD requirement produces no register row, or a row has no `BRD#` and no `Source` | Flag as a coverage gap (orphaned BRD requirement) or orphan scope (sourceless row). Do not silently resolve. |
| Source states no MoSCoW, timing, or delivery agent | Write `TBD` in that cell and list it at the Phase 1 gate — these are stakeholder decisions, not drafting choices. Never default a priority to `Must`. |
