# Dev-Algo Team

> 3-agent dialogue system for Competitive Programming, Algorithm Design, and Interview Preparation

## Team Composition

| Agent | Icon | Role | Focus |
|-------|------|------|-------|
| Developer | 👨‍💻 | Implementer | Code implementation, edge cases, test cases |
| Algo-Master | 🧙 | Algorithm Expert | Pattern recognition, complexity analysis, optimization |
| Code Reviewer | 🔍 | Validator | Correctness, edge cases, micro-optimizations |

## Session Modes

### Problem-Solving Mode (`*solve`)
```
Dev presents problem → Algo analyzes → Dev implements → Reviewer validates
Output: Algorithm Design Document
```

### Code Review Mode (`*review`)
```
Dev presents code → Reviewer analyzes → Algo suggests → Dev refactors
Output: Code Review Report
```

### Interview Prep Mode (`*interview`)
```
Algo presents problem → Dev solves → Reviewer evaluates
Output: Interview Assessment Report
```

## Quick Start

```bash
# Start a solve session
/microai:dev-algo-session two sum problem

# Start a code review
/microai:dev-algo-session *review my sorting is TLE

# Start a mock interview
/microai:dev-algo-session *interview medium DP
```

## Knowledge Base

| File | Topics |
|------|--------|
| `01-dp-patterns.md` | 1D/2D DP, Bitmask, LIS, Knapsack |
| `02-graph-algorithms.md` | BFS, DFS, Dijkstra, MST, Topo Sort |
| `03-greedy-divide-conquer.md` | Greedy proofs, Binary search, Segment tree |
| `04-complexity-analysis.md` | Big-O, constraint analysis, trade-offs |
| `05-interview-patterns.md` | Two pointers, sliding window, monotonic stack |
| `06-optimization-techniques.md` | Constant factor, bit manipulation, I/O |

## Observer Commands

| Command | Effect |
|---------|--------|
| `@dev: <msg>` | Inject as Developer |
| `@algo: <msg>` | Inject as Algo-Master |
| `@reviewer: <msg>` | Inject as Code Reviewer |
| `*hint` | Get hint (interview mode) |
| `*skip` | Skip to synthesis |
| `*auto` / `*manual` | Toggle auto-continue |
| `*exit` | End session |

## Directory Structure

```
dev-algo/
├── workflow.md           # Team workflow
├── agents/
│   ├── developer.md      # Implementer agent
│   ├── algo-master.md    # Algorithm expert agent
│   └── code-reviewer.md  # Validator agent
├── knowledge/
│   ├── knowledge-index.yaml
│   └── 01-06-*.md        # Pattern knowledge bases
├── memory/
│   ├── context.md        # Team state
│   ├── learnings.md      # Discovered patterns
│   └── sessions.md       # Session history
├── steps/
│   └── step-01-05-*.md   # Workflow steps
└── templates/
    ├── algorithm-design-template.md
    ├── code-review-template.md
    ├── interview-assessment-template.md
    └── meeting-minutes-template.md
```

## Complexity Guidelines

| n limit | Acceptable Complexity |
|---------|----------------------|
| n ≤ 20 | O(2^n), O(n!) |
| n ≤ 10³ | O(n²) |
| n ≤ 10⁵ | O(n log n) |
| n ≤ 10⁶ | O(n) |
| n ≤ 10⁹ | O(log n), O(1) |

## Output Location

Session outputs are saved to:
```
.microai/docs/teams/dev-algo/logs/{date}-{mode}-{topic}.md
```

---

**Version:** 1.0
**Created:** 2024-12-31
**Language:** Vietnamese (vi) + English
