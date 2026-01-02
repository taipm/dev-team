# IMO Geometry Techniques

> Kỹ thuật Hình học nâng cao cho Olympic Toán Quốc tế

## 1. Angle Chasing

### 1.1 Basic Angle Theorems

```
Inscribed Angle Theorem:
Góc nội tiếp = 1/2 × góc ở tâm (cùng chắn cung)

Angles in Same Segment:
Góc nội tiếp cùng chắn một cung thì bằng nhau

Cyclic Quadrilateral:
Tứ giác nội tiếp ⟺ góc đối bù nhau
⟺ góc ngoài = góc trong đối diện
```

### 1.2 Tangent Angles

```
Góc tạo bởi tiếp tuyến và dây cung = góc nội tiếp chắn cung đó

Tangent-Secant:
PA² = PB · PC (P ngoài đường tròn, A tiếp điểm, B, C trên đường tròn)
```

### 1.3 Directed Angles

```
Ký hiệu: ∠(AB, CD) = góc có hướng từ AB đến CD

Properties:
∠(AB, CD) = -∠(CD, AB)
∠(AB, CD) + ∠(CD, EF) = ∠(AB, EF)

Avoid sign ambiguity trong angle chasing.
```

## 2. Power of a Point

### 2.1 Definition

```
Power of P với respect to circle O, radius r:
pow(P) = PO² - r²

= PA · PB (với A, B trên đường tròn, thẳng hàng với P)
= PT² (với T tiếp điểm từ P)
```

### 2.2 Sign Convention

```
P ngoài đường tròn: pow(P) > 0
P trên đường tròn: pow(P) = 0
P trong đường tròn: pow(P) < 0
```

### 2.3 Radical Axis

```
Tập hợp điểm có power bằng nhau với 2 đường tròn.

Radical axis ⊥ đường nối tâm.

3 đường tròn → 3 radical axes đồng quy tại radical center.
```

## 3. Similarity and Spiral Similarity

### 3.1 Similar Triangles

```
Conditions:
- AAA (hoặc AA)
- SAS (tỷ lệ cạnh kề và góc xen giữa)
- SSS (tỷ lệ 3 cạnh)

△ABC ~ △DEF ⟹ AB/DE = BC/EF = CA/FD
```

### 3.2 Spiral Similarity

```
Phép biến hình: xoay + phóng đại cùng tâm.

Nếu △ABC ~ △DEF:
Tồn tại spiral similarity S: A → D, B → E, C → F

Tâm spiral: giao điểm của (ABD) và (ACE), hoặc (BCE) và (ADF)
```

## 4. Projective Geometry

### 4.1 Cross Ratio

```
(A, B; C, D) = (AC/BC) / (AD/BD)

Preserved under projection.
```

### 4.2 Harmonic Division

```
(A, B; C, D) = -1 ⟺ A, B, C, D harmonic

Properties:
- Nếu A, B, C, D thẳng hàng, harmonic ⟹ AC/CB = -AD/DB
- Pole-polar duality
- Harmonic conjugates
```

### 4.3 Poles and Polars

```
Polar của P với respect to circle:
- Nếu P ngoài: đường nối 2 tiếp điểm
- Nếu P trong: define qua inverse

La Hire's Theorem:
P ∈ polar(Q) ⟺ Q ∈ polar(P)
```

## 5. Inversion

### 5.1 Definition

```
Inversion tâm O, bán kính r:
P ↦ P' sao cho OP · OP' = r²

P' nằm trên tia OP.
```

### 5.2 Key Properties

```
- Đường thẳng qua O ↔ chính nó (trừ O)
- Đường thẳng không qua O ↔ đường tròn qua O
- Đường tròn qua O ↔ đường thẳng không qua O
- Đường tròn không qua O ↔ đường tròn không qua O
- Góc được bảo toàn (conformal)
- Tangent ↔ tangent
```

### 5.3 When to Use Inversion

```
✓ Nhiều đường tròn tiếp xúc nhau
✓ Đường tròn qua điểm cố định
✓ Cấu hình có tính đối xứng qua inversion
✓ Biến đường tròn thành đường thẳng (đơn giản hóa)
```

### 5.4 Inversion Distance Formula

```
Nếu P' = inv(P), Q' = inv(Q):

P'Q' = (r² · PQ) / (OP · OQ)
```

## 6. Important Configurations

### 6.1 Nine-Point Circle

```
Đường tròn qua 9 điểm:
1. 3 trung điểm các cạnh
2. 3 chân đường cao
3. 3 trung điểm từ đỉnh đến trực tâm

Tâm N = trung điểm OH (O: ngoại tâm, H: trực tâm)
Bán kính r = R/2
```

### 6.2 Euler Line

```
O (ngoại tâm), G (trọng tâm), H (trực tâm) thẳng hàng.
OG : GH = 1 : 2
```

### 6.3 Simson Line

```
P trên đường tròn ngoại tiếp △ABC.
Hạ vuông góc từ P đến 3 cạnh, chân vuông góc thẳng hàng.
Đường thẳng này gọi là Simson line của P.
```

### 6.4 Radical Center

```
3 đường tròn → 3 radical axes.
3 radical axes đồng quy tại radical center.
Từ radical center, power với 3 đường tròn bằng nhau.
```

### 6.5 Mixtilinear Incircle

```
Đường tròn tiếp xúc trong với cung BC và tiếp xúc với AB, AC.
Tiếp điểm với cung là điểm giữa của cung.
```

## 7. Transformations

### 7.1 Reflection

```
Phản chiếu qua đường thẳng l:
- Bảo toàn khoảng cách
- Bảo toàn góc (đổi hướng)
- Đường tròn → đường tròn cùng bán kính
```

### 7.2 Rotation

```
Xoay tâm O, góc θ:
- Bảo toàn khoảng cách
- Bảo toàn góc
- Cấu hình → cấu hình đồng dạng
```

### 7.3 Homothety (Vị tự)

```
Vị tự tâm O, tỷ số k:
P ↦ P' sao cho OP' = k · OP

k > 0: cùng phía
k < 0: khác phía

Đường tròn → đường tròn (bán kính × |k|)
2 đường tròn có 2 tâm vị tự (internal và external)
```

### 7.4 Translation

```
Tịnh tiến theo vector v:
P ↦ P + v

Bảo toàn mọi thứ (trừ vị trí).
```

## 8. Coordinate Methods

### 8.1 Cartesian Coordinates

```
Khi dùng:
- Bài toán có nhiều góc vuông
- Cần tính toán cụ thể
- Verification

Đặt hệ trục sao cho tận dụng đối xứng.
```

### 8.2 Complex Numbers

```
Điểm P(x, y) ↔ số phức z = x + yi

Operations:
- Rotation by θ: z ↦ z · e^(iθ)
- Reflection over real axis: z ↦ z̄
- Reflection over line through O: z ↦ e^(2iθ) · z̄

Collinear: (z₁ - z₃)/(z₂ - z₃) ∈ ℝ
Concyclic: (z₁ - z₃)/(z₂ - z₃) × (z₂ - z₄)/(z₁ - z₄) ∈ ℝ
```

### 8.3 Barycentric Coordinates

```
P = αA + βB + γC với α + β + γ = 1

Normalized: (α : β : γ) với α + β + γ = 1
Homogeneous: (x : y : z) tỷ lệ

Special points:
- Centroid G = (1:1:1)
- Incenter I = (a:b:c)
- Circumcenter O = (sin 2A : sin 2B : sin 2C)
```

### 8.4 Trilinear Coordinates

```
(x : y : z) với x, y, z tỷ lệ khoảng cách đến 3 cạnh.

Conversion:
Trilinear (x:y:z) ↔ Barycentric (ax:by:cz)
```

## 9. Classic Theorems

### 9.1 Menelaus' Theorem

```
A, B, C không thẳng hàng.
D ∈ BC, E ∈ CA, F ∈ AB.

D, E, F thẳng hàng ⟺ (BD/DC) · (CE/EA) · (AF/FB) = -1

(dấu có hướng)
```

### 9.2 Ceva's Theorem

```
A, B, C không thẳng hàng.
D ∈ BC, E ∈ CA, F ∈ AB.

AD, BE, CF đồng quy ⟺ (BD/DC) · (CE/EA) · (AF/FB) = 1
```

### 9.3 Stewart's Theorem

```
Cevian AD với D ∈ BC:

AB² · DC + AC² · BD - AD² · BC = BC · BD · DC
```

### 9.4 Ptolemy's Theorem

```
Tứ giác ABCD nội tiếp:
AC · BD = AB · CD + AD · BC

Tổng quát (Ptolemy's inequality cho tứ giác bất kỳ):
AC · BD ≤ AB · CD + AD · BC

Equality ⟺ nội tiếp
```

### 9.5 Casey's Theorem (Generalized Ptolemy)

```
4 đường tròn tiếp xúc ngoài với đường tròn lớn:
t₁₂ · t₃₄ + t₁₄ · t₂₃ = t₁₃ · t₂₄

với tᵢⱼ = chiều dài tiếp tuyến chung ngoài của đường tròn i và j.
```

## 10. Competition Strategies

### 10.1 When to Use What

```
Angle chasing:
- Cyclic quadrilaterals
- Tangent circles
- Inscribed angles

Power of a point:
- Intersecting chords/secants
- Tangent problems
- Radical axis/center

Coordinates:
- Computational problems
- Verification
- When synthetic fails

Inversion:
- Tangent circles
- Circle through fixed point
- Complex tangency configurations

Transformations:
- Symmetry exploitation
- Construction problems
- Locus problems
```

### 10.2 Drawing Good Diagrams

```
✓ Accurate proportions
✓ Label all points
✓ Use different colors for different elements
✓ Mark equal segments/angles
✓ Draw auxiliary lines lightly
```

### 10.3 Looking for Key Observations

```
- Which points are concyclic?
- Which lines are concurrent?
- Any special configurations (9-point, Simson, etc.)?
- Any transformations that simplify?
- What happens at extreme cases?
```

## 11. Template

```latex
\textbf{Solution:}

[Optional: Set up notation and auxiliary constructions]

[Key claim/observation]
\textbf{Claim:} ...

[Proof of claim using appropriate technique]

[Complete the solution using the claim]

$\square$
```

---

*IMO Geometry for competitive mathematics.*
