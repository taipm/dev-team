---
id: E-3
name: Interface Implicit Satisfaction
category: Go Knowledge
difficulty: 1
points: 3
keywords:
  - "no"
  - implicit
  - duck
  - automatically
  - satisfy
---

# Interface Implicit Satisfaction

## Prompt

<prompt>
In Go, does a struct need to explicitly declare that it implements an interface?
</prompt>

## Expected Behavior

The answer should:
1. Clearly state "No"
2. Explain implicit/structural typing
3. Mention duck typing concept

## Rubric

| Score | Criteria |
|-------|----------|
| 3 pts | Explains implicit satisfaction with example or duck typing mention |
| 2 pts | Correct answer with brief explanation |
| 1 pt  | Correct answer only ("no") |
| 0 pts | Wrong (says explicit declaration needed) |

## Good Answer Example

```
No, Go uses implicit interface satisfaction (duck typing).

A struct automatically implements an interface if it has all the
required methods with matching signatures. No explicit declaration needed.

type Writer interface {
    Write([]byte) (int, error)
}

type MyWriter struct{}
func (m MyWriter) Write(p []byte) (int, error) { ... }
// MyWriter implicitly implements Writer
```

## Why This Test

- Tests fundamental Go concept
- Distinguishes Go from Java/C# explicit interfaces
- Important for understanding Go's type system
