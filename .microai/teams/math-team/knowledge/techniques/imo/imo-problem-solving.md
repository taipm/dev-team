# IMO Problem-Solving Methodology

> Phương pháp giải toán Olympic Quốc tế (IMO Level)

## 1. Triết lý giải toán IMO

### 1.1 Mindset của IMO Solver

```
IMO ≠ Bài khó hơn
IMO = Bài đòi hỏi INSIGHT SÂU + SÁNG TẠO
```

**3 Nguyên tắc vàng:**
1. **Đừng vội vàng** - IMO cho 4.5 giờ/3 bài = 90 phút/bài
2. **Thử nhiều hướng** - Bài IMO thường có nhiều cách giải
3. **Tìm invariant** - Đại lượng không đổi thường là chìa khóa

### 1.2 IMO vs THPT

| Aspect | THPT | IMO |
|--------|------|-----|
| Thời gian | 5-10 phút/bài | 90 phút/bài |
| Kỹ thuật | Áp công thức | Sáng tạo từ nguyên lý |
| Pattern | Quen thuộc | Ẩn sau bề mặt |
| Solution | Thường 1 cách | Nhiều cách |
| Proof | Đơn giản | Chặt chẽ, formal |

## 2. Framework 7 Bước IMO

### Bước 1: DEEP READ (5-10 phút)

```
□ Đọc 3 lần:
  - Lần 1: Overview
  - Lần 2: Highlight từ khóa
  - Lần 3: Phân tích cấu trúc

□ Identify:
  - Cho gì? (Given/Hypothesis)
  - Hỏi gì? (Target/Conclusion)
  - Ràng buộc? (Constraints)
  - Có gì đặc biệt? (Special conditions)
```

### Bước 2: SIMPLIFY (5 phút)

```
□ Đơn giản hóa đề bài:
  - Thử n nhỏ (n=1,2,3,4,5)
  - Thử trường hợp đặc biệt
  - Vẽ hình (geometry)
  - Bỏ bớt điều kiện

□ Câu hỏi:
  - Bài này GIỐNG bài nào?
  - Nếu bỏ điều kiện X thì sao?
  - Điều kiện nào là CHÌA KHÓA?
```

### Bước 3: EXPLORE (15-20 phút)

```
□ Thử các hướng:
  - Brute force với n nhỏ
  - Tìm pattern
  - Đảo ngược (work backwards)
  - Contradiction (phản chứng)

□ Tools:
  - Tính toán cụ thể
  - Vẽ nhiều hình
  - Liệt kê cases
  - Tìm invariant
```

### Bước 4: IDENTIFY TECHNIQUE (5 phút)

```
□ Match với techniques:
  - Algebra: Polynomial, inequality, functional eq
  - Combinatorics: Counting, pigeonhole, extremal
  - Geometry: Angle chasing, coordinate, projective
  - Number Theory: Modular, Diophantine, order

□ Ask:
  - Technique nào PHẢI dùng?
  - Có thể kết hợp 2+ techniques?
```

### Bước 5: CONSTRUCT (30-40 phút)

```
□ Xây dựng lời giải:
  - Viết formal proof
  - Justify mỗi bước
  - Check edge cases
  - Verify với examples

□ Format:
  - Claim → Proof → Done
  - Lemma nếu cần
  - Clear transitions
```

### Bước 6: VERIFY (10 phút)

```
□ Kiểm tra:
  - Logic flow đúng?
  - Có bước nào sai?
  - Edge cases covered?
  - Đáp án hợp lý?

□ Test:
  - Thử lại với n=1,2,3
  - Extreme cases
  - Boundary conditions
```

### Bước 7: BEAUTIFY (5-10 phút)

```
□ Polish:
  - Rút gọn steps
  - Làm rõ transitions
  - Add insights
  - Clean notation
```

## 3. 12 Nguyên lý Vàng IMO

### 3.1 Extremal Principle (Nguyên lý cực trị)

```
Xét phần tử MAX/MIN của tập hợp.
Phần tử cực trị thường có tính chất đặc biệt.
```

**Example:**
- Chọn số lớn nhất trong dãy
- Chọn tam giác có diện tích lớn nhất
- Chọn đỉnh xa nhất

### 3.2 Pigeonhole Principle (Nguyên lý Dirichlet)

```
n+1 đồ vật vào n ngăn → ít nhất 1 ngăn có ≥2 đồ vật.

Generalized: kn+1 → ít nhất 1 ngăn có ≥k+1 đồ vật.
```

**Applications:**
- Đồng dư: n+1 số → 2 số cùng mod n
- Geometry: n+1 điểm trong đa giác n cạnh
- Sequences: Tìm substring lặp

### 3.3 Invariant Principle

```
Tìm đại lượng KHÔNG ĐỔI qua các phép biến đổi.
Nếu initial ≠ target modulo invariant → impossible.
```

**Common Invariants:**
- Tổng / Tích
- Parity (chẵn/lẻ)
- Modulo n
- Coloring (màu sắc)
- Degree trong graph

### 3.4 Monovariant Principle

```
Tìm đại lượng chỉ TĂNG hoặc chỉ GIẢM.
Bounded monovariant → quá trình phải dừng.
```

**Example:**
- Potential function
- Energy function
- Số bước còn lại

### 3.5 Induction (Quy nạp)

```
Strong Induction: Giả sử đúng với TẤT CẢ k < n

Types:
- Simple: n → n+1
- Strong: [1..n-1] → n
- Two-way: n → n+1 và n → n-1
- Structural: Trên cấu trúc (cây, đồ thị)
```

### 3.6 Contradiction (Phản chứng)

```
Giả sử NGƯỢC LẠI, dẫn đến mâu thuẫn.

Khi dùng:
- Chứng minh KHÔNG tồn tại
- Chứng minh DUY NHẤT
- Chứng minh VÔ HẠN
```

### 3.7 Construction (Xây dựng)

```
Chứng minh tồn tại bằng cách XÂY DỰNG cụ thể.

Types:
- Direct construction
- Greedy construction
- Probabilistic method (IMO hard)
```

### 3.8 Bijection Principle

```
|A| = |B| nếu tồn tại song ánh A → B.

Use for:
- Đếm (combinatorics)
- Chứng minh equal cardinality
- Transform problems
```

### 3.9 Double Counting

```
Đếm cùng một đại lượng theo 2 CÁCH KHÁC NHAU.

∑(over A) f(a,b) = ∑(over B) f(a,b)
```

### 3.10 Greedy Algorithm

```
Luôn chọn LOCALLY OPTIMAL → globally optimal?

Khi hoạt động:
- Matroid structure
- Exchange property
- Optimal substructure
```

### 3.11 Smoothing (Làm trơn)

```
Thay đổi để làm tình huống "smooth" hơn.
Extreme → đạt tại boundary.
```

**Applications:**
- Inequality optimization
- Convexity arguments
- Karamata

### 3.12 Coloring (Tô màu)

```
Gán màu để reveal hidden structure.

Types:
- Checkerboard (bàn cờ)
- Mod k coloring
- Graph coloring
- Weight assignment
```

## 4. Techniques theo Domain

### 4.1 Number Theory (IMO Favorite)

```yaml
Core:
  - Modular arithmetic
  - Legendre symbol
  - LTE (Lifting the Exponent)
  - Zsygmondy's theorem
  - Orders and primitive roots

Advanced:
  - Vieta jumping
  - USAMO inequality trick
  - p-adic valuation
  - Hensel's lemma
```

### 4.2 Combinatorics

```yaml
Counting:
  - Inclusion-Exclusion
  - Generating functions
  - Burnside's lemma
  - Catalan structures

Graph Theory:
  - Ramsey theory
  - Turán's theorem
  - Hall's theorem
  - Sperner's theorem

Games:
  - Nim theory
  - Sprague-Grundy
  - Symmetric strategy
```

### 4.3 Geometry

```yaml
Euclidean:
  - Angle chasing
  - Power of a point
  - Radical axes
  - Simson line
  - Nine-point circle

Transformations:
  - Homothety
  - Inversion
  - Spiral similarity
  - Projective

Trigonometric:
  - Law of sines/cosines
  - Area formulas
  - Trigonometric identities

Coordinate:
  - Complex numbers
  - Barycentric coordinates
  - Projective coordinates
```

### 4.4 Algebra

```yaml
Polynomial:
  - Vieta's formulas
  - Symmetric polynomials
  - Newton's identities
  - Resultant

Inequality:
  - AM-GM-HM
  - Cauchy-Schwarz
  - Schur
  - SOS (Sum of Squares)
  - Muirhead
  - Karamata

Functional Equations:
  - Cauchy's equation
  - Jensen's equation
  - Substitution tricks
  - Injectivity/Surjectivity
```

## 5. IMO Problem Classification

### 5.1 Difficulty Levels (P1-P6)

| Problem | Difficulty | Expected | Strategy |
|---------|-----------|----------|----------|
| P1, P4 | Easy | 70-80% solve | Standard techniques |
| P2, P5 | Medium | 30-50% solve | Combination of techniques |
| P3, P6 | Hard | 5-20% solve | Creative insight required |

### 5.2 Topic Distribution

```
Typical IMO:
- Day 1: Algebra/Combo, Geometry, NT
- Day 2: Combo/NT, Geometry, Algebra

Recent trends:
- More functional equations
- Graph theory rising
- Number theory still strong
- Geometry becoming harder
```

## 6. Common Mistakes to Avoid

### 6.1 Logic Errors

```
❌ Circular reasoning
❌ Assuming what to prove
❌ Missing edge cases
❌ Unjustified claims
❌ Wrong direction of implication
```

### 6.2 Computation Errors

```
❌ Sign errors
❌ Index off-by-one
❌ Wrong modular arithmetic
❌ Fraction simplification
```

### 6.3 Strategy Errors

```
❌ Sticking to one approach too long
❌ Not trying small cases first
❌ Overcomplicating
❌ Missing the key insight
```

## 7. Training Path

### Level 1: Foundation (1-2 years)

```
- Master basic techniques
- Solve 100+ national olympiad problems
- Learn proof writing
```

### Level 2: Intermediate (2-3 years)

```
- Study advanced techniques
- Solve past IMO P1, P4
- Learn from solutions
- Develop problem sense
```

### Level 3: Advanced (3+ years)

```
- Solve IMO P2, P5
- Create own problems
- Study cutting-edge techniques
- Speed and accuracy
```

## 8. Resources

### 8.1 Books

```
Beginner:
- "Problem-Solving Through Problems" - Larson
- "The Art and Craft of Problem Solving" - Zeitz

Intermediate:
- "Putnam and Beyond" - Gelca
- "Mathematical Olympiad Challenges" - Andreescu

Advanced:
- "The IMO Compendium" - Djukić
- Evan Chen's "EGMO"
```

### 8.2 Online

```
- AoPS (Art of Problem Solving)
- Evan Chen's blog
- Po-Shen Loh's YouTube
- IMO official website
```

---

*This knowledge is for Math Team IMO-level problem solving.*
