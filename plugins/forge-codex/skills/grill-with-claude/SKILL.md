---
name: "grill-with-claude"
description: "Route a Codex session through the shared peer-grilling protocol with Claude as the independent reviewer. Use when the user asks for $grill-with-claude or wants Claude to challenge a Codex plan."
metadata:
  category: pipeline
  alias_for: grill-with-peer
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Grill With Claude

Invoke `$grill-with-peer` with Claude as the requested independent peer. Follow the shared protocol and do not duplicate or replace it.
