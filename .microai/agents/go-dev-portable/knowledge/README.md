# Go Dev Portable - Knowledge

This is a **portable version** of `go-dev-agent` designed to be copied to other projects.

## Knowledge Location

This agent's knowledge files are maintained in the main `go-dev-agent`:

```
.microai/agents/go-dev-agent/knowledge/
```

When deploying to a new project, copy the needed knowledge files from there.

## Why Portable?

- `go-dev-agent` = Main development agent for this project (has learned patterns)
- `go-dev-portable` = Template for deploying to other projects

## Usage

1. Copy this agent directory to your project
2. Copy relevant knowledge files from `go-dev-agent/knowledge/`
3. Customize for your project's specific patterns

## Cleanup Note

Duplicate files were removed on 2026-01-01 as part of Knowledge Forge initiative.
See: `.microai/scripts/AUDIT-REPORT.md`
