# dev-algo-session

Dialogue giữa Developer và Algorithm Expert.

## Kích Hoạt

```
/microai:dev-algo-session
```

## Mục Đích

- Algorithm design
- Complexity analysis
- Optimization strategies
- Competitive programming

## Roles

### 👨‍💻 Developer
- Describe problem
- Discuss constraints
- Implement solutions
- Ask about optimizations

### 🧮 Algorithm Expert
- Analyze problem
- Propose algorithms
- Prove correctness
- Analyze complexity

## Output Formats

### Algorithm Analysis

```markdown
# Algorithm: [Name]

## Problem
[Description]

## Approach
[High-level strategy]

## Pseudocode
```
function solve(input):
    // Step 1
    // Step 2
    return result
```

## Complexity
- Time: O(n log n)
- Space: O(n)

## Proof of Correctness
[Why it works]

## Edge Cases
- [Case 1]
- [Case 2]
```

## Ví Dụ Session

```
You: /microai:dev-algo-session

Developer: 👨‍💻 Tôi cần tìm K elements gần nhất
với target trong sorted array.

Algo: 🧮 Interesting problem! Để clarify:
1. Array có duplicates không?
2. K có thể lớn hơn array size?
3. Khi tie, prefer element nào?

Developer: 👨‍💻
1. Có thể có duplicates
2. K <= array.length
3. Prefer smaller element

Algo: 🧮 Có vài approaches:

**Approach 1: Sort by distance**
- Calculate distance of all elements
- Sort by distance
- Take K elements
- Time: O(n log n), Space: O(n)

**Approach 2: Binary Search + Two Pointers**
- Binary search tìm position của target
- Two pointers expand từ đó
- Time: O(log n + k), Space: O(1)

**Approach 3: Binary Search on Window**
- Binary search tìm left bound của window size K
- Time: O(log(n-k) + k), Space: O(1)

Approach 2 là balance tốt nhất.

Developer: 👨‍💻 Explain Approach 2 chi tiết?

Algo: 🧮

## Approach 2: Binary Search + Two Pointers

### Intuition
Tìm điểm gần target nhất, rồi expand hai bên.

### Algorithm
```python
def findClosestElements(arr, k, x):
    # Binary search for closest position
    left = 0
    right = len(arr) - 1

    while right - left >= k:
        if abs(arr[left] - x) > abs(arr[right] - x):
            left += 1
        else:
            right -= 1

    return arr[left:right+1]
```

### Correctness Proof
- At each step, we eliminate the farther element
- After (n-k) eliminations, k elements remain
- These are the k closest elements

### Complexity
- Time: O(n - k) trong worst case
- Space: O(1) excluding output

### Edge Cases
1. x smaller than all elements → first k
2. x larger than all elements → last k
3. x in middle → balanced expansion

Developer: 👨‍💻 Có thể optimize hơn không?

Algo: 🧮 Yes! Approach 3 uses binary search
để tìm left boundary:

```python
def findClosestElements(arr, k, x):
    left = 0
    right = len(arr) - k

    while left < right:
        mid = (left + right) // 2
        if x - arr[mid] > arr[mid + k] - x:
            left = mid + 1
        else:
            right = mid

    return arr[left:left + k]
```

Time: O(log(n-k) + k)
```

## Common Algorithm Topics

| Topic | Techniques |
|-------|------------|
| Sorting | QuickSort, MergeSort, RadixSort |
| Searching | Binary Search, Two Pointers |
| Graphs | BFS, DFS, Dijkstra, Union-Find |
| DP | Memoization, Tabulation |
| Strings | KMP, Rabin-Karp, Trie |

## Xem Thêm

- [Session Teams Overview](../session-teams.md)
- [Problem Solving Workflow](../../workflows/problem-solving.md)
