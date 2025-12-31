# Step 03: Dialogue Loop

## Purpose
Turn-based discussion between 3 agents until problem is solved or consensus reached.

## Speaker Rotation by Mode

### Solve Mode
```
Dev presents problem
  → Algo analyzes & recommends pattern
    → Dev implements approach
      → Reviewer validates
        → Dev refines (if needed)
          → Algo suggests optimization
            → ...
```

**Rotation**: Dev → Algo → Dev → Reviewer → Dev → Algo → ...

### Review Mode
```
Dev presents code
  → Reviewer analyzes issues
    → Algo suggests optimization
      → Dev implements fix
        → Reviewer re-validates
          → ...
```

**Rotation**: Dev → Reviewer → Algo → Dev → Reviewer → ...

### Interview Mode
```
Algo presents problem
  → Dev thinks & explains approach
    → Reviewer evaluates approach
      → Dev codes solution
        → Algo asks follow-up
          → ...
```

**Rotation**: Algo → Dev → Reviewer → Dev → Algo → ...

## Turn Structure

### Turn Header
```
╔═══════════════════════════════════════════════════════════════╗
║ Turn {n}/{max} | Mode: {mode} | Speaker: {agent} {icon}        ║
╚═══════════════════════════════════════════════════════════════╝
```

### Turn Content
Each agent follows their response format from agent definition.

### Turn Footer
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 Turn {n} complete. Next: {next_agent} {icon}
   Press Enter to continue, or:
   • @{agent}: <msg> - Inject as {agent}
   • *focus: <topic> - Redirect discussion
   • *skip - Skip to synthesis
   • *auto - Enable auto-continue
   • *exit - End session
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Turn Limits

| Mode | Max Turns | Typical Turns |
|------|-----------|---------------|
| solve | 15 | 8-12 |
| review | 10 | 5-8 |
| interview | 12 | 8-10 |

## Dialogue State Machine

```
┌─────────────────────────────────────────────────────────────────┐
│                    Dialogue State Machine                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  [PRESENTING] ──turn_complete──→ [ANALYZING]                    │
│       │                              │                          │
│       │                              │                          │
│       ↓                              ↓                          │
│  [IMPLEMENTING] ←─recommendation─ [ANALYZING]                   │
│       │                              │                          │
│       │                              │                          │
│       ↓                              ↓                          │
│  [VALIDATING] ←──code_ready───── [IMPLEMENTING]                 │
│       │                              │                          │
│       │                              │                          │
│       ↓                              ↓                          │
│  [REFINING] ←───feedback──────── [VALIDATING]                   │
│       │                              │                          │
│       │                              │                          │
│       ↓                              ↓                          │
│  [CONSENSUS] ←──approved───────── [VALIDATING]                  │
│       │                                                         │
│       ↓                                                         │
│  [SYNTHESIZING] ────────→ Step 4                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Handoff Signals

### Developer Handoffs
- `[Algo-Master, pattern này đúng không?]` → Algo-Master speaks
- `[Reviewer, check implementation?]` → Reviewer speaks
- `[Implement xong, ready for review]` → Reviewer speaks

### Algo-Master Handoffs
- `[Dev, thử implement pattern này]` → Developer speaks
- `[Reviewer, verify complexity?]` → Reviewer speaks
- `[Có unclear gì không?]` → Whoever has question

### Reviewer Handoffs
- `[Dev, fix issues này]` → Developer speaks
- `[LGTM, có thể submit]` → Synthesis phase
- `[Algo, có optimization nào?]` → Algo-Master speaks

## Observer Interventions

### Inject Message
```
@algo: Có thể dùng segment tree ở đây không?
```
→ System injects message as if Algo-Master said it

### Focus Redirect
```
*focus: edge cases
```
→ Next speaker focuses on edge cases

### Auto Continue
```
*auto
```
→ Continue without prompting until max turns or consensus

### Skip to Synthesis
```
*skip
```
→ End dialogue, generate output with current state

## Checkpoint per Turn

After each turn:
```yaml
checkpoint:
  turn: {n}
  speaker: {agent}
  content_summary: "{brief summary}"
  state:
    problem_understood: {true/false}
    approach_selected: {true/false}
    implemented: {true/false}
    validated: {true/false}
    consensus: {true/false}
```

## Consensus Detection

Dialogue can end when:
1. Reviewer says "LGTM" or "Pass"
2. Max turns reached
3. Observer commands `*skip` or `*exit`
4. All agents agree on solution

## Transition to Step 4

When consensus detected or max turns:
- Display dialogue summary
- Transition to Step 4: Output Synthesis
