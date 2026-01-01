# Quick Reference Card

Tham khảo nhanh các commands và patterns.

## Installation

```bash
npx @microai.club/dev-team@alpha install
```

## Essential Commands

| Command | Purpose |
|---------|---------|
| `/microai:deep-question` | Deep questioning |
| `/microai:deep-thinking` | 7 Titans analysis |
| `/microai:father` | Create agents |

## Session Teams

| Command | Roles |
|---------|-------|
| `/microai:dev-user-session` | Dev + User |
| `/microai:dev-architect-session` | Dev + Architect |
| `/microai:dev-qa-session` | Dev + QA |
| `/microai:dev-security-session` | Dev + Security |
| `/microai:pm-dev-session` | PM + Dev |
| `/microai:dev-algo-session` | Dev + Algo |

## Go Development

| Command | Purpose |
|---------|---------|
| `/microai:go:go-dev` | Implementation |
| `/microai:go:go-refactor` | Refactoring |
| `/microai:go:go-review-linus` | Code review |

## Observer Commands

```
*status      # Current state
*focus X     # Focus agent X
*next        # Next phase
*back        # Previous phase
*summarize   # Summary
*pause       # Pause session
*continue    # Continue
```

## 7 Titans

| Titan | Style |
|-------|-------|
| Socrates | Questions |
| Aristotle | Logic |
| Musk | First Principles |
| Feynman | Explanation |
| Munger | Mental Models |
| Polya | Problem Solving |
| Da Vinci | Creative |

## 5 Phases

```
UNDERSTAND → ANALYZE → EXPLORE → SYNTHESIZE → VALIDATE
```

## Directory Structure

```
.claude/
├── CLAUDE.md
├── settings.json
├── agents/
├── skills/
└── commands/

.microai/
├── agents/
│   └── microai/teams/
├── commands/
├── hooks/
└── kanban/
```

## Agent File Format

```yaml
---
name: agent-name
description: |
  Description
model: sonnet
tools: [Read, Write, Edit, Bash]
---

# Instructions
```

## Team File Format

```yaml
---
name: team-name
type: sequential
lead: lead.md
agents: [lead.md, spec1.md]
phases:
  - name: phase1
    agent: lead
---

# Workflow
```

## Settings.json

```json
{
  "permissions": {
    "allow": ["Bash(git:*)"],
    "deny": ["Read(.env)"]
  }
}
```

## Common Patterns

### Good Context

```
Domain: E-commerce
Problem: [specific issue]
Constraints: [list]
Goal: [measurable]
```

### User Story

```
As a [role]
I want [feature]
So that [benefit]
```

### ADR

```
# ADR-001: [Title]
## Status: Proposed
## Context: [Why]
## Decision: [What]
## Consequences: [Trade-offs]
```

## Troubleshooting

```bash
# Check installation
dev-team doctor

# Fix permissions
chmod +x .microai/hooks/**/*.sh

# Validate JSON
cat .claude/settings.json | jq .
```

## Links

- [Installation](../getting-started/installation.md)
- [Agent Gallery](../agents/gallery.md)
- [Team Overview](../teams/overview.md)
- [Troubleshooting](../workflows/troubleshooting.md)
