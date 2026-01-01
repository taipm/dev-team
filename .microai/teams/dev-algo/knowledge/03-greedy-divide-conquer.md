# Greedy & Divide-Conquer Patterns

## Greedy Algorithms

### When Greedy Works

Greedy works when:
1. **Greedy choice property**: Local optimal leads to global optimal
2. **Optimal substructure**: Optimal solution contains optimal solutions to subproblems

### Proof Techniques

#### Exchange Argument
1. Assume optimal solution O differs from greedy solution G
2. Show you can swap elements to make O more like G without worsening
3. Conclude G is optimal

#### Stays Ahead
1. At each step, show greedy is at least as good as any other choice
2. By induction, greedy stays ahead and reaches optimal

### Classic Greedy Problems

#### Interval Scheduling (Activity Selection)
```python
def max_activities(intervals):
    # Sort by end time
    intervals.sort(key=lambda x: x[1])
    count = 0
    last_end = float('-inf')

    for start, end in intervals:
        if start >= last_end:
            count += 1
            last_end = end

    return count
```

**Proof**: Choosing earliest end time maximizes remaining time for other activities.

#### Interval Partitioning (Meeting Rooms)
```python
import heapq

def min_rooms(intervals):
    intervals.sort()  # Sort by start time
    rooms = []  # Min heap of end times

    for start, end in intervals:
        if rooms and rooms[0] <= start:
            heapq.heappop(rooms)
        heapq.heappush(rooms, end)

    return len(rooms)
```

#### Huffman Coding
```python
import heapq

def huffman(frequencies):
    heap = [[freq, [char, ""]] for char, freq in frequencies.items()]
    heapq.heapify(heap)

    while len(heap) > 1:
        lo = heapq.heappop(heap)
        hi = heapq.heappop(heap)
        for pair in lo[1:]:
            pair[1] = '0' + pair[1]
        for pair in hi[1:]:
            pair[1] = '1' + pair[1]
        heapq.heappush(heap, [lo[0] + hi[0]] + lo[1:] + hi[1:])

    return {char: code for char, code in heap[0][1:]}
```

#### Fractional Knapsack
```python
def fractional_knapsack(items, capacity):
    # items = [(value, weight), ...]
    # Sort by value/weight ratio
    items.sort(key=lambda x: x[0]/x[1], reverse=True)

    total_value = 0
    for value, weight in items:
        if capacity >= weight:
            capacity -= weight
            total_value += value
        else:
            total_value += value * (capacity / weight)
            break

    return total_value
```

## Binary Search Patterns

### Standard Binary Search
```python
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1
```

### Lower Bound (First >= target)
```python
def lower_bound(arr, target):
    left, right = 0, len(arr)
    while left < right:
        mid = (left + right) // 2
        if arr[mid] < target:
            left = mid + 1
        else:
            right = mid
    return left
```

### Upper Bound (First > target)
```python
def upper_bound(arr, target):
    left, right = 0, len(arr)
    while left < right:
        mid = (left + right) // 2
        if arr[mid] <= target:
            left = mid + 1
        else:
            right = mid
    return left
```

### Binary Search on Answer
```python
# Find minimum x such that condition(x) is True
def binary_search_answer(lo, hi, condition):
    while lo < hi:
        mid = (lo + hi) // 2
        if condition(mid):
            hi = mid
        else:
            lo = mid + 1
    return lo
```

**Example**: Minimum capacity to ship within D days
```python
def ship_within_days(weights, D):
    def can_ship(capacity):
        days = 1
        current = 0
        for w in weights:
            if current + w > capacity:
                days += 1
                current = 0
            current += w
        return days <= D

    return binary_search_answer(max(weights), sum(weights), can_ship)
```

## Divide and Conquer

### Pattern
```python
def divide_conquer(problem):
    # Base case
    if is_base_case(problem):
        return solve_directly(problem)

    # Divide
    subproblems = divide(problem)

    # Conquer
    subresults = [divide_conquer(sub) for sub in subproblems]

    # Combine
    return combine(subresults)
```

### Merge Sort
```python
def merge_sort(arr):
    if len(arr) <= 1:
        return arr

    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])

    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result
```

**Complexity**: O(n log n)

### Count Inversions
```python
def count_inversions(arr):
    def merge_count(left, right):
        result = []
        inversions = 0
        i = j = 0
        while i < len(left) and j < len(right):
            if left[i] <= right[j]:
                result.append(left[i])
                i += 1
            else:
                result.append(right[j])
                inversions += len(left) - i  # Key insight
                j += 1
        result.extend(left[i:])
        result.extend(right[j:])
        return result, inversions

    def sort_count(arr):
        if len(arr) <= 1:
            return arr, 0
        mid = len(arr) // 2
        left, left_inv = sort_count(arr[:mid])
        right, right_inv = sort_count(arr[mid:])
        merged, split_inv = merge_count(left, right)
        return merged, left_inv + right_inv + split_inv

    _, inversions = sort_count(arr)
    return inversions
```

### Quick Select (Kth Largest)
```python
import random

def quick_select(arr, k):
    if len(arr) == 1:
        return arr[0]

    pivot = random.choice(arr)
    left = [x for x in arr if x < pivot]
    mid = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]

    if k <= len(left):
        return quick_select(left, k)
    elif k <= len(left) + len(mid):
        return pivot
    else:
        return quick_select(right, k - len(left) - len(mid))
```

**Average**: O(n), **Worst**: O(n²)

## Segment Tree

### Basic Segment Tree (Range Sum Query)
```python
class SegmentTree:
    def __init__(self, arr):
        self.n = len(arr)
        self.tree = [0] * (4 * self.n)
        self.build(arr, 1, 0, self.n - 1)

    def build(self, arr, node, start, end):
        if start == end:
            self.tree[node] = arr[start]
        else:
            mid = (start + end) // 2
            self.build(arr, 2*node, start, mid)
            self.build(arr, 2*node+1, mid+1, end)
            self.tree[node] = self.tree[2*node] + self.tree[2*node+1]

    def update(self, node, start, end, idx, val):
        if start == end:
            self.tree[node] = val
        else:
            mid = (start + end) // 2
            if idx <= mid:
                self.update(2*node, start, mid, idx, val)
            else:
                self.update(2*node+1, mid+1, end, idx, val)
            self.tree[node] = self.tree[2*node] + self.tree[2*node+1]

    def query(self, node, start, end, l, r):
        if r < start or end < l:
            return 0
        if l <= start and end <= r:
            return self.tree[node]
        mid = (start + end) // 2
        left = self.query(2*node, start, mid, l, r)
        right = self.query(2*node+1, mid+1, end, l, r)
        return left + right
```

**Complexity**: Build O(n), Query O(log n), Update O(log n)

## Algorithm Selection

| Problem Type | Algorithm |
|--------------|-----------|
| Interval scheduling | Sort by end, greedy |
| Minimum resources | Sort + heap |
| Search sorted array | Binary search |
| Find kth element | Quick select |
| Range queries | Segment tree |
| Optimal prefix codes | Huffman coding |
