---
id: E-1
name: Error Handling Basics
category: Go Knowledge
difficulty: 1
points: 3
keywords:
  - check
  - handle
  - error
  - err
  - nil
  - if err
---

# Error Handling Basics

## Prompt

<prompt>
All Go functions that return errors should be checked. The function ReadFile returns an error. What should the caller do?
</prompt>

## Expected Behavior

The answer should:
1. State that the caller must check/handle the error
2. Ideally show the `if err != nil` pattern
3. Mention what to do with the error (return, log, handle)

## Rubric

| Score | Criteria |
|-------|----------|
| 3 pts | States to check error with code pattern (`if err != nil`) |
| 2 pts | States to handle error without code example |
| 1 pt  | Mentions error handling vaguely |
| 0 pts | Ignores error handling or says it's optional |

## Good Answer Example

```
The caller should check the error returned by ReadFile:

data, err := ReadFile(filename)
if err != nil {
    return fmt.Errorf("failed to read file: %w", err)
}
// use data
```

## Why This Test

- Tests basic Go idiom understanding
- Simple syllogistic reasoning (A returns error → must check error)
- Foundation for more complex error handling tests
