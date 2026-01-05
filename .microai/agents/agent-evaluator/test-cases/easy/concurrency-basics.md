---
id: E-4
name: Map Concurrency Safety
category: Concurrency
difficulty: 1
points: 3
keywords:
  - race
  - data race
  - crash
  - fatal
  - unsafe
  - undefined
  - concurrent
---

# Map Concurrency Safety

## Prompt

<prompt>
Two goroutines write to the same map without synchronization. What happens?
</prompt>

## Expected Behavior

The answer should:
1. Identify this as unsafe/data race
2. Mention potential crash or fatal error
3. Understand Go maps are not concurrent-safe

## Rubric

| Score | Criteria |
|-------|----------|
| 3 pts | Identifies data race with consequences (crash/fatal) |
| 2 pts | Mentions race condition without details |
| 1 pt  | Says it's unsafe without specifics |
| 0 pts | Says it's fine or doesn't identify the problem |

## Good Answer Example

```
This creates a data race and will likely cause a fatal error.

Go maps are not safe for concurrent read/write. The runtime detects
concurrent map writes and panics with "fatal error: concurrent map writes".

Solutions:
1. Use sync.Mutex to protect map access
2. Use sync.Map for concurrent access
3. Use channels to serialize access
```

---

# Nil vs Empty Slice

## Metadata

```yaml
id: E-5
name: Nil vs Empty Slice
category: Go Knowledge
difficulty: 1
points: 3
keywords:
  - nil
  - empty
  - allocated
  - memory
  - json
  - marshal
```

## Prompt

<prompt>
What is the difference between 'var s []int' and 's := []int{}'?
</prompt>

## Expected Behavior

The answer should:
1. Identify first as nil slice, second as empty slice
2. Explain memory allocation difference
3. Bonus: mention JSON marshaling difference

## Rubric

| Score | Criteria |
|-------|----------|
| 3 pts | Explains nil vs empty with JSON marshaling difference |
| 2 pts | Correctly identifies nil vs empty with allocation mention |
| 1 pt  | Knows they're different but unclear explanation |
| 0 pts | Says they're the same |

## Good Answer Example

```
var s []int    → nil slice (s == nil is true, no memory allocated)
s := []int{}   → empty slice (s != nil, memory allocated, len=0)

Key differences:
1. nil check: first is nil, second is not
2. JSON: nil marshals to "null", empty to "[]"
3. Both have len=0 and can be appended to

In practice, prefer nil slice unless you specifically need non-nil empty.
```
