# Dev-QA Team Workflow

## Overview

Team simulation giữa **QA Engineer** và **Developer** để thực hiện:
- Test Plan Creation
- Bug Triage
- Code Review + QA

---

## Team Members

| Agent | Role | Icon | Color |
|-------|------|------|-------|
| qa-engineer | Senior QA Engineer | 🔍 | orange |
| developer | Full-Stack Developer | 👨‍💻 | green |

---

## Session Modes

### Mode 1: Test Plan (`*testplan`)
```
Purpose: Tạo test plan cho feature mới
First Speaker: Developer
Output: Test Plan Document với Test Cases (GWT format)

Flow:
Dev presents feature → QA asks questions →
Dialogue about scope, risks → QA proposes test scenarios →
Dev validates feasibility → Both sign off
```

### Mode 2: Bug Triage (`*bug`)
```
Purpose: Triage bug report và agree on fix
First Speaker: QA Engineer
Output: Bug Report với agreed severity + fix plan

Flow:
QA presents bug → Dev analyzes root cause →
Dialogue about severity, priority → Agree on fix approach →
QA proposes verification scenarios → Both sign off
```

### Mode 3: Code Review (`*review`)
```
Purpose: QA review code từ testability perspective
First Speaker: Developer
Output: Code Review Report với QA recommendations

Flow:
Dev presents code changes → QA reviews testability →
Dialogue about edge cases, error handling →
QA provides recommendations → Dev addresses feedback → Sign off
```

---

## Session Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEV-QA SESSION FLOW                          │
└─────────────────────────────────────────────────────────────────┘

     ┌──────────────┐
     │ Step 01      │
     │ Session Init │
     └──────┬───────┘
            │
            ▼
┌───────────────────────┐
│ Detect mode from topic│
│ Load agents & knowledge│
│ Display welcome       │
└───────────┬───────────┘
            │
            ▼
     ┌──────────────┐
     │ Step 02      │
     │ Presentation │
     └──────┬───────┘
            │
            ▼
┌───────────────────────┐
│ First speaker presents│
│ (Dev or QA by mode)   │
└───────────┬───────────┘
            │
            ▼
     ┌──────────────┐
     │ Step 03      │◄──────┐
     │ Dialogue Loop│       │
     └──────┬───────┘       │
            │               │
            ▼               │
┌───────────────────────┐   │
│ Turn-based conversation│   │
│ Observer controls      │   │
│ Checkpoint each turn   │───┘
└───────────┬───────────┘
            │
            │ Consensus reached
            │ OR max turns
            ▼
     ┌──────────────┐
     │ Step 04      │
     │ Synthesis    │
     └──────┬───────┘
            │
            ▼
┌───────────────────────┐
│ Generate output doc   │
│ Both agents sign off  │
└───────────┬───────────┘
            │
            ▼
     ┌──────────────┐
     │ Step 05      │
     │ Session Close│
     └──────┬───────┘
            │
            ▼
┌───────────────────────┐
│ Save to docs/qa/logs/ │
│ Update memory         │
│ Display summary       │
└───────────────────────┘
```

---

## Observer Controls

### During Dialogue

| Command | Action |
|---------|--------|
| `[Enter]` | Continue to next turn |
| `@qa: <msg>` | Inject message as QA |
| `@dev: <msg>` | Inject message as Dev |
| `@guide: <msg>` | Facilitator note |
| `*skip` | Skip to synthesis |
| `*exit` | End session |
| `*auto` | Switch to auto mode |
| `*manual` | Switch to manual mode |
| `*save` | Force checkpoint |
| `*resume` | Resume from checkpoint |

---

## Dialogue Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| **manual** | Wait after each turn | Default, full control |
| **auto** | Agents dialogue automatically | Quick generation |
| **semi-auto** | Auto with pause at decisions | Balanced |

---

## Output Templates

| Mode | Output Type | Template |
|------|-------------|----------|
| testplan | Test Plan | `templates/test-plan-template.md` |
| bug | Bug Report | `templates/bug-report-template.md` |
| review | Review Report | `templates/code-review-template.md` |

Additional templates:
- `test-case-template.md` - Individual test case (GWT)
- `meeting-minutes-template.md` - Session transcript

---

## Memory System

### Files
- `memory/context.md` - Current state, preferences
- `memory/learnings.md` - Patterns discovered
- `memory/sessions.md` - Session history

### Updates
- **On session start:** Load context
- **On session end:** Update all memory files
- **On pattern discovery:** Add to learnings

---

## Knowledge Auto-Loading

### By Mode
| Mode | Always Load | On Demand |
|------|-------------|-----------|
| testplan | 01-testing-strategies | 03-testability-review |
| bug | 02-bug-reporting-guide | 01-testing-strategies |
| review | 03-testability-review | 01, 02 |

### By Keyword
- "edge case" → 01-testing-strategies
- "severity", "priority" → 02-bug-reporting-guide
- "mock", "inject" → 03-testability-review

---

## Checkpoint System

- Auto-save after each turn
- Resume with `*resume` command
- Archive to `memory/checkpoints/` on session close

---

## Session Output Location

```yaml
# User-facing outputs (git tracked)
output_locations:
  user_outputs: "docs/qa/"
  subdirs:
    - logs/            # Session outputs
    - test-plans/      # Test plan documents
    - bug-reports/     # Bug reports

# Agent internals (optional git)
agent_memory: ".microai/agents/microai/teams/dev-qa/memory/"

# File naming pattern
naming_pattern: "{YYYY-MM-DD}-{mode}-{topic-slug}.md"
```

**Output Directory Structure:**
```
docs/qa/
├── logs/
│   └── {YYYY-MM-DD}-testplan-{topic-slug}.md
├── test-plans/
│   └── {YYYY-MM-DD}-{feature}-test-plan.md
└── bug-reports/
    └── {YYYY-MM-DD}-{issue}-bug-report.md
```

---

## Quick Start

```bash
# Test Plan mode
/microai:dev-qa-session user authentication feature

# Bug Triage mode
/microai:dev-qa-session bug: login fails on Safari

# Code Review mode
/microai:dev-qa-session review: PR #123 payment refactor
```

---

## Best Practices

### For QA
- Ask "what if" questions
- Provide concrete reproduction steps
- Focus on risk-based prioritization
- Cite evidence, not opinions

### For Developer
- Explain technical constraints clearly
- Be open to feedback
- Suggest test scenarios proactively
- Address security concerns directly

### For Observer
- Let agents dialogue naturally
- Intervene only when needed
- Use `@guide` for redirection
- Use `*skip` for time-boxing
