# Bất phương trình Đại số

## Bất đẳng thức cơ bản

### AM-GM (Trung bình cộng - Trung bình nhân)
```latex
\frac{a_1 + a_2 + ... + a_n}{n} \geq \sqrt[n]{a_1 \cdot a_2 \cdot ... \cdot a_n}
\text{Dấu "=" khi } a_1 = a_2 = ... = a_n
```

### Cauchy-Schwarz
```latex
(a_1^2 + a_2^2 + ... + a_n^2)(b_1^2 + b_2^2 + ... + b_n^2) \geq (a_1b_1 + a_2b_2 + ... + a_nb_n)^2
```

### Dạng Engel (Cauchy-Schwarz)
```latex
\frac{a_1^2}{b_1} + \frac{a_2^2}{b_2} + ... + \frac{a_n^2}{b_n} \geq \frac{(a_1 + a_2 + ... + a_n)^2}{b_1 + b_2 + ... + b_n}
```

## Bất phương trình bậc nhất

```latex
ax + b > 0:
\begin{cases}
a > 0: x > -\frac{b}{a} \\
a < 0: x < -\frac{b}{a} \\
a = 0: \text{vô nghiệm hoặc nghiệm đúng } \forall x
\end{cases}
```

## Bất phương trình bậc hai

```latex
ax^2 + bx + c > 0 \quad (a \neq 0)
```

### Phương pháp
1. Tính Δ = b² - 4ac
2. Xét dấu a và Δ
3. Dùng bảng xét dấu hoặc parabol

### Bảng xét dấu
| a | Δ | ax² + bx + c > 0 |
|---|---|------------------|
| + | < 0 | ∀x ∈ ℝ |
| + | = 0 | x ≠ -b/(2a) |
| + | > 0 | x < x₁ hoặc x > x₂ |
| - | < 0 | ∅ |
| - | = 0 | ∅ |
| - | > 0 | x₁ < x < x₂ |

## Bất phương trình chứa dấu giá trị tuyệt đối

### Dạng cơ bản
```latex
|f(x)| < a \Leftrightarrow -a < f(x) < a \quad (a > 0)

|f(x)| > a \Leftrightarrow f(x) < -a \text{ hoặc } f(x) > a
```

### Dạng tổng
```latex
|a| + |b| \geq |a + b| \quad \text{(Bất đẳng thức tam giác)}

|a| - |b| \leq |a - b|
```

## Bất phương trình phân thức

```latex
\frac{f(x)}{g(x)} > 0 \Leftrightarrow f(x) \cdot g(x) > 0 \text{ và } g(x) \neq 0
```

### Phương pháp khoảng
1. Tìm nghiệm của tử và mẫu
2. Xếp lên trục số
3. Xác định dấu từng khoảng
4. Chọn khoảng phù hợp

## Bất phương trình vô tỉ

### Dạng √f(x) > g(x)
```latex
\sqrt{f(x)} > g(x) \Leftrightarrow
\begin{cases}
f(x) \geq 0, g(x) < 0 \\
\text{hoặc} \\
f(x) \geq 0, g(x) \geq 0, f(x) > g(x)^2
\end{cases}
```

### Dạng √f(x) < g(x)
```latex
\sqrt{f(x)} < g(x) \Leftrightarrow
\begin{cases}
f(x) \geq 0 \\
g(x) > 0 \\
f(x) < g(x)^2
\end{cases}
```

## Kỹ thuật chứng minh BĐT

1. **Biến đổi tương đương**: A ≥ B ⟺ A - B ≥ 0
2. **AM-GM**: Khi có tích hoặc cần ước lượng
3. **Cauchy-Schwarz**: Khi có tổng bình phương
4. **Phân tích thành bình phương**: (a-b)² ≥ 0
5. **Quy nạp**: Cho BĐT với n biến
