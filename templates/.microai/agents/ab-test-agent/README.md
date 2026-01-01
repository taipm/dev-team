# AB Test Agent (Fisher)

> "The best time to plan an experiment is after you've done it. But the second best time is before you run it with proper statistical rigor."

Agent chuyên thiết kế, phân tích và đánh giá A/B tests với statistical rigor, đặt theo tên R.A. Fisher - cha đẻ của thống kê hiện đại.

---

## Quick Start

```bash
# Invoke agent
/microai:ab-test

# Hoặc với mode cụ thể
/microai:ab-test "Thiết kế experiment cho feature X"
/microai:ab-test "Phân tích kết quả của test Y"
```

---

## Features

### 3 Modes Chính

| Mode | Mục đích | Trigger Keywords |
|------|----------|------------------|
| **Design** | Thiết kế experiment mới | design, thiết kế, sample size |
| **Analysis** | Phân tích kết quả | analyze, phân tích, p-value |
| **Review** | Audit experiment | review, đánh giá, audit |

### Statistical Methods

| Method | Approach | Output |
|--------|----------|--------|
| **Z-test** | Frequentist | P-value, CI |
| **T-test** | Frequentist | P-value, CI |
| **Beta-Binomial** | Bayesian | P(B>A), Expected Loss |
| **Sequential** | Either | Always-valid inference |

### Smart Features

- **Auto Mode Detection:** Weighted scoring để chọn mode phù hợp
- **Sample Size Calculator:** Tính sample size và duration
- **Pitfall Detection:** Cảnh báo common mistakes
- **Output Templates:** Pre-registration, Analysis Report, Audit Report

### Commands

```
Core:
*design         - Bắt đầu design experiment mới
*analyze        - Phân tích results
*review         - Audit experiment
*calculate      - Sample size calculator

Mode:
*frequentist    - Dùng frequentist approach
*bayesian       - Dùng Bayesian approach

Session:
*help           - Hiển thị commands
*frameworks     - Xem statistical frameworks
*pitfalls       - Xem common pitfalls
*summary        - Tổng hợp session
*exit           - Kết thúc session
```

---

## Use Cases

### 1. Design Mode
```
Input: "Thiết kế A/B test cho checkout flow mới"
Agent:
  - Thu thập hypothesis
  - Xác định metrics
  - Tính sample size
  - Tạo pre-registration document
Output: Experiment Design Document
```

### 2. Analysis Mode
```
Input: "Phân tích: Control 5%, Treatment 5.5%, n=10000 mỗi variant"
Agent:
  - Validate data (SRM check)
  - Tính p-value, CI
  - Assess practical significance
  - Recommend decision
Output: Analysis Report
```

### 3. Review Mode
```
Input: "Review experiment XYZ đã chạy 1 tuần"
Agent:
  - Check design phase
  - Check execution phase
  - Check analysis
  - Flag issues
Output: Audit Report
```

---

## Directory Structure

```
ab-test-agent/
├── agent.md                    # Agent definition
├── README.md                   # This file
├── knowledge/
│   ├── 01-statistical-frameworks.md    # Core statistics
│   ├── 02-experiment-design.md         # Design patterns
│   ├── 03-analysis-methods.md          # Analysis workflow
│   ├── 04-common-pitfalls.md           # Pitfalls & prevention
│   └── knowledge-index.yaml            # Auto-load index
├── memory/
│   ├── context.md              # Session state
│   ├── decisions.md            # Key decisions
│   └── learnings.md            # Patterns learned
└── templates/
    ├── experiment-design.md    # Pre-registration template
    └── analysis-report.md      # Analysis output template
```

---

## Knowledge Base

### 01-statistical-frameworks.md
- Hypothesis Testing Framework
- Frequentist Methods (Z-test, T-test, Chi-square)
- Bayesian Methods (Beta-Binomial, P(B>A))
- Sample Size Calculation
- Confidence Intervals
- Multiple Testing Correction
- Sequential Testing

### 02-experiment-design.md
- Experiment Design Workflow
- Hypothesis Formulation
- Metric Selection (OEC, Secondary, Guardrails)
- Sample Size Planning
- Randomization Design
- Pre-Registration Template

### 03-analysis-methods.md
- Pre-Analysis Validation (SRM, Runtime)
- Statistical Analysis Workflow
- Effect Size Interpretation
- Segment Analysis
- Decision Framework
- Common Mistakes

### 04-common-pitfalls.md
- Design Pitfalls (Underpowered, No Pre-registration)
- Execution Pitfalls (SRM, Peeking, Novelty)
- Analysis Pitfalls (P-hacking, Simpson's Paradox)
- Interpretation Pitfalls ("Almost Significant")
- Organizational Pitfalls (HiPPO Effect)

---

## Sample Size Quick Reference

**For conversion rates (80% power, 95% significance):**

| Baseline | 5% Relative MDE | 10% Relative MDE | 20% Relative MDE |
|----------|-----------------|------------------|------------------|
| 1% | 505,000 | 127,000 | 32,000 |
| 5% | 97,000 | 25,000 | 7,000 |
| 10% | 46,000 | 12,000 | 3,000 |

---

## Pitfall Prevention

### Critical (P0)
| Pitfall | Prevention |
|---------|------------|
| Peeking | Pre-define stopping rules |
| P-hacking | Pre-register analysis |
| SRM | Monitor daily |
| Underpowered | Calculate upfront |

### Important (P1)
| Pitfall | Prevention |
|---------|------------|
| Novelty effect | Run 14+ days |
| Multiple testing | Use correction |
| Simpson's paradox | Check segments |

---

## Configuration

### Model
Default: `opus` (for statistical rigor)

### Language
Default: Vietnamese (`vi`)

Agent giao tiếp bằng tiếng Việt với statistical terms giữ nguyên tiếng Anh.

---

## Output Locations

- Experiment logs: `docs/ab-test-sessions/`
- Format: `{YYYY-MM-DD}-{experiment-name}.md`

---

## Integration

### Với Other Agents
- **Deep Question Agent**: Hỏi về assumptions trong experiment design
- **Dev Agent**: Implement feature flags cho experiments
- **QA Agent**: Validate tracking implementation

### Workflow Example
```
1. Fisher (AB Test): Design experiment
2. Dev Agent: Implement feature flag
3. QA Agent: Verify tracking
4. Fisher: Monitor và analyze
5. Deep Question: Post-mortem if surprising results
```

---

## Changelog

### v1.0.0 (2025-12-31)
- Initial release
- 3 modes: Design, Analysis, Review
- Frequentist & Bayesian methods
- Sample size calculator
- Pitfall detection
- Output templates

---

## Credits

Named after **Ronald A. Fisher** (1890-1962):
- Father of modern statistics
- Invented ANOVA, maximum likelihood, experimental design
- Authored "Statistical Methods for Research Workers" (1925)
- Pioneer of randomized controlled experiments

---

## License

Part of MicroAI Agent Ecosystem.
