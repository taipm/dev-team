---
id: M-H5
name: Advanced Geometry
category: Geometry
difficulty: 4
points: 7
keywords:
  - "sin"
  - "cos"
  - "heron"
  - "diện tích"
  - "6√7"
answer: "6√7"
---

# Advanced Geometry

## Prompt

<prompt>
Tam giác ABC có BC = 8cm, góc B = 60°, góc C = 45°.

a) Tính cạnh AB
b) Tính diện tích tam giác ABC
</prompt>

## Expected Answer

```
Góc A = 180° - 60° - 45° = 75°

a) Theo định lý sin:
   AB/sin C = BC/sin A
   AB/sin 45° = 8/sin 75°

   sin 75° = sin(45° + 30°) = (√6 + √2)/4

   AB = 8 × sin 45° / sin 75°
   AB = 8 × (√2/2) / ((√6 + √2)/4)
   AB = 8 × (√2/2) × (4/(√6 + √2))
   AB = 16√2/(√6 + √2)
   AB = 16√2(√6 - √2)/((√6 + √2)(√6 - √2))
   AB = 16√2(√6 - √2)/(6 - 2)
   AB = 4√2(√6 - √2)
   AB = 4√12 - 4×2 = 8√3 - 8 ≈ 5.86 cm

b) Diện tích:
   S = (1/2) × AB × BC × sin B
   S = (1/2) × (8√3 - 8) × 8 × sin 60°
   S = (1/2) × (8√3 - 8) × 8 × (√3/2)
   S = 2(8√3 - 8)√3
   S = 16×3 - 16√3
   S = 48 - 16√3 ≈ 20.29 cm²
```

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | Cả AB và S đúng, trình bày đầy đủ |
| 6 pts | AB đúng, S có sai số nhỏ |
| 5 pts | Phương pháp đúng, tính sai |
| 4 pts | Biết dùng định lý sin/cos |
| 2 pts | Có ý tưởng nhưng không thực hiện |
| 0 pts | Không biết cách làm |

## Keywords for Grading

- Primary: `8√3 - 8`, `5.86`, `48 - 16√3`, `20.29`
- Method: `định lý sin`, `law of sines`, `sin 75`, `diện tích`
