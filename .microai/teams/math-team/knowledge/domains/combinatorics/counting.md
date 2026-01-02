# Đếm và Tổ hợp

## Công thức cơ bản

### Giai thừa
```latex
n! = n \times (n-1) \times ... \times 2 \times 1

0! = 1
```

### Hoán vị
```latex
P_n = n! \quad \text{(sắp xếp n phần tử)}
```

### Chỉnh hợp
```latex
A_n^k = \frac{n!}{(n-k)!} \quad \text{(chọn k từ n, có thứ tự)}
```

### Tổ hợp
```latex
C_n^k = \binom{n}{k} = \frac{n!}{k!(n-k)!} \quad \text{(chọn k từ n, không thứ tự)}
```

### Tính chất tổ hợp
```latex
C_n^k = C_n^{n-k}

C_n^k = C_{n-1}^{k-1} + C_{n-1}^k \quad \text{(Pascal)}

\sum_{k=0}^{n} C_n^k = 2^n
```

## Nguyên lý đếm

### Nguyên lý cộng
Nếu A có m cách, B có n cách (không giao nhau):
```latex
|A \cup B| = m + n
```

### Nguyên lý nhân
Nếu việc 1 có m cách, việc 2 có n cách (độc lập):
```latex
\text{Tổng số cách} = m \times n
```

### Nguyên lý bù trừ (Inclusion-Exclusion)
```latex
|A \cup B| = |A| + |B| - |A \cap B|

|A \cup B \cup C| = |A| + |B| + |C| - |A \cap B| - |B \cap C| - |C \cap A| + |A \cap B \cap C|
```

## Kỹ thuật đếm

### Đếm bù
```latex
|\text{Không có tính chất P}| = |\text{Tổng}| - |\text{Có tính chất P}|
```

### Chia trường hợp
Phân chia theo đặc điểm, đếm từng trường hợp rồi cộng lại.

### Stars and Bars
Chia n đồ vật giống nhau vào k hộp khác nhau:
```latex
\binom{n + k - 1}{k - 1}
```

### Hoán vị có lặp
n phần tử trong đó có n₁ loại 1, n₂ loại 2, ...:
```latex
\frac{n!}{n_1! \cdot n_2! \cdot ... \cdot n_r!}
```

## Nhị thức Newton

```latex
(a + b)^n = \sum_{k=0}^{n} \binom{n}{k} a^{n-k} b^k

= \binom{n}{0}a^n + \binom{n}{1}a^{n-1}b + ... + \binom{n}{n}b^n
```

### Hệ quả
```latex
\sum_{k=0}^{n} \binom{n}{k} = 2^n \quad \text{(thay a=b=1)}

\sum_{k=0}^{n} (-1)^k \binom{n}{k} = 0 \quad \text{(thay a=1, b=-1)}
```

## Nguyên lý Dirichlet (Pigeonhole)

### Dạng đơn giản
Nếu n+1 đồ vật vào n hộp → ít nhất 1 hộp có ≥ 2 đồ vật.

### Dạng tổng quát
Nếu kn+1 đồ vật vào n hộp → ít nhất 1 hộp có ≥ k+1 đồ vật.

### Ứng dụng
- Chứng minh tồn tại
- Tìm số lượng tối thiểu
- Bài toán mod

## Công thức truy hồi

### Fibonacci
```latex
F_n = F_{n-1} + F_{n-2}
F_0 = 0, F_1 = 1
```

### Catalan
```latex
C_n = \frac{1}{n+1}\binom{2n}{n}
```
Ứng dụng: Dãy ngoặc đúng, cây nhị phân, tam giác hóa đa giác.
