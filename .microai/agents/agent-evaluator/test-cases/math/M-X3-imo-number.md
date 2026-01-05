---
id: M-X3
name: IMO Number Theory
category: Number Theory
difficulty: 5
points: 7
keywords:
  - "vô hạn"
  - "infinite"
  - "nguyên tố"
  - "prime"
  - "Euclid"
  - "proof by contradiction"
answer: "infinitely many primes"
---

# IMO-Level Number Theory

## Prompt

<prompt>
(Định lý Euclid)

Chứng minh rằng có vô hạn số nguyên tố.
</prompt>

## Expected Answer

```
Định lý Euclid: Có vô hạn số nguyên tố.

Chứng minh bằng phản chứng:

Giả sử chỉ có hữu hạn số nguyên tố: p₁, p₂, p₃, ..., pₙ

Xét số: N = p₁ × p₂ × p₃ × ... × pₙ + 1

Nhận xét về N:
- N > 1 (vì N > pₙ > 1)
- N > tất cả các pᵢ

Xét phép chia N cho từng pᵢ:
N = p₁ × p₂ × ... × pₙ + 1
⟹ N chia pᵢ dư 1 (với mọi i = 1, 2, ..., n)
⟹ N không chia hết cho bất kỳ pᵢ nào

Tuy nhiên, theo Định lý cơ bản của số học:
Mọi số nguyên > 1 đều có thể biểu diễn thành tích các số nguyên tố.

Vì N > 1, nên N phải có ước nguyên tố.
Gọi p là ước nguyên tố của N.

Vì p là số nguyên tố nên p ∈ {p₁, p₂, ..., pₙ} (theo giả sử)
Nhưng N không chia hết cho bất kỳ pᵢ nào → Mâu thuẫn!

Vậy giả sử sai, tức là có vô hạn số nguyên tố. ∎

Ghi chú: Thực tế có 2 trường hợp:
1. N là số nguyên tố → N là số nguyên tố mới ∉ {p₁, ..., pₙ}
2. N là hợp số → N có ước nguyên tố p ∉ {p₁, ..., pₙ}

Cả hai đều cho số nguyên tố mới, mâu thuẫn với giả sử.
```

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | Chứng minh phản chứng đầy đủ, chặt chẽ |
| 6 pts | Đúng ý tưởng, thiếu giải thích chi tiết |
| 5 pts | Đúng xây dựng N, thiếu kết luận |
| 3 pts | Hiểu phản chứng nhưng không xây dựng được N |
| 1 pt  | Biết kết quả nhưng không chứng minh được |
| 0 pts | Không giải được |

## Keywords for Grading

- Primary: `vô hạn`, `infinite`, `infinitely many`
- Method: `phản chứng`, `contradiction`, `N = p₁p₂...pₙ + 1`
- Concepts: `ước`, `divisor`, `dư 1`, `remainder`
