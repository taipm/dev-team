# Dev-Algo Team Workflow

## Overview

Dev-Algo team simulation facilitates dialogue giữa **Developer**, **Algorithm Master**, và **Code Reviewer** để:
- Solve competitive programming problems
- Optimize algorithm implementations
- Prepare for technical interviews

## Team Members

| Agent | Role | Focus |
|-------|------|-------|
| 👨‍💻 Developer | Implementer | Code implementation, edge cases, test cases |
| 🧙 Algo-Master | Algorithm Expert | Pattern recognition, complexity analysis, optimization |
| 🔍 Code Reviewer | Validator | Correctness, edge cases, micro-optimizations |

## Session Modes

### Problem-Solving Mode (`*solve` - default)
```
Purpose: Solve competitive programming problems from scratch
Flow: Dev presents problem → Algo analyzes → Dev implements → Reviewer validates
Output: Algorithm Design Document
Triggers: "*solve", topic contains "solve", "problem", "leetcode", "codeforces"
```

### Code Review Mode (`*review`)
```
Purpose: Review existing algorithm implementation for optimization
Flow: Dev presents code → Reviewer analyzes → Algo suggests → Dev refactors
Output: Code Review Report
Triggers: "*review", topic contains "review", "optimize", "TLE", "timeout"
```

### Interview Prep Mode (`*interview`)
```
Purpose: Mock technical interview with algorithm focus
Flow: Algo presents problem → Dev solves with time constraint → Reviewer evaluates
Output: Interview Assessment Report
Triggers: "*interview", topic contains "interview", "mock", "practice"
```

## Workflow Steps

```
┌─────────────────────────────────────────────────────────────────┐
│                    Dev-Algo Session Flow                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Step 1: Session Init                                           │
│    ├── Detect mode (solve/review/interview)                     │
│    ├── Load agents và knowledge                                 │
│    └── Display welcome banner                                   │
│                                                                  │
│  Step 2: Problem Presentation                                   │
│    ├── [solve] Developer presents problem statement             │
│    ├── [review] Developer presents current implementation       │
│    └── [interview] Algo-Master presents problem as interviewer  │
│                                                                  │
│  Step 3: Dialogue Loop (3-agent rotation)                       │
│    ├── solve:     Dev → Algo → Dev → Reviewer → Dev → ...      │
│    ├── review:    Dev → Reviewer → Algo → Dev → ...            │
│    ├── interview: Algo → Dev → Reviewer → Dev → ...            │
│    ├── Observer controls (continue/intervene/skip)              │
│    └── Auto-checkpoint each turn                                │
│                                                                  │
│  Step 4: Output Synthesis                                       │
│    ├── Generate output document                                 │
│    ├── All 3 agents review                                      │
│    └── Sign-off process                                         │
│                                                                  │
│  Step 5: Session Close                                          │
│    ├── Save to .microai/docs/teams/dev-algo/logs/              │
│    ├── Update team memory                                       │
│    └── Display summary                                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Knowledge Loading

### By Mode
| Mode | Auto-Load |
|------|-----------|
| solve | dp-patterns, graph-algorithms, complexity |
| review | complexity, optimization-techniques |
| interview | interview-patterns, complexity |

### By Keywords
- `dp`, `dynamic programming`, `memoization` → dp-patterns
- `graph`, `bfs`, `dfs`, `dijkstra` → graph-algorithms
- `greedy`, `binary search` → greedy-divide-conquer
- `two pointer`, `sliding window` → interview-patterns
- `TLE`, `optimize`, `performance` → optimization-techniques

## Observer Commands

| Command | Effect |
|---------|--------|
| `@dev: <msg>` | Inject as Developer |
| `@algo: <msg>` | Inject as Algo-Master |
| `@reviewer: <msg>` | Inject as Code Reviewer |
| `@guide: <msg>` | Facilitator note |
| `*focus: <topic>` | Redirect discussion |
| `*hint` | Algo-Master gives hint (interview mode) |
| `*auto` | Auto-continue mode |
| `*manual` | Manual mode (default) |
| `*skip` | Skip to synthesis |
| `*exit` | End session |

## Output Paths

```
.microai/docs/teams/dev-algo/logs/
├── 2024-01-15-solve-two-sum.md
├── 2024-01-15-review-binary-search.md
└── 2024-01-15-interview-dp-practice.md
```

## Usage

### Start Session
```
/microai:dev-algo-session solve two sum problem
/microai:dev-algo-session review my sorting implementation
/microai:dev-algo-session interview dp problems
```

### Mode Triggers
- `*solve` or default → Problem-Solving Mode
- `*review` or topic contains "review", "TLE", "optimize" → Code Review Mode
- `*interview` or topic contains "interview", "mock" → Interview Prep Mode

## Memory System

- **context.md**: Active session state, statistics
- **learnings.md**: Algorithm patterns và insights discovered
- **sessions.md**: Session history summaries

## Best Practices

### For Problem Solving
1. Understand problem constraints first
2. Classify problem into pattern category
3. Start with brute force, then optimize
4. Test with edge cases before submission

### For Code Review
1. Verify complexity claims với analysis
2. Check all edge cases systematically
3. Look for constant-factor optimizations
4. Validate correctness before performance

### For Interview Prep
1. Think out loud, explain reasoning
2. Start with examples before coding
3. State assumptions clearly
4. Test solution với examples
