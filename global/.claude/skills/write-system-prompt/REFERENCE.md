# Write System Prompt — Reference

`/write-system-prompt` reads this before Phase 1. It holds the agent spec, the lint checks, the
test-set format, and the reason behind each part. Platform-specific rules are in
[PLATFORMS.md](PLATFORMS.md).

---

## Agent spec

The spec is filled in Phase 1, step 3. Each slot holds content traced to the source, or `GAP`.
In an interview, ask the questions in this order. The order runs from what the agent is for to
how it proves it is done.

| # | Slot | Holds | Interview question | Stop if `GAP`? |
|---|---|---|---|---|
| 1 | **Purpose** | One sentence on what the agent does and for whom | "In one sentence, what does this agent do, and for whom?" | Yes |
| 2 | **Role** | One or two sentences of identity and boundary, including what it leaves to neighbouring agents | "What is it, and what is it not responsible for?" | No |
| 3 | **Users and channel** | Who talks to it, where (chat, panel, IDE, API, triggered), and their expertise | "Who uses it, and where?" | No |
| 4 | **Inputs** | What arrives with each turn or trigger: fields, variables, records, files | "What does it receive when it starts?" | No |
| 5 | **Workflow** | Ordered steps, only where the order is real. Each step has an action verb, an output, and the condition that moves it on | "Walk me through what it does, step by step." | No |
| 6 | **End state** | The observable condition that means the agent has finished, for success and for each failure | "How does it, or the orchestrator, know it's done?" | Yes |
| 7 | **Tools and knowledge** | Each tool and knowledge source, with its name, what it does, when to use it and when not to, its required inputs, and its side effects | "What can it call or read, and when should it?" | No |
| 8 | **Output contract** | Tone, length (as a number), format, structure, and what it must flag | "What should a good reply look like?" | No |
| 9 | **Scope and stop conditions** | What is in and out of scope, and when to stop and hand back rather than work around a problem | "What should it refuse or hand off, and when should it stop?" | No |
| 10 | **Ask or assume** | When missing information means asking, and when it means assuming and labelling the assumption | "If information is missing, should it ask or make a labelled assumption?" | No |
| 11 | **Hard limits** | The few consequential or irreversible actions it must not take, or must confirm first, each with its reason | "What must it never do without a person's say-so?" | No |
| 12 | **Examples** | 2–3 diverse input-to-output pairs, only where the task is complex or the format is unusual | "Can you give a real example of a good result?" | No |
| 13 | **Verification** | The check the agent runs before reporting done | "How should it check its own work?" | No |
| 14 | **Model and effort** | The target model and its reasoning-effort setting, where the platform exposes them | "Which model, if you know?" | No |

**Provenance.** In a document source, a slot is filled only from what the document says. In an
interview, it is filled only from what the user says or plainly accepts. A recommendation the
user lets pass is still a `GAP`.

**Porting an existing prompt.** Extract the prompt into the slots first. Then list what in it
fits no slot: platform boilerplate, contradictions, and lines that are only emphasis. Ask the
user before dropping any of it.

---

## Lint checks

Run in Phase 3, step 8, against every render. Each check has a pass condition.

| # | Check | Passes when |
|---|---|---|
| L1 | **No contradiction** | No two lines require incompatible behaviour, including across the instructions, the tool descriptions and the knowledge |
| L2 | **Literal and actionable** | Each instruction names an action. No "can you…", "try to", "as appropriate", "should" or "where possible" |
| L3 | **Positive steering** | Behaviour is steered by what to do. A "never" appears only on a hard limit from slot 11 |
| L4 | **Even emphasis** | No CAPS, CRITICAL, MUST or IMPORTANT, unless the target's PLATFORMS.md section allows them, and then only on hard limits |
| L5 | **No no-ops** | Every line changes behaviour against the platform's defaults |
| L6 | **Reasons given** | Every constraint that is not self-evident carries a reason |
| L7 | **Numbers, not adjectives** | Length, count and frequency are stated as numbers ("at most 5 bullets", not "concise") |
| L8 | **Distinct routing text** | No two agents or tools in the same orchestration have overlapping names or descriptions |
| L9 | **Instructions in the instruction field** | No directive text has been pushed into knowledge files or retrieved content |
| L10 | **Static prefix** | <!--no-adapt-->Claude<!--/no-adapt--> and OpenAI only: no timestamps, user names or per-request data in the system prompt or other cached prefix |
| L11 | **Within limits** | Every field is at most 90% of its hard cap, measured with a tool |
| L12 | **Data clean** | No personal information, customer data, credentials or internal hostnames. Examples use placeholders |
| L13 | **Stop and confirm** | Every irreversible action in the workflow has a confirmation step or a deterministic platform control |
| L14 | **Cold-reader test** | Someone with no context could follow the render without asking what a term means. Every org-specific term is defined |

---

## Test set

Written in Phase 3, step 9. Platforms change their models underneath the prompt, and M365 Copilot
does so without notice. The test set is how the user knows a prompt still works.

**Format** (`tests.md`):

```markdown
| ID | Type | Input (placeholder data only) | Expected behaviour | Pass when |
|---|---|---|---|---|
| T1 | Happy path | … | … | Observable condition |
```

**Coverage.** Five to ten cases. At least one of each type that applies:

| Type | Proves |
|---|---|
| Happy path | The main workflow reaches its end state |
| Missing input | The ask-or-assume policy holds |
| Out of scope | The agent hands off or declines as the spec says |
| Hard limit | Each limit holds, including when the user pushes for the action |
| Ambiguous routing | In a multi-agent or multi-tool setup, the right agent or tool is chosen |
| Injected content | Instructions inside a retrieved document, email or record are treated as data |
| Format | The output contract is met: length, structure, tone |
| Stop condition | The agent stops and reports rather than working round a blocker |

Each **Pass when** cell holds an observable condition, such as "asks for the case number before
calling `lookup_case`". "Responds well" is not a condition.

---

## Why each part exists

Vendor guidance current at November 2026. These pages change with each model generation, so
check them before relying on a detail.

| Part | Practice | Support |
|---|---|---|
| One spec, many renders | Every platform agrees on the content of a good prompt (role, literal steps, end state, output contract, bounds) and differs on its format | Common to all four vendors' guidance (see PLATFORMS.md sources) |
| Purpose and End state stop | An agent needs a defined end state, or neither it nor an orchestrator knows when it has finished | ServiceNow agent guidelines; Microsoft Goal/Action/Transition; OpenAI GPT-5.5 stopping condition |
| Literal instructions (L2) | Current models do exactly what is asked | Anthropic prompting best practices; Microsoft declarative agent instructions |
| Even emphasis (L4) | Aggressive wording overtriggers, and absolutes are followed too literally | Anthropic; OpenAI GPT-5 and GPT-5.5 guidance |
| No contradiction (L1) | Precise instruction-followers spend reasoning reconciling conflicts | OpenAI GPT-5 prompting guide |
| Numbers (L7) | Concrete caps hold, adjectives drift | OpenAI GPT-5.2 guide; Microsoft (always specify tone, verbosity and format) |
| Routing text (L8) | Orchestrators select agents and tools from their names and descriptions | Microsoft Copilot Studio orchestration guidance; ServiceNow agent guidelines; Anthropic *Writing tools for agents* |
| Instruction field (L9) | Knowledge is not trusted as instructions, and directive text in it may be stripped | Microsoft declarative agent instructions |
| Static prefix (L10) | Per-request data in the prefix breaks prompt caching | Anthropic and OpenAI prompt caching docs |
| Few, diverse examples | A single example gets copied, and a few diverse ones generalise | Anthropic; Microsoft |
| Test set | Pin the model, build evals, and re-test after any model change | OpenAI prompt engineering guide; Microsoft (automatic model upgrades) |
