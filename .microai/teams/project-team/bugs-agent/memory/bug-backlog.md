# Bug Backlog - Kanban Board

> Last updated: 2024-12-30 by bugs-agent (BUG-003 analysis complete)

---

## Board Overview

```
+-----------------------------------------------------------------------------+
|                           BUG KANBAN BOARD                                  |
+-------------+-------------+-------------+-------------+---------------------+
|  BACKLOG    |  ANALYZING  |  READY      |  IN PROGRESS|  DONE               |
|  WIP: inf   |  WIP: 3     |  WIP: 5     |  WIP: 2     |  Archive weekly     |
+-------------+-------------+-------------+-------------+---------------------+
|             |             |  BUG-003    |             |  BUG-001           |
|             |             |             |             |  BUG-002           |
|             |             |             |             |                     |
+-------------+-------------+-------------+-------------+---------------------+
```

| Column | Count | WIP Limit | Status |
|--------|-------|-----------|--------|
| BACKLOG | 0 | inf | OK |
| ANALYZING | 0 | 3 | OK |
| READY | 1 | 5 | OK |
| IN PROGRESS | 0 | 2 | OK |
| DONE | 2 | Archive | OK |

---

## BACKLOG

(No bugs in backlog)

---

## ANALYZING

(No bugs currently in analysis)

---

## READY

### BUG-003

```yaml
id: BUG-003
title: "Streaming handler too large (548 LOC in streamChat)"
severity: medium
status: ready
priority: P2

reported: 2024-12-30
reporter: chat-agent (D001 analysis)
analyzed: 2024-12-30
analyzer: bugs-agent
assignee: TBD (recommend go-refactor-agent)
labels: [code-quality, refactor, chat, streaming]

files:
  - src/backend/ask-it-server/handlers/chat_streaming.go

notes: |
  Full 5W2H + 5Why analysis completed.
  8 extraction candidates identified.
  Estimated effort: M (Medium) - 4-6 hours
  Recommend incremental refactoring approach.
```

---

### 5W2H Documentation: BUG-003

#### WHAT (Cai gi?)

- **Bug description**: The `streamChat()` function in `chat_streaming.go` is 548 lines (lines 80-628), making it excessively long and difficult to maintain. The file total is 628 LOC including a helper function `tryResumeCrewIfPaused()` (52 lines).

- **Expected behavior**: Functions should follow Single Responsibility Principle (SRP). Go community best practices suggest functions under 50-100 lines, with complex orchestration handlers under 150 lines maximum.

- **Actual behavior**: `streamChat()` handles 10+ distinct responsibilities in a single function:
  1. HTTP SSE setup (headers, flusher validation)
  2. Crew resume check (HPSM + Remote-Command)
  3. OpenAI stream initialization
  4. First stream processing loop
  5. Signal buffer management
  6. Trigger detection and buffering
  7. Multi-round tool calling loop (nested 130+ lines)
  8. Agent handoff processing
  9. Conversation persistence (70+ line goroutine)
  10. Final response building

#### WHY (Tai sao quan trong?)

- **Business impact**:
  - Slow feature development - new streaming features require understanding 548 lines
  - Higher risk of regressions when modifying any streaming behavior
  - Difficult to onboard new developers to this critical code path

- **User impact**:
  - Indirect - bugs in streaming affect chat experience
  - Harder to fix user-reported streaming issues quickly

- **Technical debt**:
  - Violates SRP - function does too many things
  - Testing complexity - hard to unit test specific behaviors
  - Code duplication - stream processing logic repeated in tool loop
  - Cognitive load - developers must hold entire function in memory

#### WHERE (O dau?)

- **File(s)**: `/src/backend/ask-it-server/handlers/chat_streaming.go`
- **Function(s)**:
  - `streamChat()` - lines 80-628 (548 LOC) - MAIN ISSUE
  - `tryResumeCrewIfPaused()` - lines 25-77 (52 LOC) - OK
- **Environment**: All environments (code quality issue)
- **Component**: ask-it-server / handlers / chat streaming

#### WHEN (Khi nao?)

- **First reported**: 2024-12-30 (D001 analysis by chat-agent)
- **Frequency**: Permanent - affects every code change to streaming
- **Trigger condition**:
  - Any modification to streaming logic
  - Any new feature requiring streaming changes
  - Any debugging of streaming issues

#### WHO (Ai?)

- **Reporter**: chat-agent (D001 analysis)
- **Affected users**: Developers maintaining streaming code
- **Assignee**: TBD (recommend go-refactor-agent)
- **Reviewer**: backend-lead

#### HOW (Nhu the nao?)

- **Steps to reproduce**:
  1. Open `src/backend/ask-it-server/handlers/chat_streaming.go`
  2. Navigate to `streamChat()` function
  3. Count lines: 548 LOC
  4. Attempt to understand what the function does
  5. Notice 10+ distinct responsibilities mixed together

- **Proposed solution**: Extract 8 helper functions (see Refactoring Plan below)

#### HOW MUCH (Bao nhieu?)

- **Severity**: MEDIUM (P2) - Code quality, not functional bug
- **Effort estimate**: M (Medium) - 4-6 hours total
  - 30-45 min per extraction
  - Testing after each extraction
- **Files affected**: 1 file (may create 1-2 new files)
- **Lines to refactor**: ~400 lines (keep ~150 in main orchestrator)
- **Test coverage**: Must maintain existing test pass rate
- **Risk**: Low with incremental approach

---

### 5Why Root Cause Analysis: BUG-003

**Symptom**: `streamChat()` function is 548 lines long

| # | Question | Answer |
|---|----------|--------|
| 1 | Tai sao function dai 548 lines? | Because 10+ distinct responsibilities are all implemented inline in one function |
| 2 | Tai sao 10+ responsibilities in one function? | Because features were added incrementally (Epic 7, 12, 14, 16, 18) without refactoring |
| 3 | Tai sao features added without refactoring? | Because each feature had deadline pressure and "just add to existing function" was faster |
| 4 | Tai sao no refactoring checkpoint? | Because there was no code complexity review gate in the development process |
| 5 | Tai sao no complexity review gate? | **ROOT CAUSE**: Development process lacks code health metrics and periodic refactoring sprints |

**Root Cause**:
Organic growth without refactoring checkpoints. Features were added to meet delivery deadlines without periodic code health reviews. The function grew from simple streaming to handling crews, tools, signals, persistence, and handoffs.

**Solution Pattern**:
1. Extract helper functions now (tactical fix)
2. Add complexity linting (e.g., gocyclo, funlen) to CI
3. Schedule periodic "code health" sprints to address accumulated debt
4. Define function size guidelines in coding standards

---

### Refactoring Plan: BUG-003

#### Extraction Candidates (Priority Order)

| # | Proposed Function | Lines | Current Location | Effort | Impact |
|---|-------------------|-------|------------------|--------|--------|
| 1 | `saveConversationAsync()` | ~70 | 521-604 | S | High - isolated goroutine |
| 2 | `processMultiRoundTools()` | ~130 | 308-442 | M | High - nested loop |
| 3 | `processFirstStream()` | ~100 | 154-306 | M | High - main stream loop |
| 4 | `handleTriggerDetection()` | ~30 | 274-306 | S | Med - trigger logic |
| 5 | `processAgentHandoff()` | ~50 | 453-512 | S | Med - handoff logic |
| 6 | `buildFinalResponse()` | ~25 | 606-628 | S | Low - simple builder |
| 7 | `setupSSEHeaders()` | ~20 | 85-105 | S | Low - simple setup |
| 8 | `streamContentChunk()` | ~25 | (duplicated) | S | Med - DRY extraction |

#### Recommended Approach

**Phase 1: High-Value Extractions (2-3 hours)**
1. Extract `saveConversationAsync()` - completely isolated, zero risk
2. Extract `processMultiRoundTools()` - reduces main function by 130 lines

**Phase 2: Medium-Value Extractions (2-3 hours)**
3. Extract `processFirstStream()` - main stream processing
4. Extract `streamContentChunk()` - DRY up duplicated logic

**Phase 3: Polish (1 hour, optional)**
5. Extract remaining small functions

#### Target State

After refactoring, `streamChat()` should be ~100-150 lines:
- Orchestration logic only
- Clear flow visible at glance
- Each step delegates to well-named helper

```go
func streamChat(...) {
    setupSSEHeaders(w)

    if tryResumeCrewIfPaused(...) { return }

    stream := initOpenAIStream(ctx, params)
    defer stream.Close()

    firstStreamContent := processFirstStream(stream, ...)

    if hasToolCalls {
        finalContent = processMultiRoundTools(...)
    }

    handoffResult := processAgentHandoff(finalContent, ...)

    go saveConversationAsync(...)

    buildFinalResponse(w, ...)
}
```

---

## IN PROGRESS

(No bugs currently being fixed)

---

## DONE

### BUG-001 [FIXED]

```yaml
id: BUG-001
title: "Race condition in RouteMessage session handling"
severity: critical
status: done
priority: P0

reported: 2024-12-30
reporter: router-agent (D005 analysis)
assignee: backend-lead
resolved: 2024-12-30
resolution_commit: 646c2cd798db7e00fac213ffe848c8721d871413
labels: [concurrency, data-race, router]

files:
  - src/backend/ask-it-server/services/agentrouter/router.go
```

---

#### 5W2H Documentation: BUG-001

##### WHAT (Cai gi?)

- **Bug description**: Race condition in `RouteMessage()` function where session state was modified without holding the mutex lock. The function called `getOrCreateSession()` which released the lock, then modified `session.Context.ConversationHistory` and `session.LastActivityAt` without protection.
- **Expected behavior**: All session state modifications should be protected by `sessionsMu` mutex to ensure thread-safety when multiple goroutines access the same session concurrently.
- **Actual behavior**: Session modifications occurred outside the lock, causing potential data corruption when concurrent requests hit the same session.

##### WHY (Tai sao quan trong?)

- **Business impact**: Data loss or corruption in conversation history, causing users to lose context in their chat sessions
- **User impact**: Inconsistent responses, lost messages, potential service crashes under high load
- **Technical debt**: Critical concurrency bug that could cause intermittent, hard-to-reproduce failures

##### WHERE (O dau?)

- **File(s)**: `/src/backend/ask-it-server/services/agentrouter/router.go`
- **Function(s)**: `RouteMessage()` (lines 112-161)
- **Environment**: All environments under concurrent load
- **Component**: AgentRouter service - session management

##### WHEN (Khi nao?)

- **First reported**: 2024-12-30 (D005 analysis by router-agent)
- **Frequency**: Race condition - intermittent under concurrent load
- **Trigger condition**: Multiple goroutines calling `RouteMessage()` for the same `sessionID` simultaneously

##### WHO (Ai?)

- **Reporter**: router-agent (D005 analysis)
- **Affected users**: All users with active chat sessions under high concurrency
- **Assignee**: backend-lead
- **Reviewer**: Claude Code

##### HOW (Nhu the nao?)

- **Steps to reproduce**:
  1. Create a session with `sessionID = "test-session"`
  2. Launch multiple goroutines (e.g., 100 concurrent)
  3. Each goroutine calls `RouteMessage(ctx, "message", "test-session", "user-1")`
  4. Run with `-race` flag: `go test -race ./...`
  5. Race detector will flag the unsafe access

- **Root Cause (from 5Why)**:
  The `RouteMessage()` function was designed with incorrect lock scope. It called `getOrCreateSession()` which properly acquired and released the lock, but then the caller modified session state *after* the lock was released.

- **Solution Applied** (commit `646c2cd`):
  1. Inline session creation within `RouteMessage()` while holding lock
  2. Keep lock held during ALL session state modifications
  3. Capture `currentAgent` value before releasing lock
  4. Release lock only before logging and returning

##### HOW MUCH (Bao nhieu?)

- **Severity**: CRITICAL (P0)
- **Effort estimate**: S (Small - 1-2 hours)
- **Files affected**: 1 file
- **Lines changed**: +33 / -5
- **Users affected**: All concurrent users (100%)
- **Test verification**: 40/40 tests pass with `-race` flag

---

#### 5Why Root Cause Analysis: BUG-001

**Symptom**: Race condition detected when multiple goroutines access session concurrently

| # | Question | Answer |
|---|----------|--------|
| 1 | Tai sao race condition xay ra? | `session.Context.ConversationHistory = append(...)` was called without holding the mutex lock |
| 2 | Tai sao code modify session without lock? | Because `RouteMessage()` called `getOrCreateSession()` which internally acquired and released the lock, returning an unlocked session reference |
| 3 | Tai sao `getOrCreateSession()` releases lock truoc khi return? | Design pattern: helper function was meant to be self-contained, but caller needed to do more work on the returned session |
| 4 | Tai sao caller needed to modify session after getting it? | `RouteMessage()` has business logic to add messages to conversation history and update timestamps |
| 5 | Tai sao design khong anticipate concurrent access? | **ROOT CAUSE**: Lock scope was incorrectly designed at function boundaries instead of operation boundaries. The lock should protect the entire read-modify-write operation, not just the creation. |

**Root Cause**: Incorrect lock scope design - lock was released too early by helper function, before all mutations were complete.

**Solution Pattern**:
- Lock at operation boundary, not function boundary
- Keep lock held for entire read-modify-write sequence
- Inline critical sections when helper functions cannot maintain lock

---

### BUG-002

```yaml
id: BUG-002
title: "Missing score_threshold in Qdrant search"
severity: high
status: done
priority: P1

reported: 2024-12-30
reporter: qdrant-agent (D002 analysis)
assignee: backend-lead
resolved: 2024-12-30
labels: [qdrant, search, quality]

files:
  - tools/qdrant_base.go

resolution: |
  D003 fix: Added ScoreThreshold field and DefaultScoreThreshold = 0.7.
  Now low-relevance results are filtered out.
```

---

## Bug Cards Archive

(Move DONE bugs here weekly)

---

## Metrics

| Metric | Value | Target |
|--------|-------|--------|
| Open bugs | 1 | < 10 |
| Critical open | 0 | 0 |
| Avg lead time | < 1 day | < 7 days |
| Throughput (weekly) | 2 | Trending up |

---

## Next Bug ID

**Next ID: BUG-004**
