# PM-Dev Team Workflow

## Overview

PM-Dev team simulation facilitates dialogue giữa **Product Manager** và **Developer** để:
- Refine requirements và user stories
- Create technical specifications
- Estimate effort và plan sprints

## Team Members

| Agent | Role | Focus |
|-------|------|-------|
| 📋 Product Manager | Product expert | User needs, priorities, business value |
| 👨‍💻 Developer | Technical expert | Feasibility, estimates, implementation |

## Session Modes

### Requirements Mode (default)
```
Purpose: Refine requirements and create user stories
Flow: PM presents → Dev clarifies → Refine → Document
Output: User Stories Document
```

### Tech Spec Mode
```
Purpose: Create technical specification
Flow: Requirements → Design discussion → Estimate → Document
Output: Technical Specification
```

### Estimation Mode
```
Purpose: Estimate effort for features/stories
Flow: Scope → Breakdown → Estimate → Confidence
Output: Estimation Report
```

## Workflow Steps

```
┌─────────────────────────────────────────────────────────────────┐
│                    PM-Dev Session Flow                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Step 1: Session Init                                           │
│    ├── Detect mode (requirements/tech-spec/estimation)          │
│    ├── Load agents và knowledge                                 │
│    └── Display welcome banner                                   │
│                                                                  │
│  Step 2: Topic Presentation                                     │
│    └── PM presents feature/requirements/scope                   │
│                                                                  │
│  Step 3: Dialogue Loop                                          │
│    ├── Turn-based discussion                                    │
│    ├── Clarifying questions                                     │
│    ├── Scope negotiation                                        │
│    └── Observer controls                                        │
│                                                                  │
│  Step 4: Output Synthesis                                       │
│    ├── Generate output document                                 │
│    ├── Compile stories/estimates                                │
│    └── Sign-off process                                         │
│                                                                  │
│  Step 5: Session Close                                          │
│    ├── Save to .microai/docs/teams/pm-dev/logs/                 │
│    ├── Update team memory                                       │
│    └── Display summary                                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Knowledge Loading

### By Mode
| Mode | Auto-Load |
|------|-----------|
| requirements | user-story-guide |
| tech-spec | technical-spec-guide, estimation-techniques |
| estimation | estimation-techniques |

### By Keywords
- `story`, `requirement`, `feature` → user-story-guide
- `spec`, `technical`, `design` → technical-spec-guide
- `estimate`, `timeline`, `planning` → estimation-techniques

## Observer Commands

| Command | Effect |
|---------|--------|
| `@pm: <msg>` | Inject as Product Manager |
| `@dev: <msg>` | Inject as Developer |
| `@guide: <msg>` | Facilitator note |
| `*focus: <topic>` | Focus on specific story |
| `*auto` | Auto-continue mode |
| `*manual` | Manual mode (default) |
| `*skip` | Skip to synthesis |
| `*exit` | End session |

## Output Paths

```
.microai/docs/teams/pm-dev/logs/
├── 2024-01-15-requirements-user-notifications.md
├── 2024-01-15-tech-spec-payment-gateway.md
└── 2024-01-15-estimation-dashboard-redesign.md
```

## Usage

### Start Session
```
/microai:pm-dev-session requirements: user notification feature
/microai:pm-dev-session tech-spec: payment gateway integration
/microai:pm-dev-session estimation: dashboard redesign
```

### Mode Triggers
- `*requirements` or default → Requirements Mode
- `*tech-spec` or topic contains "spec", "technical" → Tech Spec Mode
- `*estimation` or topic contains "estimate", "planning" → Estimation Mode

## Memory System

- **context.md**: Active project state, statistics
- **learnings.md**: Patterns và insights discovered
- **sessions.md**: Session history summaries
- **checkpoints/**: Resume capability

## Best Practices

### For PM
1. Come prepared với user context
2. Be clear about priorities
3. Open to scope negotiation
4. Document constraints upfront

### For Developer
1. Ask clarifying questions
2. Provide range estimates
3. Flag risks early
4. Suggest alternatives

### For Both
1. Time-box discussions
2. Document assumptions
3. Agree on scope before estimating
4. Follow up on open questions
