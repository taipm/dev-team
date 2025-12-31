# Dev-Algo Session Command

Start a Dev-Algo team session with 3 agents: Developer, Algo-Master, and Code Reviewer.

## Usage

```
/microai:dev-algo-session <topic>
/microai:dev-algo-session *solve <problem>
/microai:dev-algo-session *review <code description>
/microai:dev-algo-session *interview <difficulty>
```

## Examples

```
/microai:dev-algo-session two sum problem
/microai:dev-algo-session *solve longest increasing subsequence
/microai:dev-algo-session *review my binary search implementation has TLE
/microai:dev-algo-session *interview medium difficulty DP
```

## Session Modes

| Mode | Trigger | Description |
|------|---------|-------------|
| `*solve` | Default | Solve problem from scratch |
| `*review` | TLE, optimize | Review and optimize code |
| `*interview` | Interview prep | Mock technical interview |

## Observer Commands

During session:
- `@dev: <msg>` - Inject as Developer
- `@algo: <msg>` - Inject as Algo-Master
- `@reviewer: <msg>` - Inject as Code Reviewer
- `*hint` - Get hint (interview mode)
- `*skip` - Skip to output synthesis
- `*auto` / `*manual` - Toggle auto-continue
- `*exit` - End session

---

## Session Execution

$ARGUMENTS

### Step 1: Initialize Session

Load the dev-algo team from `.microai/agents/microai/teams/dev-algo/`:
- Read `workflow.md` for session configuration
- Load agents from `agents/` directory
- Determine mode from topic or explicit trigger

### Step 2: Load Knowledge

Based on detected mode, load relevant knowledge files:
- **solve**: dp-patterns, graph-algorithms, complexity
- **review**: complexity, optimization-techniques
- **interview**: interview-patterns, complexity

### Step 3: Start Dialogue

Display welcome banner and begin turn-based dialogue:

```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-ALGO SESSION: {MODE} 🧙                       ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                ║
║  Team: Developer 👨‍💻 | Algo-Master 🧙 | Reviewer 🔍           ║
╚═══════════════════════════════════════════════════════════════╝
```

### Step 4: Execute Dialogue Loop

Follow speaker rotation based on mode:
- **solve**: Dev → Algo → Dev → Reviewer → Dev → ...
- **review**: Dev → Reviewer → Algo → Dev → ...
- **interview**: Algo → Dev → Reviewer → Dev → ...

Each agent uses their defined response format and handoff signals.

### Step 5: Generate Output

Based on session outcome, generate appropriate output document:
- solve → Algorithm Design Document
- review → Code Review Report
- interview → Interview Assessment

Save to `.microai/docs/teams/dev-algo/logs/{date}-{mode}-{topic}.md`

### Step 6: Close Session

Update memory files and display session summary.

---

## Team Reference

### Developer 👨‍💻
- Focus: Implementation, edge cases, testing
- Asks: "Algo-Master, pattern này đúng không?"

### Algo-Master 🧙
- Focus: Pattern recognition, complexity analysis
- Asks: "Dev, thử implement pattern này"

### Code Reviewer 🔍
- Focus: Correctness, edge cases, optimization
- Says: "LGTM" or "Needs revision"
