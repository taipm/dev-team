# Algebra Patterns Reference

> Chi tiết các patterns đại số với SymPy.

## Equations - Phương trình

### Polynomial Equations

```python
from sympy import *
x = Symbol('x')

# Phương trình bậc 2
solve(x**2 - 5*x + 6, x)                    # [2, 3]

# Phương trình bậc 3
solve(x**3 - 6*x**2 + 11*x - 6, x)         # [1, 2, 3]

# Phương trình bậc 4
solve(x**4 - 5*x**2 + 4, x)                # [-2, -1, 1, 2]

# Phương trình với tham số
a, b, c = symbols('a b c')
solve(a*x**2 + b*x + c, x)                  # [(-b±√(b²-4ac))/(2a)]
```

### Systems of Equations

```python
from sympy import *
x, y, z = symbols('x y z')

# Hệ 2 ẩn
solve([x + y - 5, x - y - 1], [x, y])
# {x: 3, y: 2}

# Hệ 3 ẩn
solve([
    x + y + z - 6,
    2*x + y - z - 1,
    x - y + 2*z - 5
], [x, y, z])
# {x: 1, y: 2, z: 3}

# Hệ phi tuyến
solve([x**2 + y**2 - 25, x - y - 1], [x, y])
```

### Inequalities - Bất phương trình

```python
from sympy import *
x = Symbol('x')

# Bất phương trình đơn giản
solve(x**2 - 4 > 0, x)           # (-∞, -2) ∪ (2, ∞)
solve(x**2 - 4 <= 0, x)          # [-2, 2]

# Bất phương trình hữu tỉ
solve((x - 1)/(x + 2) > 0, x)    # (-∞, -2) ∪ (1, ∞)

# Hệ bất phương trình
from sympy import And
solve(And(x > 1, x < 5), x)      # (1, 5)
```

## Polynomials - Đa thức

### Factorization

```python
from sympy import *
x = Symbol('x')

# Phân tích thành nhân tử
factor(x**2 - 4)                           # (x-2)(x+2)
factor(x**3 - 1)                           # (x-1)(x²+x+1)
factor(x**4 - 16)                          # (x-2)(x+2)(x²+4)

# Phân tích với tham số
a = Symbol('a')
factor(x**2 - a**2)                        # (x-a)(x+a)
```

### Expansion & Simplification

```python
from sympy import *
x, y = symbols('x y')

# Khai triển
expand((x + 1)**3)                         # x³ + 3x² + 3x + 1
expand((x + y)**4)                         # x⁴ + 4x³y + 6x²y² + 4xy³ + y⁴

# Đơn giản hóa
simplify((x**2 - 1)/(x - 1))              # x + 1
simplify(sin(x)**2 + cos(x)**2)           # 1

# Thu gọn về dạng chuẩn
collect(x**2 + 2*x + x**2 - x, x)         # 2x² + x
```

### Polynomial Division

```python
from sympy import *
x = Symbol('x')

# Chia đa thức
div(x**3 - 2*x**2 + x - 1, x - 1)
# (x² - x, -1)  →  thương và dư

# Chia hết
quo(x**3 - 1, x - 1)                       # x² + x + 1
rem(x**3 - 2*x**2 + x - 1, x - 1)         # -1
```

## Expressions - Biểu thức

### Rational Expressions

```python
from sympy import *
x = Symbol('x')

# Quy đồng
together(1/x + 1/(x+1))                    # (2x+1)/(x(x+1))

# Phân tích thành phân số đơn giản
apart((x**2 + 1)/(x**3 - x))
# 1/x + 1/(x-1) - 1/(x+1)

# Rút gọn
cancel((x**2 - 1)/(x**2 - x))             # (x+1)/x
```

### Substitution

```python
from sympy import *
x, y, a = symbols('x y a')

expr = x**2 + 2*x + 1

# Thay thế giá trị
expr.subs(x, 2)                            # 9
expr.subs(x, a + 1)                        # (a+1)² + 2(a+1) + 1

# Nhiều thay thế
(x + y).subs([(x, 1), (y, 2)])            # 3
```

## Special Patterns

### Completing the Square

```python
from sympy import *
x = Symbol('x')

expr = x**2 + 6*x + 5
# Hoàn thành bình phương: (x+3)² - 4

# Công thức tổng quát
a, b, c = symbols('a b c')
expr = a*x**2 + b*x + c
# = a(x + b/(2a))² + c - b²/(4a)
```

### Sum Formulas

```python
from sympy import *
n, k = symbols('n k', integer=True, positive=True)

# Tổng cấp số cộng
summation(k, (k, 1, n))                    # n(n+1)/2

# Tổng bình phương
summation(k**2, (k, 1, n))                 # n(n+1)(2n+1)/6

# Tổng lập phương
summation(k**3, (k, 1, n))                 # n²(n+1)²/4
```

### Binomial Theorem

```python
from sympy import *
x, y, n, k = symbols('x y n k')

# Khai triển nhị thức Newton
expand((x + y)**5)

# Hệ số nhị thức
binomial(5, 2)                             # 10
binomial(n, k)                             # n!/(k!(n-k)!)

# Công thức tổng quát
# (x+y)^n = Σ C(n,k) * x^(n-k) * y^k
```
