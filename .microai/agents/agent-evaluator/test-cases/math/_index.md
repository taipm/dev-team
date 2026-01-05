# Mathematics Test Cases

> Bộ test đánh giá khả năng giải toán của LLM models

## Tổng quan

Đánh giá 5 chiều năng lực toán học:
1. **Arithmetic & Algebra** - Tính toán, phương trình
2. **Logic & Proof** - Suy luận logic, chứng minh
3. **Geometry** - Hình học phẳng và không gian
4. **Combinatorics** - Tổ hợp, xác suất
5. **Problem Solving** - Bài toán tổng hợp, olympiad

## Cấp độ

| Tier | Điểm | Mô tả | Expected |
|------|------|-------|----------|
| M-Easy | 15 | Toán cơ bản (cấp 2) | Local 60%+, Cloud 90%+ |
| M-Medium | 25 | Toán nâng cao (cấp 3) | Local 30-50%, Cloud 70%+ |
| M-Hard | 35 | Toán chuyên (HSG tỉnh) | Local 10-20%, Cloud 50%+ |
| M-Expert | 25 | Olympiad (IMO, VMO) | Local <10%, Cloud 30%+ |

## Scoring

- **Exact match**: Đáp án chính xác
- **Process scoring**: Partial credit cho reasoning đúng
- **Key concepts**: Keywords cho concepts quan trọng

## Files

```
math/
├── _index.md           # This file
├── M-E1-arithmetic.md  # Basic arithmetic
├── M-E2-algebra.md     # Linear equations
├── M-E3-geometry.md    # Basic geometry
├── M-M1-quadratic.md   # Quadratic equations
├── M-M2-sequences.md   # Arithmetic/geometric sequences
├── M-M3-trigonometry.md # Trigonometry
├── M-M4-probability.md # Basic probability
├── M-M5-functions.md   # Functions and graphs
├── M-H1-polynomial.md  # Polynomial equations
├── M-H2-inequalities.md # Inequalities and optimization
├── M-H3-number-theory.md # Number theory basics
├── M-H4-combinatorics.md # Counting and combinatorics
├── M-H5-geometry-adv.md # Advanced geometry
├── M-X1-imo-algebra.md # IMO-level algebra
├── M-X2-imo-geometry.md # IMO-level geometry
├── M-X3-imo-number.md  # IMO-level number theory
└── benchmark-math.sh   # Benchmark runner
```
