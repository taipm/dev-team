---
id: M-H4
name: Combinatorics
category: Combinatorics
difficulty: 4
points: 7
keywords:
  - "C(10,3)"
  - "120"
  - "tổ hợp"
  - "combination"
answer: "120"
---

# Combinatorics

## Prompt

<prompt>
Có 10 học sinh, cần chọn ra 3 học sinh để làm ban cán sự lớp (các vị trí như nhau).

a) Có bao nhiêu cách chọn?
b) Biết trong 10 học sinh có 6 nam và 4 nữ. Có bao nhiêu cách chọn sao cho có ít nhất 1 nữ?
</prompt>

## Expected Answer

```
a) Chọn 3 từ 10 (không phân biệt vị trí) = Tổ hợp
   C(10,3) = 10!/(3! × 7!) = (10 × 9 × 8)/(3 × 2 × 1) = 720/6 = 120 cách

b) Cách 1: Trực tiếp
   = C(1 nữ) + C(2 nữ) + C(3 nữ)
   = C(4,1)×C(6,2) + C(4,2)×C(6,1) + C(4,3)×C(6,0)
   = 4×15 + 6×6 + 4×1
   = 60 + 36 + 4 = 100 cách

   Cách 2: Phần bù
   = Tổng - C(0 nữ)
   = 120 - C(6,3)
   = 120 - 20 = 100 cách
```

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | a=120, b=100, giải thích đầy đủ |
| 6 pts | Cả 2 đáp án đúng, thiếu chi tiết |
| 5 pts | a đúng, b sai do tính toán |
| 4 pts | a đúng, b sai phương pháp |
| 3 pts | Chỉ đúng phần a |
| 1 pt  | Hiểu tổ hợp nhưng không áp dụng được |
| 0 pts | Không biết tổ hợp |

## Keywords for Grading

- Primary: `120`, `100`
- Formula: `C(10,3)`, `tổ hợp`, `combination`, `phần bù`
