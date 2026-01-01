# Dynamic Programming Patterns

## Overview

Dynamic Programming (DP) solves problems by breaking them into overlapping subproblems and storing results to avoid recomputation.

**Key Signs**: Optimal substructure + Overlapping subproblems

## Pattern Classification

| Pattern | Complexity | Use When |
|---------|------------|----------|
| 1D DP | O(n) | Linear sequence, single state |
| 2D DP | O(n²) or O(nm) | Two sequences, grid problems |
| Bitmask DP | O(2^n × n) | Small n (≤20), subset selection |
| Digit DP | O(digits × states) | Count numbers with properties |
| Tree DP | O(n) | Tree structure problems |
| Interval DP | O(n³) | Optimal merging, matrix chain |

## 1D DP Patterns

### Fibonacci Style
```python
# State: dp[i] = answer for first i elements
# Transition: dp[i] = f(dp[i-1], dp[i-2], ...)

def fibonacci(n):
    if n <= 1: return n
    dp = [0] * (n + 1)
    dp[1] = 1
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    return dp[n]
```

**Space Optimization**: If dp[i] only depends on dp[i-1], dp[i-2], use variables.

### Climbing Stairs / Coin Change
```python
# dp[i] = min coins to make amount i
def coin_change(coins, amount):
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0
    for i in range(1, amount + 1):
        for coin in coins:
            if coin <= i:
                dp[i] = min(dp[i], dp[i - coin] + 1)
    return dp[amount] if dp[amount] != float('inf') else -1
```

### House Robber (Non-adjacent selection)
```python
# dp[i] = max profit from first i houses
def rob(nums):
    if not nums: return 0
    if len(nums) == 1: return nums[0]
    dp = [0] * len(nums)
    dp[0] = nums[0]
    dp[1] = max(nums[0], nums[1])
    for i in range(2, len(nums)):
        dp[i] = max(dp[i-1], dp[i-2] + nums[i])
    return dp[-1]
```

## 2D DP Patterns

### Longest Common Subsequence (LCS)
```python
# dp[i][j] = LCS length of s1[:i] and s2[:j]
def lcs(s1, s2):
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
    return dp[m][n]
```

### Edit Distance
```python
# dp[i][j] = min operations to convert s1[:i] to s2[:j]
def edit_distance(s1, s2):
    m, n = len(s1), len(s2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(m + 1): dp[i][0] = i
    for j in range(n + 1): dp[0][j] = j
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1]
            else:
                dp[i][j] = 1 + min(dp[i-1][j],      # delete
                                   dp[i][j-1],      # insert
                                   dp[i-1][j-1])    # replace
    return dp[m][n]
```

### 0/1 Knapsack
```python
# dp[i][w] = max value with first i items and capacity w
def knapsack(weights, values, capacity):
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for w in range(capacity + 1):
            dp[i][w] = dp[i-1][w]  # don't take item i
            if weights[i-1] <= w:
                dp[i][w] = max(dp[i][w],
                               dp[i-1][w - weights[i-1]] + values[i-1])
    return dp[n][capacity]
```

### Grid Path (Unique Paths)
```python
# dp[i][j] = number of ways to reach (i, j)
def unique_paths(m, n):
    dp = [[1] * n for _ in range(m)]
    for i in range(1, m):
        for j in range(1, n):
            dp[i][j] = dp[i-1][j] + dp[i][j-1]
    return dp[m-1][n-1]
```

## Bitmask DP

### Traveling Salesman Problem (TSP)
```python
# dp[mask][i] = min cost to visit cities in mask, ending at i
def tsp(dist):
    n = len(dist)
    INF = float('inf')
    dp = [[INF] * n for _ in range(1 << n)]
    dp[1][0] = 0  # start at city 0

    for mask in range(1, 1 << n):
        for last in range(n):
            if not (mask & (1 << last)): continue
            if dp[mask][last] == INF: continue
            for next_city in range(n):
                if mask & (1 << next_city): continue
                new_mask = mask | (1 << next_city)
                dp[new_mask][next_city] = min(
                    dp[new_mask][next_city],
                    dp[mask][last] + dist[last][next_city]
                )

    full_mask = (1 << n) - 1
    return min(dp[full_mask][i] + dist[i][0] for i in range(n))
```

### Subset Sum with Bitmask
```python
# Check all 2^n subsets
def subset_sum(nums, target):
    n = len(nums)
    for mask in range(1 << n):
        total = sum(nums[i] for i in range(n) if mask & (1 << i))
        if total == target:
            return True
    return False
```

## Longest Increasing Subsequence (LIS)

### O(n²) Solution
```python
def lis_n2(nums):
    n = len(nums)
    dp = [1] * n
    for i in range(1, n):
        for j in range(i):
            if nums[j] < nums[i]:
                dp[i] = max(dp[i], dp[j] + 1)
    return max(dp)
```

### O(n log n) Solution with Binary Search
```python
import bisect

def lis_nlogn(nums):
    tails = []  # tails[i] = smallest tail of LIS of length i+1
    for num in nums:
        pos = bisect.bisect_left(tails, num)
        if pos == len(tails):
            tails.append(num)
        else:
            tails[pos] = num
    return len(tails)
```

## Common Pitfalls

1. **Wrong base case**: Always verify dp[0] or dp[0][0]
2. **Off-by-one**: Check loop bounds carefully
3. **State definition unclear**: Write out what dp[i] means
4. **Missing state**: Ensure all relevant info is captured
5. **Wrong transition order**: Fill table in correct order

## When to Use DP

| Signal | Pattern |
|--------|---------|
| "Minimum/maximum" | Optimization DP |
| "Count number of ways" | Counting DP |
| "Is it possible" | Boolean DP |
| "Subsequence" | LIS/LCS style |
| "Partition array" | Subset DP |
| Small n (≤20) | Bitmask DP |
