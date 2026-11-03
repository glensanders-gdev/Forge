# Write System Prompt — Platforms

`$write-system-prompt` reads the section for each target before rendering it in Phase 3. Each
section gives the format, a skeleton, the hard limits and the quirks for that platform.

**Last verified: 2026-11-04.** Vendors change these rules with each model generation. If this
date is more than 90 days old, check the cited pages before relying on a limit.
Source tags: **[V]** means the vendor page was read, **[S]** means the item comes from a search
snippet or secondary source, and **[C]** means it comes from community guidance, not
official documentation.

## Targets

| Key | Platform | Output |
|---|---|---|
| `Codex` | Anthropic Codex: API system prompt, Agent SDK, subagent | One system prompt |
| `openai` | OpenAI Responses API: `instructions` or a developer message | One developer prompt |
| `codex` | OpenAI Codex: `AGENTS.md` | One Markdown file |
| `m365` | Microsoft 365 Copilot declarative agent or Agent Builder | Instructions, description, conversation starters |
| `copilot-studio` | Microsoft Copilot Studio agent | Instructions, plus each tool's and topic's name and description |
| `github-copilot` | GitHub Copilot: `copilot-instructions.md`, `*.instructions.md`, `.agent.md` | One or more Markdown files |
| `servicenow-agent` | ServiceNow AI Agent Studio agent, or an agentic workflow | Description, role, instructions, tool descriptions |
| `servicenow-skill` | ServiceNow Now Assist Skill Kit skill | Role, context, instructions and output prompt sections |

---

## `Codex`

- **Format.** Open with a one-sentence role, then XML-tagged blocks with consistent, descriptive
  names. Nest the tags for hierarchy. Put long reference documents at the top, in a `<documents>` block. [V]
- **Emphasis.** Calm. Aggressive or anti-laziness wording overtriggers on current models, so drop
  CAPS and MUST. [V]
- **Behaviour lines worth including,** where the spec calls for them [V]:
  - Keep working until the task is done, and stop to ask only when blocked.
  - Add nothing that was not requested.
  - Run a real check (tests or a build) before reporting done.
  - Look up anything that may have changed since training.
- **Avoid:**
  - Asking the model to reproduce its reasoning in its reply, which can trigger refusals.
  - "Only use tools when strictly necessary".
  - "Hold all findings for the end" rules. [V]
- **Reasoning depth** is set by the `effort` parameter, not by prompt wording. Note it in the
  hand-over and leave it out of the prompt. [V]
- **Caching.** The prefix order is tools, then system, then messages. Keep the system prompt
  static, and put per-request data in the user turn. [V]
- **Tools.** Write each description as if for a new team member: what it does, when to use it,
  and what each parameter means. Use unambiguous parameter names (`user_id`, not `user`), and
  write error messages that say how to fix the problem. [V]
- **Limits.** No hard cap. The constraint is the context budget.
- **For a Claude Code `CLAUDE.md`,** keep it short and limited to what the model cannot infer from the repository. Rules that must always hold belong in hooks. [V]

```xml
You are [role, one sentence].

<context>[who the users are, the channel, the org terms they use]</context>
<workflow>
1. [Verb] [object]. Output: [x]. Move on when [condition].
</workflow>
<tools>[only hints that the tool descriptions cannot carry]</tools>
<output_format>[tone, length as a number, structure]</output_format>
<boundaries>[scope; ask-or-assume policy; hard limits with reasons]</boundaries>
<examples><example>…</example></examples>
<verification>[the check to run before reporting done]</verification>
```

Sources: platform.Codex.com prompting best practices and the per-model pages; anthropic.com/engineering *Writing tools for agents*; the prompt caching docs.

---

## `openai`

- **Format.** Markdown sections in the order Identity, Instructions, Examples, Context, with the
  context near the end. Use XML only to delimit reference documents. One tagged block per
  behaviour is acceptable (for example `<output_verbosity_spec>`). [V]
- **Priority.** A developer message outranks a user message. `instructions` applies only to the
  current request and is not carried forward by `previous_response_id`. [V]
- **Emphasis.** Calm. Absolutes are followed too literally, and contradictions are costly. [V]
- **Length and scope.**
  - Give concrete length caps.
  - Include a scope-discipline line: implement only what was requested, and take the simplest
    valid reading.
  - Say whether to ask 1–3 questions or to state labelled assumptions. [V]
- **Newer models (GPT-6 family).** The model asks more clarifying questions, so tell it to infer
  and persist unless an action is destructive. It favours lists, so ask for prose when you want
  prose. Bound its testing and its delegation to subagents. [V]
- **Reasoning depth** is the `effort` parameter. Pin the model snapshot, and say so in the
  hand-over. [V]
- **Saved prompt objects** (`v1/prompts`) shut down on 2026-11-30. Keep the prompt in the
  application's code. [V]

```markdown
# Identity
[Role and purpose, 1–2 sentences.]
# Instructions
- [Literal rule, with its reason]
## Workflow
1. [Verb] [object] → [output]. Done when [condition].
## Output
[Length cap, format, tone]
## Boundaries
[Scope, stop conditions, ask-or-assume, hard limits]
# Examples
<example id="1">…</example>
# Context
[Static reference material]
```

Sources: developers.openai.com prompt engineering, prompt guidance, the GPT-5.2 guide.

---

## `codex`

- **Discovery.** Codex reads the global file in `~/.codex`, then each directory from the project
  root down to the current directory. In each, `AGENTS.override.md` takes precedence over
  `AGENTS.md`. The files are concatenated root-first, so the nearer file wins. [V]
- **Limit.** 32 KiB combined by default (`project_doc_max_bytes`). Files past the limit are
  dropped. [V]
- **Format.** Markdown. Start from the standard Codex prompt and add targeted sections:
  - Autonomy and Persistence
  - Code Implementation
  - Editing Constraints
  - Exploration
  - Final Message Formatting [V]
- **Behaviour.**
  - Assume rather than ask, and end with an edit, or with a blocker and a question.
  - Current Codex models want short preambles and progress updates every few steps.
  - Give the build, test and lint commands in the order they run. [V]
- **Content.** Only what the agent cannot read from the repository: commands, conventions, paths and the checks to run before done.

---

## `m365`

- **Limits.**
  - Instructions: **8,000 characters** [V].
  - Description: 1,000 characters [S].
  - Conversation starters: at most 12, each up to 128 characters [S].
  - Name: 30 characters in Agent Builder [S].
- **Format.** Markdown only: `#` headers and `-` bullets, `1.` only where order matters. Use
  backticks for tool and system names and **bold** for critical rules. Do not mix list types. [V]
- **Skeleton.** Purpose, General guidelines, Workflow, Output formatting, Examples. Write the
  workflow steps as **Goal / Action / Transition**, one atomic task each. [V]
- **Name each capability** a step uses (a connector, SharePoint, code interpreter, people). Add
  "only call a tool if its inputs are available; otherwise ask the user". [V]
- **Always state tone, verbosity and format.** If they are left out, they drift as Microsoft
  upgrades the model. [V]
- **Never move instructions into knowledge files.** Knowledge is not trusted as instructions, and
  the XPIA (cross-prompt injection) classifiers may strip directive text from it. Put long
  reference material in knowledge and keep every rule in the instructions. [V]
- **Grounding only.** Set `discourage_model_knowledge: true` in the manifest (v1.6+). [V]
- **Examples.** Use none for simple tasks and several for complex ones. A single example gets
  parroted. [V]
- **Reasoning** is set by prompt phrases such as "Use deep reasoning" or "Short answer only". Add
  a final self-check step. [V]

```markdown
# OBJECTIVE
[Purpose and role]
# RESPONSE RULES
- [Rule, with its reason]
# WORKFLOW
## Step 1: [name]
- **Goal:** …
- **Action:** use `[capability]` to …
- **Transition:** when …, go to Step 2
# OUTPUT FORMATTING RULES
[Tone, length, structure]
# EXAMPLES
[Valid and invalid cases]
```

Source: learn.microsoft.com *Write effective instructions for declarative agents*; the declarative agent manifest reference.

---

## `copilot-studio`

- **Routing comes from names first, then descriptions, not from the instructions.** Write the
  tool and topic names and descriptions before the instructions. Fix misrouting there first. [V]
- **Instructions.**
  - Keep them "as simple and as short as possible".
  - Number them, and say "follow in order".
  - Use `/Name` to insert exact tool, topic, agent or variable references.
  - Add hints only for ambiguous routing. [V]
- **Instructions cannot change:**
  - retrieval
  - the fallback message
  - Adaptive Card triggering
  - content filtering.

  Use **topics** for these, for deterministic wording, and for confirmation before an
  irreversible action. Say so in the hand-over. [V]
- **Knowledge.** Describe knowledge sources generically, by what they hold, rather than by name.
  This differs from `m365`. [V]
- **Tools.** Keep the toolset small, with non-overlapping descriptions. A few example utterances
  in a description help, and a description may say when not to use the tool. [V]
- **Limits.**
  - Standard harness: 8,000 characters on an older quota page, **unverified**. One community
    report describes errors at about 5,300 characters combined [S].
  - The Customer Conversation harness (preview) allows 20,000 characters per tab or sub-agent,
    a 1,024-character description, and skills of up to 3,000 characters each, at most 10 per
    sub-agent [V].
  - Until the standard-harness limit is verified in the product, render under **5,000**
    characters.
- **Debugging.** Remove the instructions, then add them back one at a time, checking the activity
  map after each. Put this in the hand-over. [V]

---

## `github-copilot`

- **Files.**
  - `.github/copilot-instructions.md` applies repo-wide.
  - `.github/instructions/*.instructions.md` take `applyTo` globs and an optional
    `excludeAgent`.
  - `.github/agents/*.agent.md` defines custom agents. `description` is **required**, and the
    body is limited to 30,000 characters. [V]
- **Layering.** Repo-wide and path-specific files apply together. `AGENTS.md` is supported, and
  the nearest one wins. Personal settings outrank repo settings, which outrank org settings.
  Conflicting instructions are all passed to the model. [V]
- **Content.**
  - Short imperative bullets.
  - Build, test and lint commands in order, and the key paths.
  - Small good/bad code examples.
  - Standards pasted inline, not linked.
  - Start with 10–20 instructions, and keep each file under about 1,000 lines. [V]
- **Leave out** vague goals ("be more accurate"), emoji or formatting requests, and attempts to
  change Copilot's core behaviour. [V]
- **Handoffs.** `handoffs` and `argument-hint` in `.agent.md` are ignored on GitHub.com. [V]

---

## `servicenow-agent`

- **Fields.** Render each field separately [V]:
  - **Description:** the key tasks, inputs and outputs. It must distinguish this agent from
    every other agent, because the orchestrator selects on it.
  - **Role:** 1–2 sentences covering function, the business problem and a usage scenario, with
    the limits that keep agents from overlapping. Limit 2,000 characters [S].
  - **Instructions:** ordered steps, each starting with a verb (Fetch, Validate, Generate) and
    each producing an output. Include explicit conditions ("If priority = High, escalate"),
    error contingencies, and the success and end states.
  - **Tool descriptions:** what, when and why, plus inputs and outputs. Use the output
    transformation field when a downstream agent needs a format.
- **Agentic workflow** (orchestration) instructions: numbered steps with a starting condition,
  decision points, end states, and when each agent is triggered. Use "the user". Use "show",
  "display" or "inform" for steps that only display information. [V]
- **Emphasis exception.** ServiceNow's own guidance uses "NEVER" for hard limits. Community
  guidance repeats critical rules at the start, in the relevant step, and at the end, in
  identical wording. Allow this for **slot-11 hard limits only**, and for at most three of them.
  [V]/[C]
- **Tool naming.** Name assigned custom tools exactly, and update the instructions whenever a tool
  is renamed. For built-in tools, use action keywords (search, fetch, analyse) rather than tool
  names, because naming unassigned tools sends the agent looking for them. Test both. [V]/[C]
- **Execution.** Tools marked `copilot` pause for user confirmation, and tools marked `autopilot`
  run automatically. Recommend `copilot` for irreversible actions. [V]
- **Scale.** At most about 10 agents per workflow and about 15 tools is recommended. The context
  window is 128K. The orchestrator runs on Azure OpenAI GPT models, so write the prompt to be
  model-agnostic, not Codex-specific. [V]/[C]
- **Markdown** rendering in the instructions field is **unverified**. Use plain numbered steps.

---

## `servicenow-skill`

- **Template.** Four mandatory sections: Role, Context, Instructions, Output. Inputs are
  referenced as variables in the template. [V]
- **Outputs.** The five outputs are fixed: `response`, `confidence`, `explanation`, `metadata`,
  `citations`. Custom outputs are not supported, so the Output section shapes `response` only. [V]
- **Tools** run before the prompt, and their results are merged into it. Refer to a tool's output
  variable; never ask the model to call a tool. [V]
- **Testing.** Check the literal text in the Grounded Prompt view. Automated Prompt Optimization
  needs a dataset of at least 100 records. [S]

Sources: servicenow.com docs *General guidelines for creating AI agents and agentic workflows*; the Now Assist Skill Kit overview; the ServiceNow SDK Now Assist skills guide; ServiceNow Community *Advanced AI Agent Instructions Guide*.
