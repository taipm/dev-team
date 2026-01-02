# Chia hết và Số nguyên tố

## Định nghĩa chia hết

```latex
a | b \Leftrightarrow \exists k \in \mathbb{Z}: b = ka

\text{"a chia hết b" hay "b chia hết cho a"}
```

### Tính chất
```latex
a | b, a | c \Rightarrow a | (bx + cy) \quad \forall x, y \in \mathbb{Z}

a | b, b | c \Rightarrow a | c

a | b, b | a \Rightarrow a = \pm b
```

## Ước chung lớn nhất (ƯCLN)

### Định nghĩa
```latex
\gcd(a, b) = d \Leftrightarrow d | a, d | b \text{ và } d \text{ lớn nhất}
```

### Thuật toán Euclid
```latex
\gcd(a, b) = \gcd(b, a \mod b)
\gcd(a, 0) = a
```

### Tính chất
```latex
\gcd(a, b) \cdot \text{lcm}(a, b) = a \cdot b

\gcd(a, b) = \gcd(a - b, b) \quad (a > b)

\gcd(ka, kb) = k \cdot \gcd(a, b)
```

## Đồng thức Bézout

```latex
\gcd(a, b) = d \Rightarrow \exists x, y \in \mathbb{Z}: ax + by = d
```

### Hệ quả
- Phương trình ax + by = c có nghiệm nguyên ⟺ gcd(a,b) | c

## Số nguyên tố

### Định nghĩa
p là số nguyên tố nếu p > 1 và p chỉ có 2 ước: 1 và p.

### Định lý cơ bản của số học
Mỗi số nguyên > 1 phân tích duy nhất thành tích các số nguyên tố:
```latex
n = p_1^{a_1} \cdot p_2^{a_2} \cdot ... \cdot p_k^{a_k}
```

### Số lượng ước
```latex
n = p_1^{a_1} \cdot p_2^{a_2} \cdot ... \cdot p_k^{a_k}

\tau(n) = (a_1 + 1)(a_2 + 1)...(a_k + 1)
```

### Tổng các ước
```latex
\sigma(n) = \frac{p_1^{a_1+1} - 1}{p_1 - 1} \cdot \frac{p_2^{a_2+1} - 1}{p_2 - 1} \cdot ... \cdot \frac{p_k^{a_k+1} - 1}{p_k - 1}
```

## Dấu hiệu chia hết

| Số | Điều kiện |
|----|-----------|
| 2 | Chữ số cuối chẵn |
| 3 | Tổng các chữ số chia hết cho 3 |
| 4 | 2 chữ số cuối chia hết cho 4 |
| 5 | Chữ số cuối là 0 hoặc 5 |
| 6 | Chia hết cho cả 2 và 3 |
| 8 | 3 chữ số cuối chia hết cho 8 |
| 9 | Tổng các chữ số chia hết cho 9 |
| 11 | Hiệu tổng chữ số vị trí lẻ và chẵn chia hết cho 11 |

## Hàm Euler φ(n)

### Định nghĩa
φ(n) = số các số từ 1 đến n nguyên tố cùng n

### Công thức
```latex
\varphi(n) = n \prod_{p | n} \left(1 - \frac{1}{p}\right)
```

### Ví dụ
```latex
\varphi(12) = 12 \cdot \left(1 - \frac{1}{2}\right) \cdot \left(1 - \frac{1}{3}\right) = 12 \cdot \frac{1}{2} \cdot \frac{2}{3} = 4
```

## Các kết quả quan trọng

### n² mod 4
```latex
n^2 \equiv 0, 1 \pmod{4}
```

### n² mod 8
```latex
n^2 \equiv 0, 1, 4 \pmod{8}
```

### Tổng lập phương
```latex
n^3 \equiv n \pmod{6}
```
