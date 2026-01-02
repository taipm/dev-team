# Step 01: Session Initialization

## Trigger
- Session start
- `/discovery` command invoked

## Agents
- 🎯 **Navigator** (lead)
- 📝 **Chronicler** (support)

## Actions

### 1. Navigator: Assess Session Type
```yaml
check:
  - Is this a new session or resume?
  - Is last-context available?
  - What scope does user want?

determine:
  session_type: "new|resume|continue"
```

### 2. Chronicler: Load Contexts
```yaml
load:
  - memory/last-context.md
  - memory/question-context.md
  - knowledge/question-bank.yaml

verify:
  - File integrity
  - Format correctness
  - Data consistency

initialize:
  - memory/current-context.md (fresh)
  - memory/code-context.md (fresh)
```

### 3. Navigator: Display Session Info
```markdown
╔═══════════════════════════════════════════════════════════════════╗
║                    DISCOVERY SESSION                               ║
╠═══════════════════════════════════════════════════════════════════╣
║  Type: {new|resume|continue}                                       ║
║  Scope: {full|focused|custom}                                      ║
║  Depth: {1|2|3}                                                    ║
╠═══════════════════════════════════════════════════════════════════╣
║  From Last Session:                                                ║
║  • Date: {date}                                                    ║
║  • Questions answered: {N}                                         ║
║  • Key findings: {summary}                                         ║
║  • Open questions: {N}                                             ║
╠═══════════════════════════════════════════════════════════════════╣
║  Question Bank:                                                    ║
║  • Total questions: {N}                                            ║
║  • Already answered: {N}                                           ║
║  • Available: {N}                                                  ║
╚═══════════════════════════════════════════════════════════════════╝
```

### 4. Navigator: Confirm or Adjust
```yaml
if: user specified scope
  confirm: scope settings

else:
  ask:
    - "Full discovery hoặc focus vào area cụ thể?"
    - "Depth level mong muốn?"

available_commands:
  - "[Enter]" → Continue with defaults
  - "*scope:{area}" → Set focus area
  - "*depth:{1|2|3}" → Set depth level
  - "*resume" → Resume from checkpoint
```

## Output
```yaml
current_context:
  session:
    id: "{uuid}"
    started_at: "{timestamp}"
    type: "{new|resume|continue}"
    scope: "{full|focused}"
    depth: {1|2|3}

  from_last_session:
    date: "{date}"
    questions_answered: {N}
    open_questions: []

  status: "initialized"
```

## Transition
→ Step 02: Question Selection
