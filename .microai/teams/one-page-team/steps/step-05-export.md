---
step: 5
name: export
title: Export & Package
agent: orchestrator-agent
trigger: review_complete
---

# Step 5: Export & Package

## Objective
Export key documents to PDF và package outputs.

## Agent
📋 **Orchestrator Agent**

## Trigger
- Signal: `review_complete` từ Step 4

## Actions

### 5.1 Export PDFs
```yaml
documents_to_export:
  - oppm.md → oppm.pdf (already done in Step 2)
  - Additional PDFs if requested

command: |
  pandoc {file}.md -o {file}.pdf \
    --pdf-engine=xelatex \
    -V geometry:a4paper \
    -V geometry:margin=15mm \
    -V fontsize=10pt \
    -V mainfont="Arial Unicode MS"
```

### 5.2 Create Final README
```yaml
actions:
  - Generate comprehensive README.md
  - Include document tree
  - Add quick start guide
  - List all files with descriptions
```

### 5.3 Package Outputs
```yaml
actions:
  - Verify all files in place
  - Create manifest.yaml
  - Calculate file sizes
```

### 5.4 Open Output Folder
```yaml
actions:
  - Open output directory in Finder/Explorer
  - Display path to user
```

## Outputs
- PDFs of key documents
- `README.md` with navigation
- `manifest.yaml` with file list

## Signals
```yaml
on_complete:
  - export_complete
  - trigger: step-06-summary
```

## Error Handling
| Error | Recovery |
|-------|----------|
| PDF export fail | Skip, note in summary |
| Folder open fail | Display path instead |

## Transition
→ **Step 6: Summary**
