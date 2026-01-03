# 5 Intelligence Dimensions

> Framework đánh giá mức độ thông minh của agents.

---

## Overview

Agent intelligence được đo lường qua 5 dimensions độc lập:

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGENT INTELLIGENCE                            │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────┐│
│  │REASONING │  │KNOWLEDGE │  │ADAPTABLE │  │ OUTPUT   │  │SPEC││
│  │   25%    │  │   20%    │  │   20%    │  │   20%    │  │15% ││
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  └────┘│
└─────────────────────────────────────────────────────────────────┘
```

---

## Dimension 1: Reasoning (25 points)

> Khả năng suy luận logic, giải quyết vấn đề, tư duy đa bước.

### Sub-dimensions

| ID | Sub-dimension | Points | Description |
|----|---------------|--------|-------------|
| R1 | Logic | 8 | Syllogism, deduction, induction |
| R2 | Multi-step | 8 | Chain reasoning, dependency resolution |
| R3 | Edge cases | 5 | Circular dependencies, contradictions |
| R4 | Abstraction | 4 | Pattern recognition, generalization |

### Evaluation Method

```yaml
static_checks:
  - Has reasoning patterns in knowledge?
  - Has thinking framework references?
  - Has problem-solving examples?

dynamic_tests:
  - Logic puzzles (syllogism, transitivity)
  - Multi-step problems (dependency chains)
  - Edge cases (cycles, contradictions)
  - Abstraction tests (find patterns)
```

### Scoring Rubric

| Score | Description |
|-------|-------------|
| 23-25 | Excellent - Handles complex multi-step reasoning with edge cases |
| 18-22 | Good - Solid logic, occasional gaps in edge cases |
| 13-17 | Fair - Basic reasoning, struggles with multi-step |
| 8-12 | Poor - Inconsistent logic, many errors |
| 0-7 | Failing - Cannot reason through simple problems |

---

## Dimension 2: Knowledge (20 points)

> Độ sâu và breadth của domain knowledge.

### Sub-dimensions

| ID | Sub-dimension | Points | Description |
|----|---------------|--------|-------------|
| K1 | Domain depth | 8 | Expert-level knowledge in primary domain |
| K2 | Breadth | 5 | Cross-domain awareness |
| K3 | Accuracy | 4 | Factual correctness |
| K4 | Currency | 3 | Up-to-date information |

### Evaluation Method

```yaml
static_checks:
  - Knowledge files count and coverage
  - Code examples quality and quantity
  - Reference to external resources
  - Domain-specific terminology usage

dynamic_tests:
  - Domain-specific questions
  - Fact verification tests
  - Cross-domain reasoning
```

### Scoring Rubric

| Score | Description |
|-------|-------------|
| 18-20 | Expert - Deep domain knowledge, accurate, current |
| 14-17 | Advanced - Good coverage, minor gaps |
| 10-13 | Competent - Basic knowledge, some inaccuracies |
| 6-9 | Limited - Shallow knowledge, outdated |
| 0-5 | Failing - Incorrect or missing knowledge |

---

## Dimension 3: Adaptability (20 points)

> Khả năng xử lý edge cases, ambiguity, và recovery.

### Sub-dimensions

| ID | Sub-dimension | Points | Description |
|----|---------------|--------|-------------|
| A1 | Ambiguity handling | 7 | Clarification requests, assumptions |
| A2 | Error recovery | 6 | Graceful failures, suggestions |
| A3 | Edge cases | 4 | Unusual inputs, boundary conditions |
| A4 | Context switching | 3 | Multi-topic conversations |

### Evaluation Method

```yaml
static_checks:
  - Has clarification protocol?
  - Has error handling patterns?
  - Has edge case documentation?

dynamic_tests:
  - Ambiguous prompts (no context given)
  - Invalid inputs (error recovery)
  - Boundary conditions
  - Topic switching mid-conversation
```

### Scoring Rubric

| Score | Description |
|-------|-------------|
| 18-20 | Excellent - Gracefully handles all ambiguity and errors |
| 14-17 | Good - Asks for clarification, recovers from most errors |
| 10-13 | Fair - Some clarification, basic error handling |
| 6-9 | Poor - Assumes too much, crashes on errors |
| 0-5 | Failing - Cannot handle any ambiguity |

---

## Dimension 4: Output Quality (20 points)

> Accuracy, completeness, và usefulness của output.

### Sub-dimensions

| ID | Sub-dimension | Points | Description |
|----|---------------|--------|-------------|
| O1 | Accuracy | 7 | Correct answers, no hallucinations |
| O2 | Completeness | 5 | All aspects covered |
| O3 | Formatting | 4 | Clear structure, readable |
| O4 | Actionability | 4 | Practical, executable advice |

### Evaluation Method

```yaml
static_checks:
  - Has output templates?
  - Has formatting guidelines?
  - Has actionable patterns?

dynamic_tests:
  - Accuracy verification against known answers
  - Completeness check (missing aspects)
  - Format consistency
  - Actionability scoring
```

### Scoring Rubric

| Score | Description |
|-------|-------------|
| 18-20 | Excellent - Accurate, complete, well-formatted, actionable |
| 14-17 | Good - Mostly accurate, minor gaps, good format |
| 10-13 | Fair - Some errors, incomplete, acceptable format |
| 6-9 | Poor - Many errors, often incomplete, poor format |
| 0-5 | Failing - Incorrect, unusable outputs |

---

## Dimension 5: Spec Compliance (15 points)

> Tuân thủ v2.0 agent specification và best practices.

### Sub-dimensions

| ID | Sub-dimension | Points | Description |
|----|---------------|--------|-------------|
| S1 | Structure | 5 | Directory, files, naming |
| S2 | Metadata | 5 | Required fields, format |
| S3 | Best practices | 5 | Patterns, anti-patterns avoided |

### Evaluation Method

```yaml
static_checks:
  - Directory structure correct?
  - All required metadata fields present?
  - Knowledge files properly named?
  - Memory system implemented?
  - Activation protocol complete?

# No dynamic tests - purely structural
```

### Scoring Rubric

| Score | Description |
|-------|-------------|
| 14-15 | Full compliance - All requirements met |
| 11-13 | Good - Minor deviations only |
| 8-10 | Fair - Some missing elements |
| 4-7 | Poor - Significant gaps |
| 0-3 | Failing - Does not follow spec |

---

## Weighted Total Score

```
Total = (Reasoning × 1.0) + (Knowledge × 1.0) +
        (Adaptability × 1.0) + (Output × 1.0) +
        (Compliance × 1.0)

Max = 25 + 20 + 20 + 20 + 15 = 100
```

### Grade Scale

| Score | Grade | Level | Description |
|-------|-------|-------|-------------|
| 90-100 | A+ | Exceptional | Top-tier agent, handles complex tasks |
| 80-89 | A | Advanced | Strong across all dimensions |
| 70-79 | B | Competent | Solid performance, some limitations |
| 60-69 | C | Basic | Functional but many gaps |
| 50-59 | D | Limited | Needs significant improvement |
| <50 | F | Failing | Major rework required |

---

## Dimension Interactions

```
Reasoning ←→ Knowledge
    ↓           ↓
Adaptability ←→ Output Quality
         ↘   ↙
       Compliance
```

- **Reasoning + Knowledge**: Deep reasoning requires domain knowledge
- **Adaptability + Output**: Error recovery affects output quality
- **All → Compliance**: Good structure enables all other dimensions
