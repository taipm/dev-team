# Computational Geometry for TikZ

## Root Cause Analysis: Tại sao hình vẽ bị sai?

### Vấn đề gốc rễ
Khi vẽ hình hình học bằng TikZ, lỗi phổ biến nhất là **hardcode tọa độ** thay vì **tính toán từ ràng buộc hình học**.

### Ví dụ lỗi điển hình
```latex
% SAI - Hardcode tọa độ K
\coordinate (K) at (1, -2.25);  % Không đảm bảo K nằm trên đường tròn!

% ĐÚNG - Tính K từ phương trình
% Line x = 1 intersects circle (x-0.7)² + (y-0.87)² = R²
% → K at (1, 0.87 - sqrt(R² - 0.09))
```

## Nguyên tắc Computational Geometry

### 1. ALWAYS Calculate, Never Guess

| Điểm | Phương pháp tính | TikZ Code |
|------|------------------|-----------|
| Chân đường cao D | Projection A onto BC | `($(B)!(A)!(C)$)` |
| Trung điểm I | Midpoint formula | `($(B)!0.5!(C)$)` |
| Tâm đường tròn O | Giao perpendicular bisectors | Tính tay hoặc `through` |
| Giao điểm K | Line-circle intersection | Giải phương trình |

### 2. Projection Formula (TikZ)

```latex
% D = projection of A onto line BC
\coordinate (D) at ($(B)!(A)!(C)$);

% Giải thích: ($(B)!(A)!(C)$) = điểm trên đường BC gần A nhất
```

### 3. Midpoint Formula

```latex
% I = midpoint of BC
\coordinate (I) at ($(B)!0.5!(C)$);

% General: point at ratio t from B to C
\coordinate (P) at ($(B)!t!(C)$);  % t ∈ [0,1]
```

### 4. Circumcenter Calculation

Cho tam giác ABC với:
- B = (x_B, y_B)
- C = (x_C, y_C)
- A = (x_A, y_A)

**Bước 1**: Trung điểm các cạnh
```latex
\coordinate (M_BC) at ($(B)!0.5!(C)$);
```

**Bước 2**: Đường trung trực
- Trung trực BC đi qua M_BC và vuông góc với BC
- Nếu BC nằm ngang (cùng y): trung trực là đường thẳng đứng x = (x_B + x_C)/2

**Bước 3**: Tính O
```
|OA|² = |OB|²
(x_O - x_A)² + (y_O - y_A)² = (x_O - x_B)² + (y_O - y_B)²
```

### 5. Line-Circle Intersection

Cho đường thẳng L và đường tròn (O, R):

**Trường hợp đặc biệt**: Đường thẳng đứng x = a
```
Circle: (x - x_O)² + (y - y_O)² = R²
Substitute x = a:
(a - x_O)² + (y - y_O)² = R²
(y - y_O)² = R² - (a - x_O)²

y = y_O ± sqrt(R² - (a - x_O)²)
```

**TikZ Implementation**:
```latex
\pgfmathsetmacro{\yK}{0.87 - sqrt(\R*\R - 0.09)}
\coordinate (K) at (1, \yK);
```

### 6. Nine-Point Circle

```latex
% Center N = midpoint of OH
\coordinate (N) at ($(O)!0.5!(H)$);

% Radius = R/2
\pgfmathsetmacro{\nR}{\R/2}

% Draw
\draw[dashed] (N) circle[radius=\nR];
```

### 7. Orthocenter by Intersection

```latex
% Method 1: Using pgf intersections (complex)
\path[name path=alt_AD] (A) -- (D);
\path[name path=alt_BE] (B) -- (E);
\path[name intersections={of=alt_AD and alt_BE, by=H}];

% Method 2: Calculate manually (more reliable)
% H lies on altitude AD (line from A perpendicular to BC)
% If BC is horizontal, altitude AD is vertical through A
```

## Verification Checklist

Trước khi hoàn thành hình vẽ, kiểm tra:

- [ ] **Circumcircle**: |OA| = |OB| = |OC| = R
- [ ] **K on circle**: |OK| = R
- [ ] **D on BC**: D nằm giữa B và C (hoặc trên đường BC mở rộng)
- [ ] **Right angles**: AD ⊥ BC, BE ⊥ AC, CF ⊥ AB
- [ ] **Nine-point circle**: Đi qua D, E, F, I, và trung điểm AH, BH, CH

## Template Code: Complete Triangle with Orthocenter

```latex
\begin{tikzpicture}[scale=1.5]
    % === STEP 1: Define triangle ===
    \coordinate (A) at (1, 3.5);
    \coordinate (B) at (-1.8, 0);
    \coordinate (C) at (3.2, 0);

    % === STEP 2: Calculate circumcenter ===
    % (Manual calculation for this specific triangle)
    \coordinate (O) at (0.7, 0.87);
    \def\R{2.65}

    % === STEP 3: Altitude feet using PROJECTION ===
    \coordinate (D) at ($(B)!(A)!(C)$);
    \coordinate (E) at ($(A)!(B)!(C)$);
    \coordinate (F) at ($(A)!(C)!(B)$);

    % === STEP 4: Orthocenter ===
    % (Calculated: intersection of AD and BE)
    \coordinate (H) at (1, 1.07);

    % === STEP 5: Midpoint I ===
    \coordinate (I) at ($(B)!0.5!(C)$);

    % === STEP 6: Point K on circumcircle ===
    % Line AD is x = 1, solve for intersection with circle
    \pgfmathsetmacro{\yK}{0.87 - sqrt(\R*\R - 0.09)}
    \coordinate (K) at (1, \yK);

    % === STEP 7: Nine-point circle ===
    \coordinate (N) at ($(O)!0.5!(H)$);
    \pgfmathsetmacro{\nR}{\R/2}

    % === DRAWING ===
    \draw[blue, thick] (O) circle[radius=\R];           % Circumcircle
    \draw[purple, dashed] (N) circle[radius=\nR];       % Nine-point circle
    \draw[red, very thick] (A) -- (B) -- (C) -- cycle;  % Triangle
    \draw[cyan] (A) -- (D) (B) -- (E) (C) -- (F);       % Altitudes
    \draw[cyan, dashed] (D) -- (K);                      % Extension to K
    \draw[green!50!black] (D) -- (E) -- (F) -- cycle;   % Orthic triangle

    % === POINTS ===
    \foreach \p/\pos in {A/above, B/below left, C/below right,
                         D/below, E/right, F/left,
                         H/above right, I/below, K/below} {
        \fill (\p) circle[radius=2pt];
        \node[\pos] at (\p) {$\p$};
    }
\end{tikzpicture}
```

## Common Errors and Fixes

### Error 1: K not on circumcircle
**Cause**: Hardcoded y-coordinate
**Fix**: Calculate using line-circle intersection formula

### Error 2: D, E, F not at right angles
**Cause**: Used midpoint instead of projection
**Fix**: Use `($(B)!(A)!(C)$)` syntax

### Error 3: Nine-point circle wrong size
**Cause**: Used wrong radius
**Fix**: Radius = R/2, Center = midpoint of OH

### Error 4: Orthocenter outside triangle (obtuse case)
**Note**: This is correct! For obtuse triangles, H is outside.

---

*Knowledge file for Geometry Illustrator Agent - Math Team*
*Last updated: 2026-01-02*
