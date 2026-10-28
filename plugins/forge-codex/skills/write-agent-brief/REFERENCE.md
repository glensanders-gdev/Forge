# Write Agent Brief — Reference

Read by `$write-agent-brief` before Phase 1. The template, the conversation-source rules, the checks, and the reasons behind each part.

---

## Brief template

The slots below are filled in Phase 1, step 3. Each slot holds content traced to the source, or
`GAP`. The order is fixed: the agent meets the outcome first and the detail after it.

| # | Slot | Holds | Thin-source stop if `GAP`? |
|---|---|---|---|
| 1 | **Goal** | One sentence stating the outcome and who it serves | Yes |
| 2 | **Done** | The observable state that ends the work | Yes |
| 3 | **Source** | Paths (repo agent) or labelled excerpts (chat assistant) the agent works from, and the instruction to work from them only | No |
| 4 | **Acceptance criteria** | Testable criteria in `standards/language.md` form, keeping the source's IDs | No |
| 5 | **Constraints** | What to do, each with the reason it matters | No |
| 6 | **Scope** | In scope, out of scope, and the stop conditions that end the run early | No |
| 7 | **Verify** | The check the agent runs before it reports done: a command, a test, or a review against the criteria | No |
| 8 | **Ask before acting** | Open questions, and the decisions the agent hands back rather than makes | No |
| 9 | **Report** | What the agent returns: format, length, and what to flag | No |

### Repo agent

```markdown
# Brief: [title]

**Goal:** [one sentence]
**Done when:** [observable end state]

## Source
Work from these, and nothing else, for requirements:
- `[path]` — [what it holds]
Where the source is silent, list the gap under "Questions" in your report and leave it open.

## Acceptance criteria
| ID | Criterion |
|---|---|
| [PRD-NNN.N] | [declarative end state] |

## Constraints
- [Do X], because [reason].

## Scope
- **In:** [...]
- **Out:** [...] — leave these untouched even where a change looks useful.
- **Stop and report** if [condition], rather than working round it.

## Verify
Before reporting done, run `[command]` and confirm [result]. Check each criterion above, and
mark it met, unmet or untested.

## Ask before acting
- [Decision handed back to the human]

## Report
[Format]. List the criteria met and unmet, the files changed, and every question raised.
```

### Chat assistant

Built on the four-part prompt Microsoft recommends for Copilot: goal, context, source and
expectations. The source material comes **first**, because chat assistants attend best to long
input placed before the question.

```markdown
<source>
[Label]: [minimum excerpt each criterion needs]
</source>

**Goal:** [one sentence]. **Done when:** [end state].

**Context:** [who it is for and why it matters].

**Use only the source above.** Where it does not answer something, list it under "Gaps" and
do not supply an answer of your own.

**Requirements:**
| ID | Criterion |
|---|---|

**Constraints:** [do X, because Y].

**Expectations:** [format, length, tone]. End with "Gaps" and "Assumptions I made", each empty
if none.

**Before you start,** ask me anything you need to know to meet the requirements.
```

---

## Conversation source

Applies when the source is this session, or pasted notes or a transcript. A document is agreed
text; a conversation mixes what the user decided with what was only suggested, and changes its
mind as it goes. These rules settle what counts as a requirement.

**Provenance.** Tag each candidate item before it fills a slot:

| Tag | Means | Fills a slot? |
|---|---|---|
| **Stated** | The user said it | Yes |
| **Accepted** | The assistant proposed it and the user plainly agreed (“yes”, “go with that”, or acted on it) | Yes |
| **Proposed** | The assistant proposed it and the user moved on without agreeing | No: `GAP` |
| **Inferred** | Nobody said it; it follows from what was said | No: `GAP` |

Silence is not agreement. In notes or a transcript with several speakers, a point is **Stated**
only when the speaker who owns the decision made it; any other speaker's point is **Proposed**.

**Reversals.** Where a later decision replaces an earlier one, the later one fills the slot and the
pair goes in the first gap round as `Earlier: X. Later: Y. Y stands?`. Where the conversation
moved on without settling a point, it is a `GAP`.

**Goal and Done round.** Where either is missing, ask for it once, in the first gap round,
recommending an answer drawn from the conversation and saying which lines it comes from. This is the
only elicitation the skill does. More is a grill.

**Source slot.** The agent never sees the conversation, so the Source slot holds the decisions as
numbered statements, each one a Stated or Accepted item, worded so it stands alone:

```markdown
## Source
Decisions agreed before this brief (work from these, and the files below, only):
1. Passkeys are offered only to users who already have a password.
2. The existing password path stays as it is.
- `src/auth/login.ts`: current sign-in flow
```

---

## Cold-reader checks

Run in Phase 3, step 7. Each check has a pass condition.

| Check | Passes when |
|---|---|
| **Cold read** | Someone with only the brief and the named sources could start without asking what the goal is |
| **Every line live** | Removing any line would change what the agent does. Restated code facts and default behaviour are cut |
| **No contradiction** | No two instructions can both apply and disagree, including against `CLAUDE.md` / `AGENTS.md` where the target reads them |
| **Reasons given** | Every constraint carries its reason |
| **Positive framing** | Each instruction says what to do. A "never" remains only on a consequential or irreversible action |
| **Even emphasis** | No CRITICAL, MUST or capitals used for emphasis. Current models over-apply shouted instructions |
| **Testable criteria** | Each criterion is true or false at verification, per `standards/language.md` |
| **Verify is runnable** | The check names a command, test or review the agent can perform, and the result that passes |
| **Scope bounded** | Out of scope and at least one stop condition are stated |
| **One goal** | The brief serves a single goal |
| **Data clean** | No personal information, customer data or credentials are in the brief or its excerpts |

---

## Worked pairs

**Goal**

> ✗ `Improve the login flow.`
> ✓ `Goal: a returning user signs in with a saved passkey in one step. Done when: PRD-014.1 to PRD-014.3 pass and the existing password path is unchanged.`

**Gaps**

> ✗ Source is silent on lockout. The brief says `Lock the account after 5 failed attempts.`
> ✓ `Ask before acting: the source sets no lockout threshold. Propose one and wait for approval.`

**Constraints**

> ✗ `NEVER modify the schema!!`
> ✓ `Leave the database schema unchanged, because migrations ship separately in another release. If a criterion cannot be met without a schema change, stop and report.`

**Verify**

> ✗ `Make sure it works.`
> ✓ `Run npm test -- auth and confirm zero failures. Then check each criterion and mark it met, unmet or untested.`

**Conversation provenance**

> ✗ The assistant suggested rate-limiting sign-in to 10 a minute; the user replied about the button
> colour. The brief says `Rate-limit sign-in to 10 attempts a minute.`
> ✓ `Ask before acting: rate-limiting was suggested but not agreed. Confirm whether it is in scope.`

**Chat source**

> ✗ `Write the requirements section using what you know about our billing system.`
> ✓ `Use only the excerpt labelled BRD §3. Where it does not cover a case, list it under Gaps.`

---

## Why each section exists

The practices below come from vendor and practitioner guidance current at October 2026. Vendor
pages are living documents, so check the page for the model in use before relying on a detail.

| Brief section | Practice | Support |
|---|---|---|
| Goal, Done | State the outcome and the definition of done explicitly. Current models do what is literally asked | Anthropic prompting best practices; Microsoft Copilot prompts; Google Gemini prompting strategies |
| Source | Ground the output in supplied material, and flag gaps rather than fill them | Microsoft (Source); Anthropic ("investigate before answering") |
| Source placement | Long material first, question last | Anthropic; Google |
| Acceptance criteria | Testable statements the agent can check its work against | AWS Kiro (EARS); Anthropic Claude Code best practices (spec before build) |
| Constraints | Give the reason. Say what to do rather than what not to do | Anthropic |
| Even emphasis | Shouted instructions over-trigger on current models | Anthropic; OpenAI GPT-5 prompting guide (Cursor case) |
| No contradiction | Contradictions cost precise instruction-followers the most | OpenAI GPT-5 prompting guide |
| Scope, stop conditions | Bound eagerness and unrequested changes | Anthropic; OpenAI; Google |
| Verify | Give the agent a check to run before it reports done | Anthropic Claude Code best practices |
| Conversation source | Interview the user, write the spec, then build from a fresh session that holds only the spec | Anthropic Claude Code best practices (interview pattern); Anthropic context engineering (context rot) |
| Ask before acting | Ask rather than assume | Google; AWS Kiro (ambiguity check); Claude Code (interview pattern) |
| Every line live | Context is a finite attention budget. Include only what the agent cannot infer | Anthropic, *Effective context engineering for AI agents* (2025-09-29) |
| One goal | Small, gated units of work | GitHub Spec Kit; AWS Kiro; Claude Code |

**EARS is optional.** "WHEN [trigger], [response]" suits event-driven criteria, and coding agents
read it well. Where a criterion uses it, the `standards/language.md` rules still apply: no modal verb and no
"the system".

**Not adopted:** heavy multi-file spec pipelines. Thoughtworks cautions that long specs are hard to
review and pull towards big-bang delivery. A brief is one unit of work, and the requirements
documents stay where they are.
