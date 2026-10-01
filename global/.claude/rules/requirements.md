---
paths:
  - "**/docs/brd/**"
  - "**/docs/prd/**"
  - "**/docs/ord/**"
  - "**/docs/ac/**"
---

# Requirements Documents

BRDs, PRDs, ORDs and acceptance criteria are written to the standards in
`~/.claude/standards/requirements/`. Before changing one, read `README.md` there for the scope
boundary, then `language.md` and `tables.md`. `ai.md` and `reporting.md` apply only where their
trigger tests fire, and `llm-companion.md` governs the `.llm.md` companion beside a BRD or ORD.
The `/write-*` skills read these files themselves.
