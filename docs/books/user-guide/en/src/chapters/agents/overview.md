# Agent Overview

Introduction to the Agent system in the dev-team framework.

## What is an Agent?

An **Agent** is a specialized AI assistant configured to perform specific tasks. Each agent has:

- **Persona**: Role and communication style
- **Knowledge**: Domain expertise
- **Tools**: Allowed tools to use
- **Memory**: Ability to remember across sessions

## Why Use Agents?

### Comparison with Plain Claude

| Aspect | Plain Claude | Agent |
|--------|--------------|-------|
| Knowledge | General | Deep domain expertise |
| Context | Starts fresh | Has built-in context |
| Workflow | General | Specific process |
| Memory | None | Memory system |

### Benefits of Agents

1. **Specialization**: Agent deeply understands specific domain
2. **Consistency**: Same agent always works the same way
3. **Time Saving**: No need to explain context each time
4. **Extensibility**: Create new agents for new needs

## Agent Types

### 1. Specialist Agents

Domain experts:

- **npm-agent**: NPM package management
- **go-dev-portable**: Go development
- **go-refactor-portable**: Go refactoring

### 2. Meta Agents

Agents that can create other agents:

- **father-agent**: Creates agents, commands, knowledge

### 3. Thinking Agents

Agents that assist with thinking:

- **deep-question-agent**: Deep questioning

## Agent Structure

Each agent is defined by a markdown file with YAML frontmatter:

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

### agent.md File

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

## How to Invoke Agents

### Via Slash Command

```
/microai:npm
```

### Via Task Tool (in Claude Code)

Agents can be automatically invoked via the Task tool when appropriate.

### Manual Activation

In some cases, you can ask Claude to read and execute an agent:

```
Read and follow the agent at @.microai/agents/npm-agent/agent.md
```

## Built-in Agents

| Agent | Description | Command |
|-------|-------------|---------|
| father-agent | Create new agents | `/microai:father` |
| npm-agent | NPM management | `/microai:npm` |
| go-dev-portable | Go development | Automatic |
| go-refactor-portable | Go refactoring | `/microai:go:go-refactor` |
| deep-question-agent | Deep questioning | `/microai:deep-question` |

## Best Practices

### 1. Choose the Right Agent

- Check description and use cases
- Test with a small problem first

### 2. Provide Clear Context

```
I'm working on a Go microservices project.
Need to refactor the processOrder function to handle concurrent requests.
```

### 3. State Your Goals

```
Goal: Reduce response time to under 100ms
Constraint: Don't change the API signature
```

### 4. Use Memory

Agents remember decisions and learnings. If you need to reset:

```
Please ignore previous context and start fresh.
```

## Next Steps

- [What is an Agent? (detailed)](./what-is-agent.md)
- [Invoking Agents](./invoking-agents.md)
- [Built-in Agents](./built-in-agents.md)
