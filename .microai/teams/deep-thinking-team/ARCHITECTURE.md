# Deep Thinking Team - Architecture v3.0

> "Maximum Parallelism, Minimum Waste"

---

## Team Composition (20 Members)

### Core Infrastructure (2)
| Role | Agent | Function |
|------|-------|----------|
| 🎭 **Orchestrator** | `maestro` | Điều phối, quyết định gọi ai, parallel execution |
| 📝 **Secretary** | `scribe` | Silent mode, documentation, task tracking |

### Thinkers Division (7) - Original Titans
| # | Agent | Persona | Domain |
|---|-------|---------|--------|
| 1 | 🔮 `socrates` | Socrates | Deep Questions |
| 2 | 🧬 `aristotle` | Aristotle | Logic & Structure |
| 3 | ⚡ `musk` | Elon Musk | First Principles |
| 4 | 🔬 `feynman` | Richard Feynman | Simplification |
| 5 | 🎭 `munger` | Charlie Munger | Mental Models |
| 6 | 📐 `polya` | George Polya | Problem-Solving |
| 7 | 🎨 `davinci` | Leonardo da Vinci | Synthesis |

### Builders Division (8) - Tech Legends
| # | Agent | Persona | Domain |
|---|-------|---------|--------|
| 8 | 🐧 `linus` | Linus Torvalds | Systems, Code Quality |
| 9 | 🏗️ `dijkstra` | Edsger Dijkstra | Algorithms, Correctness |
| 10 | 📚 `knuth` | Donald Knuth | Analysis, Literate Programming |
| 11 | 🎮 `carmack` | John Carmack | Performance, Hardware Mastery |
| 12 | 🔄 `beck` | Kent Beck | TDD, XP, Feedback Loops |
| 13 | 🏛️ `fowler` | Martin Fowler | Architecture, Trade-offs |
| 14 | 🧹 `unclebob` | Robert C. Martin | Clean Code, SOLID |
| 15 | 🧘 `hickey` | Rich Hickey | Simplicity, Immutability |

### Executors Division (2) - Business Titans
| # | Agent | Persona | Domain |
|---|-------|---------|--------|
| 16 | 🚀 `bezos` | Jeff Bezos | Customer Obsession, Scale |
| 17 | 🍎 `jobs` | Steve Jobs | Product, Simplicity |

### Visionaries Division (3) - Industry Leaders
| # | Agent | Persona | Domain |
|---|-------|---------|--------|
| 18 | 💚 `jensen` | Jensen Huang | AI/GPU, Platform Vision |
| 19 | 📊 `grove` | Andy Grove | Execution, Paranoia |
| 20 | 🎯 `thiel` | Peter Thiel | Contrarian Strategy, Monopoly |

---

## Parallel Execution Model

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         MAESTRO (Orchestrator)                          │
│                     "Decides WHO works, WHEN, HOW"                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  INPUT: Problem Statement                                               │
│     ↓                                                                   │
│  CLASSIFY: What type of problem?                                        │
│     │                                                                   │
│     ├─→ Strategic Decision  → [jobs, bezos, grove, munger]             │
│     ├─→ Technical Design    → [linus, dijkstra, feynman, musk]         │
│     ├─→ Deep Understanding  → [socrates, aristotle]                    │
│     ├─→ Execution Planning  → [bezos, grove, polya]                    │
│     └─→ Full Analysis       → All relevant agents (parallel)           │
│                                                                         │
│  PARALLEL GROUPS:                                                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                     │
│  │   GROUP A   │  │   GROUP B   │  │   GROUP C   │                     │
│  │  (Thinkers) │  │  (Builders) │  │ (Executors) │                     │
│  │ Run in //   │  │ Run in //   │  │ Run in //   │                     │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘                     │
│         └────────────────┼────────────────┘                            │
│                          ↓                                              │
│                    SYNTHESIS (davinci)                                  │
│                          ↓                                              │
│                    OUTPUT (scribe)                                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Agent Selection Matrix

### By Problem Type

| Problem Type | Primary | Secondary | Optional |
|--------------|---------|-----------|----------|
| **Strategy** | bezos, jobs, thiel | munger, grove | musk |
| **Architecture** | fowler, linus, dijkstra | feynman, musk | hickey |
| **Product** | jobs, bezos | feynman, thiel | socrates |
| **Performance** | carmack, linus, dijkstra | knuth | polya |
| **Innovation** | musk, jobs, thiel | davinci, jensen | feynman |
| **Risk** | munger, grove | aristotle, thiel | bezos |
| **Scale** | bezos, jensen | linus, carmack | grove |
| **Code Quality** | unclebob, linus, beck | fowler, hickey | knuth |
| **Testing** | beck, unclebob | fowler | dijkstra |
| **Refactoring** | fowler, unclebob, beck | hickey | linus |
| **Simplicity** | hickey, feynman, jobs | unclebob | fowler |
| **Understanding** | socrates, aristotle | feynman, knuth | polya |
| **Execution** | grove, polya | bezos | linus |
| **Algorithms** | dijkstra, knuth | carmack | polya |
| **Contrarian** | thiel, musk | munger | grove |

### By Urgency

| Urgency | Strategy |
|---------|----------|
| **Critical (< 1h)** | 2-3 agents max, direct to solution |
| **Normal (1-4h)** | 4-5 agents, standard flow |
| **Deep (> 4h)** | Full team available, comprehensive |

---

## Directory Structure v2.0

```
deep-thinking-team/
├── ARCHITECTURE.md              # This file
├── README.md                    # Public documentation
├── workflow.md                  # Orchestration logic
│
├── agents/
│   ├── core/                    # Infrastructure
│   │   ├── maestro.md          # 🎭 Orchestrator
│   │   └── scribe.md           # 📝 Secretary
│   │
│   ├── thinkers/               # Original 7 Titans
│   │   ├── socrates.md         # 🔮 Deep Questions
│   │   ├── aristotle.md        # 🧬 Logic
│   │   ├── musk.md             # ⚡ First Principles
│   │   ├── feynman.md          # 🔬 Simplification
│   │   ├── munger.md           # 🎭 Mental Models
│   │   ├── polya.md            # 📐 Problem-Solving
│   │   └── davinci.md          # 🎨 Synthesis
│   │
│   ├── builders/               # Tech Legends
│   │   ├── linus.md            # 🐧 Systems Master
│   │   └── dijkstra.md         # 🏗️ Algorithms
│   │
│   ├── executors/              # Business Titans
│   │   ├── bezos.md            # 🚀 Customer Obsession
│   │   └── jobs.md             # 🍎 Product Genius
│   │
│   └── visionaries/            # Industry Leaders
│       ├── jensen.md           # 💚 AI Vision
│       └── grove.md            # 📊 Execution
│
├── knowledge/
│   ├── frameworks/             # Thinking frameworks
│   │   ├── 01-socratic-method.md
│   │   ├── 02-first-principles.md
│   │   ├── 03-mental-models.md
│   │   └── index.yaml
│   │
│   ├── patterns/               # Problem patterns
│   │   ├── strategic-decisions.md
│   │   ├── technical-design.md
│   │   └── execution-planning.md
│   │
│   └── references/             # Quick references
│       └── agent-selection.yaml
│
├── memory/
│   ├── context.md              # Current session
│   ├── insights.md             # Accumulated wisdom
│   └── decisions.md            # Past decisions
│
├── templates/
│   ├── solution-blueprint.md   # Full output
│   ├── quick-decision.md       # Fast decisions
│   └── session-summary.md      # Session logs
│
├── sessions/                   # Session logs (scribe manages)
│   └── .gitkeep
│
└── workspace/                  # Working documents (scribe manages)
    └── .gitkeep
```

---

## Communication Protocol

### Maestro Commands

```yaml
# Start session
@maestro start "{problem}"

# Specify urgency
@maestro urgent "{problem}"      # Critical mode
@maestro deep "{problem}"        # Full analysis

# Direct agent call
@maestro call [linus, jobs] "{question}"

# Status
@maestro status
@maestro summary
```

### Scribe Commands (Silent by default)

```yaml
# Activate scribe
@scribe on                       # Enable active mode
@scribe off                      # Return to silent

# Document requests
@scribe note "{insight}"         # Quick note
@scribe decision "{decision}"    # Log decision
@scribe summary                  # Generate summary

# File management
@scribe save "{filename}"        # Save current work
@scribe organize                 # Organize workspace
```

---

## Execution Modes

### Mode 1: Quick (2-3 agents)

```
Problem → Maestro → [2-3 relevant agents] → Solution
Time: 5-15 minutes
Use for: Tactical decisions, quick questions
```

### Mode 2: Standard (4-6 agents)

```
Problem → Maestro → Classify
                 → [Parallel Group A] ─┐
                 → [Parallel Group B] ─┼→ Synthesis → Solution
                                      ─┘
Time: 30-60 minutes
Use for: Most problems
```

### Mode 3: Comprehensive (All relevant)

```
Problem → Maestro → Full Classification
                 → Phase 1 (Understand): [socrates, aristotle] ──┐
                 → Phase 2 (Deconstruct): [musk, feynman, linus] ┼→ Parallel
                 → Phase 3 (Challenge): [munger, grove] ─────────┤
                 → Phase 4 (Solve): [polya, dijkstra, bezos] ────┘
                 → Phase 5 (Synthesize): [davinci, jobs]
                 → Output: [scribe]
Time: 2-4 hours
Use for: Critical decisions, complex problems
```

---

## Quality Gates

### Before Each Phase

```yaml
gate_check:
  - problem_clear: "Is the problem well-defined?"
  - agents_appropriate: "Are selected agents right?"
  - dependencies_met: "Are prerequisites done?"
```

### After Each Phase

```yaml
phase_complete:
  - insights_captured: "Key insights documented?"
  - contradictions_resolved: "Any conflicts?"
  - ready_for_next: "Can proceed?"
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-31 | Initial 7 Titans |
| 2.0 | 2025-12-31 | +6 agents, Orchestrator, Secretary, Parallel Execution |

---

*"The whole is greater than the sum of its parts."* - Aristotle
