---
step: 2
name: oppm
title: OPPM Creation
agent: oppm-agent
trigger: project_analysis_ready
---

# Step 2: OPPM Creation

## Objective
Tạo One-Page Project Management document với 5 yếu tố bắt buộc.

## Agent
📄 **OPPM Agent**

## Trigger
- Signal: `project_analysis_ready` từ Step 1
- Message: `task_assignment` từ Orchestrator

## Input
```yaml
project_context:
  name: string
  type: string
  owner: string
  period: { start, end }
  objectives: array
  tasks: array
  kpis: array
```

## Actions

### 2.1 Validate Input
```yaml
actions:
  - Verify all required fields present
  - Validate objectives are measurable
  - Check tasks have owners
  - Verify timeline is realistic
```

### 2.2 Select Template
```yaml
actions:
  - Match project type to template
  - Load template: Software/General/Agile/Personal
  - Customize layout for project
```

### 2.3 Generate OPPM
```yaml
actions:
  - Create Header section
  - Create Objectives section (3-5 items)
  - Create Tasks section (10-15 items)
  - Create Timeline Matrix
  - Create Status & Metrics section
  - Apply visual formatting
  - Validate one-page constraint
```

### 2.4 Export PDF
```yaml
actions:
  - Validate markdown
  - Run pandoc with Vietnamese font
  - Verify PDF quality
```

### 2.5 Save & Signal
```yaml
actions:
  - Save oppm.md to output/01-oppm/
  - Save oppm.pdf to output/01-oppm/
  - Publish oppm_created signal
```

## Outputs
- `output/{project}/01-oppm/oppm.md`
- `output/{project}/01-oppm/oppm.pdf`

## Signals
```yaml
on_complete:
  - oppm_created
  - payload:
      path: output/{project}/01-oppm/oppm.md
      project_context: {...}
  - trigger: [step-03a-doc, step-03b-track, step-03c-sop, step-03d-template]
```

## Error Handling
| Error | Recovery |
|-------|----------|
| Content too long | Summarize, remove details |
| PDF export fail | Try alternative fonts |
| Missing info | Request from Orchestrator |

## Transition
→ **Step 3a-3d: Parallel Document Generation** (4 agents simultaneously)
