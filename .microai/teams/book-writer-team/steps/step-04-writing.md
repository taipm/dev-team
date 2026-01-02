# Step 04: Writing

## Agent
✍️ **Writer Agent** - Technical Content Writer

## Trigger
Step 03 hoàn thành, research complete

## Actions

### 1. Activate Writer Agent
```
Load: ./agents/writer-agent.md
Load knowledge: ./knowledge/writer/writing-patterns.md
Receive: Outline from Step 02, Research from Step 03
Update state: current_agent = "writer"
```

### 2. Write Each Chapter
```
For each chapter:
1. Review outline objectives
2. Study research notes
3. Write introduction (hook + overview)
4. Write main content sections
5. Create code examples with explanations
6. Write exercises with solutions
7. Write chapter summary
8. Write transition to next chapter
```

### 3. Content Structure
```markdown
# Chapter {N}: {Title}

> {Engaging quote or hook}

## Introduction

{Why this chapter matters}
{What reader will learn}
{How it connects to previous chapter}

## {Section 1}

{Clear explanation with examples}

### {Subsection}

{Detailed content}

```{language}
// Code with comments
{code}
```

**Let's break this down:**
- Line 1: {explanation}
- Line 2: {explanation}

## Exercises

### Exercise 1: {Title}
{Instructions}

<details>
<summary>Solution</summary>
{Solution with explanation}
</details>

## Summary

{Key takeaways}

## What's Next

{Preview of next chapter}
```

### 4. Present Draft Chapters

```
✍️ **CHAPTER DRAFTS**

══════════════════════════════════════════════════════════════

CHAPTER 1: {Title}
Word Count: {count}
Code Examples: {count}
Exercises: {count}
Status: ✅ Draft Complete

Preview:
{First 500 characters of chapter...}

──────────────────────────────────────────────────────────────

CHAPTER 2: {Title}
[...]

══════════════════════════════════════════════════════════════

WRITING SUMMARY:
- Chapters written: {count}/{total}
- Total word count: {count}
- Total code examples: {count}
- Total exercises: {count}

══════════════════════════════════════════════════════════════
```

### 5. BREAKPOINT
```
═══════════════════════════════════════════════════════════════
                       [BREAKPOINT]
═══════════════════════════════════════════════════════════════

Review chapter drafts above.

ACTIONS:
- [Enter] - Approve drafts, continue to Editing
- @writer: revise chapter N - Request revision
- *skip - Accept as-is, proceed
- *exit - End session

═══════════════════════════════════════════════════════════════
```

## Observer Options at Breakpoint

| Input | Action |
|-------|--------|
| `[Enter]` | Approve drafts, proceed to Step 05 |
| `@writer: feedback` | Writer revises based on feedback |
| `*skip` | Accept as-is, proceed |
| `*exit` | Save progress, end session |

## Communication
```yaml
publishes:
  topic: content
  message:
    type: chapters_written
    data:
      chapters: [{chapter content}]
      word_count: {total}
```

## Output
```yaml
outputs:
  chapters:
    - path: "./docs/books/{book_name}/chapters/chapter-01.md"
      word_count: {count}
    - path: "./docs/books/{book_name}/chapters/chapter-02.md"
      word_count: {count}
    [...]

quality_metrics:
  content_written: true
```

## Checkpoint
```
./checkpoints/step-04-writing-{timestamp}.yaml
```

## Next Step
→ Step 05: Editing (Editor Agent)
