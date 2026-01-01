# Agents có sẵn

Danh sách agents được cài đặt cùng @microai.club/dev-team.

---

## Agents chính

### Father Agent

**Vị trí:** `.microai/agents/father-agent/`

Meta-agent để tạo và quản lý các agents khác.

| Property | Value |
|----------|-------|
| Command | `/microai:father` |
| Model | opus |
| Capabilities | create, clone, review, list agents |

**Use cases:**
- Tạo agent mới theo template
- Clone và customize agent có sẵn
- Review agent definitions

**Chi tiết:** [.microai/agents/father-agent/agent.md](../../.microai/agents/father-agent/agent.md)

---

### Go Dev Agent

**Vị trí:** `.microai/agents/microai/agents/go-dev-agent.md`

Chuyên gia phát triển Go với knowledge base về patterns, anti-patterns.

| Property | Value |
|----------|-------|
| Command | `/microai:go:go-dev` |
| Model | sonnet |
| Tools | Read, Write, Edit, Bash, Grep, Glob |

**Knowledge base:**
- Concurrency patterns
- HTTP patterns
- Graceful shutdown
- CLI patterns
- LLM integration (OpenAI, Ollama)

**Chi tiết:** [.microai/agents/microai/agents/go-dev-agent.md](../../.microai/agents/microai/agents/go-dev-agent.md)

---

### Go Refactor Agent

**Vị trí:** `.microai/agents/go-refactor-portable/`

Chuyên gia refactoring Go với 5W2H workflow.

| Property | Value |
|----------|-------|
| Command | `/microai:go:go-refactor` |
| Model | sonnet |
| Approach | Risk-based batching |

**Features:**
- 2-layer knowledge (GLOBAL + PROJECT)
- Automatic metrics tracking
- Auto-generated reports

**Chi tiết:** [.microai/agents/go-refactor-portable/README.md](../../.microai/agents/go-refactor-portable/README.md)

---

### Go Review Agent (Linus Style)

**Vị trí:** `.microai/agents/microai/agents/go-review-linus-agent.md`

Code review chất lượng cao theo phong cách Linus Torvalds.

| Property | Value |
|----------|-------|
| Command | `/microai:go:go-review-linus` |
| Model | sonnet |
| Style | Brutally honest |

**Knowledge areas:**
- Go idioms
- Concurrency rules
- Security checks
- Performance tips
- Hardcode patterns

**Chi tiết:** [.microai/agents/microai/agents/go-review-linus-agent.md](../../.microai/agents/microai/agents/go-review-linus-agent.md)

---

### First Principles Thinker

**Vị trí:** `.microai/agents/microai/agents/first-principles-thinker.md`

Agent cho phân tích vấn đề theo first principles.

| Property | Value |
|----------|-------|
| Command | `/microai:first-thinking` |
| Model | sonnet |
| Approach | Socratic questioning |

**Use cases:**
- Break down complex problems
- Challenge assumptions
- Find root causes

**Chi tiết:** [.microai/agents/microai/agents/first-principles-thinker.md](../../.microai/agents/microai/agents/first-principles-thinker.md)

---

### GitHub Agent

**Vị trí:** `.microai/agents/microai/agents/github-agent.md`

Quản lý GitHub operations.

| Property | Value |
|----------|-------|
| Command | `/microai:github` |
| Tools | Bash, Read, Grep |

**Capabilities:**
- PRs, issues, branches
- GitHub Actions
- Releases

**Chi tiết:** [.microai/agents/microai/agents/github-agent.md](../../.microai/agents/microai/agents/github-agent.md)

---

### NPM Agent

**Vị trí:** `.microai/agents/npm-agent/`

Chuyên gia npm package management.

| Property | Value |
|----------|-------|
| Command | `/microai:npm` |
| Capabilities | publish, manage deps, create installers |

**Chi tiết:** [.microai/agents/npm-agent/](../../.microai/agents/npm-agent/)

---

## Teams

### Project Team

**Vị trí:** `.microai/agents/microai/teams/project-team/`

Team agents cho một project cụ thể:

| Agent | Vai trò |
|-------|---------|
| gateway-agent | API gateway patterns |
| user-agent | User management |
| chat-agent | Chat/conversation |
| test-agent | Testing |
| config-agent | Configuration |
| mongodb-agent | MongoDB operations |
| bugs-agent | Bug tracking |
| middleware-agent | Middleware patterns |
| router-agent | Routing logic |
| prompt-agent | Prompt engineering |
| hpsm-agent | Service management |
| userhub-agent | User hub operations |
| agentic-agent | Agentic framework |
| pattern-agent | Design patterns |
| qdrant-agent | Vector database |
| admin-handler-agent | Admin operations |
| backend-lead | Backend leadership |

---

### Go Team

**Vị trí:** `.microai/agents/microai/teams/go-team/`

Team chuyên biệt cho Go development.

---

### Mining Team

**Vị trí:** `.microai/agents/microai/teams/mining-team/`

Team cho deep analysis với 4 agents:
- Socrates
- Contrarian
- Sherlock
- Ops

6-phase workflow cho comprehensive analysis.

**Chi tiết:** [.microai/agents/microai/teams/mining-team/README.md](../../.microai/agents/microai/teams/mining-team/README.md)

---

### Dev-User Team

**Vị trí:** `.microai/agents/microai/teams/dev-user/`

Team simulation giữa Solo Developer và End User.

| Property | Value |
|----------|-------|
| Command | `/microai:dev-user-session` |
| Purpose | Generate User Stories with Acceptance Criteria |

---

## Sử dụng Agents

### Qua Slash Command

```
/microai:father create
/microai:go:go-dev
/microai:github
```

### Qua yêu cầu trực tiếp

```
Use the go-dev agent to implement this feature.
```

### Qua Task tool

```
Launch the first-principles-thinker agent to analyze this problem.
```

---

## Tiếp theo

- [Agent Gallery](./agent-gallery.md) - Showcase các agents hay
- [Tạo Agent](../guides/creating-agents.md) - Tạo agent của riêng bạn
- [Agent Overview](./overview.md) - Kiến trúc agent ecosystem
