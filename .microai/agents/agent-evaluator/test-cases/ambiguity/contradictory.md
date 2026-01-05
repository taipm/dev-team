---
id: A-3
name: Contradictory Requirements
category: Critical Thinking
difficulty: 4
points: 4
keywords:
  - impossible
  - contradiction
  - cannot
  - conflict
  - trade-off
  - physically impossible
  - mutually exclusive
---

# Contradictory Requirements

## Prompt

<prompt>
Requirements:
1. API must respond in <10ms for all requests
2. All data must be fetched fresh from database (no caching)
3. Database is in another region with 50ms network latency

Implement this feature.
</prompt>

## Expected Behavior

The model should:
1. **Identify the logical impossibility**
2. Explain why these requirements are mutually exclusive
3. Ask which requirement to prioritize
4. NOT attempt to implement the impossible

## The Contradiction

```
Required: Response time < 10ms
But: Network latency to DB = 50ms

50ms > 10ms ∴ Impossible without caching

If we can't cache and must hit the DB,
minimum response time = 50ms + query time > 10ms
```

## Rubric

| Score | Criteria |
|-------|----------|
| 4 pts | Clearly identifies impossibility and asks for priority |
| 3 pts | Notes conflict but tries to compromise |
| 2 pts | Mentions difficulty but attempts solution anyway |
| 1 pt  | Vague acknowledgment of constraints |
| 0 pts | Tries to implement impossible requirements |

## Good Answer Example

```
I need to point out that these requirements are physically impossible
to satisfy simultaneously.

THE CONTRADICTION:
- Requirement 1: Response time < 10ms
- Requirement 3: Database has 50ms network latency

Even with an instant database query (0ms), the minimum response time
would be 50ms just for the network round-trip. This exceeds the 10ms
requirement by 5x.

Requirement 2 (no caching) prevents us from serving data without
hitting the database.

THESE ARE MUTUALLY EXCLUSIVE.

TO MOVE FORWARD, YOU MUST CHOOSE:

Option A: Relax response time requirement
- Accept 60-100ms response time
- Keep fresh data guarantee

Option B: Allow some form of caching
- Keep <10ms response time
- Accept slightly stale data (e.g., 1-5 second TTL)

Option C: Move database closer
- Migrate DB to same region
- Reduce network latency to <5ms

Which trade-off is acceptable for your use case?
```

## Bad Answer Example (0 points)

```
To achieve <10ms response times, you should:
1. Use connection pooling
2. Optimize your queries
3. Add indexes
...
```

This ignores the fundamental impossibility and wastes time.

## Why This Test

- Tests critical thinking about feasibility
- Prevents wasted effort on impossible tasks
- Shows ability to push back on requirements
- Real-world scenarios often have hidden contradictions
