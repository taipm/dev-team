# Scoring Rubrics

> Chi tiết cách tính điểm cho từng dimension.

---

## Static Analysis Rubrics (40 points)

### Structure Check (10 points)

| Check | Points | Pass Criteria |
|-------|--------|---------------|
| Directory exists | 2 | `.microai/agents/{name}/` exists |
| agent.md present | 2 | Valid markdown with YAML frontmatter |
| knowledge/ exists | 2 | Directory with ≥1 .md file |
| memory/ exists | 2 | Directory with context.md |
| Command registered | 2 | `.claude/commands/microai/{name}.md` exists |

### Metadata Compliance (10 points)

| Check | Points | Pass Criteria |
|-------|--------|---------------|
| id field | 2 | kebab-case, unique |
| name field | 2 | Human-readable name |
| model field | 2 | Valid: opus/sonnet/haiku |
| language field | 2 | Explicit: vi/en |
| persona section | 2 | role + identity defined |

### Knowledge Coverage (10 points)

| Check | Points | Pass Criteria |
|-------|--------|---------------|
| File count | 3 | ≥3 knowledge files |
| knowledge-index.yaml | 2 | Valid index exists |
| Code examples | 3 | ≥3 code blocks in files |
| Anti-patterns | 2 | Documented what NOT to do |

### Design Patterns (10 points)

| Check | Points | Pass Criteria |
|-------|--------|---------------|
| Activation protocol | 3 | Clear numbered steps |
| Menu system | 3 | Commands with triggers |
| Workflow references | 2 | External YAML workflows |
| Principles defined | 2 | ≥3 guiding principles |

---

## Dynamic Testing Rubrics (40 points)

### Reasoning Tests (15 points)

#### Logic Tests (5 points)

| Test | Points | Expected |
|------|--------|----------|
| Syllogism | 2 | Correct deduction |
| Transitivity | 2 | A→B, B→C ⟹ A→C |
| Negation | 1 | Handle "not" correctly |

**Test Cases:**

```yaml
logic_tests:
  - id: L1
    prompt: "All A are B. All B are C. Is all A are C?"
    expected: "Yes"
    keywords: ["yes", "correct", "true", "đúng"]
    points: 2

  - id: L2
    prompt: "If it rains, the ground is wet. The ground is wet. Did it rain?"
    expected: "Not necessarily (affirming the consequent fallacy)"
    keywords: ["not necessarily", "cannot conclude", "fallacy"]
    points: 2

  - id: L3
    prompt: "No cats are dogs. Some pets are cats. Can some pets be dogs?"
    expected: "Yes, some pets can still be dogs"
    keywords: ["yes", "possible"]
    points: 1
```

#### Multi-step Tests (5 points)

```yaml
multistep_tests:
  - id: M1
    prompt: "Task A depends on B. B depends on C. C depends on D. What execution order?"
    expected: "D → C → B → A"
    keywords: ["D", "C", "B", "A"]
    order_matters: true
    points: 3

  - id: M2
    prompt: |
      There are 3 boxes: Red, Blue, Green.
      - Red is left of Blue
      - Green is right of Blue
      What is the order from left to right?
    expected: "Red, Blue, Green"
    keywords: ["Red", "Blue", "Green"]
    order_matters: true
    points: 2
```

#### Edge Case Tests (5 points)

```yaml
edge_tests:
  - id: E1
    prompt: "A depends on B. B depends on A. What happens?"
    expected: "Circular dependency error"
    keywords: ["circular", "cycle", "error", "cannot"]
    points: 3

  - id: E2
    prompt: "Sort this list: []. What is the result?"
    expected: "Empty list []"
    keywords: ["empty", "[]", "nothing"]
    points: 2
```

### Knowledge Tests (10 points)

**Domain-specific tests generated based on agent type:**

```yaml
knowledge_tests:
  dev_agent:
    - prompt: "What are the SOLID principles?"
      keywords: ["Single responsibility", "Open-closed", "Liskov", "Interface segregation", "Dependency inversion"]
      points: 3

    - prompt: "When should you use composition over inheritance?"
      keywords: ["flexibility", "loose coupling", "has-a", "is-a"]
      points: 2

  qa_agent:
    - prompt: "What is the test pyramid?"
      keywords: ["unit", "integration", "e2e", "pyramid"]
      points: 3

    - prompt: "What is boundary value analysis?"
      keywords: ["edge", "boundary", "min", "max", "valid", "invalid"]
      points: 2
```

### Adaptability Tests (10 points)

#### Ambiguity Handling (5 points)

```yaml
ambiguity_tests:
  - id: A1
    prompt: "Fix the bug"
    expected: "Ask for clarification"
    keywords: ["which", "what", "where", "more information", "clarify"]
    points: 3

  - id: A2
    prompt: "Make it faster"
    expected: "Ask what specifically to optimize"
    keywords: ["what", "which", "specify", "clarify"]
    points: 2
```

#### Error Recovery (5 points)

```yaml
recovery_tests:
  - id: R1
    prompt: "Run command: xyz_invalid_command_123"
    expected: "Graceful error message + suggestion"
    keywords: ["error", "not found", "did you mean", "try", "suggestion"]
    points: 3

  - id: R2
    prompt: "Read file: /nonexistent/path/file.txt"
    expected: "Handle gracefully, suggest alternatives"
    keywords: ["not exist", "cannot", "check", "try"]
    points: 2
```

### Output Quality Tests (5 points)

```yaml
output_tests:
  - id: O1
    prompt: "Explain recursion in 3 sentences"
    criteria:
      - length: "≤3 sentences"
      - clarity: "Understandable by beginner"
      - accuracy: "Technically correct"
    points: 3

  - id: O2
    prompt: "List 5 benefits of version control"
    criteria:
      - count: "Exactly 5 items"
      - format: "Numbered or bulleted list"
      - relevance: "All items about version control"
    points: 2
```

---

## Synthesis Scoring (20 points)

### Cross-dimension Analysis (8 points)

| Check | Points | Criteria |
|-------|--------|----------|
| Consistency | 4 | Similar quality across dimensions |
| Balance | 4 | No dimension severely lacking |

### Pattern Recognition (6 points)

| Check | Points | Criteria |
|-------|--------|----------|
| Strengths identified | 3 | Top 2-3 clear strengths |
| Weaknesses identified | 3 | Clear gaps documented |

### Confidence Level (6 points)

| Level | Points | When to assign |
|-------|--------|----------------|
| High | 6 | All tests completed, consistent results |
| Medium | 4 | Some tests failed/skipped |
| Low | 2 | Many tests failed, inconsistent |

---

## Score Calculation

```python
def calculate_score(static, dynamic, synthesis):
    """
    static: dict with structure, metadata, knowledge, design
    dynamic: dict with reasoning, knowledge, adaptability, output
    synthesis: dict with cross_dim, patterns, confidence
    """

    # Static (40 points max)
    static_score = sum([
        static['structure'],      # max 10
        static['metadata'],       # max 10
        static['knowledge'],      # max 10
        static['design']          # max 10
    ])

    # Dynamic (40 points max)
    dynamic_score = sum([
        dynamic['reasoning'],     # max 15
        dynamic['knowledge'],     # max 10
        dynamic['adaptability'],  # max 10
        dynamic['output']         # max 5
    ])

    # Synthesis (20 points max)
    synthesis_score = sum([
        synthesis['cross_dim'],   # max 8
        synthesis['patterns'],    # max 6
        synthesis['confidence']   # max 6
    ])

    total = static_score + dynamic_score + synthesis_score

    # Grade assignment
    if total >= 90: grade = 'A+'
    elif total >= 80: grade = 'A'
    elif total >= 70: grade = 'B'
    elif total >= 60: grade = 'C'
    elif total >= 50: grade = 'D'
    else: grade = 'F'

    return {
        'total': total,
        'grade': grade,
        'breakdown': {
            'static': static_score,
            'dynamic': dynamic_score,
            'synthesis': synthesis_score
        }
    }
```

---

## Visual Score Display

```
╔═══════════════════════════════════════════════════════════════╗
║  DIMENSION BREAKDOWN                                            ║
├───────────────────────────────────────────────────────────────┤
║  Reasoning:      21/25  ████████████████████░░░░░  84%         ║
║  Knowledge:      18/20  ██████████████████░░░░░░░  90%         ║
║  Adaptability:   15/20  ███████████████░░░░░░░░░░  75%         ║
║  Output Quality: 16/20  ████████████████░░░░░░░░░  80%         ║
║  Compliance:     12/15  ████████████████░░░░░░░░░  80%         ║
╚═══════════════════════════════════════════════════════════════╝
```

Progress bar calculation:
```python
def progress_bar(score, max_score, width=20):
    filled = int((score / max_score) * width)
    empty = width - filled
    return '█' * filled + '░' * empty
```
