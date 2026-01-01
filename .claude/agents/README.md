# Agents Directory

This directory contains custom Claude Code agents for the dev-team project.

## Quick Start

Create a new agent by adding a `.md` file with YAML frontmatter:

```markdown
---
name: my-agent
description: "Use this agent when [specific trigger]"
tools: Read, Grep, Edit, Bash
model: sonnet
---

[Your agent's system prompt here]
```

## Agent Template

```yaml
---
# Required fields
name: agent-name              # lowercase, hyphens only (kebab-case)
description: "..."            # When to use this agent (include trigger keywords)

# Optional fields
tools: Tool1, Tool2           # Comma-separated list of allowed tools
model: sonnet                 # sonnet (default), opus, haiku
permissionMode: default       # default, acceptEdits, bypassPermissions, plan
skills: skill1, skill2        # Auto-load specific skills
---

# Agent Name

## Role
Describe the agent's primary role and responsibilities.

## Guidelines
- Guideline 1
- Guideline 2

## Output Format
Describe expected output format.
```

## Available Tools

Common tools you can specify:

- `Read` - Read files
- `Grep` - Search file contents
- `Glob` - Find files by pattern
- `Edit` - Edit files
- `Write` - Create/overwrite files
- `Bash` - Run shell commands
- `WebFetch` - Fetch web content
- `WebSearch` - Search the web
- `Task` - Launch sub-agents

## Best Practices

1. **Focused Design**: One agent = one responsibility
2. **Clear Description**: Include trigger keywords for auto-invocation
3. **Tool Restriction**: Only allow necessary tools
4. **Vietnamese Support**: Use bilingual descriptions if needed

## Examples

### Code Reviewer Agent

```yaml
---
name: code-reviewer
description: "PROACTIVELY use for code review, security analysis, and quality assessment"
tools: Read, Grep, Glob
model: sonnet
---

You are a code review specialist...
```

### Documentation Agent

```yaml
---
name: doc-writer
description: "Use when writing or updating documentation"
tools: Read, Write, Glob
model: haiku
---

You are a documentation specialist...
```

## File Naming

- Use kebab-case: `my-agent.md`
- Be descriptive: `python-debugger.md`, `api-designer.md`
