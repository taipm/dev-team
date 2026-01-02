---
description: Commands Directory (project)
---

# MicroAI Commands Directory

> Slash commands để kích hoạt các agents và teams trong hệ sinh thái MicroAI.

## Usage

```bash
/microai:<command-name> [arguments]
```

## Available Commands

### Agents - Individual Specialists

| Command | Agent | Description |
|---------|-------|-------------|
| `/microai:deep-question` | Deep Question Agent | Đặt câu hỏi cốt tử với 7 phương pháp tư duy |
| `/microai:first-thinking` | First Principles Thinker | Break down complex problems to fundamental truths |
| `/microai:root-cause` | Root Cause Agent | Phân tích vấn đề đến gốc rễ với 9-step framework |
| `/microai:research` | Research Agent | Phân tích papers từ arXiv với 7 thinking frameworks |
| `/microai:npm` | NPM Agent | Chuyên gia npm: tạo installer, publish packages |
| `/microai:ollama` | Ollama Agent | Translation agent EN→VI sử dụng Ollama local |
| `/microai:kanban` | Kanban Agent | Task tracking and visualization |
| `/microai:github` | GitHub Agent | PRs, issues, branches, Actions, releases |
| `/microai:github-setup` | GitHub Setup | Repository setup and security audit |
| `/microai:fb-post` | Facebook Post Agent | Đăng bài lên Facebook Page qua Graph API |
| `/microai:skill-creator` | Skill Creator | Tạo, clone, analyze skills cho MicroAI |
| `/microai:father-agent` | Father Agent | Meta-agent tạo, clone, review agents |
| `/microai:white-hacker` | White Hacker | Security testing and penetration |
| `/microai:hpsm` | HPSM Agent | HPSM ticketing system integration |
| `/microai:gateway` | Gateway Agent | API Gateway, middleware, auth, rate limiting |
| `/microai:parallels` | Parallels VM Agent | Quản lý máy ảo Parallels Desktop trên Mac |

### Go Development

| Command | Description |
|---------|-------------|
| `/microai:go:go-team` | AI Coding Team cho Go - từ requirements đến release |
| `/microai:go:go-dev` | Go development specialist |
| `/microai:go:go-refactor` | Go refactoring với Risk-based batching + 5W2H |
| `/microai:go:go-review-linus` | Go Code Review - Linus Torvalds style |

### Teams - Multi-Agent Sessions

| Command | Description |
|---------|-------------|
| `/microai:python-team-session` | Full-stack development với 6 agents |
| `/microai:backend-team` | Backend Development Team cho bit-server-v2 |
| `/microai:deep-thinking` | Triệu tập Maestro và 20+ agents |
| `/microai:math-team` | Mathematical problem solving team |
| `/microai:youtube-team` | YouTube content creation team |
| `/microai:mine` | Mining Team - đào sâu insights từ nhiều góc độ |
| `/microai:book-writer-team-session` | Book Writer Team |

### Dialogue Sessions - Role-Based Simulations

| Command | Roles | Purpose |
|---------|-------|---------|
| `/microai:pm-dev-session` | PM ↔ Developer | Requirements, Tech Spec, Estimation |
| `/microai:dev-qa-session` | Dev ↔ QA | Test Plan, Bug Report, Code Review |
| `/microai:dev-architect-session` | Dev ↔ Architect | ADR, System Design, Architecture Review |
| `/microai:dev-security-session` | Dev ↔ Security | Security Review, Threat Model, Vulnerability |
| `/microai:dev-user-session` | Dev ↔ End User | User Story với Acceptance Criteria |
| `/microai:dev-algo-session` | Dev ↔ Algorithm | Algorithm design and optimization |
| `/microai:hacker-security-session` | Hacker ↔ Security | Security testing simulation |

## Quick Examples

```bash
# Quản lý VMs
/microai:parallels *list
/microai:parallels *start microai-club
/microai:parallels *ssh db-server

# Go development
/microai:go:go-dev implement feature X
/microai:go:go-review-linus review this PR

# Team sessions
/microai:pm-dev-session refine requirements for login feature
/microai:deep-thinking solve complex architecture problem

# Research & Analysis
/microai:research analyze paper on transformers
/microai:root-cause investigate production outage
```

## Creating New Commands

See `/microai:father-agent *create` to create new agents, or manually:

1. Create agent in `.microai/agents/<name>/agent.md`
2. Create command in `.claude/commands/microai/<name>.md`
3. Register in `.microai/knowledge/registry.yaml` (optional)

## Directory Structure

```
.claude/commands/microai/
├── README.md                    # This file
├── parallels.md                 # VM management
├── deep-question.md             # Deep questioning
├── deep-thinking.md             # Multi-agent thinking
├── deep-thinking/               # Sub-commands
│   ├── feynman.md
│   ├── socrates.md
│   └── ...
├── go/                          # Go development
│   ├── go-team.md
│   ├── go-dev.md
│   └── ...
└── ...
```
