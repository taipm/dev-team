# Hard Tier Benchmark Report

> Tests: 5 | Max Score: 35 points
> Expected: Local 15-40%, Cloud 50-70%

---

## Results

| Test | Points | qwen3 | deepseek | opus | sonnet | haiku |
|------|--------|-------|----------|------|--------|-------|
| H-1 Deadlock | 7 | 4.20 | 1.40 | 5.60 | 4.20 | 0 |
| H-2 Code Bugs | 7 | 4.20 | 1.40 | 7.00 | 7.00 | 5.60 |
| H-3 API Review | 7 | 0 | 0 | 4.20 | 7.00 | 1.40 |
| H-4 Fan-In | 7 | 5.60 | 0 | 4.20 | 0 | 7.00 |
| H-5 SQL Injection | 7 | 7.00 | 1.40 | 2.80 | 4.20 | 4.20 |
| **TOTAL** | **35** | **21.00 (60%)** | **4.20 (12%)** | **23.80 (68%)** | **22.40 (64%)** | **18.20 (52%)** |

---

## Summary

| Rank | Model | Score | % |
|------|-------|-------|---|
| opus | 23.80/35 | 68% |
| sonnet | 22.40/35 | 64% |
| qwen | 21.00/35 | 60% |
| haiku | 18.20/35 | 52% |
| deepseek | 4.20/35 | 12% |

---

## Analysis

Expected performance for Hard tier:
- Local models (qwen, deepseek): 15-40%
- Haiku: 30%+
- Sonnet: 50%+
- Opus: 70%+

### Actual Results

| Model | Score | Expected | Status |
|-------|-------|----------|--------|
| qwen3 | 60% | 15-40% | ⚠️ Higher than expected |
| deepseek | 12% | 15-40% | ✅ As expected |
| haiku | 52% | 30%+ | ✅ As expected |
| sonnet | 64% | 50%+ | ✅ As expected |
| opus | 68% | 70%+ | ❌ Below expected |

---

*Generated: 2026-01-03 23:30:25*
