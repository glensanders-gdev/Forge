---
name: "write-ac"
description: "Transform a PRD and ORD into Jira acceptance criteria — promote KPPs and headline outcomes to Capability-level AC, flow story detail to child Epics/Stories, carry PRD-NNN/ORD-NNN traceability into each criterion, and optionally push to the linked Jira Capability behind a confirmation gate. Use when the user runs $write-ac, has a PRD and/or ORD ready to turn into Jira acceptance criteria, or is promoting a project to a Jira Capability."
metadata:
  category: pipeline
  version: 1.3.0
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write AC

Turn an authored PRD and ORD into testable acceptance criteria positioned at the right altitude for a Jira Capability and its child Epics/Stories. This skill **consumes** requirements — it never authors them. Runs in two phases with a confirmation gate; any external Jira write is gated separately.

See [REFERENCE.md](REFERENCE.md) for the altitude rules, the PRD-story and ORD-requirement translation patterns, the AC document template, and the Jira field mapping.

**Authoring standards** — `~/.codex/forge/rules/requirements/language.md` governs the wording of every
criterion written here. Translation carries a requirement's meaning across, not its defects: an AC
derived from a hedged source requirement is rewritten to the declarative end-state form, never
copied through. Never restate these rules here.

---

## Phase 1 — AFK Select [AFK]

Runs unattended. Reads the source requirements and sorts them by altitude — no authoring, no questions.

1. Read the PRD at `docs/prd/active/*.md` if present — stories (`PRD-NNN`) and their acceptance criteria.
2. Read the ORD at `docs/ord/*.md` if present — the requirement register in §§3–8. Each row carries `ORD#`, a declarative `Requirement Description` holding its own value, a `Verification` method, `MoSCoW`, and any **[KPP]** tag. Note which rows already carry a `Capability` / `Epic` — those are prior mappings, not gaps.
3. Read the PRD↔ORD cross-links if present — the PRD's traceability matrix and the ORD's Appendix B. Reuse them rather than re-deriving. A standalone ORD has no Appendix B; that is expected, not a gap.
4. Resolve the target Jira Capability — read `external_ids.jira` (type `capability`) from the linked idea/project file. If none, note it; the run still produces the AC document.
5. Classify every requirement by altitude (see REFERENCE.md § Altitude). Apply the **MoSCoW gate first** — `Won't` produces no AC at all, `Could` never reaches Capability level — then the altitude tests:
   - **Capability AC** — every **[KPP]** from any register section, and each headline functional outcome.
   - **Child Epic/Story AC** — detailed story-level criteria, edge and error cases, and every delivery enabler (staffing, training, patch windows, SLA governance, infrastructure) unless tagged **[KPP]**.
6. Present the Selection Summary and pause.

### Selection Summary Format

```
## AC Selection — [Capability name / Feature]

Target Jira Capability: [CAP-NN or "none linked — run $link-jira"]
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
   - **Functional (PRD)** → the PRD still stores criteria as Given/When/Then pending that conversion, so **this skill is the boundary where they become declarative**. Extract the testable condition from the `Then` clause, rewrite it to the end-state form, and carry the `PRD-NNN` ID. Do not copy the Given/When scaffolding into the AC.
   - **Operational (ORD)** → the register row's `Requirement Description` + its `Verification`, carrying the `ORD-NNN` ID and keeping the verification method verbatim.
3. Assign each AC a stable `AC-NNN` ID with a Source column tracing to its `PRD-NNN`/`ORD-NNN`.
4. Write the AC document to `docs/ac/[capability-name]-AC.md` using the template in REFERENCE.md.
5. **Jira push is optional and gated.** If a Capability is linked and the human wants it pushed:
   - Show exactly what will be written to which Capability key (Capability AC field + child issue AC).
   - Require the human to type `PUSH` to confirm. On confirm, write via the `jira` MCP (`$jira`). Never push without it.
   - List child issues that do not yet exist for the human to create — never auto-create Jira issues.
6. **Write back the Capability and Epic mapping into the ORD register.** The ORD's `Capability` and `Epic` columns exist for this and stay `—` until this step runs.

   **Only write an ID that exists in Jira.** This skill never creates issues, so an Epic listed in step 5 as "not yet created" has no key — writing one back would put a forward reference to nothing into an approved document. Write `TBD` for those. If no Capability is linked at all, skip this step entirely.

   The ORD is already an approved document, so present the change set and require a typed `CONFIRM`:

   ```
   ## ORD write-back — [ORD path]
   | ORD# | Capability | Epic | Exists in Jira? |
   |------|-----------|------|-----------------|
   | ORD-004 | CAP-12 | EPIC-31 | yes — both |
   | ORD-009 | CAP-12 | TBD | Epic not yet created |

   N rows updated. Columns touched: Capability, Epic only.
   Type CONFIRM to apply.
   ```

   Never touch any other column. Never write back to a requirement that has no AC.
7. Suggest next steps: `$link-jira` if no Capability is linked yet. Note that `$qa-plan` generates its checklist from the PRD's user stories and definition of done — it does **not** read `docs/ac/`, so the AC document is the Jira-facing artefact rather than the QA input.

---

## Rules

- Never author or invent requirements — every AC traces to an existing `PRD-NNN` or `ORD-NNN`. A need with no source is out of scope for this skill; flag it.
- Never write a non-functional AC without its verification method — an ORD requirement with no way to prove it is not an acceptance criterion.
- Never push to Jira without a typed `PUSH` confirmation showing the exact target Capability and payload.
- Never put detailed story-level criteria on the Capability — Capability AC are KPPs and headline outcomes only; detail flows to child issues.
- Never carry a requirement's *narrative* into the AC — no "As a… I want…", no full register row, no priority, timing, delivery agent or comments. Carry the testable condition and its verification method verbatim; that is what makes the criterion readable standalone in Jira. See REFERENCE.md § Verbatim vs reference.
- Never edit a carried value in the AC document — the source PRD/ORD is authoritative. Change it there and re-run.
- Never write `could`, `should`, `would`, `may`, `enables`, `is able to`, or `can [verb]` into a criterion, and never refer to "the system" — a criterion derived from a hedged source requirement is rewritten to the declarative end-state form, never copied through. See `rules/requirements/language.md`.
- Never translate a `Won't` requirement into an AC, and never promote a `Could` to Capability level.
- Never promote a delivery enabler to Capability AC on priority alone — only a **[KPP]** tag promotes one.
- Never reuse a retired `AC-NNN` ID.
- Never ask questions during Phase 1 — select, then present.
- Never resolve BRD↔PRD↔ORD traceability here — that belongs to `$write-prd`, `$write-ord`, `$write-reqs`. The `Capability`/`Epic` write-back is the one exception, and it touches those two columns only.
- Never write back to the ORD without a typed `CONFIRM` — the ORD is an approved document, and approval of the ORD did not cover this edit.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Neither PRD nor ORD found | Stop. "No PRD or ORD found — author requirements with $write-prd, $write-ord, or $write-reqs first." |
| Only a PRD (no ORD) | Proceed — Capability AC are headline functional outcomes only; note no operational/KPP AC exist. |
| Only an ORD (no PRD) | Proceed — Capability AC are KPP thresholds only; note no functional AC exist. |
| No [KPP] tagged in the ORD | Proceed — promote headline outcomes; flag "no KPP designated — confirm the Capability has no program-failure threshold." |
| An ORD requirement is still `[TBD]` | Do not turn it into an AC. List it as blocked pending the ORD; do not invent a threshold. |
| No Jira Capability linked | Produce the AC document only. Suggest `$link-jira PROJ-NNN CAP-NN --type capability`; never push. |
| AC document already exists at target path | Stop. "An AC document already exists at docs/ac/. Confirm overwrite or provide a new name." |
| jira MCP not configured at push time | Write the document, skip the push, direct the user to `$jira setup`. |
| Every ORD requirement is `Won't` | Stop. "All operational requirements are marked Won't for this release — no AC to author." |
| User declines the write-back `CONFIRM` | The AC document stands; the ORD is untouched. Report which `ORD#` rows remain unmapped. Never apply a partial set without a fresh `CONFIRM`. |
| ORD not found or not writable at write-back time | Write the AC document, skip the write-back, and list the `ORD# → Capability/Epic` mapping for the human to apply manually. |
| An ORD row already carries a *different* Capability or Epic | Do not overwrite. List the conflict — existing value vs proposed — and ask which stands. A changed Capability usually means the ORD was re-scoped. |
| No Jira Capability linked at write-back time | Skip the write-back entirely — there is no key to write. The AC document is still produced. |
| An Epic does not yet exist in Jira | Write `TBD` in the Epic cell. Never invent or predict an issue key. |
