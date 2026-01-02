# Question Sources Guide

> Hướng dẫn Questioner Agent load và quản lý câu hỏi từ nhiều nguồn

---

## Supported Question Sources

### 1. Built-in Question Bank (YAML)
**Path:** `../question-bank.yaml`
**Format:** YAML với categories, dependencies, search_hints
**Use when:** Full structured discovery

### 2. Custom Questions (Markdown)
**Path:** `./custom-questions/*.md`
**Format:** Markdown - thân thiện với người dùng
**Use when:** User muốn thêm câu hỏi nhanh

### 3. Project-Specific Questions
**Path:** `.discovery/questions.md` (trong target project)
**Format:** Markdown
**Use when:** Project có câu hỏi riêng

### 4. Inline Questions
**Source:** User input during session
**Format:** Free text
**Use when:** Ad-hoc exploration

---

## Loading Priority

```
1. [ALWAYS] Built-in question-bank.yaml (core questions)
2. [IF EXISTS] custom-questions/*.md (team customizations)
3. [IF EXISTS] {target}/.discovery/questions.md (project-specific)
4. [RUNTIME] User inline questions (*ask: ...)
```

---

## Markdown Question Format

Khi load từ `.md` files, parse theo format:

```markdown
## Category Name
<!-- category: category-id -->
<!-- icon: 🔍 -->

### Question Title
<!-- id: cat-01 -->
<!-- depth: 2 -->
<!-- depends: [arch-01] -->

**Câu hỏi:** Nội dung câu hỏi ở đây?

**Evidence cần tìm:**
- Loại file/pattern cần tìm
- Thông tin cần extract

**Search hints:**
- Glob: `**/*.go`, `**/config.*`
- Grep: `keyword1`, `keyword2`
```

---

## Question Set Profiles

### Profile: quick
- Chỉ load Depth-1 questions
- Max 5-8 câu hỏi
- ~15-30 phút

### Profile: standard
- Load Depth-1 + Depth-2
- Max 10-15 câu hỏi
- ~1 giờ

### Profile: comprehensive
- Load tất cả depths
- 20+ câu hỏi
- ~2+ giờ

### Profile: custom
- Chỉ load từ custom-questions/
- Số lượng tùy user

### Profile: focused:{category}
- Chỉ load category cụ thể
- E.g., `focused:security`, `focused:architecture`

---

## Selection Algorithm

```yaml
select_questions:
  input:
    - profile: string
    - scope: string | null
    - exclude_answered: boolean
    - custom_only: boolean

  steps:
    1. Load sources theo priority
    2. Filter by profile (depth)
    3. Filter by scope (category)
    4. Exclude answered (from question-context)
    5. Resolve dependencies
    6. Sort by priority score
    7. Return selected list
```

---

## Commands

| Command | Effect |
|---------|--------|
| `*questions:list` | List tất cả available questions |
| `*questions:custom` | Chỉ show custom questions |
| `*questions:add` | Add inline question |
| `*questions:profile:{name}` | Switch profile |
| `*questions:category:{id}` | Focus on category |

---

*Questioner Agent sử dụng file này để quản lý multi-source questions.*
