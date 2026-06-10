---
name: "pir"
description: "Post Implementation Review. Assesses whether delivered features actually achieved their stated goals. Runs at project level (all features for PROJ-NNN) or PI level (all features across a PI). Reads archived PRDs for stated goals, collects human outcome observations, surfaces gaps for human decision, and writes a private PIR document to the company directory. Use when user runs $pir [PROJ-NNN | PI-N]."
metadata:
  category: sprint
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Post Implementation Review (PIR)

Assess whether delivered work achieved its intended outcomes. This is not a process
retrospective (how did we work?) — it is an outcome review (did it work?). Run it
after features have been live long enough to observe real results — typically 2–4 weeks
post-deployment.

PIR documents are **private** — stored in the company directory, never committed to the
project's GitHub.

---

## Usage

```
$pir PROJ-001    ← project-level: all features delivered for this project
$pir PI-3        ← PI-level: all features delivered across PI-3
$pir             ← prompts for scope
```

---

## Storage

```
~/.codex/forge/companies/[active_company]$pir/
  PROJ-001/
    pir-YYYY-MM-DD.md
  PI-3/
    pir-YYYY-MM-DD.md
```

If no `active_company` is set, write to `docs/pir/` in the project repo and note:
"No company configured — PIR written to project docs. Set up $company-add to enable
private company-level storage."

---

## Phase 1 — Establish Scope

### Parse argument

| Argument | Scope |
|----------|-------|
| `PROJ-NNN` | All features archived for this project |
| `PI-N` | All features delivered in this PI across all projects |
| None | Ask: "Review a project (`$pir PROJ-NNN`) or a PI (`$pir PI-N`)?" |

### Confirm period

For **project-level**: check `~/.codex/forge/companies/[active_company]$pir/PROJ-NNN/` for a prior PIR.
- If one exists: "A PIR was run on [date]. Review features delivered since then, or full history? (since / all)"
- If none: cover all archived PRDs for this project.

For **PI-level**: the period is fixed — the full PI from start to final release.

---

## Phase 2 — Gather Source Material (AFK, silent)

### Project-level (PROJ-NNN)

1. Read `~/.codex/forge/companies/[active_company]/registry.md` — confirm project exists.
2. Find all archived PRDs for this project: `docs/prd/archived/[feature-name].md`
3. Find all Go/No Go records: `docs/releases/[release-id]-gono.md`
4. Read incident records since go-live: `~/.codex/forge/companies/[active_company]/incidents/`
   — filter to incidents linked to this project.
5. Read security assessment reports: `docs/security/assessment-*.md`
   — note any open findings remaining post-release.
6. Read performance review reports: `docs/performance/review-*.md`
   — note any open findings remaining post-release.
7. Read `docs/known-issues.md` — list open issues created since go-live.

### PI-level (PI-N)

1. Read `~/.codex/forge/pi/PI-N/plan.md` — extract PI objectives and all projects in scope.
2. For each project in the PI: repeat the project-level gather above.
3. Read all Go/No Go records for the PI's releases.
4. Read `~/.codex/forge/pi/PI-N/plan.md` PI End section for delivery summary if `$pi-end` was run.

---

## Phase 3 — Extract Stated Goals (AFK, silent)

For each archived PRD found, extract:

| Field | Source in PRD |
|-------|--------------|
| Feature name | Header |
| Problem being solved | `## Problem Statement` section |
| Intended outcome | `## Solution` section |
| User outcomes | "so that [outcome]" clauses from `## User Stories` |
| Release date | Go/No Go record date |

If a PRD has no User Stories with "so that" clauses and no clear Solution statement,
flag it: `⚠️ [Feature name]: PRD has no measurable outcomes — assessment will be qualitative only.`

For **PI-level**: also extract PI objectives from `~/.codex/forge/pi/PI-N/plan.md`.

---

## Phase 4 — HITL: Outcome Assessment

Present each feature in turn. For each one:

```
─────────────────────────────────────────────────────
Feature: [Feature Name]   Released: YYYY-MM-DD
─────────────────────────────────────────────────────

Problem it was meant to solve:
  [Problem Statement from PRD]

What was delivered:
  [Solution from PRD — one sentence]

Intended user outcomes:
  1. [so that outcome from user story]
  2. [so that outcome from user story]
  ...

Supporting data:
  Incidents since go-live: N (SEV1: N, SEV2: N, SEV3: N)
  Open known issues: N
  Open security findings: N
  Open performance findings: N

─────────────────────────────────────────────────────
For each intended outcome, how did it land?

  1. [outcome text]
     ✅ Met / ⚠️ Partially met / ❌ Not met / 🔲 Unable to assess
     Evidence: (describe what you observed)

  2. [outcome text]
     ✅ Met / ⚠️ Partially met / ❌ Not met / 🔲 Unable to assess
     Evidence:

Overall: Was the problem actually solved? (yes / partial / no / too soon to tell)
Any unexpected outcomes — positive or negative?
─────────────────────────────────────────────────────
```

Wait for human input before moving to the next feature.

For **PI-level**: after all project features, also assess PI objectives:

```
─────────────────────────────────────────────────────
PI-N Objectives Assessment
─────────────────────────────────────────────────────
Objective 1: [PI objective text]
  ✅ Met / ⚠️ Partially met / ❌ Not met / 🔲 Too soon
  Evidence:

Objective 2: ...
─────────────────────────────────────────────────────
```

---

## Phase 5 — Surface Gaps (HITL)

After all features are assessed, compile gaps: any outcome rated ⚠️ or ❌.

Present each gap and ask what to do with it:

```
─────────────────────────────────────────────────────
Gaps found: N outcome(s) partially met or not met

Gap 1: [Feature name] — [outcome text]
  Rated: ⚠️ Partially met
  Evidence: [human's observation]

  What would you like to do with this?
    A) Create a backlog item to address it
    B) Create a new idea to rethink the approach
    C) Log for future PIR follow-up (monitor, no action now)
    D) No action — accept the outcome

Gap 2: ...
─────────────────────────────────────────────────────
```

For each gap where the human chooses A or B:

**A — Backlog item:** Record the gap and decision. The human should create the ticket
separately via `$backlog-add` — do not create it automatically.
Prompt: "Run `$backlog-add` to add this: [suggested ticket title]"

**B — New idea:** Record the gap and decision. Prompt:
"Run `$idea` to capture this: [suggested one-line idea framing]"

**C or D:** Record as-is in the PIR document.

---

## Phase 6 — Write PIR Document

Write to `~/.codex/forge/companies/[active_company]$pir/[PROJ-NNN or PI-N]$pir-YYYY-MM-DD.md`.

Create the directory if it doesn't exist.

### Project-level template

```markdown
# Post Implementation Review — [Project Name]

**Scope:** PROJ-NNN | Project-level
**Period:** [start date] → [end date] (or "Since previous PIR: YYYY-MM-DD")
**Features reviewed:** N
**Prepared:** YYYY-MM-DD
**Prepared using:** $pir

---

## Features Reviewed

| Feature | Released | Overall Outcome |
|---------|----------|----------------|
| [name] | YYYY-MM-DD | ✅ Problem solved / ⚠️ Partial / ❌ Not solved / 🔲 Too soon |

---

## Feature Assessments

### [Feature Name]

**Released:** YYYY-MM-DD
**Problem:** [Problem Statement]
**Delivered:** [Solution summary]

#### Outcome Assessment

| Intended Outcome | Result | Evidence |
|-----------------|--------|----------|
| [user story "so that" clause] | ✅ / ⚠️ / ❌ / 🔲 | [human observation] |

**Overall:** [yes / partial / no / too soon to tell]
**Unexpected outcomes:** [positive or negative, or "None"]

#### Supporting Data at Review Date

| Signal | Value |
|--------|-------|
| Incidents since go-live | N (SEV1: N, SEV2: N, SEV3: N) |
| Open known issues | N |
| Open security findings | N |
| Open performance findings | N |

---

[Repeat for each feature]

---

## Gaps and Decisions

| Gap | Feature | Rating | Decision | Action |
|-----|---------|--------|----------|--------|
| [outcome text] | [feature] | ⚠️ | Backlog item | [suggested title] |
| [outcome text] | [feature] | ❌ | New idea | [suggested framing] |
| [outcome text] | [feature] | ⚠️ | Monitor | — |

---

## Cross-Feature Patterns

[Any patterns observed across multiple features — common failure modes,
recurring gap types, systemic issues. Note "None identified" if clean.]

---

## PRD Quality Notes

[Any PRDs that lacked measurable outcomes — flag for process improvement]

[e.g. "[Feature name]: No 'so that' outcome clauses — assessment was qualitative only.
Consider adding a Success Criteria section to future PRDs."]

---

## Lessons Learned

[3–5 observations specific to this project's delivery. What would you design
or approach differently? Drawn from the outcome assessments above.]

---

*Private document — not committed to project GitHub.*
*Prepared using Forge $pir skill.*
```

### PI-level template

Same structure, with additions:

- **PI Objectives Assessment** section after Features Reviewed, before Feature Assessments
- **Cross-Project Patterns** section (not just cross-feature)
- **PI Delivery Context** referencing the PI End summary if available

```markdown
## PI Objectives Assessment

| Objective | Result | Evidence |
|-----------|--------|----------|
| [PI objective] | ✅ / ⚠️ / ❌ / 🔲 | [observation] |

## Projects in Scope

| Project | Features Reviewed | Overall Health |
|---------|-----------------|---------------|
| PROJ-NNN [name] | N features | ✅ / ⚠️ / ❌ |
```

---

## Phase 7 — Confirm

```
✅ PIR written — [PROJ-NNN / PI-N]

   File: ~/.codex/forge/companies/[active_company]$pir/[scope]$pir-YYYY-MM-DD.md

   Features reviewed:   N
   Outcomes assessed:   N
   ✅ Met:              N
   ⚠️ Partially met:   N
   ❌ Not met:          N
   🔲 Too soon:         N

   Gaps identified: N
     → Backlog items to create:  N  (run $backlog-add for each)
     → Ideas to capture:         N  (run $idea for each)
     → Monitoring:               N
     → No action:                N

   [If PRD quality notes exist:]
   ⚠️ N PRD(s) lacked measurable outcomes — see PRD Quality Notes in the report.

   This PIR will be included in the next $fy-review automatically.
   Private document — not committed to project GitHub.
```

---

## Connection to $fy-review

`$fy-review` Phase 2 reads `~/.codex/forge/companies/[active_company]$pir/` as a data source.
PIR outcome assessments feed directly into the value observations phase, reducing
the amount of reconstruction needed at year-end.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No archived PRDs found for PROJ-NNN | "No archived features found for PROJ-NNN. Features must be approved via $approve before a PIR can be run." Stop. |
| No `active_company` set | Write to `docs/pir/` in project repo. Warn about privacy. |
| PRD has no outcomes to assess | Proceed with qualitative-only assessment. Flag in PRD Quality Notes. |
| PI-N plan not found | "PI-N plan not found at ~/.codex/forge/pi/PI-N/plan.md. Confirm the PI identifier." Stop. |
| Prior PIR exists for same scope | Warn: "A PIR already exists for [scope] on [date]. Overwrite or create an additional review? (overwrite / new)" |
| Human skips all outcome assessments | Still write the PIR with all fields marked 🔲. Note "Assessment deferred — human skipped input." |

---

## Rules

- Never assess outcomes without human input — outcome data is always HITL
- Never create backlog items or ideas automatically — surface them and let the human act
- Never commit PIR documents to the project's GitHub
- Gaps are surfaced, not judged — present neutrally, let the human decide the response
- Missing success criteria in a PRD is always noted — it is process feedback, not a blocker
- A PIR is not a blame document — frame everything as learning and improvement
