# IMO Combinatorics Techniques

> Kỹ thuật Tổ hợp nâng cao cho Olympic Toán Quốc tế

## 1. Counting Principles

### 1.1 Basic Counting

```
Addition Principle:
|A ∪ B| = |A| + |B| khi A ∩ B = ∅

Multiplication Principle:
Số cách làm task1 AND task2 = (cách làm task1) × (cách làm task2)

Permutations:
P(n,k) = n!/(n-k)! = số cách chọn k từ n, có thứ tự

Combinations:
C(n,k) = n!/(k!(n-k)!) = số cách chọn k từ n, không thứ tự
```

### 1.2 Inclusion-Exclusion

```
|A₁ ∪ A₂ ∪ ... ∪ Aₙ| =
  ∑|Aᵢ| - ∑|Aᵢ ∩ Aⱼ| + ∑|Aᵢ ∩ Aⱼ ∩ Aₖ| - ... + (-1)^(n+1)|A₁ ∩ ... ∩ Aₙ|

Common applications:
- Derangements: D(n) = n! × ∑(-1)^k/k!
- Euler's totient function
- Counting with restrictions
```

### 1.3 Stars and Bars

```
Số nghiệm nguyên không âm của x₁ + x₂ + ... + xₖ = n:
C(n+k-1, k-1)

Số nghiệm nguyên dương:
C(n-1, k-1)
```

### 1.4 Bijection Counting

```
|A| = |B| nếu tồn tại bijection f: A → B

Strategy:
1. Bài toán đếm A khó
2. Tìm bijection đến B dễ đếm hơn
3. Đếm B
```

## 2. Advanced Counting

### 2.1 Double Counting

```
Đếm pairs (a, b) ∈ A × B thỏa mãn relation R theo 2 cách:
∑_{a ∈ A} |{b : (a,b) ∈ R}| = ∑_{b ∈ B} |{a : (a,b) ∈ R}|
```

**Example: Handshaking Lemma**
```
∑ deg(v) = 2|E|
```

### 2.2 Generating Functions

```
Ordinary GF:
G(x) = ∑ aₙxⁿ

Operations:
- Addition: aₙ + bₙ ↔ A(x) + B(x)
- Shifting: aₙ₋₁ ↔ xA(x)
- Convolution: ∑aₖbₙ₋ₖ ↔ A(x)B(x)

Common GFs:
- 1/(1-x) = 1 + x + x² + ... (aₙ = 1)
- 1/(1-x)² = 1 + 2x + 3x² + ... (aₙ = n+1)
- (1+x)ⁿ = ∑ C(n,k)xᵏ
```

### 2.3 Exponential Generating Functions

```
EGF: Ĝ(x) = ∑ aₙ/n! × xⁿ

Good for labeled structures.

Convolution of EGFs counts labeled union.
```

### 2.4 Catalan Numbers

```
Cₙ = C(2n,n)/(n+1) = (2n)!/((n+1)!n!)

Counts:
- Số cách đặt ngoặc
- Số cây nhị phân với n+1 lá
- Số đường đi không vượt đường chéo
- Số cách triangulate n+2-gon

Recurrence: Cₙ = ∑ Cₖ Cₙ₋₁₋ₖ
```

### 2.5 Burnside's Lemma

```
Số orbits của group G acting on set X:
|X/G| = (1/|G|) × ∑_{g ∈ G} |X^g|

với X^g = {x ∈ X : g·x = x}
```

## 3. Pigeonhole Principle

### 3.1 Basic Pigeonhole

```
n+1 objects into n boxes → ∃ box with ≥ 2 objects
```

### 3.2 Generalized Pigeonhole

```
kn+1 objects into n boxes → ∃ box with ≥ k+1 objects

More generally:
N objects into n boxes → ∃ box with ≥ ⌈N/n⌉ objects
```

### 3.3 Infinite Pigeonhole

```
Infinitely many objects into finitely many boxes
→ ∃ box with infinitely many objects
```

### 3.4 Applications

```
- Modular arithmetic: n+1 numbers → 2 with same remainder mod n
- Geometry: n+1 points in unit square → 2 within distance √2/n
- Sequences: Length n²+1 sequence → monotonic subsequence length n+1
- Dirichlet's approximation theorem
```

## 4. Extremal Combinatorics

### 4.1 Extremal Principle

```
Xét phần tử MAX hoặc MIN của tập hợp.
Phần tử cực trị thường có tính chất đặc biệt.
```

### 4.2 Turán's Theorem

```
Max edges in n-vertex graph without K_{r+1}:
ex(n, K_{r+1}) = (1 - 1/r) × n²/2 × (1 + o(1))

Extremal graph: Complete r-partite với parts balanced.
```

### 4.3 Sperner's Theorem

```
Max antichain in power set of [n]:
C(n, ⌊n/2⌋)

Antichain = no set contains another.
```

### 4.4 Dilworth's Theorem

```
Minimum chains covering poset = Maximum antichain size
```

## 5. Graph Theory

### 5.1 Basic Concepts

```
Graph G = (V, E)
- deg(v) = number of edges incident to v
- ∑ deg(v) = 2|E| (handshaking)
- Complete graph Kₙ has n(n-1)/2 edges
- Bipartite ⟺ no odd cycle ⟺ 2-colorable
```

### 5.2 Connectivity

```
- Connected: path between any two vertices
- k-connected: still connected after removing any k-1 vertices
- Bridge: edge whose removal disconnects
- Cut vertex: vertex whose removal disconnects
```

### 5.3 Trees

```
Tree with n vertices:
- Has n-1 edges
- Connected and acyclic
- Unique path between any two vertices
- Adding any edge creates exactly one cycle

Cayley's formula: n^(n-2) labeled trees on n vertices
```

### 5.4 Eulerian and Hamiltonian

```
Eulerian path/cycle: visits every EDGE exactly once
- Exists ⟺ at most 2 odd-degree vertices (path)
- Exists ⟺ all vertices even degree (cycle)

Hamiltonian path/cycle: visits every VERTEX exactly once
- No simple characterization (NP-complete)
- Ore's theorem, Dirac's theorem for sufficient conditions
```

### 5.5 Coloring

```
χ(G) = chromatic number = min colors to color vertices, adjacent vertices different colors

- Bipartite: χ = 2
- Tree: χ = 2 (if not trivial)
- Kₙ: χ = n
- Planar: χ ≤ 4 (Four Color Theorem)
- χ ≤ Δ + 1 (greedy, Δ = max degree)
- Brooks: χ ≤ Δ unless complete or odd cycle
```

### 5.6 Planar Graphs

```
Euler's formula: V - E + F = 2

For planar graph:
- E ≤ 3V - 6 (if V ≥ 3)
- E ≤ 2V - 4 (if bipartite, V ≥ 3)

K₅ and K₃,₃ are not planar.
Kuratowski: G planar ⟺ no K₅ or K₃,₃ subdivision
```

### 5.7 Hall's Marriage Theorem

```
Bipartite graph G = (X ∪ Y, E).
Perfect matching X → Y exists ⟺ |N(S)| ≥ |S| for all S ⊆ X
```

## 6. Ramsey Theory

### 6.1 Ramsey Numbers

```
R(m,n) = min N such that:
Any 2-coloring of edges of K_N contains
- red K_m, or
- blue K_n

R(3,3) = 6
R(4,4) = 18
R(5,5) ∈ [43, 48]
```

### 6.2 Basic Ramsey Results

```
R(m,n) exists and R(m,n) ≤ C(m+n-2, m-1)

R(m,n) = R(n,m)
R(m,2) = m
R(3,3) = 6
```

### 6.3 Applications

```
"In any party of 6, there are 3 mutual friends or 3 mutual strangers."

Ramsey-type arguments often used for:
- Unavoidable patterns
- Large homogeneous subsets
- Infinite Ramsey for infinite structures
```

## 7. Game Theory (Combinatorial Games)

### 7.1 Nim

```
Positions: (a₁, a₂, ..., aₖ) piles of stones
Move: remove any positive number from one pile
Win: take last stone (normal play)

Sprague-Grundy: P-position ⟺ a₁ ⊕ a₂ ⊕ ... ⊕ aₖ = 0
```

### 7.2 Sprague-Grundy Theorem

```
Every impartial game position has a Grundy value g.
g = mex{g(positions reachable in one move)}
(mex = minimum excludant = smallest non-negative integer not in set)

Game sum: g(G₁ + G₂) = g(G₁) ⊕ g(G₂)
P-position: g = 0
N-position: g ≠ 0
```

### 7.3 Strategy Stealing

```
If second player has winning strategy, first player can "steal" it.
Often used to prove first player wins (non-constructive).
```

### 7.4 Symmetry Strategy

```
Match opponent's moves symmetrically.
Works when game has symmetry and symmetric play is valid.
```

## 8. Invariants and Monovariants

### 8.1 Invariants

```
Quantity that doesn't change through allowed operations.

Common:
- Parity (odd/even count)
- Sum/product
- Modular residue
- Coloring value
```

### 8.2 Monovariants

```
Quantity that only increases or only decreases.

If bounded → process terminates.
Use to count maximum steps or prove termination.
```

## 9. Competition Strategies

### 9.1 Small Cases

```
ALWAYS check n = 1, 2, 3, 4, 5 first.
Look for pattern or conjecture.
```

### 9.2 Reformulation

```
Restate problem in different terms:
- Graph coloring ↔ partition
- Subset ↔ binary string
- Permutation ↔ bijection
```

### 9.3 Working Backwards

```
Start from what you want to prove.
What would imply it? And what would imply that?
```

### 9.4 Greedy + Verification

```
1. Propose greedy algorithm
2. Prove it works (or find counterexample)
3. Analyze result
```

## 10. Template

```latex
\textbf{Solution:}

[Optional: Reformulate problem]

[Key observation/claim]

[Proof - using appropriate technique]

[Conclusion]

$\square$
```

---

*IMO Combinatorics for competitive mathematics.*
