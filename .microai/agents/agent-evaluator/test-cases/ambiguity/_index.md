---
tier: ambiguity
name: Ambiguity Tier
total_points: 10
test_count: 3
expected_performance:
  local: "30-50%"
  haiku: "50%+"
  sonnet: "70%+"
  opus: "80%+"
description: |
  Tests the model's ability to recognize ambiguity and ask for clarification
  instead of making assumptions or jumping to solutions.
---

# Ambiguity Tier Tests

## Overview

| ID | Name | Category | Points |
|----|------|----------|--------|
| A-1 | Vague Bug Report | Clarification | 3 |
| A-2 | Underspecified Feature | Clarification | 3 |
| A-3 | Contradictory Requirements | Critical Thinking | 4 |

## Test Files

- `vague-requests.md` - A-1
- `underspecified.md` - A-2
- `contradictory.md` - A-3

## Purpose

This tier tests a critical capability:
- Can the model recognize when it doesn't have enough information?
- Does it ask clarifying questions or make assumptions?
- Can it identify logically impossible requirements?

## Scoring Philosophy

**Anti-patterns are penalized:**
- Jumping straight to a solution = 0 points
- Making assumptions without asking = reduced score
- Not recognizing impossibility = 0 points

**Good behavior rewarded:**
- Asking clarifying questions
- Listing what information is needed
- Identifying contradictions
