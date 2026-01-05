# Diagram-Team - Architecture v1.0

> "Maximum Parallelism, Accurate Visualization, Deep Verification"

---

## Team Composition (10 Agents)

### Core Infrastructure (2)

| Role | Agent | Function |
|------|-------|----------|
| 🎭 **Orchestrator** | `maestro` | Điều phối workflow, tổng hợp outputs |
| 🔍 **Analyzer** | `explorer` | Phân tích codebase, extract metadata |

### Diagrammers Division (7) - Parallel Workers

| # | Agent | Icon | Persona | Diagram Type | Mermaid Syntax |
|---|-------|------|---------|--------------|----------------|
| 1 | `architect` | 🏛️ | System Architect | Architecture | C4Context, C4Container |
| 2 | `sequencer` | ⏱️ | API Designer | Sequence | sequenceDiagram |
| 3 | `classifier` | 📦 | OOP Expert | Class/Entity | classDiagram |
| 4 | `modeler` | 🗄️ | DBA | ERD | erDiagram |
| 5 | `mapper` | 📂 | DevOps | Directory | graph TD |
| 6 | `logician` | 🧠 | Algorithm Expert | Logic Flow | flowchart |
| 7 | `designer` | 🎨 | UX Designer | UI/UX | stateDiagram |

### Verification Division (1)

| Role | Agent | Function |
|------|-------|----------|
| ✅ **Validator** | `validator` | Cross-check diagrams với codebase |

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          DIAGRAM-TEAM v1.0                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        INPUT LAYER                                   │   │
│  │  User Request: "Analyze project at /path/to/project"                │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                   ↓                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                      ORCHESTRATION LAYER                             │   │
│  │  🎭 Maestro - Coordinates all phases, manages state                 │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                   ↓                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                      EXPLORATION LAYER                               │   │
│  │  🔍 Explorer - Analyzes codebase, extracts metadata                 │   │
│  │  Output: exploration-report.md                                       │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                   ↓                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                      GENERATION LAYER (Parallel)                     │   │
│  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐          │   │
│  │  │ 🏛️  │ │ ⏱️  │ │ 📦  │ │ 🗄️  │ │ 📂  │ │ 🧠  │ │ 🎨  │          │   │
│  │  │Arch │ │ Seq │ │Class│ │ ERD │ │ Dir │ │Logic│ │UI/UX│          │   │
│  │  └─────┘ └─────┘ └─────┘ └─────┘ └─────┘ └─────┘ └─────┘          │   │
│  │  Output: 7 Mermaid diagrams (.mmd)                                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                   ↓                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                      VERIFICATION LAYER                              │   │
│  │  ✅ Validator - Cross-checks diagrams against actual code           │   │
│  │  Output: verification-report.md                                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                   ↓                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                       OUTPUT LAYER                                   │   │
│  │  output/{project}/diagrams/                                          │   │
│  │  ├── diagrams/ (7 .mmd files)                                       │   │
│  │  ├── verification/ (reports)                                         │   │
│  │  └── session-summary.md                                              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 4-Phase Protocol

```
PHASE 1: EXPLORE
├── Agent: Explorer
├── Duration: 2-5 min
├── Input: Project path
├── Output: exploration-report.md
└── Signal: exploration_complete

PHASE 2: GENERATE (Parallel)
├── Agents: 7 Diagrammers (simultaneous)
├── Duration: 3-8 min
├── Input: exploration-report.md
├── Output: 7 Mermaid diagrams
├── Sync: Wait for all 7 to complete
└── Signal: all_diagrams_ready

PHASE 3: VERIFY
├── Agent: Validator
├── Duration: 2-4 min
├── Input: All diagrams + codebase
├── Output: verification-report.md
└── Signal: verification_complete

PHASE 4: AGGREGATE
├── Agent: Maestro
├── Duration: 1-2 min
├── Input: All outputs
├── Output: Final package + README
└── Signal: workflow_complete
```

---

## Deep Verification System

### Verification Checks

| Check ID | Name | Description | Method |
|----------|------|-------------|--------|
| V1 | `entity_exists` | Entities in diagram exist in code | Grep class/function names |
| V2 | `relationship_valid` | Arrows/connections accurate | Trace import statements |
| V3 | `completeness` | No major components missed | Compare with exploration |
| V4 | `naming_match` | Names match exactly | Case-sensitive comparison |
| V5 | `api_accuracy` | API endpoints exist | Match router/handler defs |
| V6 | `erd_accuracy` | DB tables/columns exist | Compare schema/ORM models |

### Mismatch Handling

```yaml
on_mismatch:
  MISSING_ENTITY:
    severity: warning
    action: "Flag entity not found"
    suggestion: "Remove from diagram or verify spelling"

  INVALID_RELATIONSHIP:
    severity: warning
    action: "Flag connection not verified"
    suggestion: "Review actual import/call path"

  INCOMPLETE:
    severity: info
    action: "List missing components"
    suggestion: "Consider adding to diagram"

  NAME_MISMATCH:
    severity: warning
    action: "Flag naming inconsistency"
    suggestion: "Use exact name from code"
```

### Verification Output Format

```yaml
verification_report:
  diagram: "architecture.mmd"
  status: "pass|warning|fail"
  score: 95  # percentage

  verified_entities:
    - name: "UserService"
      found_at: "internal/service/user.go:15"
      status: "verified"

  mismatches:
    - type: "MISSING_ENTITY"
      entity: "CacheService"
      diagram_location: "line 12"
      suggestion: "Entity not found - verify name"

  suggestions:
    - "Consider adding PaymentService (found in codebase)"
```

---

## Parallel Execution Configuration

```yaml
parallel:
  enabled: true
  max_workers: 7

  parallelizable_groups:
    - name: diagram_generation
      steps:
        - step-03a-architecture
        - step-03b-sequence
        - step-03c-class
        - step-03d-erd
        - step-03e-directory
        - step-03f-logic
        - step-03g-uiux
      sync_point: all_diagrams_ready
      merge_strategy: wait_all

  worker_config:
    timeout_per_worker: 300000  # 5 min
    retry_on_failure: true
    max_retries: 2
```

---

## Communication Protocol

### Signal Topics

| Topic | Publisher | Subscribers | Trigger |
|-------|-----------|-------------|---------|
| `exploration_trigger` | Maestro | Explorer | User starts |
| `exploration_complete` | Explorer | All Diagrammers | Exploration done |
| `generation_trigger` | Maestro | Diagrammers | After exploration |
| `diagram_created` | Each Diagrammer | Maestro | Diagram complete |
| `all_diagrams_ready` | Maestro | Validator | All 7 done |
| `verification_trigger` | Maestro | Validator | Sync complete |
| `verification_complete` | Validator | Maestro | Verification done |
| `aggregation_complete` | Maestro | - | Final output ready |
| `workflow_complete` | Maestro | - | Session ends |

### Message Format

```yaml
message:
  id: "{uuid}"
  timestamp: "{ISO8601}"
  topic: "{topic_name}"
  sender: "{agent_id}"
  payload: {}
```

---

## Directory Structure

```
diagram-team/
├── ARCHITECTURE.md              # This file
├── README.md                    # Public documentation
├── workflow.md                  # Main orchestration
│
├── agents/
│   ├── core/
│   │   ├── maestro-agent.md    # 🎭 Orchestrator
│   │   └── explorer-agent.md   # 🔍 Analyzer
│   │
│   ├── diagrammers/
│   │   ├── architect-agent.md  # 🏛️ Architecture
│   │   ├── sequencer-agent.md  # ⏱️ Sequence
│   │   ├── classifier-agent.md # 📦 Class
│   │   ├── modeler-agent.md    # 🗄️ ERD
│   │   ├── mapper-agent.md     # 📂 Directory
│   │   ├── logician-agent.md   # 🧠 Logic
│   │   └── designer-agent.md   # 🎨 UI/UX
│   │
│   └── verification/
│       └── validator-agent.md  # ✅ Verification
│
├── steps/
│   ├── step-01-init.md
│   ├── step-02-explore.md
│   ├── step-03a-architecture.md  # Parallel
│   ├── step-03b-sequence.md      # Parallel
│   ├── step-03c-class.md         # Parallel
│   ├── step-03d-erd.md           # Parallel
│   ├── step-03e-directory.md     # Parallel
│   ├── step-03f-logic.md         # Parallel
│   ├── step-03g-uiux.md          # Parallel
│   ├── step-04-verify.md
│   ├── step-05-aggregate.md
│   └── step-06-summary.md
│
├── knowledge/
│   ├── shared/
│   │   ├── mermaid-syntax.md
│   │   ├── diagram-best-practices.md
│   │   └── verification-patterns.md
│   │
│   ├── exploration/
│   │   ├── tech-stack-detection.md
│   │   └── component-patterns.md
│   │
│   ├── diagrams/
│   │   ├── c4-model.md
│   │   ├── sequence-patterns.md
│   │   ├── class-diagram-patterns.md
│   │   ├── erd-patterns.md
│   │   ├── directory-patterns.md
│   │   ├── flowchart-patterns.md
│   │   └── uiux-flow-patterns.md
│   │
│   └── verification/
│       ├── verification-checklist.md
│       └── mismatch-resolution.md
│
├── templates/
│   ├── exploration-report-template.md
│   ├── diagram-template.mmd
│   ├── verification-report-template.md
│   ├── session-summary-template.md
│   └── readme-template.md
│
├── communication/
├── checkpoints/
├── kanban/
├── logs/
├── memory/
└── sessions/
```

---

## Agent Selection by Diagram Type

| Diagram Need | Agent | Mermaid Type | Key Focus |
|--------------|-------|--------------|-----------|
| System overview | architect | C4Context | Components, boundaries |
| API flows | sequencer | sequenceDiagram | Request/response |
| OOP structure | classifier | classDiagram | Classes, interfaces |
| Database schema | modeler | erDiagram | Tables, relationships |
| Project layout | mapper | graph TD | Directories, files |
| Algorithm logic | logician | flowchart | Decisions, loops |
| User journeys | designer | stateDiagram | Screens, transitions |

---

## Quality Gates

### Phase Transition Gates

```yaml
gate_1_to_2:
  name: "Exploration Complete"
  checks:
    - exploration_report_exists
    - tech_stack_identified
    - components_mapped

gate_2_to_3:
  name: "All Diagrams Ready"
  checks:
    - 7_diagrams_created
    - valid_mermaid_syntax
    - no_empty_diagrams

gate_3_to_4:
  name: "Verification Complete"
  checks:
    - all_diagrams_verified
    - report_generated
    - issues_documented
```

---

## Metrics

```yaml
success_metrics:
  exploration:
    components_found: "> 0"
    relationships_mapped: "> 0"

  generation:
    diagrams_created: "7"
    syntax_valid: "100%"

  verification:
    accuracy_score: "> 80%"
    entities_verified: "> 90%"

  overall:
    total_duration: "< 15 min"
    user_satisfaction: "high"
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-04 | Initial release with 10 agents, 7 diagram types, deep verification |

---

*"Một hình ảnh đáng giá ngàn dòng code."*
