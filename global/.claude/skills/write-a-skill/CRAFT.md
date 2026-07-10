---
name: write-a-skill-craft
origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills — productivity/writing-great-skills)
description: Craft reference for write-a-skill — how to make a skill predictable, lean, and reliably invoked. Read when authoring or pruning a skill body and description.
---

# Skill Craft

The mechanics of *good* skill prose — distinct from `SKILL.md`'s structural checklist.
`SKILL.md` tells you which files to create and what to update; this tells you how to make
the words inside them work.

Adapted from Matt Pocock's "Writing Great Skills" (github.com/mattpocock/skills). Forge
already credits Pocock in `~/.claude/PRINCIPLES.md`; this file translates his craft
guidance into Forge conventions and adds the Forge negative-space and failure-mode lens.

---

## The Root Virtue: Predictability

A good skill makes the agent follow the **same process every run** — not produce identical
output, but take the same disciplined path. Every technique below serves predictability.
When two pieces of advice conflict, pick the one that makes behaviour more repeatable.

This is the same instinct behind Forge's PRINCIPLE 5 (*Structure Is the Default*): the
process is the protection.

---

## Leading Words

Recruit a single compact concept the model already learned in pretraining, then reuse it
throughout the skill. The agent reasons *with* that word the whole way through.

- Collapse distributed restatement into one word: "fast, deterministic, low-overhead" → **tight**.
- Replace a fuzzy instruction with a binary observable state: "a loop you believe in" → **red** (the failing test).
- Strengthen no-op adjectives: "be thorough" changes nothing if the agent is already thorough-ish — use **relentless**.
- Repeat the leading word in the description *and* the body so invocation and execution share one hook.

Leading words win twice: fewer tokens, and a sharper anchor for the agent's reasoning.
Good examples from the wild: *lesson*, *fog of war*, *tracer bullets*, *tight*, *red*.

---

## Completion Criteria

The single biggest lever on quality. A step ends when its **completion criterion** is met —
so make the criterion *checkable* and *exhaustive*, not a vague gesture.

- Checkable: the agent can tell done from not-done without guessing.
- Exhaustive where it matters: "every modified model is accounted for", not "models are handled".
- A demanding criterion drives the **legwork** (the digging inside a step) regardless of how
  the steps are structured. Sharpen the criterion *before* you add more steps.

This is how you defeat **premature completion** (see Failure Modes) cheaply and locally.

---

## Information Hierarchy

Rank content by how immediately the agent needs it, across two axes — *steps vs reference*
and *in-skill vs disclosed*:

| Tier | What | Where |
|------|------|-------|
| 1 | Ordered actions the agent performs | inline in `SKILL.md` |
| 2 | Flat, peer-set reference every branch needs | inline in `SKILL.md` |
| 3 | Reference only some branches reach, or bulky tables | a sibling file behind a **context pointer** |

A **context pointer** is the link that sends the agent to tier-3 material. Its *wording* —
not the target file — decides when and how reliably the agent reaches it. Write the pointer
to name the condition: "When adapting from an external source, read CRAFT.md", not "see CRAFT.md".

**Co-locate**: keep a concept's definition, its rules, and its caveats under one heading so
the agent meets them together. This is Forge PRINCIPLE 6 (*Reference, Don't Duplicate*) applied
at paragraph scale.

---

## When to Split a Skill

Two clean tests — split only when one fires; otherwise keep it in one file.

- **Split by invocation** — when a distinct leading word should be able to trigger
  independently, or another skill needs to call this slice. Costs context load (the new
  skill's description sits in the window every turn), so justify it.
- **Split by sequence** — when the steps *after* the current one tempt the agent to stop
  early. Hiding post-completion steps behind a pointer removes the forward pull and forces
  full legwork on the current step first.

Branch handling is the cleanest disclosure test: **inline what every branch needs; push behind
a pointer what only some branches reach.**

---

## The Invocation-Load Tradeoff (Forge dual-invocation note)

Pocock frames skills as *model-invoked* (carries a description; the agent can reach it
autonomously; costs **context load** every turn) **or** *user-invoked* (no description;
only a human can type it; costs **cognitive load** — the human must remember it exists).

**Forge convention differs: every Forge skill is dual-invoked** — it ships a `description`
(model-discoverable) *and* a command file (user-invokable). So Forge doesn't choose between
the two. But the tradeoff still instructs you:

- The `description` is paid for on *every* turn — prune it harder than the body. One trigger
  per genuine branch; collapse synonyms that just rename the same branch.
- Forge's **router** for cognitive load already exists: `/commands` (the `commands` skill)
  indexes every command so a human needn't memorise them. New skills are surfaced there, not
  by inflating individual descriptions.

---

## Pruning Discipline

Run these tests sentence by sentence. Be aggressive — most prose that fails should be
*deleted*, not rewritten.

- **No-op test** — does this line change behaviour versus the agent's default? If a competent
  agent would do it anyway, the line is a no-op. Cut it.
- **Relevance test** — does this line still bear on what the skill does? Staleness, not
  wrongness, is what makes content dead.
- **Single source of truth** — each meaning lives in exactly one authoritative place, so a
  behaviour change is a one-place edit. Duplication costs tokens, maintenance, and inflates
  the prominence of whatever is repeated.

---

## Negation: Prohibition vs Guardrail

Pocock's sharpest warning: **steering by prohibition backfires.** "Never be verbose" primes
verbosity rather than suppressing it — the forbidden behaviour is the loudest word in the
sentence. A prohibition used to shape the *happy path* is weaker than the positive leading
word that would steer it: don't write "never be verbose", write **terse**.

This looks like it contradicts Forge PRINCIPLE 2 (*Negative Space Programming* — explicit
"never" rules). It doesn't; it sharpens it. The two kinds of "never" are different tools:

- **Steering prohibition** (weak — reframe it) — a "never" standing in for craft direction on
  the main path: "never write sloppy code", "never be vague". Replace with a positive leading
  word that does the steering. This is the negation Pocock warns against.
- **Guardrail prohibition** (strong — keep it) — a "never" fencing off a *consequential or
  irreversible* action: "never deploy without `CONFIRM`", "never commit secrets", "never skip
  the review". This is a boundary, not steering — exactly the negative space PRINCIPLE 2 exists
  to protect. The forbidden action is rare and costly, so naming it explicitly is correct.

Test before writing a "never": *is the forbidden thing a guardrail (rare, consequential, a
boundary) or am I really steering the happy path?* If the latter, delete the prohibition and
reach for a leading word instead.

---

## Failure Modes (of skill prose)

| Mode | Symptom | Cure |
|------|---------|------|
| **Premature completion** | Agent stops a step before it's genuinely done | Sharpen the completion criterion first (cheap, local). Only if it's irreducibly fuzzy *and* observed in practice, split by sequence. |
| **Duplication** | Same meaning in two places; they drift apart | Single source of truth — keep one, reference it. |
| **Sediment** | Stale layers pile up because adding feels safe and removing feels risky | Apply the relevance test on every edit; delete dead lines. |
| **Sprawl** | Skill is too long even though every line is live and unique | Disclose tier-3 reference behind pointers; split by branch or sequence. |
| **No-op** | A line that changes nothing versus defaults | Delete it, or replace a weak leading word with a stronger one. |
| **Negation** | A "never" that's really steering the happy path primes the forbidden behaviour | Reframe as a positive leading word. Keep "never" only for guardrails on consequential/irreversible actions (see Negation: Prohibition vs Guardrail). |

---

## Never

- Never pad a `description` with identity already stated in the body — it is paid for every turn.
- Never add a step when the real fix is a sharper completion criterion.
- Never duplicate a meaning across files to "make it easier to find" — pointer to it instead.
- Never leave a no-op line in because deleting feels risky — sediment is how skills rot.
- Never split a skill for tidiness alone — split only by invocation or by sequence.
- Never use a prohibition to steer the happy path where a positive leading word would work — reserve "never" for guardrails on consequential or irreversible actions.

---

## Vocabulary

Compact reference for the terms above (adapted from Pocock's GLOSSARY).

| Term | Meaning |
|------|---------|
| Predictability | Same process every run; the virtue the others serve |
| Leading word | A pretrained concept reused throughout to anchor reasoning and invocation |
| Completion criterion | The checkable condition marking a step as truly done |
| Premature completion | Stopping a step early because attention shifted to "being done" |
| Legwork | The digging the agent does inside a step |
| Information hierarchy | Content ranked by immediacy across in-file/disclosed and steps/reference |
| Context pointer | A link to disclosed material whose wording sets when the agent reaches it |
| Progressive disclosure | Moving reference down the hierarchy to keep the top legible |
| Co-location | Grouping a concept's parts under one heading so they arrive together |
| Branch | A distinct path/case through a skill, triggered by different conditions |
| Context load | Token cost of a description sitting in the window every turn |
| Cognitive load | The human cost of remembering a skill exists |
| Single source of truth | Each meaning in exactly one authoritative place |
| No-op | A line that changes nothing versus default behaviour |
| Sediment | Stale layers accumulating because removal feels risky |
| Sprawl | Excessive length despite every line being live |
| Negation | Steering by prohibition, which primes the forbidden behaviour — reframe positively; keep "never" only for guardrails |
