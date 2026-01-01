# Mục Lục

[Giới Thiệu](./README.md)

---

# Phần 1: CLI Reference

- [dev-team CLI](./chapters/cli/overview.md)
    - [install](./chapters/cli/install.md)
    - [update](./chapters/cli/update.md)
    - [list](./chapters/cli/list.md)
- [Environment Variables](./chapters/cli/environment.md)
- [Exit Codes](./chapters/cli/exit-codes.md)

---

# Phần 2: Agent Specification

- [Agent Format](./chapters/agent-spec/format.md)
    - [YAML Frontmatter Fields](./chapters/agent-spec/frontmatter.md)
    - [Required Fields](./chapters/agent-spec/required-fields.md)
    - [Optional Fields](./chapters/agent-spec/optional-fields.md)
- [Body Structure](./chapters/agent-spec/body.md)
- [Tools Reference](./chapters/agent-spec/tools.md)
    - [Read](./chapters/agent-spec/tools/read.md)
    - [Write](./chapters/agent-spec/tools/write.md)
    - [Edit](./chapters/agent-spec/tools/edit.md)
    - [Bash](./chapters/agent-spec/tools/bash.md)
    - [Glob](./chapters/agent-spec/tools/glob.md)
    - [Grep](./chapters/agent-spec/tools/grep.md)
    - [WebFetch](./chapters/agent-spec/tools/webfetch.md)
    - [WebSearch](./chapters/agent-spec/tools/websearch.md)
    - [LSP](./chapters/agent-spec/tools/lsp.md)
    - [TodoWrite](./chapters/agent-spec/tools/todowrite.md)
    - [AskUserQuestion](./chapters/agent-spec/tools/askuserquestion.md)
- [Models](./chapters/agent-spec/models.md)
- [Permission Modes](./chapters/agent-spec/permission-modes.md)
- [Validation Rules](./chapters/agent-spec/validation.md)

---

# Phần 3: Skill Specification

- [Skill Format](./chapters/skill-spec/format.md)
- [SKILL.md Structure](./chapters/skill-spec/skill-file.md)
- [Reference Files](./chapters/skill-spec/reference-files.md)
- [Validation Rules](./chapters/skill-spec/validation.md)

---

# Phần 4: Team Specification

- [Team Format](./chapters/team-spec/format.md)
- [Directory Structure](./chapters/team-spec/directory.md)
- [workflow.md](./chapters/team-spec/workflow.md)
- [team-memory/](./chapters/team-spec/team-memory.md)
    - [context.md](./chapters/team-spec/memory/context.md)
    - [decisions.md](./chapters/team-spec/memory/decisions.md)
    - [handoffs.md](./chapters/team-spec/memory/handoffs.md)
    - [blockers.md](./chapters/team-spec/memory/blockers.md)
- [Handoff Protocol](./chapters/team-spec/handoff-protocol.md)
- [Dispatch Protocol](./chapters/team-spec/dispatch-protocol.md)

---

# Phần 5: Command Specification

- [Command Format](./chapters/command-spec/format.md)
- [Naming Conventions](./chapters/command-spec/naming.md)
- [@ References](./chapters/command-spec/at-references.md)

---

# Phần 6: Hooks API

- [Hook Configuration](./chapters/hooks-api/configuration.md)
- [Matchers](./chapters/hooks-api/matchers.md)
- [Hook Types](./chapters/hooks-api/types.md)
    - [PreToolUse](./chapters/hooks-api/pre-tool-use.md)
    - [PostToolUse](./chapters/hooks-api/post-tool-use.md)
    - [UserPromptSubmit](./chapters/hooks-api/user-prompt-submit.md)
    - [SessionStart](./chapters/hooks-api/session-start.md)
- [Input Schema](./chapters/hooks-api/input-schema.md)
- [Exit Codes](./chapters/hooks-api/exit-codes.md)
- [Script Templates](./chapters/hooks-api/templates.md)

---

# Phần 7: Knowledge System

- [knowledge-index.yaml Schema](./chapters/knowledge-api/index-schema.md)
- [Auto-loading Rules](./chapters/knowledge-api/auto-loading.md)
- [Keyword Triggers](./chapters/knowledge-api/keyword-triggers.md)
- [Phase-based Loading](./chapters/knowledge-api/phase-loading.md)

---

# Phần 8: Memory System

- [Memory Files](./chapters/memory-api/files.md)
- [context.md Format](./chapters/memory-api/context-format.md)
- [decisions.md Format](./chapters/memory-api/decisions-format.md)
- [learnings.md Format](./chapters/memory-api/learnings-format.md)
- [Checkpoint Format](./chapters/memory-api/checkpoint-format.md)

---

# Phần 9: Configuration

- [settings.json](./chapters/config/settings-json.md)
    - [permissions](./chapters/config/permissions.md)
    - [hooks](./chapters/config/hooks.md)
    - [env](./chapters/config/env.md)
- [settings.local.json](./chapters/config/settings-local.md)
- [CLAUDE.md](./chapters/config/claude-md.md)

---

# Phần 10: MicroAI Adapter Specification

- [Architecture](./chapters/adapter-spec/architecture.md)
- [Compliance Levels](./chapters/adapter-spec/compliance-levels.md)
    - [Level 1: Minimal](./chapters/adapter-spec/level-1.md)
    - [Level 2: Standard](./chapters/adapter-spec/level-2.md)
    - [Level 3: Full](./chapters/adapter-spec/level-3.md)
- [Tool Abstraction](./chapters/adapter-spec/tool-abstraction.md)
- [Permission Model](./chapters/adapter-spec/permission-model.md)
- [Implementation Guide](./chapters/adapter-spec/implementation.md)
- [Compliance Checklist](./chapters/adapter-spec/compliance-checklist.md)

---

# Phần 11: Built-in Agents Reference

- [father-agent](./chapters/built-in/father-agent.md)
- [npm-agent](./chapters/built-in/npm-agent.md)
- [go-dev-portable](./chapters/built-in/go-dev.md)
- [go-refactor-portable](./chapters/built-in/go-refactor.md)
- [deep-question-agent](./chapters/built-in/deep-question.md)

---

# Phần 12: Built-in Teams Reference

- [deep-thinking-team](./chapters/built-in-teams/deep-thinking.md)
    - [Agents](./chapters/built-in-teams/deep-thinking/agents.md)
    - [Workflow](./chapters/built-in-teams/deep-thinking/workflow.md)
- [dev-user](./chapters/built-in-teams/dev-user.md)
- [dev-architect](./chapters/built-in-teams/dev-architect.md)
- [dev-qa](./chapters/built-in-teams/dev-qa.md)
- [dev-security](./chapters/built-in-teams/dev-security.md)
- [pm-dev](./chapters/built-in-teams/pm-dev.md)
- [dev-algo](./chapters/built-in-teams/dev-algo.md)
- [go-team](./chapters/built-in-teams/go-team.md)
- [mining-team](./chapters/built-in-teams/mining-team.md)
- [deep-research](./chapters/built-in-teams/deep-research.md)
- [project-team](./chapters/built-in-teams/project-team.md)

---

# Phụ Lục

- [YAML Schema Reference](./chapters/appendix/yaml-schema.md)
- [Error Messages](./chapters/appendix/error-messages.md)
- [Changelog](./chapters/appendix/changelog.md)
