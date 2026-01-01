# Optimization Techniques

## Constant Factor Optimizations

### Loop Optimizations

#### Avoid Function Calls in Loops
```python
# Slow
for i in range(len(arr)):
    process(arr[i])

# Fast - cache length
n = len(arr)
for i in range(n):
    process(arr[i])
```

#### Loop Unrolling
```python
# Normal loop
for i in range(0, n):
    sum += arr[i]

# Unrolled (2x)
for i in range(0, n, 2):
    sum += arr[i] + arr[i+1]
```

#### Early Termination
```python
# Check all
def contains(arr, target):
    found = False
    for x in arr:
        if x == target:
            found = True
    return found

# Early exit
def contains_fast(arr, target):
    for x in arr:
        if x == target:
            return True
    return False
```

### Data Structure Choices

| Need | Best Choice | Avoid |
|------|-------------|-------|
| Fast lookup | set, dict | list |
| Ordered iteration | list | set |
| FIFO queue | deque | list.pop(0) |
| Min/max | heapq | sorted() |
| String building | list + join | s += char |

### String Optimizations

```python
# Slow - O(n²) due to string immutability
result = ""
for char in chars:
    result += char

# Fast - O(n)
result = "".join(chars)

# Or use list
parts = []
for char in chars:
    parts.append(char)
result = "".join(parts)
```

## Bit Manipulation

### Common Operations

```python
# Check if nth bit is set
(x >> n) & 1

# Set nth bit
x | (1 << n)

# Clear nth bit
x & ~(1 << n)

# Toggle nth bit
x ^ (1 << n)

# Check if power of 2
x & (x - 1) == 0

# Get lowest set bit
x & (-x)

# Clear lowest set bit
x & (x - 1)

# Count set bits
bin(x).count('1')  # Simple
# Or: x.bit_count() in Python 3.10+
```

### Bit Tricks

```python
# Swap without temp
a ^= b
b ^= a
a ^= b

# Check if even/odd (faster than % 2)
is_even = (x & 1) == 0

# Multiply/divide by 2
x << 1  # x * 2
x >> 1  # x // 2

# Modulo power of 2
x & (n - 1)  # x % n where n is power of 2
```

## Memory Optimizations

### Space-Time Trade-offs

| Trade-off | Example |
|-----------|---------|
| Cache results | Memoization, LRU cache |
| Precompute | Prefix sums, lookup tables |
| Compress state | Bitmask DP |
| Rolling array | 2D DP → 1D |

### DP Space Optimization

```python
# 2D DP - O(n²) space
dp = [[0] * n for _ in range(n)]
for i in range(1, n):
    for j in range(n):
        dp[i][j] = f(dp[i-1][j], dp[i-1][j-1])

# Rolling array - O(n) space
prev = [0] * n
curr = [0] * n
for i in range(1, n):
    for j in range(n):
        curr[j] = f(prev[j], prev[j-1])
    prev, curr = curr, prev
```

### Generator for Large Data

```python
# Memory hungry
def get_squares(n):
    return [i**2 for i in range(n)]

# Memory efficient
def get_squares_gen(n):
    for i in range(n):
        yield i**2
```

## I/O Optimizations

### Fast Input (Python)

```python
import sys
input = sys.stdin.readline

# Read single integer
n = int(input())

# Read line of integers
arr = list(map(int, input().split()))

# Read multiple lines
for _ in range(n):
    line = input()
```

### Fast Output (Python)

```python
import sys

# Slow - many print calls
for x in arr:
    print(x)

# Fast - single print
print('\n'.join(map(str, arr)))

# Or use sys.stdout
sys.stdout.write('\n'.join(map(str, arr)))
```

### C++ I/O Optimization

```cpp
ios_base::sync_with_stdio(false);
cin.tie(NULL);
```

## Algorithm-Level Optimizations

### Avoid Repeated Work

```python
# Slow - recomputes in each iteration
for i in range(n):
    for j in range(n):
        val = expensive_function(i)  # Same for all j!
        result += val * arr[j]

# Fast - compute once
for i in range(n):
    val = expensive_function(i)
    for j in range(n):
        result += val * arr[j]
```

### Precomputation

```python
# Prefix sum for range queries
prefix = [0] * (n + 1)
for i in range(n):
    prefix[i + 1] = prefix[i] + arr[i]

# Range sum [l, r] in O(1)
range_sum = prefix[r + 1] - prefix[l]
```

### Early Pruning

```python
# Backtracking with pruning
def solve(state):
    if not is_valid(state):
        return  # Prune invalid branches early
    if is_solution(state):
        process_solution(state)
        return
    for choice in choices:
        make_choice(state, choice)
        solve(state)
        undo_choice(state, choice)
```

## Cache Locality

### Row-Major Access (Good)

```python
# Good - sequential memory access
for i in range(n):
    for j in range(m):
        process(matrix[i][j])
```

### Column-Major Access (Bad)

```python
# Bad - jumping around in memory
for j in range(m):
    for i in range(n):
        process(matrix[i][j])
```

## Common TLE Fixes

| Issue | Fix |
|-------|-----|
| O(n²) when O(n log n) possible | Use sorting, binary search |
| Repeated string concat | Use list + join |
| list.pop(0) in loop | Use collections.deque |
| Nested loops | Hash map lookup |
| Repeated function calls | Memoization |
| Many small I/O operations | Batch I/O |
| Python too slow | PyPy or rewrite hot path |

## Quick Reference

```
┌─────────────────────────────────────────────────────────────────┐
│              OPTIMIZATION CHECKLIST                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✓ Algorithm correct before optimizing                         │
│  ✓ Profile to find bottleneck                                  │
│  ✓ Check data structure choices                                │
│  ✓ Avoid work in inner loops                                   │
│  ✓ Consider precomputation                                     │
│  ✓ Use early termination                                       │
│  ✓ Batch I/O operations                                        │
│  ✓ Consider bit manipulation                                   │
│  ✓ Check memory access patterns                                │
│                                                                 │
│  "Premature optimization is the root of all evil"              │
│   - But knowing these patterns helps write good code           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```
