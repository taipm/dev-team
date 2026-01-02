# IMO Inequality Techniques

> Kỹ thuật chứng minh bất đẳng thức cho Olympic Toán

## 1. Classical Inequalities

### 1.1 AM-GM (Arithmetic Mean - Geometric Mean)

```
Với a₁, a₂, ..., aₙ ≥ 0:

(a₁ + a₂ + ... + aₙ)/n ≥ ⁿ√(a₁·a₂·...·aₙ)

Equality ⟺ a₁ = a₂ = ... = aₙ
```

**Weighted AM-GM:**
```
Với weights w₁ + w₂ + ... + wₙ = 1, wᵢ > 0:

w₁a₁ + w₂a₂ + ... + wₙaₙ ≥ a₁^w₁ · a₂^w₂ · ... · aₙ^wₙ
```

**Tricks:**
```
- Thêm bớt số hạng để dùng AM-GM
- Nhân tử để tạo hằng số
- Chọn weight phù hợp
```

### 1.2 Cauchy-Schwarz

**Standard Form:**
```
(∑aᵢbᵢ)² ≤ (∑aᵢ²)(∑bᵢ²)

Equality ⟺ aᵢ/bᵢ = const
```

**Engel Form (Titu's Lemma):**
```
a₁²/b₁ + a₂²/b₂ + ... + aₙ²/bₙ ≥ (a₁ + a₂ + ... + aₙ)²/(b₁ + b₂ + ... + bₙ)

Equality ⟺ a₁/b₁ = a₂/b₂ = ... = aₙ/bₙ
```

**Applications:**
```
- Chứng minh BĐT dạng ∑(1/xᵢ) ≥ n²/∑xᵢ
- BĐT phân thức
- Minkowski inequality
```

### 1.3 Power Mean Inequality

```
M_r = (∑aᵢʳ/n)^(1/r)

For r < s: M_r ≤ M_s

Special cases:
- M₋₁ = HM (Harmonic Mean)
- M₀ = GM (Geometric Mean, limit)
- M₁ = AM (Arithmetic Mean)
- M₂ = QM (Quadratic Mean)

HM ≤ GM ≤ AM ≤ QM
```

### 1.4 Jensen's Inequality

```
Cho f convex (lồi), xᵢ ∈ domain:

f((x₁ + x₂ + ... + xₙ)/n) ≤ (f(x₁) + f(x₂) + ... + f(xₙ))/n

Cho f concave (lõm): đổi chiều BĐT
```

**Common convex functions:**
```
- x² (x ∈ ℝ)
- eˣ (x ∈ ℝ)
- -ln x (x > 0)
- xᵖ (p ≥ 1 or p ≤ 0, x > 0)
- 1/x (x > 0)
```

**Common concave functions:**
```
- √x (x > 0)
- ln x (x > 0)
- xᵖ (0 < p < 1, x > 0)
- sin x (0 < x < π)
```

### 1.5 Chebyshev's Inequality

```
Cho a₁ ≤ a₂ ≤ ... ≤ aₙ và b₁ ≤ b₂ ≤ ... ≤ bₙ:

n·∑aᵢbᵢ ≥ (∑aᵢ)(∑bᵢ) (cùng thứ tự)

n·∑aᵢbₙ₊₁₋ᵢ ≤ (∑aᵢ)(∑bᵢ) (ngược thứ tự)
```

### 1.6 Rearrangement Inequality

```
Cho a₁ ≤ a₂ ≤ ... ≤ aₙ và b₁ ≤ b₂ ≤ ... ≤ bₙ:

Với mọi permutation σ:
∑aᵢbₙ₊₁₋ᵢ ≤ ∑aᵢbσ(ᵢ) ≤ ∑aᵢbᵢ

Tức là: Reverse sum ≤ Any sum ≤ Sorted sum
```

## 2. Advanced Techniques

### 2.1 SOS (Sum of Squares)

```
Viết BĐT dưới dạng tổng bình phương.

Example: a² + b² + c² - ab - bc - ca ≥ 0

= 1/2[(a-b)² + (b-c)² + (c-a)²] ≥ 0 ✓
```

**Method:**
```
1. Đặt f(a,b,c) = LHS - RHS
2. Tìm cách viết f = ∑(...)² hoặc ∑positive × (...)²
3. Kết luận f ≥ 0
```

### 2.2 Schur's Inequality

```
Với a, b, c ≥ 0 và t ≥ 0:

aᵗ(a-b)(a-c) + bᵗ(b-c)(b-a) + cᵗ(c-a)(c-b) ≥ 0

Equality ⟺ a = b = c hoặc 2 trong 3 số bằng nhau và số còn lại = 0
```

**Common cases:**
```
t = 1: a³ + b³ + c³ + 3abc ≥ ab(a+b) + bc(b+c) + ca(c+a)
t = 2: a⁴ + b⁴ + c⁴ + abc(a+b+c) ≥ ab(a²+b²) + bc(b²+c²) + ca(c²+a²)
```

### 2.3 Muirhead's Inequality

```
Cho [a] = (a₁, a₂, ..., aₙ) và [b] = (b₁, b₂, ..., bₙ).

Nếu [a] majorizes [b] (ký hiệu [a] ≻ [b]), thì:
∑sym x₁^a₁ · x₂^a₂ · ... · xₙ^aₙ ≥ ∑sym x₁^b₁ · x₂^b₂ · ... · xₙ^bₙ

với xᵢ > 0.
```

**Majorization:**
```
[a] ≻ [b] nếu:
1. a₁ ≥ a₂ ≥ ... ≥ aₙ (sorted)
2. b₁ ≥ b₂ ≥ ... ≥ bₙ (sorted)
3. a₁ + a₂ + ... + aₖ ≥ b₁ + b₂ + ... + bₖ cho mọi k
4. a₁ + a₂ + ... + aₙ = b₁ + b₂ + ... + bₙ
```

**Example:**
```
(3,0,0) ≻ (2,1,0) ≻ (1,1,1)

⟹ a³ + b³ + c³ ≥ a²b + a²c + b²a + b²c + c²a + c²b ≥ 3abc
                    (chia 2)                        (chia 6)
```

### 2.4 Karamata's Inequality

```
Nếu f convex và (x₁, ..., xₙ) ≻ (y₁, ..., yₙ), thì:

∑f(xᵢ) ≥ ∑f(yᵢ)
```

### 2.5 Mixing Variables (Smoothing)

```
Kỹ thuật "dồn biến":
1. Giữ cố định một số biến, biến đổi các biến khác
2. Đưa về trường hợp cực trị (thường là biến bằng nhau hoặc = 0)
```

**Example:**
```
Chứng minh: a² + b² + c² ≥ ab + bc + ca

Smoothing: Nếu a ≠ b, đặt a' = b' = (a+b)/2
LHS giảm ít hơn RHS giảm (hoặc LHS tăng, RHS giảm)
⟹ BĐT mạnh hơn tại a = b = c
⟹ Check: 3a² ≥ 3a² ✓
```

## 3. Useful Substitutions

### 3.1 Trigonometric Substitution

```
Cho a, b, c > 0 với a + b + c = π:
- Đặt a = A, b = B, c = C (góc tam giác)
- Dùng: sin A, cos A, tan A, ...

Cho a² + b² = 1:
- Đặt a = sin θ, b = cos θ
```

### 3.2 Homogenization

```
Nếu BĐT homogeneous degree d:
- Có thể normalize: đặt a + b + c = 1, hoặc abc = 1, etc.

Nếu BĐT không homogeneous:
- Nhân thêm factor để thành homogeneous
```

### 3.3 Substitution for Symmetric Inequalities

```
Cho BĐT đối xứng 3 biến:
- p = a + b + c
- q = ab + bc + ca
- r = abc

Biểu diễn theo p, q, r và dùng:
- p² ≥ 3q (from (a-b)² + (b-c)² + (c-a)² ≥ 0)
- q² ≥ 3pr (similar)
- p³ + 2r ≥ 3pq (Schur)
```

## 4. Competition Strategies

### 4.1 Normalization Strategy

```
Step 1: Xác định BĐT có homogeneous không
Step 2: Nếu có, normalize về constraint thuận tiện
Step 3: Áp dụng kỹ thuật
```

### 4.2 Testing Equality Cases

```
1. Check a = b = c
2. Check extreme cases (một biến = 0)
3. Check boundary conditions
4. Từ equality condition, suy ngược technique cần dùng
```

### 4.3 Difficulty Assessment

```
Easy: AM-GM, CS trực tiếp
Medium: Combination, substitution
Hard: SOS, Schur, Muirhead
Very Hard: Smoothing, creative transformation
```

## 5. Classic Problems

### 5.1 Nesbitt's Inequality

```
a/(b+c) + b/(c+a) + c/(a+b) ≥ 3/2

Proof (CS):
LHS = ∑ a²/(a(b+c)) ≥ (a+b+c)²/∑a(b+c) = (a+b+c)²/2(ab+bc+ca)

Cần: (a+b+c)² ≥ 3(ab+bc+ca) ⟺ a² + b² + c² ≥ ab + bc + ca ✓
```

### 5.2 IMO 1995/2

```
Với a, b, c > 0 và abc = 1:

1/(a³(b+c)) + 1/(b³(c+a)) + 1/(c³(a+b)) ≥ 3/2
```

### 5.3 IMO 2001/2

```
Với a, b, c > 0:

a/√(a² + 8bc) + b/√(b² + 8ca) + c/√(c² + 8ab) ≥ 1
```

## 6. Template for Inequality Proof

```latex
\textbf{Proof:}

[Optional: Normalization]
WLOG, assume $a + b + c = 1$ (or other constraint).

[Optional: Key observation]
We claim that...

[Main proof using technique]
By [technique name], we have:
$[inequality steps]$

[Equality condition]
Equality holds when $a = b = c$.

$\square$
```

---

*IMO Inequality Techniques for competitive mathematics.*
