# Code Style

Quy ước coding cho dự án dev-team.

---

## JavaScript

### General

- ES6+ syntax
- `const` preferred, `let` when needed, no `var`
- Semicolons required
- Single quotes for strings
- 2-space indentation

### Naming

| Type | Convention | Example |
|------|------------|---------|
| Variables | camelCase | `userName` |
| Functions | camelCase | `getUserName()` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRIES` |
| Classes | PascalCase | `UserService` |
| Files | kebab-case | `user-service.js` |

### Functions

```javascript
// Good
async function installComponent(name, options) {
  const { force = false, path = '.' } = options;
  // ...
}

// Avoid
function install(n, o) {
  var force = o.force || false;
  // ...
}
```

### Error Handling

```javascript
// Good
try {
  await fs.copyFile(src, dest);
} catch (error) {
  console.error(`Failed to copy ${src}: ${error.message}`);
  throw error;
}

// Avoid
fs.copyFile(src, dest); // No error handling
```

---

## Markdown

### Headers

- One H1 per file
- Hierarchical structure (H1 > H2 > H3)
- Blank line before and after headers

### Code Blocks

Always specify language:

````markdown
```javascript
const x = 1;
```

```bash
npm install
```

```yaml
name: agent-name
```
````

### Tables

Use consistent alignment:

```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Value 1  | Value 2  | Value 3  |
```

### Links

- Use relative paths for internal links
- Use descriptive link text

```markdown
[Installation Guide](./getting-started/installation.md)
```

---

## Shell Scripts

### Shebang

```bash
#!/bin/bash
```

### Variables

```bash
# Good
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

# Quote variables
echo "$TOOL_NAME"
```

### Error Handling

```bash
# Exit on error
set -e

# Or check explicitly
if ! command -v jq &> /dev/null; then
    echo "jq is required" >&2
    exit 1
fi
```

### Comments

```bash
# Single line comment

# Multi-line comment
# describing the logic
# of this block
```

---

## YAML

### Agent/Skill Frontmatter

```yaml
---
name: agent-name
description: "Clear description with keywords"
tools: Read, Write, Edit
model: sonnet
---
```

### Indentation

- 2 spaces
- No tabs

### Strings

```yaml
# Use quotes for descriptions
description: "Use for code review"

# No quotes for simple values
name: code-reviewer
model: sonnet
```

---

## JSON

### Formatting

- 2-space indentation
- Trailing newline
- No trailing commas

```json
{
  "name": "@microai.club/dev-team",
  "version": "1.0.0",
  "description": "Dev team configuration"
}
```

---

## Git Commits

### Format

```
<type>: <description>

[optional body]
```

### Types

| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `style` | Formatting (no code change) |
| `refactor` | Code restructuring |
| `test` | Tests |
| `chore` | Maintenance |

### Examples

```
feat: add go-refactor agent
fix: correct hook path in settings
docs: update installation guide
refactor: simplify install command logic
```

---

## File Organization

### Source Files

```
src/
├── commands/           # CLI commands
│   ├── install.js
│   └── list.js
├── utils/              # Shared utilities
│   ├── files.js
│   └── prompts.js
└── index.js            # Main export
```

### Templates

```
templates/
├── .claude/            # Claude config
│   ├── agents/
│   ├── skills/
│   └── commands/
└── .microai/           # MicroAI config
    ├── agents/
    └── hooks/
```

---

## Documentation

### File Names

- kebab-case: `getting-started.md`
- Descriptive: `creating-agents.md` not `agents.md`

### Content Structure

1. Title (H1)
2. Brief description
3. Table of contents (if long)
4. Main content with H2 sections
5. Next steps / Related links

---

## Linting

### ESLint

Project uses ESLint. Run before commit:

```bash
npm run lint
npm run lint:fix
```

### Markdown Lint

Follow markdownlint rules:
- MD001: Heading levels increment by one
- MD012: No multiple consecutive blank lines
- MD022: Headings should be surrounded by blank lines
- MD040: Fenced code blocks should have a language

---

## Tiếp theo

- [Submitting PR](./submitting-pr.md)
- [Development Setup](./development-setup.md)
