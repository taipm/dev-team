# IMO Number Theory Techniques

> Kỹ thuật Số học nâng cao cho Olympic Toán Quốc tế

## 1. Divisibility and Primes

### 1.1 Fundamental Theorems

```
Fundamental Theorem of Arithmetic:
Mọi số n > 1 phân tích duy nhất thành tích các số nguyên tố:
n = p₁^a₁ · p₂^a₂ · ... · pₖ^aₖ

Bezout's Identity:
gcd(a,b) = ax + by với x, y ∈ ℤ
```

### 1.2 Useful Divisibility Results

```
a | b và a | c ⟹ a | (bx + cy)
a | bc và gcd(a,b) = 1 ⟹ a | c
p | ab với p nguyên tố ⟹ p | a hoặc p | b
```

### 1.3 GCD/LCM Properties

```
gcd(a,b) · lcm(a,b) = ab
gcd(a,bc) = gcd(a,b) · gcd(a,c) khi gcd(b,c) = 1
gcd(aⁿ - 1, aᵐ - 1) = a^gcd(n,m) - 1
```

## 2. Modular Arithmetic

### 2.1 Basic Properties

```
a ≡ b (mod n) ⟺ n | (a - b)

Properties:
- a ≡ b, c ≡ d ⟹ a + c ≡ b + d
- a ≡ b, c ≡ d ⟹ ac ≡ bd
- a ≡ b ⟹ aⁿ ≡ bⁿ
- ca ≡ cb ⟹ a ≡ b (mod n/gcd(c,n))
```

### 2.2 Fermat's Little Theorem

```
Nếu p nguyên tố và gcd(a,p) = 1:

a^(p-1) ≡ 1 (mod p)
a^p ≡ a (mod p)
```

**Applications:**
```
- Tính dư của a^n mod p
- Chứng minh chia hết
- Inverse: a^(-1) ≡ a^(p-2) (mod p)
```

### 2.3 Euler's Theorem

```
Nếu gcd(a,n) = 1:

a^φ(n) ≡ 1 (mod n)

Euler's totient:
φ(n) = n · ∏(1 - 1/p) với p | n
φ(p^k) = p^k - p^(k-1)
φ(mn) = φ(m)φ(n) khi gcd(m,n) = 1
```

### 2.4 Chinese Remainder Theorem (CRT)

```
Nếu gcd(m,n) = 1, hệ:
x ≡ a (mod m)
x ≡ b (mod n)

có nghiệm duy nhất modulo mn.

Công thức: x = a·n·(n^(-1) mod m) + b·m·(m^(-1) mod n)
```

**Generalized CRT:**
```
x ≡ aᵢ (mod nᵢ), i = 1..k với các nᵢ đôi một nguyên tố cùng nhau
⟹ Nghiệm duy nhất mod n₁n₂...nₖ
```

### 2.5 Order and Primitive Roots

```
Order of a modulo n:
ord_n(a) = min{k > 0 : a^k ≡ 1 (mod n)}

Properties:
- ord_n(a) | φ(n)
- a^m ≡ 1 (mod n) ⟺ ord_n(a) | m
- ord_n(a^k) = ord_n(a) / gcd(k, ord_n(a))

Primitive root:
g là primitive root mod n nếu ord_n(g) = φ(n)
Tồn tại primitive root ⟺ n = 1, 2, 4, p^k, 2p^k (p lẻ)
```

## 3. Advanced Techniques

### 3.1 Lifting the Exponent Lemma (LTE)

```
Cho p lẻ, p | a - b, p ∤ a, p ∤ b:

v_p(aⁿ - bⁿ) = v_p(a - b) + v_p(n)

Cho p = 2, 2 | a - b, a, b lẻ, n chẵn:

v_2(aⁿ - bⁿ) = v_2(a - b) + v_2(a + b) + v_2(n) - 1

(v_p(x) = số mũ cao nhất của p chia hết x)
```

**Example:**
```
v_3(7^100 - 1) = v_3(7-1) + v_3(100) = 1 + 0 = 1
⟹ 3 | 7^100 - 1 but 9 ∤ 7^100 - 1
```

### 3.2 Zsygmondy's Theorem

```
Với a > b ≥ 1, gcd(a,b) = 1, n > 1:

Tồn tại số nguyên tố p | aⁿ - bⁿ nhưng p ∤ aᵏ - bᵏ với mọi k < n

Ngoại trừ:
1. n = 2, a + b là lũy thừa của 2
2. n = 6, a = 2, b = 1 (2^6 - 1 = 63 = 7·9)
```

### 3.3 Legendre Symbol

```
Cho p lẻ:
(a/p) = 1 nếu a là QR mod p
(a/p) = -1 nếu a không là QR mod p
(a/p) = 0 nếu p | a

Euler's Criterion:
(a/p) ≡ a^((p-1)/2) (mod p)

Properties:
(ab/p) = (a/p)(b/p)
(-1/p) = (-1)^((p-1)/2)
(2/p) = (-1)^((p²-1)/8)

Quadratic Reciprocity:
(p/q)(q/p) = (-1)^((p-1)(q-1)/4)
```

### 3.4 p-adic Valuation

```
v_p(n) = số mũ cao nhất của p trong n

Properties:
v_p(ab) = v_p(a) + v_p(b)
v_p(a + b) ≥ min(v_p(a), v_p(b))
v_p(a + b) = min(v_p(a), v_p(b)) nếu v_p(a) ≠ v_p(b)

v_p(n!) = ∑_{i=1}^∞ ⌊n/p^i⌋ (Legendre's formula)
```

### 3.5 Hensel's Lemma (Advanced)

```
Nếu f(a) ≡ 0 (mod p) và f'(a) ≢ 0 (mod p):

Tồn tại duy nhất b ≡ a (mod p) sao cho f(b) ≡ 0 (mod p^k) với mọi k.

Lifting: b' = b - f(b)/f'(b) (mod p^(k+1))
```

## 4. Diophantine Equations

### 4.1 Linear Diophantine Equation

```
ax + by = c có nghiệm ⟺ gcd(a,b) | c

General solution:
x = x₀ + (b/d)t
y = y₀ - (a/d)t

với d = gcd(a,b), (x₀, y₀) nghiệm đặc biệt
```

### 4.2 Pythagorean Equation

```
x² + y² = z² có primitive solutions:
x = m² - n²
y = 2mn
z = m² + n²

với gcd(m,n) = 1, m > n > 0, m-n lẻ
```

### 4.3 Pell's Equation

```
x² - Dy² = 1 (D không là số chính phương)

Có vô hạn nghiệm.
Fundamental solution (x₁, y₁) cho tất cả nghiệm:
x_n + y_n√D = (x₁ + y₁√D)^n
```

### 4.4 Sum of Two Squares

```
n = x² + y² ⟺ mọi thừa số nguyên tố p ≡ 3 (mod 4) có mũ chẵn

Fermat's theorem:
p lẻ: p = x² + y² ⟺ p ≡ 1 (mod 4)
```

### 4.5 Fermat's Last Theorem (Historical)

```
xⁿ + yⁿ = zⁿ không có nghiệm nguyên dương với n > 2.

Proved by Andrew Wiles (1995).
```

## 5. Techniques for Competition

### 5.1 Vieta Jumping

```
Khi phương trình đối xứng f(x,y) = 0 với (a,b) nghiệm,
xem x như biến, y = b cố định:
- Phương trình bậc 2 theo x có nghiệm a và a'
- Từ Vieta: a + a' = ... , a·a' = ...
- Nếu a' nguyên và 0 < a' < a → tiếp tục với (a', b)
- Contradiction với minimum
```

**Classic:** IMO 1988/6
```
Cho a² + b² / (ab + 1) = k nguyên.
Chứng minh k là số chính phương.
```

### 5.2 Infinite Descent

```
1. Giả sử tồn tại nghiệm (minimal)
2. Construct nghiệm nhỏ hơn
3. Contradiction với minimality
```

### 5.3 Size Arguments

```
Ước lượng size:
- So sánh mod với absolute value
- Bounding arguments
- Growth rate comparisons
```

### 5.4 Local-Global Principle

```
Check:
1. Nghiệm mod p với mọi p nguyên tố
2. Nghiệm thực

Nếu fail ở một local → không có nghiệm global.
```

## 6. Important Sequences

### 6.1 Fibonacci Numbers

```
F_n: 0, 1, 1, 2, 3, 5, 8, 13, ...
F_{n+2} = F_{n+1} + F_n

Properties:
- gcd(F_m, F_n) = F_{gcd(m,n)}
- F_n | F_{kn}
- F_{n+1}² + F_n² = F_{2n+1}
- F_{n+1}F_{n-1} - F_n² = (-1)^n
```

### 6.2 Lucas Numbers

```
L_n: 2, 1, 3, 4, 7, 11, 18, ...
L_{n+2} = L_{n+1} + L_n

L_n = F_{n-1} + F_{n+1}
```

### 6.3 Catalan Numbers

```
C_n = (2n)! / ((n+1)!·n!)
C_n = C_0·C_{n-1} + C_1·C_{n-2} + ... + C_{n-1}·C_0
```

## 7. Problem Types and Approaches

### 7.1 Divisibility Problems

```
Strategies:
1. Factor và analyze prime factors
2. Use mod với prime phù hợp
3. LTE cho difference of powers
4. Order arguments
```

### 7.2 Existence Problems

```
Strategies:
1. Direct construction
2. CRT construction
3. Infinite descent (non-existence)
4. Counting arguments
```

### 7.3 "Find All" Problems

```
Strategies:
1. Find necessary conditions
2. Verify sufficient conditions
3. Check small cases
4. Bound và exhaust
```

## 8. Template

```latex
\textbf{Solution:}

[Analyze the problem, identify key constraints]

[Choose appropriate technique]

[Execute proof with clear steps]

[Verify answer satisfies all conditions]

\boxed{\text{Answer}}
```

---

*IMO Number Theory for competitive mathematics.*
