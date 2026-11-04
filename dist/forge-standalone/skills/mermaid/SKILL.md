---
name: mermaid
category: ideation
description: Build a Mermaid diagram from context — the conversation, or files the user provides — and save it as a .mmd file. Offers a light grill first when the context is thin. Use when user runs /mermaid, or asks to diagram, map, or visualise a flow, journey, or system interaction.
---

# Mermaid

Turn context into a **faithful** Mermaid diagram — every participant, step and arrow traces back
to something the user said or a file they gave. Nothing is invented to make the picture complete;
a gap is grilled or labelled, never filled by guesswork.

## Process

### 1. Gather the context

Collect the conversation so far plus every file the user names or attaches, each read in full.

**Done when:** every provided file has been read, and you can state in one line what the diagram
is about.

### 2. Offer the fork

Summarise what the context covers in two or three lines, then put the choice to the user:

```
I can:
  1. Grill first — a few questions to fill the gaps before drawing
  2. Draw now — build the diagram from what's here
Gaps I can see: [list, or "none"]
```

Recommend **grill** when a gap would force an invented step, actor or outcome; otherwise **draw**.

**Done when:** the user has chosen 1 or 2 — wait for it.

### 3. Grill (option 1 only)

Ask only what the diagram needs — nothing about cost, priority or delivery. Work in rounds of up
to 5 numbered questions, each with your recommended answer, then wait. Cover, as relevant:

- **Actors** — who or what takes part (people, systems, services)
- **Steps** — what happens, in what order, triggered by what
- **States** — where it starts (current state) and where it ends (target state)
- **Branches** — decisions, failures, exceptions that change the path

**Done when:** every question the diagram depends on is answered or the user has said to draw
with it open. Open items become labelled `[unconfirmed]` in the diagram.

### 4. Pick the diagram type

Choose by the shape of the context — see [TEMPLATES.md](TEMPLATES.md) for each skeleton:

| Context shape | Type |
|---|---|
| Systems or actors exchanging calls, data or responses | `sequenceDiagram` — **System Interaction** |
| Current state → intervention → target state | `flowchart LR` — **Journey** |
| Decisions, branches, exceptions | `flowchart TD` |
| Lifecycle of one thing through statuses | `stateDiagram-v2` |
| Anything else | the Mermaid type that fits |

Context holding both a journey and a system interaction gets both, as separate diagrams.

**Done when:** each type is named with a one-line reason.

### 5. Draw and confirm

Check the syntax rules in [TEMPLATES.md](TEMPLATES.md), then present the diagram inline in a
```` ```mermaid ```` block and ask: "Does this represent it correctly? What's missing or wrong?"
Revise until the user confirms.

**Done when:** the user confirms the diagram, and every element traces to the context or carries
`[unconfirmed]`.

### 6. Save

Save the confirmed diagram as raw Mermaid (no code fence) to `[subject]-[type].mmd`, kebab-case
(e.g. `order-checkout-sequence.mmd`) — next to the source file when one was provided, otherwise
in the current directory.

**Done when:** the write succeeded and you have reported the full path.

## Rules

- One diagram per file. Two diagrams means two files.
- Use the user's own names for actors and steps — no renaming for tidiness.
- Never claim a file was saved unless the write succeeded, and never overwrite an existing `.mmd`
  without the user's yes.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No context and no files | Ask once what to diagram; stop gracefully if no answer. |
| A provided file can't be read | Say which one and why, then offer the fork on what remains. |
| Context too thin to draw without inventing | Recommend grill at the fork, and name the gaps. |
| User chooses draw with gaps open | Draw it; label each gap `[unconfirmed]` rather than guessing. |
| Diagram would exceed ~15 participants or ~40 steps | Offer to split into an overview and detail diagrams. |
| Target `.mmd` already exists | Show it and ask: overwrite, or save under a new name. |
