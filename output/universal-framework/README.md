# 🚀 Universal Execution Framework v2.1

> Tích hợp OKR + First Principles + Type-Aware Processing + Complete Execution + Validation thành một hệ thống executable bởi LLM Agents.

---

## ⭐ What's New in v2.1

| Feature | Description |
|---------|-------------|
| **Complete Execution** | ALL tasks executed - không còn MVP/LEAN filtering |
| **Phase-Based Flow** | FOUNDATION → BUILD → ENHANCE → FINALIZE |
| **Project Type System** | Auto-classify projects (UI, API, Algorithm) |
| **Type-Specific Questions** | Framework tự hỏi đúng câu hỏi cho từng loại project |
| **VALIDATOR Agent** | Quality gates tại 3 checkpoints |
| **Enhanced HANDOFF** | Complete, self-contained document với exact specifications |
| **Visual Fidelity** | UI projects có exact design tokens, không còn "assume" |

---

## Philosophy Change v2.1

```
v1.0 (LEAN/MVP): "Do less, but what matters" → Có thể bỏ sót features
v2.1 (Complete): "Do everything, in optimal order" → Đầy đủ, quality cao
```

**Why the change:**
- MVP approach có thể loại bỏ features quan trọng
- 80/20 filtering dựa trên assumptions, không phải requirements
- Output phải COMPLETE, không phải "minimum viable"
- Real projects cần đầy đủ features để hoạt động đúng

---

## Quick Start

### Cho LLM Agents (Auto Mode)

```yaml
# Invoke orchestrator with project input
input:
  name: "My Project"
  description: "What you want to achieve"
  success_criteria: "What success looks like"
  # Optional but recommended:
  fidelity_level: "functional"  # prototype | functional | polished | realistic
  references: "Link to reference images/docs"

# Pipeline v2.1 với Complete Execution
pipeline:
  [CLASSIFY] → DEFINER → DECOMPOSER → PRIORITIZER → SEQUENCER
           ↓
  [PRE-VALIDATE] → [GENERATE HANDOFF] → EXECUTOR
           ↓
  [MID-VALIDATE] → [POST-VALIDATE] → REVIEWER

# Output: HANDOFF.md ready for Claude Code execution
```

### Cho con người (Manual Mode)

```
1. CLASSIFY:   Xác định project type (UI/API/Algorithm)
2. DEFINE:     "Project thành công khi ___" + 3 KRs + type-specific questions
3. DECOMPOSE:  Chia task đến khi ≤2h + inject mandatory tasks từ type
4. PRIORITIZE: Phase assignment (FOUNDATION/BUILD/ENHANCE/FINALIZE)
5. SEQUENCE:   Xác định dependencies, tạo complete timeline
6. VALIDATE:   Pre-execute validation gate
7. HANDOFF:    Generate complete execution document
8. EXECUTE:    Làm ALL tasks theo HANDOFF specs
9. VALIDATE:   Post-execute validation gate
10. REVIEW:    Final review, learnings
```

---

## Directory Structure v2.1

```
universal-framework/
├── README.md                     # This file
├── agents/
│   ├── 00-orchestrator.md        # Master coordinator v2.1
│   ├── 01-definer.md             # OKR + Classification v2.0
│   ├── 02-decomposer.md          # Task breakdown + Type tasks v2.0
│   ├── 03-prioritizer.md         # ⭐ v2.1: Complete execution ordering
│   ├── 04-sequencer.md           # ⭐ v2.1: Complete timeline
│   ├── 05-executor.md            # Task execution
│   ├── 06-reviewer.md            # Quality & learnings
│   ├── 07-checkpoint-protocol.md # Mandatory save protocol
│   └── 08-validator.md           # Quality gates
├── types/                        # Project type configs
│   ├── registry.yaml             # Type classification registry
│   ├── ui-project.yaml           # UI project requirements
│   ├── api-project.yaml          # API project requirements
│   └── algorithm-project.yaml    # Algorithm project requirements
├── templates/
│   └── HANDOFF-v2.md             # Complete handoff template
├── examples/
│   └── HANDOFF-casio-fx880-v2.md # Complete working example
├── sessions/
│   └── ...
└── projects/
    └── casio-fx880-calculator/   # Example project
```

---

## 🎯 Project Type System

Framework v2.1 tự động classify project và apply requirements tương ứng:

### Supported Types

| Type | Detection Keywords | Mandatory Tasks |
|------|-------------------|-----------------|
| **UI** | giao diện, app, web, dashboard, calculator | Visual refs, Design tokens, Component specs |
| **API** | REST, GraphQL, backend, server, endpoint | API contract, Data models, Error catalog |
| **Algorithm** | thuật toán, xử lý, tính toán, ML | I/O spec, Test cases, Complexity analysis |
| **Documentation** | tài liệu, guide, spec | Structure, Audience, Format |
| **Hybrid** | Multiple types detected | Combined requirements |

### Fidelity Levels

| Level | Description | UI Requirements |
|-------|-------------|-----------------|
| **prototype** | POC, chỉ cần hoạt động | Basic layout |
| **functional** | MVP, hoạt động đúng | Clean styling, consistent |
| **polished** | Production-ready | Professional design |
| **realistic** | Giống thật, chi tiết cao | Exact visual replication, reference images REQUIRED |

---

## 📋 Execution Phases (NEW in v2.1)

Thay vì MVP filtering, tasks được phân vào 4 phases:

```
┌─────────────────────────────────────────────────────────────┐
│  PHASE 1: FOUNDATION (30% tasks)                            │
│  Core structure, design system, critical paths              │
│  Examples: Visual refs, Design tokens, HTML structure       │
├─────────────────────────────────────────────────────────────┤
│  PHASE 2: BUILD (30% tasks)                                 │
│  Main features, business logic                              │
│  Examples: Components, Calculations, Functions              │
├─────────────────────────────────────────────────────────────┤
│  PHASE 3: ENHANCE (25% tasks)                               │
│  Polish, UX improvements                                    │
│  Examples: States, Animations, Edge cases                   │
├─────────────────────────────────────────────────────────────┤
│  PHASE 4: FINALIZE (15% tasks)                              │
│  Validation, testing, cleanup                               │
│  Examples: Visual comparison, Testing, Documentation        │
└─────────────────────────────────────────────────────────────┘
```

**Key difference from MVP:**
- MVP: "Do only essential tasks" → Some tasks eliminated
- Phases: "Do ALL tasks in optimal order" → Nothing eliminated

---

## 📋 Agent Pipeline v2.1

```
                          ┌─────────────┐
                          │  VALIDATOR  │
                          │  (3 Gates)  │
                          └──────┬──────┘
                                 │
┌────────────────────────────────┼────────────────────────────┐
│                                ▼                            │
│  User Input → [CLASSIFY] → DEFINER → [SAVE]                 │
│                    │           │                            │
│                    │    ┌──────┴──────┐                     │
│                    └────┤ TYPE CONFIG │                     │
│                         └──────┬──────┘                     │
│                                │                            │
│            DECOMPOSER ← ───────┘                            │
│                │                                            │
│                ▼                                            │
│           PRIORITIZER v2.1 (Phase Assignment)               │
│                │                                            │
│                ▼                                            │
│           SEQUENCER v2.1 (Complete Timeline)                │
│                │                                            │
│         ┌──────┴──────┐                                     │
│         │  GATE 1     │                                     │
│         │  PASSED?    │                                     │
│         └──────┬──────┘                                     │
│                │ YES                                        │
│                ▼                                            │
│    [GENERATE HANDOFF]                                       │
│                │                                            │
│                ▼                                            │
│           EXECUTOR                                          │
│                │                                            │
│    ┌───────────┼───────────┐                                │
│    │           │           │                                │
│ [MID-VAL]  [MID-VAL]  [POST-VAL]                            │
│   25%        50%        100%                                │
│                │                                            │
│         ┌──────┴──────┐                                     │
│         │  GATE 2     │                                     │
│         │  PASSED?    │                                     │
│         └──────┬──────┘                                     │
│                │ YES                                        │
│                ▼                                            │
│            REVIEWER                                         │
│                │                                            │
│                ▼                                            │
│           [REPORT]                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📄 HANDOFF Document

Output cuối cùng của Framework là **HANDOFF.md** - tài liệu hoàn chỉnh có thể bàn giao cho Claude Code thực thi.

### HANDOFF Requirements:
- ✅ No [FILL] placeholders - tất cả values đã điền
- ✅ Type-specific sections included
- ✅ EXACT values (hex codes, px, etc.) - không assume
- ✅ ALL tasks included (complete execution)
- ✅ Verification checklist
- ✅ Can be executed WITHOUT modification

### Example (UI Project):
```markdown
## Design Tokens (EXACT VALUES)

:root {
  --body-bg: #1a1a2e;          /* Exact from reference */
  --display-bg: #a8b5a0;       /* LCD green */
  --btn-number-bg: #f0f0f0;    /* Light gray */
  ...
}

## Execution Phases

FOUNDATION (8h): TASK-VR-001 → TASK-DS-001 → TASK-HTML-001
BUILD (6h): TASK-BTN-001 → TASK-CALC-001
ENHANCE (4h): TASK-STATE-001 → TASK-ANIM-001
FINALIZE (2h): TASK-VAL-001

## Verification Checklist

□ Body color matches reference (#1a1a2e)
□ Display has LCD green tint (#a8b5a0)
□ All 5 button types styled correctly
□ Layout matches reference layout diagram
```

---

## ⚡ Complete vs MVP Execution

### Problem with MVP (v1.0)
```
User: "Build calculator like Casio FX-880"
MVP approach:
  → Identify "essential" tasks (subjective)
  → Cut "nice-to-have" (may be important)
  → Output: Working but incomplete calculator
```

### Solution with Complete Execution (v2.1)
```
User: "Build calculator like Casio FX-880"
Complete approach:
  → Classify ALL tasks by phase
  → Execute FOUNDATION first (core structure)
  → Execute BUILD (functionality)
  → Execute ENHANCE (polish)
  → Execute FINALIZE (validation)
  → Output: Complete, polished calculator
```

---

## ⭐ CRITICAL: Checkpoint Protocol

```
⚠️ EVERY PHASE MUST SAVE OUTPUT TO FILE
⚠️ NO PROCEEDING WITHOUT VERIFIED CHECKPOINT
⚠️ VALIDATION GATES MUST PASS BEFORE EXECUTION
⚠️ IF INTERRUPTED, CAN RESUME FROM LAST CHECKPOINT
```

### Project Output Structure v2.1
```
{project}/
├── phases/
│   ├── 00-define/
│   │   ├── okr.yaml
│   │   ├── classification.yaml
│   │   └── phase-complete.yaml
│   ├── 01-decompose/
│   │   ├── tasks.yaml
│   │   └── phase-complete.yaml
│   ├── 02-prioritize/
│   │   ├── execution-order.yaml    # ← Changed from mvp-scope.yaml
│   │   └── phase-complete.yaml
│   ├── 03-sequence/
│   │   ├── execution-plan.yaml
│   │   └── phase-complete.yaml
│   ├── 04-execute/
│   │   ├── progress.yaml
│   │   └── phase-complete.yaml
│   └── 05-review/
│       └── project-report.yaml
├── validation/
│   ├── pre-execute.yaml
│   ├── mid-execute-25.yaml
│   ├── mid-execute-50.yaml
│   └── post-execute.yaml
├── references/
├── tasks/
├── logs/
├── sessions/
├── deliverables/
└── HANDOFF.md
```

---

## The Formula v2.1

```
SUCCESS = CLEAR GOAL × COMPLETE TASKS × OPTIMAL ORDER × VALIDATE × ITERATE
```

| Component | Description |
|-----------|-------------|
| **CLEAR GOAL** | 1 Objective + 3 KRs + Type-specific requirements |
| **COMPLETE TASKS** | ALL tasks decomposed, NONE eliminated |
| **OPTIMAL ORDER** | FOUNDATION → BUILD → ENHANCE → FINALIZE |
| **VALIDATE** | 3 validation gates (Pre/Mid/Post Execute) |
| **ITERATE** | Learn and improve |

---

## Key Metrics v2.1

| Metric | Formula | Target |
|--------|---------|--------|
| **Completion Rate** | Done Tasks / Total Tasks | 100% (complete execution) |
| **Validation Pass Rate** | Checks Passed / Total Checks | > 95% |
| **Visual Fidelity** | Match Score vs Reference | > 90% (UI projects) |
| **Phase Completion** | Phases Completed / 4 | 100% |
| **First-Time Pass** | (Done - Rework) / Total | > 80% |

---

## Usage Examples

### Example 1: UI Project (Realistic Fidelity)

```yaml
input:
  name: "Casio FX-880 Calculator"
  description: "Xây dựng ứng dụng máy tính với giao diện giống máy tính thật"
  success_criteria: "Calculator hoạt động và trông giống Casio FX-880"
  fidelity_level: "realistic"
  references:
    - "reference-images/casio-fx880-front.png"

# Framework will:
# 1. Classify as UI project
# 2. Ask for exact color codes
# 3. Require reference images
# 4. Generate HANDOFF with exact visual specs
# 5. Execute ALL tasks in 4 phases
# 6. Validate output matches reference ±5%
```

### Example 2: API Project

```yaml
input:
  name: "User Authentication API"
  description: "REST API cho login/register với JWT"
  success_criteria: "Secure authentication flow"

# Framework will:
# 1. Classify as API project
# 2. Ask for endpoint list
# 3. Require error code definitions
# 4. Generate HANDOFF with API contract
# 5. Execute ALL endpoints (no shortcuts)
# 6. Validate all endpoints implemented
```

---

## Getting Started v2.1

### Step 1: Read the Orchestrator v2.1
```
agents/00-orchestrator.md
```

### Step 2: Understand Type System
```
types/registry.yaml          # How types are classified
types/ui-project.yaml        # UI project requirements
types/api-project.yaml       # API project requirements
types/algorithm-project.yaml # Algorithm project requirements
```

### Step 3: Review Agents
```
agents/03-prioritizer.md     # v2.1: Complete execution ordering
agents/04-sequencer.md       # v2.1: Complete timeline
agents/08-validator.md       # Quality gates
```

### Step 4: Use HANDOFF Template
```
templates/HANDOFF-v2.md      # Complete handoff format
examples/HANDOFF-casio-fx880-v2.md  # Working example
```

### Step 5: Run with Your Project
```
Provide project input → Framework classifies → Asks type questions
→ Generates complete HANDOFF → Execute ALL tasks → Validate → Deliver
```

---

## Methodology Integration v2.1

| Source | Contribution | Phase |
|--------|--------------|-------|
| **OKR** | Clear goals & metrics | Define |
| **First Principles** | Break assumptions | Decompose |
| **Type-Driven** | Type-specific quality | All phases |
| **Complete Execution** | No task elimination | Prioritize, Execute |
| **Kaizen** | Continuous improvement | Review |

**Removed from v2.1:**
- ~~LEAN~~ (caused incomplete output)
- ~~80/20~~ (subjective filtering)
- ~~MVP~~ (missing features)

---

## Credits

Framework v2.1 designed through Deep Thinking Team Session với 9 legendary minds.

**Core Improvements v2.1:**
- Complete Execution philosophy
- Phase-based ordering
- No task elimination
- Full quality assurance

---

*"Framework v2.1: Complete execution, optimal order, highest quality."*
