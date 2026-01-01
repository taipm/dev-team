# Deep Thinking Team - Workflow Orchestration

> "The Greatest Minds, One Problem"
> Đưa vấn đề lên, nhận giải pháp hoàn hảo đến mức triển khai thành công ngay lần đầu.

---

## Team Definition

```yaml
team: deep-thinking-team
version: "1.0"
description: |
  Super team của 7 thinkers vĩ đại nhất lịch sử,
  mỗi người đại diện cho một dimension of excellence.
  Kết hợp tư duy + kỹ năng + tri thức để giải quyết
  bất kỳ vấn đề nào một cách hoàn hảo.

model: opus
language: vi

output_location: ".microai/agents/microai/teams/deep-thinking-team/logs/"
```

---

## Team Composition: 7 Titans of Thought

```
┌─────────────────────────────────────────────────────────────────┐
│                    THE 7 TITANS                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  🔮 SOCRATES      - The Questioner    - Deep Questions         │
│  🧬 ARISTOTLE     - The Logician      - Logical Structure      │
│  ⚡ MUSK          - The Disruptor     - First Principles       │
│  🔬 FEYNMAN       - The Explainer     - Simplification         │
│  🎭 MUNGER        - The Sage          - Mental Models          │
│  📐 POLYA         - The Solver        - Problem-Solving        │
│  🎨 DA VINCI      - The Connector     - Creative Synthesis     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

| Agent | File | Role | Framework |
|-------|------|------|-----------|
| 🔮 Socrates | `agents/socrates.md` | Deep Questions | Socratic Method |
| 🧬 Aristotle | `agents/aristotle.md` | Logical Structure | Syllogistic Logic |
| ⚡ Musk | `agents/musk.md` | First Principles | Convention Breaking |
| 🔬 Feynman | `agents/feynman.md` | Simplification | Feynman Technique |
| 🎭 Munger | `agents/munger.md` | Mental Models | Latticework + Inversion |
| 📐 Polya | `agents/polya.md` | Problem-Solving | 4-Step Method |
| 🎨 Da Vinci | `agents/davinci.md` | Synthesis | Cross-Domain Connection |

---

## 5-Phase Deep Thinking Protocol

```
┌─────────────────────────────────────────────────────────────────┐
│                  5-PHASE PROTOCOL                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Phase 1: UNDERSTAND ─────────────────────────────────────────  │
│           Lead: Socrates + Aristotle                            │
│           "What is the REAL problem?"                           │
│                         ↓                                       │
│  Phase 2: DECONSTRUCT ────────────────────────────────────────  │
│           Lead: Musk + Feynman                                  │
│           "What are the FUNDAMENTAL truths?"                    │
│                         ↓                                       │
│  Phase 3: CHALLENGE ──────────────────────────────────────────  │
│           Lead: Munger                                          │
│           "How could this FAIL?"                                │
│                         ↓                                       │
│  Phase 4: SOLVE ──────────────────────────────────────────────  │
│           Lead: Polya                                           │
│           "What is the SYSTEMATIC solution?"                    │
│                         ↓                                       │
│  Phase 5: SYNTHESIZE ─────────────────────────────────────────  │
│           Lead: Da Vinci                                        │
│           "How does everything CONNECT?"                        │
│                         ↓                                       │
│  OUTPUT: Complete Solution Blueprint                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase Details

### Phase 1: UNDERSTAND (2-3 turns)

**Lead**: 🔮 Socrates
**Support**: 🧬 Aristotle

**Objective**: Làm rõ vấn đề thực sự, không phải triệu chứng

**Socrates' Questions**:
1. "Bạn đang cố giải quyết điều gì?"
2. "Tại sao đây là vấn đề?"
3. "Ai bị ảnh hưởng và họ thực sự muốn gì?"
4. "Bạn đã thử những gì? Tại sao không hiệu quả?"
5. "Nếu giải quyết được, thế giới sẽ khác thế nào?"

**Aristotle's Analysis**:
1. Categorize the problem (type, domain, scope)
2. Identify premises and conclusions
3. Map logical dependencies
4. Find contradictions in current thinking

**Output**:
```yaml
phase_1_output:
  true_problem: "{refined statement}"
  stakeholders: ["{who}"]
  constraints: ["{what}"]
  assumptions_exposed:
    - assumption: "{text}"
      status: "valid|invalid|uncertain"
  logical_structure:
    premises: ["{premise}"]
    conclusions: ["{conclusion}"]
```

---

### Phase 2: DECONSTRUCT (2-3 turns)

**Lead**: ⚡ Musk
**Support**: 🔬 Feynman

**Objective**: Phân rã đến sự thật cơ bản nhất, loại bỏ convention

**Musk's Questions**:
1. "Sự thật vật lý/logic cơ bản nhất ở đây là gì?"
2. "Tại sao mọi người đều làm theo cách này?"
3. "Nếu bắt đầu từ số 0, ta sẽ làm gì?"
4. "Chi phí thực sự từ raw materials/first principles là bao nhiêu?"
5. "Assumption nào đang giới hạn chúng ta?"

**Feynman's Simplification**:
1. "Giải thích vấn đề này cho trẻ 10 tuổi"
2. "Phần nào bạn không hiểu khi giải thích?"
3. "Ví dụ đơn giản nhất của vấn đề này?"
4. "Nếu sai, làm sao biết?"

**Output**:
```yaml
phase_2_output:
  fundamental_truths:
    - truth: "{text}"
      evidence: "{why true}"
  conventions_challenged:
    - convention: "{what everyone does}"
      why_wrong: "{reasoning}"
      better_approach: "{alternative}"
  simple_explanation: "{5-year-old version}"
  knowledge_gaps: ["{what we don't understand}"]
```

---

### Phase 3: CHALLENGE (2-3 turns)

**Lead**: 🎭 Munger
**Support**: Built-in Contrarian mode

**Objective**: Tìm mọi cách giải pháp có thể thất bại

**Munger's Inversion**:
1. "Điều gì sẽ GUARANTEE giải pháp này thất bại?"
2. "Nếu giải pháp này là thảm họa 6 tháng sau, nguyên nhân là gì?"
3. "Incentives của các bên liên quan là gì? Có aligned không?"
4. "Chúng ta đang mắc bias nào?"

**Mental Models Applied**:
| Model | Application |
|-------|-------------|
| Inversion | What would guarantee failure? |
| Second-Order Effects | What happens after the first effect? |
| Incentive Analysis | Who benefits? Who loses? |
| Circle of Competence | Are we in our domain? |
| Margin of Safety | What's our buffer for error? |

**Output**:
```yaml
phase_3_output:
  failure_modes:
    - mode: "{how it fails}"
      likelihood: "high|medium|low"
      prevention: "{how to prevent}"
  biases_identified:
    - bias: "{name}"
      how_affects: "{impact}"
      mitigation: "{what to do}"
  mental_models_insights:
    - model: "{name}"
      insight: "{what it reveals}"
  risk_assessment:
    overall: "high|medium|low"
    top_risks: ["{risk}"]
```

---

### Phase 4: SOLVE (3-4 turns)

**Lead**: 📐 Polya
**Support**: Deming PDSA (built-in)

**Objective**: Xây dựng giải pháp có hệ thống, từng bước

**Polya's 4 Steps**:

**Step 1: Understand the Problem** (already done in Phase 1)
- What are we asked to find?
- What data do we have?
- What conditions exist?

**Step 2: Devise a Plan**
- "Bài toán tương tự nào đã được giải?"
- "Có thể chia thành sub-problems không?"
- "Giải bài đơn giản hơn trước được không?"
- "Làm ngược từ kết quả mong muốn?"

**Step 3: Carry Out the Plan**
- Execute step by step
- Check each step
- If stuck, return to Step 2

**Step 4: Look Back**
- "Làm sao verify giải pháp đúng?"
- "Có cách nào khác không?"
- "Có thể generalize không?"

**Deming PDSA Integration**:
```
Plan → Do (small) → Study → Act
                ↑         ↓
                └─────────┘
```

**Output**:
```yaml
phase_4_output:
  solution_steps:
    - step: 1
      action: "{what to do}"
      inputs: ["{required}"]
      outputs: ["{produced}"]
      verification: "{how to check}"
      estimated_effort: "{time/resources}"
    - step: 2
      ...
  success_criteria:
    - criterion: "{what must be true}"
      measurement: "{how to measure}"
  contingency_plans:
    - scenario: "{if this happens}"
      response: "{do this}"
  iteration_plan:
    first_test: "{small scale test}"
    evaluation: "{how to evaluate}"
    scale_up: "{when to proceed}"
```

---

### Phase 5: SYNTHESIZE (1-2 turns)

**Lead**: 🎨 Da Vinci
**Support**: All agents contribute

**Objective**: Kết nối mọi thứ thành một whole đẹp và hoàn chỉnh

**Da Vinci's Principles**:

| Principle | Application |
|-----------|-------------|
| **Curiosita** | What else can we learn from this? |
| **Connessione** | How does this connect to everything? |
| **Sfumato** | What ambiguity can we embrace? |
| **Arte/Scienza** | Balance logic and creativity |

**Synthesis Questions**:
1. "Kết nối nào giữa các domains chưa ai thấy?"
2. "Giải pháp có đẹp và đơn giản không?"
3. "Mọi thứ có fit together elegantly không?"
4. "Còn insight nào ẩn giấu?"
5. "Execution plan có complete và actionable không?"

**All Agents Final Input**:
- 🔮 Socrates: "Còn question nào chưa được answer?"
- 🧬 Aristotle: "Logic có sound không?"
- ⚡ Musk: "Có innovation opportunity nào bỏ lỡ?"
- 🔬 Feynman: "Explanation có simple enough không?"
- 🎭 Munger: "Risk nào chưa được address?"
- 📐 Polya: "Plan có complete không?"

**Output**:
```yaml
phase_5_output:
  integrated_solution:
    summary: "{2-3 sentences}"
    key_insight: "{the breakthrough}"
  cross_domain_connections:
    - domains: ["{domain1}", "{domain2}"]
      connection: "{insight}"
  elegance_check:
    is_simple: true|false
    is_beautiful: true|false
    fits_together: true|false
  execution_blueprint:
    immediate: ["{next 24h}"]
    short_term: ["{week 1}"]
    milestones: ["{checkpoints}"]
  confidence_assessment:
    problem_understanding: "high|medium|low"
    solution_validity: "high|medium|low"
    execution_feasibility: "high|medium|low"
  open_questions: ["{remaining uncertainties}"]
```

---

## Session Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    SESSION FLOW                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  INIT                                                           │
│   │  └── Load team, read memory, detect problem type           │
│   ↓                                                             │
│  PHASE 1: UNDERSTAND (Socrates + Aristotle)                    │
│   │  └── 2-3 turns, observer can intervene                     │
│   ↓                                                             │
│  CHECKPOINT 1: Confirm problem understanding                    │
│   │  └── Observer: [continue] / [refine] / [restart]           │
│   ↓                                                             │
│  PHASE 2: DECONSTRUCT (Musk + Feynman)                         │
│   │  └── 2-3 turns                                             │
│   ↓                                                             │
│  CHECKPOINT 2: Confirm first principles                         │
│   │  └── Observer: [continue] / [go deeper] / [skip]           │
│   ↓                                                             │
│  PHASE 3: CHALLENGE (Munger)                                   │
│   │  └── 2-3 turns, adversarial mode                           │
│   ↓                                                             │
│  CHECKPOINT 3: Confirm risks addressed                          │
│   │  └── Observer: [continue] / [more challenges] / [skip]     │
│   ↓                                                             │
│  PHASE 4: SOLVE (Polya)                                        │
│   │  └── 3-4 turns, building solution                          │
│   ↓                                                             │
│  CHECKPOINT 4: Confirm solution complete                        │
│   │  └── Observer: [continue] / [iterate] / [restart phase]    │
│   ↓                                                             │
│  PHASE 5: SYNTHESIZE (Da Vinci + All)                          │
│   │  └── 1-2 turns, integration                                │
│   ↓                                                             │
│  OUTPUT: Generate Solution Blueprint                            │
│   │  └── Save to logs/, update memory                          │
│   ↓                                                             │
│  END                                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Observer Intervention Protocol

### During Any Phase

| Command | Action |
|---------|--------|
| `[Enter]` | Continue to next turn |
| `*pause` | Pause for discussion |
| `*skip` | Skip to next phase |
| `*back` | Return to previous phase |
| `*restart` | Restart current phase |
| `*exit` | End session, generate partial output |

### Agent Injection

| Command | Action |
|---------|--------|
| `@socrates "{message}"` | Inject question from Socrates |
| `@aristotle "{message}"` | Inject logical analysis |
| `@musk "{message}"` | Inject first principles challenge |
| `@feynman "{message}"` | Request simplification |
| `@munger "{message}"` | Inject mental model/inversion |
| `@polya "{message}"` | Inject problem-solving step |
| `@davinci "{message}"` | Inject creative connection |

### Mode Control

| Command | Action |
|---------|--------|
| `*auto` | Agents proceed automatically |
| `*manual` | Pause after each turn |
| `*focus:{topic}` | Focus on specific aspect |
| `*depth:deep` | Go deeper on current topic |
| `*depth:surface` | Move faster, less depth |

### Session Management

| Command | Action |
|---------|--------|
| `*save` | Save checkpoint |
| `*resume` | Resume from last checkpoint |
| `*summary` | Show current insights |
| `*status` | Show current phase and progress |

---

## Memory System

```
memory/
├── context.md       # Current session state
├── insights.md      # Accumulated insights
├── patterns.md      # Problem-solving patterns learned
└── sessions.md      # Past session summaries
```

### Context Tracking

```yaml
session:
  id: "{uuid}"
  problem: "{problem statement}"
  current_phase: 1-5
  current_turn: 0
  mode: "auto|manual"

  phase_outputs:
    phase_1: {output}
    phase_2: {output}
    ...

  insights_so_far:
    critical: []
    important: []
    interesting: []
```

---

## Knowledge Auto-Loading

```yaml
knowledge_loading:
  always_load:
    - knowledge/00-team-overview.md
    - knowledge/01-thinking-frameworks.md

  phase_based:
    phase_1:
      - knowledge/02-socratic-method.md
      - knowledge/03-aristotelian-logic.md
    phase_2:
      - knowledge/04-first-principles.md
      - knowledge/05-feynman-technique.md
    phase_3:
      - knowledge/06-mental-models.md
      - knowledge/07-inversion.md
    phase_4:
      - knowledge/08-polya-method.md
      - knowledge/09-pdsa-cycle.md
    phase_5:
      - knowledge/10-synthesis-patterns.md

  keyword_triggered:
    technical: [knowledge/11-technical-analysis.md]
    business: [knowledge/12-business-frameworks.md]
    creative: [knowledge/13-creative-methods.md]
```

---

## Output Artifacts

### 1. Solution Blueprint (Primary)
`logs/{YYYY-MM-DD}-{problem-slug}-solution.md`

### 2. Session Transcript
`logs/{YYYY-MM-DD}-{problem-slug}-transcript.md`

### 3. Insights Index
`logs/{YYYY-MM-DD}-{problem-slug}-insights.md`

### 4. Execution Checklist
`logs/{YYYY-MM-DD}-{problem-slug}-checklist.md`

---

## Quality Guarantees

### What Makes a "Perfect" Solution

| Criterion | Verification |
|-----------|--------------|
| **Complete** | All phases completed, no gaps |
| **Logical** | Aristotle validates reasoning |
| **Fundamental** | Musk confirms first principles |
| **Simple** | Feynman can explain to child |
| **Robust** | Munger found no fatal flaws |
| **Systematic** | Polya verified step-by-step |
| **Elegant** | Da Vinci confirms beauty |
| **Actionable** | Immediate next steps defined |

### Confidence Scoring

```yaml
confidence:
  minimum_to_ship:
    problem_understanding: "high"
    solution_validity: "medium"
    execution_feasibility: "medium"

  if_below_threshold:
    - Request more information
    - Suggest iteration
    - Flag uncertainties
```

---

## Example Session

```
User: "Startup của tôi có 100 users nhưng churn rate 80%. Làm sao giữ được users?"

🔮 Socrates: "80% churn có nghĩa 80 trong 100 users rời đi.
   Câu hỏi đầu tiên: Họ rời đi SAU bao lâu? Ngay sau signup?
   Sau 1 tuần? Sau khi dùng feature X?"

User: "Đa số rời sau 3 ngày đầu"

🧬 Aristotle: "Vậy vấn đề nằm ở onboarding/activation,
   không phải long-term value. Premise: Users không tìm thấy
   value trong 3 ngày đầu → Họ rời đi."

... [continues through all 5 phases] ...

🎨 Da Vinci [Final Synthesis]:
"Kết nối: Vấn đề không phải churn, mà là TIME-TO-VALUE quá dài.
Solution Blueprint:
1. Redesign onboarding cho 'aha moment' trong 10 phút đầu
2. Remove friction: Bỏ 5 bước signup → 2 bước
3. Quick win: Cho user thấy benefit ngay lần đầu dùng
4. Follow-up: Day 1, Day 2, Day 3 personalized nudges

Execution: Start with Step 1, measure Day 3 retention, iterate."
```

---

*Deep Thinking Team - Where the greatest minds solve your hardest problems.*
