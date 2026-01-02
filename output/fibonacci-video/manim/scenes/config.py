"""
Fibonacci Video - Global Configuration
YouTube Team Production
"""

from manim import *

# Color Palette (3B1B Inspired)
FIBONACCI_BLUE = "#1C758A"
GOLDEN_YELLOW = "#FFD700"
NATURE_GREEN = "#83C167"
SPIRAL_PURPLE = "#9A72AC"
WARM_ORANGE = "#FF8C00"
SOFT_RED = "#FC6255"
CREAM_WHITE = "#FFFACD"
DARK_BG = "#1C1C1C"

# Typography
MATH_FONT = "Computer Modern"
VN_FONT = "Be Vietnam Pro"
TITLE_SIZE = 64
BODY_SIZE = 42
LABEL_SIZE = 32
SMALL_SIZE = 24

# Animation Timing
FAST_RUN = 0.3
STANDARD_RUN = 1.0
SLOW_RUN = 2.0
VERY_SLOW_RUN = 3.0

# Fibonacci sequence helper
def fibonacci(n):
    """Generate first n Fibonacci numbers"""
    fib = [1, 1]
    for i in range(2, n):
        fib.append(fib[-1] + fib[-2])
    return fib

# Golden ratio
PHI = (1 + 5**0.5) / 2  # 1.618033988749895
PSI = (1 - 5**0.5) / 2  # -0.618033988749895
