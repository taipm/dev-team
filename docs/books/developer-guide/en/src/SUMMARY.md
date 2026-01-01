# Summary

[Introduction](./README.md)

---

# Part 1: Architecture Overview

- [MicroAI Architecture](./chapters/architecture/overview.md)
    - [3-Layer Model](./chapters/architecture/three-layer-model.md)
    - [Core vs Adapter](./chapters/architecture/core-vs-adapter.md)
    - [Portable Agents](./chapters/architecture/portable-agents.md)
- [The .microai/ Directory](./chapters/architecture/microai-directory.md)
- [The .claude/ Directory](./chapters/architecture/claude-directory.md)

---

# Part 2: Creating Agents

- [Basic Agents](./chapters/creating-agents/basic-agent.md)
    - [agent.md File Structure](./chapters/creating-agents/agent-file-structure.md)
    - [YAML Frontmatter](./chapters/creating-agents/yaml-frontmatter.md)
    - [Body Content](./chapters/creating-agents/body-content.md)
- [Advanced Agents](./chapters/creating-agents/advanced-agent.md)
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

# Part 3: Creating Teams

- [Basic Teams](./chapters/creating-teams/basic-team.md)
    - [Team Directory Structure](./chapters/creating-teams/team-structure.md)
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

# Part 4: Creating Skills

- [Basic Skills](./chapters/creating-skills/basic-skill.md)
    - [Skill Directory Structure](./chapters/creating-skills/skill-structure.md)
    - [SKILL.md](./chapters/creating-skills/skill-file.md)
    - [Reference Files](./chapters/creating-skills/reference-files.md)
- [Advanced Skills](./chapters/creating-skills/advanced-skill.md)
    - [Templates](./chapters/creating-skills/templates.md)
    - [Examples](./chapters/creating-skills/examples.md)

---

# Part 5: Creating Commands

- [Slash Commands](./chapters/creating-commands/slash-commands.md)
    - [Command File Structure](./chapters/creating-commands/command-structure.md)
    - [Linking to Agents](./chapters/creating-commands/linking-agents.md)
- [Naming Conventions](./chapters/creating-commands/naming.md)

---

# Part 6: Hooks System

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

# Part 7: Knowledge System

- [Knowledge Base Design](./chapters/knowledge/design.md)
- [knowledge-index.yaml](./chapters/knowledge/index-file.md)
- [Auto-loading Patterns](./chapters/knowledge/auto-loading.md)
- [Learning System](./chapters/knowledge/learning.md)

---

# Part 8: Memory System

- [Memory Architecture](./chapters/memory/architecture.md)
- [context.md](./chapters/memory/context.md)
- [decisions.md](./chapters/memory/decisions.md)
- [learnings.md](./chapters/memory/learnings.md)
- [Session Persistence](./chapters/memory/persistence.md)
- [Checkpointing](./chapters/memory/checkpointing.md)

---

# Part 9: Best Practices

- [Agent Design Principles](./chapters/best-practices/agent-design.md)
- [Team Orchestration](./chapters/best-practices/team-orchestration.md)
- [Error Handling](./chapters/best-practices/error-handling.md)
- [Testing Strategies](./chapters/best-practices/testing.md)
- [Documentation](./chapters/best-practices/documentation.md)

---

# Part 10: Case Studies

- [Building an Agent from Scratch](./chapters/case-studies/building-agent.md)
- [Building a Team from Scratch](./chapters/case-studies/building-team.md)
- [Migrating to MicroAI Format](./chapters/case-studies/migration.md)

---

# Appendix

- [Templates Repository](./chapters/appendix/templates.md)
- [Anti-Patterns](./chapters/appendix/anti-patterns.md)
- [Release Checklist](./chapters/appendix/release-checklist.md)
