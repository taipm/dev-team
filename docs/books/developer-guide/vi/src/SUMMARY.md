# Mục Lục

[Giới Thiệu](./README.md)

---

# Phần 1: Kiến Trúc Tổng Quan

- [Kiến Trúc MicroAI](./chapters/architecture/overview.md)
    - [Mô Hình 3 Lớp](./chapters/architecture/three-layer-model.md)
    - [Core vs Adapter](./chapters/architecture/core-vs-adapter.md)
    - [Portable Agents](./chapters/architecture/portable-agents.md)
- [Thư Mục .microai/](./chapters/architecture/microai-directory.md)
- [Thư Mục .claude/](./chapters/architecture/claude-directory.md)

---

# Phần 2: Tạo Agent

- [Agent Cơ Bản](./chapters/creating-agents/basic-agent.md)
    - [Cấu Trúc File agent.md](./chapters/creating-agents/agent-file-structure.md)
    - [YAML Frontmatter](./chapters/creating-agents/yaml-frontmatter.md)
    - [Body Content](./chapters/creating-agents/body-content.md)
- [Agent Nâng Cao](./chapters/creating-agents/advanced-agent.md)
    - [Knowledge Base](./chapters/creating-agents/knowledge-base.md)
    - [Memory System](./chapters/creating-agents/memory-system.md)
    - [Activation Protocol](./chapters/creating-agents/activation-protocol.md)
    - [Menu Commands](./chapters/creating-agents/menu-commands.md)
- [Agent Patterns](./chapters/creating-agents/patterns.md)
    - [Specialist Pattern](./chapters/creating-agents/patterns/specialist.md)
    - [Review Pattern](./chapters/creating-agents/patterns/review.md)
    - [Meta Pattern](./chapters/creating-agents/patterns/meta.md)
- [Testing Agents](./chapters/creating-agents/testing.md)

---

# Phần 3: Tạo Team

- [Team Cơ Bản](./chapters/creating-teams/basic-team.md)
    - [Cấu Trúc Thư Mục Team](./chapters/creating-teams/team-structure.md)
    - [workflow.md](./chapters/creating-teams/workflow-file.md)
    - [team-memory/](./chapters/creating-teams/team-memory.md)
- [Coordination Patterns](./chapters/creating-teams/coordination-patterns.md)
    - [Sequential Pipeline](./chapters/creating-teams/patterns/sequential.md)
    - [Parallel Fan-out](./chapters/creating-teams/patterns/parallel.md)
    - [Expert Consultation](./chapters/creating-teams/patterns/consultation.md)
- [Handoff Protocol](./chapters/creating-teams/handoff-protocol.md)
- [Observer Integration](./chapters/creating-teams/observer-integration.md)
- [Session Teams](./chapters/creating-teams/session-teams.md)
    - [Turn-based Dialogue](./chapters/creating-teams/turn-based.md)
    - [Agent Roles](./chapters/creating-teams/agent-roles.md)
    - [Templates](./chapters/creating-teams/templates.md)

---

# Phần 4: Tạo Skills

- [Skill Cơ Bản](./chapters/creating-skills/basic-skill.md)
    - [Cấu Trúc Thư Mục Skill](./chapters/creating-skills/skill-structure.md)
    - [SKILL.md](./chapters/creating-skills/skill-file.md)
    - [Reference Files](./chapters/creating-skills/reference-files.md)
- [Skill Nâng Cao](./chapters/creating-skills/advanced-skill.md)
    - [Templates](./chapters/creating-skills/templates.md)
    - [Examples](./chapters/creating-skills/examples.md)

---

# Phần 5: Tạo Commands

- [Slash Commands](./chapters/creating-commands/slash-commands.md)
    - [Cấu Trúc File Command](./chapters/creating-commands/command-structure.md)
    - [Linking to Agents](./chapters/creating-commands/linking-agents.md)
- [Naming Conventions](./chapters/creating-commands/naming.md)

---

# Phần 6: Hooks System

- [Hooks Overview](./chapters/hooks/overview.md)
- [Hook Types](./chapters/hooks/types.md)
    - [PreToolUse](./chapters/hooks/pre-tool-use.md)
    - [PostToolUse](./chapters/hooks/post-tool-use.md)
    - [UserPromptSubmit](./chapters/hooks/user-prompt-submit.md)
    - [SessionStart](./chapters/hooks/session-start.md)
- [Hook Scripts](./chapters/hooks/scripts.md)
    - [Input/Output](./chapters/hooks/input-output.md)
    - [Blocking Hooks](./chapters/hooks/blocking.md)
    - [Logging Hooks](./chapters/hooks/logging.md)
- [Security Hooks](./chapters/hooks/security.md)

---

# Phần 7: Knowledge System

- [Knowledge Base Design](./chapters/knowledge/design.md)
- [knowledge-index.yaml](./chapters/knowledge/index-file.md)
- [Auto-loading Patterns](./chapters/knowledge/auto-loading.md)
- [Learning System](./chapters/knowledge/learning.md)

---

# Phần 8: Memory System

- [Memory Architecture](./chapters/memory/architecture.md)
- [context.md](./chapters/memory/context.md)
- [decisions.md](./chapters/memory/decisions.md)
- [learnings.md](./chapters/memory/learnings.md)
- [Session Persistence](./chapters/memory/persistence.md)
- [Checkpointing](./chapters/memory/checkpointing.md)

---

# Phần 9: Best Practices

- [Agent Design Principles](./chapters/best-practices/agent-design.md)
- [Team Orchestration](./chapters/best-practices/team-orchestration.md)
- [Error Handling](./chapters/best-practices/error-handling.md)
- [Testing Strategies](./chapters/best-practices/testing.md)
- [Documentation](./chapters/best-practices/documentation.md)

---

# Phần 10: Case Studies

- [Xây Dựng Agent Từ Đầu](./chapters/case-studies/building-agent.md)
- [Xây Dựng Team Từ Đầu](./chapters/case-studies/building-team.md)
- [Migrate Agent Sang MicroAI Format](./chapters/case-studies/migration.md)

---

# Phụ Lục

- [Templates Repository](./chapters/appendix/templates.md)
- [Anti-Patterns](./chapters/appendix/anti-patterns.md)
- [Checklist for Release](./chapters/appendix/release-checklist.md)
