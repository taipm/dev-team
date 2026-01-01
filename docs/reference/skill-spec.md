# Skill Specification

Đặc tả kỹ thuật cho Claude Code skills.

---

## Skill vs Agent

| Aspect | Agent | Skill |
|--------|-------|-------|
| Purpose | Define behavior | Provide knowledge |
| Structure | Single file | Folder with files |
| Trigger | Automatic/manual | Loaded by agents |
| Scope | Task execution | Reference material |

---

## Folder Structure

```
.claude/skills/
└── skill-name/
    ├── SKILL.md        # Required - main definition
    ├── reference.md    # Optional - detailed docs
    ├── examples/       # Optional - examples folder
    │   └── example.md
    └── templates/      # Optional - templates
        └── template.md
```

---

## SKILL.md Format

```yaml
---
name: skill-name
description: "When to use this skill"
allowed-tools: Read, Write
---

# Skill Content

Markdown body with skill knowledge.
```

---

## YAML Frontmatter Fields

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Unique identifier (kebab-case) |
| `description` | string | When to use this skill |

### Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `allowed-tools` | string | - | Tools allowed when skill is active |

---

## Field Details

### name

Unique identifier. Should match folder name.

```yaml
name: api-designer      # Good
name: API Designer      # Bad - not kebab-case
```

### description

Mô tả khi nào skill được load.

```yaml
# Good
description: "Design RESTful APIs following best practices"
description: "Generate PDF documents from data"

# Bad
description: "API stuff"
```

### allowed-tools

Restrict tools khi skill active.

```yaml
allowed-tools: Read, Write        # File operations only
allowed-tools: Read, Write, Bash  # Include commands
```

---

## Body Content

SKILL.md body chứa knowledge chính. Có thể reference các files khác.

### Recommended Structure

```markdown
# Skill Name

## Purpose
What this skill provides.

## Conventions
- Convention 1
- Convention 2

## Guidelines
- Guideline 1
- Guideline 2

## References
- [Detailed Reference](./reference.md)
- [Examples](./examples/)
```

### Size Limit

- SKILL.md nên dưới **500 lines**
- Dùng reference files cho nội dung chi tiết

---

## Reference Files

### Naming Conventions

| Pattern | Purpose |
|---------|---------|
| `reference.md` | Main reference documentation |
| `conventions.md` | Coding/design conventions |
| `examples/*.md` | Example files |
| `templates/*.md` | Template files |

### Linking

Dùng relative paths trong SKILL.md:

```markdown
## References
- [API Conventions](./conventions.md)
- [REST Example](./examples/rest.md)
```

---

## Examples

### API Designer Skill

```
.claude/skills/
└── api-designer/
    ├── SKILL.md
    ├── conventions.md
    └── examples/
        ├── rest-example.md
        └── graphql-example.md
```

**SKILL.md:**

```yaml
---
name: api-designer
description: "Design RESTful APIs following best practices"
allowed-tools: Read, Write
---

# API Designer

## Purpose
Design consistent, well-documented APIs.

## Conventions
- Use plural nouns for resources
- Use HTTP methods correctly
- Include proper error responses

## References
- [API Conventions](./conventions.md)
- [REST Example](./examples/rest-example.md)
```

### PDF Generator Skill

```
.claude/skills/
└── pdf-generator/
    ├── SKILL.md
    └── templates/
        ├── report.md
        └── invoice.md
```

**SKILL.md:**

```yaml
---
name: pdf-generator
description: "Generate PDF documents from data"
allowed-tools: Read, Write, Bash
---

# PDF Generator

## Capabilities
- Generate reports
- Create invoices
- Export documentation

## Templates
- [Report Template](./templates/report.md)
- [Invoice Template](./templates/invoice.md)

## Usage
1. Prepare data in JSON
2. Select template
3. Generate PDF
```

### Database Design Skill

```
.claude/skills/
└── db-design/
    ├── SKILL.md
    ├── normalization.md
    ├── indexing.md
    └── migrations.md
```

---

## Usage

### In Agents

```yaml
---
name: backend-dev
skills: api-designer, db-design
---
```

### Trigger Keywords

Claude loads skills when conversation matches description keywords.

### Manual Request

```
Use the api-designer skill to design this endpoint.
```

---

## Validation

| Check | Error if |
|-------|----------|
| SKILL.md | Missing in folder |
| Frontmatter | Missing `---` delimiters |
| name | Missing or doesn't match folder |
| description | Missing |
| References | Broken links |

---

## Best Practices

### Do

- Keep SKILL.md under 500 lines
- Use reference files for details
- Include examples
- Clear description with keywords
- Match name with folder name

### Don't

- Put everything in SKILL.md
- Use vague descriptions
- Create deep nested folders
- Forget to update references

---

## Tiếp theo

- [Agent Specification](./agent-spec.md)
- [Hooks API](./hooks-api.md)
- [Tạo Skill](../guides/creating-skills.md)
