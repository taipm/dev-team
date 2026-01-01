# Reference Manual - @microai.club/dev-team

Welcome to the **Reference Manual** for the dev-team framework!

## Introduction

This book provides complete technical documentation for the dev-team framework, including:

- **CLI Reference**: CLI commands and options
- **Specifications**: Formats and schemas for agents, teams, skills, commands
- **APIs**: Hooks, Knowledge, Memory systems
- **Configuration**: settings.json, CLAUDE.md
- **Built-in Components**: Available Agents and Teams

## How to Use

This book is designed for **reference lookup**, not for reading from start to finish.

### Quick Lookup

| You want to know about... | See section... |
|---------------------------|----------------|
| CLI commands | [Part 1: CLI Reference](./chapters/cli/overview.md) |
| Agent format | [Part 2: Agent Specification](./chapters/agent-spec/format.md) |
| Available tools | [Tools Reference](./chapters/agent-spec/tools.md) |
| Team structure | [Part 4: Team Specification](./chapters/team-spec/format.md) |
| Hooks setup | [Part 6: Hooks API](./chapters/hooks-api/configuration.md) |
| settings.json | [Part 9: Configuration](./chapters/config/settings-json.md) |
| Adapter specification | [Part 10: Adapter Spec](./chapters/adapter-spec/architecture.md) |
| Built-in agents | [Part 11: Agents](./chapters/built-in/father-agent.md) |
| Built-in teams | [Part 12: Teams](./chapters/built-in-teams/deep-thinking.md) |

## Conventions

### Code Blocks

```yaml
# YAML configuration example
name: example
```

```bash
# Shell command example
dev-team install
```

### Tables

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Unique identifier |

### Markers

- **Required**: Must be present
- **Optional**: Can be omitted
- **Default**: Default value if not specified
- **Deprecated**: Should not be used, will be removed

## Links

- **User Guide**: [Usage guide](../../user-guide/en/src/README.md)
- **Developer Guide**: [Development guide](../../developer-guide/en/src/README.md)
- **GitHub**: [github.com/taipm/dev-team](https://github.com/taipm/dev-team)

## Version

This documentation is for version: **v1.0.0-alpha.2**

See [Changelog](./chapters/appendix/changelog.md) for version history.

---

Start looking up with [CLI Reference](./chapters/cli/overview.md).
