---
id: M-E1
name: Basic Arithmetic
category: Arithmetic
difficulty: 1
points: 3
keywords:
  - "17"
answer: "17"
---

# Basic Arithmetic

## Prompt

<prompt>
Tính: 3 + 5 × 2 + 4 ÷ 2 = ?

Giải thích thứ tự thực hiện phép tính.
</prompt>

## Expected Answer

```
Thứ tự: Nhân/Chia trước, Cộng/Trừ sau
= 3 + (5 × 2) + (4 ÷ 2)
= 3 + 10 + 2
= 15

Wait, let me recalculate:
= 3 + 10 + 2 = 15
```

**Correct answer: 15**

## Rubric

| Score | Criteria |
|-------|----------|
| 3 pts | Đáp án đúng (15) + giải thích thứ tự |
| 2 pts | Đáp án đúng, thiếu giải thích |
| 1 pt  | Giải thích đúng, tính sai |
| 0 pts | Sai hoàn toàn |

## Keywords for Grading

- Primary: `15` (exact answer)
- Secondary: `nhân`, `chia`, `trước`, `order`, `PEMDAS`, `BODMAS`
