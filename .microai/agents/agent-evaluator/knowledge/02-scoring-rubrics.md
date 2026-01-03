# Scoring Rubrics v2.0

> Chi tiết cách tính điểm với Real Execution Testing.
> Updated: 2026-01-03

---

## Score Distribution Overview

```
╔═══════════════════════════════════════════════════════════════════════╗
║           AGENT INTELLIGENCE SCORING v2.0                              ║
╠═══════════════════════════════════════════════════════════════════════╣
║                                                                        ║
║  PHASE A: STATIC ANALYSIS         30 points (30%)                     ║
║  ├── Structure Check               8 points                            ║
║  ├── Metadata Compliance           8 points                            ║
║  ├── Knowledge Coverage            7 points                            ║
║  └── Design Patterns               7 points                            ║
║                                                                        ║
║  PHASE B: DYNAMIC TESTING         55 points (55%) ★ REAL EXECUTION    ║
║  ├── Reasoning Tests              20 points                            ║
║  ├── Adaptability Tests           15 points                            ║
║  ├── Output Quality Tests         10 points                            ║
║  └── Creativity Tests (NEW)       10 points                            ║
║                                                                        ║
║  PHASE C: SYNTHESIS               15 points (15%)                     ║
║  ├── Cross-dimension Analysis      6 points                            ║
║  ├── Pattern Recognition           5 points                            ║
║  └── Confidence Level              4 points                            ║
║                                                                        ║
║  TOTAL:                          100 points                            ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
```

**Key Change in v2.0**: Dynamic Testing increased from 40% to 55% based on Deep Thinking Team analysis.

---

## Phase A: Static Analysis (30 points)

### A1. Structure Check (8 points)

| Check | Points | Pass Criteria |
|-------|--------|---------------|
| Directory exists | 2 | `.microai/agents/{name}/` exists |
| agent.md present | 2 | Valid markdown with YAML frontmatter |
| knowledge/ exists | 2 | Directory with ≥1 .md file |
| memory/ exists | 1 | Directory with context.md |
| Command registered | 1 | `.claude/commands/microai/{name}.md` exists |

### A2. Metadata Compliance (8 points)

| Check | Points | Pass Criteria |
|-------|--------|---------------|
| id field | 2 | kebab-case, unique |
| name + version | 2 | Human-readable name, semver version |
| model field | 2 | Valid: opus/sonnet/haiku |
| persona section | 2 | role + identity + principles defined |

### A3. Knowledge Coverage (7 points)

| Check | Points | Pass Criteria |
|-------|--------|---------------|
| File count | 2 | ≥3 knowledge files |
| knowledge-index.yaml | 2 | Valid index with auto_load rules |
| Code examples | 2 | ≥3 code blocks in knowledge files |
| Anti-patterns | 1 | Documented what NOT to do |

### A4. Design Patterns (7 points)

| Check | Points | Pass Criteria |
|-------|--------|---------------|
| Activation protocol | 2 | Clear activation steps |
| Clarification protocol | 2 | Handles ambiguous inputs |
| Error recovery | 2 | Graceful error handling defined |
| Menu system | 1 | Commands with triggers |

---

## Phase B: Dynamic Testing (55 points) ★

### Execution Provider

```yaml
provider:
  primary: ollama
  model: "qwen3:1.7b"
  timeout: 30
  script: ".microai/skills/development-skills/ollama/scripts/ollama-run.sh"

fallback:
  provider: claude
  model: sonnet
  timeout: 60
```

### B1. Reasoning Tests (20 points)

#### Logic Tests (7 points)

| ID | Test | Points | Keywords |
|----|------|--------|----------|
| R-L1 | Syllogism (A→B, B→C, A→C?) | 2 | yes, correct, true |
| R-L2 | Affirming consequent fallacy | 3 | not necessarily, cannot conclude |
| R-L3 | Negative quantifier | 2 | no, not all, some cannot |

#### Multi-step Reasoning (8 points)

| ID | Test | Points | Keywords |
|----|------|--------|----------|
| R-M1 | Dependency order (A←B←C←D) | 3 | D, C, B, A (order matters) |
| R-M2 | Cascade failure analysis | 3 | API, Web, both, all |
| R-M3 | Sequential task calculation | 2 | 6, six, hours |

#### Edge Case Handling (5 points)

| ID | Test | Points | Keywords |
|----|------|--------|----------|
| R-E1 | Circular dependency detection | 3 | circular, cycle, infinite, loop |
| R-E2 | Division by zero | 2 | error, exception, undefined |

### B2. Adaptability Tests (15 points)

#### Ambiguity Handling (8 points)

| ID | Test | Points | Expected Response |
|----|------|--------|-------------------|
| A-A1 | "Fix the bug" | 3 | Ask: which bug? what file? |
| A-A2 | "Make it faster" | 3 | Ask: what specifically to optimize? |
| A-A3 | "Review the code" | 2 | Ask: which files? focus area? |

#### Error Recovery (7 points)

| ID | Test | Points | Expected Response |
|----|------|--------|-------------------|
| A-R1 | Invalid command | 3 | Graceful error + suggestion |
| A-R2 | Nonexistent file | 2 | Handle + suggest check |
| A-R3 | Unknown environment | 2 | List available options |

### B3. Output Quality Tests (10 points)

| ID | Test | Points | Criteria |
|----|------|--------|----------|
| O-F1 | List exactly 3 items | 3 | Format compliance |
| O-F2 | Explain in 2 sentences | 3 | Constraint following |
| O-C1 | 4 pillars of OOP | 4 | Completeness + accuracy |

### B4. Creativity Tests (10 points) ★ NEW

| ID | Test | Points | Assessment |
|----|------|--------|------------|
| C-N1 | Novel solutions (not caching) | 4 | Propose unconventional ideas |
| C-N2 | Production-only debug | 3 | Problem-solving approach |
| C-P1 | Reframe perception problem | 3 | Think beyond obvious |

---

## Phase C: Synthesis (15 points)

### C1. Cross-dimension Analysis (6 points)

| Check | Points | Criteria |
|-------|--------|----------|
| Consistency | 3 | Similar quality across dimensions |
| Balance | 3 | No dimension severely lacking (<50%) |

### C2. Pattern Recognition (5 points)

| Check | Points | Criteria |
|-------|--------|----------|
| Strengths identified | 2.5 | Top 2-3 clear strengths |
| Weaknesses identified | 2.5 | Clear gaps with evidence |

### C3. Confidence Level (4 points)

| Level | Points | When |
|-------|--------|------|
| High | 4 | All tests completed, consistent |
| Medium | 2-3 | Some tests failed/skipped |
| Low | 0-1 | Many failures, inconsistent |

---

## Grade Assignment

| Score | Grade | Level | Description |
|-------|-------|-------|-------------|
| 90-100 | A+ | Exceptional | Production-ready, handles complex tasks |
| 80-89 | A | Advanced | Strong reasoning, few gaps |
| 70-79 | B | Competent | Solid but has limitations |
| 60-69 | C | Basic | Functional but many gaps |
| 50-59 | D | Limited | Needs significant improvements |
| <50 | F | Failing | Not production-ready |

---

## Score Calculation (Python)

```python
def calculate_score_v2(static: dict, dynamic: dict, synthesis: dict) -> dict:
    """
    v2.0 scoring with increased dynamic weight.

    static: {structure, metadata, knowledge, design}
    dynamic: {reasoning, adaptability, output, creativity}
    synthesis: {cross_dim, patterns, confidence}
    """

    # Phase A: Static (30 points max)
    static_score = sum([
        min(static.get('structure', 0), 8),
        min(static.get('metadata', 0), 8),
        min(static.get('knowledge', 0), 7),
        min(static.get('design', 0), 7)
    ])

    # Phase B: Dynamic (55 points max) ★
    dynamic_score = sum([
        min(dynamic.get('reasoning', 0), 20),
        min(dynamic.get('adaptability', 0), 15),
        min(dynamic.get('output', 0), 10),
        min(dynamic.get('creativity', 0), 10)
    ])

    # Phase C: Synthesis (15 points max)
    synthesis_score = sum([
        min(synthesis.get('cross_dim', 0), 6),
        min(synthesis.get('patterns', 0), 5),
        min(synthesis.get('confidence', 0), 4)
    ])

    total = static_score + dynamic_score + synthesis_score

    # Grade assignment
    if total >= 90: grade, level = 'A+', 'Exceptional'
    elif total >= 80: grade, level = 'A', 'Advanced'
    elif total >= 70: grade, level = 'B', 'Competent'
    elif total >= 60: grade, level = 'C', 'Basic'
    elif total >= 50: grade, level = 'D', 'Limited'
    else: grade, level = 'F', 'Failing'

    return {
        'total': total,
        'grade': grade,
        'level': level,
        'breakdown': {
            'static': {'score': static_score, 'max': 30, 'pct': round(static_score/30*100)},
            'dynamic': {'score': dynamic_score, 'max': 55, 'pct': round(dynamic_score/55*100)},
            'synthesis': {'score': synthesis_score, 'max': 15, 'pct': round(synthesis_score/15*100)}
        }
    }
```

---

## Keyword Matching Rules

```yaml
matching:
  case_sensitive: false
  partial_match: true

  scoring:
    # Score = points * (matched_keywords / total_keywords)
    min_match_ratio: 0.5  # Need 50%+ keywords to pass

  weights:
    exact_match: 1.0
    partial_match: 0.7
    synonym_match: 0.5
```

---

## Visual Score Display

```
╔═══════════════════════════════════════════════════════════════╗
║  DIMENSION BREAKDOWN (v2.0)                                    ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                ║
║  STATIC (30 pts)                                               ║
║  Structure:     8/8   ████████████████████████  100%           ║
║  Metadata:      7/8   █████████████████████░░░   88%           ║
║  Knowledge:     6/7   █████████████████████░░░   86%           ║
║  Design:        7/7   ████████████████████████  100%           ║
║                                                                ║
║  DYNAMIC (55 pts) ★                                            ║
║  Reasoning:    18/20  ██████████████████░░░░░░   90%           ║
║  Adaptability: 13/15  █████████████████░░░░░░░   87%           ║
║  Output:        9/10  ██████████████████░░░░░░   90%           ║
║  Creativity:    8/10  ████████████████░░░░░░░░   80%           ║
║                                                                ║
║  SYNTHESIS (15 pts)                                            ║
║  Cross-dim:     5/6   ████████████████████░░░░   83%           ║
║  Patterns:      4/5   ████████████████░░░░░░░░   80%           ║
║  Confidence:    4/4   ████████████████████████  100%           ║
║                                                                ║
╠═══════════════════════════════════════════════════════════════╣
║  TOTAL: 89/100 (Grade A - Advanced)                            ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## Comparison: v1.0 vs v2.0

| Aspect | v1.0 | v2.0 | Rationale |
|--------|------|------|-----------|
| Static Analysis | 40% | 30% | Structure != Performance |
| Dynamic Testing | 40% | 55% | Real execution matters |
| Synthesis | 20% | 15% | Reduced but still important |
| Creativity | 0% | 10% | New dimension for novelty |
| Test Execution | Self-eval | Ollama/Claude | Actual agent responses |

---

## Domain-Specific Test Bonus

When agent domain is detected, bonus tests are added:

| Domain | Extra Tests | Max Bonus |
|--------|-------------|-----------|
| go_dev | 4 Go-specific tests | +15 pts (informational) |
| python_dev | 4 Python tests | +15 pts |
| qa | 4 QA/Testing tests | +15 pts |
| devops | 4 DevOps tests | +15 pts |

Domain tests are informational and don't change the 100-point base score.

---

*Scoring Rubrics v2.0 - Updated with Real Execution Testing*
