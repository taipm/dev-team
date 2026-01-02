# Q&A Entry Template

## YAML Format

```yaml
# Single Q&A Entry
entry:
  # Identifiers
  question_id: "{{question_id}}"
  category: "{{category}}"
  session_id: "{{session_id}}"
  answered_at: "{{timestamp}}"

  # Question
  question:
    text: "{{question_text}}"
    depth: {{depth}}
    parent: "{{parent_question_id}}"  # null if original

  # Answer
  answer:
    summary: |
      {{answer_summary}}

    details:
{{#each details}}
      - aspect: "{{aspect}}"
        finding: "{{finding}}"
        location: "{{location}}"
{{/each}}

    evidence:
{{#each evidence}}
      - file: "{{file}}"
        lines: "{{lines}}"
        snippet: |
          {{snippet}}
        note: "{{note}}"
{{/each}}

  # Metadata
  confidence: "{{confidence}}"  # high | medium
  verified: {{verified}}
  related_questions: [{{related_questions}}]
  related_patterns: [{{related_patterns}}]
```

---

## Markdown Format

### {{question_id}}: {{question_text}}

**Category:** {{category}}
**Depth:** {{depth}}
**Confidence:** {{confidence}}

#### Answer

{{answer_summary}}

#### Details

{{#each details}}
- **{{aspect}}:** {{finding}}
  - Location: `{{location}}`
{{/each}}

#### Evidence

{{#each evidence}}
**{{file}}:{{lines}}**
```
{{snippet}}
```
{{#if note}}
*Note: {{note}}*
{{/if}}

{{/each}}

#### Related

- Questions: {{related_questions}}
- Patterns: {{related_patterns}}

---

*Answered in session {{session_id}} on {{timestamp}}*

---

## Bulk Export Template (YAML)

```yaml
# Q&A Database Export
export:
  project: "{{project_name}}"
  exported_at: "{{export_timestamp}}"
  total_entries: {{total_entries}}

entries:
{{#each entries}}
  - question_id: "{{question_id}}"
    question: "{{question_text}}"
    answer_summary: "{{answer_summary}}"
    confidence: "{{confidence}}"
    evidence_count: {{evidence_count}}
    session: "{{session_id}}"
{{/each}}
```

---

## Query Examples

### Find by Category
```yaml
# All architecture questions
filter:
  category: "architecture"
```

### Find by Confidence
```yaml
# All high-confidence answers
filter:
  confidence: "high"
```

### Find Unanswered
```yaml
# Questions without answers
filter:
  status: "unanswered"
```

### Find Related
```yaml
# Questions related to auth
search:
  text: "auth*"
  fields: [question, answer_summary]
```
