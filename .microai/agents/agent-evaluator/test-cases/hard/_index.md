---
tier: hard
name: Hard Tier
total_points: 35
test_count: 5
expected_performance:
  local: "15-40%"
  haiku: "30%+"
  sonnet: "50%+"
  opus: "70%+"
description: |
  Advanced tests requiring deep analysis and multiple concepts.
  This tier separates good models from great ones.
---

# Hard Tier Tests

## Overview

| ID | Name | Category | Points |
|----|------|----------|--------|
| H-1 | Deadlock Analysis | Concurrency | 7 |
| H-2 | Multiple Code Bugs | Code Review | 7 |
| H-3 | REST API Design Review | Architecture | 7 |
| H-4 | Fan-In Concurrency Pattern | Concurrency | 7 |
| H-5 | SQL Injection Detection | Security | 7 |

## Test Files

- `deadlock-analysis.md` - H-1
- `code-review-bugs.md` - H-2
- `api-design-review.md` - H-3
- `concurrency-patterns.md` - H-4
- `security-vulnerabilities.md` - H-5

## Purpose

This tier clearly separates:
- Local models struggle significantly
- Haiku shows limitations on complex analysis
- Sonnet handles most with occasional gaps
- Opus demonstrates consistent deep reasoning

## Key Differentiators

1. **Multi-issue identification** - Finding ALL problems, not just obvious ones
2. **Solution completeness** - Providing working fixes, not just identifying issues
3. **Trade-off analysis** - Understanding consequences of different approaches
