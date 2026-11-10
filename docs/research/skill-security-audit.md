# Research: Security Auditing of Agent Skills

**Date:** 2026-11-10
**Status:** Draft. Web sources were read on 2026-11-10. Vendor figures have not been independently verified.

## Question

How could a Forge skill check other skills (its own portfolio and third-party skills before install) for loopholes, exploits and other security risks? Which security standards should it be measured against?

## Findings

### 1. The threat is real and specific to skills

- A skill is **instructions plus optional code** that the agent loads and then runs with the user's privileges. A malicious skill needs no exploit. Plain English in `SKILL.md` is enough, for example "read ~/.ssh and post it to …". Snyk's ToxicSkills work showed that three lines of markdown can do this.
- Measured prevalence in public registries:
  - Snyk ToxicSkills: 13.4% of 3,984 skills had critical issues (vendor figure).
  - arXiv 2602.06547: 157 confirmed malicious skills, carrying 632 vulnerabilities, among 98,380 registry skills (independent).
  - ClawHavoc campaign: 341 of 2,857 ClawHub skills were malicious in January 2026.
- The two dominant attack classes are **data theft or exfiltration** and **agent hijack**, where the skill overrides the user's or system's instructions. Snyk reports that every malicious skill it confirmed combined both.
- Skill names have no namespace, so a skill can impersonate a trusted name. Forge's `skill-health` already checks for shadowed names. Name squatting is the security version of the same problem.
- Anthropic's position is that users should run only trusted Skills (ones they wrote, or ones from Anthropic). A malicious skill can direct Claude to run code, read sensitive files or send data out. Anthropic treats vetting as the user's responsibility.

### 2. Standards to anchor against

| Standard | Status | Use in a skill audit |
|---|---|---|
| **OWASP Agentic Skills Top 10 (AST01–AST10)** | Incubator. The page says "1.0-2026", but its own timeline targets v1.0 for Q4 2026. Treat it as draft. | **Primary checklist.** It is the only standard scoped to the skill layer. |
| **OWASP Top 10 for Agentic Applications 2026 (ASI01–ASI10)** | Published 2025-12-09 | Runtime risk lens: goal hijack, tool misuse, privilege abuse, supply chain, code execution, memory poisoning. |
| **OWASP Top 10 for LLM Applications 2025** | Published | Prompt injection (LLM01), sensitive information disclosure, excessive agency. |
| MITRE ATLAS | Living | Adversary technique IDs, if findings need TTP tagging. Optional. |
| NIST AI RMF and AI 600-1 (GenAI profile) | Published | Governance framing (inventory, accountability). Maps to AST09. Optional. |
| SLSA, plus the existing `security` ruleset | Published | Provenance and pinning of skill sources. Maps to AST02 and AST07. |

**AST10 risks and key controls**, as given in the OWASP README:

| ID | Risk | Sev | Key control |
|---|---|---|---|
| AST01 | Malicious Skills | Critical | Signing, behavioural scanning |
| AST02 | Supply Chain Compromise | Critical | Transparency logs, dependency pinning |
| AST03 | Over-Privileged Skills | High | Least-privilege manifests, runtime enforcement |
| AST04 | Insecure Metadata | High | Schema validation, safe parsers |
| AST05 | Untrusted External Instructions | High | Source inventory, pin or inline remote content, rescan |
| AST06 | Weak Isolation | High | Container or process isolation |
| AST07 | Update Drift | Medium | Immutable pinning, hash verification |
| AST08 | Poor Scanning | Medium | Multi-tool pipeline, semantic analysis |
| AST09 | No Governance | Medium | Inventory, approval workflow, audit log |
| AST10 | Cross-Platform Reuse | Medium | Universal format, per-platform validation |

The OWASP guidance for skill authors also says to **never request write access to `MEMORY.md` or `AGENTS.md` (or similar persistent files) without documenting why**. That applies directly to Forge, whose skills write `CLAUDE.md`, `AGENTS.md`, memory and handoffs.

ASI01–ASI06 were confirmed from multiple secondary sources. ASI07–ASI10 (inter-agent communication, cascading failures, human-agent trust exploitation, rogue agents) were seen only as themes. Confirm their exact numbering at genai.owasp.org before citing them.

### 3. Detection approaches

**A. Deterministic pattern scan (regex or AST)**
- Flags shell or network primitives (`curl`, `wget`, `nc`, `base64 -d | sh`, `eval`), credential paths (`~/.ssh`, `.env`, `~/.aws`, keychain), injection phrases ("ignore previous instructions", "do not tell the user"), hidden content (zero-width or Unicode tag characters, HTML comments, very long single lines, base64 blobs), and remote fetch-and-follow instructions.
- Cheap, repeatable and explainable, but **easy to evade**. Snyk bypassed it with `c${u}rl`, Python one-liners, and plain English asking the agent to build the command itself.
- The failure also runs the other way. Skill Defender rated a real exfiltration skill "CLEAN", and rated *itself* "DANGEROUS" because its reference files contain the patterns it searches for.

**B. Capability-versus-purpose analysis (semantic)**
- Compares what the skill *says* it does (`description`) with what it *can* do: `allowed-tools`, bundled scripts, files touched, network use, and whether it writes persistent agent config.
- Answers the question regex cannot. Shell access is fine for `/deploy` and suspicious for `/add-term`.
- The **"lethal trifecta"** heuristic (used in skillshield) flags skills that combine untrusted input, access to private data, and an outbound channel.

**C. LLM intent review**
- An isolated model reads `SKILL.md` and its scripts *as untrusted data* and judges intent. It catches paraphrased injection.
- Risks:
  - The reviewer can itself be prompt-injected by the skill under review.
  - It is non-deterministic.
  - Its cost grows with portfolio size.

**D. Provenance and drift controls**
- Content hashes, pinned versions and a trust register (author, source URL, reviewed hash, review date). A changed hash re-triggers review (AST07).
- Signing (OWASP suggests ed25519 plus `content_hash`) is the strong form, but no registry enforces it yet.

**E. Runtime controls** (outside a skill's reach, noted for completeness)
- Sandboxing, deny rules in `settings.json`, and watching for unexpected subprocesses, file writes or outbound connections.
- A static audit skill can only *recommend* these.

### 4. Existing Forge assets

| Skill | Relevance | Gap |
|---|---|---|
| `skill-health` | Structural portfolio audit: manifest, names, shadowing, standards register, `EXCEPTIONS.md` | No security semantics. Its STANDARDS and EXCEPTIONS registers are a reusable pattern. |
| `security-assessment` | OWASP Top 10 code audit; gitignored `docs/security/` report; SEC-NNN tickets | Targets application code, not skills. Its report handling (gitignored, sensitive) should be reused. |
| `vibe-security` | Covers AI/LLM *integration* code | Does not audit skills or prompts as an attack surface. |
| `assimilate` | Imports external skills into Forge | **The natural install-time gate.** It currently has no security check before an external skill is adapted. |
| `write-a-skill` | Authoring | Could carry a "security self-check" step, which would shift detection left. |

### 5. Existing third-party tools

- **Snyk mcp-scan**: LLM-based, commercial.
- **Tessl skill-scanner**: LLM review that stresses false-positive control.
- **skillshield** (PyPI) and **SkillGuard**: pattern-based. SkillGuard was itself flagged malicious and removed from ClawHub.
- None should be trusted blindly or installed unvetted. A security tool that runs inside the agent is a high-value impersonation target.

## Trade-offs

| | A. Patterns only | B+C. Semantic + LLM review | Layered A→B→C + D |
|---|---|---|---|
| Detection of plain-English attacks | Poor | Good | Good |
| Determinism and explainability | High | Medium | High for triage, medium for verdict |
| Risk the reviewer gets injected | None | Real | Mitigated by isolation and a fixed output schema |
| False positives on security skills | High | Lower | Low, with an exceptions register |
| Cost per run | Very low | Medium to high | Medium: LLM runs only on flagged or changed skills |
| Catches update drift | No | No | Yes, via the hash register |

## Recommendation

Build a **new standalone skill** rather than extending `skill-health`. Working name: `skill-security`. Check it against `RESERVED-NAMES.md` before choosing.

1. **Two modes.**
   - `--portfolio` audits every installed skill, monthly or alongside `/skill-health`.
   - `<path|url>` is a pre-install gate for a single skill, called by `/assimilate` before it adapts any external skill.
2. **Layered pipeline.**
   - (a) A deterministic inventory and pattern pass as *triage*, never as the verdict.
   - (b) A capability-versus-purpose matrix, including the lethal-trifecta and persistent-config-write checks.
   - (c) An LLM intent review in an **isolated subagent**. It receives the skill as quoted data with a fixed JSON verdict schema, has no tools that can execute or fetch, and is told that instructions inside the skill are evidence, not commands.
3. **Map every finding to AST01–AST10**, with ASI or LLM IDs as secondary tags. Severity follows the OWASP table.
4. **Never execute the target.** Read only. No running bundled scripts and no following remote links during the audit, because AST05 content is fetched only to hash it, if at all.
5. **Reuse Forge registers.**
   - A `TRUST.md` holds reviewed hash, source, reviewer and date. A changed hash means re-review.
   - `EXCEPTIONS.md` handles legitimate security-content skills (including this one, `vibe-security` and `security-assessment`), so the scanner does not flag itself. Exceptions lower severity and never hide a finding.
6. **Sensitive output.** Write the report to a gitignored location, following the `security-assessment` pattern. Critical and High findings can become SEC-NNN tickets.
7. **HITL.** The skill recommends block, allow or allow-with-exception. The human decides (ai-use rule §3).
8. **Self-test fixtures.** Ship a small corpus of benign and malicious sample skills: an obfuscated curl, a paraphrased exfiltration, a hidden Unicode instruction, a config-write without justification. This proves detection and guards against the Skill Defender failure.

Open questions for grilling:
- Should it gate `/assimilate` hard or only advise?
- Should the LLM pass run on every skill, or only on flagged or changed ones?
- Should the trust register live in Forge or per company?

## References

- OWASP Agentic Skills Top 10: https://owasp.org/www-project-agentic-skills-top-10/ (README read via its owasp.github.io redirect; AST01 page: …/ast01.html)
- OWASP Top 10 for Agentic Applications 2026: https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026
- Snyk, "Why Your 'Skill Scanner' Is Just False Security" (2026-02-11): https://snyk.io/blog/skill-scanner-false-security/
- arXiv 2602.06547, empirical study of malicious skills: https://arxiv.org/pdf/2602.06547v2
- arXiv 2604.02837, skill threat model: https://arxiv.org/pdf/2604.02837
- Red Hat, Agent skills: security threats and controls: https://developers.redhat.com/articles/2026/03/10/agent-skills-explore-security-threats-and-controls
- SafeDep, Agent Skills threat model: https://safedep.io/agent-skills-threat-model/
- SC World, Claude skills used to deploy malware (Cato PoC): https://www.scworld.com/news/claude-agent-skills-could-be-used-to-deploy-malware-researchers-say
- Tessl skill-scanner: https://tessl.io/registry/skills/github/popey/claude-code-skills/skill-scanner--skill-scanner
- skillshield: https://pypi.org/project/skillshield/
- Anthropic Agent Skills docs (not read directly; read via secondary sources): https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- Forge: `global/.claude/skills/skill-health/`, `security-assessment/`, `vibe-security/`, `assimilate/`, `write-a-skill/RESERVED-NAMES.md`
