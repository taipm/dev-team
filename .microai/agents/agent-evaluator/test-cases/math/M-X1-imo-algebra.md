---
id: M-X1
name: IMO Algebra
category: Algebra
difficulty: 5
points: 10
keywords:
  - "f(x) = x"
  - "identity"
  - "phương trình hàm"
  - "functional equation"
  - "injective"
  - "surjective"
answer: "f(x)=x"
---

# IMO-Level Algebra (Functional Equation)

## Prompt

<prompt>
(IMO 2019-style)

Tìm tất cả các hàm f: ℝ → ℝ thỏa mãn:
f(x + f(y)) = f(x) + y với mọi x, y ∈ ℝ

Chứng minh đầy đủ.
</prompt>

## Expected Answer

```
Giả sử f: ℝ → ℝ thỏa mãn f(x + f(y)) = f(x) + y (*)

Bước 1: Đặt x = 0
f(f(y)) = f(0) + y

Đặt c = f(0), ta có: f(f(y)) = c + y  (**)

Bước 2: f là đơn ánh (injective)
Nếu f(a) = f(b), thì từ (**):
f(f(a)) = f(f(b))
c + a = c + b
a = b ✓

Bước 3: f là toàn ánh (surjective)
Với mọi z ∈ ℝ, đặt y = z - c
f(f(z - c)) = c + (z - c) = z
Vậy f(z - c) là nghịch ảnh của z ✓

Bước 4: Tìm f(0)
Từ (**) với y = 0:
f(f(0)) = c + 0 = c = f(0)
Vậy f(c) = c

Thay y = 0 vào (*):
f(x + c) = f(x) + 0 = f(x)
⟹ f(x + c) = f(x) với mọi x

Vì f đơn ánh: x + c = x ⟹ c = 0
Vậy f(0) = 0

Bước 5: Kết luận
Từ (**) với c = 0:
f(f(y)) = y (f là song ánh với f⁻¹ = f)

Thay vào (*):
f(x + f(y)) = f(x) + y
f(f(x + f(y))) = f(f(x) + y)
x + f(y) = f(f(x)) + y
x + f(y) = x + y
f(y) = y

Đáp án: f(x) = x là nghiệm duy nhất.

Thử lại: f(x + f(y)) = x + y = f(x) + y ✓
```

## Rubric

| Score | Criteria |
|-------|----------|
| 10 pts | Chứng minh hoàn chỉnh: đơn ánh, toàn ánh, f(x)=x |
| 8 pts | Đúng f(x)=x, chứng minh thiếu 1 bước |
| 6 pts | Đúng hướng, thiếu chặt chẽ |
| 4 pts | Đoán đúng f(x)=x, không chứng minh đầy đủ |
| 2 pts | Có ý tưởng đúng nhưng không hoàn thiện |
| 0 pts | Không giải được |

## Keywords for Grading

- Primary: `f(x) = x`, `identity`
- Concepts: `đơn ánh`, `injective`, `toàn ánh`, `surjective`, `song ánh`, `bijective`
- Method: `thay`, `substitute`, `x = 0`, `y = 0`
