# Invoking Agents

Guide to activating agents.

## Method 1: Slash Command (Recommended)

```
/microai:agent-name
```

Examples:
```
/microai:npm
/microai:deep-question
/microai:go:go-dev
```

## Method 2: Automatic via Task Tool

When you request a task, Claude Code may automatically select the appropriate agent via the Task tool.

Example:
```
Refactor handler.go following best practices
```

Claude Code may automatically activate `go-refactor-portable` agent.

## Method 3: Manual Activation

Ask Claude to read and execute an agent:

```
Read and execute the agent at @.microai/agents/npm-agent/agent.md
```

## Naming Conventions

| Pattern | Example | Description |
|---------|---------|-------------|
| `/microai:name` | `/microai:npm` | Single agent |
| `/microai:group:name` | `/microai:go:go-dev` | Agent in group |

## Confirming Activation

When an agent activates successfully:

1. You'll see a greeting from the agent
2. Agent introduces its role
3. Agent asks about your needs

Example output:

```
🎯 Deep Question Agent is ready!

I use 7 thinking methods to ask deep questions.
What problem would you like to explore today?
```

## Tips

### Choose the Right Agent

- Read description in command list
- Test with a small problem first
- If unsure, use `/help`

### Provide Context

```
I'm working on a microservices project in Go.
Need to refactor processOrder function for concurrent handling.
```

## See Also

- [Built-in Agents](./built-in-agents.md)
- [Agent Gallery](./gallery.md)
