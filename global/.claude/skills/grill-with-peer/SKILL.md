---
name: grill-with-peer
category: pipeline
version: 1.0.0
description: Stress-test a plan or design with an independent peer model, then reconcile its critique with the host model. Use when the user asks for cross-model review, model diversity, a second AI opinion, /grill-with-peer, or /grill-with-codex.
---

# Grill With Peer

Use Codex as an independent peer reviewer while Claude remains the facilitator. The peer challenges the plan; it does not take over the session.

## Process

1. Define the review target, decision to make, constraints, and desired output from the conversation and project files.
2. Show the user a concise summary of the context that would be sent to Codex. Ask for explicit consent before invoking the external model.
3. Check that a non-interactive Codex CLI is available and authenticated. Inspect `codex exec --help` before choosing flags; prefer standard input or a temporary redacted brief.
4. Send Codex a self-contained challenge brief asking for assumptions, weak points, failure modes, missing evidence, viable alternatives, trade-offs, a recommendation, and unresolved questions.
5. Keep Claude's analysis independent until the peer response is received.
6. Reconcile the two views. Separate agreements, disagreements, and new issues. Resolve factual disputes from project evidence where possible.
7. Present a final recommendation and identify which conclusions came from Claude, Codex, or both.

## Rules

- Never send project context to another provider or process without explicit user consent.
- Redact secrets, credentials, personal data, and unrelated proprietary material.
- Use non-interactive peer execution only. Never open a nested interactive agent session.
- Report the peer command, model when known, and context boundaries.
- Never claim an independent peer review occurred if the peer could not be invoked.
- If Codex is unavailable, consent is denied, or invocation fails, explain the limitation and offer `/critic` as the single-model fallback.

## Output

Report the context sent, each model's view, agreements, disagreements, final recommendation, and unresolved questions.
