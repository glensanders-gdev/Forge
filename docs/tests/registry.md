# Test Case Registry

Tracks all TC-NNN IDs issued across features. Assigned by `/testplan`, updated by `/qa-report`.

| TC | Behaviour | Feature | Testplan | Requirement | Type | Status |
|----|-----------|---------|----------|-------------|------|--------|
| TC-001 | Windows junction install — ReparsePoint confirmed | forge-junction-sync | testplan-forge-junction-sync.md | — | Manual | Waived |
| TC-002 | Skill edit in `~/.claude/` immediately visible in `git status` | forge-junction-sync | testplan-forge-junction-sync.md | — | Manual | Waived |
| TC-003 | Migration preserves user data dirs | forge-junction-sync | testplan-forge-junction-sync.md | — | Manual | Waived |
| TC-004 | Migration flow end-to-end — legacy copy → junction | forge-junction-sync | testplan-forge-junction-sync.md | — | Manual | Waived |
| TC-005 | `/update-forge` uses `git pull`, does not invoke `update.sh` | forge-junction-sync | testplan-forge-junction-sync.md | — | Manual | Waived |
| TC-006 | iOS guidance branch shown when `ln`/`mklink` unavailable | forge-junction-sync | testplan-forge-junction-sync.md | — | Manual | Waived |
| TC-007 | Idempotency — re-run `install.sh` reports `↩ Already linked` | forge-junction-sync | testplan-forge-junction-sync.md | — | Manual | Waived |
| TC-008 | Wrong remote guard — stops with warning, no filesystem changes | forge-junction-sync | testplan-forge-junction-sync.md | — | Manual | Waived |
| TC-009 | `install.sh` failure surfaced — `✗ Failed` message visible | forge-junction-sync | testplan-forge-junction-sync.md | — | Manual | Waived |
| TC-010 | `update.sh` deprecation notice visible at top of file | forge-junction-sync | testplan-forge-junction-sync.md | — | Manual | Waived |
| TC-011 | Completed audit returns one recommendation with every finding listed | skill-security | testplan-skill-security.md | PRD-001.1 | Automated | Defined |
| TC-012 | No script, command or link in the audited skill is executed or followed — marker commands leave no trace | skill-security | testplan-skill-security.md | PRD-001.2 | Automated | Defined |
| TC-013 | URL source downloaded only after approval naming source and size | skill-security | testplan-skill-security.md | PRD-001.3 | Manual | Defined |
| TC-014 | Downloaded skill placed in a new, empty directory | skill-security | testplan-skill-security.md | PRD-001.4 | Automated | Defined |
| TC-015 | Failed, refused or malformed intent review yields Incomplete, never Allow | skill-security | testplan-skill-security.md | PRD-001.6 | Automated | Defined |
| TC-016 | Handed-over content audited without second download; declined download writes no file | skill-security | testplan-skill-security.md | PRD-001.5, PRD-001.7 | Manual | Defined |
| TC-017 | Folder with no SKILL.md reported as not a skill | skill-security | testplan-skill-security.md | PRD-001.8 | Automated | Defined |
| TC-018 | Portfolio audit lists every installed skill with recommendation and finding count | skill-security | testplan-skill-security.md | PRD-002.1 | Automated | Defined |
| TC-019 | Unchanged skills shown as current; intent review skipped for them | skill-security | testplan-skill-security.md | PRD-002.2 | Automated | Defined |
| TC-020 | Unreadable skill folder listed as Incomplete; audit continues | skill-security | testplan-skill-security.md | PRD-002.3 | Automated | Defined |
| TC-021 | Portfolio with no trust records reviews every skill | skill-security | testplan-skill-security.md | PRD-002.4 | Automated | Defined |
| TC-022 | Capability findings name stated purpose and access, including config, hook and MCP writes | skill-security | testplan-skill-security.md | PRD-003.1, PRD-003.3, PRD-003.4 | Automated | Defined |
| TC-023 | Untrusted input + private data + outbound channel rated at least High | skill-security | testplan-skill-security.md | PRD-003.2 | Automated | Defined |
| TC-024 | Obfuscated content flagged; tool-less skill text still checked | skill-security | testplan-skill-security.md | PRD-003.5, PRD-003.6 | Automated | Defined |
| TC-025 | Intent reviewer holds no tools and receives skill only as delimited text | skill-security | testplan-skill-security.md | PRD-004.1 | Automated | Defined |
| TC-026 | Every intent verdict conforms to the fixed verdict format | skill-security | testplan-skill-security.md | PRD-004.2 | Automated | Defined |
| TC-027 | Model tier routing: Opus single-skill, Sonnet portfolio, Opus repeat on Critical/High | skill-security | testplan-skill-security.md | PRD-004.3, PRD-004.4 | Automated | Defined |
| TC-028 | Detection on EVL-001 meets its recorded thresholds | skill-security | testplan-skill-security.md | PRD-004.5 | Automated | Defined |
| TC-029 | Out-of-format verdict discarded; result Incomplete | skill-security | testplan-skill-security.md | PRD-004.6 | Automated | Defined |
| TC-030 | Verdict-override instruction rated at least High, quoted as evidence | skill-security | testplan-skill-security.md | PRD-004.7 | Automated | Defined |
| TC-031 | Each finding carries AST10 ID and severity, plus secondary ID where applicable | skill-security | testplan-skill-security.md | PRD-005.1, PRD-005.2 | Automated | Defined |
| TC-032 | Finding with no AST10 match reported as Unmapped | skill-security | testplan-skill-security.md | PRD-005.3 | Automated | Defined |
| TC-033 | Report names the AST10 version used | skill-security | testplan-skill-security.md | PRD-005.4 | Automated | Defined |
| TC-034 | Trust record holds all six fields | skill-security | testplan-skill-security.md | PRD-006.1 | Automated | Defined |
| TC-035 | Changed fingerprint reported as changed and reviewed again | skill-security | testplan-skill-security.md | PRD-006.2 | Automated | Defined |
| TC-036 | CONFIRM override logged with date, fingerprint and overridden findings | skill-security | testplan-skill-security.md | PRD-006.3 | Automated | Defined |
| TC-037 | Trust register write refused inside a git working tree | skill-security | testplan-skill-security.md | PRD-006.4 | Automated | Defined |
| TC-038 | First audit creates an empty trust register | skill-security | testplan-skill-security.md | PRD-006.5 | Automated | Defined |
| TC-039 | Excepted finding shown at lowered severity with exception cited, never hidden | skill-security | testplan-skill-security.md | PRD-007.1 | Automated | Defined |
| TC-040 | Shipped baseline exceptions keyed by fingerprint | skill-security | testplan-skill-security.md | PRD-007.2 | Automated | Defined |
| TC-041 | User exceptions add to the baseline, never remove it | skill-security | testplan-skill-security.md | PRD-007.3 | Automated | Defined |
| TC-042 | Stale exception ignored and reported | skill-security | testplan-skill-security.md | PRD-007.4 | Automated | Defined |
| TC-043 | /assimilate audits before evaluation and halts on Critical/High until CONFIRM | skill-security | testplan-skill-security.md | PRD-008.1, PRD-008.2 | Manual | Defined |
| TC-044 | /assimilate shows Medium/Low findings and continues | skill-security | testplan-skill-security.md | PRD-008.3 | Manual | Defined |
| TC-045 | /assimilate halts on Incomplete verdict until CONFIRM | skill-security | testplan-skill-security.md | PRD-008.4 | Manual | Defined |
| TC-046 | Prose-only source reported as not auditable | skill-security | testplan-skill-security.md | PRD-008.5 | Manual | Defined |
| TC-047 | Dated report saved outside every git working tree | skill-security | testplan-skill-security.md | PRD-009.1 | Automated | Defined |
| TC-048 | Report write refused inside a git working tree | skill-security | testplan-skill-security.md | PRD-009.3 | Automated | Defined |
| TC-049 | No-findings audit still writes a dated report | skill-security | testplan-skill-security.md | PRD-009.4 | Automated | Defined |
| TC-050 | No malicious EVL-001 sample receives Allow | skill-security | testplan-skill-security.md | PRD-010.2 | Automated | Defined |
| TC-051 | Samples not loadable and absent from Codex and standalone builds | skill-security | testplan-skill-security.md | PRD-010.3 | Automated | Defined |
| TC-052 | Tuning and held-out halves disjoint; only held-out forms EVL-001 | skill-security | testplan-skill-security.md | PRD-010.1 | Automated | Defined |
| TC-053 | Malicious sample rated below High recorded as detection failure; release withheld | skill-security | testplan-skill-security.md | PRD-010.5 | Automated | Defined |
| TC-054 | Safe security-content sample receives no High or Critical | skill-security | testplan-skill-security.md | PRD-010.6 | Automated | Defined |
| TC-055 | SEC-NNN promotion waits for maintainer approval | skill-security | testplan-skill-security.md | PRD-009.2 | Manual | Defined |
| TC-056 | Copilot prompt 15,000 characters or fewer | skill-security | testplan-skill-security.md | PRD-011.3 | Automated | Defined |
| TC-057 | Copilot verdict in fixed format, labelled Indicative, no rendered links, no work search, search instruction rated High | skill-security | testplan-skill-security.md | PRD-011.1, PRD-011.2, PRD-011.4, PRD-011.5, PRD-011.6 | Manual | Defined |
