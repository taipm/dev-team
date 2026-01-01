# Team Context

> Last updated: 2024-12-30 by backend-lead

## Team Mission

Backend Development Team cho bit-server-v2 project. Quản lý và phát triển:
- ask-it-server (Port 8092) - Main AI service
- gateway-server (Port 8099) - API Gateway
- auth-ldap-server (Port 8098) - Authentication

## Current Sprint/Focus

### Active Tasks
| Task | Assigned To | Status | Started |
|------|-------------|--------|---------|
| Team initialization | backend-lead | ✅ Done | 2024-12-30 |
| Create specialists | father-agent | ✅ Done | 2024-12-30 |
| Add agent creation skills | backend-lead | ✅ Done | 2024-12-30 |
| Create chat-agent | backend-lead | ✅ Done | 2024-12-30 |
| Create qdrant-agent | backend-lead | ✅ Done | 2024-12-30 |
| Create prompt-agent | backend-lead | ✅ Done | 2024-12-30 |
| Create admin-handler-agent | backend-lead | ✅ Done | 2024-12-30 |
| Create user-agent | backend-lead | ✅ Done | 2024-12-30 |
| Create config-agent | backend-lead | ✅ Done | 2024-12-30 |
| Create router-agent | backend-lead | ✅ Done | 2024-12-30 |
| Create test-agent | backend-lead | ✅ Done | 2024-12-30 |
| Move hpsm-agent to team dir | backend-lead | ✅ Done | 2024-12-30 |
| Move gateway-agent to team dir | backend-lead | ✅ Done | 2024-12-30 |
| Review hpsm-agent | - | ⏳ Pending | - |
| Review gateway-agent | - | ⏳ Pending | - |
| Create bugs-agent | backend-lead | ✅ Done | 2024-12-30 |

### Sprint Goal
Thiết lập Backend Team với đầy đủ specialists và memory system.

## Team Capabilities

Backend Lead giờ có khả năng:
- **`*add-specialist`**: Tạo specialist mới cho team (simplified workflow)
- **`*review-team`**: Review team structure và specialists
- **`*status`**: Xem team status
- **`*dispatch`**: Manual dispatch task cho specialist

Với tasks phức tạp, có thể delegate cho Father Agent (`/father *create`).

## Project State Overview

| Area | Owner | Status | Last Update |
|------|-------|--------|-------------|
| internal/agentic/ | agentic-agent | ✅ Ready | 2024-12-30 |
| internal/hpsm/ | hpsm-agent | ✅ Ready | 2024-12-30 |
| internal/database/ | mongodb-agent | ✅ Ready | 2024-12-30 |
| gateway-server/ | gateway-agent | ✅ Ready | 2024-12-30 |
| services/pattern/ | pattern-agent | ✅ Ready | 2024-12-30 |
| internal/middleware/ | middleware-agent | ✅ Ready | 2024-12-30 |
| handlers/chat*.go | chat-agent | ✅ Ready | 2024-12-30 |
| tools/qdrant*.go | qdrant-agent | ✅ Ready | 2024-12-30 |
| services/prompt_*.go | prompt-agent | ✅ Ready | 2024-12-30 |
| handlers/admin*.go | admin-handler-agent | ✅ Ready | 2024-12-30 |
| services/user_*.go | user-agent | ✅ Ready | 2024-12-30 |
| internal/config/ | config-agent | ✅ Ready | 2024-12-30 |
| services/agentrouter/ | router-agent | ✅ Ready | 2024-12-30 |
| tests/e2e/, tests/integration/ | test-agent | ✅ Ready | 2024-12-30 |
| bugs/, issues/ (virtual) | bugs-agent | ✅ Ready | 2024-12-30 |

## Team Members (15 specialists)

| Agent | Domain | Expertise | LOC |
|-------|--------|-----------|-----|
| agentic-agent | `internal/agentic/` | Budget, Crew, Pricing | ~2000 |
| hpsm-agent | `internal/hpsm/`, `tools/hpsm/` | HPSM tickets, OAuth | ~1500 |
| mongodb-agent | `internal/database/` | Schema, Indexes, Queries | ~1000 |
| gateway-agent | `gateway-server/` | API Gateway, Routing | ~3000 |
| pattern-agent | `services/pattern/` | Pattern CRUD, Catalog | ~2000 |
| middleware-agent | `internal/middleware/` | Auth, RBAC, Rate limiting | ~1500 |
| chat-agent | `handlers/chat*.go` | Chat, Streaming, Signals | ~5000 |
| qdrant-agent | `tools/qdrant*.go` | Vector search, RAG | ~1700 |
| prompt-agent | `services/prompt_*.go` | Prompt templates, Metrics | ~500 |
| admin-handler-agent | `handlers/admin*.go`, `admin/` | Admin API, Config, Backup | ~2500 |
| user-agent | `services/user_*.go`, `services/conversation_*.go` | User mgmt, Conversations | ~2800 |
| **config-agent** | `internal/config/` | Config, Secrets, Environment | ~2200 |
| **router-agent** | `services/agentrouter/`, `app/router.go` | Agent routing, HTTP routes | ~1600 |
| **test-agent** | `tests/e2e/`, `tests/integration/` | E2E, Integration, Coverage | ~2000+ |
| **bugs-agent** | `bugs/`, `issues/` (virtual) | Bug tracking, Kanban, 5Why, 5W2H | N/A |

**Total Coverage: ~29,300 LOC (~95% of codebase)**

## Dispatch History

| ID | Task | Agent | Status |
|----|------|-------|--------|
| D001 | Analyze chat_streaming.go | chat-agent | ✅ Done |
| D002 | Analyze qdrant tools | qdrant-agent | ✅ Done |
| D003 | Fix score_threshold | backend-lead | ✅ Done |

## Key Files Team Is Working On

- `.claude/agents/microai/teams/project-team/` - Team structure
- All specialist agent directories

## Dependencies & Integration Points

| Our Component | Depends On | Status |
|---------------|------------|--------|
| All specialists | backend-lead dispatch | Active |
| hpsm-agent | mongodb-agent (logging) | Pending |
| agentic-agent | pricing.go SSOT | Active |
| chat-agent | agentic-agent (budget) | Active |
| chat-agent | pattern-agent (prompts) | Active |
| qdrant-agent | chat-agent (RAG context) | Active |
| prompt-agent | chat-agent (rendering) | Active |
| user-agent | agentic-agent (budget) | Active |
| router-agent | chat-agent (signal routing) | Active |
| config-agent | all services (config loading) | Active |
| test-agent | all handlers/services (testing) | Active |
| bugs-agent | all team agents (bug tracking) | Active (silent) |

## Notes for Next Session
1. ~~Review existing hpsm-agent and gateway-agent~~ ✅ Done (moved to team dir, aligned with team standards)
2. ~~Fix score_threshold issue in qdrant (from D002)~~ ✅ Done
3. Fix streaming concerns (from D001)
4. ~~Consider adding Priority 3 agents~~ ✅ Done (added config, router, test agents)
