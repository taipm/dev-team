# Skill Template

> Template chuẩn cho SKILL.md file trong MicroAI system.

## SKILL.md Structure

```yaml
---
name: skill-name                    # Required: kebab-case, match folder name
description: |                      # Required: Keyword-rich, when to trigger
  When Claude needs to [action] for [use case].
  Triggers: keyword1, keyword2, keyword3
description_vi: |                   # Required: Vietnamese translation
  Khi Claude cần [hành động] cho [use case].
license: apache-2.0                 # Required: apache-2.0 | proprietary
allowed-tools: Read, Write, Bash    # Optional: Restrict available tools
model: sonnet                       # Optional: Model specification
version: "1.0.0"                    # Optional: Semantic versioning
---

# Skill Name

> One-line description of what this skill does.

## Quick Start

[Essential code example or workflow - MOST IMPORTANT SECTION]

## Core Capabilities

### Capability 1
[Instructions and examples]

### Capability 2
[Instructions and examples]

## Common Patterns

### Pattern A
[Code or workflow example]

### Pattern B
[Code or workflow example]

## References
- [Detailed docs](./references/detailed.md)
- [API reference](./references/api.md)
- [Examples](./examples/)

## Best Practices

### Do's
- ...

### Don'ts
- ...
```

## Field Reference

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Skill identifier, kebab-case |
| `description` | Yes | When to trigger, keyword-rich |
| `description_vi` | Yes | Vietnamese translation |
| `license` | Yes | apache-2.0 or proprietary |
| `allowed-tools` | No | Comma-separated tool list |
| `model` | No | Preferred model (sonnet/opus/haiku) |
| `version` | No | Semantic version string |

## Size Guidelines

- **SKILL.md**: < 500 lines recommended
- **Total skill folder**: < 50KB ideal
- **References**: Use for content > 200 lines
- **Scripts**: Only for deterministic operations

## Folder Structure

```
skill-name/
├── SKILL.md              # Required - Main definition
├── LICENSE.txt           # Recommended - License file
├── references/           # Optional - Extended docs
│   ├── detailed.md
│   └── api.md
├── scripts/              # Optional - Executable code
│   └── helper.py
├── examples/             # Optional - Example files
│   └── example-1.md
└── templates/            # Optional - Output templates
    └── output-template.md
```
