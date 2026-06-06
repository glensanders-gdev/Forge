---
name: "intent-layers"
description: "Alias for $context-health. Audits token load and recommends directory-scoped AGENTS.md child nodes. Use when thinking about context structure in terms of Tyler Brandt\u0027s \"Intent Layer\" framework."
metadata:
  version: 1.0.0
  category: framework
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Intent Layers

Alias for `$context-health`. Invoke the context-health skill directly.

Intent Layer is Tyler Brandt's term for directory-scoped `AGENTS.md` files that give the AI agent
scoped instructions without loading the entire project context. `$context-health` includes Intent
Layer child node recommendations as of v1.1.0.

## Failure Modes

- If `$context-health` is not available, report it clearly — do not guess.

## Rules

- Always delegate to `$context-health` — do not reimplement logic here.
