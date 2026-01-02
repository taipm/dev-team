# Team Command Template

Template cho slash command để invoke team session.

---

## Command File Template

Tạo tại: `.microai/commands/{team_name}-session.md`

```markdown
---
description: "Khởi động {TEAM_NAME} team simulation - dialogue turn-based giữa {Agent1} và {Agent2}"
---

# {TEAM_NAME} Session

Invoke the {TEAM_NAME} team for collaborative dialogue.

## Load Team

1. Read workflow: `.microai/teams/{team_name}/workflow.md`
2. Load agents từ `.microai/teams/{team_name}/agents/`
3. Load shared knowledge từ `.microai/teams/{team_name}/knowledge/`
4. Initialize memory từ `.microai/teams/{team_name}/memory/`

## Execute Workflow

Follow steps defined in workflow.md:
1. **Step 01**: Session Init - Parse input, detect mode, display welcome
2. **Step 02**: Presentation - First speaker presents topic
3. **Step 03**: Dialogue Loop - Turn-based conversation until consensus
4. **Step 04**: Synthesis - Generate output document
5. **Step 05**: Close - Save logs, update memory, display summary

## Session Modes

| Mode | Trigger | First Speaker | Output |
|------|---------|---------------|--------|
| {mode_1} | {keywords} | {agent} | {output_type} |
| {mode_2} | {keywords} | {agent} | {output_type} |

## Observer Controls

During dialogue, observer can:
- `[Enter]` - Continue
- `@{agent1}: <msg>` - Inject as Agent 1
- `@{agent2}: <msg>` - Inject as Agent 2
- `*skip` - Skip to synthesis
- `*exit` - End session
- `*auto` - Auto mode

## Examples

```bash
# Mode 1
/microai:{team_name}-session {example_topic_1}

# Mode 2
/microai:{team_name}-session {mode_2_prefix}: {example_topic_2}
```
```

---

## Runtime Command

Copy to: `.claude/commands/microai/{team_name}-session.md`

Nội dung giống file source command.

---

## Example: dev-qa-session

```markdown
---
description: "Khởi động Dev-QA team simulation - dialogue turn-based giữa Developer và QA Engineer để tạo Test Plan, Bug Report, hoặc Code Review"
---

# Dev-QA Session

Invoke the Dev-QA team for quality-focused dialogue.

## Load Team

1. Read workflow: `.microai/teams/dev-qa/workflow.md`
2. Load agents: `developer.md`, `qa-engineer.md`
3. Load knowledge: testing-strategies, bug-reporting, testability
4. Initialize memory

## Session Modes

| Mode | Trigger | First Speaker | Output |
|------|---------|---------------|--------|
| testplan | default, feature | Developer | Test Plan |
| bug | "bug:", "issue:" | QA Engineer | Bug Report |
| review | "review:", "PR" | Developer | Review Report |

## Examples

```bash
# Test Plan
/microai:dev-qa-session user authentication feature

# Bug Triage
/microai:dev-qa-session bug: login fails on Safari

# Code Review
/microai:dev-qa-session review: PR #123
```
```

---

## Checklist

Khi tạo team command:

- [ ] Description rõ ràng, có team name và agents
- [ ] Load đúng workflow path
- [ ] List all session modes với triggers
- [ ] Có examples cho mỗi mode
- [ ] Copy to .claude/commands/microai/ để register
