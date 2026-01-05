# Expert Tier Benchmark Report

> Tests: 3 | Max Score: 25 points
> Purpose: Differentiate opus > sonnet > haiku
> Expected: Local 5-15%, Haiku 10%+, Sonnet 30%+, Opus 50%+

---

## Results

| Test | Points | qwen3 | deepseek | opus | sonnet | haiku |
|------|--------|-------|----------|------|--------|-------|
| X-1 Rate Limiter | 10 | 6.25 | 2.50 | 0 | 0 | 0 |
| X-2 Refactoring | 8 | 6.00 | 4.00 | 5.00 | 5.00 | 6.00 |
| X-3 Cache Design | 7 | 5.25 | 4.37 | 0 | 7.00 | 7.00 |
| **TOTAL** | **25** | **17.50 (70%)** | **10.87 (43%)** | **5.00 (20%)** | **12.00 (48%)** | **13.00 (52%)** |

---

## Ranking

| Rank | Model | Score | % | Grade |
|------|-------|-------|---|-------|
| #1 | qwen3 | 17.50/25 | 70% | A |
| #2 | claude-haiku | 13.00/25 | 52% | A |
| #3 | claude-sonnet | 12.00/25 | 48% | B |
| #4 | deepseek-r1 | 10.87/25 | 43% | B |
| #5 | claude-opus | 5.00/25 | 20% | C |

---

## Differentiation Analysis

### Expected vs Actual

| Model | Expected | Actual | Gap Analysis |
|-------|----------|--------|--------------|
| opus | 50%+ | 20% | ❌ Below target |
| sonnet | 30%+ | 48% | ✅ Met expectation |
| haiku | 10%+ | 52% | ✅ Met expectation |
| deepseek | 5-15% | 43% | ⚠️ Higher than expected |
| qwen3 | 5-15% | 70% | ⚠️ Higher than expected |

### Model Hierarchy Check

Expected: opus > sonnet > haiku > local models

❌ opus > sonnet: No (20% <= 48%)
❌ sonnet > haiku: No (48% <= 52%)
⚠️ haiku > local: Mixed results

---

*Generated: 2026-01-04 00:14:40*
*Expert Tier - Designed to differentiate advanced reasoning capabilities*
