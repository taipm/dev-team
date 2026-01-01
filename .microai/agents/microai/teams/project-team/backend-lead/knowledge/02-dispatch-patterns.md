# Dispatch Patterns - Backend Lead

> Các patterns để dispatch tasks cho specialists hiệu quả.

---

## Pattern 1: Single Specialist

**Khi dùng:** Task thuộc hoàn toàn một domain.

```
User: "Fix bug trong budget tracking"

Analysis:
  - Domain: agentic (budget.go, budget_v2.go)
  - Single specialist: agentic-agent
  - No dependencies

Dispatch:
┌─────────────────────────────────────────────────────────────────────────┐
│ Task(                                                                    │
│   subagent_type: "agentic-agent",                                       │
│   prompt: """                                                            │
│   CONTEXT: User reports bug in budget tracking                          │
│                                                                          │
│   TASK: Investigate and fix the bug                                     │
│                                                                          │
│   FILES TO FOCUS:                                                        │
│   - internal/agentic/budget.go                                          │
│   - internal/agentic/budget_v2.go                                       │
│                                                                          │
│   EXPECTED OUTPUT:                                                       │
│   - Root cause analysis                                                  │
│   - Fix implementation                                                   │
│   - Test verification                                                    │
│   """,                                                                   │
│   description: "Fix budget tracking bug"                                │
│ )                                                                        │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Pattern 2: Parallel Investigation

**Khi dùng:** Cần thu thập thông tin từ nhiều domains cùng lúc.

```
User: "Performance issue khi gọi HPSM"

Analysis:
  - Cần investigate ở 3 domains:
    - agentic: timeout settings
    - hpsm: API latency
    - mongodb: query performance
  - Parallel-safe: không dependencies

Dispatch:
┌─────────────────────────────────────────────────────────────────────────┐
│ // Launch all 3 in parallel                                             │
│                                                                          │
│ Task(                                                                    │
│   subagent_type: "agentic-agent",                                       │
│   prompt: "Investigate timeout patterns in crew execution",             │
│   run_in_background: true,                                              │
│   description: "Check agentic timeouts"                                 │
│ )                                                                        │
│                                                                          │
│ Task(                                                                    │
│   subagent_type: "hpsm-agent",                                          │
│   prompt: "Profile HPSM API call latency, check OAuth flow",            │
│   run_in_background: true,                                              │
│   description: "Profile HPSM latency"                                   │
│ )                                                                        │
│                                                                          │
│ Task(                                                                    │
│   subagent_type: "mongodb-agent",                                       │
│   prompt: "Analyze query performance on hpsm_logs collection",          │
│   run_in_background: true,                                              │
│   description: "Check MongoDB performance"                              │
│ )                                                                        │
│                                                                          │
│ // Wait and collect results                                              │
│ results = TaskOutput(all task_ids, block: true)                         │
│                                                                          │
│ // Synthesize findings                                                   │
│ synthesize(results)                                                      │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Pattern 3: Sequential with Handoff

**Khi dùng:** Tasks có dependencies, output của task trước là input của task sau.

```
User: "Thêm retry mechanism cho HPSM và log failures vào MongoDB"

Analysis:
  - Task 1: Design schema (mongodb-agent) → output: schema definition
  - Task 2: Implement retry + logging (hpsm-agent) → uses schema
  - Dependency: Task 2 cần Task 1 hoàn thành

Dispatch:
┌─────────────────────────────────────────────────────────────────────────┐
│ // Phase 1: Schema first                                                 │
│ schema_result = Task(                                                    │
│   subagent_type: "mongodb-agent",                                       │
│   prompt: """                                                            │
│   Create failure logging schema for HPSM retries.                       │
│                                                                          │
│   Required fields:                                                       │
│   - timestamp                                                            │
│   - endpoint                                                             │
│   - error_message                                                        │
│   - retry_count                                                          │
│   - final_status                                                         │
│                                                                          │
│   Output: Schema definition and index recommendations                    │
│   """,                                                                   │
│   description: "Create failure schema"                                  │
│ )                                                                        │
│                                                                          │
│ // Phase 2: Use schema (after Phase 1)                                   │
│ Task(                                                                    │
│   subagent_type: "hpsm-agent",                                          │
│   prompt: """                                                            │
│   Implement retry mechanism with failure logging.                        │
│                                                                          │
│   Use this schema from mongodb-agent:                                    │
│   ${schema_result}                                                       │
│                                                                          │
│   Requirements:                                                          │
│   - Exponential backoff                                                  │
│   - Max 3 retries                                                        │
│   - Log each failure to MongoDB                                          │
│   """,                                                                   │
│   description: "Implement retry with logging"                           │
│ )                                                                        │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Pattern 4: Consultation

**Khi dùng:** Specialist cần expertise từ domain khác nhưng không cần full task.

```
User: "Implement cost tracking cho HPSM API calls"

Analysis:
  - Primary: hpsm-agent (implementation)
  - Consult: agentic-agent (pricing patterns)
  - Flow: Get patterns → Apply to HPSM

Dispatch:
┌─────────────────────────────────────────────────────────────────────────┐
│ // Step 1: Consult for patterns (quick, focused)                         │
│ pricing_patterns = Task(                                                 │
│   subagent_type: "agentic-agent",                                       │
│   prompt: """                                                            │
│   Provide pricing and cost tracking patterns used in agentic module.    │
│                                                                          │
│   Focus on:                                                              │
│   - How pricing.go defines costs                                         │
│   - How cost_tracker.go logs costs                                       │
│   - Interface/patterns to reuse                                          │
│                                                                          │
│   Output: Code snippets and patterns to apply                            │
│   """,                                                                   │
│   model: "haiku",  // Quick consultation                                │
│   description: "Get pricing patterns"                                   │
│ )                                                                        │
│                                                                          │
│ // Step 2: Primary implementation                                        │
│ Task(                                                                    │
│   subagent_type: "hpsm-agent",                                          │
│   prompt: """                                                            │
│   Implement cost tracking for HPSM API calls.                            │
│                                                                          │
│   Use these patterns from agentic module:                                │
│   ${pricing_patterns}                                                    │
│                                                                          │
│   Apply to internal/hpsm/client.go                                       │
│   """,                                                                   │
│   description: "Implement HPSM cost tracking"                           │
│ )                                                                        │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Pattern 5: Parallel Implementation

**Khi dùng:** Cùng loại changes ở multiple domains, độc lập.

```
User: "Refactor middleware chain ở cả ask-it-server và gateway-server"

Analysis:
  - Task 1: middleware-agent (ask-it-server)
  - Task 2: gateway-agent (gateway-server)
  - Parallel-safe: different codebases
  - Sync point: shared interface definition

Dispatch:
┌─────────────────────────────────────────────────────────────────────────┐
│ // Define shared interface first                                         │
│ interface_def = """                                                      │
│ type Middleware interface {                                              │
│     Handle(next http.Handler) http.Handler                               │
│     Name() string                                                        │
│     Priority() int                                                       │
│ }                                                                        │
│ """                                                                      │
│                                                                          │
│ // Parallel implementation                                               │
│ Task(                                                                    │
│   subagent_type: "middleware-agent",                                    │
│   prompt: """                                                            │
│   Refactor ask-it-server middleware to use interface:                    │
│   ${interface_def}                                                       │
│   """,                                                                   │
│   run_in_background: true,                                              │
│   description: "Refactor ask-it middleware"                             │
│ )                                                                        │
│                                                                          │
│ Task(                                                                    │
│   subagent_type: "gateway-agent",                                       │
│   prompt: """                                                            │
│   Refactor gateway-server middleware to use interface:                   │
│   ${interface_def}                                                       │
│   """,                                                                   │
│   run_in_background: true,                                              │
│   description: "Refactor gateway middleware"                            │
│ )                                                                        │
│                                                                          │
│ // Collect and verify consistency                                        │
│ results = TaskOutput(all task_ids)                                      │
│ verify_interface_compliance(results)                                     │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Pattern 6: Phased Rollout

**Khi dùng:** Large feature với multiple phases.

```
User: "Add comprehensive audit logging across the system"

Analysis:
  - Phase 1: Core infrastructure (mongodb-agent)
  - Phase 2: Integration points (parallel: multiple agents)
  - Phase 3: Verification (all agents)

Dispatch:
┌─────────────────────────────────────────────────────────────────────────┐
│ // PHASE 1: Infrastructure                                               │
│ infra = Task(                                                            │
│   subagent_type: "mongodb-agent",                                       │
│   prompt: "Create audit_logs collection with proper indexes",           │
│   description: "Phase 1: Audit infrastructure"                          │
│ )                                                                        │
│                                                                          │
│ // PHASE 2: Integration (parallel)                                       │
│ Task(agentic-agent, "Add audit logging to crew execution", background)  │
│ Task(hpsm-agent, "Add audit logging to ticket operations", background)  │
│ Task(pattern-agent, "Add audit logging to pattern changes", background) │
│                                                                          │
│ results_phase2 = TaskOutput(all phase 2 task_ids)                       │
│                                                                          │
│ // PHASE 3: Verification                                                 │
│ Task(                                                                    │
│   subagent_type: "mongodb-agent",                                       │
│   prompt: """                                                            │
│   Verify audit logging integration:                                      │
│   - Check all integrations write to audit_logs                          │
│   - Verify log format consistency                                        │
│   - Test query performance                                               │
│   """,                                                                   │
│   description: "Phase 3: Verify audit system"                           │
│ )                                                                        │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Decision Matrix

| Scenario | Pattern | Execution |
|----------|---------|-----------|
| Single domain task | Pattern 1 | Sequential |
| Multi-domain investigation | Pattern 2 | Parallel |
| Output → Input dependency | Pattern 3 | Sequential |
| Need expertise from other domain | Pattern 4 | Consult then implement |
| Same change in multiple places | Pattern 5 | Parallel |
| Large feature rollout | Pattern 6 | Phased |

---

## Model Selection

| Task Type | Model | Reason |
|-----------|-------|--------|
| Complex implementation | opus | Need deep reasoning |
| Investigation/Analysis | sonnet | Balance of speed and quality |
| Quick consultation | haiku | Fast, focused answers |
| Code review | sonnet | Good for pattern matching |
