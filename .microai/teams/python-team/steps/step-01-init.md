# Step 01: Session Initialization

## Trigger
Khi user gọi `/microai:python-team-session {topic}`

## Actions

### 1. Parse Input
- Extract topic từ user input
- Identify keywords để suggest framework

### 2. Load Context
- Check `pyproject.toml` cho existing project
- Check `requirements.txt` fallback
- Detect framework từ dependencies

### 3. Framework Detection

```python
# Detection logic
if "fastapi" in deps:
    framework = "fastapi"
elif "django" in deps:
    framework = "django"
elif "flask" in deps:
    framework = "flask"
else:
    framework = ask_user()
```

### 4. Display Welcome

```
╔═══════════════════════════════════════════════════════════════╗
║                 🐍 PYTHON TEAM SESSION                         ║
╠═══════════════════════════════════════════════════════════════╣
║  Topic: {topic}                                                ║
║  Date: {date}                                                  ║
║  Framework: {framework}                                        ║
╠═══════════════════════════════════════════════════════════════╣
║  Team Members:                                                 ║
║  🎯 PM Agent - Requirements & User Stories                     ║
║  🏗️ Architect - System Design & Patterns                       ║
║  🐍 Developer - Implementation                                 ║
║  🧪 Tester - Testing & Coverage                                ║
║  🔍 Reviewer - Code Quality & Security                         ║
║  🚀 DevOps - Deployment & CI/CD                                ║
╚═══════════════════════════════════════════════════════════════╝

Workflow:
1. [→] Init
2. [ ] Requirements (PM Agent)
3. [ ] Architecture (Architect Agent)
4. [ ] Implementation (Developer Agent)
5. [ ] Testing (Tester Agent)
6. [ ] Review Loop (Reviewer ↔ Developer)
7. [ ] DevOps (DevOps Agent)
8. [ ] Synthesis

[Enter] to continue | *pause | *skip-to:N | *exit
```

### 5. Initialize State

```yaml
python_team_state:
  topic: "{topic}"
  date: "{today}"
  phase: "init"
  framework: "{detected}"
  current_step: 1
  breakpoint_active: false
```

## Next Step
→ Step 02: Requirements Gathering
