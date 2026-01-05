# Agent Collaboration Patterns

> "If you want to go fast, go alone. If you want to go far, go together." - African Proverb

---

## Overview

Các mẫu hợp tác giữa agents trong Deep Thinking Team để tạo ra synergy và kết quả tốt nhất.

---

## Pattern 1: Debate Pattern

### Mô tả
Hai agents với viewpoints đối lập tranh luận về vấn đề để tạo ra balanced perspective.

### Khi nào sử dụng
- Có multiple valid approaches
- Cần explore trade-offs
- Avoid confirmation bias
- High-stakes decision

### Implementation

```yaml
debate_pattern:
  structure:
    protagonist: "[Agent A - advocates for X]"
    antagonist: "[Agent B - advocates for NOT X or alternative]"
    moderator: "Maestro (ensures productive debate)"

  rounds:
    round_1:
      protagonist: "Present case for X"
      antagonist: "Challenge and present counter-arguments"

    round_2:
      protagonist: "Respond to challenges"
      antagonist: "Strengthen counter-arguments"

    round_3:
      synthesis: "Maestro synthesizes key insights from both sides"

  output:
    - "Pros and cons of each position"
    - "Key trade-offs identified"
    - "Synthesis/recommendation"
```

### Example Debates

```yaml
debate_1:
  topic: "Microservices vs Monolith"
  protagonist:
    agent: musk
    position: "First principles: start simple with monolith"
  antagonist:
    agent: fowler
    position: "Trade-offs depend on context, may need services"
  output: "Modular monolith as middle ground"

debate_2:
  topic: "Move fast vs Build right"
  protagonist:
    agent: grove
    position: "Speed is competitive advantage, ship now"
  antagonist:
    agent: dijkstra
    position: "Correctness first, technical debt kills later"
  output: "Sustainable velocity with quality gates"

debate_3:
  topic: "Build vs Buy"
  protagonist:
    agent: musk
    position: "Build: control destiny, 10x potential"
  antagonist:
    agent: bezos
    position: "Buy: focus on core differentiator"
  output: "Decision framework based on strategic importance"
```

### Debate Template

```markdown
## 🎭 Debate: [Topic]

### Positions

**Team A** ([Agent Names]):
> [Core argument]

**Team B** ([Agent Names]):
> [Core argument]

### Round 1: Opening Arguments

**Team A**:
[Argument with evidence]

**Team B**:
[Counter-argument with evidence]

### Round 2: Rebuttals

**Team A responds**:
[Address Team B's points]

**Team B responds**:
[Address Team A's points]

### Round 3: Synthesis

**Key Trade-offs**:
| Dimension | Team A View | Team B View |
|-----------|-------------|-------------|
| [Dimension 1] | | |
| [Dimension 2] | | |

**Synthesis**:
[What we learned from both perspectives]

**Recommendation**:
[Balanced recommendation incorporating both views]
```

---

## Pattern 2: Handoff Pattern

### Mô tả
Agent này hoàn thành phần việc rồi chuyển giao cho agent tiếp theo trong chain.

### Khi nào sử dụng
- Sequential processing cần thiết
- Each agent adds unique value
- Output của agent A là input của agent B
- Pipeline processing

### Implementation

```yaml
handoff_pattern:
  structure:
    chain: [agent_1, agent_2, agent_3, ...]
    handoff_artifact: "Document/output passed between agents"

  process:
    step_1:
      agent: agent_1
      input: "Original problem"
      output: "Processed artifact v1"
      handoff_to: agent_2

    step_2:
      agent: agent_2
      input: "Processed artifact v1"
      output: "Processed artifact v2"
      handoff_to: agent_3

    # ... continues

  handoff_requirements:
    - "Clear output format"
    - "Explicit handoff notes"
    - "Context preservation"
```

### Example Handoff Chains

```yaml
chain_1_problem_to_solution:
  name: "Understanding → Solution"
  chain:
    - agent: socrates
      action: "Clarify problem, expose assumptions"
      handoff: "Clear problem statement + assumptions list"

    - agent: aristotle
      action: "Structure logically, categorize"
      handoff: "Logical structure + categories"

    - agent: polya
      action: "Systematic problem-solving"
      handoff: "Solution approach + steps"

    - agent: builders
      action: "Implement solution"
      handoff: "Working implementation"

chain_2_idea_to_strategy:
  name: "Idea → Execution Strategy"
  chain:
    - agent: musk
      action: "First principles analysis"
      handoff: "Fundamentals + 10x opportunity"

    - agent: thiel
      action: "Contrarian positioning"
      handoff: "Secret + competitive advantage"

    - agent: bezos
      action: "Customer-centric refinement"
      handoff: "Customer value proposition"

    - agent: grove
      action: "Execution planning"
      handoff: "OKRs + action plan"

chain_3_code_to_production:
  name: "Code → Production Ready"
  chain:
    - agent: beck
      action: "TDD, implement feature"
      handoff: "Working code with tests"

    - agent: linus
      action: "Code review, quality check"
      handoff: "Reviewed code + feedback"

    - agent: dijkstra
      action: "Correctness verification"
      handoff: "Verified correct code"

    - agent: carmack
      action: "Performance optimization"
      handoff: "Optimized, production-ready code"
```

### Handoff Template

```markdown
## 🔄 Handoff: [Topic]

### Chain Overview
```
[Agent 1] → [Agent 2] → [Agent 3] → ...
```

### Stage 1: [Agent 1 Name]

**Input**: [What this agent received]

**Work Done**:
[Summary of agent's contribution]

**Output**:
[Key deliverables]

**Handoff Notes for Next Agent**:
- [Context point 1]
- [Context point 2]
- [Open questions]

---

### Stage 2: [Agent 2 Name]

**Received From**: [Previous agent]

**Input Review**:
[How this agent interprets the handoff]

**Work Done**:
[Summary of agent's contribution]

**Output**:
[Key deliverables]

**Handoff Notes for Next Agent**:
- [Context point 1]
- [Context point 2]

---

[Continue for remaining stages...]

### Final Output
[Combined result of the chain]
```

---

## Pattern 3: Parallel Analysis

### Mô tả
Nhiều agents phân tích cùng một vấn đề đồng thời từ góc nhìn khác nhau.

### Khi nào sử dụng
- Problem cần multiple perspectives
- Time pressure (parallel = faster)
- Comprehensive analysis needed
- Cross-functional problem

### Implementation

```yaml
parallel_analysis:
  structure:
    problem: "Single problem statement"
    agents: [agent_1, agent_2, agent_3, ...]
    collector: "Da Vinci (synthesizes all analyses)"

  process:
    phase_1_parallel:
      - agent_1: "Analyzes from perspective A"
      - agent_2: "Analyzes from perspective B"
      - agent_3: "Analyzes from perspective C"
      # All run simultaneously

    phase_2_collect:
      collector: "Gathers all analyses"

    phase_3_synthesize:
      collector: "Creates unified view"

  output:
    - "Multiple perspective analyses"
    - "Unified synthesis"
    - "Identified agreements and conflicts"
```

### Example Parallel Analyses

```yaml
parallel_1_comprehensive_review:
  name: "Technical Decision Review"
  problem: "Should we adopt GraphQL?"

  parallel_agents:
    linus:
      perspective: "System design & code quality"
      focus: "Complexity, maintainability"

    carmack:
      perspective: "Performance"
      focus: "Latency, caching, N+1 queries"

    fowler:
      perspective: "Architecture trade-offs"
      focus: "When GraphQL makes sense"

    beck:
      perspective: "Developer experience"
      focus: "Testability, development speed"

  collector: davinci
  output: "Comprehensive GraphQL adoption recommendation"

parallel_2_strategic_analysis:
  name: "Market Opportunity Analysis"
  problem: "Should we enter enterprise market?"

  parallel_agents:
    thiel:
      perspective: "Competitive positioning"
      focus: "Secrets, monopoly potential"

    bezos:
      perspective: "Customer"
      focus: "Enterprise customer needs"

    grove:
      perspective: "Execution"
      focus: "Capabilities, risks, timing"

    munger:
      perspective: "Risk analysis"
      focus: "Failure modes, biases"

  collector: davinci
  output: "Multi-dimensional market entry analysis"
```

### Parallel Analysis Template

```markdown
## ⚡ Parallel Analysis: [Topic]

### Problem Statement
[What we're analyzing]

---

### Perspective 1: [Agent 1 Name] - [Focus Area]

**Key Findings**:
1. [Finding 1]
2. [Finding 2]

**Concerns**:
- [Concern 1]
- [Concern 2]

**Recommendation**: [Agent's recommendation]

---

### Perspective 2: [Agent 2 Name] - [Focus Area]

**Key Findings**:
1. [Finding 1]
2. [Finding 2]

**Concerns**:
- [Concern 1]
- [Concern 2]

**Recommendation**: [Agent's recommendation]

---

### Perspective 3: [Agent 3 Name] - [Focus Area]

[Same structure...]

---

### 🎨 Synthesis (Da Vinci)

**Agreements Across Perspectives**:
- [All agents agree on X]
- [All agents agree on Y]

**Conflicts Identified**:
| Topic | Agent A View | Agent B View | Resolution |
|-------|--------------|--------------|------------|
| | | | |

**Unified Recommendation**:
[Synthesized recommendation incorporating all perspectives]
```

---

## Pattern 4: Synthesis Pattern

### Mô tả
Da Vinci tổng hợp outputs từ tất cả agents thành unified solution.

### Khi nào sử dụng
- End of multi-agent analysis
- Need unified deliverable
- Cross-functional integration
- Creating actionable output

### Implementation

```yaml
synthesis_pattern:
  structure:
    inputs:
      - "All agent outputs from previous phases"
      - "Original problem statement"
      - "Constraints and requirements"
    synthesizer: "Da Vinci"
    output: "Unified solution blueprint"

  process:
    step_1_gather:
      action: "Collect all agent outputs"
      organize_by: ["theme", "agreement", "conflict"]

    step_2_connect:
      action: "Find hidden connections"
      techniques:
        - "Cross-reference insights"
        - "Identify patterns"
        - "Map relationships"

    step_3_unify:
      action: "Create core insight"
      criteria:
        - "Explains all findings"
        - "Resolves conflicts"
        - "Actionable"

    step_4_crystallize:
      action: "Create final deliverable"
      formats:
        - "Executive summary"
        - "Detailed blueprint"
        - "Action plan"
```

### Synthesis Template

```markdown
## 🎨 Synthesis Blueprint: [Topic]

### Source Inputs

| Agent | Key Contribution | Quality |
|-------|------------------|---------|
| [Agent 1] | [Summary] | ⭐⭐⭐⭐⭐ |
| [Agent 2] | [Summary] | ⭐⭐⭐⭐ |
| ... | ... | ... |

### Key Connections Discovered

1. **[Connection 1]**: [Agent A insight] + [Agent B insight] → [New understanding]
2. **[Connection 2]**: [Description]
3. **[Connection 3]**: [Description]

### Core Insight

> [One sentence that captures the essence of all analyses]

### Unified Solution

**Vision**: [What success looks like]

**Principles**:
1. [Derived from multiple agent insights]
2. [Principle 2]
3. [Principle 3]

**Strategy**:
- Phase 1: [Focus]
- Phase 2: [Focus]
- Phase 3: [Focus]

### Action Plan

| Action | Owner | Timeline | Dependencies |
|--------|-------|----------|--------------|
| [Action 1] | [Who] | [When] | [What] |
| [Action 2] | [Who] | [When] | [What] |

### Open Items

- [ ] [Question to resolve]
- [ ] [Decision pending]

---
*Synthesized by Da Vinci from [N] agent contributions*
```

---

## Pattern 5: Challenge Pattern

### Mô tả
Một agent challenge kết quả của agent khác để strengthen solution.

### Implementation

```yaml
challenge_pattern:
  pairs:
    musk_vs_fowler:
      scenario: "First principles solution"
      challenger: fowler
      challenge: "Trade-offs bạn chưa consider?"

    jobs_vs_linus:
      scenario: "Product design"
      challenger: linus
      challenge: "Technically feasible không?"

    thiel_vs_munger:
      scenario: "Strategic bet"
      challenger: munger
      challenge: "Biases và failure modes?"

    beck_vs_dijkstra:
      scenario: "Development approach"
      challenger: dijkstra
      challenge: "Provably correct không?"
```

---

## Collaboration Matrix

```yaml
synergistic_pairs:
  understanding:
    - [socrates, aristotle]  # Questions → Logic
    - [socrates, feynman]    # Questions → Simplification

  analysis:
    - [musk, feynman]        # First principles → Simple explanation
    - [munger, grove]        # Inversion → Execution risks

  technical:
    - [linus, dijkstra]      # Systems → Correctness
    - [carmack, knuth]       # Performance → Analysis

  design:
    - [fowler, beck]         # Architecture → Implementation
    - [jobs, davinci]        # Product → Creative connection

  strategy:
    - [thiel, bezos]         # Contrarian → Customer
    - [grove, beck]          # Execution → Feedback
```

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│            COLLABORATION PATTERNS QUICK GUIDE                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  DEBATE PATTERN                                              │
│  When: Need balanced perspective, explore trade-offs         │
│  Structure: Protagonist vs Antagonist → Synthesis            │
│  Example: Musk vs Fowler on architecture                     │
│                                                              │
│  HANDOFF PATTERN                                             │
│  When: Sequential processing needed                          │
│  Structure: Agent A → Agent B → Agent C → ...                │
│  Example: Socrates → Aristotle → Polya → Builders            │
│                                                              │
│  PARALLEL PATTERN                                            │
│  When: Need multiple perspectives simultaneously             │
│  Structure: All agents analyze → Da Vinci synthesizes        │
│  Example: Phase 3 Challenge (Munger + Grove parallel)        │
│                                                              │
│  SYNTHESIS PATTERN                                           │
│  When: End of analysis, need unified output                  │
│  Structure: All outputs → Da Vinci → Blueprint               │
│  Example: Phase 5 final synthesis                            │
│                                                              │
│  CHALLENGE PATTERN                                           │
│  When: Need to strengthen solution                           │
│  Structure: Agent A proposes → Agent B challenges            │
│  Example: Beck implements → Dijkstra verifies                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

*"None of us is as smart as all of us." - Ken Blanchard*
