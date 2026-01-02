# Phương trình Đại số

## Phương trình bậc nhất
```latex
ax + b = 0 \Rightarrow x = -\frac{b}{a} \quad (a \neq 0)
```

## Phương trình bậc hai
```latex
ax^2 + bx + c = 0 \quad (a \neq 0)

\Delta = b^2 - 4ac

\text{Nghiệm: } x = \frac{-b \pm \sqrt{\Delta}}{2a}
```

### Các trường hợp
- Δ > 0: Hai nghiệm phân biệt
- Δ = 0: Nghiệm kép
- Δ < 0: Vô nghiệm (trong ℝ)

### Vieta
```latex
x_1 + x_2 = -\frac{b}{a}
x_1 \cdot x_2 = \frac{c}{a}
```

## Phương trình bậc ba

### Dạng tổng quát
```latex
ax^3 + bx^2 + cx + d = 0
```

### Dạng khuyết (x³ + px + q = 0)
**Cardano formula:**
```latex
x = \sqrt[3]{-\frac{q}{2} + \sqrt{D}} + \sqrt[3]{-\frac{q}{2} - \sqrt{D}}
\text{ với } D = \frac{q^2}{4} + \frac{p^3}{27}
```

**Lượng giác hóa** (khi |coefficient| ≤ 2):
```latex
x^3 - 3x + a = 0 \quad (|a| \leq 2)
\text{Đặt } x = 2\cos\theta
\text{Ta có } \cos 3\theta = \frac{a}{2}
```

## Phương trình vô tỉ

### Căn bậc hai
```latex
\sqrt{f(x)} = g(x) \Leftrightarrow
\begin{cases}
g(x) \geq 0 \\
f(x) = g(x)^2
\end{cases}
```

### Liên hợp
```latex
\sqrt{a} - \sqrt{b} = \frac{a - b}{\sqrt{a} + \sqrt{b}}
```

## Phương trình mũ và logarit

### Mũ
```latex
a^{f(x)} = a^{g(x)} \Leftrightarrow f(x) = g(x) \quad (a > 0, a \neq 1)
```

### Logarit
```latex
\log_a f(x) = \log_a g(x) \Leftrightarrow
\begin{cases}
f(x) = g(x) \\
f(x) > 0
\end{cases}
```

### Đổi cơ số
```latex
\log_a b = \frac{\ln b}{\ln a} = \frac{\log_c b}{\log_c a}
```

## Hệ phương trình

### Phương pháp thế
1. Rút một ẩn từ một PT
2. Thế vào PT còn lại
3. Giải PT một ẩn
4. Tìm ẩn còn lại

### Phương pháp cộng đại số
1. Nhân các PT để hệ số bằng nhau
2. Cộng/trừ để khử ẩn
3. Giải PT thu được

### Đặt ẩn phụ
Thường dùng khi có pattern đối xứng:
```latex
u = x + y, \quad v = xy
```
