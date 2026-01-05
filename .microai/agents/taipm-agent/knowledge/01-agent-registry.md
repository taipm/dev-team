# Agent & Team Registry

> Catalog đầy đủ tất cả agents và teams trong hệ thống dev-team.
> Taipm Agent sử dụng file này để routing decisions.

---

## Standalone Agents (25)

### Tier 1: Production-Ready (High Maturity)

| Agent | Icon | Description | Best For |
|-------|------|-------------|----------|
| **father-agent** | 👨‍👦 | Meta-agent tạo và quản lý agents | Tạo agent mới, clone, review agents |
| **agent-evaluator** | 📊 | Đánh giá intelligence của agents | Test và benchmark agents |
| **go-dev-agent** | 🔧 | Go development specialist | Implement Go code |
| **go-review-linus-agent** | 🐧 | Code review theo phong cách Linus | Review Go code brutally honest |
| **go-refactor-agent** | 🔄 | Refactoring specialist cho Go | Refactor với risk-based batching |
| **deep-question-agent** | 🔮 | Socrates - đặt câu hỏi sâu | Phân tích, tìm blind spots |
| **white-hacker-agent** | 🔓 | Security testing specialist | Pentest, security audit |
| **algo-function-agent** | 🧠 | Algorithm design specialist | Thiết kế algorithm, pseudocode |
| **blueprint-architect** | 📐 | Solution architect | System design, blueprints |

### Tier 2: Well-Developed (Medium Maturity)

| Agent | Icon | Description | Best For |
|-------|------|-------------|----------|
| **daily-agent** | 📅 | Daily task automation | Morning briefing, task queue |
| **root-cause-agent** | 🔍 | 9-step root cause analysis | Tìm nguyên nhân gốc |
| **ollama-agent** | 🦙 | Local LLM integration | Dịch thuật, tóm tắt, Q&A offline |
| **ollama-auto-agent** | 🤖 | Auto 5-Why với Ollama | Root cause tự động |
| **fb-post-agent** | 📘 | Facebook posting | Đăng bài Facebook Page |
| **one-page-agent** | 📄 | One-page project management | OPPM visualization |
| **npm-agent** | 📦 | NPM package specialist | Publish, dependencies |
| **skill-creator-agent** | ⚡ | Skill creation specialist | Tạo skills mới |
| **language-tagger-agent** | 🏷️ | Language tagging | Tag nội dung đa ngôn ngữ |
| **ab-test-agent** | 🧪 | A/B testing specialist | Experiment design |

### Tier 3: Stub/Basic (Low Maturity - Needs Development)

| Agent | Icon | Description | Status |
|-------|------|-------------|--------|
| **kanban-agent** | 📋 | Kanban board management | Minimal - needs expansion |
| **github-agent** | 🐙 | GitHub operations | Minimal - needs expansion |
| **first-principles-thinker** | 💭 | First principles thinking | Stub only |

### Symlinks (Point to Team Agents)

| Agent | Points To |
|-------|-----------|
| config-agent | project-team/config-agent |
| router-agent | project-team/router-agent |
| test-agent | project-team/test-agent |

---

## Multi-Agent Teams (20)

### Tier 1: Production Teams (Fully Developed)

| Team | Icon | Agents | Description | Best For |
|------|------|--------|-------------|----------|
| **deep-thinking-team** | 🧠 | 20 | Expert panel với Maestro | Complex analysis, strategic decisions |
| **go-team** | 🔵 | 11 | Full Go development | Go projects end-to-end |
| **youtube-team** | 🎬 | 8+ | Video production | YouTube content creation |
| **math-team** | ➗ | 5+ | IMO-level problem solving | Math problems (E/M/H/X) |
| **audiobook-production-team** | 🎧 | 6+ | Audiobook creation | URL → MP3 audiobook |
| **toeic-content-team** | 📚 | 5+ | TOEIC learning content | Vocabulary lessons, videos |

### Tier 2: Well-Developed Teams

| Team | Icon | Description | Best For |
|------|------|-------------|----------|
| **python-team** | 🐍 | Python development team | Python projects |
| **project-team** | 📁 | Full project lifecycle (18 agents) | Large projects |
| **one-page-team** | 📄 | One-page project planning | Project visualization |
| **book-writer-team** | 📖 | Book writing pipeline | Books, long-form content |
| **deep-research** | 🔬 | Research team | arXiv papers, deep dives |

### Tier 3: Collaboration Teams (Dialogue-Based)

| Team | Icon | Pattern | Best For |
|------|------|---------|----------|
| **dev-qa** | 🧪 | Developer ↔ QA Engineer | Test plans, bug reports |
| **dev-architect** | 🏗️ | Developer ↔ Solution Architect | ADR, system design |
| **dev-security** | 🔐 | Developer ↔ Security Engineer | Security review, threat model |
| **pm-dev** | 📋 | PM ↔ Developer | Requirements, estimation |
| **dev-user** | 👤 | Developer ↔ End User | User stories, acceptance criteria |
| **dev-algo** | 🧮 | Developer ↔ Algorithm Specialist | Algorithm design sessions |

### Tier 4: Specialized Teams (Early Stage)

| Team | Icon | Description | Status |
|------|------|-------------|--------|
| **mining-team** | ⛏️ | Insight mining | Early stage |
| **hacker-security** | 💀 | Security testing | Stub - needs templates |

---

## Quick Reference: Intent → Agent/Team

```yaml
# Content Creation
audiobook: audiobook-production-team
video/youtube: youtube-team
toeic/vocabulary: toeic-content-team
book/writing: book-writer-team
facebook/post: fb-post-agent

# Development
go/implement: go-dev-agent
go/review: go-review-linus-agent
go/refactor: go-refactor-agent
python: python-team
algorithm/design: algo-function-agent

# Analysis & Thinking
deep/analysis: deep-thinking-team
question/explore: deep-question-agent
root-cause: root-cause-agent
research/paper: deep-research
math/problem: math-team

# Planning & Management
project/plan: project-team
one-page/oppm: one-page-agent
daily/tasks: daily-agent
kanban: kanban-agent

# Meta & Tools
create/agent: father-agent
evaluate/agent: agent-evaluator
create/skill: skill-creator-agent
npm/package: npm-agent
github: github-agent

# Security
security/pentest: white-hacker-agent
security/review: dev-security

# Collaboration Sessions
qa/test: dev-qa
architect/design: dev-architect
requirements: pm-dev
user-story: dev-user
```

---

## Capability Matrix

| Capability | Primary Agent/Team | Backup |
|------------|-------------------|--------|
| Go Development | go-team | go-dev-agent |
| Code Review | go-review-linus-agent | dev-qa |
| Architecture | deep-thinking-team | dev-architect |
| Content Creation | youtube-team | audiobook-production-team |
| Research | deep-research | deep-thinking-team |
| Problem Solving | math-team | deep-thinking-team |
| Daily Operations | daily-agent | taipm-agent (direct) |
| Agent Creation | father-agent | - |
| Security | white-hacker-agent | dev-security |

---

*Registry maintained by Taipm Agent. Last updated: 2026-01-04*
