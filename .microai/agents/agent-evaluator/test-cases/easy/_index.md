---
tier: easy
name: Easy Tier
total_points: 15
test_count: 5
expected_performance:
  local: "70%+"
  haiku: "85%+"
  sonnet: "90%+"
  opus: "95%+"
description: |
  Basic tests that all models should pass.
  Focuses on fundamental concepts and simple reasoning.
---

# Easy Tier Tests

## Overview

| ID | Name | Category | Points |
|----|------|----------|--------|
| E-1 | Error Handling Basics | Go Knowledge | 3 |
| E-2 | Simple Dependency | Reasoning | 3 |
| E-3 | Interface Implicit | Go Knowledge | 3 |
| E-4 | Map Concurrency | Concurrency | 3 |
| E-5 | Nil vs Empty Slice | Go Knowledge | 3 |

## Test Files

- `error-handling.md` - E-1
- `dependency.md` - E-2
- `go-interfaces.md` - E-3
- `concurrency-basics.md` - E-4, E-5

## Purpose

These tests establish a baseline:
- If a model fails Easy tier, it's not suitable for the agent
- All production-ready models should score 85%+ here
- Differentiates only the weakest models
