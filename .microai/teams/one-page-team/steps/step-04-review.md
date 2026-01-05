---
step: 4
name: review
title: Review & Validation
agent: orchestrator-agent
trigger: [docs_created, tracking_ready, sops_created, templates_ready]
wait_for_all: true
---

# Step 4: Review & Validation

## Objective
Thu thập, review và validate tất cả outputs.

## Agent
📋 **Orchestrator Agent**

## Trigger
- Wait for ALL parallel steps to complete:
  - `docs_created` từ Step 3a
  - `tracking_ready` từ Step 3b
  - `sops_created` từ Step 3c
  - `templates_ready` từ Step 3d

## Actions

### 4.1 Collect Outputs
```yaml
actions:
  - Gather all document paths
  - Verify file existence
  - Count total documents
```

### 4.2 Validate Completeness
```yaml
checks:
  - All expected files exist
  - No empty files
  - Vietnamese encoding correct
  - Cross-references valid
```

### 4.3 Generate Document Index
```yaml
actions:
  - Create README.md với links
  - List all documents with descriptions
  - Add navigation structure
```

### 4.4 Quality Check
```yaml
checks:
  - OPPM fits on one page
  - Consistency across documents
  - No placeholder text remaining
  - All sections complete
```

## Breakpoint
**[BREAKPOINT: Review complete?]**

User can review outputs before export.

## Outputs
- `output/{project}/README.md`
- Validation report (internal)

## Signals
```yaml
on_complete:
  - review_complete
  - trigger: step-05-export
```

## Error Handling
| Error | Recovery |
|-------|----------|
| Missing documents | Retry failed agent |
| Validation failed | Report issues, offer fix |
| Empty files | Regenerate |

## Transition
→ **Step 5: Export**
