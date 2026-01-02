# Đồng dư thức (Modular Arithmetic)

## Định nghĩa

```latex
a \equiv b \pmod{m} \Leftrightarrow m | (a - b)
```

"a đồng dư b theo modulo m"

## Tính chất cơ bản

### Phép cộng và nhân
```latex
a \equiv b \pmod{m}, c \equiv d \pmod{m}

\Rightarrow a + c \equiv b + d \pmod{m}

\Rightarrow a \cdot c \equiv b \cdot d \pmod{m}
```

### Lũy thừa
```latex
a \equiv b \pmod{m} \Rightarrow a^n \equiv b^n \pmod{m}
```

### Chia (cẩn thận!)
```latex
ac \equiv bc \pmod{m} \Rightarrow a \equiv b \pmod{\frac{m}{\gcd(c, m)}}
```

## Định lý Fermat nhỏ

```latex
p \text{ nguyên tố}, \gcd(a, p) = 1 \Rightarrow a^{p-1} \equiv 1 \pmod{p}
```

### Hệ quả
```latex
a^p \equiv a \pmod{p} \quad \forall a \in \mathbb{Z}
```

### Ứng dụng
- Tính a^n mod p nhanh
- Tìm nghịch đảo modular

## Định lý Euler

```latex
\gcd(a, n) = 1 \Rightarrow a^{\varphi(n)} \equiv 1 \pmod{n}
```

(Tổng quát của Fermat nhỏ, vì φ(p) = p-1)

## Nghịch đảo modular

### Định nghĩa
```latex
a^{-1} \pmod{m}: \quad a \cdot a^{-1} \equiv 1 \pmod{m}
```

Tồn tại khi gcd(a, m) = 1

### Tính nghịch đảo
1. **Fermat nhỏ** (m nguyên tố): a^(-1) ≡ a^(m-2) (mod m)
2. **Euler**: a^(-1) ≡ a^(φ(m)-1) (mod m)
3. **Euclid mở rộng**: Tìm x sao cho ax + my = 1

## Định lý phần dư Trung Hoa (CRT)

Nếu gcd(m₁, m₂) = 1:
```latex
\begin{cases}
x \equiv a_1 \pmod{m_1} \\
x \equiv a_2 \pmod{m_2}
\end{cases}
\text{ có nghiệm duy nhất } \pmod{m_1 m_2}
```

### Công thức giải
```latex
x = a_1 M_1 y_1 + a_2 M_2 y_2 \pmod{m_1 m_2}
```
trong đó:
- M₁ = m₂, M₂ = m₁
- y₁ = M₁^(-1) mod m₁
- y₂ = M₂^(-1) mod m₂

## Bậc của phần tử

### Định nghĩa
```latex
\text{ord}_m(a) = \min\{k > 0 : a^k \equiv 1 \pmod{m}\}
```

### Tính chất
```latex
\text{ord}_m(a) | \varphi(m)

a^n \equiv 1 \pmod{m} \Leftrightarrow \text{ord}_m(a) | n
```

## Căn nguyên thủy

### Định nghĩa
g là căn nguyên thủy mod m nếu ord_m(g) = φ(m)

### Tồn tại
Căn nguyên thủy tồn tại khi m = 1, 2, 4, p^k, 2p^k (p lẻ)

## Lifting the Exponent Lemma (LTE)

### Trường hợp p lẻ
Với p | (x - y) và p ∤ x, p ∤ y:
```latex
v_p(x^n - y^n) = v_p(x - y) + v_p(n)
```

### Trường hợp p = 2
Với 2 | (x - y) và x, y lẻ:
```latex
v_2(x^n - y^n) = v_2(x - y) + v_2(x + y) + v_2(n) - 1
```

## Ứng dụng Olympic

### Pattern thường gặp
```latex
n^2 \equiv 0, 1 \pmod{3}
n^2 \equiv 0, 1 \pmod{4}
n^2 \equiv 0, 1, 4 \pmod{8}
n^3 \equiv 0, 1, 6, 7, 8 \pmod{9}
```

### Kỹ thuật
1. Xét mod nhỏ để tìm ràng buộc
2. CRT để kết hợp nhiều điều kiện
3. LTE để phân tích v_p(expression)
