# Deep Thinking Team - Architecture v4.0

> "Maximum Parallelism, Minimum Waste, Comprehensive Knowledge"

---

## What's New in v4.0

```yaml
v4_features:
  knowledge_layer:
    - "7 Thinking Frameworks documented"
    - "Master Question Bank (100+ questions)"
    - "Agent Collaboration Patterns"
    - "Phase Integration Patterns"
    - "Quick Reference Card"

  frameworks:
    - "01-socratic-method.md"
    - "02-first-principles.md"
    - "03-mental-models.md"
    - "04-problem-solving.md"
    - "05-synthesis.md"
    - "06-algorithm-analysis.md"
    - "07-architecture.md"

  thinking:
    - "seven-frameworks.md"
    - "patterns-by-problem.md"

  patterns:
    - "agent-collaboration.md"
    - "phase-integration.md"
```

---

## Team Composition (20 Members)

### Core Infrastructure (2)
| Role | Agent | Function |
|------|-------|----------|
| 🎼 **Orchestrator** | `maestro` | Điều phối, quyết định gọi ai, parallel execution |
| 📝 **Secretary** | `scribe` | Silent mode, documentation, task tracking |

### Thinkers Division (7) - Original Titans
| # | Agent | Persona | Domain |
|---|-------|---------|--------|
| 1 | 🔮 `socrates` | Socrates | Deep Questions, Assumptions |
| 2 | 🧬 `aristotle` | Aristotle | Logic & Structure |
| 3 | ⚡ `musk` | Elon Musk | First Principles, 10x Thinking |
| 4 | 🔬 `feynman` | Richard Feynman | Simplification, Teaching |
| 5 | 🎭 `munger` | Charlie Munger | Mental Models, Inversion |
| 6 | 📐 `polya` | George Polya | Problem-Solving Methodology |
| 7 | 🎨 `davinci` | Leonardo da Vinci | Synthesis, Connections |

### Builders Division (8) - Tech Legends
| # | Agent | Persona | Domain |
|---|-------|---------|--------|
| 8 | 🐧 `linus` | Linus Torvalds | Systems, Code Quality |
| 9 | 🔷 `dijkstra` | Edsger Dijkstra | Algorithms, Correctness Proofs |
| 10 | 📚 `knuth` | Donald Knuth | Algorithm Analysis, Rigor |
| 11 | 🎮 `carmack` | John Carmack | Performance, Hardware Mastery |
| 12 | 🔄 `beck` | Kent Beck | TDD, XP, Feedback Loops |
| 13 | 🏛️ `fowler` | Martin Fowler | Architecture, Trade-offs |
| 14 | 👨‍💻 `unclebob` | Robert C. Martin | Clean Code, SOLID |
| 15 | 🧘 `hickey` | Rich Hickey | Simplicity, Immutability |

### Executors Division (2) - Business Titans
| # | Agent | Persona | Domain |
|---|-------|---------|--------|
| 16 | 📦 `bezos` | Jeff Bezos | Customer Obsession, Scale |
| 17 | 🍎 `jobs` | Steve Jobs | Product Vision, Simplicity |

### Visionaries Division (3) - Industry Leaders
| # | Agent | Persona | Domain |
|---|-------|---------|--------|
| 18 | 💻 `jensen` | Jensen Huang | AI/GPU, Platform Vision |
| 19 | 🔧 `grove` | Andy Grove | Execution, Strategic Paranoia |
| 20 | 🚀 `thiel` | Peter Thiel | Contrarian Strategy, Monopoly |

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    DEEP THINKING TEAM v4.0                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│                         KNOWLEDGE LAYER                                  │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐           │
│  │Frameworks│ │Questions│ │Thinking │ │Patterns │ │Reference│           │
│  │(7 files) │ │(1 file) │ │(2 files)│ │(2 files)│ │(1 file) │           │
│  └────┬─────┘ └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘           │
│       └────────────┴──────────┼──────────┴────────────┘                 │
│                               ↓                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                        AGENT LAYER                               │    │
│  │  ┌─────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌──────────┐      │    │
│  │  │Core │ │Thinkers │ │Builders │ │Executors│ │Visionaries│      │    │
│  │  │ (2) │ │   (7)   │ │   (8)   │ │   (2)   │ │    (3)   │      │    │
│  │  └──┬──┘ └────┬────┘ └────┬────┘ └────┬────┘ └─────┬────┘      │    │
│  │     └─────────┴───────────┴───────────┴────────────┘            │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                               ↓                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                      WORKFLOW LAYER                              │    │
│  │  ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐   │    │
│  │  │ 5-Phase    │ │  3 Modes   │ │  Parallel  │ │  Quality   │   │    │
│  │  │ Protocol   │ │Quick/Std/  │ │ Execution  │ │   Gates    │   │    │
│  │  │            │ │Comprehensive│ │            │ │            │   │    │
│  │  └────────────┘ └────────────┘ └────────────┘ └────────────┘   │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 7 Thinking Frameworks

```yaml
frameworks:
  1_socratic_questioning:
    purpose: "Làm rõ vấn đề và giả định"
    lead_agent: socrates
    support: aristotle
    file: "knowledge/frameworks/01-socratic-method.md"

  2_first_principles:
    purpose: "Phân tách đến chân lý cơ bản"
    lead_agent: musk
    support: feynman
    file: "knowledge/frameworks/02-first-principles.md"

  3_mental_models:
    purpose: "Áp dụng multi-disciplinary thinking"
    lead_agent: munger
    support: grove
    file: "knowledge/frameworks/03-mental-models.md"

  4_problem_solving:
    purpose: "Giải quyết có hệ thống"
    lead_agent: polya
    support: dijkstra
    file: "knowledge/frameworks/04-problem-solving.md"

  5_synthesis:
    purpose: "Tổng hợp và kết nối"
    lead_agent: davinci
    support: all
    file: "knowledge/frameworks/05-synthesis.md"

  6_algorithm_analysis:
    purpose: "Phân tích thuật toán và hiệu năng"
    lead_agents: [knuth, dijkstra, carmack]
    file: "knowledge/frameworks/06-algorithm-analysis.md"

  7_architecture:
    purpose: "Quyết định kiến trúc"
    lead_agents: [fowler, linus]
    file: "knowledge/frameworks/07-architecture.md"
```

---

## 5-Phase Protocol

```
PHASE 1: UNDERSTAND
├── Agents: Socrates + Aristotle
├── Framework: Socratic Questioning
├── Output: Problem Definition Document
└── Gate: Problem Clarity

PHASE 2: DECONSTRUCT
├── Agents: Musk + Feynman
├── Framework: First Principles
├── Output: Fundamental Truths + Simple Model
└── Gate: Feynman Test (can explain simply?)

PHASE 3: CHALLENGE
├── Agents: Munger + Grove
├── Framework: Mental Models + Inversion
├── Output: Failure Modes + Risks + Biases
└── Gate: Pre-mortem Complete

PHASE 4: SOLVE
├── Agents: Polya + Builders (contextual)
├── Framework: Problem-Solving + Algorithm/Architecture
├── Output: Verified Solution Steps
└── Gate: Solution Completeness

PHASE 5: SYNTHESIZE
├── Agents: Da Vinci + All
├── Framework: Synthesis
├── Output: Blueprint + Action Plan
└── Gate: All quality checks passed
```

---

## Collaboration Patterns

### Pattern 1: Debate
```yaml
description: "Hai agents tranh luận về vấn đề"
structure: "Protagonist vs Antagonist → Synthesis"
example: "Musk (first principles) vs Fowler (trade-offs)"
output: "Balanced perspective"
```

### Pattern 2: Handoff
```yaml
description: "Agent chuyển giao cho agent khác"
structure: "Agent A → Agent B → Agent C"
example: "Socrates → Aristotle → Polya → Builders"
output: "Progressively refined solution"
```

### Pattern 3: Parallel
```yaml
description: "Nhiều agents phân tích song song"
structure: "All agents → Da Vinci synthesizes"
example: "Phase 4: Multiple builders analyze simultaneously"
output: "Multi-perspective analysis"
```

### Pattern 4: Challenge
```yaml
description: "Agent challenge kết quả của agent khác"
structure: "Agent A proposes → Agent B challenges"
example: "Beck implements → Dijkstra verifies correctness"
output: "Strengthened solution"
```

---

## Agent Selection Matrix

### By Problem Type

| Problem Type | Primary | Secondary | Optional |
|--------------|---------|-----------|----------|
| **Unclear problem** | socrates, aristotle | feynman | - |
| **Need breakthrough** | musk, feynman | davinci | thiel |
| **Risk analysis** | munger, grove | aristotle | - |
| **Architecture** | fowler, linus | dijkstra | hickey |
| **Performance** | carmack, knuth | linus | dijkstra |
| **Product design** | jobs, davinci | bezos | feynman |
| **Strategy** | thiel, bezos | grove | munger |
| **Execution** | grove, beck | polya | - |
| **Code quality** | linus, unclebob | beck, fowler | hickey |
| **Algorithm** | dijkstra, knuth | carmack | polya |

### By Urgency

| Mode | Duration | Agents | Use For |
|------|----------|--------|---------|
| Quick | 5-15 min | 2-3 | Tactical decisions |
| Standard | 30-60 min | 4-6 | Normal analysis |
| Comprehensive | 2-4 hrs | All relevant | Strategic decisions |

---

## Directory Structure v4.0

```
deep-thinking-team/
├── ARCHITECTURE.md              # This file
├── README.md                    # Public documentation
├── workflow.md                  # Orchestration logic
│
├── agents/
│   ├── core/                    # Infrastructure
│   │   ├── maestro.md          # 🎼 Orchestrator
│   │   └── scribe.md           # 📝 Secretary
│   │
│   ├── thinkers/               # 7 Thinking Agents
│   │   ├── socrates.md         # 🔮 Deep Questions
│   │   ├── aristotle.md        # 🧬 Logic
│   │   ├── musk.md             # ⚡ First Principles
│   │   ├── feynman.md          # 🔬 Simplification
│   │   ├── munger.md           # 🎭 Mental Models
│   │   ├── polya.md            # 📐 Problem-Solving
│   │   └── davinci.md          # 🎨 Synthesis
│   │
│   ├── builders/               # 8 Tech Legends
│   │   ├── linus.md            # 🐧 Systems Master
│   │   ├── dijkstra.md         # 🔷 Algorithms
│   │   ├── knuth.md            # 📚 Analysis
│   │   ├── carmack.md          # 🎮 Performance
│   │   ├── beck.md             # 🔄 TDD
│   │   ├── fowler.md           # 🏛️ Architecture
│   │   ├── unclebob.md         # 👨‍💻 Clean Code
│   │   └── hickey.md           # 🧘 Simplicity
│   │
│   ├── executors/              # 2 Business Titans
│   │   ├── bezos.md            # 📦 Customer Obsession
│   │   └── jobs.md             # 🍎 Product Genius
│   │
│   └── visionaries/            # 3 Industry Leaders
│       ├── jensen.md           # 💻 AI Vision
│       ├── grove.md            # 🔧 Execution
│       └── thiel.md            # 🚀 Contrarian
│
├── knowledge/                   # ✨ NEW IN v4.0
│   ├── frameworks/             # 7 Thinking frameworks
│   │   ├── 01-socratic-method.md
│   │   ├── 02-first-principles.md
│   │   ├── 03-mental-models.md
│   │   ├── 04-problem-solving.md
│   │   ├── 05-synthesis.md
│   │   ├── 06-algorithm-analysis.md
│   │   └── 07-architecture.md
│   │
│   ├── thinking/               # Framework selection guides
│   │   ├── seven-frameworks.md
│   │   └── patterns-by-problem.md
│   │
│   ├── questions/              # Question banks
│   │   └── master-question-bank.md
│   │
│   ├── patterns/               # Collaboration patterns
│   │   ├── agent-collaboration.md
│   │   └── phase-integration.md
│   │
│   └── references/             # Quick references
│       └── quick-reference.md
│
├── templates/
│   ├── solution-blueprint.md   # Full output
│   ├── quick-decision.md       # Fast decisions
│   └── session-summary.md      # Session logs
│
├── sessions/                   # Session logs
│   └── .gitkeep
│
└── workspace/                  # Working documents
    └── .gitkeep
```

---

## Quality Gates

### Phase Transition Gates

```yaml
gate_1_to_2:
  name: "Problem Clarity"
  checks:
    - "Problem statement specific and measurable"
    - "Assumptions identified"
    - "Scope defined"

gate_2_to_3:
  name: "First Principles"
  checks:
    - "Fundamental truths identified"
    - "Feynman test passed"
    - "Not reasoning by analogy"

gate_3_to_4:
  name: "Risk Awareness"
  checks:
    - "5+ failure modes identified"
    - "Mitigations defined"
    - "Pre-mortem completed"

gate_4_to_5:
  name: "Solution Completeness"
  checks:
    - "Steps verified"
    - "Edge cases handled"
    - "Rollback plan exists"
```

---

## Commands

### Quick Start

```bash
# Standard invocation
/microai:deep-thinking "Your problem here"

# Quick mode (2-3 agents)
/microai:deep-thinking:quick "Urgent question"

# Specific agent
/microai:deep-thinking:socrates "Question to clarify"
/microai:deep-thinking:musk "First principles analysis"
```

### Maestro Commands

```yaml
@maestro start "{problem}"       # Start session
@maestro urgent "{problem}"      # Quick mode
@maestro deep "{problem}"        # Comprehensive mode
@maestro call [agent1, agent2] "{question}"
@maestro status
@maestro summary
```

---

## Metrics & Success Criteria

```yaml
success_metrics:
  problem_understanding:
    owner: "Socrates + Aristotle"
    measure: "Clarity score 1-5"

  solution_quality:
    owner: "Dijkstra + Carmack"
    measure: "Correctness + Performance"

  strategic_alignment:
    owner: "Thiel + Bezos"
    measure: "Customer value + Competitive advantage"

  execution_readiness:
    owner: "Grove + Beck"
    measure: "Actionable steps defined"

  synthesis_completeness:
    owner: "Da Vinci"
    measure: "All perspectives integrated"
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-31 | Initial 7 Titans |
| 2.0 | 2025-12-31 | +6 agents, Orchestrator, Secretary, Parallel Execution |
| 3.0 | 2026-01-01 | +7 agents (total 20), 5 Divisions, 5-Phase Protocol |
| **4.0** | **2026-01-04** | **Knowledge Layer: 7 Frameworks, Question Bank, Collaboration Patterns, Phase Integration, Quick Reference** |

---

*"The whole is greater than the sum of its parts."* - Aristotle

*"Simplicity is the ultimate sophistication."* - Leonardo da Vinci
