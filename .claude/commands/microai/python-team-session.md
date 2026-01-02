---
description: "Khởi động Python Team session - Full-stack development từ requirements đến release với 6 agents"
---

# Python Team Session

Invoke the Python Team for full-stack Python development.

## Load Team

1. Read workflow: `.microai/teams/python-team/workflow.md`
2. Load agents từ `.microai/teams/python-team/agents/`
3. Load steps từ `.microai/teams/python-team/steps/`
4. Initialize session state

## Execute Workflow

Follow steps defined in workflow.md:
1. **Step 01**: Session Init - Parse input, detect framework, display welcome
2. **Step 02**: Requirements - PM Agent gathers specs
3. **Step 03**: Architecture - Architect designs system
4. **Step 04**: Implementation - Developer writes code
5. **Step 05**: Testing - Tester creates pytest suites
6. **Step 06**: Review Loop - Reviewer ↔ Developer quality cycle
7. **Step 07**: DevOps - Docker, CI/CD configuration
8. **Step 08**: Synthesis - Final report and handoff

## Team Members

| Agent | Role | Focus |
|-------|------|-------|
| 🎯 PM Agent | Product Manager | Requirements, user stories |
| 🏗️ Architect | Solution Architect | Patterns, structure |
| 🐍 Developer | Python Developer | Implementation |
| 🧪 Tester | QA Engineer | pytest, coverage |
| 🔍 Reviewer | Code Reviewer | Quality, security |
| 🚀 DevOps | DevOps Engineer | Docker, CI/CD |

## Observer Controls

| Command | Effect |
|---------|--------|
| `[Enter]` | Continue to next step |
| `*pause` | Pause for manual review |
| `*skip` | Skip current step |
| `*skip-to:N` | Jump to step N |
| `*exit` | End session, save progress |
| `@pm: <msg>` | Inject to PM Agent |
| `@arch: <msg>` | Inject to Architect |
| `@dev: <msg>` | Inject to Developer |
| `@test: <msg>` | Inject to Tester |
| `@reviewer: <msg>` | Inject to Reviewer |
| `@devops: <msg>` | Inject to DevOps |

## Framework Selection

| Command | Framework |
|---------|-----------|
| `*framework:fastapi` | FastAPI (default) |
| `*framework:django` | Django |
| `*framework:flask` | Flask |
| `*framework:cli` | CLI application |

## Examples

```bash
# FastAPI REST API
/microai:python-team-session build a user management REST API

# Django web app
/microai:python-team-session *framework:django create a blog application

# CLI tool
/microai:python-team-session *framework:cli create a file processing CLI
```
