# Prompt Evolution Agent

Activate the Self-Evolving Prompt Agent (SEPA) - Agent tự động cải thiện prompt của chính nó.

<agent-activation CRITICAL="TRUE">
1. ĐỌC agent file: @.microai/agents/prompt-evolution-agent/agent.md
2. ĐỌC current state: @.microai/agents/prompt-evolution-agent/memory/context.md
3. ĐỌC scores history: @.microai/agents/prompt-evolution-agent/memory/scores.yaml
4. ĐỌC current version: @.microai/agents/prompt-evolution-agent/memory/versions/v001.md
5. THỰC THI activation protocol như trong agent.md
</agent-activation>

## Commands

| Command | Effect |
|---------|--------|
| `/prompt-evolution` | Show status và sẵn sàng execute |
| `/prompt-evolution status` | Detailed evolution stats |
| `/prompt-evolution evolve` | Force evolution cycle |
| `/prompt-evolution rollback` | Rollback to best version |
| `/prompt-evolution versions` | List all versions |

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│              SELF-EVOLVING PROMPT AGENT                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  EXECUTE TASK ────────────────────────────────────────────┐ │
│       │                                                    │ │
│       │ Use current prompt version                         │ │
│       ↓                                                    │ │
│  LOG METRICS ──────────────────────────────────────────┐  │ │
│       │                                                 │  │ │
│       │ Tool success, time, output quality              │  │ │
│       ↓                                                 │  │ │
│  CHECK TRIGGER ────────────────────────────────────┐   │  │ │
│       │                                             │   │  │ │
│       │ Every 3 executions                          │   │  │ │
│       ↓                                             │   │  │ │
│  ┌─────────────────────────────────────────────┐   │   │  │ │
│  │            EVOLUTION CYCLE                   │   │   │  │ │
│  │  1. Calculate score                          │   │   │  │ │
│  │  2. Check rollback conditions                │   │   │  │ │
│  │  3. Select mutation strategy                 │   │   │  │ │
│  │  4. Apply mutation                           │   │   │  │ │
│  │  5. Save new version                         │   │   │  │ │
│  └─────────────────────────────────────────────┘   │   │  │ │
│       │                                             │   │  │ │
│       ↓                                             │   │  │ │
│  REPEAT ←───────────────────────────────────────────┘   │  │ │
│                                                          │  │ │
└──────────────────────────────────────────────────────────┘  │
                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Key Features

- **Automatic Signals**: No human feedback needed
  - Tool success rate (35%)
  - Output quality (25%)
  - Efficiency (20%)
  - Error rate (15%)
  - Structure (5%)

- **8 Mutation Strategies**:
  - instruction_rephrase (LOW risk)
  - step_reorder (MEDIUM risk)
  - constraint_add (LOW risk)
  - constraint_remove (HIGH risk)
  - example_inject (LOW risk)
  - emphasis_shift (MEDIUM risk)
  - format_change (MEDIUM risk)
  - persona_adjust (LOW risk)

- **Safety Mechanisms**:
  - Keep last 5 versions
  - Auto-rollback on 2+ failures
  - Elite protection (best version never deleted)

## Files

```
.microai/agents/prompt-evolution-agent/
├── agent.md                    # Agent definition
├── knowledge/
│   ├── 01-mutation-strategies.md
│   ├── 02-scoring-rubric.md
│   └── 03-safety-protocols.md
├── memory/
│   ├── context.md              # Current state
│   ├── scores.yaml             # Version scores
│   ├── executions.jsonl        # Execution log
│   ├── evolution-log.md        # Evolution history
│   └── versions/
│       └── v001.md             # Base version
├── hooks/
│   └── post-execution.sh       # Metrics collection
└── scripts/
    ├── calculate-score.sh      # Scoring
    └── evolve.sh               # Evolution cycle
```

---

**ARGUMENTS**: Nếu có argument, xử lý như command (status, evolve, rollback, versions).

Nếu không có argument, hiển thị status và sẵn sàng thực hiện task.
