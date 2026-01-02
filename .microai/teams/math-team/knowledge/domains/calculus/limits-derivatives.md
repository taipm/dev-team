# Giới hạn và Đạo hàm

## Giới hạn

### Giới hạn cơ bản
```latex
\lim_{x \to 0} \frac{\sin x}{x} = 1

\lim_{x \to 0} \frac{1 - \cos x}{x^2} = \frac{1}{2}

\lim_{x \to 0} \frac{\tan x}{x} = 1

\lim_{x \to 0} \frac{e^x - 1}{x} = 1

\lim_{x \to 0} \frac{\ln(1 + x)}{x} = 1

\lim_{x \to \infty} \left(1 + \frac{1}{x}\right)^x = e

\lim_{x \to 0} (1 + x)^{1/x} = e
```

### Dạng vô định
- 0/0, ∞/∞ → L'Hospital hoặc biến đổi
- 0 × ∞ → Chuyển về 0/0 hoặc ∞/∞
- ∞ - ∞ → Thông phân, nhân liên hợp
- 1^∞, 0^0, ∞^0 → Dùng logarit

### Quy tắc L'Hospital
```latex
\lim_{x \to a} \frac{f(x)}{g(x)} = \lim_{x \to a} \frac{f'(x)}{g'(x)}
```
(Áp dụng khi 0/0 hoặc ∞/∞)

## Đạo hàm

### Công thức cơ bản
```latex
(c)' = 0

(x^n)' = nx^{n-1}

(\sqrt{x})' = \frac{1}{2\sqrt{x}}

\left(\frac{1}{x}\right)' = -\frac{1}{x^2}

(e^x)' = e^x

(a^x)' = a^x \ln a

(\ln x)' = \frac{1}{x}

(\log_a x)' = \frac{1}{x \ln a}
```

### Đạo hàm lượng giác
```latex
(\sin x)' = \cos x

(\cos x)' = -\sin x

(\tan x)' = \frac{1}{\cos^2 x} = 1 + \tan^2 x

(\cot x)' = -\frac{1}{\sin^2 x}
```

### Quy tắc đạo hàm
```latex
(u + v)' = u' + v'

(u \cdot v)' = u'v + uv'

\left(\frac{u}{v}\right)' = \frac{u'v - uv'}{v^2}

(f(g(x)))' = f'(g(x)) \cdot g'(x) \quad \text{(Chain rule)}
```

## Ứng dụng đạo hàm

### Cực trị
```latex
f'(x_0) = 0 \text{ và } f''(x_0) < 0 \Rightarrow x_0 \text{ là điểm cực đại}

f'(x_0) = 0 \text{ và } f''(x_0) > 0 \Rightarrow x_0 \text{ là điểm cực tiểu}
```

### Tiếp tuyến
```latex
\text{PT tiếp tuyến tại } (x_0, y_0): y - y_0 = f'(x_0)(x - x_0)
```

### Khảo sát hàm số
1. TXĐ
2. Sự biến thiên (y', bảng biến thiên)
3. Cực trị
4. Giới hạn, tiệm cận
5. Đồ thị

### Tiệm cận
```latex
\text{Ngang: } y = \lim_{x \to \pm\infty} f(x)

\text{Đứng: } x = a \text{ nếu } \lim_{x \to a} f(x) = \pm\infty

\text{Xiên: } y = ax + b \text{ với } a = \lim_{x \to \infty} \frac{f(x)}{x}, b = \lim_{x \to \infty}(f(x) - ax)
```
