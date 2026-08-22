Invoke the save-state skill. Save current session state immediately — stream handoff first, register row second, kanban.md third, DEVLOG last. No confirmation prompts and no questions: where the stream cannot be resolved it writes docs/handoffs/unassigned-[timestamp].md rather than guessing which stream to overwrite. Optional argument: the stream slug. Use to pause cleanly at any pipeline stage, or when context window exhaustion is imminent.

Skill: global/.claude/skills/save-state/SKILL.md
