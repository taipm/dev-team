# Complexity Analysis

## Big-O Notation

| Notation | Name | Example |
|----------|------|---------|
| O(1) | Constant | Hash lookup, array access |
| O(log n) | Logarithmic | Binary search |
| O(n) | Linear | Single loop |
| O(n log n) | Linearithmic | Merge sort, heap sort |
| O(n²) | Quadratic | Nested loops |
| O(n³) | Cubic | 3 nested loops, Floyd-Warshall |
| O(2ⁿ) | Exponential | Subsets, backtracking |
| O(n!) | Factorial | Permutations |

## Constraint-Based Estimation

| n limit | Acceptable Complexity | Operations |
|---------|----------------------|------------|
| n ≤ 10 | O(n!), O(n⁶) | ~3.6M, 1M |
| n ≤ 20 | O(2ⁿ), O(n⁵) | ~1M, 3.2M |
| n ≤ 100 | O(n⁴) | 100M |
| n ≤ 400 | O(n³) | 64M |
| n ≤ 2000 | O(n² log n) | 44M |
| n ≤ 10⁴ | O(n²) | 100M |
| n ≤ 10⁵ | O(n log n), O(n√n) | 1.7M, 31.6M |
| n ≤ 10⁶ | O(n) | 1M |
| n ≤ 10⁸ | O(n), O(log n) | 100M, 27 |
| n ≤ 10⁹ | O(log n), O(1) | 30, 1 |

**Rule of thumb**: ~10⁸ operations per second

## Common Complexity Patterns

### Loops
```python
# O(n)
for i in range(n):
    # O(1) work

# O(n²)
for i in range(n):
    for j in range(n):
        # O(1) work

# O(n log n) - halving inner
for i in range(n):
    j = n
    while j > 0:
        j //= 2
        # O(1) work
```

### Recursion
```python
# O(2^n) - branching factor 2
def fib(n):
    if n <= 1: return n
    return fib(n-1) + fib(n-2)

# O(n) - linear recursion with memoization
@cache
def fib_memo(n):
    if n <= 1: return n
    return fib_memo(n-1) + fib_memo(n-2)

# O(log n) - halving each call
def binary_exp(x, n):
    if n == 0: return 1
    if n % 2 == 0:
        return binary_exp(x * x, n // 2)
    return x * binary_exp(x, n - 1)
```

### Master Theorem

For T(n) = aT(n/b) + O(n^d):

| Condition | Complexity |
|-----------|------------|
| d > log_b(a) | O(n^d) |
| d = log_b(a) | O(n^d log n) |
| d < log_b(a) | O(n^(log_b(a))) |

**Examples**:
- Merge sort: T(n) = 2T(n/2) + O(n) → O(n log n)
- Binary search: T(n) = T(n/2) + O(1) → O(log n)
- Karatsuba: T(n) = 3T(n/2) + O(n) → O(n^1.58)

## Amortized Analysis

### Dynamic Array (ArrayList)
- Single push: O(n) worst case (resize)
- n pushes: O(n) total
- **Amortized**: O(1) per push

### Union-Find with Path Compression
- Single operation: O(log n) worst case
- m operations: O(m α(n)) ≈ O(m)
- **Amortized**: O(α(n)) ≈ O(1) per operation

## Space Complexity

| Structure | Space |
|-----------|-------|
| Variables | O(1) |
| Array of n | O(n) |
| 2D array n×m | O(nm) |
| Recursion depth d | O(d) stack |
| Hash map n keys | O(n) |
| Graph n nodes, m edges | O(n + m) |

### Common Trade-offs

| Time | Space | Technique |
|------|-------|-----------|
| O(n) → O(1) | O(1) → O(n) | Hash map |
| O(n²) → O(n log n) | O(1) → O(n) | Sorting |
| O(2ⁿ) → O(n²) | O(1) → O(n²) | DP memoization |

## Complexity Analysis Steps

### Step 1: Identify Operations
- Loop iterations
- Recursive calls
- Data structure operations

### Step 2: Count Operations
```python
def example(n):
    result = 0        # O(1)
    for i in range(n):      # n iterations
        for j in range(i):  # 0 + 1 + ... + (n-1) = n(n-1)/2
            result += 1     # O(1)
    return result
```

**Total**: 1 + n(n-1)/2 = O(n²)

### Step 3: Consider Data Structures

| Operation | Array | Linked List | Hash Set | BST |
|-----------|-------|-------------|----------|-----|
| Access [i] | O(1) | O(n) | - | - |
| Search | O(n) | O(n) | O(1) | O(log n) |
| Insert | O(n) | O(1) | O(1) | O(log n) |
| Delete | O(n) | O(1) | O(1) | O(log n) |

### Step 4: Worst vs Average

| Algorithm | Average | Worst |
|-----------|---------|-------|
| Quick sort | O(n log n) | O(n²) |
| Hash table | O(1) | O(n) |
| Quick select | O(n) | O(n²) |

## Red Flags in Code

### O(n²) Hidden
```python
# String concatenation in loop - O(n²)
s = ""
for i in range(n):
    s += char  # Creates new string each time!

# Fix: Use list join - O(n)
chars = []
for i in range(n):
    chars.append(char)
s = "".join(chars)
```

### Expensive Operations in Loop
```python
# O(n²) - len() is O(1), but list.pop(0) is O(n)
while arr:
    arr.pop(0)  # O(n) each time!

# Fix: Use deque - O(n)
from collections import deque
arr = deque(arr)
while arr:
    arr.popleft()  # O(1)
```

### Unnecessary Sorting
```python
# O(n log n) - just to find min/max
sorted_arr = sorted(arr)
minimum = sorted_arr[0]

# Fix: O(n)
minimum = min(arr)
```

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────┐
│                 COMPLEXITY QUICK REFERENCE                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  n ≤ 20    →  Brute force OK (2^n, n!)                          │
│  n ≤ 10³   →  O(n²) OK                                          │
│  n ≤ 10⁵   →  O(n log n) needed                                 │
│  n ≤ 10⁶   →  O(n) needed                                       │
│  n ≤ 10⁹   →  O(log n) or O(1) needed                           │
│                                                                  │
│  ~10⁸ operations = 1 second                                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```
