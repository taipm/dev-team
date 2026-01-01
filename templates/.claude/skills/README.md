# Skills Directory

This directory contains custom Claude Code skills for the dev-team project.

## What are Skills?

Skills are reusable knowledge packages that extend Claude's capabilities with:

- Specialized workflows
- Domain knowledge
- Tool restrictions
- Reference documentation

## Directory Structure

Each skill is a folder containing:

```
skills/
└── my-skill/
    ├── SKILL.md           # Required: Skill definition
    ├── reference.md       # Optional: Detailed docs
    └── examples/          # Optional: Examples
        └── example-1.md
```

## SKILL.md Template

```yaml
---
# Required fields
name: skill-name              # lowercase, hyphens only, max 64 chars
description: "..."            # What it does, max 1024 chars

# Optional fields
allowed-tools: Read, Grep     # Restrict to specific tools
model: sonnet                 # sonnet, opus, haiku
---

# Skill Name

## Purpose
Describe what this skill does.

## Usage
When to invoke this skill.

## Instructions
Step-by-step instructions for Claude.

## References
Link to supporting files:
- [Reference Guide](./reference.md)
- [Examples](./examples/)
```

## Best Practices

1. **Keep SKILL.md Under 500 Lines**
   - Essential info only
   - Link to supporting files for details

2. **Progressive Disclosure**
   - Core instructions in SKILL.md
   - Details in reference files

3. **Clear Triggers**
   - Use specific keywords in description
   - Match user's natural language

4. **Tool Restriction**
   - Use `allowed-tools` for safety
   - Prevent unintended modifications

## Example: PDF Skill

```
skills/
└── pdf-generator/
    ├── SKILL.md
    ├── templates.md
    └── examples/
        ├── report.md
        └── invoice.md
```

**SKILL.md:**

```yaml
---
name: pdf-generator
description: "Generate PDF documents from markdown or data"
allowed-tools: Read, Write, Bash
---

# PDF Generator

Generate professional PDF documents.

## Supported Formats
- Reports
- Invoices
- Documentation

See [templates](./templates.md) for available templates.
```

## Invoking Skills

Skills are automatically loaded when their trigger keywords match user requests.

Use descriptive keywords in your description:

- "Use when generating reports..."
- "Invoke for API documentation..."
- "PROACTIVELY use for code formatting..."
