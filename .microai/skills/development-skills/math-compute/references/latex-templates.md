# LaTeX Math Templates

> Templates và patterns để tạo output LaTeX chuyên nghiệp.

## SymPy to LaTeX

### Basic Conversion

```python
from sympy import *

x, y = symbols('x y')

# Expression to LaTeX
expr = x**2 + 2*x*y + y**2
print(latex(expr))
# x^{2} + 2 x y + y^{2}

# Fraction
print(latex(Rational(3, 4)))
# \frac{3}{4}

# Square root
print(latex(sqrt(x + 1)))
# \sqrt{x + 1}
```

### Calculus Expressions

```python
from sympy import *
x = Symbol('x')

# Derivative
print(latex(Derivative(sin(x), x)))
# \frac{d}{d x} \sin{\left(x \right)}

# Integral
print(latex(Integral(exp(-x**2), x)))
# \int e^{- x^{2}}\, dx

# Definite integral
print(latex(Integral(x**2, (x, 0, 1))))
# \int\limits_{0}^{1} x^{2}\, dx

# Limit
print(latex(Limit(sin(x)/x, x, 0)))
# \lim_{x \to 0} \frac{\sin{\left(x \right)}}{x}

# Sum
print(latex(Sum(1/n**2, (n, 1, oo))))
# \sum_{n=1}^{\infty} \frac{1}{n^{2}}
```

### Matrix LaTeX

```python
from sympy import *

M = Matrix([[1, 2, 3], [4, 5, 6]])
print(latex(M))
# \left[\begin{matrix}1 & 2 & 3\\4 & 5 & 6\end{matrix}\right]

# Determinant
print(latex(Determinant(M)))
# \left|{\begin{matrix}1 & 2\\3 & 4\end{matrix}}\right|
```

## Common LaTeX Patterns

### Fractions & Powers

```latex
% Phân số
\frac{a}{b}
\dfrac{a}{b}       % Display style

% Lũy thừa
x^{2}
x^{n+1}
e^{-x^{2}}

% Căn
\sqrt{x}
\sqrt[3]{x}        % Căn bậc 3
\sqrt[n]{x}        % Căn bậc n
```

### Greek Letters

```latex
% Thường dùng
\alpha \beta \gamma \delta \epsilon
\theta \lambda \mu \pi \sigma
\phi \psi \omega

% Viết hoa
\Gamma \Delta \Theta \Lambda
\Phi \Psi \Omega
```

### Operators

```latex
% Phép toán
\pm \mp \times \div \cdot
\leq \geq \neq \approx \equiv

% Tập hợp
\in \notin \subset \subseteq
\cup \cap \setminus \emptyset

% Logic
\forall \exists \neg \land \lor
\implies \iff
```

### Brackets & Delimiters

```latex
% Tự động scale
\left( ... \right)
\left[ ... \right]
\left\{ ... \right\}
\left| ... \right|

% Cases
\begin{cases}
  x & \text{if } x \geq 0 \\
  -x & \text{if } x < 0
\end{cases}
```

## Document Templates

### Problem Solution Template

```latex
\documentclass[12pt]{article}
\usepackage{amsmath, amssymb, amsthm}
\usepackage[utf8]{inputenc}
\usepackage[vietnamese]{babel}

\begin{document}

\section*{Bài toán}
Giải phương trình: $x^2 - 5x + 6 = 0$

\section*{Lời giải}

\textbf{Cách 1: Phân tích nhân tử}

\begin{align}
x^2 - 5x + 6 &= 0 \\
(x - 2)(x - 3) &= 0 \\
x = 2 \quad &\text{hoặc} \quad x = 3
\end{align}

\textbf{Cách 2: Công thức nghiệm}

\[
x = \frac{5 \pm \sqrt{25 - 24}}{2} = \frac{5 \pm 1}{2}
\]

Vậy $x_1 = 2$ và $x_2 = 3$.

\end{document}
```

### Calculus Solution Template

```latex
\section*{Bài toán}
Tính tích phân: $\displaystyle\int_0^{\pi} \sin^2 x \, dx$

\section*{Lời giải}

Sử dụng công thức: $\sin^2 x = \frac{1 - \cos 2x}{2}$

\begin{align}
\int_0^{\pi} \sin^2 x \, dx
&= \int_0^{\pi} \frac{1 - \cos 2x}{2} \, dx \\
&= \frac{1}{2} \left[ x - \frac{\sin 2x}{2} \right]_0^{\pi} \\
&= \frac{1}{2} \left( \pi - 0 \right) \\
&= \boxed{\frac{\pi}{2}}
\end{align}
```

### Matrix Solution Template

```latex
\section*{Bài toán}
Tìm ma trận nghịch đảo của $A = \begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix}$

\section*{Lời giải}

\textbf{Bước 1:} Tính định thức
\[
\det(A) = 1 \cdot 4 - 2 \cdot 3 = -2 \neq 0
\]

\textbf{Bước 2:} Tính ma trận nghịch đảo
\[
A^{-1} = \frac{1}{\det(A)} \begin{pmatrix} d & -b \\ -c & a \end{pmatrix}
= \frac{1}{-2} \begin{pmatrix} 4 & -2 \\ -3 & 1 \end{pmatrix}
= \begin{pmatrix} -2 & 1 \\ \frac{3}{2} & -\frac{1}{2} \end{pmatrix}
\]
```

## Python Generation

### Auto-generate LaTeX Solution

```python
from sympy import *

def solve_with_latex(equation, var):
    """Giải phương trình và tạo LaTeX output."""

    solutions = solve(equation, var)

    latex_output = []
    latex_output.append(f"\\textbf{{Phương trình:}} ${latex(Eq(equation, 0))}$\n")
    latex_output.append("\\textbf{Lời giải:}\n")

    # Factor if possible
    factored = factor(equation)
    if factored != equation:
        latex_output.append(f"Phân tích: ${latex(equation)} = {latex(factored)}$\n")

    latex_output.append(f"\\textbf{{Nghiệm:}} $x \\in \\{{{', '.join(map(str, solutions))}\\}}$")

    return '\n'.join(latex_output)

# Usage
x = Symbol('x')
eq = x**2 - 5*x + 6
print(solve_with_latex(eq, x))
```

### Pretty Print to Console

```python
from sympy import *
init_printing(use_unicode=True)

x = Symbol('x')

# Console pretty print
pprint(Integral(exp(-x**2), (x, -oo, oo)))
#  ∞
#  ⌠
#  ⎮    2
#  ⎮  -x
#  ⎮ ℯ    dx
#  ⌡
# -∞
```
