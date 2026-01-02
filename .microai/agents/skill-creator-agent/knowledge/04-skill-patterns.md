# Skill Content Patterns

> Các patterns phổ biến khi thiết kế skill content.

## Pattern Categories

### 1. Tool-Focused Skills
Dành cho skills wrap một tool hoặc library cụ thể.

```markdown
# Tool Name Skill

## Quick Start
\`\`\`python
from tool import function
result = function(input)
\`\`\`

## Common Operations

### Operation A
\`\`\`python
# Code example
\`\`\`

### Operation B
\`\`\`python
# Code example
\`\`\`

## Error Handling
[Common errors and solutions]

## References
- [API Reference](./references/api.md)
```

**Examples**: pdf, docx, xlsx skills

---

### 2. Workflow Skills
Dành cho skills guide qua multi-step process.

```markdown
# Workflow Skill

## Overview
[Brief description of the workflow]

## Stage 1: [Name]
### Goal
[What this stage achieves]

### Steps
1. Step one
2. Step two

### Output
[Expected deliverable]

## Stage 2: [Name]
[Same structure]

## Stage 3: [Name]
[Same structure]

## Transitions
- Stage 1 → Stage 2: When [condition]
- Stage 2 → Stage 3: When [condition]
```

**Examples**: doc-coauthoring, mcp-builder skills

---

### 3. Design/Creative Skills
Dành cho skills cần aesthetic judgment.

```markdown
# Design Skill

## Design Philosophy
[Core principles and values]

## Visual Elements

### Typography
[Guidance on fonts and text]

### Color
[Color palette principles]

### Layout
[Spatial organization]

## Anti-Patterns
[What to avoid - CRITICAL for creative skills]

## Examples Gallery
[Links to example outputs]
```

**Examples**: frontend-design, canvas-design skills

---

### 4. Analysis Skills
Dành cho skills evaluate hoặc analyze content.

```markdown
# Analysis Skill

## Analysis Framework

### Dimension 1: [Name]
- Criteria A
- Criteria B
- Scoring: [How to evaluate]

### Dimension 2: [Name]
[Same structure]

## Output Format
\`\`\`
## Analysis Report
### Summary
[Key findings]

### Detailed Analysis
#### Dimension 1
[Findings]

### Recommendations
[Action items]
\`\`\`

## Common Issues
[Patterns to watch for]
```

**Examples**: code-review, security-audit skills

---

### 5. Template Skills
Dành cho skills generate content từ templates.

```markdown
# Template Skill

## Available Templates

### Template A: [Name]
**Use when**: [Trigger condition]

\`\`\`
[Template content with placeholders]
\`\`\`

**Variables**:
- `{{var1}}`: Description
- `{{var2}}`: Description

### Template B: [Name]
[Same structure]

## Customization
[How to modify templates]

## Examples
[Filled template examples]
```

**Examples**: internal-comms, slack-gif-creator skills

---

### 6. Integration Skills
Dành cho skills connect với external systems.

```markdown
# Integration Skill

## Prerequisites
- [ ] API key configured
- [ ] Dependencies installed

## Connection Setup
\`\`\`bash
# Setup commands
\`\`\`

## Operations

### Read Data
\`\`\`python
# Example
\`\`\`

### Write Data
\`\`\`python
# Example
\`\`\`

## Error Handling
[Common errors and solutions]

## Rate Limits
[API constraints to be aware of]
```

**Examples**: mcp-builder, webapp-testing skills

---

## Pattern Selection Guide

| Use Case | Recommended Pattern |
|----------|---------------------|
| Wrap a library/tool | Tool-Focused |
| Multi-step process | Workflow |
| Creative output | Design/Creative |
| Evaluate content | Analysis |
| Generate from templates | Template |
| Connect to APIs | Integration |

## Combining Patterns

Skills có thể combine multiple patterns:

```markdown
# Complex Skill

## Quick Start (Tool-Focused)
[Immediate value]

## Workflow (Workflow Pattern)
### Stage 1...

## Templates (Template Pattern)
### Template A...

## Quality Check (Analysis Pattern)
### Checklist...
```
