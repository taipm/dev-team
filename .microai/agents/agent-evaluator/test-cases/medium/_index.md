---
tier: medium
name: Medium Tier
total_points: 25
test_count: 5
expected_performance:
  local: "40-60%"
  haiku: "60%+"
  sonnet: "75%+"
  opus: "85%+"
description: |
  Intermediate tests requiring multi-step reasoning.
  Local models begin to struggle here.
---

# Medium Tier Tests

## Overview

| ID | Name | Category | Points |
|----|------|----------|--------|
| M-1 | Complex Dependency Chain | Reasoning | 5 |
| M-2 | Context Cancellation Bug | Concurrency | 5 |
| M-3 | Error Wrapping Chain | Error Handling | 5 |
| M-4 | Interface Segregation | Design | 5 |
| M-5 | Race in Counter | Concurrency | 5 |

## Test Files

- `complex-dependency.md` - M-1
- `context-handling.md` - M-2
- `error-wrapping.md` - M-3
- `design-principles.md` - M-4
- `race-conditions.md` - M-5

## Purpose

This tier begins to differentiate:
- Local models (qwen, deepseek) start showing limitations
- Haiku should handle most but miss nuances
- Sonnet shows consistent performance
- Opus demonstrates strong reasoning
