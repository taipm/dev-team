# Father Agent - Design Documents

> Directory for design documents created during agent/team creation workflows.

## Purpose

This directory stores design documents that are:
1. **Created** by Father Agent before any create/clone/create-team operation
2. **Reviewed** by Deep Thinking Team for approval
3. **Archived** after successful execution

## Directory Structure

```
designs/
├── README.md              # This file
├── {name}-design.md       # Active design documents (WIP)
└── archive/               # Completed design documents
    └── {date}-{type}-{name}.md
```

## Workflow

```
┌─────────────────┐
│  1. CREATE      │  Father Agent generates design doc from template
│     DESIGN      │  Path: ./designs/{name}-design.md
└────────┬────────┘
         │
         v
┌─────────────────┐
│  2. SUBMIT TO   │  /microai:deep-thinking {mode}
│  DEEP THINKING  │  Mandatory review by expert team
└────────┬────────┘
         │
    ┌────┴────┐
    v         v
┌────────┐ ┌──────────┐
│APPROVED│ │ REJECTED │
└───┬────┘ └────┬─────┘
    │           │
    │           v
    │    ┌──────────────┐
    │    │ REVISE &     │  Loop back to step 1
    │    │ RESUBMIT     │  No skip allowed
    │    └──────────────┘
    │
    v
┌─────────────────┐
│  3. EXECUTE     │  Proceed with agent/team creation
│     WORKFLOW    │
└────────┬────────┘
         │
         v
┌─────────────────┐
│  4. ARCHIVE     │  Move to ./archive/{date}-{type}-{name}.md
│     DESIGN      │
└─────────────────┘
```

## Naming Convention

### Active Documents
- Pattern: `{target-name}-design.md`
- Example: `gateway-agent-design.md`

### Archived Documents
- Pattern: `{YYYY-MM-DD}-{operation-type}-{target-name}.md`
- Examples:
  - `2025-01-04-create-agent-gateway-agent.md`
  - `2025-01-04-clone-agent-go-review-agent.md`
  - `2025-01-04-create-team-security-team.md`

## Review Modes

| Mode | Duration | When to Use |
|------|----------|-------------|
| `quick` | 5-15 min | Simple clone with minimal changes |
| `standard` | 30-60 min | New agent, significant modifications |
| `deep` | 2-4 hours | New team, critical infrastructure |

## Important Rules

1. **No Skip**: Design Review is MANDATORY - cannot be skipped under any circumstances
2. **Revise on Reject**: If rejected, must revise and resubmit (not cancel)
3. **Archive Required**: All completed designs must be archived
4. **Link to Created Asset**: Design doc should be referenced in created agent's memory (if enabled)

## Template Location

Design document template: `../knowledge/16-design-document-template.md`
