# Test Case Registry

Tracks all TC-NNN IDs issued across features. Assigned by `/testplan`, updated by `/qa-report`.

| TC | Behaviour | Feature | Testplan | Type | Status |
|----|-----------|---------|----------|------|--------|
| TC-001 | Windows junction install — ReparsePoint confirmed | forge-junction-sync | testplan-forge-junction-sync.md | Manual | Waived |
| TC-002 | Skill edit in `~/.claude/` immediately visible in `git status` | forge-junction-sync | testplan-forge-junction-sync.md | Manual | Waived |
| TC-003 | Migration preserves user data dirs | forge-junction-sync | testplan-forge-junction-sync.md | Manual | Waived |
| TC-004 | Migration flow end-to-end — legacy copy → junction | forge-junction-sync | testplan-forge-junction-sync.md | Manual | Waived |
| TC-005 | `/forge-update` uses `git pull`, does not invoke `update.sh` | forge-junction-sync | testplan-forge-junction-sync.md | Manual | Waived |
| TC-006 | iOS guidance branch shown when `ln`/`mklink` unavailable | forge-junction-sync | testplan-forge-junction-sync.md | Manual | Waived |
| TC-007 | Idempotency — re-run `install.sh` reports `↩ Already linked` | forge-junction-sync | testplan-forge-junction-sync.md | Manual | Waived |
| TC-008 | Wrong remote guard — stops with warning, no filesystem changes | forge-junction-sync | testplan-forge-junction-sync.md | Manual | Waived |
| TC-009 | `install.sh` failure surfaced — `✗ Failed` message visible | forge-junction-sync | testplan-forge-junction-sync.md | Manual | Waived |
| TC-010 | `update.sh` deprecation notice visible at top of file | forge-junction-sync | testplan-forge-junction-sync.md | Manual | Waived |
