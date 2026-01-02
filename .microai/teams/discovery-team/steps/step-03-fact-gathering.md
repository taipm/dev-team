# Step 03: Fact Gathering

## Trigger
- After Step 02 complete
- Questions confirmed by user

## Agents
- 📖 **Reader** (lead)
- 📝 **Chronicler** (support)
- 🎯 **Navigator** (oversight)

## Actions

### For Each Selected Question:

#### 1. Reader: Identify Search Strategy
```yaml
input: question from queue

analyze:
  - Extract keywords from question
  - Check evidence_required field
  - Load search_hints (glob, grep)

plan:
  search_order:
    1. Glob for file patterns
    2. Grep for keywords in found files
    3. Read relevant files
    4. Extract facts with evidence
```

#### 2. Reader: Execute Search
```yaml
# Step 2a: Find files
glob_search:
  patterns: question.search_hints.glob
  result: file_list[]

# Step 2b: Search within files
grep_search:
  patterns: question.search_hints.grep
  files: file_list or **/*
  result: matches[]

# Step 2c: Read and extract
for each relevant_file:
  read: file content
  extract:
    - Specific sections relevant to question
    - Code that answers the question
    - Evidence (file:line:content)
```

#### 3. Reader: Extract Facts
```yaml
# CRITICAL: Facts only, no assumptions!
for each finding:
  create_fact:
    id: "fact-{session}-{sequence}"
    question_id: current_question.id
    type: "structure|behavior|relationship|pattern"

    content: |
      Clear description of what was found

    evidence:
      file: "{relative path}"
      lines: "{start}-{end}"
      snippet: |
        {actual code from file}

    confidence: "high|medium"
    # NO "low" - if unsure, don't claim!

  validate:
    - Evidence exists in file?
    - Line numbers correct?
    - Snippet matches source?
```

#### 4. Chronicler: Record to Code-Context
```yaml
append_to: memory/code-context.md

format:
  ## Fact: {fact_id}
  **Question:** {question}
  **Type:** {type}
  **Content:** {content}
  **Evidence:** {file}:{lines}
  ```
  {snippet}
  ```
  **Confidence:** {level}
  ---
```

#### 5. Reader: Report Progress
```markdown
📖 **Reader**: Question "{question}" - Fact extracted

**Fact:** {summary}
**Evidence:** {file}:{lines}
**Confidence:** {HIGH|MEDIUM}

**Progress:** {current}/{total} questions
**Facts collected:** {N}

[Enter] next | *detail | *skip | *deep
```

### Loop Control

```yaml
for_each_question:
  - Execute search
  - Extract facts
  - Record to context
  - Report progress
  - Await user (if not auto mode)

if: no evidence found
  report:
    "❌ KHÔNG TÌM THẤY EVIDENCE cho: {question}"
    "Đã search: {patterns}"
    "Kết quả: 0 files/matches"
  action: record as "unanswered" with reason
```

## BREAKPOINT

```markdown
═══════════════ BREAKPOINT: Xác nhận Facts ═══════════════

**Questions processed:** {N}/{total}
**Facts extracted:** {N}
**Unanswered:** {N}

**Facts Summary:**
| Question | Facts | Confidence |
|----------|-------|------------|
| arch-01 | 3 | HIGH |
| entry-01 | 2 | HIGH |
| dep-01 | 5 | MEDIUM |

**Unanswered questions:**
- {question}: {reason no evidence}

Continue to analysis? [Enter] yes | *review:{id} | *retry:{id}
```

## Error Handling

```yaml
file_not_found:
  action: log warning, skip file, continue

permission_denied:
  action: log error, note as "restricted", continue

no_evidence:
  action:
    - Record question as "unanswered"
    - Note search patterns tried
    - Suggest for derived questions
```

## Output
```yaml
code_context:
  facts:
    - {fact objects}
  files_read: []
  patterns_found: []

question_context:
  updated:
    - id: "arch-01"
      status: "answered"
      facts: ["fact-001", "fact-002"]
    - id: "entry-01"
      status: "unanswered"
      reason: "No main.* file found"
```

## Transition
→ Step 04: Analysis
