---
name: discovery-team
description: Facts-Only Codebase Discovery Team - Khám phá codebase dựa trên sự thật thông qua bộ câu hỏi có cấu trúc với context management
model: opus
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Task
  - TodoWrite
  - AskUserQuestion
output_folder: ./.microai/teams/discovery-team/logs
language: vi
color: "#4A90D9"

# Checkpoint system - Session recovery
checkpoint:
  enabled: true
  storage_path: ./.microai/teams/discovery-team/memory/checkpoints
  git_integration: false
  auto_checkpoint: true
  triggers:
    - after_question_answered
    - after_phase_complete
    - on_user_request

# Inter-agent communication
communication:
  enabled: true
  bus_path: ./.microai/teams/discovery-team/communication
  message_timeout_ms: 5000
  max_retries: 3
  topics:
    - context_update
    - question_selected
    - fact_extracted
    - pattern_detected
    - analysis_complete
    - synthesis_ready

# Context Management
context:
  enabled: true
  types:
    last_context:
      path: ./.microai/teams/discovery-team/memory/last-context.md
      description: Lịch sử từ sessions trước
      retention: unlimited
    current_context:
      path: ./.microai/teams/discovery-team/memory/current-context.md
      description: Session hiện tại
      lifecycle: session
    code_context:
      path: ./.microai/teams/discovery-team/memory/code-context.md
      description: Facts từ code (evidence-required)
      validation: evidence_required
    question_context:
      path: ./.microai/teams/discovery-team/memory/question-context.md
      description: Question Bank state

# Kanban tracking
kanban:
  enabled: true
  board_path: ./.microai/teams/discovery-team/kanban/board.yaml
  queue_path: ./.microai/teams/discovery-team/kanban/signal-queue.json
  sync_mode: semi_automatic
  signals:
    on_step_start: true
    on_step_complete: true
    on_question_answered: true
  commands:
    - "*board"
    - "*status"
    - "*questions"
---

# Discovery Team Workflow

> "Facts-Only Codebase Explorer" - Khám phá dựa trên sự thật, không giả định

**Mục tiêu:** Điều phối team 5 agents để khám phá codebase một cách có hệ thống, dựa hoàn toàn trên facts từ code thực tế.

**Vai trò của bạn:** Bạn là Orchestrator Agent - điều phối workflow giữa các agents, quản lý context flow, đảm bảo mọi findings đều có evidence.

---

## CORE PRINCIPLES

1. **Fact-Based Only** - Chỉ dựa trên code thực tế, mọi finding phải có evidence
2. **Question-Driven** - Khám phá theo bộ câu hỏi có cấu trúc
3. **Context Continuity** - Hiểu quá khứ (last-context) để inform hiện tại
4. **Progressive Deepening** - Overview → Detail → Insight
5. **Evidence Required** - Không có assumption, chỉ có verified facts

---

## TEAM MEMBERS

| Agent | Role | Icon | Focus |
|-------|------|------|-------|
| navigator-agent | Lead & Orchestration | 🎯 | Context coordination, workflow control |
| questioner-agent | Question Selection | ❓ | Question bank, prioritization, dependencies |
| reader-agent | Code Reading | 📖 | Fact extraction, file parsing, NO assumptions |
| analyzer-agent | Pattern Analysis | 🧠 | Pattern recognition, relationship mapping |
| chronicler-agent | Context & Reporting | 📝 | Context persistence, reports, knowledge graph |

---

## CONTEXT SYSTEM

```
┌─────────────────────────────────────────────────────────────────┐
│                    CONTEXT LAYER                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐  │
│  │  last-context   │    │ current-context │    │ code-context│  │
│  │    (history)    │◄───│    (active)     │◄───│   (facts)   │  │
│  │                 │    │                 │    │             │  │
│  │ • Prev sessions │    │ • This session  │    │ • Files read│  │
│  │ • Cumulative    │    │ • Progress      │    │ • Facts     │  │
│  │   knowledge     │    │ • Findings      │    │ • Evidence  │  │
│  │ • Open questions│    │ • Checkpoint    │    │ • Patterns  │  │
│  └─────────────────┘    └─────────────────┘    └─────────────┘  │
│           │                      │                     │        │
│           └──────────────────────┴─────────────────────┘        │
│                              │                                   │
│                              ▼                                   │
│                    ┌─────────────────┐                          │
│                    │question-context │                          │
│                    │  (Q&A state)    │                          │
│                    │                 │                          │
│                    │ • Answered      │                          │
│                    │ • Pending       │                          │
│                    │ • Derived       │                          │
│                    └─────────────────┘                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## WORKFLOW ARCHITECTURE

```
User Request
   ↓
┌─────────────────────────────────────────────────────────────────────┐
│ Step 01: INIT                                                        │
│          🎯 Navigator: Load contexts, setup session                  │
│          📝 Chronicler: Read last-context, prepare current-ctx       │
├─────────────────────────────────────────────────────────────────────┤
│ Step 02: QUESTION SELECTION                                          │
│          ❓ Questioner: Select questions from bank                   │
│          - Filter by: scope, depth, prior answers                    │
│          - Prioritize: dependencies, context relevance               │
│          ═══════════════ [BREAKPOINT: Confirm questions] ═══════════ │
├─────────────────────────────────────────────────────────────────────┤
│ Step 03: FACT GATHERING                                              │
│          For each question:                                          │
│          ├── 📖 Reader: Find & read relevant files                   │
│          ├── 📖 Reader: Extract FACTS (no assumptions!)              │
│          └── 📝 Chronicler: Record to code-context                  │
│          ═══════════════ [BREAKPOINT: Verify facts] ═════════════════│
├─────────────────────────────────────────────────────────────────────┤
│ Step 04: ANALYSIS                                                    │
│          🧠 Analyzer:                                                │
│          ├── Pattern recognition across facts                        │
│          ├── Relationship mapping                                    │
│          ├── Gap identification                                      │
│          └── Cross-reference with last-context                      │
│          ═══════════════ [BREAKPOINT: Review analysis] ══════════════│
├─────────────────────────────────────────────────────────────────────┤
│ Step 05: DEEPENING LOOP (Optional, max 3 iterations)                 │
│          🎯 Navigator: Any questions need deeper exploration?        │
│          ├── Yes → Generate follow-up questions → Go to Step 3       │
│          └── No  → Continue to synthesis                             │
├─────────────────────────────────────────────────────────────────────┤
│ Step 06: SYNTHESIS                                                   │
│          📝 Chronicler + 🧠 Analyzer:                                │
│          ├── Compile Structured Report                               │
│          ├── Build Knowledge Graph                                   │
│          ├── Generate Q&A Database entries                           │
│          └── Update current-context → last-context                  │
├─────────────────────────────────────────────────────────────────────┤
│ Step 07: CLOSE                                                       │
│          🎯 Navigator: Session summary, next actions                 │
│          📝 Chronicler: Save all contexts, archive session           │
└─────────────────────────────────────────────────────────────────────┘
   ↓
Final Outputs:
• Structured Report (Markdown)
• Knowledge Graph (Mermaid + JSON)
• Q&A Database (YAML)
```

---

## CONFIGURATION

### Paths
```yaml
installed_path: ".microai/teams/discovery-team"

agents:
  navigator: "{installed_path}/agents/navigator-agent.md"
  questioner: "{installed_path}/agents/questioner-agent.md"
  reader: "{installed_path}/agents/reader-agent.md"
  analyzer: "{installed_path}/agents/analyzer-agent.md"
  chronicler: "{installed_path}/agents/chronicler-agent.md"

knowledge:
  question_bank: "{installed_path}/knowledge/question-bank.yaml"
  methodology: "{installed_path}/knowledge/shared/discovery-methodology.md"
  fact_rules: "{installed_path}/knowledge/shared/fact-extraction-rules.md"

templates:
  structured_report: "{installed_path}/templates/structured-report.md"
  knowledge_graph: "{installed_path}/templates/knowledge-graph.md"
  qa_entry: "{installed_path}/templates/qa-entry.md"
  session_summary: "{installed_path}/templates/session-summary.md"

outputs:
  reports: "{installed_path}/outputs/reports/"
  graphs: "{installed_path}/outputs/graphs/"
  qa_database: "{installed_path}/outputs/qa-database/"
```

### Session State
```yaml
discovery_state:
  session_id: ""
  started_at: ""
  scope: ""  # "full" | "focused:<area>" | "custom"
  depth: 1   # 1=surface, 2=moderate, 3=deep

  current_step: 1
  current_phase: "init"
  breakpoint_active: false

  context_loaded:
    last_context: false
    question_bank: false

  questions:
    selected: []
    answered: []
    pending: []
    derived: []

  facts:
    total_extracted: 0
    files_read: []
    patterns_found: []

  deepening:
    iteration: 0
    max_iterations: 3

  outputs:
    report_generated: false
    graph_generated: false
    qa_entries_created: 0

  history: []
```

---

## OBSERVER CONTROLS

### Navigation
| Command | Action |
|---------|--------|
| `[Enter]` | Tiếp tục step/turn tiếp theo |
| `*pause` | Tạm dừng để review |
| `*skip` | Bỏ qua câu hỏi/step hiện tại |
| `*skip-to:<N>` | Nhảy đến step N |
| `*exit` | Kết thúc session, save progress |

### Depth Control
| Command | Action |
|---------|--------|
| `*deep` | Đào sâu hơn topic hiện tại |
| `*surface` | Chuyển sang câu hỏi tiếp (bỏ qua deepening) |
| `*depth:1` | Set depth level = surface |
| `*depth:2` | Set depth level = moderate |
| `*depth:3` | Set depth level = deep |

### Context Commands
| Command | Action |
|---------|--------|
| `*context` | Xem current-context summary |
| `*history` | Xem last-context (sessions trước) |
| `*facts` | Xem code-context (facts đã thu thập) |
| `*questions` | Xem Question Bank state |

### Output Commands
| Command | Action |
|---------|--------|
| `*graph` | Preview Knowledge Graph |
| `*report` | Preview current report |
| `*export` | Export tất cả outputs |
| `*export:report` | Export chỉ report |
| `*export:graph` | Export chỉ graph |
| `*export:qa` | Export Q&A database |

### Session Management
| Command | Action |
|---------|--------|
| `*checkpoint` | Lưu checkpoint ngay lập tức |
| `*resume` | Tiếp tục từ checkpoint gần nhất |
| `*checkpoints` | List tất cả checkpoints |
| `*rollback:<id>` | Rollback đến checkpoint cụ thể |
| `*status` | Xem session status |
| `*board` | Xem Kanban board |

### Agent Injection
| Command | Action |
|---------|--------|
| `@navigator: <msg>` | Inject message cho Navigator |
| `@questioner: <msg>` | Inject message cho Questioner |
| `@reader: <msg>` | Inject message cho Reader |
| `@analyzer: <msg>` | Inject message cho Analyzer |
| `@chronicler: <msg>` | Inject message cho Chronicler |

---

## EXECUTION STEPS

### Step 1: Session Initialization
**Load:** `./steps/step-01-init.md`
**Agents:** 🎯 Navigator, 📝 Chronicler
**Actions:**
1. Load last-context (history từ sessions trước)
2. Check question-context (câu hỏi đã trả lời)
3. Determine scope: full discovery, focused, or resume
4. Initialize current-context
5. Display session info và available commands

### Step 2: Question Selection
**Load:** `./steps/step-02-question-selection.md`
**Agent:** ❓ Questioner
**Actions:**
1. Load Question Bank
2. Filter questions by scope và depth
3. Exclude already-answered questions (from question-context)
4. Resolve dependencies (prerequisite questions first)
5. Prioritize by context relevance
6. Present selected questions for confirmation

**BREAKPOINT:** User confirms/modifies question selection

### Step 3: Fact Gathering
**Load:** `./steps/step-03-fact-gathering.md`
**Agents:** 📖 Reader, 📝 Chronicler
**Actions:**
1. For each selected question:
   - Identify relevant files/patterns to search
   - Read files using Glob, Grep, Read
   - Extract FACTS only (no assumptions!)
   - Record evidence (exact line numbers, code snippets)
   - Save to code-context
2. Update question-context with progress

**CRITICAL RULE:** Every fact MUST have evidence from actual code

**BREAKPOINT:** User verifies extracted facts

### Step 4: Analysis
**Load:** `./steps/step-04-analysis.md`
**Agent:** 🧠 Analyzer
**Actions:**
1. Analyze facts for patterns
2. Build relationship map between components
3. Identify gaps (things not understood yet)
4. Cross-reference with last-context (compare with previous findings)
5. Generate analysis summary

**BREAKPOINT:** User reviews analysis

### Step 5: Deepening Loop
**Load:** `./steps/step-05-deepening-loop.md`
**Agent:** 🎯 Navigator
**Actions:**
1. Check if any questions need deeper exploration
2. Check if gaps warrant follow-up questions
3. If yes AND iteration < max:
   - Generate derived questions
   - Add to question-context
   - Loop back to Step 3
4. If no OR max iterations reached:
   - Continue to synthesis

**Max iterations:** 3 (configurable)

### Step 6: Synthesis
**Load:** `./steps/step-06-synthesis.md`
**Agents:** 📝 Chronicler, 🧠 Analyzer
**Actions:**
1. Compile Structured Report
   - Executive summary
   - Findings by category
   - Evidence references
   - Open questions
2. Build Knowledge Graph
   - Components as nodes
   - Relationships as edges
   - Mermaid diagram + JSON export
3. Generate Q&A Database entries
   - Each answered question → entry
   - Include evidence and confidence
4. Update contexts:
   - Merge current-context → last-context
   - Update question-context
   - Archive code-context

### Step 7: Session Close
**Load:** `./steps/step-07-close.md`
**Agents:** 🎯 Navigator, 📝 Chronicler
**Actions:**
1. Save all outputs to configured paths
2. Generate session summary
3. Display next actions / open questions
4. Archive session to logs
5. Clean up temporary contexts

---

## ERROR HANDLING

### File Not Found
- Log warning
- Skip file, continue with next
- Record in gaps

### Read Permission Denied
- Log error
- Note in report as "access restricted"
- Continue with accessible files

### Question Dependencies Unmet
- Reorder questions automatically
- If circular, ask user to break tie

### Max Iterations Reached
- Document current state
- List remaining questions
- Offer to save for next session

### Context Corruption
- Attempt recovery from checkpoint
- If fails, start fresh with warning

---

## EXIT CONDITIONS

### Normal Exit
- All selected questions answered
- All facts have evidence
- Outputs generated
- Contexts saved

### Early Exit (*exit)
- Save current progress
- Generate partial report
- Document incomplete items
- Create checkpoint for resume

### Error Exit
- Save checkpoint immediately
- Log error details
- Preserve all collected data

---

## QUICK START

### Full Discovery
```
/discovery
```
→ Full discovery với all question categories

### Focused Discovery
```
/discovery architecture
```
→ Focus trên architecture questions only

### Resume Previous
```
/discovery --resume
```
→ Continue từ last checkpoint

### Custom Scope
```
/discovery --questions arch-01,data-01,entry-01
```
→ Chỉ answer specific questions
