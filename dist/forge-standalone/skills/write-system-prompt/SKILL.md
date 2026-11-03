---
name: write-system-prompt
category: pipeline
description: Write an LLM-optimised system prompt for an AI agent. It builds one platform-neutral agent spec, then renders it for each target platform within that platform's format and limits, lints it, and adds a test set. Targets are the Anthropic API, the OpenAI API, Codex AGENTS.md, Microsoft 365 Copilot declarative agents, Copilot Studio, GitHub Copilot, and ServiceNow AI Agent Studio or Now Assist Skill Kit. Use when the user runs /write-system-prompt, is building or configuring an agent on one of these platforms, or wants an existing agent prompt ported, tightened or reviewed.
---

# Write System Prompt

Write the persistent instructions that define an agent. The core is **one spec, many renders**.
The agent's behaviour is settled once, in a platform-neutral **spec**. Each target platform then
gets a **render**, a prompt in that platform's format, within its limits, in the fields it
expects. The behaviour stays the same in every render; only the format changes.

This skill writes the standing prompt for an agent. A one-off task handed to an agent is a brief,
which is `/write-agent-brief`.

**Before Phase 1, read [REFERENCE.md](REFERENCE.md):** the spec slots, the lint checks and the test-set
format. **Before rendering for a target, read that target's section of
[PLATFORMS.md](PLATFORMS.md).** Its rules are dated, and the platforms change underneath them.

## Phase 1 — Spec [AFK]

1. **Name the source and the targets.** The source is either a **document** (a PRD, notes, or an
   existing prompt to port or tighten) or an **interview** (nothing written yet). The targets are
   one or more of the keys in PLATFORMS.md § Targets. Ask once if either is missing. Done when
   the source and every target key are named.
2. **Run the data check.**
   A system prompt and its examples ship with the agent and are read on every turn. Strip
   personal information, customer data, credentials and internal hostnames, and use placeholders
   in examples. Done when every line of the source has been checked, and anything removed has
   been named to the user.
3. **Fill the spec.** Map the source onto REFERENCE.md § Agent spec. Every slot holds content
   traced to the source, or `GAP`. An interview asks each slot's question in order, at most five
   per round, each with a recommended answer. Done when every slot is filled or marked `GAP`.

**Thin-source stop.** If **Purpose** or **End state** is still `GAP` after step 3, stop. A prompt
written without them produces an agent that cannot tell when it has finished. Recommend a
stress-test of the idea (`/grill-me`) first.

## Phase 2 — Gap Gate [HITL]

4. **Put every remaining `GAP` to the user** as a numbered question, at most five per round, each
   with a recommended answer. Wait for a reply to every round. Done when no `GAP` remains: each is
   answered, or recorded as deliberately left to the model's judgement.
5. **Show the spec** and get approval before rendering. Changing the spec is cheap now. Changing
   it after four renders means four rewrites.

## Phase 3 — Render [AFK]

6. **Render each target** from the approved spec, using its PLATFORMS.md section: the skeleton,
   the delimiter style, the emphasis rules, and the field split for field-based platforms.
   Render content only the spec holds. Done when every spec slot appears in every render, or is
   listed as deliberately carried elsewhere (for example, M365 knowledge or a ServiceNow tool
   description).
7. **Measure each render against its limits.** Count characters with a tool such as `wc -m`,
   never by eye. Keep 10% headroom under each hard cap. Done when every field is under its cap,
   or the user has approved what moves out to knowledge, tools or skills.
8. **Lint each render** against REFERENCE.md § Lint checks. Done when every check passes or its
   fix is applied. A failing check gets fixed. It never becomes a footnote.
9. **Write the test set** per REFERENCE.md § Test set. Done when every hard limit, every branch of
   the workflow and every stop condition has at least one case.

## Phase 4 — Hand-over [HITL]

10. **Save and present.** Inside a repository, write `docs/prompts/[slug]/spec.md`, one
    `[target].md` per render, and `tests.md`. Outside one, return each as a fenced block. Each
    field of a field-based platform goes in its own block, labelled with its character count.
    The user installs the prompt. This skill never publishes, deploys or configures an agent
    on any platform.

## Rules

- The spec is the single source of truth. To change behaviour, change the spec and re-render.
  Never edit one render on its own.
- Every line in a render changes what the agent does. A line restating platform defaults, or
  what a competent model would do anyway, is cut.
- Each constraint is stated as what to do, with its reason. Keep a "never" only for consequential
  or irreversible actions. Those actions also get a confirmation step in the workflow, not prose
  alone.
- Routing text is prompt text. Agent and tool names and descriptions get the same care as the
  instructions, and on Copilot Studio and ServiceNow they matter more.
- Follow the platform's rule over a general preference. For example, Markdown on M365 and XML on
  Claude.

## Failure Modes

| Condition | Behaviour |
|---|---|
| Purpose or End state missing | Thin-source stop. Write no prompt |
| A gap tempting to fill from inference | Mark it `GAP` and ask. An inferred rule is a fabricated one |
| Two spec slots conflict | Resolve the conflict with the user before rendering. Precise models spend effort reconciling contradictions, and lose |
| A render is over its limit | Move reference material to knowledge, tools or skills, with approval. Never truncate silently |
| User asks to "make it stronger" with CAPS or MUST | Explain that current models overtrigger on it. Apply it only where PLATFORMS.md allows it |
| Porting an existing prompt | Extract it into a spec first, then render. Never translate one platform's prompt directly into another's format |
| PLATFORMS.md section is over 90 days old | Say so, and recommend checking the vendor page it cites before relying on its limits |
| Restricted data in the source or the examples | Remove it, use placeholders, and tell the user what was removed |
| Agent's actions are irreversible | Add a confirmation step and a hard limit. On platforms with a deterministic option (a Copilot Studio topic, a ServiceNow tool in `copilot` mode), recommend that over prose |
