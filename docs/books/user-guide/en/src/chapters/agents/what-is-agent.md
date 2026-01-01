# What is an Agent?

Detailed explanation of the Agent concept in dev-team.

## Definition

An **Agent** is a specialized AI assistant configured to perform specific tasks. Each agent has:

- **Persona**: Role and communication style
- **Knowledge**: Domain expertise
- **Tools**: Allowed tools to use
- **Memory**: Ability to remember across sessions

## Agent Structure

```
agent-name/
├── agent.md           # Agent definition
├── knowledge/         # Domain knowledge
│   ├── 01-topic.md
│   └── knowledge-index.yaml
└── memory/            # Memory
    ├── context.md
    ├── decisions.md
    └── learnings.md
```

## agent.md File

```yaml
---
name: my-agent
description: |
  Agent description. Use when:
  - Use case 1
  - Use case 2

model: opus
tools: [Read, Write, Edit, Bash, Glob, Grep]
language: en
---

# Agent Content

Instructions for the agent...
```

## Agent vs Plain Claude

| Aspect | Plain Claude | Agent |
|--------|--------------|-------|
| Knowledge | General | Deep domain expertise |
| Context | Starts fresh | Has built-in context |
| Workflow | General | Specific process |
| Memory | None | Memory system |

## When to Use an Agent?

### Use an Agent when:

- Need an expert in a specific domain
- Want consistent process
- Have complex context to maintain
- Work is recurring

### Use Plain Claude when:

- Simple, quick questions
- No special expertise needed
- One-time, non-recurring

## See Also

- [Invoking Agents](./invoking-agents.md)
- [Built-in Agents](./built-in-agents.md)
