# Thinking Patterns by Problem Type

> "If I had an hour to solve a problem, I'd spend 55 minutes thinking about the problem and 5 minutes thinking about solutions." - Albert Einstein

---

## Overview

Hướng dẫn chọn thinking patterns và agents phù hợp cho từng loại vấn đề cụ thể.

---

## 1. STRATEGIC PROBLEMS

### Market Entry Decision

```yaml
problem_type: "Nên enter market mới không?"

recommended_pattern:
  framework: "Strategic Thinking + Inversion"
  agents:
    primary: [thiel, bezos, grove]
    support: [munger]

process:
  step_1_contrarian:
    agent: thiel
    questions:
      - "Điều gì bạn thấy mà others không thấy?"
      - "Đây có phải là secret chưa ai khai thác?"
      - "Có thể build monopoly không?"

  step_2_customer:
    agent: bezos
    questions:
      - "Customer trong market này thực sự muốn gì?"
      - "Friction points hiện tại là gì?"
      - "Có thể working backwards từ ideal experience?"

  step_3_paranoid:
    agent: grove
    questions:
      - "Đây có phải strategic inflection point?"
      - "Competitors sẽ respond thế nào?"
      - "Internal risks là gì?"

  step_4_inversion:
    agent: munger
    questions:
      - "Làm sao để fail trong market này?"
      - "Biases nào đang ảnh hưởng decision?"

output: "Strategic recommendation với risk mitigation"
```

### Pivot Decision

```yaml
problem_type: "Có nên pivot không?"

recommended_pattern:
  framework: "First Principles + Inversion"
  agents:
    primary: [musk, grove, munger]
    support: [bezos]

process:
  step_1_fundamentals:
    agent: musk
    questions:
      - "First principles của business là gì?"
      - "Đang solve đúng problem không?"
      - "Có fundamental truth nào invalidate current direction?"

  step_2_inflection:
    agent: grove
    questions:
      - "Đây có phải inflection point?"
      - "Signal vs noise - data có đủ không?"
      - "Timing có đúng không?"

  step_3_inversion:
    agent: munger
    questions:
      - "Sunk cost có đang ảnh hưởng không?"
      - "Nếu bắt đầu lại, có chọn current path?"

output: "Pivot/persevere decision với rationale"
```

---

## 2. TECHNICAL PROBLEMS

### Architecture Design

```yaml
problem_type: "Thiết kế system architecture"

recommended_pattern:
  framework: "Systems Thinking + First Principles"
  agents:
    primary: [linus, dijkstra, fowler]
    support: [musk, carmack]

process:
  step_1_requirements:
    agent: fowler
    questions:
      - "Requirements thực sự là gì?"
      - "Trade-offs acceptable là gì?"
      - "Constraints (team, time, budget)?"

  step_2_first_principles:
    agent: musk
    questions:
      - "Industry convention có đang limit thinking?"
      - "Simplest architecture đạt requirements?"

  step_3_system_design:
    agent: linus
    questions:
      - "Data structures cần thiết là gì?"
      - "Components và relationships?"
      - "Failure modes và handling?"

  step_4_correctness:
    agent: dijkstra
    questions:
      - "Invariants cần maintain là gì?"
      - "Có thể prove correctness không?"

  step_5_performance:
    agent: carmack
    questions:
      - "Bottlenecks tiềm năng ở đâu?"
      - "Performance requirements?"

output: "Architecture decision record (ADR)"
```

### Performance Optimization

```yaml
problem_type: "System chậm, cần optimize"

recommended_pattern:
  framework: "Systems Thinking + Algorithm Analysis"
  agents:
    primary: [carmack, knuth, linus]
    support: [dijkstra]

process:
  step_1_measure:
    agent: carmack
    questions:
      - "Đã profile chưa? Data là gì?"
      - "Bottleneck thực sự ở đâu?"
      - "CPU/Memory/IO bound?"

  step_2_algorithm:
    agent: knuth
    questions:
      - "Complexity analysis của current solution?"
      - "Có algorithm tốt hơn không?"
      - "Premature optimization không?"

  step_3_implementation:
    agent: linus
    questions:
      - "Data structures có optimal không?"
      - "Cache behavior như thế nào?"
      - "Có unnecessary abstraction không?"

  step_4_verify:
    agent: dijkstra
    questions:
      - "Optimization có break correctness không?"
      - "Edge cases vẫn handled đúng?"

output: "Performance improvement với measurements"
```

### Bug Investigation

```yaml
problem_type: "Bug khó hiểu, cần debug"

recommended_pattern:
  framework: "Socratic + Systems Thinking"
  agents:
    primary: [socrates, linus, dijkstra]
    support: [polya]

process:
  step_1_clarify:
    agent: socrates
    questions:
      - "Bug chính xác là gì? Symptoms?"
      - "Khi nào xảy ra? Điều kiện?"
      - "Reproducible không?"

  step_2_system:
    agent: linus
    questions:
      - "Control flow khi bug xảy ra?"
      - "State của system lúc đó?"
      - "Recent changes liên quan?"

  step_3_logic:
    agent: dijkstra
    questions:
      - "Invariant nào bị violate?"
      - "Precondition nào không được meet?"

  step_4_solve:
    agent: polya
    questions:
      - "Có thể simplify problem không?"
      - "Đã gặp similar bug chưa?"

output: "Root cause và fix"
```

---

## 3. PRODUCT PROBLEMS

### New Feature Design

```yaml
problem_type: "Thiết kế feature mới"

recommended_pattern:
  framework: "Design Thinking + First Principles"
  agents:
    primary: [jobs, davinci, musk]
    support: [feynman, bezos]

process:
  step_1_empathize:
    agent: bezos
    questions:
      - "Customer muốn gì với feature này?"
      - "Current pain points là gì?"

  step_2_simplify:
    agent: jobs
    questions:
      - "Essence của feature là gì?"
      - "Có thể bỏ gì để simpler?"
      - "First impression sẽ như thế nào?"

  step_3_first_principles:
    agent: musk
    questions:
      - "Industry standards có đang limit thinking?"
      - "Cách tốt hơn từ fundamentals?"

  step_4_connect:
    agent: davinci
    questions:
      - "Inspiration từ domains khác?"
      - "Hidden connections với existing features?"

  step_5_explain:
    agent: feynman
    questions:
      - "User có hiểu ngay không?"
      - "Có thể explain trong 1 câu?"

output: "Feature spec với user-centered design"
```

### Product Strategy

```yaml
problem_type: "Product roadmap và strategy"

recommended_pattern:
  framework: "Strategic + Design Thinking"
  agents:
    primary: [jobs, thiel, jensen]
    support: [bezos, grove]

process:
  step_1_vision:
    agent: jobs
    questions:
      - "Product vision là gì?"
      - "Đâu là essence, đâu là noise?"
      - "Sẽ proud show product này không?"

  step_2_contrarian:
    agent: thiel
    questions:
      - "Secret competitive advantage là gì?"
      - "Đây là 0→1 hay 1→n?"
      - "Moat có thể build là gì?"

  step_3_platform:
    agent: jensen
    questions:
      - "Product hay platform?"
      - "Ecosystem potential?"
      - "Technology leverage?"

  step_4_customer:
    agent: bezos
    questions:
      - "Long-term customer value?"
      - "Flywheel effect?"

  step_5_execution:
    agent: grove
    questions:
      - "Execution priorities?"
      - "Key milestones?"

output: "Product strategy document"
```

---

## 4. ORGANIZATIONAL PROBLEMS

### Team Scaling

```yaml
problem_type: "Scale team và processes"

recommended_pattern:
  framework: "Systems + Execution Thinking"
  agents:
    primary: [grove, fowler, beck]
    support: [linus]

process:
  step_1_diagnose:
    agent: grove
    questions:
      - "Current bottlenecks là gì?"
      - "Đâu cần scale, đâu không?"
      - "Organizational inflection points?"

  step_2_architecture:
    agent: fowler
    questions:
      - "Team topology nào phù hợp?"
      - "Communication patterns?"
      - "Trade-offs của mỗi option?"

  step_3_process:
    agent: beck
    questions:
      - "Processes cần thay đổi?"
      - "Feedback loops đang có?"
      - "Simplify gì được?"

  step_4_technical:
    agent: linus
    questions:
      - "Codebase có scale được không?"
      - "Modularization cần thiết?"

output: "Scaling plan với phases"
```

### Process Improvement

```yaml
problem_type: "Improve development process"

recommended_pattern:
  framework: "Execution + First Principles"
  agents:
    primary: [beck, fowler, grove]
    support: [musk, munger]

process:
  step_1_measure:
    agent: grove
    questions:
      - "Metrics hiện tại là gì?"
      - "Bottlenecks ở đâu?"
      - "OKRs cho improvement?"

  step_2_first_principles:
    agent: musk
    questions:
      - "Process này tồn tại vì sao?"
      - "Có thể eliminate steps nào?"
      - "Industry conventions đang follow vì đúng hay vì quen?"

  step_3_simplify:
    agent: beck
    questions:
      - "Simplest process that works?"
      - "Feedback loops đủ nhanh?"
      - "TDD/CI/CD có đang help không?"

  step_4_trade_offs:
    agent: fowler
    questions:
      - "Trade-offs của changes?"
      - "Incremental hay big-bang?"

  step_5_inversion:
    agent: munger
    questions:
      - "Làm sao để improvement fail?"
      - "Biases đang ảnh hưởng?"

output: "Process improvement plan"
```

---

## 5. PROBLEM-SOLVING PROBLEMS

### Unclear Problem

```yaml
problem_type: "Không rõ problem là gì"

recommended_pattern:
  framework: "Socratic Questioning"
  agents:
    primary: [socrates, aristotle, feynman]

process:
  step_1_clarify:
    agent: socrates
    questions:
      - "Vấn đề được describe như thế nào?"
      - "Ai đang bị ảnh hưởng?"
      - "Symptoms vs root cause?"

  step_2_structure:
    agent: aristotle
    questions:
      - "Vấn đề này thuộc category nào?"
      - "Logical structure của problem?"
      - "Cause và effect relationships?"

  step_3_simplify:
    agent: feynman
    questions:
      - "Có thể explain vấn đề simply không?"
      - "Jargon nào đang obscure understanding?"
      - "Analogy từ đời thường?"

output: "Clear problem definition"
```

### Stuck on Solution

```yaml
problem_type: "Đang stuck, không tìm ra solution"

recommended_pattern:
  framework: "Problem-Solving + Design Thinking"
  agents:
    primary: [polya, davinci, musk]
    support: [feynman]

process:
  step_1_heuristics:
    agent: polya
    questions:
      - "Có thể solve simpler version không?"
      - "Work backwards từ goal?"
      - "Đã gặp similar problem chưa?"
      - "Có thể draw diagram không?"

  step_2_first_principles:
    agent: musk
    questions:
      - "Đang reason by analogy không?"
      - "Fundamentals của problem?"
      - "Convention nào đang limit?"

  step_3_connect:
    agent: davinci
    questions:
      - "Inspiration từ domain khác?"
      - "Hidden connections?"
      - "Có thể combine ideas?"

  step_4_simplify:
    agent: feynman
    questions:
      - "Phần nào của problem chưa hiểu rõ?"
      - "Simplify thế nào?"

output: "Solution approach hoặc new understanding"
```

---

## Quick Selection Guide

```
┌─────────────────────────────────────────────────────────────┐
│              PATTERN SELECTION QUICK GUIDE                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STRATEGIC:                                                  │
│  • Market entry → Thiel + Bezos + Grove                      │
│  • Pivot decision → Musk + Grove + Munger                    │
│  • Competitive response → Grove + Thiel                      │
│                                                              │
│  TECHNICAL:                                                  │
│  • Architecture → Linus + Fowler + Dijkstra                  │
│  • Performance → Carmack + Knuth + Linus                     │
│  • Bug investigation → Socrates + Linus + Dijkstra           │
│  • Code quality → Linus + Beck + Fowler                      │
│                                                              │
│  PRODUCT:                                                    │
│  • New feature → Jobs + Da Vinci + Feynman                   │
│  • Product strategy → Jobs + Thiel + Jensen                  │
│  • UX improvement → Jobs + Bezos + Feynman                   │
│                                                              │
│  ORGANIZATIONAL:                                             │
│  • Team scaling → Grove + Fowler + Beck                      │
│  • Process improvement → Beck + Musk + Grove                 │
│                                                              │
│  PROBLEM-SOLVING:                                            │
│  • Unclear problem → Socrates + Aristotle + Feynman          │
│  • Stuck on solution → Polya + Da Vinci + Musk               │
│  • Risk analysis → Munger + Grove                            │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

*"The best way to have a good idea is to have lots of ideas." - Linus Pauling*
