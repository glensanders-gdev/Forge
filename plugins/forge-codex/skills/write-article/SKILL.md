---
name: "write-article"
description: "Write long-form content — Confluence pages, README sections, stakeholder summaries, Go/No Go briefs, release notes, guides, and reports — in a clear, concrete voice that sounds like a person, not an AI. Use when producing any written deliverable longer than a paragraph where voice consistency, structure, and credibility matter."
metadata:
  category: code-quality
  version: 1.1.0
  origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)
---

# Write Article

Write long-form content that sounds like an actual person with a point of view — not an AI smoothing itself into generic paste.

Adapted from ECC's article-writing skill. Applied to Forge's written deliverables: Confluence pages, READMEs, stakeholder communications, Go/No Go briefs, PI summaries, research outputs, and release notes.

---

## When to Use

- Writing or updating `forge-confluence.md` or any Confluence section
- Drafting stakeholder-facing content (PI summaries, release communications, Go/No Go briefs)
- Writing or improving README sections
- Turning research notes or session findings into a structured document
- Any written deliverable where generic AI tone would undermine credibility

---

## Core Rules

1. **Lead with the concrete thing** — artifact, example, number, outcome, or specific observation. Explain after, not before.
2. **Use proof instead of adjectives** — "reduced deployment failures by 40%" beats "significantly improved reliability."
3. **Tight sentences** — unless the intended voice is deliberately expansive, keep sentences short.
4. **Never invent facts or evidence** — if you don't have a number, don't invent one. Say what you know.
5. **One argument per section** — every section has one job. If it's doing two things, split it.

---

## Voice Handling

If a voice reference is provided (e.g. an existing Confluence page, a previous README section, a stakeholder update the team has written):
1. Read it before writing
2. Note: sentence length, formality level, use of headers, tone (direct/warm/technical)
3. Match those properties in the new content

If no voice reference is given, default to the **Forge voice**: plain, direct, concrete, professional without being formal. The Confluence page in this session is the reference.

---

## Banned Patterns

Delete and rewrite any of these — they signal AI-generated filler:

- "In today's rapidly evolving landscape"
- "game-changer", "cutting-edge", "revolutionary", "transformative"
- "Here's why this matters" as a standalone bridge sentence
- Generic opening paragraphs that delay the actual content
- Closing questions added to seem engaging ("What do you think?")
- Biography padding that doesn't move the argument
- Any sentence that could be deleted without losing meaning

---

## Format Guidance by Document Type

### Confluence Pages
- Lead section answers: what is this, why does it exist
- Use headers for navigation, not decoration — only add a header if the section needs to be found independently
- Plain language first, technical detail second
- Stakeholder audience: avoid jargon; when unavoidable, define it inline

### README
- First paragraph: what it is and who it's for, in two sentences
- Code examples before explanations, not after
- Version history is a table, not prose
- Installation steps are numbered and tested

### Stakeholder Summaries (PI end, release notes)
- Lead with what was delivered — not with how hard it was
- Use the stakeholder label, not the internal ticket name
- Carry-forwards get one sentence of context: what's next, not why it slipped
- Never apologise for scope changes — just state what changed and when it will land

### Go/No Go Briefs
- Status first — GO recommendation or NOT GO, in the first line
- Evidence second — what's ready, what isn't
- Risk third — what could go wrong and what the mitigation is
- Decision required — explicit, dated, owned

### Research Outputs
- Lead with the finding, not the methodology
- One claim per paragraph
- Link to source documents, don't reproduce them
- End with: implications for the current project, not generic conclusions

---

## Writing Process

0. **Check style guide** — if `~/.codex/forge/knowledge/company/style-guide.md` exists and is populated, read it before writing. Apply its tone, terminology, banned phrases, and formatting standards throughout. If it is a placeholder, proceed without it and note: "Style guide not yet populated — run `$style-check` once filled in."
1. **Clarify audience and purpose** — who reads this and what do they need to do after reading it?
2. **Build a hard outline** — one job per section, stated in plain language
3. **Draft section by section** — start each section with the concrete thing (proof, finding, outcome)
4. **Expand only where earned** — each new sentence must add something the previous one didn't
5. **Cut anything templated** — if a sentence could appear in any document about any topic, delete it

---

## Quality Gate

Before delivering any written content:

- [ ] Every factual claim is backed by provided sources or documented data
- [ ] Generic AI transitions and filler phrases are gone
- [ ] Voice matches the supplied reference or the Forge default voice
- [ ] Every section adds something new — no padding
- [ ] Format matches the intended medium (Confluence, README, brief, etc.)
- [ ] The first sentence would make a reader want to read the second
- [ ] If this is an external deliverable, run `style-check` to validate against the company style guide

---

## Forge Integration Points

| Skill | How article-writing applies |
|-------|---------------------------|
| `$update-readme` | Apply voice and structure rules when drafting README updates |
| `$pi-end` | Stakeholder delivery summary follows the Stakeholder Summary format above |
| `$go-nogo` | Go/No Go brief follows the brief format above |
| `$handoff` | Handoff notes follow the concrete-first rule |
| Confluence page | Full article-writing skill applies |
| `$research` | Research outputs follow the research output format above |

---

## Rules

- Never invent evidence — if you don't have a number, don't fabricate one
- Always clarify audience before writing anything substantial
- Voice consistency matters more than variety — once a voice is established, maintain it
- The quality gate is not optional for any Forge-produced written deliverable

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No audience specified | Ask: "Who reads this and what do they need to do after reading it?" — never assume |
| No voice reference available | Default to Forge voice (plain, direct, concrete, professional) |
| Content is too long | Apply the "cut anything templated" rule — offer a tighter version |
| Factual gaps | Flag explicitly: "I don't have a number for X — use [placeholder] and fill in before publishing" |
