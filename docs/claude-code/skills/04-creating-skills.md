# Tạo Skill

> Hướng dẫn step-by-step tạo skill từ đầu đến hoàn thiện.

---

## Quy trình tổng quan

```
┌─────────────────────────────────────────────────────────────────┐
│                    SKILL CREATION FLOW                           │
├─────────────────────────────────────────────────────────────────┤
│  1. Plan → 2. Structure → 3. Write → 4. Test → 5. Refine        │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Lên kế hoạch

### Xác định scope

Trả lời các câu hỏi:

| Câu hỏi | Ví dụ trả lời |
|---------|---------------|
| Skill làm gì? | "Format commit messages" |
| Khi nào trigger? | "Khi user viết commit" |
| Cần knowledge gì? | "Conventional commits spec" |
| Output là gì? | "Formatted commit message" |

### Checklist trước khi tạo

```
□ Có thật sự cần skill mới? (Kiểm tra existing skills)
□ Scope đủ focused? (Không quá rộng)
□ Reusable? (Dùng được nhiều lần)
□ Không cần persona? (Nếu cần → dùng Agent)
```

---

## Step 2: Tạo cấu trúc

### Tạo folder

```bash
mkdir -p .claude/skills/commit-helper
```

### Tạo files cơ bản

```bash
touch .claude/skills/commit-helper/SKILL.md
```

### Cấu trúc hoàn chỉnh (nếu cần)

```bash
mkdir -p .claude/skills/commit-helper/examples
touch .claude/skills/commit-helper/conventions.md
```

---

## Step 3: Viết SKILL.md

### Template cơ bản

```yaml
---
name: {skill-name}
description: "{Mô tả khi nào dùng skill này}"
---

# {Skill Name}

## Purpose
{Mô tả ngắn gọn skill làm gì}

## Guidelines
- {Guideline 1}
- {Guideline 2}
- {Guideline 3}

## Quick Reference
| {Column 1} | {Column 2} |
|------------|------------|
| {Data 1}   | {Data 2}   |

## Examples

### Good Example
```
{Good example}
```

### Bad Example
```
{Bad example}
```
```

### Ví dụ thực tế: Commit Helper

```yaml
---
name: commit-helper
description: "Help write commit messages following conventional commits"
---

# Commit Helper

## Purpose
Giúp viết commit messages theo chuẩn Conventional Commits.

## Message Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

## Types

| Type | Dùng khi |
|------|----------|
| `feat` | Tính năng mới |
| `fix` | Sửa bug |
| `docs` | Chỉ thay đổi documentation |
| `style` | Format, không thay đổi logic |
| `refactor` | Refactor code |
| `test` | Thêm/sửa tests |
| `chore` | Maintenance tasks |

## Rules

1. Subject line ≤ 50 ký tự
2. Không kết thúc subject bằng dấu chấm
3. Dùng imperative mood ("add" không phải "added")
4. Body wrap ở 72 ký tự
5. Body giải thích WHY, không phải WHAT

## Examples

### Good
```
feat(auth): add JWT token refresh

Implement automatic token refresh when access token expires.
This prevents users from being logged out unexpectedly.

Closes #123
```

### Bad
```
fix bug
```

```
updated the authentication module to add a new feature for refreshing tokens automatically when they expire so users don't get logged out
```
```

---

## Step 4: Test skill

### Test manual

```
1. Restart Claude Code session
2. Yêu cầu task liên quan đến skill
3. Kiểm tra skill có được load không
4. Verify output đúng guidelines
```

### Test scenarios

| Scenario | Expected |
|----------|----------|
| Keyword trigger | Skill auto-load khi mention keywords |
| Direct request | `/commit-helper` loads skill |
| Output format | Follows guidelines trong skill |

### Troubleshooting

| Vấn đề | Nguyên nhân | Giải pháp |
|--------|-------------|-----------|
| Skill không load | SKILL.md missing | Kiểm tra file tồn tại |
| Frontmatter error | YAML syntax | Kiểm tra `---` delimiters |
| Name mismatch | name ≠ folder | Sửa cho khớp |
| Keywords không trigger | Description vague | Thêm clear keywords |

---

## Step 5: Refine

### Iterate based on usage

1. **Collect feedback** - Note những gì chưa work
2. **Add examples** - Thêm ví dụ cho cases mới
3. **Clarify guidelines** - Làm rõ rules ambiguous
4. **Split if needed** - Tách file nếu quá lớn

### Checklist hoàn thiện

```
□ SKILL.md < 500 lines
□ Description có clear keywords
□ Có ví dụ good/bad
□ Quick reference table
□ Links to references (nếu có)
□ Tested với real tasks
```

---

## Templates sẵn dùng

### Template: Utility Skill

```yaml
---
name: {utility-name}
description: "{Action} for {purpose}"
---

# {Utility Name}

## Usage
{How to use}

## Options
| Option | Description |
|--------|-------------|
| {opt1} | {desc1} |

## Examples
{Examples}
```

### Template: Convention Skill

```yaml
---
name: {convention-name}
description: "Follow {convention} when {action}"
---

# {Convention Name}

## Rules
1. {Rule 1}
2. {Rule 2}

## Format
```
{format template}
```

## Examples

### Good
{good example}

### Bad
{bad example}
```

### Template: Generator Skill

```yaml
---
name: {generator-name}
description: "Generate {output} from {input}"
allowed-tools: Read, Write
---

# {Generator Name}

## Input
{Input format}

## Output
{Output format}

## Process
1. {Step 1}
2. {Step 2}

## Templates
See [templates/](./templates/)
```

---

## Common Mistakes to Avoid

| Mistake | Problem | Fix |
|---------|---------|-----|
| Too broad scope | Skill làm quá nhiều | Chia nhỏ thành multiple skills |
| No examples | Khó hiểu cách dùng | Thêm good/bad examples |
| Vague description | Không auto-trigger | Keywords rõ ràng |
| Too much content | Slow to load/read | Split vào reference files |
| No testing | Bugs không phát hiện | Test với real tasks |

---

## Tiếp theo

- [Patterns nâng cao](./05-advanced-patterns.md)
- [Examples Gallery](./06-examples-gallery.md)
