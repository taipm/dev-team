# Estimation Techniques

> Shared knowledge for PM-Dev and Dev-Architect teams

## Overview

This document covers software estimation techniques applicable across teams for planning, scoping, and resource allocation.

---

## 1. T-Shirt Sizing

Quick relative sizing without specific time units.

| Size | Relative Effort | Typical Use |
|------|-----------------|-------------|
| XS | 1 | < 2 hours, trivial |
| S | 2 | Half day |
| M | 3-5 | 1-2 days |
| L | 8-13 | 3-5 days |
| XL | 20+ | 1-2 weeks, needs breakdown |

### When to Use
- Initial backlog grooming
- High-level roadmap planning
- Comparing features relatively

---

## 2. Story Points (Fibonacci)

Relative complexity using Fibonacci sequence: 1, 2, 3, 5, 8, 13, 21

### Factors to Consider
1. **Complexity** - Technical difficulty
2. **Uncertainty** - Unknowns and risks
3. **Effort** - Amount of work
4. **Dependencies** - External blockers

### Reference Stories
| Points | Reference |
|--------|-----------|
| 1 | Fix typo, update config |
| 2 | Simple UI change |
| 3 | Standard CRUD operation |
| 5 | Feature with some complexity |
| 8 | Complex feature, integration |
| 13 | Large feature, research needed |
| 21+ | Epic, needs breakdown |

---

## 3. Three-Point Estimation (PERT)

$$E = (O + 4M + P) / 6$$

- **O** = Optimistic (best case)
- **M** = Most Likely (normal)
- **P** = Pessimistic (worst case)

### Example
| Case | Days |
|------|------|
| Optimistic | 3 |
| Most Likely | 5 |
| Pessimistic | 12 |
| **Expected** | **5.8** |

---

## 4. Planning Poker

Collaborative estimation technique:

1. Present story to team
2. Each member picks estimate card privately
3. Reveal simultaneously
4. Discuss outliers
5. Re-vote if needed
6. Consensus reached

### Benefits
- Reduces anchoring bias
- Encourages discussion
- Leverages team knowledge

---

## 5. Estimation Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Anchoring | First number biases others | Use Planning Poker |
| Optimism bias | Underestimate consistently | Add buffer, use historical data |
| Scope creep | Original estimate invalid | Re-estimate when scope changes |
| Expert only | One person estimates | Team estimation |
| No breakdown | Large items poorly estimated | Break into smaller pieces |

---

## 6. Confidence Levels

Always pair estimate with confidence:

| Level | Meaning | Variance |
|-------|---------|----------|
| High | Well understood, done before | ±10% |
| Medium | Some unknowns | ±25% |
| Low | Many unknowns, research needed | ±50%+ |

---

## Quick Reference

```
T-Shirt:    XS < S < M < L < XL
Fibonacci:  1, 2, 3, 5, 8, 13, 21
PERT:       (O + 4M + P) / 6
Confidence: High (±10%), Medium (±25%), Low (±50%)
```

---

*Last updated: 2024-12-31*
*Applicable teams: pm-dev, dev-architect*
