# Advanced Proof Techniques for IMO

> Kỹ thuật chứng minh nâng cao cho Olympic Toán Quốc tế

## 1. Proof by Contradiction (Phản chứng)

### 1.1 Standard Form

```
Cần chứng minh: P

1. Giả sử ¬P (phủ định của P)
2. Từ ¬P, suy ra các hệ quả
3. Dẫn đến mâu thuẫn với:
   - Giả thiết đề bài
   - Một định lý đã biết
   - Chính ¬P
4. Kết luận: P đúng ∎
```

### 1.2 When to Use

```
✓ Chứng minh không tồn tại
✓ Chứng minh duy nhất
✓ Chứng minh vô hạn
✓ Khi chứng minh trực tiếp quá khó
```

### 1.3 Example Template

```latex
\textbf{Proof by Contradiction:}

Giả sử ngược lại, tức là [negation of statement].

[Logical deductions from the assumption]

Điều này mâu thuẫn với [known fact / hypothesis].

Do đó, giả sử là sai. Vậy [original statement] đúng. $\square$
```

## 2. Mathematical Induction (Quy nạp)

### 2.1 Simple Induction

```
Chứng minh P(n) đúng ∀n ≥ n₀

1. Base case: Chứng minh P(n₀) đúng
2. Inductive step:
   - Giả sử P(k) đúng (IH - Inductive Hypothesis)
   - Chứng minh P(k+1) đúng
3. Kết luận: P(n) đúng ∀n ≥ n₀ ∎
```

### 2.2 Strong Induction

```
Chứng minh P(n) đúng ∀n ≥ n₀

1. Base case: Chứng minh P(n₀), P(n₀+1), ..., P(n₀+m) đúng
2. Inductive step:
   - Giả sử P(n₀), P(n₀+1), ..., P(k) đúng với k ≥ n₀+m
   - Chứng minh P(k+1) đúng
3. Kết luận: P(n) đúng ∀n ≥ n₀ ∎
```

### 2.3 Two-Way Induction

```
Dùng khi cần chứng minh P(n) ∀n ∈ ℤ

1. Chứng minh P(0)
2. Chứng minh P(n) → P(n+1) ∀n ≥ 0
3. Chứng minh P(n) → P(n-1) ∀n ≤ 0
```

### 2.4 Structural Induction

```
Dùng cho cấu trúc đệ quy (cây, biểu thức, ...)

1. Base case: Chứng minh cho cấu trúc cơ bản
2. Inductive step: Giả sử đúng cho sub-structures,
   chứng minh đúng cho combined structure
```

### 2.5 Common Mistakes

```
❌ Quên base case
❌ Base case sai
❌ Không dùng IH trong inductive step
❌ Sử dụng IH không đúng
❌ Gap trong induction (bỏ sót cases)
```

## 3. Infinite Descent (Hạ vô hạn)

### 3.1 Standard Form

```
Cần chứng minh: Không tồn tại n ∈ ℕ thỏa mãn P(n)

1. Giả sử tồn tại n₀ ∈ ℕ thỏa mãn P(n₀)
2. Chọn n₀ NHỎ NHẤT thỏa mãn P
3. Từ n₀, xây dựng n₁ < n₀ cũng thỏa mãn P
4. Mâu thuẫn với tính tối tiểu của n₀
5. Kết luận: Không tồn tại n thỏa mãn P ∎
```

### 3.2 Applications

```
- Chứng minh phương trình Diophantine vô nghiệm
- Chứng minh √2 vô tỉ
- Fermat's Last Theorem (n=4)
```

### 3.3 Example: √2 is irrational

```
Giả sử √2 = p/q với p,q ∈ ℤ, gcd(p,q) = 1.

2q² = p² → p² chẵn → p chẵn → p = 2k
2q² = 4k² → q² = 2k² → q chẵn

Mâu thuẫn với gcd(p,q) = 1. ∎
```

## 4. Extremal Principle (Nguyên lý cực trị)

### 4.1 Minimum Counterexample

```
Cần chứng minh: P(n) đúng ∀n

1. Giả sử tồn tại n sao cho P(n) sai
2. Chọn n NHỎ NHẤT sao cho P(n) sai
3. Sử dụng P(k) đúng ∀k < n
4. Dẫn đến P(n) đúng → mâu thuẫn ∎
```

### 4.2 Extremal Element

```
Trong tập hữu hạn, xét phần tử cực trị:
- Số lớn nhất / nhỏ nhất
- Điểm xa nhất / gần nhất
- Góc lớn nhất / nhỏ nhất
- Diện tích max / min
```

### 4.3 Example Usage

```
Bài toán: Trong n điểm trên mặt phẳng, không có 3 điểm thẳng hàng,
chứng minh tồn tại đường thẳng qua đúng 2 điểm.

Lời giải:
- Xét tất cả các cặp (đường thẳng qua 2 điểm, điểm không thuộc đường thẳng)
- Chọn cặp có khoảng cách NHỎ NHẤT
- Chứng minh đường thẳng này đi qua đúng 2 điểm
```

## 5. Double Counting

### 5.1 Standard Form

```
Đếm số cặp (a, b) ∈ A × B thỏa mãn R(a,b) theo 2 cách:

Cách 1: ∑_{a ∈ A} |{b : R(a,b)}|
Cách 2: ∑_{b ∈ B} |{a : R(a,b)}|

Hai cách phải bằng nhau.
```

### 5.2 Example: Handshaking Lemma

```
Trong đồ thị, tổng bậc của các đỉnh = 2 × số cạnh.

Proof:
Đếm số cặp (v, e) với v là đầu mút của e:
- Đếm theo v: ∑_{v} deg(v)
- Đếm theo e: 2|E| (mỗi cạnh có 2 đầu mút)
```

### 5.3 Applications

```
- Euler's formula cho đồ thị phẳng
- Số incidences point-line
- Counting arguments trong combinatorics
```

## 6. Pigeonhole Principle

### 6.1 Basic Form

```
Nếu n+1 đồ vật được đặt vào n ngăn,
thì tồn tại ít nhất 1 ngăn chứa ≥ 2 đồ vật.
```

### 6.2 Generalized Form

```
Nếu N đồ vật vào n ngăn, tồn tại ngăn chứa ≥ ⌈N/n⌉ đồ vật.

Infinite pigeonhole:
Nếu vô hạn đồ vật vào hữu hạn ngăn, tồn tại ngăn vô hạn.
```

### 6.3 Applications

```
- Số học: n+1 số → 2 số cùng dư mod n
- Dãy số: Trong dãy n²+1 số, có dãy con đơn điệu độ dài n+1
- Hình học: n+1 điểm trong hình vuông cạnh 1 → 2 điểm cách ≤ √2/n
```

## 7. Invariants and Monovariants

### 7.1 Invariant

```
Đại lượng KHÔNG ĐỔI qua các phép biến đổi.

Dùng để chứng minh KHÔNG THỂ:
- Nếu I(initial) ≠ I(target) → không thể biến đổi
```

### 7.2 Common Invariants

```
- Parity (tính chẵn lẻ)
- Sum modulo n
- Coloring (tô màu bàn cờ)
- Số nghịch thế
- Polynomial evaluation
```

### 7.3 Monovariant

```
Đại lượng chỉ TĂNG hoặc chỉ GIẢM.

Dùng để chứng minh:
- Quá trình DỪNG (bounded monovariant)
- Số bước giới hạn
```

### 7.4 Example: Chocolate Bar

```
Bẻ thanh chocolate m×n thành mn miếng 1×1.
Số lần bẻ tối thiểu?

Monovariant: Số miếng sau mỗi lần bẻ TĂNG 1.
Ban đầu: 1 miếng. Cuối: mn miếng.
Số lần bẻ = mn - 1. ∎
```

## 8. Constructive Proofs

### 8.1 Direct Construction

```
Chứng minh tồn tại bằng cách XÂY DỰNG cụ thể.

Steps:
1. Describe the construction
2. Verify construction satisfies all conditions
```

### 8.2 Greedy Construction

```
Xây dựng từng bước, mỗi bước chọn "tốt nhất".

Cần chứng minh:
- Mỗi bước có thể thực hiện (no dead end)
- Kết quả đạt yêu cầu
```

### 8.3 Probabilistic Method (Advanced)

```
Chứng minh tồn tại bằng cách chỉ ra P(X thỏa mãn) > 0.

Nếu P > 0, thì tồn tại ít nhất 1 X thỏa mãn.
```

## 9. Proof Formatting for IMO

### 9.1 Structure

```latex
\textbf{Solution:}

[Optional: Key observation or lemma]

[Main proof]

[Conclusion with box]
$\boxed{\text{Answer}}$
```

### 9.2 Clear Transitions

```
"We claim that..." → Claim
"Indeed,..." → Start of justification
"Thus,..." → Conclusion of argument
"It follows that..." → Consequence
"Without loss of generality (WLOG),..." → Symmetry reduction
"Suppose for contradiction..." → Start of contradiction proof
```

### 9.3 Lemma Structure

```latex
\textbf{Lemma:} [Statement]

\textbf{Proof of Lemma:}
[Proof]
$\square$

[Continue main proof using lemma]
```

## 10. Verification Checklist

```
Before submitting:

□ Is the logic correct?
□ Are all cases covered?
□ Is the base case verified (for induction)?
□ Is the contradiction clear (for proof by contradiction)?
□ Are all claims justified?
□ Is the answer clearly stated?
□ Are there any gaps in reasoning?
□ Double-check calculations
```

---

*Advanced proof techniques for IMO-level problem solving.*
