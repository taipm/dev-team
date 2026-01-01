# Dev-Architect Team Workflow

## Overview

Dev-Architect team simulation facilitates dialogue giữa **Developer** và **Solution Architect** để:
- Design system architecture
- Review architecture decisions
- Create Architecture Decision Records (ADR)

## Team Members

| Agent | Role | Focus |
|-------|------|-------|
| 🏗️ Solution Architect | Design expert | System design, scalability, patterns |
| 👨‍💻 Developer | Implementation expert | Feasibility, complexity, trade-offs |

## Session Modes

### Design Mode (default)
```
Purpose: Design new system/feature architecture
Flow: Dev presents requirements → Arch proposes design → Discussion → ADR
Output: Architecture Decision Record (ADR)
```

### Review Mode
```
Purpose: Review existing architecture
Flow: Dev presents architecture → Arch reviews → Feedback → Sign-off
Output: Architecture Review Report
```

### ADR Mode
```
Purpose: Document architecture decisions
Flow: Context → Options analysis → Discussion → Decision documentation
Output: ADR Document
```

## Workflow Steps

```
┌─────────────────────────────────────────────────────────────────┐
│                    Dev-Architect Session Flow                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Step 1: Session Init                                           │
│    ├── Detect mode (design/review/adr)                          │
│    ├── Load agents và knowledge                                 │
│    └── Display welcome banner                                   │
│                                                                  │
│  Step 2: Topic Presentation                                     │
│    ├── [design] Developer presents requirements                 │
│    ├── [review] Developer presents architecture                 │
│    └── [adr] Architect presents decision context                │
│                                                                  │
│  Step 3: Dialogue Loop                                          │
│    ├── Turn-based discussion                                    │
│    ├── Observer controls (continue/intervene/skip)              │
│    └── Auto-checkpoint each turn                                │
│                                                                  │
│  Step 4: Output Synthesis                                       │
│    ├── Generate output document (ADR/Review Report)             │
│    ├── Both agents review                                       │
│    └── Sign-off process                                         │
│                                                                  │
│  Step 5: Session Close                                          │
│    ├── Save to docs/architect/logs/                             │
│    ├── Update team memory                                       │
│    └── Display summary                                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Knowledge Loading

### By Mode
| Mode | Auto-Load |
|------|-----------|
| design | architecture-patterns, adr-guide |
| review | system-design-checklist, adr-guide |
| adr | adr-guide, architecture-patterns |

### By Keywords
- `microservices`, `monolith`, `event-driven` → architecture-patterns
- `decision`, `adr`, `document` → adr-guide
- `review`, `checklist`, `security` → system-design-checklist

## Observer Commands

| Command | Effect |
|---------|--------|
| `@arch: <msg>` | Inject as Solution Architect |
| `@dev: <msg>` | Inject as Developer |
| `@guide: <msg>` | Facilitator note |
| `*focus: <topic>` | Redirect discussion |
| `*auto` | Auto-continue mode |
| `*manual` | Manual mode (default) |
| `*skip` | Skip to synthesis |
| `*exit` | End session |

## Output Paths

```yaml
# User-facing outputs (git tracked)
output_locations:
  user_outputs: "docs/architect/"
  subdirs:
    - logs/            # Session transcripts
    - adrs/            # Architecture Decision Records
    - designs/         # System design documents
    - reviews/         # Architecture review reports

# Agent internals (optional git)
agent_memory: ".microai/agents/microai/teams/dev-architect/memory/"

# File naming pattern
naming_pattern: "{YYYY-MM-DD}-{mode}-{topic-slug}.md"
```

**Output Directory Structure:**
```
docs/architect/
├── logs/
│   └── 2024-01-15-design-order-processing.md
├── adrs/
│   └── 001-database-selection.md
├── designs/
│   └── order-processing-design.md
└── reviews/
    └── 2024-01-15-payment-service-review.md
```

## Usage

### Start Session
```
/microai:dev-architect-session design payment gateway
/microai:dev-architect-session review order service architecture
/microai:dev-architect-session adr: database selection
```

### Mode Triggers
- `*design` or default → Design Mode
- `*review` or topic contains "review" → Review Mode
- `*adr` or topic contains "adr", "decision" → ADR Mode

## Memory System

- **context.md**: Active project state, statistics
- **learnings.md**: Patterns và insights discovered
- **sessions.md**: Session history summaries
- **checkpoints/**: Resume capability

## Best Practices

### For Effective Sessions
1. Provide clear requirements/context upfront
2. Let both perspectives be heard
3. Document decisions với rationale
4. Identify action items clearly

### For Good ADRs
1. State context clearly
2. List alternatives considered
3. Explain rationale for decision
4. Document consequences honestly

### For Architecture Reviews
1. Present architecture với diagrams
2. Highlight areas of concern
3. Be specific about recommendations
4. Prioritize findings by severity
