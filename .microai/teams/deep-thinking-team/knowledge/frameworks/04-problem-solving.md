# Problem-Solving Methodology

> "If you can't solve a problem, then there is an easier problem you can solve: find it." - George Polya

---

## Overview

Framework giải quyết vấn đề có hệ thống dựa trên phương pháp 4 bước của George Polya, kết hợp với PDSA cycle và catalog heuristics.

---

## Polya's 4-Step Method

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      POLYA'S 4-STEP METHOD                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  STEP 1: UNDERSTAND THE PROBLEM                                          │
│  ═══════════════════════════════                                         │
│  Questions:                                                              │
│  • Unknown là gì? (What are we looking for?)                            │
│  • Data là gì? (What do we have?)                                       │
│  • Condition là gì? (What constraints?)                                  │
│  • Có thể satisfy condition không?                                       │
│  • Có đủ data không? Thừa? Contradictory?                               │
│                                                                          │
│  Actions:                                                                │
│  • Vẽ diagram nếu có thể                                                │
│  • Introduce notation phù hợp                                            │
│  • Tách các parts của condition                                         │
│                                                                          │
│  ═══════════════════════════════════════════════════════════════════     │
│                                                                          │
│  STEP 2: DEVISE A PLAN                                                   │
│  ═══════════════════════                                                 │
│  Questions:                                                              │
│  • Đã gặp problem này chưa? Similar problem?                            │
│  • Có theorem nào useful không?                                          │
│  • Nhìn vào unknown - problem nào có cùng unknown?                      │
│  • Có thể restate problem không?                                         │
│  • Nếu không solve được, solve related problem nào?                     │
│                                                                          │
│  Heuristics:                                                             │
│  • Work backwards from goal                                              │
│  • Solve simpler version first                                           │
│  • Divide and conquer                                                    │
│  • Find pattern from examples                                            │
│                                                                          │
│  ═══════════════════════════════════════════════════════════════════     │
│                                                                          │
│  STEP 3: CARRY OUT THE PLAN                                              │
│  ═════════════════════════                                               │
│  Actions:                                                                │
│  • Execute từng step của plan                                            │
│  • Check mỗi step - có CHẮC CHẮN đúng không?                            │
│  • Nếu stuck, back to Step 2                                             │
│  • Document reasoning ở mỗi bước                                         │
│                                                                          │
│  ═══════════════════════════════════════════════════════════════════     │
│                                                                          │
│  STEP 4: LOOK BACK (REVIEW)                                              │
│  ═════════════════════════                                               │
│  Questions:                                                              │
│  • Check result - có make sense không?                                   │
│  • Có thể derive result differently không?                              │
│  • Có thể dùng result/method cho problem khác không?                    │
│  • Đã học được gì? Generalize được không?                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Heuristics Catalog

### When You're Stuck

```yaml
try_simpler_version:
  description: "Solve phiên bản đơn giản hơn trước"
  example: "N items → try with 2 items first"
  when: "Problem too complex to see pattern"

work_backwards:
  description: "Start from goal, work to starting point"
  example: "Final state → intermediate states → initial state"
  when: "Goal is clearer than path"

draw_a_picture:
  description: "Visualize problem"
  example: "Diagram, flowchart, state machine"
  when: "Relationships hard to see in text"

try_examples:
  description: "Work through concrete instances"
  example: "Abstract pattern → specific cases"
  when: "Pattern not obvious"

look_for_pattern:
  description: "Find regularities in examples"
  example: "Case 1, 2, 3 → generalize"
  when: "Have several examples"

divide_and_conquer:
  description: "Break into smaller sub-problems"
  example: "Big problem → independent parts → combine"
  when: "Problem has natural divisions"

change_representation:
  description: "Reframe in different terms"
  example: "Geometry → algebra, recursion → iteration"
  when: "Current frame not productive"

use_auxiliary_element:
  description: "Introduce helper construct"
  example: "Add helper line in geometry"
  when: "Direct approach fails"

solve_related_problem:
  description: "Solve similar problem you know"
  example: "Can't sort → can find min → selection sort"
  when: "Have related solved problem"

assume_solution_exists:
  description: "What if solution exists? What properties?"
  example: "If sorted, then... binary search works"
  when: "Need to understand solution structure"
```

### When Verifying

```yaml
sanity_check:
  description: "Does answer make sense?"
  checks:
    - "Right magnitude?"
    - "Right units?"
    - "Edge cases work?"
    - "Intuition matches?"

dimensional_analysis:
  description: "Do units/types match?"
  example: "meters + seconds = invalid"

boundary_testing:
  description: "Check extreme values"
  cases:
    - "Empty input"
    - "Single element"
    - "Maximum input"
    - "Negative values"

alternative_derivation:
  description: "Solve same problem different way"
  purpose: "Cross-validate answer"
```

---

## PDSA Cycle Integration

```
┌─────────────────────────────────────────────────────────────┐
│                    PDSA CYCLE                                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│                    ┌─────────┐                               │
│                    │  PLAN   │                               │
│                    │ (Polya  │                               │
│                    │ Steps   │                               │
│                    │  1-2)   │                               │
│                    └────┬────┘                               │
│                         │                                    │
│         ┌───────────────┴───────────────┐                   │
│         ↓                               ↓                   │
│    ┌─────────┐                    ┌─────────┐              │
│    │   DO    │                    │  ACT    │              │
│    │ (Polya  │                    │ (Adopt, │              │
│    │ Step 3) │                    │ Adapt,  │              │
│    │         │                    │ Abandon)│              │
│    └────┬────┘                    └────┬────┘              │
│         │                               ↑                   │
│         ↓                               │                   │
│    ┌─────────┐                          │                   │
│    │ STUDY   │──────────────────────────┘                  │
│    │ (Polya  │                                              │
│    │ Step 4) │                                              │
│    │         │                                              │
│    └─────────┘                                              │
│                                                              │
│  PLAN  → Define problem, hypothesis, expected results       │
│  DO    → Execute small-scale test                           │
│  STUDY → Analyze results vs expectations                    │
│  ACT   → Standardize if works, or cycle again               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### PDSA Application to Software

```yaml
cycle_1:
  plan:
    hypothesis: "Caching sẽ giảm 50% response time"
    measure: "Response time p95"
    baseline: "200ms"

  do:
    action: "Implement Redis cache for top 10 endpoints"
    scope: "One service, staging environment"
    duration: "1 week"

  study:
    result: "p95 reduced to 120ms (40% improvement)"
    observation: "Cache hit rate only 60%"
    insight: "Need longer TTL"

  act:
    decision: "Adopt with modifications"
    next_cycle: "Increase TTL, measure impact"

cycle_2:
  plan:
    hypothesis: "TTL 1 hour → 90% cache hit rate"
    # ... continues
```

---

## Problem Classification

### By Structure

```yaml
well_defined:
  characteristics:
    - Clear initial state
    - Clear goal state
    - Known operations
  approach: "Systematic search + heuristics"
  example: "Sort array, find shortest path"

ill_defined:
  characteristics:
    - Unclear goals
    - Unknown constraints
    - Multiple valid solutions
  approach: "Problem structuring first"
  example: "Design better UX, improve team culture"

constraint_satisfaction:
  characteristics:
    - Find values that satisfy constraints
    - May have many/no solutions
  approach: "Constraint propagation, backtracking"
  example: "Scheduling, resource allocation"

optimization:
  characteristics:
    - Find best solution among many
    - Objective function to maximize/minimize
  approach: "Greedy, dynamic programming, heuristics"
  example: "Minimize cost, maximize throughput"
```

### By Domain

```yaml
algorithmic:
  characteristics: "Well-defined, provably correct"
  approach: "Data structures, algorithms, complexity analysis"
  agents: "Dijkstra, Knuth, Carmack"

design:
  characteristics: "Trade-offs, subjective quality"
  approach: "Patterns, principles, iteration"
  agents: "Fowler, Uncle Bob, Hickey"

strategic:
  characteristics: "Uncertain, long-term"
  approach: "Analysis, scenarios, positioning"
  agents: "Thiel, Grove, Bezos"

product:
  characteristics: "User-centered, market-driven"
  approach: "Research, prototyping, feedback"
  agents: "Jobs, Jensen"
```

---

## Verification Patterns

### Proof Techniques

```yaml
direct_proof:
  process: "Assume premises → derive conclusion"
  use_when: "Clear logical path exists"

proof_by_contradiction:
  process: "Assume opposite → derive contradiction"
  use_when: "Direct proof difficult"

proof_by_induction:
  process: "Base case + inductive step"
  use_when: "Proving for all n"

proof_by_construction:
  process: "Build example that satisfies"
  use_when: "Existence proof"
```

### Testing Strategies

```yaml
example_based:
  process: "Verify with specific inputs"
  coverage: "Known cases"

property_based:
  process: "Verify properties hold for many inputs"
  coverage: "Random exploration"

boundary_testing:
  process: "Test at edges of valid input"
  coverage: "Edge cases"

invariant_checking:
  process: "Verify invariants maintained"
  coverage: "All state transitions"
```

---

## Problem-Solving Templates

### Template 1: Technical Problem

```markdown
## Problem Statement
**Unknown**: [What we need to find]
**Given**: [What we have]
**Constraints**: [Limitations]

## Understanding Check
- [ ] Can restate problem in own words
- [ ] Identified all constraints
- [ ] Drew diagram/visualization

## Plan
**Approach**: [Strategy]
**Similar problems**: [Related problems solved before]
**Key insight**: [What makes this solvable]

## Solution
**Step 1**: [Action + reasoning]
**Step 2**: [Action + reasoning]
...

## Verification
- [ ] Answer makes sense
- [ ] Edge cases checked
- [ ] Alternative derivation matches

## Reflection
**What worked**: [Effective strategies]
**What didn't**: [Dead ends]
**Generalization**: [Can apply to similar problems?]
```

### Template 2: Design Problem

```markdown
## Problem Statement
**Goal**: [What we're designing]
**Context**: [Constraints, users, environment]
**Success criteria**: [How we'll know it works]

## Exploration
**Options considered**:
1. [Option A] - pros/cons
2. [Option B] - pros/cons
3. [Option C] - pros/cons

## Trade-off Analysis
| Criteria | Option A | Option B | Option C |
|----------|----------|----------|----------|
| [Criteria 1] | | | |
| [Criteria 2] | | | |

## Decision
**Chosen**: [Option]
**Rationale**: [Why this option]
**Risks accepted**: [Trade-offs]

## Implementation Plan
1. [Phase 1]
2. [Phase 2]
...

## Review Triggers
Reconsider if:
- [Condition 1]
- [Condition 2]
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│             PROBLEM-SOLVING QUICK GUIDE                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  POLYA'S 4 STEPS:                                            │
│  1. UNDERSTAND → Unknown? Data? Constraints?                 │
│  2. PLAN → Similar problem? Work backwards? Simplify?        │
│  3. EXECUTE → Step by step, verify each                      │
│  4. REVIEW → Check result, learn, generalize                 │
│                                                              │
│  WHEN STUCK:                                                 │
│  • Solve simpler version first                               │
│  • Work backwards from goal                                  │
│  • Draw a picture/diagram                                    │
│  • Try concrete examples                                     │
│  • Break into smaller parts                                  │
│  • Change representation                                     │
│  • Solve related problem you know                            │
│                                                              │
│  PDSA CYCLE:                                                 │
│  Plan → Do (small scale) → Study → Act (adopt/adapt/abandon) │
│                                                              │
│  VERIFICATION:                                               │
│  • Sanity check (makes sense?)                               │
│  • Boundary testing (edge cases)                             │
│  • Alternative derivation (different approach)               │
│                                                              │
│  PROBLEM TYPES:                                              │
│  • Well-defined → Systematic search                          │
│  • Ill-defined → Structure first                             │
│  • Optimization → Greedy/DP/heuristics                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

*"The ability to focus attention on important things is a defining characteristic of intelligence." - Robert Shiller*
