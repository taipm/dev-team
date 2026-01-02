# Step 05: Editing

## Agent
📝 **Editor Agent** - Editing & Proofreading Specialist

## Trigger
Step 04 hoàn thành, drafts approved

## Actions

### 1. Activate Editor Agent
```
Load: ./agents/editor-agent.md
Load knowledge: ./knowledge/editor/editing-guide.md
Receive: Chapter drafts from Step 04
Update state: current_agent = "editor"
```

### 2. Edit Each Chapter
```
For each chapter:
1. Grammar and punctuation check
2. Style consistency review
3. Clarity improvement
4. Code formatting verification
5. Terminology standardization
6. Flow and transition check
```

### 3. Editing Categories

#### Grammar & Punctuation
- Subject-verb agreement
- Tense consistency
- Comma usage
- Apostrophes
- Sentence fragments

#### Style Consistency
- Heading hierarchy
- List formatting
- Code block style
- Terminology usage
- Voice and tone

#### Clarity
- Simplify complex sentences
- Remove redundancy
- Improve transitions
- Add clarifying phrases
- Break up long paragraphs

#### Code Formatting
- Consistent indentation
- Language hints on code blocks
- Comment style
- Variable naming
- Line length

### 4. Create Editing Report

```
📝 **EDITING REPORT**

══════════════════════════════════════════════════════════════

CHAPTER 1: {Title}

Issues Found: {count}
├── Critical: {count}
├── Major: {count}
└── Minor: {count}

CRITICAL ISSUES:
1. {Description} - Line {N}

STYLE CORRECTIONS:
| Original | Corrected | Instances |
|----------|-----------|-----------|
| {text}   | {text}    | {count}   |

TERMINOLOGY STANDARDIZED:
- "JavaScript" (not "Javascript" or "JS")
- [other terms...]

──────────────────────────────────────────────────────────────

CHAPTER 2: {Title}
[...]

══════════════════════════════════════════════════════════════

EDITING SUMMARY:
- Total issues found: {count}
- Issues corrected: {count}
- Chapters edited: {count}/{total}
- Style guide updates: {count}

══════════════════════════════════════════════════════════════
```

### 5. Apply Edits
```
- Apply all corrections to chapter files
- Update style guide if new conventions added
- Track changes for review
```

## Communication
```yaml
publishes:
  topic: editing
  message:
    type: editing_complete
    data:
      chapters: [{edited chapter info}]
      issues_fixed: {count}
      style_updates: [{new conventions}]
```

## Output
```yaml
outputs:
  edited_content:
    chapters: [{paths to edited chapters}]
    editing_report: "./docs/books/{book_name}/editing-report.md"
    style_guide: "./docs/books/{book_name}/style-guide.md"

quality_metrics:
  editing_pass: true
```

## Checkpoint
```
./checkpoints/step-05-editing-{timestamp}.yaml
```

## Next Step
→ Step 06: Review Loop (Reviewer Agent)
