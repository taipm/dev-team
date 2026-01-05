---
step: 1
name: init
title: Session Initialization
agent: orchestrator-agent
trigger: session_start
---

# Step 1: Session Initialization

## Objective
Khởi tạo session và phân tích yêu cầu user.

## Agent
📋 **Orchestrator Agent**

## Trigger
- User invoke `/microai:one-page-session`
- User mô tả dự án

## Actions

### 1.1 Initialize Session
```yaml
actions:
  - Create session ID
  - Initialize session state
  - Create output directory structure
  - Display welcome message
```

### 1.2 Collect Project Information
```yaml
actions:
  - Parse user input
  - Ask clarifying questions if needed:
    - Project name
    - Project type (Software/General/Agile/Personal)
    - Niche/Domain
    - Timeline
    - Objectives
    - Key tasks
```

### 1.3 Project Analysis
```yaml
actions:
  - Determine document stack needed
  - Identify tools and technologies
  - Calculate timeline
  - Assign agents
```

### 1.4 Confirm with User
```yaml
actions:
  - Display project analysis summary
  - Show document stack to be created
  - Get user confirmation
```

## Breakpoint
**[BREAKPOINT: Confirm project analysis?]**

User must confirm before proceeding to Step 2.

## Outputs
- `session-state.yaml` (internal)
- `project-analysis.md` (if requested)

## Signals
```yaml
on_complete:
  - project_analysis_ready
  - trigger: step-02-oppm
```

## Error Handling
| Error | Recovery |
|-------|----------|
| Insufficient info | Ask more questions |
| Invalid project type | Suggest alternatives |
| User abort | Save state, cleanup |

## Transition
→ **Step 2: OPPM Creation**
