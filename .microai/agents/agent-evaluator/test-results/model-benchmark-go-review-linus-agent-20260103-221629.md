# Multi-Model Benchmark Report

> Comparing agent performance across different LLM providers and models.

---

## Agent: go-review-linus-agent

| Test | Max | qwen3:1.7b | deepseek-r1:1.5b | claude-opus | claude-sonnet | claude-haiku |
|------|-----|------------|------------------|-------------|---------------|--------------|
| R-L1 | 2 | .40 | .80 | .80 | .80 | 0 |
| R-M1 | 3 | 3.00 | 3.00 | 3.00 | 3.00 | 0 |
| R-E1 | 3 | 2.40 | 1.80 | 1.20 | 1.20 | 0 |
| A-A1 | 3 | 0 | .50 | 2.00 | .50 | 0 |
| O-C1 | 4 | 0 | 2.00 | 4.00 | 4.00 | 0 |
| **TOTAL** | **15** | **5.80 (38%)** | **8.10 (54%)** | **11.00 (73%)** | **9.50 (63%)** | **0 (0%)** |

---

## Summary

| Rank | Model | Score | Percentage | Type |
|------|-------|-------|------------|------|
| #1 | claude-opus | 11.00/15 | 73% | Claude |
| #2 | claude-sonnet | 9.50/15 | 63% | Claude |
| #3 | deepseek-r1 | 8.10/15 | 54% | 1.5b |
| #4 | qwen3 | 5.80/15 | 38% | 1.7b |
| #5 | claude-haiku | 0/15 | 0% | Claude |

---

## Analysis

### Local Models (Ollama)
- **qwen3:1.7b**: 5.80/15 (38%)
- **deepseek-r1:1.5b**: 8.10/15 (54%)

### Cloud Models (Claude)
- **claude-opus**: 11.00/15 (73%)
- **claude-sonnet**: 9.50/15 (63%)
- **claude-haiku**: 0/15 (0%)

---

*Generated: Sat Jan  3 22:20:08 +07 2026*
