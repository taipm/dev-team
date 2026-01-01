# 05 - Memory System | Hệ thống Memory

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

The Memory System enables **session continuity** across agent invocations, allowing agents to maintain context, track decisions, and learn patterns.

Hệ thống Memory cho phép **liên tục phiên làm việc** giữa các lần gọi agent, cho phép agent duy trì context, theo dõi quyết định và học các pattern.

---

## Directory Structure | Cấu trúc thư mục

```
.microai/agents/{agent-name}/
├── agent.md                        # Main agent definition
├── knowledge/                      # Static knowledge (see 04)
└── memory/
    ├── context.md                  # Current session state
    ├── decisions.md                # Key decisions log
    ├── learnings.md                # Patterns learned
    └── sessions/                   # Optional: archived sessions
        ├── 2025-12-30.md
        └── 2025-12-31.md
```

---

## Memory Files | Các file Memory

### context.md - Current State | Trạng thái hiện tại

**Purpose | Mục đích**: Track active work, blockers, and next steps.

```markdown
# Current Context

> Last updated: 2025-12-31

---

## Active Focus | Đang tập trung

- [ ] Implementing user authentication module
- [ ] Fixing race condition in worker pool
- [x] Completed database schema design

---

## Project State | Trạng thái dự án

| Aspect | Status | Notes |
|--------|--------|-------|
| Build | ✅ Passing | All tests green |
| Security | ⚠️ Review needed | Auth module pending |
| Performance | ✅ Good | 50ms avg response |

---

## Key Files | File quan trọng

| File | State | Notes |
|------|-------|-------|
| `internal/auth/handler.go` | In progress | JWT implementation |
| `internal/worker/pool.go` | Needs review | Race condition reported |
| `api/routes.go` | Complete | All endpoints documented |

---

## Blockers | Điểm nghẽn

- [ ] Waiting for security team approval on auth design
- [ ] Need decision on rate limiting strategy

---

## Next Session Should | Phiên tiếp theo nên

1. Continue JWT implementation in auth handler
2. Review worker pool race condition fix
3. Update API documentation

---

## Notes | Ghi chú

- Consider using `errgroup` for worker pool
- Rate limiting: prefer token bucket algorithm
```

### decisions.md - Decision Log | Nhật ký quyết định

**Purpose | Mục đích**: Record important decisions for future reference.

```markdown
# Key Decisions Log | Nhật ký quyết định quan trọng

---

## 2025-12-31: JWT vs Session-based Authentication

**Context | Bối cảnh**:
Building user authentication for API. Need to choose between JWT tokens and traditional session-based auth.

**Decision | Quyết định**:
Use JWT with short-lived access tokens (15min) and refresh tokens (7 days).

**Reason | Lý do**:
- Stateless: scales horizontally without shared session store
- Mobile-friendly: easier token management
- Microservices-ready: tokens work across services

**Alternatives Considered | Các phương án đã xem xét**:
- Session + Redis: rejected due to operational complexity
- OAuth2 only: overkill for current requirements

**Impact | Ảnh hưởng**:
- Need to implement token refresh endpoint
- Frontend must handle token expiration gracefully

**Reversible | Có thể đảo ngược**: Yes, with migration effort

---

## 2025-12-30: PostgreSQL as Primary Database

**Context | Bối cảnh**:
Choosing database for user data and transactions.

**Decision | Quyết định**:
PostgreSQL 15+ with pgx driver.

**Reason | Lý do**:
- ACID compliance for transactions
- JSON support for flexible schemas
- Excellent Go driver ecosystem (pgx)

**Alternatives Considered | Các phương án đã xem xét**:
- MongoDB: rejected, need strong consistency
- MySQL: acceptable but less feature-rich

**Impact | Ảnh hưởng**:
- Use sqlc for type-safe queries
- Need connection pooling (pgxpool)

**Reversible | Có thể đảo ngược**: No, high migration cost

---
```

### learnings.md - Patterns Learned | Các pattern đã học

**Purpose | Mục đích**: Capture reusable patterns discovered during work.

```markdown
# Patterns Learned | Các pattern đã học

> Accumulated insights from this codebase
> Các insight tích lũy từ codebase này

---

## 2025-12-31: Graceful HTTP Server Shutdown

**Pattern | Mẫu**:
Always use `context.WithTimeout` for shutdown, not indefinite wait.

**Code | Code**:
```go
// Good - bounded shutdown
ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
defer cancel()
if err := server.Shutdown(ctx); err != nil {
    log.Error("shutdown timeout", "err", err)
}

// Bad - can hang forever
server.Shutdown(context.Background())
```

**Why | Tại sao**:
Prevents hung connections from blocking deployment. Forces cleanup within SLA.

---

## 2025-12-30: Error Wrapping Convention

**Pattern | Mẫu**:
Wrap errors with operation context, not just message.

**Code | Code**:
```go
// Good - includes operation
return fmt.Errorf("load user id=%s: %w", userID, err)

// Bad - vague
return fmt.Errorf("failed to load: %w", err)
```

**Why | Tại sao**:
Makes debugging easier. Error chain shows exact operation that failed.

---

## 2025-12-29: Worker Pool Size Heuristic

**Pattern | Mẫu**:
For I/O-bound work: workers = 2 * num_cpu. For CPU-bound: workers = num_cpu.

**Code | Code**:
```go
// I/O bound (HTTP calls, DB queries)
poolSize := runtime.NumCPU() * 2

// CPU bound (computation)
poolSize := runtime.NumCPU()
```

**Why | Tại sao**:
I/O workers spend time waiting, so more can run concurrently. CPU workers compete for cores.

---
```

### sessions/ - Session Archives | Lưu trữ phiên

**Purpose | Mục đích**: Optional archive of complex or long sessions.

```markdown
# Session: 2025-12-31

> Archived session for reference
> Phiên làm việc lưu trữ để tham khảo

---

## Summary | Tóm tắt

Implemented JWT authentication module with refresh token support.

---

## Tasks Completed | Task hoàn thành

1. ✅ Created `internal/auth/jwt.go` with token generation
2. ✅ Added refresh endpoint `/api/v1/auth/refresh`
3. ✅ Wrote unit tests (92% coverage)
4. ✅ Updated API documentation

---

## Key Changes | Thay đổi chính

| File | Change |
|------|--------|
| `internal/auth/jwt.go` | New file - JWT utilities |
| `internal/auth/handler.go` | Added login, refresh endpoints |
| `api/routes.go` | Registered auth routes |

---

## Issues Encountered | Vấn đề gặp phải

1. **Token validation timing attack**
   - Problem: Using `==` for token comparison
   - Solution: Use `subtle.ConstantTimeCompare`

2. **Refresh token rotation**
   - Problem: Race condition when multiple requests refresh same token
   - Solution: Use database transaction with row locking

---

## Follow-up Items | Việc cần theo dõi

- [ ] Implement token blacklist for logout
- [ ] Add rate limiting to login endpoint
- [ ] Security review before production

---
```

---

## Memory Lifecycle | Vòng đời Memory

### Agent Activation | Kích hoạt Agent

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: Load context.md                                     │
│ ════════════════════════                                    │
│ • Read current state, active tasks, blockers                │
│ • Understand what was being worked on                       │
│ • Đọc trạng thái, task đang làm, điểm nghẽn                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 2: Scan decisions.md                                   │
│ ═══════════════════════════                                 │
│ • Review recent decisions (last 5-10)                       │
│ • Understand why things are done certain way                │
│ • Xem lại quyết định gần đây                               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 3: Ready for user task                                 │
│ ════════════════════════════                                │
│ • Apply context to new task                                 │
│ • Reference learnings.md as needed                          │
│ • Sẵn sàng nhận task từ user                               │
└─────────────────────────────────────────────────────────────┘
```

### During Session | Trong phiên làm việc

```python
def during_session():
    """
    Memory operations during active session.
    Các thao tác memory trong phiên làm việc.
    """
    # Reference learnings for patterns
    # Tham khảo learnings cho các pattern
    if facing_familiar_problem():
        check_learnings_md()

    # Update context for significant changes
    # Cập nhật context cho thay đổi quan trọng
    if significant_state_change():
        update_context_md()

    # No need to constantly update - wait for session end
    # Không cần cập nhật liên tục - đợi kết thúc phiên
```

### Session End | Kết thúc phiên

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: Update context.md                                   │
│ ════════════════════════════                                │
│ • Update active focus with completed/remaining tasks        │
│ • Update project state table                                │
│ • Add new blockers or remove resolved ones                  │
│ • Update "Next Session Should" section                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 2: Log decisions to decisions.md                       │
│ ═════════════════════════════════════                       │
│ • Add any significant decisions made                        │
│ • Include context, alternatives, reasoning                  │
│ • Only log decisions that affect future work                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 3: Add patterns to learnings.md                        │
│ ══════════════════════════════════════                      │
│ • Capture any new patterns discovered                       │
│ • Include code examples                                     │
│ • Explain why the pattern is useful                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 4 (Optional): Archive session                          │
│ ══════════════════════════════════════                      │
│ • For complex sessions with many changes                    │
│ • Create sessions/YYYY-MM-DD.md                            │
│ • Include summary, tasks, issues encountered                │
└─────────────────────────────────────────────────────────────┘
```

---

## Implementation Requirements | Yêu cầu implement

### For Level 2 Compliance | Cho tuân thủ Level 2

Adapters MUST:

1. **Load memory on activation**
   - Read context.md if exists
   - Read decisions.md (last 10 entries)
   - Handle missing files gracefully

2. **Inject memory into prompt**
   - Prepend to agent system prompt
   - Format clearly with section headers

3. **Persist memory on session end**
   - Update context.md with new state
   - Append decisions if any
   - Create files if don't exist

4. **Provide memory update APIs**
   - Allow agent to request memory updates
   - Support partial updates (single file)

### Memory Loading Algorithm | Thuật toán load Memory

```python
def load_memory(agent_path: str) -> Memory:
    """
    Load memory for agent activation.
    Load memory cho kích hoạt agent.
    """
    memory_dir = f"{agent_path}/memory"
    memory = Memory()

    # Load context (entire file)
    context_path = f"{memory_dir}/context.md"
    if file_exists(context_path):
        memory.context = read_file(context_path)

    # Load recent decisions (last 10)
    decisions_path = f"{memory_dir}/decisions.md"
    if file_exists(decisions_path):
        all_decisions = parse_decisions(read_file(decisions_path))
        memory.decisions = all_decisions[-10:]  # Last 10

    # Learnings loaded on-demand, not at activation
    # Learnings được load theo yêu cầu, không lúc kích hoạt

    return memory


def save_memory(agent_path: str, memory: Memory) -> None:
    """
    Save memory at session end.
    Lưu memory khi kết thúc phiên.
    """
    memory_dir = f"{agent_path}/memory"
    ensure_directory_exists(memory_dir)

    # Always overwrite context
    write_file(f"{memory_dir}/context.md", memory.context)

    # Append new decisions
    if memory.new_decisions:
        decisions_path = f"{memory_dir}/decisions.md"
        existing = read_file(decisions_path) if file_exists(decisions_path) else ""
        new_content = format_decisions(memory.new_decisions)
        write_file(decisions_path, existing + "\n" + new_content)

    # Append new learnings
    if memory.new_learnings:
        learnings_path = f"{memory_dir}/learnings.md"
        existing = read_file(learnings_path) if file_exists(learnings_path) else ""
        new_content = format_learnings(memory.new_learnings)
        write_file(learnings_path, existing + "\n" + new_content)
```

### Memory Injection Format | Định dạng inject Memory

```markdown
## Agent Memory | Memory của Agent

### Current Context | Context hiện tại

{content of context.md}

### Recent Decisions | Quyết định gần đây

{last 10 entries from decisions.md}

---

{Rest of agent prompt}
```

---

## Best Practices | Thực hành tốt nhất

### 1. Keep context.md Focused | Giữ context.md tập trung

```markdown
<!-- Good - Actionable, current -->
## Active Focus
- [ ] Fix auth token expiration bug
- [ ] Add rate limiting to API

<!-- Bad - Vague, outdated -->
## Things
- Working on stuff
- Maybe do auth later
```

### 2. Log Significant Decisions Only | Chỉ log quyết định quan trọng

```markdown
<!-- Good - Architectural decision -->
## 2025-12-31: Use Redis for Session Store
Context: Need distributed session storage...

<!-- Bad - Trivial choice -->
## 2025-12-31: Use tabs instead of spaces
Context: Formatting decision...
```

### 3. Include Code in Learnings | Bao gồm code trong Learnings

```markdown
<!-- Good - Code example included -->
## Pattern: Context Cancellation
**Code**:
```go
select {
case <-ctx.Done():
    return ctx.Err()
case result := <-ch:
    return result
}
```

<!-- Bad - Just description -->
## Pattern: Context Cancellation
Use select with ctx.Done() and channel.
```

### 4. Date All Entries | Đánh ngày mọi entry

```markdown
<!-- Good -->
## 2025-12-31: Decision Title

<!-- Bad -->
## Decision Title
(When was this made?)
```

---

## Team Memory | Memory nhóm

For multi-agent teams, see [06-team-coordination.md](./06-team-coordination.md).

Với nhóm đa agent, xem [06-team-coordination.md](./06-team-coordination.md).

Teams have shared memory in `team-memory/` directory:
- `team-memory/context.md` - Team-wide state
- `team-memory/decisions.md` - Team decisions
- `team-memory/handoffs.md` - Agent-to-agent transfers

---

## Summary | Tóm tắt

| File | Purpose | Load Time | Update Frequency |
|------|---------|-----------|------------------|
| `context.md` | Current state | Activation | Session end |
| `decisions.md` | Decision log | Activation (last 10) | When decisions made |
| `learnings.md` | Patterns | On-demand | When patterns discovered |
| `sessions/*.md` | Archives | Never auto-loaded | Complex sessions only |

---

*Next: [06-team-coordination.md](./06-team-coordination.md) - Multi-Agent Team Protocol*
