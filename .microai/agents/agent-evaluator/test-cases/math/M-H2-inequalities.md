---
id: M-H2
name: Inequalities and Optimization
category: Optimization
difficulty: 4
points: 7
keywords:
  - "AM-GM"
  - "Cauchy"
  - "min"
  - "12"
  - "x = 2"
answer: "min=12"
---

# Inequalities and Optimization

## Prompt

<prompt>
Cho x > 0. Tìm giá trị nhỏ nhất của biểu thức:
S = x² + 4/x + 8/x²

Xác định giá trị x khi S đạt min.
</prompt>

## Expected Answer

```
Áp dụng bất đẳng thức AM-GM:

S = x² + 4/x + 8/x²

Nhóm: S = x² + 8/x² + 4/x

Áp dụng AM-GM cho x² và 8/x²:
x² + 8/x² ≥ 2√(x² · 8/x²) = 2√8 = 4√2

Áp dụng AM-GM cho các số hạng:
S = x² + 4/x + 8/x² ≥ 3∛(x² · 4/x · 8/x²) = 3∛32 = 6∛4

Cách khác: Dùng đạo hàm
S' = 2x - 4/x² - 16/x³ = 0
2x⁴ - 4x - 16 = 0
x⁴ - 2x - 8 = 0
(x² - 2)(x² + 2x + 4) = 0 (với x > 0)
x = √2

S(√2) = 2 + 4/√2 + 8/2 = 2 + 2√2 + 4 = 6 + 2√2 ≈ 8.83
```

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | Tìm đúng min và x, phương pháp chặt chẽ |
| 6 pts | Min đúng, thiếu chứng minh đẳng thức |
| 5 pts | Phương pháp đúng, tính sai |
| 4 pts | Biết dùng AM-GM nhưng nhóm sai |
| 2 pts | Có ý tưởng nhưng không thực hiện được |
| 0 pts | Không biết cách làm |

## Keywords for Grading

- Primary: `√2`, `6 + 2√2`, `8.83`
- Method: `AM-GM`, `Cauchy`, `đạo hàm`, `derivative`, `bất đẳng thức`
