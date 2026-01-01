# Patterns Nâng cao

> Best practices, composition patterns, và anti-patterns khi làm việc với Skills.

---

## Skill Composition

### Pattern 1: Skill Chain

Nhiều skills phối hợp theo sequence:

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ api-designer│ →  │ db-schema   │ →  │ test-writer │
└─────────────┘    └─────────────┘    └─────────────┘
     Design            Model             Tests
```

**Cách implement:**

```markdown
# Backend Feature Workflow

1. Design API endpoints
   → Load: api-designer skill

2. Design database schema
   → Load: db-schema skill

3. Write tests
   → Load: test-writer skill
```

### Pattern 2: Skill Stack

Nhiều skills load cùng lúc cho một task:

```
┌─────────────────────────────────────┐
│              Task                    │
├─────────────────────────────────────┤
│  ┌───────────┐  ┌───────────┐       │
│  │conventions│  │formatting │       │
│  └───────────┘  └───────────┘       │
│  ┌───────────┐  ┌───────────┐       │
│  │ security  │  │ testing   │       │
│  └───────────┘  └───────────┘       │
└─────────────────────────────────────┘
```

**Khi nào dùng:**
- Task cần knowledge từ nhiều domains
- Các skills bổ sung cho nhau

### Pattern 3: Skill Inheritance

Skill con extends skill cha:

```
base-api-design/
├── SKILL.md           # Base conventions
└── rest/
    └── SKILL.md       # REST-specific
└── graphql/
    └── SKILL.md       # GraphQL-specific
```

---

## Agent + Skill Integration

### Pattern: Agent với Skill Dependencies

```yaml
# agent.md
---
name: backend-dev
skills:
  - api-designer
  - db-schema
  - commit-helper
---

# Backend Developer Agent

## Workflow

### Feature Development
1. Design API (load: api-designer)
2. Design Schema (load: db-schema)
3. Implement Code
4. Commit (load: commit-helper)
```

### Pattern: Skill as Agent Helper

Agent gọi skill cho specific tasks:

```markdown
# Code Review Agent

## Review Process

1. Static Analysis
   → Agent handles

2. Security Check
   → Load: security-checker skill

3. Performance Check
   → Load: perf-analyzer skill

4. Generate Report
   → Agent handles
```

### Pattern: Skill Delegation

Agent delegate một phần workflow cho skill:

```
┌────────────────────────────────────────┐
│           Main Agent                    │
│                                         │
│  1. Analyze requirements (agent)        │
│  2. Design solution (agent)             │
│  3. Format output ─────→ format-skill   │
│  4. Validate ──────────→ validate-skill │
│  5. Report (agent)                      │
└────────────────────────────────────────┘
```

---

## Dynamic Loading Strategies

### Strategy 1: Keyword-based

Description chứa keywords để auto-trigger:

```yaml
description: "Design RESTful APIs, create endpoints, API documentation"
```

Keywords: `API`, `endpoints`, `REST`

### Strategy 2: Context-based

Load skill dựa trên file types đang làm việc:

```markdown
When working with:
- *.go files → Load: go-conventions skill
- *.py files → Load: python-conventions skill
- *.sql files → Load: db-schema skill
```

### Strategy 3: Explicit Request

User request trực tiếp:

```
User: "Use the api-designer skill for this"
Claude: [Loads api-designer skill]
```

### Strategy 4: Agent Directive

Agent specifies khi nào load:

```markdown
## Workflow Step 3

At this point, ALWAYS load the security-checker skill
before proceeding to implementation.
```

---

## Best Practices

### 1. Keep Skills Focused

```
✅ Good: One skill = One responsibility
   - api-designer: Design APIs
   - db-schema: Design database
   - test-writer: Write tests

❌ Bad: One skill does everything
   - full-stack-helper: Design, implement, test, deploy
```

### 2. Clear Trigger Keywords

```yaml
# ✅ Good
description: "Design RESTful APIs following OpenAPI specification"

# ❌ Bad
description: "Help with backend stuff"
```

### 3. Provide Examples

Mỗi skill nên có:
- 2-3 good examples
- 1-2 bad examples (với explanation)

### 4. Quick Reference Tables

```markdown
## Quick Reference

| Type | Format | Example |
|------|--------|---------|
| feat | `feat(scope): msg` | `feat(auth): add login` |
| fix  | `fix(scope): msg`  | `fix(api): handle null` |
```

### 5. Size Management

| Metric | Target | Action nếu vượt |
|--------|--------|-----------------|
| SKILL.md | < 300 lines | Split vào references |
| Total files | < 5 | Merge related content |
| Description | < 100 chars | Tóm gọn hơn |

---

## Anti-Patterns to Avoid

### 1. Kitchen Sink Skill

```
❌ Problem: Skill làm quá nhiều thứ
   everything-skill/
   └── SKILL.md (1000+ lines, 20+ topics)

✅ Fix: Chia thành focused skills
   api-design/
   db-design/
   testing/
```

### 2. Vague Description

```yaml
# ❌ Bad
description: "General helper"

# ✅ Good
description: "Format commit messages following Conventional Commits"
```

### 3. No Examples

```markdown
# ❌ Bad
## Usage
Just use it correctly.

# ✅ Good
## Examples

### Good
```
feat(auth): add OAuth2 support
```

### Bad
```
fixed stuff
```
```

### 4. Deep Nesting

```
❌ Bad
skills/
└── development/
    └── backend/
        └── api/
            └── rest/
                └── SKILL.md

✅ Good
skills/
└── rest-api-design/
    └── SKILL.md
```

### 5. Circular Dependencies

```
❌ Bad
skill-a references skill-b
skill-b references skill-a

✅ Good
Base skills independent
Composed skills reference base
```

### 6. Missing Validation

```markdown
# ❌ Bad
Use this format for commits.

# ✅ Good
## Validation Rules
- Subject ≤ 50 chars
- No trailing period
- Imperative mood

## Common Mistakes
| Wrong | Correct |
|-------|---------|
| "Fixed bug" | "fix: handle null pointer" |
```

---

## Performance Tips

### 1. Lazy Loading

Chỉ load skill khi thực sự cần:

```markdown
## Workflow
1. Analyze (no skill needed)
2. Design → THEN load api-designer
3. Implement (no skill needed)
4. Commit → THEN load commit-helper
```

### 2. Minimal References

```yaml
# ❌ Bad: Load everything
See all these files:
- conventions.md
- examples-1.md through examples-10.md
- templates-1.md through templates-5.md

# ✅ Good: Load what's needed
## Quick Start
[Basic example here]

## Need More?
- [Full conventions](./conventions.md)
```

### 3. Cache-Friendly Structure

Giữ SKILL.md stable, update reference files:

```
skill/
├── SKILL.md           # Stable - cached
├── conventions.md     # Updates frequently
└── examples/          # Updates frequently
```

---

## Tiếp theo

- [Examples Gallery](./06-examples-gallery.md)
- [Trở về tổng quan](./README.md)
