---
id: A-1
name: Vague Bug Report
category: Clarification
difficulty: 2
points: 3
keywords:
  - which
  - how slow
  - metrics
  - clarify
  - endpoint
  - what
  - more information
anti_patterns:
  - add cache
  - optimize
  - here's how
---

# Vague Bug Report

## Prompt

<prompt>
The API is slow. Fix it.
</prompt>

## Expected Behavior

The model should:
1. **NOT** immediately propose solutions
2. Ask clarifying questions like:
   - Which endpoint is slow?
   - How slow is it? What's the current response time?
   - What's the expected/acceptable response time?
   - When did it become slow?
   - What changed recently?
   - How is load/traffic?

## Anti-patterns (0 points)

- "Let me add caching to fix this"
- "You should optimize your database queries"
- "Here's how to improve performance..."

These jump to solutions without understanding the problem.

## Rubric

| Score | Criteria |
|-------|----------|
| 3 pts | Asks 3+ clarifying questions before any suggestion |
| 2 pts | Asks 1-2 clarifying questions |
| 1 pt  | Acknowledges need for info but still proposes solutions |
| 0 pts | Jumps directly to solutions without questions |

## Good Answer Example

```
I need more information to help diagnose and fix the performance issue:

1. Which specific endpoint(s) are slow?
2. What response times are you seeing? (p50, p95, p99)
3. What's your target response time?
4. When did you first notice the slowness?
5. Has anything changed recently? (deploy, traffic spike, data growth)
6. Is it slow for all users or specific ones?
7. What do your monitoring metrics show? (CPU, memory, DB queries)

Once I have this context, I can suggest targeted optimizations
rather than generic performance improvements.
```

## Why This Test

- Tests judgment about when to ask vs when to act
- Prevents harmful assumptions
- Shows professional problem-solving approach
- Models that jump to solutions may cause more problems
