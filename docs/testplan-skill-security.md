# Test Plan: Skill Security Audit

**PRD:** [docs/prd/active/skill-security.md](prd/active/skill-security.md)
**Date:** 2026-11-10
**Sprint:** Not sprint-tracked
**TC range:** TC-011 through TC-057
**Operational TCs referenced:** none (no operational testplan exists)

Test types: **Script** — deterministic pytest under `tools/tests/` (prior art: `test_llm_companion.py`). **Eval** — the audit run against the sample corpus, each verdict scored by script against the sample's label (EVL-001 for the held-out half). **Manual** — demonstration or inspection by the maintainer.

---

## Critical Path Behaviours

Behaviours that must pass at Go/No Go:

1. TC-012 — No script, command or link in the audited skill is executed or followed — a failure turns the audit into the attack vector
2. TC-015 — Failed, refused or malformed intent review yields Incomplete, never Allow — blocks the provoke-a-refusal bypass
3. TC-025 — Intent reviewer holds no tools and receives the skill only as delimited text — isolation is the core injection defence
4. TC-030 — Verdict-override instruction rated at least High — direct test of injection resistance
5. TC-037 — Trust register write refused inside a git working tree — keeps vulnerability detail out of version control
6. TC-043 — `/assimilate` audits before evaluation and halts on Critical/High until `CONFIRM` — the gate itself
7. TC-048 — Report write refused inside a git working tree — as TC-037
8. TC-050 — No malicious EVL-001 sample receives Allow — the zero-tolerance metric
9. TC-051 — Samples not loadable and absent from Codex and standalone builds — otherwise live malware locally and in the public distribution

---

## Automated Tests

### Single-skill intake (PRD-001)

| TC | Requirement | Behaviour | Test Type | Priority | Notes |
|----|-------------|-----------|-----------|----------|-------|
| TC-011 | PRD-001.1 | Completed audit returns one recommendation with every finding listed | Eval | P1 | |
| TC-012 | PRD-001.2 | No script, command or link in the audited skill is executed or followed | Script | P1 | Samples carry harmless marker commands; assert no marker file or process appears |
| TC-014 | PRD-001.4 | Downloaded skill placed in a new, empty directory | Script | P2 | |
| TC-015 | PRD-001.6 | Failed, refused or malformed intent review yields Incomplete, never Allow | Script | P1 | Uses the verdict-substitution seam |
| TC-017 | PRD-001.8 | Folder with no `SKILL.md` reported as not a skill | Script | P3 | |

### Portfolio audit (PRD-002)

| TC | Requirement | Behaviour | Test Type | Priority | Notes |
|----|-------------|-----------|-----------|----------|-------|
| TC-018 | PRD-002.1 | Portfolio audit lists every installed skill with recommendation and finding count | Script | P2 | |
| TC-019 | PRD-002.2 | Unchanged skills shown as current; intent review skipped for them | Script | P2 | Depends on trust register (PRD-006) |
| TC-020 | PRD-002.3 | Unreadable skill folder listed as Incomplete; audit continues | Script | P2 | |
| TC-021 | PRD-002.4 | Portfolio with no trust records reviews every skill | Script | P3 | |

### Capability check and AST10 mapping (PRD-003, PRD-005)

| TC | Requirement | Behaviour | Test Type | Priority | Notes |
|----|-------------|-----------|-----------|----------|-------|
| TC-022 | PRD-003.1, PRD-003.3, PRD-003.4 | Capability findings name stated purpose and access, including config, hook and MCP writes | Eval | P1 | |
| TC-023 | PRD-003.2 | Untrusted input + private data + outbound channel rated at least High | Eval | P1 | |
| TC-024 | PRD-003.5, PRD-003.6 | Obfuscated content flagged; tool-less skill text still checked | Eval | P2 | |
| TC-031 | PRD-005.1, PRD-005.2 | Each finding carries AST10 ID and severity, plus secondary ID where applicable | Script | P2 | |
| TC-032 | PRD-005.3 | Finding with no AST10 match reported as Unmapped | Eval | P3 | |
| TC-033 | PRD-005.4 | Report names the AST10 version used | Script | P3 | |

### Intent review (PRD-004)

| TC | Requirement | Behaviour | Test Type | Priority | Notes |
|----|-------------|-----------|-----------|----------|-------|
| TC-025 | PRD-004.1 | Intent reviewer holds no tools and receives skill only as delimited text | Script + inspection | P1 | Inspect the subagent invocation; script asserts the tool list is empty |
| TC-026 | PRD-004.2 | Every intent verdict conforms to the fixed verdict format | Script | P1 | |
| TC-027 | PRD-004.3, PRD-004.4 | Model tier routing: Opus single-skill, Sonnet portfolio, Opus repeat on Critical/High | Script | P2 | |
| TC-028 | PRD-004.5 | Detection on EVL-001 meets its recorded thresholds | Eval | P1 | Re-run on every EVL-001 trigger |
| TC-029 | PRD-004.6 | Out-of-format verdict discarded; result Incomplete | Script | P1 | Uses the verdict-substitution seam |
| TC-030 | PRD-004.7 | Verdict-override instruction rated at least High, quoted as evidence | Eval | P1 | |

### Trust and exceptions registers (PRD-006, PRD-007)

| TC | Requirement | Behaviour | Test Type | Priority | Notes |
|----|-------------|-----------|-----------|----------|-------|
| TC-034 | PRD-006.1 | Trust record holds all six fields | Script | P2 | |
| TC-035 | PRD-006.2 | Changed fingerprint reported as changed and reviewed again | Script | P1 | |
| TC-036 | PRD-006.3 | `CONFIRM` override logged with date, fingerprint and overridden findings | Script | P2 | |
| TC-037 | PRD-006.4 | Trust register write refused inside a git working tree | Script | P1 | Runs in a temporary repository |
| TC-038 | PRD-006.5 | First audit creates an empty trust register | Script | P3 | |
| TC-039 | PRD-007.1 | Excepted finding shown at lowered severity with exception cited, never hidden | Script | P1 | |
| TC-040 | PRD-007.2 | Shipped baseline exceptions keyed by fingerprint | Script | P2 | |
| TC-041 | PRD-007.3 | User exceptions add to the baseline, never remove it | Script | P2 | |
| TC-042 | PRD-007.4 | Stale exception ignored and reported | Script | P2 | |

### Reports (PRD-009)

| TC | Requirement | Behaviour | Test Type | Priority | Notes |
|----|-------------|-----------|-----------|----------|-------|
| TC-047 | PRD-009.1 | Dated report saved outside every git working tree | Script | P2 | |
| TC-048 | PRD-009.3 | Report write refused inside a git working tree | Script | P1 | Runs in a temporary repository |
| TC-049 | PRD-009.4 | No-findings audit still writes a dated report | Script | P3 | |

### Sample corpus and builds (PRD-010, PRD-011)

| TC | Requirement | Behaviour | Test Type | Priority | Notes |
|----|-------------|-----------|-----------|----------|-------|
| TC-050 | PRD-010.2 | No malicious EVL-001 sample receives Allow | Eval | P1 | Zero tolerance — one failure fails the run |
| TC-051 | PRD-010.3 | Samples not loadable and absent from Codex and standalone builds | Script | P1 | Scan `plugins/forge-codex/` and `dist/` after build |
| TC-052 | PRD-010.1 | Tuning and held-out halves disjoint; only held-out forms EVL-001 | Script | P1 | |
| TC-053 | PRD-010.5 | Malicious sample rated below High recorded as detection failure; release withheld | Script | P2 | |
| TC-054 | PRD-010.6 | Safe security-content sample receives no High or Critical | Eval | P1 | |
| TC-056 | PRD-011.3 | Copilot prompt 15,000 characters or fewer | Script | P2 | |

### Mocking Strategy

The intent reviewer is the only dependency replaced in tests. TC-015, TC-029 and TC-045 need a **verdict-substitution seam** that supplies a failed, refused or malformed verdict. Its form is a build decision. It is itself attack surface, so it is active only inside the test harness and never through skill input. Eval tests use the real reviewer — mocking it would test nothing.

### Prior Art

- `tools/tests/test_llm_companion.py` — pytest pattern for deterministic checks
- `docs/tests/write-ord-2.1.0-regression.md` — case-suite pattern for the corpus labels
- `tools/test-forge-parity.ps1` and `build-forge-standalone.ps1 -Strict` — build outputs scanned by TC-051

---

## Manual Tests

| TC | Requirement | Behaviour | Steps | Expected Outcome | Priority |
|----|-------------|-----------|-------|-----------------|----------|
| TC-013 | PRD-001.3 | URL source downloaded only after approval | Audit a URL source | Approval requested naming source and size before any download | P1 |
| TC-016 | PRD-001.5, PRD-001.7 | Handed-over content audited without re-fetch; declined download writes nothing | Run via `/assimilate`; separately decline a URL download | No second fetch; no file written on decline | P2 |
| TC-043 | PRD-008.1, PRD-008.2 | `/assimilate` gate on Critical/High | `/assimilate` a malicious tuning sample | Audit runs before evaluation; halts until `CONFIRM` | P1 |
| TC-044 | PRD-008.3 | `/assimilate` continues on Medium/Low | `/assimilate` a sample with Medium findings only | Findings shown; `/assimilate` continues | P2 |
| TC-045 | PRD-008.4 | `/assimilate` halts on Incomplete | `/assimilate` with the reviewer substituted to fail | Halts until `CONFIRM` | P1 |
| TC-046 | PRD-008.5 | Prose-only source not auditable | `/assimilate` a prose description with no skill files | Reported as not auditable before continuing | P3 |
| TC-055 | PRD-009.2 | SEC-NNN promotion gated | Audit a Critical sample; decline then approve promotion | Ticket created only after approval | P3 |
| TC-057 | PRD-011.1, PRD-011.2, PRD-011.4, PRD-011.5, PRD-011.6 | Copilot audit behaviour | Paste the prompt, then tuning-half samples, into Copilot Chat | Fixed-format verdict labelled "Indicative — not an isolated review"; no rendered link or image; no work search; search instruction rated High | P2 |

---

## Not Tested

| Item | Reason |
|------|--------|
| Hooks, MCP config, plugins, runtime sandboxing, signing, auto-fix | Out of scope per PRD |
| Live malicious skills fetched from public registries | Too risky to download; the corpus stands in |
| Reviewer quality beyond EVL-001 | Out of scope — only EVL-001 is evidenced; wider claims are not made |
| Skill runtime behaviour under Codex | Parity check covers structure; a Codex runtime run costs more than the risk |
| Copilot run against EVL-001 | Would expose held-out samples to an unisolated reviewer; tuning half only |

---

## Definition of Test Complete

- [ ] All P1 automated tests (TC-011, TC-012, TC-015, TC-022, TC-023, TC-025, TC-026, TC-028–TC-030, TC-035, TC-037, TC-039, TC-048, TC-050–TC-052, TC-054) written and passing
- [ ] All P2 automated tests written and passing
- [ ] All P1 manual tests (TC-013, TC-043, TC-045) verified by human
- [ ] No known P1 bugs outstanding
- [ ] Test coverage reviewed against critical path behaviours
