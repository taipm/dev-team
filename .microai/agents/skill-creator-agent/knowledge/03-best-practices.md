# Skill Best Practices

> Guidelines cho việc tạo skills chất lượng cao trong MicroAI.

## Core Principles

### 1. Context Window is Public Good
- Mỗi token trong SKILL.md đều có cost
- Tối ưu cho việc đọc nhanh, không phải đọc kỹ
- Dùng progressive disclosure: core → details → references

### 2. Claude is Already Smart
- Không cần giải thích concepts cơ bản
- Focus vào specifics: syntax, patterns, edge cases
- Provide examples, not explanations

### 3. Match Degrees of Freedom
- Task đơn giản → instructions ngắn
- Task phức tạp → workflow rõ ràng
- Task sáng tạo → principles, not rules

## Do's

### Content
- [ ] Viết description keyword-rich để trigger chính xác
- [ ] Bắt đầu với Quick Start section
- [ ] Include concrete code examples
- [ ] Use progressive disclosure (core → detailed → reference)
- [ ] Bilingual content (English + Vietnamese)

### Structure
- [ ] Keep SKILL.md under 500 lines
- [ ] Match folder name với skill name (kebab-case)
- [ ] Put large content trong references/
- [ ] Organize scripts trong scripts/
- [ ] Include LICENSE.txt

### Quality
- [ ] Test skill với real use cases
- [ ] Verify trigger keywords work
- [ ] Check token count (< 10K ideal)
- [ ] Review với fresh eyes

## Don'ts

### Content
- [ ] Giải thích concepts mà Claude đã biết
- [ ] Duplicate content từ knowledge files
- [ ] Viết README, CHANGELOG (không cần thiết)
- [ ] Include vague descriptions ("API stuff")

### Structure
- [ ] Put all content trong SKILL.md
- [ ] Create deep nested folders (max 2 levels)
- [ ] Mix scripts với documentation
- [ ] Forget bilingual support

### Quality
- [ ] Skip validation before registering
- [ ] Use overly broad trigger keywords
- [ ] Ignore token budget
- [ ] Create duplicate skills

## Content Patterns

### Pattern 1: Quick Start + References
```markdown
# Skill Name
## Quick Start
[Essential example - 20 lines max]

## Core Features
[Brief overview with links to references]

## References
- [Detailed Guide](./references/guide.md)
```

### Pattern 2: Decision Tree
```markdown
# Skill Name
## What do you need?

### Create new [thing]
→ Use Template A

### Modify existing [thing]
→ Use Template B

### Analyze [thing]
→ Use Analysis workflow
```

### Pattern 3: Multi-Stage Workflow
```markdown
# Skill Name
## Stage 1: Discovery
[Instructions]

## Stage 2: Execution
[Instructions]

## Stage 3: Validation
[Instructions]
```

## Token Budget Guidelines

| Component | Recommended | Maximum |
|-----------|-------------|---------|
| SKILL.md body | 3K tokens | 8K tokens |
| Single reference | 2K tokens | 5K tokens |
| Total skill | 10K tokens | 20K tokens |
| Description | 50 words | 100 words |

## Quality Checklist

### Before Creating
- [ ] Is this skill distinct from existing skills?
- [ ] Can this be part of an existing skill instead?
- [ ] Is the scope focused enough?

### After Creating
- [ ] Does description trigger correctly?
- [ ] Are examples working?
- [ ] Is content < 500 lines?
- [ ] Is bilingual support complete?
- [ ] Is registry entry added?

### Before Sharing
- [ ] LICENSE.txt included?
- [ ] No sensitive data in files?
- [ ] Dependencies documented?
- [ ] Version number set?
