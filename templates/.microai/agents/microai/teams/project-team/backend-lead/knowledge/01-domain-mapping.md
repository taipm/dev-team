# Domain Mapping - Backend Project

> Chi tiết về domain ownership và file mappings cho mỗi specialist.

---

## Specialist Domain Matrix

### 1. agentic-agent

```yaml
domain: Core Engine & Orchestration
primary_paths:
  - src/backend/ask-it-server/internal/agentic/
  - src/backend/ask-it-server/services/crew/
  - src/backend/ask-it-server/services/agentrouter/

key_files:
  - internal/agentic/agent.go           # Single agent execution
  - internal/agentic/crew.go            # Multi-agent coordination
  - internal/agentic/budget.go          # Budget v1
  - internal/agentic/budget_v2.go       # Budget v2 (new)
  - internal/agentic/pricing.go         # SINGLE SOURCE OF TRUTH for prices
  - internal/agentic/token_counter.go   # Token counting
  - internal/agentic/tool_execution.go  # Tool execution engine
  - internal/agentic/timeout_tracker.go # Timeout management
  - internal/agentic/streaming.go       # SSE streaming
  - services/crew/service.go            # Crew service facade

expertise:
  - Token budget tracking (v1 & v2)
  - Crew routing và signal handling
  - Agent execution flow
  - Cost calculation và pricing
  - Timeout management
  - Streaming responses

keywords:
  - budget
  - token
  - cost
  - crew
  - agent
  - pricing
  - timeout
  - streaming
  - orchestration
```

### 2. hpsm-agent

```yaml
domain: HPSM Integration
primary_paths:
  - src/backend/ask-it-server/internal/hpsm/
  - src/backend/ask-it-server/tools/hpsm/

key_files:
  - internal/hpsm/client.go             # HTTP client with OAuth2
  - internal/hpsm/config.go             # HPSM configuration
  - internal/hpsm/models/               # Request/response models
  - tools/hpsm/create_ticket_tool.go    # Ticket creation
  - tools/hpsm/detect_situation.go      # Situation detection
  - tools/hpsm/routing_matcher.go       # Priority/Impact routing
  - tools/hpsm/user_context.go          # User context extraction
  - tools/hpsm/close.go                 # Ticket closing
  - tools/hpsm/list.go                  # Ticket listing

expertise:
  - OAuth2 authentication flow
  - Ticket CRUD operations
  - Priority/Impact detection
  - Routing rule matching
  - HPSM API integration
  - Auto-retry với token refresh

keywords:
  - ticket
  - HPSM
  - interaction
  - routing rule
  - OAuth
  - priority
  - impact
  - subcategory
  - assignment group
```

### 3. mongodb-agent

```yaml
domain: Data Layer
primary_paths:
  - src/backend/ask-it-server/internal/database/

key_files:
  - internal/database/provider.go           # Thread-safe DB provider
  - internal/database/schema.go             # Collection schemas
  - internal/database/indexes.go            # Database indexes
  - internal/database/conversation_indexes.go # Conversation indexes
  - internal/database/validation.go         # Schema validation

collections:
  - conversations        # Chat history
  - patterns            # Pattern definitions
  - hpsm_logs           # HPSM interactions
  - user_activity_logs  # User tracking
  - pattern_audit_logs  # Change history
  - llm_cost_logs       # Cost tracking

expertise:
  - Provider pattern implementation
  - Index design và optimization
  - Schema validation
  - Query optimization
  - Collection management

keywords:
  - collection
  - index
  - schema
  - query
  - MongoDB
  - database
  - provider
  - validation
```

### 4. gateway-agent

```yaml
domain: API Gateway
primary_paths:
  - src/backend/gateway-server/

key_files:
  - gateway-server/internal/orchestrator/ai_router.go
  - gateway-server/internal/orchestrator/context_builder.go
  - gateway-server/internal/orchestrator/memory.go
  - gateway-server/internal/middleware/
  - gateway-server/internal/validator/
  - gateway-server/handlers/

expertise:
  - API routing
  - Service orchestration
  - Context management
  - Request validation
  - Gateway middleware

keywords:
  - gateway
  - proxy
  - orchestrator
  - routing (gateway level)
  - request validation
```

### 5. pattern-agent

```yaml
domain: Pattern & Catalog Management
primary_paths:
  - src/backend/ask-it-server/services/pattern/
  - src/backend/ask-it-server/internal/catalog/

key_files:
  - services/pattern/service.go             # Pattern service facade
  - services/pattern/service_crud.go        # CRUD operations
  - services/pattern/service_permissions.go # RBAC
  - services/pattern/service_publish.go     # Publishing workflow
  - internal/catalog/service.go             # Catalog management
  - internal/catalog/watcher.go             # Hot reload
  - internal/catalog/validator.go           # Pattern validation

expertise:
  - Pattern CRUD operations
  - Permission management
  - Publishing workflows
  - Hot reload implementation
  - Catalog validation

keywords:
  - pattern
  - capability
  - catalog
  - publish
  - hot reload
  - permission
  - validation
```

### 6. middleware-agent

```yaml
domain: Security & Middleware
primary_paths:
  - src/backend/ask-it-server/internal/middleware/

key_files:
  - internal/middleware/auth.go           # JWT authentication
  - internal/middleware/pattern_rbac.go   # Pattern-based RBAC
  - internal/middleware/rate_limiter.go   # Rate limiting
  - internal/middleware/cors.go           # CORS handling
  - internal/middleware/logging.go        # Request logging
  - internal/middleware/error.go          # Error handling

expertise:
  - JWT validation
  - RBAC enforcement
  - Rate limiting strategies
  - Middleware chain design
  - Security best practices

keywords:
  - auth
  - JWT
  - RBAC
  - rate limit
  - middleware
  - security
  - permission
  - cors
```

---

## Cross-Domain Dependencies

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    DEPENDENCY GRAPH                                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  agentic-agent ──uses──→ mongodb-agent (cost logging)                   │
│       │                                                                  │
│       └──calls──→ hpsm-agent (tool execution)                           │
│                                                                          │
│  hpsm-agent ──uses──→ mongodb-agent (hpsm_logs)                         │
│       │                                                                  │
│       └──uses──→ agentic-agent (pricing constants)                      │
│                                                                          │
│  pattern-agent ──uses──→ mongodb-agent (pattern storage)                │
│       │                                                                  │
│       └──uses──→ middleware-agent (permission checks)                   │
│                                                                          │
│  gateway-agent ──routes──→ all specialists (via services)               │
│                                                                          │
│  middleware-agent ──protects──→ all handlers                            │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## File Path Patterns

```bash
# Khi user đề cập file path, map to specialist:

**/internal/agentic/**     → agentic-agent
**/services/crew/**        → agentic-agent
**/services/agentrouter/** → agentic-agent

**/internal/hpsm/**        → hpsm-agent
**/tools/hpsm/**           → hpsm-agent

**/internal/database/**    → mongodb-agent

**/gateway-server/**       → gateway-agent

**/services/pattern/**     → pattern-agent
**/internal/catalog/**     → pattern-agent

**/internal/middleware/**  → middleware-agent
```
