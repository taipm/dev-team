---
step: 3b
name: track
title: Tracking & Metrics
agent: track-agent
trigger: oppm_created
parallel: true
group: document_generation
---

# Step 3b: Tracking & Metrics

## Objective
Tạo tracking documents và metrics dashboards.

## Agent
📊 **Track Agent**

## Trigger
- Signal: `oppm_created` từ Step 2
- Parallel với: Step 3a, 3c, 3d

## Input
```yaml
project_context:
  tasks: array
  kpis: array
  timeline: { weeks }
output_path: output/{project}/
```

## Actions

### 3b.1 Create Weekly Tracker
```yaml
actions:
  - Generate task list from OPPM
  - Create week columns based on timeline
  - Add checkboxes and status indicators
```

### 3b.2 Create Metrics Dashboard
```yaml
actions:
  - Identify KPIs from objectives
  - Create progress bars template
  - Add trend visualization
```

### 3b.3 Create Production Log
```yaml
actions:
  - Create chronological log template
  - Add entry format
  - Include summary statistics
```

### 3b.4 Create Retrospective Template
```yaml
actions:
  - Create standard retro format
  - Include action items section
  - Add metrics comparison
```

## Outputs
```text
output/{project}/
└── 04-tracking/
    ├── weekly-tracker.md
    ├── metrics-dashboard.md
    ├── production-log.md
    └── retrospective.md
```

## Signals
```yaml
on_complete:
  - tracking_ready
  - payload:
      tracking_docs: [paths]
```

## Error Handling
| Error | Recovery |
|-------|----------|
| No KPIs defined | Use default metrics |
| Timeline unclear | Use 12-week default |

## Transition
→ **Step 4: Review** (after all parallel steps complete)
