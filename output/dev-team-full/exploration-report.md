# Exploration Report: dev-team

> **Session**: DTT-2026-01-04-DIAGRAM-002
> **Analyzed**: 2026-01-04 22:40
> **Agent**: Explorer

---

## Overview

| Attribute | Value |
|-----------|-------|
| Project Name | dev-team (MicroAI Multi-Agent Framework) |
| Root Path | /Users/taipm/GitHub/dev-team |
| Tech Stack | Node.js + YAML + Claude Code |
| Architecture | 5-Layer Multi-Agent Orchestration |

---

## Component Inventory

| Component | Count | Location |
|-----------|-------|----------|
| **Agents** | 28 | `.microai/agents/` |
| **Teams** | 20 | `.microai/teams/` |
| **Skills** | 23+ | `.microai/skills/` |
| **Commands** | 21+ | `.microai/commands/` |
| **Schemas** | 2 | `.microai/schemas/` |

---

## Agents (28)

### Meta Agents
| Agent | Purpose |
|-------|---------|
| father-agent | Agent/Team creation và management |
| agent-evaluator | Đánh giá chất lượng agent |
| skill-creator-agent | Tạo skills mới |

### Development Agents
| Agent | Purpose |
|-------|---------|
| go-dev-agent | Go development |
| go-refactor-agent | Go code refactoring |
| go-review-linus-agent | Go code review (Linus style) |
| config-agent | Configuration management |
| router-agent | Request routing |

### Thinking Agents
| Agent | Purpose |
|-------|---------|
| deep-question-agent | Socratic questioning |
| first-principles-thinker | First principles analysis |
| blueprint-architect | Architecture design |
| algo-function-agent | Algorithm design |
| root-cause-agent | Root cause analysis |

### Specialized Agents
| Agent | Purpose |
|-------|---------|
| github-agent | GitHub operations |
| npm-agent | NPM package management |
| kanban-agent | Task management |
| ollama-agent | Local LLM integration |
| fb-post-agent | Facebook posting |
| daily-agent | Daily automation |
| one-page-agent | OPPM generation |
| white-hacker-agent | Security testing |
| taipm-agent | Personal assistant |
| language-tagger-agent | Language detection |
| ab-test-agent | A/B testing |

---

## Teams (20)

### Development Teams
| Team | Agents | Pattern |
|------|--------|---------|
| go-team | 12 | Pipeline (PM→Architect→Coder→Test→Security→Reviewer) |
| python-team | 6 | Pipeline |
| project-team | 17 | Orchestrated |
| backend-team | 8 | Specialized |

### Thinking Teams
| Team | Agents | Pattern |
|------|--------|---------|
| deep-thinking-team | 20+ | Parallel (Maestro + 20 thinkers) |
| diagram-team | 10 | Parallel (7 diagrammers) |

### Content Teams
| Team | Agents | Pattern |
|------|--------|---------|
| book-writer-team | 6 | Sequential |
| audiobook-production-team | 5 | Pipeline |
| youtube-team | 8 | Pipeline |
| toeic-content-team | 6 | Specialized |

### Analysis Teams
| Team | Agents | Pattern |
|------|--------|---------|
| math-team | 4 | Collaborative |
| mining-team | 5 | Dialogue |
| deep-research | 4 | Sequential |
| dev-algo | 3 | Collaborative |

### Collaboration Teams (Dialogue Pattern)
| Team | Roles | Purpose |
|------|-------|---------|
| dev-qa | Developer + QA | Test planning |
| dev-security | Developer + Security | Security review |
| dev-architect | Developer + Architect | System design |
| dev-user | Developer + User | Requirements |
| pm-dev | PM + Developer | Planning |

### Security Teams
| Team | Purpose |
|------|---------|
| hacker-security | Penetration testing |

---

## Architecture Patterns

### 5-Layer Model

```
Layer 1: META-ORCHESTRATION
├── Father Agent (creates/manages)
├── Agent Evaluator (validates)
└── Deep Thinking Team (reviews)

Layer 2: TEAM ORCHESTRATION
├── Maestro agents (coordinate)
├── Scribe agents (document)
└── Workflow engines

Layer 3: DOMAIN AGENTS
├── Language-specific (Go, Python)
├── Role-based (PM, Architect, Tester)
└── Specialist (Algorithm, Security)

Layer 4: KNOWLEDGE
├── Universal (thinking frameworks)
├── Domain (language patterns)
└── Local (agent-specific)

Layer 5: EXECUTION
├── Workflows (39+ definitions)
├── Skills (23+ reusable)
└── Kanban (task tracking)
```

### Communication Patterns
- **Pub/Sub**: Signal-based messaging
- **Topics**: exploration_complete, diagram_created, etc.
- **Sync Points**: wait_all, wait_any

### Parallel Execution
- **diagram-team**: 7 parallel workers
- **deep-thinking-team**: 20 parallel thinkers
- **go-team**: Sequential pipeline with parallel tests

---

## Key Relationships

### Agent Dependencies
```
father-agent
├── → deep-thinking-team (design review)
├── → agent-evaluator (validation)
└── → skill-creator-agent (skills)

deep-thinking-team
├── → maestro (orchestration)
├── → scribe (documentation)
└── → 20 thinkers (parallel)

go-team
├── → go-dev-agent
├── → go-refactor-agent
└── → go-review-linus-agent
```

### Knowledge Dependencies
```
.microai/knowledge/
├── registry.yaml (global index)
├── universal/ (thinking frameworks)
├── domains/
│   ├── go/ (Go patterns)
│   ├── security/ (security)
│   └── testing/ (testing)
└── agents/{agent}/knowledge-index.yaml
```

---

## Diagram Recommendations

| Diagram Type | Priority | Focus |
|--------------|----------|-------|
| 🏛️ Architecture | High | 5-layer model, agent ecosystem |
| ⏱️ Sequence | High | Father Agent workflow, team execution |
| 📦 Class | Medium | Agent/Team schemas |
| 🗄️ ERD | Medium | Entity relationships |
| 📂 Directory | High | Project structure |
| 🧠 Logic | Medium | Execution flow |
| 🎨 UI/UX | Medium | CLI states |

---

## Files for Diagramming

### Architecture Sources
- `.microai/teams/deep-thinking-team/ARCHITECTURE.md`
- `.microai/teams/diagram-team/ARCHITECTURE.md`
- `.microai/agents/father-agent/agent.md`

### Schema Sources
- `.microai/schemas/agent-v2.0.schema.yaml`
- `.microai/schemas/team-v1.0.schema.yaml`

### Workflow Sources
- `.microai/teams/*/workflow.md`
- `.microai/agents/*/workflows/*.yaml`

---

## Summary

| Metric | Value |
|--------|-------|
| Total Agents | 28 |
| Total Teams | 20 |
| Total Skills | 23+ |
| Workflow Files | 39+ |
| Knowledge Files | 50+ |
| Complexity | High |

---

*Generated by Explorer Agent - DTT-2026-01-04-DIAGRAM-002*
