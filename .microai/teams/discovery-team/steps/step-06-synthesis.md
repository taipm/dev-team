# Step 06: Synthesis

## Trigger
- Step 05 decision: PROCEED
- OR user forces synthesis (*export)

## Agents
- 📝 **Chronicler** (lead)
- 🧠 **Analyzer** (support)
- 🎯 **Navigator** (oversight)

## Actions

### 1. Chronicler: Gather All Data
```yaml
collect:
  from_code_context:
    - All facts
    - All evidence
    - Files read

  from_analysis:
    - Patterns identified
    - Relationships mapped
    - Gaps identified
    - Insights generated

  from_question_context:
    - Questions answered
    - Questions unanswered
    - Derived questions

  from_last_context:
    - Previous session findings
    - Cumulative knowledge
```

### 2. Chronicler: Generate Structured Report
```yaml
template: templates/structured-report.md

sections:
  1. Executive Summary:
    - Session overview
    - Key findings (top 5)
    - Critical gaps

  2. Codebase Overview:
    - Architecture pattern
    - Key components
    - Technology stack

  3. Detailed Findings:
    - By category
    - By question
    - Evidence links

  4. Patterns Identified:
    - Pattern table
    - Pattern details
    - Implications

  5. Relationship Map:
    - Mermaid diagram
    - Component list
    - Dependency analysis

  6. Gaps & Open Questions:
    - Prioritized list
    - Recommended follow-ups

  7. Recommendations:
    - Immediate actions
    - Future exploration

  8. Appendix:
    - Evidence reference
    - Files read
    - Session metadata

output:
  path: outputs/reports/{date}-discovery-report.md
  format: markdown
```

### 3. Chronicler: Build Knowledge Graph
```yaml
template: templates/knowledge-graph.md

generate:
  # Mermaid diagram
  mermaid: |
    graph TD
      subgraph Services
        {foreach service}
        {service.id}[{service.name}]
        {/foreach}
      end

      subgraph Data
        {foreach datastore}
        {datastore.id}[({datastore.name})]
        {/foreach}
      end

      {foreach relationship}
      {relationship.from} --> {relationship.to}
      {/foreach}

  # JSON export
  json:
    nodes: [{id, name, type, metadata}]
    edges: [{from, to, type, weight}]

  # DOT format (for Graphviz)
  dot: |
    digraph G {
      {nodes and edges}
    }

output:
  paths:
    - outputs/graphs/{date}-knowledge-graph.md (mermaid)
    - outputs/graphs/{date}-knowledge-graph.json
    - outputs/graphs/{date}-knowledge-graph.dot
```

### 4. Chronicler: Generate Q&A Database Entries
```yaml
template: templates/qa-entry.md

for each answered_question:
  create_entry:
    question_id: "{id}"
    question_text: "{text}"
    answer:
      summary: "{brief answer}"
      details: [{structured details}]
      evidence: [{file, lines, snippet}]
    confidence: "{level}"
    session_id: "{session}"
    answered_at: "{timestamp}"

output:
  path: outputs/qa-database/{date}-qa-entries.yaml
  format: yaml

  # Also create individual files
  individual:
    path: outputs/qa-database/entries/
    files: one per question
```

### 5. Chronicler: Update Contexts
```yaml
# Merge current → last
last_context_update:
  append_session:
    id: session.id
    date: session.started_at
    scope: session.scope
    questions_answered: {N}
    key_findings: [{summary}]

  merge_cumulative:
    components: union(last.components, current.components)
    patterns: union(last.patterns, current.patterns)
    relationships: union(last.relationships, current.relationships)

  update_open_questions:
    - Remove answered
    - Add new gaps

# Archive code-context
archive:
  from: memory/code-context.md
  to: memory/archives/{session.id}-code-context.md

# Clear current-context
clear: memory/current-context.md
```

### 6. Report Generation Status
```markdown
📝 **Chronicler**: Synthesis Complete

**Outputs Generated:**

| Output | Status | Path | Size |
|--------|--------|------|------|
| Structured Report | ✓ | outputs/reports/{date}-report.md | {size} |
| Knowledge Graph | ✓ | outputs/graphs/{date}-graph.md | {nodes}N/{edges}E |
| Q&A Database | ✓ | outputs/qa-database/{date}-qa.yaml | {entries} entries |

**Contexts Updated:**

| Context | Action |
|---------|--------|
| last-context | Merged (+1 session) |
| question-context | Updated ({N} answered) |
| code-context | Archived |
| current-context | Cleared |

**Preview:**
```markdown
# {Report Title}

## Executive Summary
{first 3-5 lines of summary}
...

[View full report: {path}]
```
```

## Output
```yaml
outputs:
  report:
    path: outputs/reports/{date}-discovery-report.md
    sections: 8
    word_count: {N}

  graph:
    path: outputs/graphs/{date}-knowledge-graph.md
    nodes: {N}
    edges: {N}
    formats: [mermaid, json, dot]

  qa_database:
    path: outputs/qa-database/{date}-qa-entries.yaml
    entries: {N}

contexts_updated:
  last_context: true
  question_context: true
  code_context: archived
  current_context: cleared
```

## Transition
→ Step 07: Session Close
