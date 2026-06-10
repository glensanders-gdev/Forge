---
name: "lang-rules"
description: "Install language-specific coding guidance into the closest appropriate AGENTS.md. Use when onboarding a project or adding durable language conventions for Codex."
metadata:
  category: code-quality
  origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC) and Glen Sanders (Forge)
---

# Language Guidance

Codex rules control command execution. Coding conventions belong in `AGENTS.md`.

## Process

1. Detect the repository's primary languages and major source boundaries.
2. Read relevant guidance under the plugin's `references/coding-guidance/`.
3. Identify the closest appropriate `AGENTS.md` location for each language or subsystem.
4. Propose concise additions containing only durable conventions, build commands, and verification expectations.
5. Wait for confirmation before creating or modifying any `AGENTS.md`.
6. Recommend linters, formatters, and pre-commit checks for mechanical enforcement.

## Rules

- Never write coding standards into `.codex/rules`.
- Never duplicate guidance already present in a closer `AGENTS.md`.
- Never add vague or untestable instructions.
