# Improvement Patterns

> Best practices và patterns để cải thiện agent intelligence.

---

## Overview

Sau khi identify weaknesses, đây là patterns để fix chúng:

```
IMPROVEMENT PRIORITY MATRIX
                    HIGH IMPACT
                        │
    ┌───────────────────┼───────────────────┐
    │                   │                   │
    │  🔴 DO FIRST      │  🟡 SCHEDULE      │
    │  Reasoning gaps   │  Knowledge depth  │
    │  Clarification    │  Code examples    │
    │                   │                   │
LOW ├───────────────────┼───────────────────┤ HIGH
EFFORT                  │                    EFFORT
    │                   │                   │
    │  🟢 QUICK WINS    │  🔵 CONSIDER      │
    │  Format fixes     │  Major refactor   │
    │  Missing fields   │  Architecture     │
    │                   │                   │
    └───────────────────┼───────────────────┘
                        │
                    LOW IMPACT
```

---

## 1. Reasoning Improvements

### 1.1 Add Edge Case Handling

**Pattern**: Explicit edge case documentation

```yaml
# In knowledge file:
edge_cases:
  empty_input:
    check: "if len(input) == 0"
    action: "return empty result with message"
    example: |
      def process(items):
          if not items:
              return {"result": [], "message": "No items to process"}
          # normal processing...

  null_values:
    check: "if value is None"
    action: "use default or ask for input"

  circular_deps:
    check: "detect cycles before traversal"
    action: "return error with cycle path"
    example: |
      def detect_cycle(graph, node, visited, path):
          if node in path:
              cycle = path[path.index(node):]
              raise CyclicDependencyError(f"Cycle: {' -> '.join(cycle)}")
```

**Checklist**:
- [ ] Empty/null handling documented
- [ ] Boundary conditions covered
- [ ] Circular dependencies detected
- [ ] Examples for each edge case

---

### 1.2 Strengthen Multi-step Reasoning

**Pattern**: Chain of thought template

```yaml
# In activation protocol:
reasoning_protocol:
  steps:
    1: "State the problem clearly"
    2: "List known facts and constraints"
    3: "Identify what needs to be derived"
    4: "Apply reasoning rules step by step"
    5: "Verify conclusion against constraints"
    6: "State final answer with reasoning chain"

  example: |
    Problem: A > B, B > C, C > D. Is A > D?

    Step 1: Compare A and D transitively
    Step 2: Known: A > B, B > C, C > D
    Step 3: Need to derive: relationship between A and D
    Step 4: By transitivity:
            - A > B (given)
            - B > C (given) → A > C
            - C > D (given) → A > D
    Step 5: Check: A > D follows from chain
    Step 6: Answer: Yes, A > D by transitivity
```

---

### 1.3 Avoid Logical Fallacies

**Pattern**: Fallacy detection checklist

```yaml
# In knowledge:
common_fallacies:
  circular_reasoning:
    detect: "Conclusion appears in premises"
    fix: "Find external evidence"
    example:
      bad: "X is true because X is correct"
      good: "X is true because evidence Y and Z support it"

  affirming_consequent:
    detect: "If A then B. B is true. Therefore A."
    fix: "Consider alternative causes for B"
    example:
      bad: "If rain, ground wet. Ground wet → it rained"
      good: "Ground could be wet from sprinkler, spill, etc."

  false_dichotomy:
    detect: "Only two options presented"
    fix: "Explore middle ground and alternatives"

  hasty_generalization:
    detect: "Conclusion from insufficient sample"
    fix: "Gather more data, qualify conclusion"
```

---

## 2. Knowledge Improvements

### 2.1 Increase Depth

**Pattern**: Layered knowledge structure

```markdown
# Topic: Caching

## Level 1: Overview (for beginners)
- What is caching?
- Why use it?
- Basic patterns

## Level 2: Implementation (for practitioners)
- Cache-aside pattern
- Write-through vs write-behind
- TTL strategies
- Eviction policies (LRU, LFU, FIFO)

## Level 3: Advanced (for experts)
- Distributed caching
- Cache coherence
- Thundering herd prevention
- Cache warming strategies
- Multi-tier caching

## Level 4: Trade-offs (for architects)
- Consistency vs availability
- Memory vs performance
- Complexity vs benefit
- When NOT to cache
```

---

### 2.2 Add Code Examples

**Pattern**: Every concept = code

```markdown
# Concept: Dependency Injection

## Definition
Dependency Injection is a design pattern where dependencies are provided
to a class rather than created within it.

## Example (Python)

```python
# BAD: Hard-coded dependency
class UserService:
    def __init__(self):
        self.db = PostgresDatabase()  # Can't change, can't test

# GOOD: Injected dependency
class UserService:
    def __init__(self, db: Database):
        self.db = db  # Flexible, testable

# Usage
service = UserService(PostgresDatabase())  # Production
service = UserService(MockDatabase())      # Testing
```

## When to Use
- When you need to swap implementations
- When testing with mocks
- When following SOLID principles
```

---

### 2.3 Keep Information Current

**Pattern**: Version-aware documentation

```yaml
# In knowledge files:
metadata:
  topic: "React State Management"
  last_updated: "2026-01-03"
  applies_to: "React 18+"
  deprecated_in: null

# Version-specific notes:
version_notes:
  - version: "18.0+"
    feature: "Concurrent rendering"
    note: "State updates may be batched differently"

  - version: "17.0"
    feature: "Legacy context"
    note: "Use new Context API instead"
    deprecated: true
```

---

## 3. Adaptability Improvements

### 3.1 Add Clarification Protocol

**Pattern**: Structured clarification

```yaml
# In activation:
clarification_protocol:
  trigger_phrases:
    - "fix"        # Fix what?
    - "improve"    # Improve how?
    - "the bug"    # Which bug?
    - "it"         # What is 'it'?
    - "that thing" # What thing?

  response_template: |
    I need a bit more context to help effectively:

    1. **What specifically?** [describe the target]
    2. **Where?** [file, function, component]
    3. **Current behavior?** [what happens now]
    4. **Expected behavior?** [what should happen]

    Please provide any of the above that's missing.

  example:
    input: "Fix the bug"
    output: |
      I'd be happy to help fix the bug! Could you tell me:

      1. Which component or file has the bug?
      2. What's the current (incorrect) behavior?
      3. What should happen instead?
      4. Any error messages you're seeing?
```

---

### 3.2 Improve Error Messages

**Pattern**: Helpful error template

```yaml
error_template:
  structure:
    - what: "Brief description of what went wrong"
    - why: "Likely cause (if known)"
    - how: "Suggested fix or next step"
    - context: "Relevant information for debugging"

  example:
    input: "Read /nonexistent/file.txt"
    output: |
      ❌ **Error**: File not found

      **Path**: /nonexistent/file.txt
      **Cause**: The file doesn't exist at this location

      **Suggestions**:
      1. Check if the path is correct: `ls /nonexistent/`
      2. Verify file permissions: `ls -la /nonexistent/file.txt`
      3. If creating new file, use: `touch /nonexistent/file.txt`

      **Did you mean**: /existing/file.txt (similar path found)
```

---

### 3.3 State Assumptions Explicitly

**Pattern**: Assumption declaration

```yaml
assumption_protocol:
  when: "Before taking action on incomplete information"

  template: |
    ⚠️ **Assumptions being made**:
    {list assumptions}

    If any of these are incorrect, please let me know.

  example:
    input: "Deploy the app"
    output: |
      I'll deploy the app with these assumptions:

      ⚠️ **Assumptions**:
      1. Target: Production environment
      2. Method: Docker container to Kubernetes
      3. Config: Using values from `.env.production`
      4. Tests: All passing (skip pre-deploy tests)

      Should I proceed, or adjust any of these?
```

---

## 4. Output Improvements

### 4.1 Standardize Format

**Pattern**: Output templates

```yaml
output_templates:
  analysis:
    structure:
      - summary (1-2 sentences)
      - findings (bulleted list)
      - recommendations (numbered)
      - next_steps (actionable)

  code_solution:
    structure:
      - explanation (what and why)
      - code (with comments)
      - usage (how to use)
      - notes (edge cases, alternatives)

  comparison:
    structure:
      - summary
      - table (feature comparison)
      - recommendation
      - caveats
```

---

### 4.2 Lead with Key Information

**Pattern**: Inverted pyramid

```markdown
# Structure: Most important first

## Summary (THE answer)
Use Redis for this use case.

## Key Reasons (WHY)
1. Persistence needed
2. Complex data structures
3. Pub/sub requirements

## Detailed Analysis (FULL context)
[detailed comparison...]

## Alternatives Considered
[other options...]
```

---

### 4.3 Include Actionable Steps

**Pattern**: Every output ends with action

```yaml
action_protocol:
  rule: "Every analysis must end with concrete next steps"

  template: |
    ## Next Steps
    1. [First action to take]
    2. [Second action]
    3. [Verification step]

  example:
    analysis: "Performance bottleneck in database queries"
    next_steps: |
      ## Next Steps
      1. Add index: `CREATE INDEX idx_user_id ON orders(user_id);`
      2. Enable query logging: Set `log_min_duration_statement = 1000`
      3. Monitor: Run `SELECT * FROM pg_stat_user_indexes;`
      4. Verify: Re-run benchmark after changes
```

---

## 5. Compliance Improvements

### 5.1 Complete Metadata

**Pattern**: v2.0 metadata checklist

```yaml
# Required fields (auto-fix template):
agent:
  metadata:
    id: "{name}"           # kebab-case
    name: "{Name}"         # Human readable
    title: "{Role}"        # Role description
    icon: "🤖"            # Emoji
    color: gray            # Default
    version: "1.0"         # Semver
    model: sonnet          # Default
    language: vi           # Explicit

  persona:
    role: "{Role description}"
    identity: "{Identity description}"

  activation:
    critical: true
    steps:
      - "Load persona"
      - "Display menu"
      - "Wait for command"
```

---

### 5.2 Implement Memory System

**Pattern**: Memory file templates

```markdown
# memory/context.md
# Agent Context
> Current session context and active work.

## Current Focus
[What the agent is currently working on]

## Recent Actions
- [Date]: [Action taken]

## Pending Items
- [Items waiting for user input]

---

# memory/decisions.md
# Decisions Log
> Record of significant decisions and rationale.

## Recent Decisions
| Date | Decision | Rationale | Outcome |
|------|----------|-----------|---------|
| | | | |

---

# memory/learnings.md
# Learnings
> Patterns and insights discovered.

## Patterns Identified
- [Pattern]: [Description]

## Anti-patterns to Avoid
- [Anti-pattern]: [Why to avoid]
```

---

## Improvement Priority Guide

| Weakness | Priority | Effort | Impact | Fix |
|----------|----------|--------|--------|-----|
| No clarification | 🔴 HIGH | Low | High | Add protocol |
| Edge case gaps | 🔴 HIGH | Medium | High | Document cases |
| Missing examples | 🟡 MEDIUM | Medium | Medium | Add code |
| Outdated info | 🟡 MEDIUM | Medium | Medium | Update files |
| Format inconsistent | 🟢 LOW | Low | Low | Add templates |
| Missing fields | 🟢 LOW | Low | Low | Auto-fix |

---

## Quick Improvement Checklist

```markdown
# Before Release Checklist

## Critical (Must Fix)
- [ ] Clarification protocol exists
- [ ] Edge cases documented
- [ ] All required metadata fields present

## Important (Should Fix)
- [ ] ≥3 code examples per concept
- [ ] Multi-step reasoning examples
- [ ] Error message templates

## Nice to Have
- [ ] Memory system implemented
- [ ] Assumption declaration protocol
- [ ] Output templates standardized
```
