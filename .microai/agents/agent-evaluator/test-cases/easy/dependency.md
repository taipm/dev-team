---
id: E-2
name: Simple Dependency Order
category: Reasoning
difficulty: 1
points: 3
keywords:
  - B
  - first
  - before
  - dependency
  - init
---

# Simple Dependency Order

## Prompt

<prompt>
Package A imports B. Package B has no imports. What initializes first?
</prompt>

## Expected Behavior

The answer should:
1. Correctly identify B initializes first
2. Explain Go's initialization order (dependencies first)
3. Understand transitive dependency concept

## Rubric

| Score | Criteria |
|-------|----------|
| 3 pts | Correct answer with Go init order explanation |
| 2 pts | Correct answer (B first) without explanation |
| 1 pt  | Mentions dependency but unclear answer |
| 0 pts | Wrong answer (says A first) |

## Good Answer Example

```
B initializes first.

In Go, packages are initialized in dependency order. Since A imports B,
B must be fully initialized before A's init() functions run.

Order: B's init() → A's init() → main()
```

## Why This Test

- Tests basic dependency reasoning
- Foundation for complex dependency chain tests
- Simple two-step logical inference
