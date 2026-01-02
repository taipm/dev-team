# Step 01: Session Initialization

## Purpose
Initialize dev-algo session with mode detection, agent loading, and knowledge preparation.

## Mode Detection

### Trigger Analysis
```yaml
triggers:
  solve:
    commands: ["*solve"]
    keywords: ["solve", "problem", "leetcode", "codeforces", "contest", "challenge"]
    default: true

  review:
    commands: ["*review"]
    keywords: ["review", "optimize", "TLE", "timeout", "slow", "memory limit", "WA"]

  interview:
    commands: ["*interview"]
    keywords: ["interview", "mock", "practice", "prep", "faang", "technical"]
```

### Mode Selection Logic
```
1. Check for explicit command (*solve, *review, *interview)
2. If no command, scan topic for keywords
3. Default to "solve" mode if no match
```

## Welcome Banner

```
╔═══════════════════════════════════════════════════════════════╗
║              DEV-ALGO SESSION: {MODE} 🧙                       ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                ║
║  Mode: {Problem Solving / Code Review / Interview Prep}        ║
║  Team: Developer 👨‍💻 | Algo-Master 🧙 | Reviewer 🔍           ║
╠═══════════════════════════════════════════════════════════════╣
║  Commands:                                                     ║
║    @dev/@algo/@reviewer: <msg> - Inject message               ║
║    *hint - Get hint (interview mode)                          ║
║    *skip - Skip to synthesis                                  ║
║    *auto/*manual - Toggle auto-continue                       ║
║    *exit - End session                                        ║
╚═══════════════════════════════════════════════════════════════╝
```

## Agent Loading

### Load Order
1. Load developer.md (always first speaker in solve/review)
2. Load algo-master.md
3. Load code-reviewer.md

### Agent Introduction
```
Team đã sẵn sàng:

👨‍💻 **Developer**: Ready to implement
🧙 **Algo-Master**: Ready to analyze patterns
🔍 **Code Reviewer**: Ready to validate

Mode: {mode}
First speaker: {developer/algo-master}
```

## Knowledge Loading

### By Mode
```yaml
solve:
  auto_load:
    - dp-patterns
    - graph-algorithms
    - complexity
  priority: high

review:
  auto_load:
    - complexity
    - optimization-techniques
  priority: high

interview:
  auto_load:
    - interview-patterns
    - complexity
  priority: high
```

### By Keyword Detection
```yaml
keyword_triggers:
  dp|dynamic|memoization: dp-patterns
  graph|bfs|dfs|dijkstra|shortest: graph-algorithms
  greedy|sort|interval: greedy-divide-conquer
  two.pointer|sliding|window: interview-patterns
  tle|optimize|performance|fast: optimization-techniques
  binary.search|divide: greedy-divide-conquer
```

## Workspace Creation (CRITICAL)

**MUST** create workspace BEFORE any code generation:

```bash
# Generate workspace path
WORKSPACE=".microai/workspaces/dev-algo/$(date +%Y-%m-%d)-{topic_slug}"

# Create workspace structure
mkdir -p "$WORKSPACE/src"
mkdir -p "$WORKSPACE/output"
mkdir -p "$WORKSPACE/docs"

# Create README
echo "# Dev-Algo Session: {topic}" > "$WORKSPACE/README.md"
echo "Date: $(date +%Y-%m-%d)" >> "$WORKSPACE/README.md"
echo "Mode: {mode}" >> "$WORKSPACE/README.md"
```

### Workspace Rules
1. **ALL source code** MUST go to `$WORKSPACE/src/`
2. **ALL generated files** (videos, images, etc.) MUST go to `$WORKSPACE/output/`
3. **NEVER** create files in project root
4. Commands that generate output should `cd $WORKSPACE/output` first

### Banner Update
Display workspace path in welcome banner:
```
║  Workspace: .microai/workspaces/dev-algo/{date}-{topic}/   ║
```

## Session State Initialization

```yaml
session:
  id: "{timestamp}-{mode}-{topic_slug}"
  started_at: "{ISO timestamp}"
  mode: "{solve/review/interview}"
  topic: "{user topic}"

  # NEW: Workspace configuration
  workspace:
    root: ".microai/workspaces/dev-algo/{date}-{topic_slug}"
    src: "{workspace.root}/src"
    output: "{workspace.root}/output"
    docs: "{workspace.root}/docs"

  turn_state:
    current_turn: 0
    max_turns: {15 for solve, 10 for review, 12 for interview}
    current_speaker: null
    auto_continue: false

  agents:
    developer:
      status: active
      turns_taken: 0
    algo_master:
      status: active
      turns_taken: 0
    code_reviewer:
      status: active
      turns_taken: 0

  knowledge_loaded: []
  checkpoints: []
```

## Checkpoint Creation

Create initial checkpoint:
```
.microai/agents/microai/teams/dev-algo/memory/checkpoints/
└── {session_id}/
    └── checkpoint-00-init.yaml
```

## Transition to Step 2

After initialization:
- Display welcome banner
- Announce first speaker
- Transition to Step 2: Problem Presentation
