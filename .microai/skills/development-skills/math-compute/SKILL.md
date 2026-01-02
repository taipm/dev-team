---
name: math-compute
description: |
  When Claude needs to perform mathematical calculations, solve equations, compute
  derivatives/integrals, matrix operations, or generate LaTeX output. Triggers:
  calculate, solve, derivative, integral, matrix, equation, tính toán, giải phương trình,
  đạo hàm, tích phân, ma trận, SymPy, LaTeX math
description_vi: |
  Khi Claude cần thực hiện tính toán toán học, giải phương trình, tính đạo hàm/tích phân,
  phép toán ma trận, hoặc tạo output LaTeX. Hỗ trợ từ đại số cơ bản đến giải tích nâng cao.
license: apache-2.0
version: "1.0.0"
---

# Math Compute Skill

> Tính toán toán học chuyên nghiệp với SymPy + NumPy + LaTeX output.

## Quick Start

```python
from sympy import *

# Định nghĩa biến symbolic
x, y, z = symbols('x y z')

# Giải phương trình
solve(x**2 - 5*x + 6, x)  # [2, 3]

# Đạo hàm
diff(sin(x)*exp(x), x)  # exp(x)*sin(x) + exp(x)*cos(x)

# Tích phân
integrate(x**2, x)  # x**3/3

# Output LaTeX
latex(Integral(exp(-x**2), (x, -oo, oo)))
```

## Domains

### 1. Algebra - Đại số

```python
from sympy import *
x, y = symbols('x y')

# Giải phương trình
solve(x**2 + 2*x - 3, x)              # [-3, 1]
solve([x + y - 5, x - y - 1], [x, y]) # {x: 3, y: 2}

# Phân tích đa thức
factor(x**3 - 6*x**2 + 11*x - 6)      # (x-1)(x-2)(x-3)
expand((x + 1)**3)                     # x³ + 3x² + 3x + 1

# Đơn giản hóa
simplify((x**2 - 1)/(x - 1))          # x + 1
```

### 2. Calculus - Giải tích

```python
from sympy import *
x = Symbol('x')

# Đạo hàm
diff(x**3 + 2*x, x)           # 3x² + 2
diff(sin(x), x, 2)            # -sin(x)  (đạo hàm cấp 2)

# Tích phân
integrate(x**2, x)            # x³/3
integrate(exp(-x), (x, 0, oo)) # 1  (tích phân xác định)

# Giới hạn
limit(sin(x)/x, x, 0)         # 1
limit((1 + 1/x)**x, x, oo)    # E

# Chuỗi Taylor
series(exp(x), x, 0, 5)       # 1 + x + x²/2 + x³/6 + x⁴/24 + O(x⁵)
```

### 3. Linear Algebra - Đại số tuyến tính

```python
from sympy import Matrix, eye, zeros, ones
import numpy as np

# SymPy Matrix
A = Matrix([[1, 2], [3, 4]])
A.det()                        # -2
A.inv()                        # Matrix([[-2, 1], [3/2, -1/2]])
A.eigenvals()                  # {5/2 - sqrt(33)/2: 1, 5/2 + sqrt(33)/2: 1}

# NumPy cho tính toán số
A = np.array([[1, 2], [3, 4]])
np.linalg.det(A)              # -2.0
np.linalg.inv(A)              # array([[-2. ,  1. ], [ 1.5, -0.5]])
np.linalg.eig(A)              # eigenvalues, eigenvectors

# Ma trận đặc biệt
eye(3)                        # Identity 3x3
zeros(2, 3)                   # Zero matrix 2x3
```

### 4. Statistics - Thống kê

```python
import numpy as np
from scipy import stats

data = [23, 45, 67, 32, 89, 54, 76]

# Descriptive stats
np.mean(data)                 # 55.14
np.median(data)               # 54.0
np.std(data)                  # 21.67
np.var(data)                  # 469.55

# Probability distributions
stats.norm.pdf(0, loc=0, scale=1)      # 0.3989 (normal distribution)
stats.norm.cdf(1.96)                    # 0.975 (cumulative)
stats.binom.pmf(5, n=10, p=0.5)        # 0.246 (binomial)

# Hypothesis testing
t_stat, p_value = stats.ttest_1samp(data, 50)
```

### 5. Number Theory - Số học

```python
from sympy import *

# Số nguyên tố
isprime(17)                   # True
prime(10)                     # 29 (số nguyên tố thứ 10)
primerange(1, 50)             # [2, 3, 5, 7, 11, 13, ...]
factorint(360)                # {2: 3, 3: 2, 5: 1}

# GCD, LCM
gcd(48, 180)                  # 12
lcm(12, 18)                   # 36

# Modular arithmetic
mod_inverse(3, 7)             # 5 (vì 3*5 ≡ 1 mod 7)
pow(2, 10, 1000)              # 24 (2^10 mod 1000)
```

### 6. Geometry - Hình học

```python
from sympy import Point, Line, Circle, Triangle
from sympy import pi, sqrt, cos, sin

# Points & Lines
p1, p2 = Point(0, 0), Point(3, 4)
p1.distance(p2)               # 5

line = Line(p1, p2)
line.equation()               # 4x - 3y

# Circle
c = Circle(Point(0, 0), 5)
c.area                        # 25*pi
c.circumference               # 10*pi

# Triangle
t = Triangle(Point(0,0), Point(4,0), Point(2,3))
t.area                        # 6
t.perimeter                   # 4 + 2*sqrt(10)
```

## LaTeX Output

```python
from sympy import *
x = Symbol('x')

# Tạo LaTeX
expr = Integral(exp(-x**2), (x, -oo, oo))
print(latex(expr))
# \int\limits_{-\infty}^{\infty} e^{- x^{2}}\, dx

# Pretty print
pprint(expr, use_unicode=True)
#  ∞
#  ⌠
#  ⎮    2
#  ⎮  -x
#  ⎮ ℯ    dx
#  ⌡
# -∞

# Matrix LaTeX
M = Matrix([[1, 2], [3, 4]])
print(latex(M))
# \left[\begin{matrix}1 & 2\\3 & 4\end{matrix}\right]
```

## Common Patterns

### Solve & Verify Pattern
```python
from sympy import *
x = Symbol('x')

# Giải
eq = x**2 - 5*x + 6
solutions = solve(eq, x)  # [2, 3]

# Verify
for s in solutions:
    assert eq.subs(x, s) == 0
```

### Numerical Evaluation
```python
from sympy import *

# Symbolic
result = sqrt(2) + pi
print(result)        # sqrt(2) + pi

# Numerical
print(result.evalf())     # 4.55580...
print(result.evalf(50))   # 50 digits precision
```

### Step-by-Step Solution
```python
from sympy import *
x = Symbol('x')

# Problem: Solve x² - 5x + 6 = 0
expr = x**2 - 5*x + 6

# Step 1: Factor
factored = factor(expr)
print(f"Factor: {factored}")  # (x - 2)(x - 3)

# Step 2: Set each factor to 0
# x - 2 = 0  →  x = 2
# x - 3 = 0  →  x = 3

# Step 3: Verify
solutions = solve(expr, x)
print(f"Solutions: {solutions}")  # [2, 3]
```

## Performance Tips

```python
# Use lambdify for numerical evaluation
from sympy import lambdify, sin, cos
import numpy as np

x = Symbol('x')
f = lambdify(x, sin(x)**2 + cos(x)**2, 'numpy')
f(np.linspace(0, 2*np.pi, 100))  # Fast numerical evaluation

# Use N() for quick numerical approximation
from sympy import N, pi
N(pi, 100)  # 100 digits of pi
```

## References
- [Algebra patterns](./references/algebra.md)
- [Calculus patterns](./references/calculus.md)
- [LaTeX templates](./references/latex-templates.md)
