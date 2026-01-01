# Thinking Frameworks - Quick Reference

> Tổng hợp các frameworks tư duy của 7 Titans trong Deep Thinking Team.

---

## Overview Map

```
┌─────────────────────────────────────────────────────────────────┐
│                 THINKING FRAMEWORKS MAP                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  UNDERSTAND          DECONSTRUCT        CHALLENGE              │
│  ┌──────────┐       ┌──────────┐       ┌──────────┐           │
│  │ Socratic │       │  First   │       │ Mental   │           │
│  │ Method   │  →    │Principles│  →    │ Models   │           │
│  │ (5 Layer)│       │ (Musk)   │       │ (Munger) │           │
│  └──────────┘       └──────────┘       └──────────┘           │
│       ↓                  ↓                  ↓                  │
│  ┌──────────┐       ┌──────────┐       ┌──────────┐           │
│  │Aristotle │       │ Feynman  │       │Inversion │           │
│  │  Logic   │       │Technique │       │Pre-mortem│           │
│  └──────────┘       └──────────┘       └──────────┘           │
│                                                                 │
│  SOLVE               SYNTHESIZE                                 │
│  ┌──────────┐       ┌──────────┐                               │
│  │  Polya   │       │ Da Vinci │                               │
│  │ 4-Step   │  →    │ 7 Princ. │  →    SOLUTION               │
│  │  Method  │       │Connessio.│       BLUEPRINT               │
│  └──────────┘       └──────────┘                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 1. Socratic Method (5 Layers)

**Owner**: 🔮 Socrates
**Phase**: 1 (UNDERSTAND)
**Purpose**: Expose assumptions, find true problem

```yaml
layer_1_clarification:
  purpose: "Make sure we understand the terms"
  questions:
    - "Khi bạn nói X, ý bạn chính xác là gì?"
    - "Cho ví dụ cụ thể được không?"

layer_2_assumptions:
  purpose: "Find hidden assumptions"
  questions:
    - "Bạn đang assume điều gì?"
    - "Tại sao bạn tin điều đó đúng?"

layer_3_evidence:
  purpose: "Examine the evidence"
  questions:
    - "Làm sao bạn biết?"
    - "Evidence nào support?"

layer_4_viewpoints:
  purpose: "Consider other perspectives"
  questions:
    - "Người không đồng ý sẽ nói gì?"
    - "Góc nhìn nào bị bỏ qua?"

layer_5_implications:
  purpose: "Explore consequences"
  questions:
    - "Nếu đây là đúng, điều gì else phải đúng?"
    - "Hệ quả là gì?"
```

---

## 2. Aristotelian Logic

**Owner**: 🧬 Aristotle
**Phase**: 1 (UNDERSTAND)
**Purpose**: Structure arguments, find contradictions

```yaml
syllogism:
  structure:
    - major_premise: "All A are B"
    - minor_premise: "C is A"
    - conclusion: "Therefore, C is B"

  validation:
    - "Premises có true không?"
    - "Conclusion follows necessarily không?"
    - "Có hidden assumptions không?"

categorization:
  questions:
    - "Problem này thuộc category nào?"
    - "Essential properties là gì?"
    - "Có contradictions trong reasoning không?"
```

---

## 3. First Principles Thinking

**Owner**: ⚡ Musk
**Phase**: 2 (DECONSTRUCT)
**Purpose**: Break to fundamentals, rebuild from truth

```yaml
process:
  step_1: "Identify the problem clearly"
  step_2: "Break down to fundamental elements"
  step_3: "Challenge every assumption"
  step_4: "Calculate from ground up"
  step_5: "Build new solution without analogies"

key_questions:
  - "Sự thật vật lý/logic cơ bản nhất là gì?"
  - "Tại sao mọi người làm theo cách này?"
  - "Chi phí từ raw materials là bao nhiêu?"
  - "Nếu bắt đầu từ zero, sẽ làm gì?"

idiot_index:
  formula: "Total Cost / Raw Material Cost"
  interpretation: "High = Opportunity for optimization"
```

---

## 4. Feynman Technique

**Owner**: 🔬 Feynman
**Phase**: 2 (DECONSTRUCT)
**Purpose**: Test understanding through simplification

```yaml
process:
  step_1: "Write down everything you know"
  step_2: "Explain it simply (to a child)"
  step_3: "Identify gaps when you struggle"
  step_4: "Go back and fill the gaps"
  step_5: "Simplify and use analogies"

test_questions:
  - "Giải thích cho trẻ 10 tuổi hiểu?"
  - "Phần nào bạn không thể explain simply?"
  - "Ví dụ đơn giản nhất là gì?"
  - "Nếu sai, làm sao biết?"
```

---

## 5. Mental Models (Latticework)

**Owner**: 🎭 Munger
**Phase**: 3 (CHALLENGE)
**Purpose**: Apply multi-disciplinary thinking

```yaml
core_models:
  inversion:
    question: "Điều gì sẽ guarantee thất bại?"
    application: "Avoid those things"

  incentives:
    question: "Incentives của mỗi party là gì?"
    application: "Follow the money"

  second_order:
    question: "And then what? And then what?"
    application: "Think through consequences"

  circle_of_competence:
    question: "Đây có trong expertise của ta không?"
    application: "Know what you don't know"

  margin_of_safety:
    question: "Buffer cho errors là gì?"
    application: "Build in cushion"

psychology_biases:
  - confirmation_bias
  - social_proof
  - authority_bias
  - sunk_cost_fallacy
  - loss_aversion
  - availability_bias
```

---

## 6. Inversion & Pre-Mortem

**Owner**: 🎭 Munger
**Phase**: 3 (CHALLENGE)
**Purpose**: Find failure modes

```yaml
inversion_process:
  step_1: "State the goal"
  step_2: "Invert: What would guarantee failure?"
  step_3: "List all failure causes"
  step_4: "Avoid each cause"
  step_5: "What remains is the path"

pre_mortem:
  setup: "Imagine: 6 months from now, project FAILED"
  questions:
    - "What went wrong?"
    - "What signs did we miss?"
    - "What assumptions were wrong?"
    - "Who warned us that we ignored?"
```

---

## 7. Polya 4-Step Method

**Owner**: 📐 Polya
**Phase**: 4 (SOLVE)
**Purpose**: Systematic problem-solving

```yaml
step_1_understand:
  questions:
    - "Unknown là gì?"
    - "Data là gì?"
    - "Conditions là gì?"
  actions:
    - Restate in own words
    - Draw diagram
    - Introduce notation

step_2_plan:
  heuristics:
    - "Bài toán tương tự?"
    - "Solve simpler version first"
    - "Work backwards"
    - "Divide and conquer"
    - "Look for pattern"

step_3_execute:
  principles:
    - "Follow plan step by step"
    - "Check each step"
    - "If stuck, return to Step 2"

step_4_look_back:
  questions:
    - "Verify result?"
    - "Alternative method?"
    - "Can generalize?"
    - "What learned?"
```

---

## 8. PDSA Cycle (Deming)

**Owner**: 📐 Polya (integrated)
**Phase**: 4 (SOLVE)
**Purpose**: Iterative improvement

```yaml
cycle:
  plan:
    - Identify opportunity
    - Plan a change
    - Predict outcome

  do:
    - Test change on small scale
    - Document what happens

  study:
    - Analyze results
    - Compare to predictions
    - Learn from differences

  act:
    - If successful: implement wider
    - If not: cycle again with learnings
```

---

## 9. Da Vincian Principles

**Owner**: 🎨 Da Vinci
**Phase**: 5 (SYNTHESIZE)
**Purpose**: Creative integration

```yaml
principles:
  curiosita:
    essence: "Insatiable curiosity"
    question: "Còn điều gì chưa hỏi?"

  dimostrazione:
    essence: "Test through experience"
    question: "Làm sao KNOW điều này đúng?"

  sensazione:
    essence: "Refine the senses"
    question: "Đang MISS điều gì?"

  sfumato:
    essence: "Embrace ambiguity"
    question: "OK để không biết everything?"

  arte_scienza:
    essence: "Balance art and science"
    question: "Logic và intuition agree?"

  corporalita:
    essence: "Physical embodiment"
    question: "Solution feel right?"

  connessione:
    essence: "See interconnections"
    question: "Mọi thứ connect thế nào?"
```

---

## When to Use Each Framework

| Situation | Framework | Why |
|-----------|-----------|-----|
| Unclear problem | Socratic Method | Expose hidden assumptions |
| Need structure | Aristotelian Logic | Map reasoning |
| Industry conventions | First Principles | Challenge status quo |
| Complex explanation | Feynman Technique | Test understanding |
| Decision making | Mental Models | Multi-lens analysis |
| Risk assessment | Inversion/Pre-mortem | Find failure modes |
| Building solution | Polya 4-Step | Systematic approach |
| Iterating | PDSA Cycle | Continuous improvement |
| Final synthesis | Da Vincian | Creative integration |

---

## Quick Reference Card

```
UNDERSTAND:
  🔮 "What do you mean by...?" (Socrates)
  🧬 "What's the logical structure?" (Aristotle)

DECONSTRUCT:
  ⚡ "What's the fundamental truth?" (Musk)
  🔬 "Explain to a 10-year-old" (Feynman)

CHALLENGE:
  🎭 "What would guarantee failure?" (Munger)
  🎭 "What biases are we missing?" (Munger)

SOLVE:
  📐 "Similar problem solved before?" (Polya)
  📐 "Simpler version first?" (Polya)

SYNTHESIZE:
  🎨 "How does everything connect?" (Da Vinci)
  🎨 "Is it elegant?" (Da Vinci)
```

---

*"The greatest thinkers don't just solve problems - they reveal the hidden structure of reality."*
