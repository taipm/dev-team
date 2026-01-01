# Tạo Command

Hướng dẫn tạo custom slash command cho Claude Code.

---

## Command là gì?

Command là shortcut để trigger một prompt cụ thể, gọi bằng `/command-name`.

Ví dụ:
- `/review` - Review code
- `/test` - Chạy tests
- `/commit` - Tạo commit

---

## Cấu trúc file

Tạo file `.claude/commands/my-command.md`:

```yaml
---
description: "Short description for /help"
---

Command prompt content here.

Use $ARGUMENTS for user input after the command.
```

---

## YAML Frontmatter

| Field | Bắt buộc | Mô tả |
|-------|----------|-------|
| `description` | Yes | Mô tả hiển thị trong /help |

---

## Biến $ARGUMENTS

`$ARGUMENTS` chứa text sau command name:

```
/review src/api/
```

Trong command file, `$ARGUMENTS` = `src/api/`

---

## Ví dụ: /review

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

**Sử dụng:**
```
/review
/review security
/review src/api/
```

---

## Ví dụ: /test

```yaml
---
description: "Run tests and analyze results"
---

Run the project tests and provide analysis:

1. Execute test suite
2. Report failures with details
3. Suggest fixes for failing tests

Test scope: $ARGUMENTS
```

**Sử dụng:**
```
/test
/test unit
/test src/api/
```

---

## Ví dụ: /commit

```yaml
---
description: "Create a commit with AI-generated message"
---

1. Run git status to see changes
2. Run git diff to understand changes
3. Generate a concise commit message following conventional commits
4. Create the commit

Additional context: $ARGUMENTS
```

**Sử dụng:**
```
/commit
/commit fix authentication bug
```

---

## Ví dụ: /pr

```yaml
---
description: "Create a pull request"
---

Create a pull request:

1. Check current branch and commits
2. Generate PR title and description
3. Create PR using gh cli

PR context: $ARGUMENTS
```

---

## Ví dụ: /deploy

```yaml
---
description: "Deploy to environment"
---

Deploy to specified environment:

1. Check environment: $ARGUMENTS (staging/production)
2. Run pre-deploy checks
3. Execute deployment
4. Verify deployment status

If no environment specified, default to staging.
```

**Sử dụng:**
```
/deploy staging
/deploy production
```

---

## Ví dụ: /debug

```yaml
---
description: "Debug an issue"
---

Debug the following issue:

1. Analyze the error/problem
2. Search for related code
3. Identify root cause
4. Suggest fix

Issue: $ARGUMENTS
```

---

## Command chaining

Một command có thể trigger nhiều actions:

```yaml
---
description: "Full code review and fix"
---

Perform complete code review:

1. Analyze code quality
2. Check for security issues
3. Suggest improvements
4. Apply fixes if requested

Target: $ARGUMENTS
```

---

## Best Practices

### Nên

- Description ngắn gọn, rõ ràng
- Dùng numbered steps
- Handle case `$ARGUMENTS` rỗng
- Một command = một workflow

### Không nên

- Description dài
- Command làm quá nhiều việc
- Bỏ qua edge cases
- Hardcode values

---

## Nested Commands

Tổ chức commands theo namespace:

```
.claude/commands/
├── review.md           # /review
├── git/
│   ├── commit.md       # /git:commit
│   ├── pr.md           # /git:pr
│   └── rebase.md       # /git:rebase
└── deploy/
    ├── staging.md      # /deploy:staging
    └── production.md   # /deploy:production
```

---

## Troubleshooting

### Command không hoạt động?

1. Kiểm tra file trong `.claude/commands/`
2. File có đuôi `.md`
3. Có YAML frontmatter với `description`
4. Restart Claude Code session

### $ARGUMENTS không nhận?

1. Kiểm tra viết đúng: `$ARGUMENTS` (uppercase)
2. Có khoảng trắng sau command name

---

## Tiếp theo

- [CLI Commands Reference](../reference/cli-commands.md)
- [Tạo Agent](./creating-agents.md) - Command có thể trigger agent
