---
step: 3c
name: sop
title: Standard Operating Procedures
agent: sop-agent
trigger: oppm_created
parallel: true
group: document_generation
---

# Step 3c: Standard Operating Procedures

## Objective
Tạo SOPs, checklists và decision logs.

## Agent
📝 **SOP Agent**

## Trigger
- Signal: `oppm_created` từ Step 2
- Parallel với: Step 3a, 3b, 3d

## Input
```yaml
project_context:
  tasks: array
  phases: array
  quality_criteria: array
output_path: output/{project}/
```

## Actions

### 3c.1 Create Phase SOPs
```yaml
actions:
  - Generate SOP for each phase (4 files)
  - Include prerequisites, steps, verification
  - Add error handling sections
```

### 3c.2 Create Quality Checklist
```yaml
actions:
  - Create hierarchical checklist
  - Add pre/during/post sections
  - Include pass/fail criteria
```

### 3c.3 Create Decision Log Template
```yaml
actions:
  - Create decision entry template
  - Add options comparison format
  - Include outcome tracking
```

## Outputs
```text
output/{project}/
└── 05-reference/
    ├── sop-phase-1.md
    ├── sop-phase-2.md
    ├── sop-phase-3.md
    ├── sop-phase-4.md
    ├── quality-checklist.md
    └── decision-log.md
```

## Signals
```yaml
on_complete:
  - sops_created
  - payload:
      sop_docs: [paths]
```

## Error Handling
| Error | Recovery |
|-------|----------|
| Phase count mismatch | Adjust to match OPPM |
| No quality criteria | Use standard criteria |

## Transition
→ **Step 4: Review** (after all parallel steps complete)
