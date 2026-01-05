---
id: M-H3
name: Number Theory
category: Number Theory
difficulty: 4
points: 7
keywords:
  - "chia hết"
  - "mod"
  - "3"
  - "quy nạp"
  - "n(n+1)(n+2)"
answer: "divisible by 6"
---

# Number Theory

## Prompt

<prompt>
Chứng minh rằng với mọi số nguyên dương n:
n(n+1)(n+2) chia hết cho 6

(Tức là tích 3 số nguyên liên tiếp luôn chia hết cho 6)
</prompt>

## Expected Answer

```
Cách 1: Phân tích
Trong 3 số nguyên liên tiếp n, n+1, n+2:

1) Chia hết cho 2:
   - Luôn có ít nhất 1 số chẵn
   → n(n+1)(n+2) chia hết cho 2

2) Chia hết cho 3:
   - Trong 3 số liên tiếp, luôn có đúng 1 số chia hết cho 3
   (vì khi chia cho 3, các số cho dư 0, 1, 2 lần lượt)
   → n(n+1)(n+2) chia hết cho 3

3) Vì 2 và 3 nguyên tố cùng nhau (gcd(2,3) = 1)
   → n(n+1)(n+2) chia hết cho 2×3 = 6

Cách 2: Tổ hợp
n(n+1)(n+2) = 6 × C(n+2, 3)
C(n+2, 3) luôn là số nguyên → tích chia hết cho 6
```

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | Chứng minh đầy đủ cả 2 và 3, kết luận |
| 6 pts | Chứng minh đúng nhưng thiếu giải thích |
| 5 pts | Đúng ý tưởng, thiếu chặt chẽ |
| 4 pts | Chứng minh được 1 phần (chia hết 2 hoặc 3) |
| 2 pts | Có ý tưởng nhưng không hoàn thiện |
| 0 pts | Không biết cách chứng minh |

## Keywords for Grading

- Primary: `chia hết`, `divisible`, `6`
- Concepts: `số chẵn`, `even`, `liên tiếp`, `consecutive`, `tổ hợp`
