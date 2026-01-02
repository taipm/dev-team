# Step 02: Question Selection

## Trigger
- After Step 01 complete
- Navigator signals "proceed to selection"

## Agents
- ❓ **Questioner** (lead)
- 🎯 **Navigator** (support)

## Actions

### 1. Questioner: Load Question Bank
```yaml
load:
  source: knowledge/question-bank.yaml
  parse:
    - categories
    - questions per category
    - dependencies
    - depth levels
```

### 2. Questioner: Apply Filters
```yaml
filters:
  # 1. Exclude already answered
  answered_filter:
    source: memory/question-context.md
    action: exclude questions with status="answered"

  # 2. Scope filter
  scope_filter:
    if: scope == "focused:{area}"
      include: only questions in {area} category
    else:
      include: all categories

  # 3. Depth filter
  depth_filter:
    if: session_depth == 1
      include: questions with depth <= 1
    elif: session_depth == 2
      include: questions with depth <= 2
    else:
      include: all questions

  # 4. Dependency filter
  dependency_filter:
    for each question:
      if: all dependencies answered
        status: available
      else:
        status: blocked (list unmet deps)
```

### 3. Questioner: Prioritize
```yaml
priority_algorithm:
  # Base score
  base: 100

  # Modifiers
  modifiers:
    is_prerequisite_for_others: +30
    matches_open_questions: +25
    fills_known_gap: +20
    context_relevant: +15
    derived_from_finding: +20
    higher_depth: -10 per level

  # Sort
  sort_by:
    - priority_score (desc)
    - depth (asc)
    - category_order
```

### 4. Questioner: Present Selection
```markdown
❓ **Questioner**: Đã phân tích Question Bank

**Filters applied:**
- Scope: {scope}
- Depth: ≤{level}
- Answered: {N} excluded
- Blocked: {N} (dependencies unmet)

**Selected questions ({N}):**

| # | ID | Category | Question | Depth |
|---|-----|----------|----------|-------|
| 1 | arch-01 | 🏗️ Kiến trúc | Codebase pattern? | 1 |
| 2 | entry-01 | 🚪 Entry | Main entry point? | 1 |
| 3 | dep-01 | 📦 Dependencies | External dependencies? | 1 |
| ... | ... | ... | ... | ... |

**Blocked questions (dependencies unmet):**
- arch-02 → needs: arch-01
- data-02 → needs: entry-02, data-01

**Estimated session time:** {estimate}

[Enter] to proceed | *add:{id} | *remove:{id} | *reorder
```

### 5. Navigator: Confirm Selection

```yaml
await_user:
  options:
    "[Enter]": proceed with selection
    "*add:{id}": add specific question
    "*remove:{id}": remove question
    "*reorder:{id1},{id2}": swap order
    "*all": select all available
    "*min": minimal set (prerequisites only)
```

## BREAKPOINT

```markdown
═══════════════ BREAKPOINT: Xác nhận câu hỏi ═══════════════

**Questions selected:** {N}
**Categories covered:** {list}

Confirm và bắt đầu discovery? [Enter] yes | *modify | *cancel
```

## Output
```yaml
current_context:
  questions:
    selected:
      - id: "arch-01"
        priority: 1
        status: "pending"
      - id: "entry-01"
        priority: 2
        status: "pending"
    total: {N}
    by_category:
      architecture: {N}
      entry_points: {N}
      # ...
```

## Transition
→ Step 03: Fact Gathering
