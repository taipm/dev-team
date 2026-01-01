# Commands Directory

This directory contains custom slash commands for Claude Code.

## What are Commands?

Commands are shortcuts that expand into full prompts when invoked with `/command-name`.

## Creating a Command

Create a `.md` file with the command name:

```
commands/
├── review.md      # Invoked as /review
├── test.md        # Invoked as /test
└── deploy.md      # Invoked as /deploy
```

## Command File Format

Commands are markdown files with optional YAML frontmatter:

```yaml
---
description: "Short description for /help"
allowed-tools: Read, Grep, Bash    # Optional: restrict tools
---

[Command prompt content]

You can use $ARGUMENTS to access user input after the command.
```

## Example Commands

### /review - Code Review

```yaml
---
description: "Review code changes"
---

Review the current git diff for:
1. Code quality issues
2. Potential bugs
3. Security concerns
4. Performance problems

Focus on: $ARGUMENTS
```

### /test - Run Tests

```yaml
---
description: "Run project tests"
---

Run the test suite and report results.

If tests fail, analyze the failures and suggest fixes.

Test scope: $ARGUMENTS
```

### /deploy - Deployment Check

```yaml
---
description: "Pre-deployment checklist"
allowed-tools: Read, Grep, Bash
---

Perform pre-deployment checks:
1. Run all tests
2. Check for uncommitted changes
3. Verify build succeeds
4. Review recent commits

Environment: $ARGUMENTS
```

## Variables

- `$ARGUMENTS` - Everything after the command name
- Example: `/review src/` -> `$ARGUMENTS = "src/"`

## Best Practices

1. **Keep Commands Focused**
   - One command = one action
   - Clear, predictable behavior

2. **Use Descriptive Names**
   - `/review` not `/r`
   - `/generate-docs` not `/gd`

3. **Provide Defaults**
   - Commands should work without arguments
   - Arguments refine behavior

4. **Document Usage**
   - Include description in frontmatter
   - Shows in `/help` output

## Common Commands to Create

| Command | Purpose |
|---------|---------|
| `/review` | Code review |
| `/test` | Run tests |
| `/docs` | Generate documentation |
| `/fix` | Fix linting/type errors |
| `/commit` | Create commit with message |
| `/pr` | Create pull request |
