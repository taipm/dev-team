---
step: 6
name: summary
title: Session Summary
agent: orchestrator-agent
trigger: export_complete
final: true
---

# Step 6: Session Summary

## Objective
Hiển thị summary và kết thúc session.

## Agent
📋 **Orchestrator Agent**

## Trigger
- Signal: `export_complete` từ Step 5

## Actions

### 6.1 Generate Summary
```yaml
content:
  - Project name and type
  - Documents created count
  - Total file size
  - Time taken
  - Output location
```

### 6.2 Display Document Tree
```yaml
format: |
  output/{project}/
  ├── 01-oppm/ (2 files)
  ├── 02-technical/ (4 files)
  ├── 03-planning/ (6 files)
  ├── 04-tracking/ (4 files)
  └── 05-reference/ (10 files)

  Total: {N} files, {X} KB
```

### 6.3 Offer Next Steps
```yaml
options:
  - Review documents
  - Export more PDFs
  - Update OPPM
  - Start new session
```

### 6.4 Save Session
```yaml
actions:
  - Save final session state
  - Create checkpoint for resume
  - Log completion
```

## Summary Template

```text
╔═══════════════════════════════════════════════════════════════════════════════╗
║  ✅ SESSION COMPLETE: {project-name}                                           ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║                                                                                ║
║  Documents Created: {N} files                                                  ║
║  Total Size: {X} KB                                                            ║
║  Time Taken: {Y} minutes                                                       ║
║                                                                                ║
║  Output Location:                                                              ║
║  output/{project-name}/                                                        ║
║  ├── 01-oppm/              2 files  (OPPM + PDF)                               ║
║  ├── 02-technical/         4 files  (Setup, Pipeline, API, Scripts)            ║
║  ├── 03-planning/          6 files  (Phases, Calendar, Risks)                  ║
║  ├── 04-tracking/          4 files  (Tracker, Dashboard, Logs)                 ║
║  └── 05-reference/        10 files  (SOPs, Checklists, Templates)              ║
║                                                                                ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║  Next Steps:                                                                   ║
║  1. Review OPPM và share với stakeholders                                      ║
║  2. Bắt đầu Phase 1 theo SOPs                                                  ║
║  3. Update weekly tracker mỗi tuần                                             ║
║                                                                                ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

## Signals
```yaml
on_complete:
  - workflow_complete
  - session_end
```

## Session End
Session terminates after summary displayed.

Options to continue:
- `*start` - New session
- `*update {project}` - Update existing project
- `*export {project}` - Export more PDFs
