# Algorithm Analysis Framework

> "Premature optimization is the root of all evil." - Donald Knuth
> "The only way to go fast is to know why you're slow." - John Carmack

---

## Overview

Framework phân tích thuật toán kết hợp sự nghiêm ngặt của Knuth, tính đúng đắn của Dijkstra, và performance optimization của Carmack.

---

## Knuth's Rigor Standards

### Algorithm Analysis Protocol

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    KNUTH'S ANALYSIS PROTOCOL                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. CORRECTNESS (First and Foremost)                                     │
│  ════════════════════════════════════                                    │
│  • Does algorithm produce correct output for ALL valid inputs?           │
│  • Edge cases enumerated and handled                                     │
│  • Formal proof or rigorous argument                                     │
│  • Invariants stated and verified                                        │
│                                                                          │
│  2. COMPLEXITY ANALYSIS                                                  │
│  ════════════════════════════════════                                    │
│  • Time: Best O(?), Average O(?), Worst O(?)                            │
│  • Space: Stack O(?), Heap O(?)                                         │
│  • EXACT formula T(n) = an² + bn + c (not just Big-O)                   │
│  • Amortized analysis if applicable                                      │
│                                                                          │
│  3. PRACTICAL ANALYSIS                                                   │
│  ════════════════════════════════════                                    │
│  • Constant factors (hidden by Big-O)                                    │
│  • Cache behavior                                                        │
│  • Real-world input distributions                                        │
│  • Comparison with alternatives                                          │
│                                                                          │
│  4. DOCUMENTATION                                                        │
│  ════════════════════════════════════                                    │
│  • Literate programming style                                            │
│  • Code tells WHAT, comments tell WHY                                    │
│  • Explain reasoning at each step                                        │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Complexity Analysis Template

```yaml
time_complexity:
  best_case:
    scenario: "[When does best case occur?]"
    complexity: "O(?)"
    exact_formula: "T(n) = [formula]"

  average_case:
    scenario: "[Typical input distribution]"
    complexity: "O(?)"
    exact_formula: "T(n) = [formula]"
    derivation: "[How derived]"

  worst_case:
    scenario: "[When does worst case occur?]"
    complexity: "O(?)"
    exact_formula: "T(n) = [formula]"

  amortized:
    applies: "[Yes/No]"
    analysis: "[If yes, explain]"

space_complexity:
  auxiliary: "O(?)"
  stack_depth: "O(?)"
  in_place: "[Yes/No]"
```

---

## Dijkstra's Correctness Proofs

### Formal Verification Framework

```yaml
preconditions:
  definition: "What must be true BEFORE algorithm runs"
  notation: "{P} - precondition"
  example:
    - "Array is non-empty"
    - "All elements are positive"
    - "Input is sorted"

postconditions:
  definition: "What must be true AFTER algorithm completes"
  notation: "{Q} - postcondition"
  example:
    - "Array is sorted in ascending order"
    - "Return value is smallest element"
    - "Original elements preserved (permutation)"

loop_invariants:
  definition: "What is true at start of EVERY iteration"
  requirements:
    - "True before loop starts (initialization)"
    - "If true before iteration, true after (maintenance)"
    - "When loop ends, implies postcondition (termination)"

proof_template:
  format: |
    ALGORITHM: [Name]
    PRECONDITION: {P}
    POSTCONDITION: {Q}

    LOOP INVARIANT: {I}

    PROOF:
    1. Initialization: [Show I is true before loop]
    2. Maintenance: [Show I preserved by each iteration]
    3. Termination: [Show loop terminates]
    4. Correctness: [Show I + termination → Q]
```

### Example: Binary Search Proof

```
ALGORITHM: Binary Search
PRECONDITION: {Array A is sorted, key k exists or not in A}
POSTCONDITION: {Return index of k if exists, -1 otherwise}

INVARIANT: If k is in A, then k is in A[low..high]

PROOF:
1. INITIALIZATION:
   low = 0, high = n-1
   If k in A, then k in A[0..n-1] ✓

2. MAINTENANCE:
   mid = (low + high) / 2
   Case A[mid] == k: Return mid (found) ✓
   Case A[mid] < k: k must be in A[mid+1..high], set low = mid+1 ✓
   Case A[mid] > k: k must be in A[low..mid-1], set high = mid-1 ✓
   Invariant preserved in all cases ✓

3. TERMINATION:
   Each iteration: (high - low) decreases by at least half
   Eventually: high < low → loop terminates ✓

4. CORRECTNESS:
   If loop terminates with high < low and k not found:
   Invariant says k in A[low..high] but low > high means empty range
   Therefore k not in A → return -1 is correct ✓
```

### Dijkstra's Design Principles

```yaml
structured_programming:
  principle: "Single entry, single exit for all control structures"
  benefit: "Easier to reason about correctness"
  application: "Avoid goto, multiple returns, break/continue abuse"

separation_of_concerns:
  principle: "Each module does one thing well"
  benefit: "Isolated correctness proofs"
  application: "Clear interfaces, minimal coupling"

invariant_preservation:
  principle: "Design around maintaining invariants"
  benefit: "Correctness by construction"
  application: "Make invalid states unrepresentable"

simplicity:
  principle: "Simplicity is prerequisite for reliability"
  benefit: "Fewer bugs, easier proofs"
  application: "Reject complex solutions when simple ones exist"
```

---

## Carmack's Performance Pipeline

### Performance Optimization Process

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   CARMACK OPTIMIZATION PIPELINE                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  STEP 1: MEASURE FIRST                                                   │
│  ═══════════════════════                                                 │
│  • Profile the ENTIRE system                                             │
│  • Identify the ACTUAL bottleneck                                        │
│  • Get real numbers, not guesses                                         │
│  • Tool: Profiler (sampling + instrumentation)                           │
│                                                                          │
│  STEP 2: UNDERSTAND WHY IT'S SLOW                                        │
│  ═════════════════════════════════                                       │
│  Questions to answer:                                                    │
│  • CPU bound? GPU bound? Memory bound? I/O bound?                        │
│  • Cache misses? Branch mispredictions?                                  │
│  • Stalls? Bubbles? Dependencies?                                        │
│  • Which function? Which line? Which instruction?                        │
│                                                                          │
│  STEP 3: CONSIDER ALGORITHMIC CHANGES FIRST                              │
│  ═══════════════════════════════════════════                             │
│  • O(n²) → O(n log n) beats ANY micro-optimization                       │
│  • Change data structure before optimizing access                        │
│  • Question: Can we avoid doing this work entirely?                      │
│  • 10x improvements come from algorithm, not micro                       │
│                                                                          │
│  STEP 4: MICRO-OPTIMIZE THE HOT PATH                                     │
│  ═══════════════════════════════════                                     │
│  Only after Steps 1-3:                                                   │
│  • Cache-friendly memory access                                          │
│  • Branch prediction friendly code                                       │
│  • SIMD where applicable                                                 │
│  • Remove unnecessary operations                                         │
│                                                                          │
│  STEP 5: MEASURE AGAIN                                                   │
│  ═══════════════════════                                                 │
│  • Verify improvement with numbers                                       │
│  • Check for regressions elsewhere                                       │
│  • Document what you learned                                             │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Memory Hierarchy Awareness

```yaml
cache_levels:
  L1_cache:
    size: "32-64 KB"
    latency: "~4 cycles"
    strategy: "Hot data and code must fit here"

  L2_cache:
    size: "256 KB - 1 MB"
    latency: "~12 cycles"
    strategy: "Working set should fit here"

  L3_cache:
    size: "8-32 MB"
    latency: "~40 cycles"
    strategy: "Shared between cores"

  main_memory:
    latency: "~200 cycles"
    strategy: "Avoid in hot path"

optimization_techniques:
  data_layout:
    - "Struct of Arrays > Array of Structs (for iteration)"
    - "Pack related data together"
    - "Align to cache line boundaries (64 bytes)"

  access_patterns:
    - "Sequential > Random access"
    - "Prefetch when predictable"
    - "Avoid pointer chasing"

  cache_blocking:
    - "Process data in cache-sized chunks"
    - "Tile loops for locality"
```

### Data-Oriented Design

```yaml
principles:
  think_in_data:
    - "What data do we have?"
    - "What transformations do we need?"
    - "How is data laid out in memory?"

  avoid_oop_overhead:
    problems:
      - "Virtual functions = indirect calls = cache misses"
      - "Small objects = pointer chasing = cache misses"
      - "Inheritance hierarchies = scattered memory"
    solutions:
      - "Flat arrays of components"
      - "Homogeneous data processing"
      - "Batch operations"

  batch_processing:
    - "Process many items at once"
    - "Same operation on homogeneous data"
    - "SIMD-friendly"

example:
  bad: |
    class Entity { virtual void update(); }
    for (entity : entities) entity->update();  // Scattered, virtual

  good: |
    struct Positions { float x[N], y[N], z[N]; }  // Contiguous
    update_all_positions(positions, velocities, dt);  // Batch, SIMD
```

---

## Complexity Analysis Templates

### Template: Full Analysis

```markdown
## Algorithm: [Name]

### Description
[Brief description of what algorithm does]

### Pseudocode
```
[Algorithm in pseudocode]
```

### Correctness
**Precondition**: [What must be true before]
**Postcondition**: [What will be true after]
**Loop Invariant**: [If applicable]
**Proof**: [Sketch of correctness argument]

### Time Complexity

| Case | Complexity | Exact Formula | When |
|------|------------|---------------|------|
| Best | O(?) | T(n) = ? | [Scenario] |
| Average | O(?) | T(n) = ? | [Scenario] |
| Worst | O(?) | T(n) = ? | [Scenario] |

**Derivation**:
[Step-by-step complexity derivation]

### Space Complexity
- Auxiliary: O(?)
- Stack: O(?)
- In-place: Yes/No

### Practical Considerations
- **Constant factors**: [Hidden costs]
- **Cache behavior**: [Access patterns]
- **When to use**: [Best scenarios]
- **When NOT to use**: [Avoid scenarios]

### Alternatives Comparison
| Algorithm | Time | Space | Trade-off |
|-----------|------|-------|-----------|
| This one | O(?) | O(?) | [Pro/con] |
| Alt 1 | O(?) | O(?) | [Pro/con] |
| Alt 2 | O(?) | O(?) | [Pro/con] |
```

### Template: Performance Investigation

```markdown
## Performance Investigation: [Issue]

### Measurement
**Tool**: [Profiler used]
**Environment**: [Hardware, OS, data size]
**Metric**: [What we're measuring]

### Hot Spots
| Function | Time % | Calls | Avg Time |
|----------|--------|-------|----------|
| [func1] | [%] | [n] | [μs] |

### Bottleneck Type
[ ] CPU bound
[ ] Memory bound
[ ] I/O bound
[ ] GPU bound

### Root Cause
**Why slow**: [Technical explanation]
**Evidence**: [Data supporting this]

### Optimization Plan

**Level 1: Algorithmic**
| Change | Expected Impact | Effort |
|--------|-----------------|--------|
| [change] | [x]x faster | [effort] |

**Level 2: Data Structure**
| Change | Expected Impact | Effort |
|--------|-----------------|--------|
| [change] | [x]x faster | [effort] |

**Level 3: Micro-optimization**
| Change | Expected Impact | Effort |
|--------|-----------------|--------|
| [change] | [%] faster | [effort] |

### Results
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| [metric] | [value] | [value] | [x]x |

### Lessons Learned
- [Insight 1]
- [Insight 2]
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│            ALGORITHM ANALYSIS QUICK GUIDE                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ANALYSIS ORDER (Knuth):                                     │
│  1. CORRECTNESS - Prove it works first                       │
│  2. COMPLEXITY - Exact formulas, not just Big-O              │
│  3. PRACTICAL - Constants, cache, real inputs                │
│  4. DOCUMENT - Literate programming style                    │
│                                                              │
│  CORRECTNESS (Dijkstra):                                     │
│  • Precondition: {P} → Algorithm → Postcondition: {Q}        │
│  • Loop Invariant: True at every iteration start             │
│  • Proof: Initialization → Maintenance → Termination         │
│                                                              │
│  PERFORMANCE (Carmack):                                      │
│  1. MEASURE → Actual profiling data                          │
│  2. UNDERSTAND → Why is it slow?                             │
│  3. ALGORITHM FIRST → Big-O improvement                      │
│  4. MICRO LAST → Cache, branch, SIMD                         │
│  5. MEASURE AGAIN → Verify with data                         │
│                                                              │
│  MEMORY HIERARCHY:                                           │
│  L1 (~4 cycles) < L2 (~12) < L3 (~40) < RAM (~200)          │
│                                                              │
│  DATA-ORIENTED DESIGN:                                       │
│  • Struct of Arrays > Array of Structs                       │
│  • Sequential > Random access                                │
│  • Batch > Individual processing                             │
│                                                              │
│  KNUTH'S WARNING:                                            │
│  "Premature optimization is the root of all evil"            │
│  → Correctness first, then optimize proven bottlenecks       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

*"Beware of bugs in the above code; I have only proved it correct, not tried it." - Donald Knuth*

*"The majority of optimization work should be algorithmic, not micro." - John Carmack*

*"Simplicity is prerequisite for reliability." - Edsger Dijkstra*
