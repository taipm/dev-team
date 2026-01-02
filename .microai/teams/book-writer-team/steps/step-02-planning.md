# Step 02: Planning

## Agent
📋 **Planner Agent** - Book Structure Specialist

## Trigger
Step 01 hoàn thành, session state initialized

## Actions

### 1. Activate Planner Agent
```
Load: ./agents/planner-agent.md
Load knowledge: ./knowledge/planner/book-structure-patterns.md
Update state: current_agent = "planner"
```

### 2. Analyze Book Topic
```
Planner sẽ:
- Hiểu book topic từ user request
- Xác định target audience
- Xác định scope và boundaries
- Đề xuất book structure
```

### 3. Create Book Outline
```
Output: Book Outline với:
- Book title và subtitle
- Target audience description
- Prerequisites
- Part/Chapter structure
- Learning objectives per chapter
- Exercise count per chapter
- Chapter dependencies
```

### 4. Present to Observer

```
📋 **BOOK OUTLINE DRAFT**

══════════════════════════════════════════════════════════════
Title: {Book Title}
Subtitle: {Subtitle}
══════════════════════════════════════════════════════════════

TARGET AUDIENCE
{Description of who this book is for}

PREREQUISITES
- {Prerequisite 1}
- {Prerequisite 2}

══════════════════════════════════════════════════════════════

PART I: {Part Title}

Chapter 1: {Title}
├── Learning Objectives: {list}
├── Key Topics: {list}
├── Exercises: {count}
└── Estimated: {pages} pages

Chapter 2: {Title}
[...]

PART II: {Part Title}
[...]

══════════════════════════════════════════════════════════════

CHAPTER DEPENDENCIES:
Ch1 → Ch2 → Ch3
      ↓
     Ch4 → Ch5

══════════════════════════════════════════════════════════════
```

### 5. BREAKPOINT
```
═══════════════════════════════════════════════════════════════
                       [BREAKPOINT]
═══════════════════════════════════════════════════════════════

Review book outline above.

ACTIONS:
- [Enter] - Approve outline, continue to Research
- @planner: <feedback> - Request changes
- *skip - Skip to next step without changes
- *exit - End session

═══════════════════════════════════════════════════════════════
```

## Observer Options at Breakpoint

| Input | Action |
|-------|--------|
| `[Enter]` | Approve outline, proceed to Step 03 |
| `@planner: change X` | Planner revises outline |
| `*skip` | Accept as-is, proceed |
| `*exit` | Save progress, end session |

## Output
```yaml
outputs:
  outline:
    title: "{book title}"
    chapters: [{chapter objects}]
    path: "./docs/books/{book_name}/outline.md"

quality_metrics:
  outline_complete: true
```

## Checkpoint
Tự động save checkpoint sau khi outline approved:
```
./checkpoints/step-02-planning-{timestamp}.yaml
```

## Next Step
→ Step 03: Research (Researcher Agent)
