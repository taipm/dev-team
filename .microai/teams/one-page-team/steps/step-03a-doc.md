---
step: 3a
name: doc
title: Technical & Planning Documentation
agent: doc-agent
trigger: oppm_created
parallel: true
group: document_generation
---

# Step 3a: Technical & Planning Documentation

## Objective
Tạo technical docs và planning docs chi tiết.

## Agent
📚 **Doc Agent**

## Trigger
- Signal: `oppm_created` từ Step 2
- Parallel với: Step 3b, 3c, 3d

## Input
```yaml
project_context: (from oppm_created signal)
output_path: output/{project}/
```

## Actions

### 3a.1 Technical Documentation
```yaml
outputs:
  - tool-setup-guides.md
  - pipeline-architecture.md
  - api-integration.md
  - batch-scripts/ (directory)
```

### 3a.2 Planning Documentation
```yaml
outputs:
  - phase-1-breakdown.md
  - phase-2-breakdown.md
  - phase-3-breakdown.md
  - phase-4-breakdown.md
  - content-calendar.md
  - risk-mitigation.md
```

## Outputs
```text
output/{project}/
├── 02-technical/
│   ├── tool-setup-guides.md
│   ├── pipeline-architecture.md
│   ├── api-integration.md
│   └── batch-scripts/
└── 03-planning/
    ├── phase-1-breakdown.md
    ├── phase-2-breakdown.md
    ├── phase-3-breakdown.md
    ├── phase-4-breakdown.md
    ├── content-calendar.md
    └── risk-mitigation.md
```

## Signals
```yaml
on_complete:
  - docs_created
  - payload:
      technical_docs: [paths]
      planning_docs: [paths]
```

## Error Handling
| Error | Recovery |
|-------|----------|
| Missing tool info | Use generic setup |
| Invalid phase count | Adjust to match OPPM |

## Transition
→ **Step 4: Review** (after all parallel steps complete)
