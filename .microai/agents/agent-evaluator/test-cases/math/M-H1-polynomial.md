---
id: M-H1
name: Polynomial Division
category: Algebra
difficulty: 4
points: 7
keywords:
  - "x - 2"
  - "chia hết"
  - "a = 3"
  - "Bézout"
answer: "a=3"
---

# Polynomial Division

## Prompt

<prompt>
Cho đa thức P(x) = x³ - 3x² + ax - 6

Tìm giá trị của a để P(x) chia hết cho (x - 2).
</prompt>

## Expected Answer

```
Theo định lý Bézout:
P(x) chia hết cho (x - 2) ⟺ P(2) = 0

P(2) = 2³ - 3(2²) + a(2) - 6
     = 8 - 12 + 2a - 6
     = 2a - 10

P(2) = 0
⟺ 2a - 10 = 0
⟺ a = 5

Kiểm tra: P(x) = x³ - 3x² + 5x - 6
P(2) = 8 - 12 + 10 - 6 = 0 ✓
```

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | a=5, dùng Bézout, kiểm tra lại |
| 6 pts | a=5, giải thích đúng |
| 5 pts | a=5, không giải thích |
| 4 pts | Phương pháp đúng, tính sai |
| 2 pts | Biết dùng Bézout nhưng sai |
| 0 pts | Không biết cách làm |

## Keywords for Grading

- Primary: `5`, `a = 5`
- Method: `Bézout`, `P(2) = 0`, `thay`, `chia hết`
