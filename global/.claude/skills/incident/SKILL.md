---
name: incident
category: pi-release
description: Manage the full lifecycle of a production incident — declare, investigate, resolve, and write a post-mortem. Coordinates /diagnose and /rollback as sub-steps. Records at ~/.claude/companies/[active_company]/incidents/INC-NNN/. Drafts stakeholder communications at each stage. Use when user runs /incident, a production issue is detected, or /rollback is triggered without a prior incident.
---

# Incident

Structured incident management from declaration through post-mortem. Coordinates with
`/diagnose` and `/rollback` rather than replacing them — providing the continuity and
record that those standalone skills lack.

---

## Usage

```
/incident declare              ← open a new incident
/incident declare SEV1         ← open with severity pre-set
/incident update INC-001       ← add a timeline event to an open incident
/incident resolve INC-001      ← mark as resolved, trigger post-mortem
/incident postmortem INC-001   ← write post-mortem for a resolved incident
/incident list                 ← show open and recent incidents
```

---

## Severity Model

Read `incident_severity_model` from `~/.claude/companies/[active_company]/config.md`.
If not set, use the default SEV model and offer to save it:

```
ℹ️ No incident_severity_model configured. Using default SEV1–SEV3.
   Add `incident_severity_model: SEV` to config.md to persist this choice,
   or `incident_severity_model: P` for P1–P4.
```

### Default SEV model

| Severity | Definition | Response |
|----------|-----------|---------|
| SEV1 | Complete outage or data loss — all users affected | Immediate: consider rollback before investigation |
| SEV2 | Significant degradation — subset of users or features affected | Investigate before rollback decision |
| SEV3 | Minor issue — limited impact, workaround exists | Resolve in normal sprint flow |

### P model (if configured)

| Severity | Definition |
|----------|-----------|
| P1 | Critical — production down |
| P2 | High — major feature broken |
| P3 | Medium — degraded experience |
| P4 | Low — minor issue |

---

## Storage

All incident records live outside the project repo:
`~/.claude/companies/[active_company]/incidents/INC-NNN/`

```
INC-001/
  incident.md      ← main record: declaration, timeline, resolution
  postmortem.md    ← written after resolution
  comms/
    declared.md    ← stakeholder notification draft (declaration)
    update-N.md    ← status update drafts
    resolved.md    ← resolution notification draft
```

If no company is configured, fall back to `docs/incidents/INC-NNN/` in the project repo
with a warning that sensitive incident data will be in version control.

---

## `/incident declare`

### 1 — Assign ID

Read existing incidents directory to find the next INC-NNN. Start at INC-001.

### 2 — Gather details

Ask (skip any provided as arguments):
- Severity: [SEV1 / SEV2 / SEV3 or P1–P4 per configured model]
- What is affected? (brief description)
- When did it start? (or "now" for current time)
- Which project(s) or system(s)?

### 3 — Create incident record

Write `~/.claude/companies/[active_company]/incidents/INC-NNN/incident.md`:

```markdown
# INC-NNN — [Description]

**Severity:** [SEV1 / P1 etc.]
**Declared:** YYYY-MM-DD HH:MM
**Affected:** [systems / features / users]
**Status:** 🔴 Open

---

## Timeline

| Time | Event |
|------|-------|
| HH:MM | Incident declared |

---

## Investigation Notes

[Populated as investigation progresses]

---

## Resolution

_Pending_
```

### 4 — Draft stakeholder notification

Write `comms/declared.md`:

```markdown
**[INCIDENT DECLARED — SEVERITY N]**

We are currently investigating an issue affecting [affected systems/features].

Impact: [who is affected and how]
Status: Investigating
Started: [time]

Next update: [time + 30 minutes for SEV1, + 60 minutes for SEV2/SEV3]

[Review and send via your preferred channel before distributing]
```

### 5 — Announce

```
🔴 INC-NNN declared — [Severity] — [Description]

   Record: ~/.claude/companies/[active_company]/incidents/INC-NNN/incident.md
   Stakeholder draft: comms/declared.md — review and send before distributing

Suggested next steps:
  SEV1: Run /rollback [version] if cause is a recent deployment
  SEV2/SEV3: Run /diagnose to investigate before deciding on rollback
  Any: Run /incident update INC-NNN to log timeline events as they occur
```

**RAID log** — if `docs/raid/` exists, automatically create a linked RAID issue entry:
- Run `/raid add issue` pre-populated with:
  - Title: `[INC-NNN] [description]`
  - Source: `INCIDENT-NNN`
  - Status: `Open`
- Confirm to user: "Linked to RAID log as I-NNN."

---

## `/incident update INC-NNN`

Append a timestamped event to the timeline and optionally draft a status update.

Ask:
> "What happened? (e.g. 'identified root cause as X', 'rollback initiated', 'monitoring response')"

Append to timeline table in `incident.md`:
```markdown
| HH:MM | [event description] |
```

Ask:
> "Draft a stakeholder status update? (yes/no)"

If yes, write `comms/update-N.md` with the same template as the declaration comm,
updating status to "Investigating / Identified / Monitoring".

---

## `/incident resolve INC-NNN`

### 1 — Confirm resolution

Ask:
> "Confirm the incident is fully resolved and no further customer impact is expected? (yes/no)"

### 2 — Update record

Set status to `✅ Resolved` in `incident.md`. Add final timeline entry:
```markdown
| HH:MM | Incident resolved |
```

Record duration: time from declared to resolved.

### 3 — Draft resolution notification

Write `comms/resolved.md`:

```markdown
**[INCIDENT RESOLVED — INC-NNN]**

The incident affecting [systems/features] has been resolved.

Duration: [N hours N minutes]
Root cause: [brief — fill in after post-mortem]
Impact: [who was affected and for how long]

A post-mortem will follow within [24/48] hours.

[Review and send via your preferred channel before distributing]
```

### 4 — Prompt post-mortem

```
✅ INC-NNN resolved. Duration: [N hours N minutes]

   Stakeholder draft: comms/resolved.md — review and send before distributing

   ⚠️ Post-mortem required. Run /incident postmortem INC-NNN to complete.
   Recommended within 24–48 hours while the incident is fresh.
```

---

## `/incident postmortem INC-NNN`

### 1 — Read incident record

Read `incident.md` for the full timeline and investigation notes.

### 2 — Gather post-mortem inputs (HITL)

Ask for each section in sequence:

1. **Root cause** — the specific technical failure that caused the incident
2. **Contributing factors** — what made it worse or harder to detect
3. **What went well** — things the team did right during the response
4. **Action items** — specific changes to prevent recurrence (each gets an owner and deadline)

### 3 — Write post-mortem

Write `postmortem.md`:

```markdown
# Post-Mortem — INC-NNN

**Incident:** INC-NNN — [description]
**Severity:** [severity]
**Duration:** [start] → [end] ([N hours N minutes])
**Written:** YYYY-MM-DD

---

## Timeline

[Full timeline table from incident.md]

---

## Root Cause

[Specific technical failure — what broke and why]

---

## Contributing Factors

- [What made the incident worse]
- [What slowed detection or response]

---

## What Went Well

- [Positive observations about the response]

---

## Action Items

| Item | Owner | Due | Ticket |
|------|-------|-----|--------|
| [Specific change to prevent recurrence] | [name] | [date] | |

---

*Post-mortem completed YYYY-MM-DD*
```

### 4 — Promote action items to kanban (optional)

```
INC-NNN post-mortem has [N] action items.

Create kanban tickets for these items? (yes / no / select)
[List action items]
```

If yes, create tickets in `docs/kanban.md`:
```markdown
- [ ] INC-NNN action: [item] — [owner] | High | incident
```

### 5 — Confirm

```
✅ Post-mortem written — INC-NNN

   Record: ~/.claude/companies/[active_company]/incidents/INC-NNN/postmortem.md
   Kanban tickets: N created

   INC-NNN is now fully closed.
```

---

## `/incident list`

Show open incidents and the 5 most recently closed:

```
## Open Incidents

| ID | Severity | Description | Declared | Duration |
|----|----------|-------------|----------|---------|
| INC-002 | SEV2 | Payment service degraded | 2026-05-24 14:30 | 2h ongoing |

## Recently Closed

| ID | Severity | Description | Duration | Post-mortem |
|----|----------|-------------|---------|------------|
| INC-001 | SEV1 | Full outage | 47 min | ✅ Written |
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No company configured | Fall back to `docs/incidents/` with a warning about version control |
| Incident ID not found | List known IDs and suggest /incident list |
| Post-mortem already written | Warn and ask to confirm overwrite |
| No action items in post-mortem | Note — valid for simple incidents |

---

## Rules

- Never auto-send stakeholder communications — always draft for human review
- Post-mortem is required for SEV1 and SEV2 — surface a reminder if not written within 48 hours
- Timeline entries must have timestamps — ask if not provided
- Action items in the post-mortem must be specific and ownable — not "improve monitoring" but "add alert for payment service latency > 2s"
- This skill coordinates /diagnose and /rollback — it does not replace them
