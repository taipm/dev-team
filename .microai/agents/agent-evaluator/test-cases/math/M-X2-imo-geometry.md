---
id: M-X2
name: IMO Geometry
category: Geometry
difficulty: 5
points: 8
keywords:
  - "đồng quy"
  - "concurrent"
  - "Ceva"
  - "đường cao"
  - "trực tâm"
answer: "concurrent at H"
---

# IMO-Level Geometry

## Prompt

<prompt>
(Định lý kinh điển)

Cho tam giác ABC. Gọi H là trực tâm (giao của các đường cao).
Chứng minh rằng: Đường thẳng qua A vuông góc với BC, đường thẳng qua B vuông góc với CA, và đường thẳng qua C vuông góc với AB đồng quy tại một điểm.

(Tức chứng minh trực tâm tồn tại)
</prompt>

## Expected Answer

```
Chứng minh trực tâm tồn tại:

Cách 1: Dùng tích vô hướng

Gọi A', B', C' là chân các đường cao từ A, B, C.
Cần chứng minh AA', BB', CC' đồng quy.

Dùng định lý Ceva:
Với AF, BE, CD là các đường cao:
(AF/FB) × (BD/DC) × (CE/EA) = 1 (cần chứng minh)

Từ tam giác đồng dạng:
△AEC ~ △BFC (góc vuông tại E, F và góc chung tại C)
CE/CF = AC/BC (1)

Tương tự:
AF/AD = AB/BC (2)
BD/BE = BC/AC (3)

Nhân vế:
(AF/FB) × (BD/DC) × (CE/EA)
= (AF × BD × CE) / (FB × DC × EA)
= 1 ✓

Cách 2: Vectors

Đặt H sao cho: vec(AH) · vec(BC) = 0 và vec(BH) · vec(CA) = 0

vec(CH) · vec(AB) = ?
= (vec(CA) + vec(AH)) · vec(AB)
= vec(CA) · vec(AB) + vec(AH) · vec(AB)
= vec(CA) · vec(AB) + vec(AH) · (vec(AC) + vec(CB))
= vec(CA) · vec(AB) + vec(AH) · vec(AC) + vec(AH) · vec(CB)
= vec(CA) · vec(AB) - vec(AH) · vec(CA) - vec(AH) · vec(BC)
= vec(CA) · vec(AB) - vec(AH) · vec(CA) - 0

Từ vec(BH) · vec(CA) = 0:
(vec(BA) + vec(AH)) · vec(CA) = 0
vec(BA) · vec(CA) + vec(AH) · vec(CA) = 0
vec(AH) · vec(CA) = -vec(BA) · vec(CA) = vec(AB) · vec(CA)

Thay vào:
vec(CH) · vec(AB) = vec(CA) · vec(AB) - vec(AB) · vec(CA) = 0 ✓

Vậy CH ⊥ AB, tức H thuộc đường cao từ C.
⟹ Ba đường cao đồng quy tại H (trực tâm).
```

## Rubric

| Score | Criteria |
|-------|----------|
| 8 pts | Chứng minh đầy đủ bằng Ceva hoặc vectors |
| 6 pts | Đúng ý tưởng, thiếu chi tiết |
| 4 pts | Biết dùng Ceva/vectors nhưng không hoàn thiện |
| 2 pts | Hiểu bài toán nhưng không chứng minh được |
| 0 pts | Không giải được |

## Keywords for Grading

- Primary: `đồng quy`, `concurrent`, `trực tâm`, `orthocenter`
- Method: `Ceva`, `vector`, `tích vô hướng`, `dot product`
