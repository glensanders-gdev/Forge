---
name: mermaid-templates
description: Diagram skeletons and syntax rules for the mermaid skill — System Interaction, Journey, decision flowchart and state diagram. Read when picking a type or drawing a diagram.
origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Mermaid Templates

Skeletons to adapt, not fill in. Replace every bracketed placeholder with names from the context.

---

## System Interaction — `sequenceDiagram`

What talks to what. Solid arrows are calls, dashed arrows are responses.

```mermaid
sequenceDiagram
    participant User
    participant SystemA as [System A]
    participant SystemB as [System B]
    User->>SystemA: [action]
    SystemA->>SystemB: [data or call]
    SystemB-->>SystemA: [response]
    SystemA-->>User: [outcome]
```

---

## Journey — `flowchart LR`

From where things are to where they should be. One node per state or intervention.

```mermaid
flowchart LR
    Current["Current state:<br/>[the problem today]"]
    Step1["[intervention or step]"]
    Step2["[intervention or step]"]
    Target["Target state:<br/>[the measurable outcome]"]
    Current -->|"[trigger]"| Step1
    Step1 --> Step2
    Step2 -->|"[result]"| Target
```

---

## Decisions and Exceptions — `flowchart TD`

```mermaid
flowchart TD
    A["[start]"] --> B{"[condition?]"}
    B -- Yes --> C["[happy path]"]
    B -- No --> D["[fallback or exception]"]
    C --> E["[end]"]
    D --> E
```

---

## Lifecycle — `stateDiagram-v2`

```mermaid
stateDiagram-v2
    [*] --> Draft
    Draft --> Review: [submitted]
    Review --> Draft: [changes requested]
    Review --> Done: [approved]
    Done --> [*]
```

---

## Syntax Rules

Check each before presenting a diagram — these are the common render failures.

- Quote any node label or edge label containing `( ) [ ] { } : ; , #` or a keyword: `A["Label (x)"]`.
- In `sequenceDiagram`, give multi-word or symbol-bearing participants an alias:
  `participant API as Payments API`. Never use `end` as a bare participant or node id.
- Node ids are single tokens (`Step1`, `orderSvc`); the readable text goes in the label.
- Line breaks inside a label use `<br/>`, not `\n`.
- Mark unconfirmed elements in the label text: `C["Notify customer [unconfirmed]"]`.
- The saved `.mmd` holds raw Mermaid only: no ```` ``` ```` fence.
