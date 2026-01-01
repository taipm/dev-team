# Graph Algorithms

## Graph Representations

### Adjacency List (Preferred for sparse graphs)
```python
from collections import defaultdict

graph = defaultdict(list)
# Add edge u -> v with weight w
graph[u].append((v, w))
```

### Adjacency Matrix (Dense graphs, O(1) lookup)
```python
# For n nodes
adj = [[0] * n for _ in range(n)]
adj[u][v] = weight
```

## BFS - Breadth-First Search

**Use for**: Shortest path in unweighted graph, level-order traversal

```python
from collections import deque

def bfs(graph, start):
    visited = set([start])
    queue = deque([start])
    distance = {start: 0}

    while queue:
        node = queue.popleft()
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                distance[neighbor] = distance[node] + 1
                queue.append(neighbor)

    return distance
```

**Complexity**: O(V + E)

## DFS - Depth-First Search

**Use for**: Connectivity, cycle detection, topological sort

### Iterative
```python
def dfs_iterative(graph, start):
    visited = set()
    stack = [start]

    while stack:
        node = stack.pop()
        if node in visited:
            continue
        visited.add(node)
        for neighbor in graph[node]:
            if neighbor not in visited:
                stack.append(neighbor)

    return visited
```

### Recursive
```python
def dfs_recursive(graph, node, visited=None):
    if visited is None:
        visited = set()
    visited.add(node)
    for neighbor in graph[node]:
        if neighbor not in visited:
            dfs_recursive(graph, neighbor, visited)
    return visited
```

## Shortest Path Algorithms

### Dijkstra's Algorithm
**Use for**: Single source shortest path, non-negative weights

```python
import heapq

def dijkstra(graph, start):
    dist = {start: 0}
    pq = [(0, start)]  # (distance, node)

    while pq:
        d, u = heapq.heappop(pq)
        if d > dist.get(u, float('inf')):
            continue
        for v, w in graph[u]:
            if dist.get(u, float('inf')) + w < dist.get(v, float('inf')):
                dist[v] = dist[u] + w
                heapq.heappush(pq, (dist[v], v))

    return dist
```

**Complexity**: O((V + E) log V)

### Bellman-Ford Algorithm
**Use for**: Negative weights, detect negative cycles

```python
def bellman_ford(n, edges, start):
    dist = [float('inf')] * n
    dist[start] = 0

    for _ in range(n - 1):
        for u, v, w in edges:
            if dist[u] + w < dist[v]:
                dist[v] = dist[u] + w

    # Check for negative cycle
    for u, v, w in edges:
        if dist[u] + w < dist[v]:
            return None  # Negative cycle exists

    return dist
```

**Complexity**: O(V × E)

### Floyd-Warshall Algorithm
**Use for**: All pairs shortest path

```python
def floyd_warshall(n, edges):
    dist = [[float('inf')] * n for _ in range(n)]
    for i in range(n):
        dist[i][i] = 0
    for u, v, w in edges:
        dist[u][v] = w

    for k in range(n):
        for i in range(n):
            for j in range(n):
                dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])

    return dist
```

**Complexity**: O(V³)

## Minimum Spanning Tree (MST)

### Kruskal's Algorithm (Edge-based)
```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        px, py = self.find(x), self.find(y)
        if px == py:
            return False
        if self.rank[px] < self.rank[py]:
            px, py = py, px
        self.parent[py] = px
        if self.rank[px] == self.rank[py]:
            self.rank[px] += 1
        return True

def kruskal(n, edges):
    edges.sort(key=lambda x: x[2])  # Sort by weight
    uf = UnionFind(n)
    mst_weight = 0
    mst_edges = []

    for u, v, w in edges:
        if uf.union(u, v):
            mst_weight += w
            mst_edges.append((u, v, w))

    return mst_weight, mst_edges
```

**Complexity**: O(E log E)

### Prim's Algorithm (Vertex-based)
```python
import heapq

def prim(graph, n):
    visited = [False] * n
    pq = [(0, 0)]  # (weight, node)
    mst_weight = 0

    while pq:
        w, u = heapq.heappop(pq)
        if visited[u]:
            continue
        visited[u] = True
        mst_weight += w
        for v, weight in graph[u]:
            if not visited[v]:
                heapq.heappush(pq, (weight, v))

    return mst_weight
```

**Complexity**: O((V + E) log V)

## Topological Sort

**Use for**: DAG ordering, dependency resolution

### Kahn's Algorithm (BFS-based)
```python
from collections import deque

def topological_sort(graph, n):
    in_degree = [0] * n
    for u in graph:
        for v in graph[u]:
            in_degree[v] += 1

    queue = deque([i for i in range(n) if in_degree[i] == 0])
    result = []

    while queue:
        u = queue.popleft()
        result.append(u)
        for v in graph[u]:
            in_degree[v] -= 1
            if in_degree[v] == 0:
                queue.append(v)

    return result if len(result) == n else []  # Empty if cycle exists
```

### DFS-based
```python
def topological_sort_dfs(graph, n):
    visited = [0] * n  # 0: unvisited, 1: visiting, 2: visited
    result = []

    def dfs(node):
        if visited[node] == 1:
            return False  # Cycle detected
        if visited[node] == 2:
            return True
        visited[node] = 1
        for neighbor in graph[node]:
            if not dfs(neighbor):
                return False
        visited[node] = 2
        result.append(node)
        return True

    for i in range(n):
        if visited[i] == 0:
            if not dfs(i):
                return []  # Cycle exists

    return result[::-1]
```

## Cycle Detection

### Undirected Graph (Union-Find)
```python
def has_cycle_undirected(n, edges):
    uf = UnionFind(n)
    for u, v in edges:
        if uf.find(u) == uf.find(v):
            return True
        uf.union(u, v)
    return False
```

### Directed Graph (DFS with colors)
Use the DFS-based topological sort above - returns empty if cycle exists.

## Bipartite Check

```python
def is_bipartite(graph, n):
    color = [-1] * n

    for start in range(n):
        if color[start] != -1:
            continue
        queue = deque([start])
        color[start] = 0
        while queue:
            u = queue.popleft()
            for v in graph[u]:
                if color[v] == -1:
                    color[v] = 1 - color[u]
                    queue.append(v)
                elif color[v] == color[u]:
                    return False
    return True
```

## Algorithm Selection Guide

| Problem | Algorithm | Complexity |
|---------|-----------|------------|
| Shortest path, unweighted | BFS | O(V + E) |
| Shortest path, non-negative | Dijkstra | O((V+E) log V) |
| Shortest path, negative ok | Bellman-Ford | O(VE) |
| All pairs shortest | Floyd-Warshall | O(V³) |
| MST | Kruskal/Prim | O(E log E) |
| Topological sort | Kahn/DFS | O(V + E) |
| Cycle detection | DFS/Union-Find | O(V + E) |
| Connected components | BFS/DFS/UF | O(V + E) |
