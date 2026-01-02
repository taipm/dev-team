# Math Team

> Signal-based orchestration team for solving mathematical problems

## Overview

Math Team uses a **signal-based architecture** where each agent emits signals upon completion, automatically triggering the next agent in the workflow.

## Signal Flow

```
INPUT (Problem)
    ↓ signal: problem_received
ANALYZER (phân tích đề, xác định 2-3 hướng)
    ↓ signal: analysis_complete
MAESTRO (điều phối)
    ↓ signal: solvers_dispatched
    ┌───────┬───────┬───────┐
    ↓       ↓       ↓       │ PARALLEL
SOLVER A  SOLVER B  SOLVER C │ (max 3)
    ↓       ↓       ↓       │
    └───────┴───────┴───────┘
    ↓ signal: all_solutions_ready (wait_all)
SYNTHESIZER (so sánh, chọn best)
    ↓ signal: synthesis_complete
LATEX EDITOR (format + PDF)
    ↓ signal: document_ready
OUTPUT (PDF)
```

## Quick Start

```bash
# Invoke via slash command
/microai:math-team "Giải phương trình x² - 5x + 6 = 0"

# With options
/microai:math-team --style=detailed "Chứng minh √2 là số vô tỉ"
/microai:math-team --style=olympiad "Tìm tất cả số nguyên dương n sao cho n² + 1 chia hết cho n + 1"
```

## Agents

| Agent | Role | Model |
|-------|------|-------|
| math-maestro | Orchestrator | opus |
| math-scribe | Logger (silent) | haiku |
| problem-analyzer | Classify & identify approaches | sonnet |
| algebraic-solver | Equations, inequalities | sonnet |
| geometric-solver | Geometry, coordinates | sonnet |
| calculus-solver | Limits, derivatives, integrals | sonnet |
| combinatorics-solver | Counting, probability | sonnet |
| number-theory-solver | Divisibility, modular (Olympic) | opus |
| math-synthesizer | Compare & select best | opus |
| latex-editor | PDF generation | sonnet |

## Output Styles

| Style | Description |
|-------|-------------|
| `detailed` | Textbook style - giải thích từng bước (default) |
| `concise` | Paper style - gọn, chuyên nghiệp |
| `olympiad` | Competition style - highlight tricks |

## Problem Types Supported

- **Algebra**: Equations, inequalities, polynomials
- **Geometry**: Euclidean, analytic, trigonometry
- **Calculus**: Limits, derivatives, integrals
- **Combinatorics**: Counting, probability, discrete math
- **Number Theory**: Divisibility, modular arithmetic (Olympic)

## Configuration

See `config/config.yaml` for customizable settings:
- Max parallel solvers (default: 3)
- Timeout per solver
- Default output style
- Checkpoint behavior

## References

- Signal Schema: `signals/signal-schema.yaml`
- Workflow: `workflow.md`
- Agent Registry: `agent-registry.yaml`
