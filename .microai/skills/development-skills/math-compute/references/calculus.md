# Calculus Patterns Reference

> Chi tiết các patterns giải tích với SymPy.

## Derivatives - Đạo hàm

### Basic Derivatives

```python
from sympy import *
x = Symbol('x')

# Đạo hàm cơ bản
diff(x**n, x)                    # n*x^(n-1)
diff(sin(x), x)                  # cos(x)
diff(cos(x), x)                  # -sin(x)
diff(exp(x), x)                  # exp(x)
diff(ln(x), x)                   # 1/x
diff(tan(x), x)                  # 1/cos²(x) = sec²(x)
```

### Chain Rule - Quy tắc dây chuyền

```python
from sympy import *
x = Symbol('x')

# f(g(x))' = f'(g(x)) * g'(x)
diff(sin(x**2), x)               # 2x*cos(x²)
diff(exp(sin(x)), x)             # cos(x)*exp(sin(x))
diff(ln(cos(x)), x)              # -tan(x)
```

### Higher Order Derivatives

```python
from sympy import *
x = Symbol('x')

# Đạo hàm cấp cao
diff(sin(x), x, 2)               # -sin(x)
diff(sin(x), x, 3)               # -cos(x)
diff(sin(x), x, 4)               # sin(x)

# Đạo hàm tổng quát cấp n
n = Symbol('n', integer=True)
diff(x**5, x, n)                 # Symbolic nth derivative
```

### Partial Derivatives - Đạo hàm riêng

```python
from sympy import *
x, y, z = symbols('x y z')

f = x**2*y + y**3*z

# Đạo hàm riêng
diff(f, x)                       # 2xy
diff(f, y)                       # x² + 3y²z
diff(f, z)                       # y³

# Đạo hàm riêng cấp 2
diff(f, x, y)                    # 2x
diff(f, y, 2)                    # 6yz
```

### Implicit Differentiation

```python
from sympy import *
x, y = symbols('x y')

# Cho phương trình x² + y² = 25
# Tìm dy/dx
eq = x**2 + y**2 - 25
dy_dx = -diff(eq, x) / diff(eq, y)
# dy/dx = -x/y
```

## Integrals - Tích phân

### Indefinite Integrals

```python
from sympy import *
x = Symbol('x')

# Tích phân cơ bản
integrate(x**n, x)               # x^(n+1)/(n+1)
integrate(sin(x), x)             # -cos(x)
integrate(cos(x), x)             # sin(x)
integrate(exp(x), x)             # exp(x)
integrate(1/x, x)                # ln|x|
```

### Definite Integrals

```python
from sympy import *
x = Symbol('x')

# Tích phân xác định
integrate(x**2, (x, 0, 1))       # 1/3
integrate(sin(x), (x, 0, pi))    # 2
integrate(exp(-x), (x, 0, oo))   # 1

# Tích phân suy rộng
integrate(exp(-x**2), (x, -oo, oo))  # √π
```

### Integration Techniques

```python
from sympy import *
x = Symbol('x')

# Đổi biến (SymPy tự động)
integrate(x*exp(x**2), x)        # exp(x²)/2

# Từng phần
integrate(x*exp(x), x)           # (x-1)*exp(x)
integrate(x*sin(x), x)           # -x*cos(x) + sin(x)

# Phân số hữu tỉ
integrate(1/(x**2 - 1), x)       # ln|x-1|/2 - ln|x+1|/2

# Lượng giác
integrate(sin(x)**2, x)          # x/2 - sin(2x)/4
```

### Multiple Integrals

```python
from sympy import *
x, y = symbols('x y')

# Tích phân kép
integrate(x*y, (x, 0, 1), (y, 0, 2))  # 1

# Tích phân bội với vùng phức tạp
integrate(x + y, (y, 0, x), (x, 0, 1))
```

## Limits - Giới hạn

### Basic Limits

```python
from sympy import *
x = Symbol('x')

limit(sin(x)/x, x, 0)                    # 1
limit((1 + 1/x)**x, x, oo)               # e
limit((exp(x) - 1)/x, x, 0)              # 1
limit(x*ln(x), x, 0, '+')                # 0
```

### One-sided Limits

```python
from sympy import *
x = Symbol('x')

# Giới hạn một phía
limit(1/x, x, 0, '+')                    # +∞
limit(1/x, x, 0, '-')                    # -∞

# Hàm dấu
limit(abs(x)/x, x, 0, '+')               # 1
limit(abs(x)/x, x, 0, '-')               # -1
```

### L'Hôpital's Rule

```python
from sympy import *
x = Symbol('x')

# SymPy tự động áp dụng L'Hôpital
limit(sin(x)/x, x, 0)                    # 1 (dạng 0/0)
limit((exp(x) - 1 - x)/x**2, x, 0)       # 1/2
limit(x*ln(x), x, 0, '+')                # 0 (dạng 0*∞)
```

## Series - Chuỗi

### Taylor Series

```python
from sympy import *
x = Symbol('x')

# Khai triển Taylor tại x=0
series(exp(x), x, 0, 5)      # 1 + x + x²/2 + x³/6 + x⁴/24 + O(x⁵)
series(sin(x), x, 0, 7)      # x - x³/6 + x⁵/120 + O(x⁷)
series(cos(x), x, 0, 6)      # 1 - x²/2 + x⁴/24 + O(x⁶)
series(ln(1+x), x, 0, 5)     # x - x²/2 + x³/3 - x⁴/4 + O(x⁵)

# Taylor tại điểm khác
series(exp(x), x, 1, 3)      # e + e(x-1) + e(x-1)²/2 + O((x-1)³)
```

### Summation

```python
from sympy import *
n, k = symbols('n k', integer=True)

# Tính tổng
summation(1/k**2, (k, 1, oo))            # π²/6
summation(1/factorial(k), (k, 0, oo))    # e
summation((-1)**k/(2*k+1), (k, 0, oo))   # π/4
```

## Differential Equations - Phương trình vi phân

### ODEs

```python
from sympy import *

x = Symbol('x')
y = Function('y')

# y' = y
dsolve(Derivative(y(x), x) - y(x), y(x))
# y(x) = C₁*exp(x)

# y'' + y = 0
dsolve(Derivative(y(x), x, 2) + y(x), y(x))
# y(x) = C₁*sin(x) + C₂*cos(x)

# y' + 2y = x
dsolve(Derivative(y(x), x) + 2*y(x) - x, y(x))
```

### Initial Value Problems

```python
from sympy import *

x = Symbol('x')
y = Function('y')

# y' = y, y(0) = 1
eq = Derivative(y(x), x) - y(x)
ics = {y(0): 1}
dsolve(eq, y(x), ics=ics)
# y(x) = exp(x)
```
