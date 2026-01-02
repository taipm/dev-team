# Skill Review Checklist

> Checklist đánh giá chất lượng skill trước khi publish.

## Scoring Categories

### 1. Structure (25 points)

| Item | Points | Check |
|------|--------|-------|
| SKILL.md exists | 5 | [ ] |
| Folder name matches skill name | 5 | [ ] |
| Uses kebab-case naming | 3 | [ ] |
| Proper folder hierarchy | 5 | [ ] |
| LICENSE.txt present | 4 | [ ] |
| No unnecessary files | 3 | [ ] |

---

### 2. Metadata (20 points)

| Item | Points | Check |
|------|--------|-------|
| `name` field present | 4 | [ ] |
| `description` keyword-rich | 5 | [ ] |
| `description_vi` present | 4 | [ ] |
| `license` specified | 4 | [ ] |
| Optional fields used appropriately | 3 | [ ] |

---

### 3. Content Quality (30 points)

| Item | Points | Check |
|------|--------|-------|
| Quick Start section first | 5 | [ ] |
| Concrete code examples | 8 | [ ] |
| Progressive disclosure | 5 | [ ] |
| Clear section organization | 5 | [ ] |
| No redundant content | 4 | [ ] |
| Bilingual completeness | 3 | [ ] |

---

### 4. Size & Performance (15 points)

| Item | Points | Check |
|------|--------|-------|
| SKILL.md < 500 lines | 5 | [ ] |
| Total folder < 50KB | 4 | [ ] |
| Large content in references | 3 | [ ] |
| Scripts separated properly | 3 | [ ] |

---

### 5. Usability (10 points)

| Item | Points | Check |
|------|--------|-------|
| Description triggers correctly | 4 | [ ] |
| Examples are runnable | 3 | [ ] |
| Error handling documented | 3 | [ ] |

---

## Grade Scale

| Score | Grade | Status |
|-------|-------|--------|
| 90-100 | A | Excellent - Ready to publish |
| 80-89 | B | Good - Minor improvements needed |
| 70-79 | C | Fair - Several issues to address |
| 60-69 | D | Poor - Significant rework required |
| 0-59 | F | Failing - Does not meet standards |

---

## Common Issues & Fixes

### Issue: Vague description
```yaml
# Bad
description: "Helps with documents"

# Good
description: |
  When Claude needs to create, edit, or analyze
  Word documents (.docx). Triggers: word document,
  docx, microsoft word, document editing
```

### Issue: Missing Quick Start
```markdown
# Bad - starts with theory
## Introduction
Documents are important...

# Good - starts with action
## Quick Start
\`\`\`python
from docx import Document
doc = Document()
doc.add_paragraph("Hello")
doc.save("output.docx")
\`\`\`
```

### Issue: Content too long
```markdown
# Bad - everything in SKILL.md
[500+ lines of content]

# Good - use references
## API Reference
See [detailed API docs](./references/api.md)
```

### Issue: No bilingual support
```yaml
# Bad
description: "Creates presentations"

# Good
description: "Creates presentations"
description_vi: "Tạo bài thuyết trình"
```

---

## Review Report Template

```markdown
# Skill Review: [skill-name]

## Summary
- **Score**: XX/100
- **Grade**: X
- **Status**: [Ready | Needs Work | Rejected]

## Scores by Category
| Category | Score | Max |
|----------|-------|-----|
| Structure | X | 25 |
| Metadata | X | 20 |
| Content Quality | X | 30 |
| Size & Performance | X | 15 |
| Usability | X | 10 |

## Issues Found
1. [Issue description]
   - **Severity**: High/Medium/Low
   - **Fix**: [Suggested fix]

2. [Issue description]
   - **Severity**: High/Medium/Low
   - **Fix**: [Suggested fix]

## Recommendations
- [Recommendation 1]
- [Recommendation 2]

## Conclusion
[Final assessment and next steps]
```

---

## Quick Validation Commands

```bash
# Check file structure
ls -la skill-folder/

# Count SKILL.md lines
wc -l skill-folder/SKILL.md

# Check total size
du -sh skill-folder/

# Validate YAML frontmatter
head -50 skill-folder/SKILL.md

# Search for required fields
grep -E "^(name|description|license):" skill-folder/SKILL.md
```
