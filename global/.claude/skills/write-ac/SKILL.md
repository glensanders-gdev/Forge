---
name: write-ac
category: pipeline
version: 1.0.0
description: Transform a PRD and ORD into Jira acceptance criteria — promote KPPs and headline outcomes to Capability-level AC, flow story detail to child Epics/Stories, carry PRD-NNN/ORD-NNN traceability into each criterion, and optionally push to the linked Jira Capability behind a confirmation gate. Use when the user runs /write-ac, has a PRD and/or ORD ready to turn into Jira acceptance criteria, or is promoting a project to a Jira Capability.
---

# Write AC

Turn an authored PRD and ORD into testable acceptance criteria positioned at the right altitude for a Jira Capability and its child Epics/Stories. This skill **consumes** requirements — it never authors them. Runs in two phases with a confirmation gate; any external Jira write is gated separately.

See [REFERENCE.md](REFERENCE.md) for the altitude rules, the PRD-story and ORD-requirement translation patterns, the AC document template, and the Jira field mapping.

---

## Phase 1 — AFK Select [AFK]

Runs unattended. Reads the source requirements and sorts them by altitude — no authoring, no questions.

1. Read the PRD at `docs/prd/active/*.md` if present — stories (`PRD-NNN`) and their acceptance criteria.
2. Read the ORD at `docs/ord/*.md` if present — requirements (`ORD-NNN`), their threshold + measurement method, and **[KPP]** tags.
3. Read the joined traceability matrix (PRD Appendix B / ORD Appendix) if present — reuse existing PRD↔ORD cross-links rather than re-deriving them.
4. Resolve the target Jira Capability — read `external_ids.jira` (type `capability`) from the linked idea/project file. If none, note it; the run still produces the AC document.
5. Classify every requirement by altitude (see REFERENCE.md § Altitude):
   - **Capability AC** — every **[KPP]** and each headline functional outcome.
   - **Child Epic/Story AC** — detailed story-level criteria, edge and error cases.
6. Present the Selection Summary and pause.

### Selection Summary Format

```
## AC Selection — [Capability name / Feature]

Target Jira Capability: [CAP-NN or "none linked — run /link-jira"]
Sources read: [PRD path / "none"] · [ORD path / "none"]

### Promote to Capability AC
| Source ID | Type | Why it promotes |
|-----------|---------|-----------------|
| ORD-004 | KPP | program-failure threshold |
| PRD-002 | Outcome | headline user outcome |

### Flow to child Epics/Stories
| Source ID | Maps to | Note |
|-----------|---------|------|
| PRD-005 | Story | edge/error detail |

Unclassifiable / missing source: [list or "none"]

---
Confirm the split to proceed to Phase 2, or re-assign altitude before I write.
```

---

## Phase 2 — HITL Write & Push [HITL]

Runs after the human confirms the split.

1. Incorporate altitude re-assignments from the confirmation.
2. Translate each selected requirement into a testable AC (see REFERENCE.md § Translation):
   - **Functional (PRD)** → Given/When/Then, carrying the `PRD-NNN` ID.
   - **Operational (ORD)** → `[threshold] + [measurement method]`, carrying the `ORD-NNN` ID and keeping the verification method verbatim.
3. Assign each AC a stable `AC-NNN` ID with a Source column tracing to its `PRD-NNN`/`ORD-NNN`.
4. Write the AC document to `docs/ac/[capability-name]-AC.md` using the template in REFERENCE.md.
5. **Jira push is optional and gated.** If a Capability is linked and the human wants it pushed:
   - Show exactly what will be written to which Capability key (Capability AC field + child issue AC).
   - Require the human to type `PUSH` to confirm. On confirm, write via the `jira` MCP (`/jira`). Never push without it.
   - List child issues that do not yet exist for the human to create — never auto-create Jira issues.
6. Suggest next steps: `/link-jira` if no Capability is linked yet; `/qa-plan` to turn these AC into a QA checklist.

---

## Rules

- Never author or invent requirements — every AC traces to an existing `PRD-NNN` or `ORD-NNN`. A need with no source is out of scope for this skill; flag it.
- Never write a non-functional AC without its measurement method — an ORD threshold with no way to verify it is not an acceptance criterion.
- Never push to Jira without a typed `PUSH` confirmation showing the exact target Capability and payload.
- Never put detailed story-level criteria on the Capability — Capability AC are KPPs and headline outcomes only; detail flows to child issues.
- Never restate a requirement's full text in the AC — reference its source ID and state the testable condition (reference, don't duplicate).
- Never reuse a retired `AC-NNN` ID.
- Never ask questions during Phase 1 — select, then present.
- Never resolve BRD↔PRD↔ORD traceability here — that belongs to `/write-prd`, `/write-ord`, `/write-reqs`.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Neither PRD nor ORD found | Stop. "No PRD or ORD found — author requirements with /write-prd, /write-ord, or /write-reqs first." |
| Only a PRD (no ORD) | Proceed — Capability AC are headline functional outcomes only; note no operational/KPP AC exist. |
| Only an ORD (no PRD) | Proceed — Capability AC are KPP thresholds only; note no functional AC exist. |
| No [KPP] tagged in the ORD | Proceed — promote headline outcomes; flag "no KPP designated — confirm the Capability has no program-failure threshold." |
| An ORD requirement is still `[TBD]` | Do not turn it into an AC. List it as blocked pending the ORD; do not invent a threshold. |
| No Jira Capability linked | Produce the AC document only. Suggest `/link-jira PROJ-NNN CAP-NN --type capability`; never push. |
| AC document already exists at target path | Stop. "An AC document already exists at docs/ac/. Confirm overwrite or provide a new name." |
| jira MCP not configured at push time | Write the document, skip the push, direct the user to `/jira setup`. |
