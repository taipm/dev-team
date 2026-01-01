# Budget V2 Epic - Story Checklists

Epic: BUDGET-V2 | Token Category Separation
Created: 2025-12-29

---

## Sprint 1: Foundation + Cleanup (11 pts)

### S0: Code Quality Cleanup (3 pts) - PREREQUISITE

**Files to modify:**
- [ ] `internal/agentic/pricing.go` - Document/remove dead constants
- [ ] `internal/agentic/budget.go` - Extract magic numbers
- [ ] `services/cost_tracker.go` - Remove duplicate pricing
- [ ] `services/token_service_test.go` - Import constants
- [ ] `services/pattern/test_e2e.go` - Import constants
- [ ] `internal/config/config.go` - Use pricing.go defaults
- [ ] `internal/agentic/README.md` - CREATE: Document package boundaries

**Checklist:**
- [ ] Remove duplicate pricing constants (DUP-001: 6 locations → 1)
- [ ] Unify cost calculation logic (DUP-002: 3 implementations)
- [ ] Document BudgetTracker vs CostTracker responsibilities
- [ ] Extract magic number `0.05` → `DefaultMaxRequestCostUSD`
- [ ] Extract magic number `10000` → `DefaultMaxRequestTokens`
- [ ] Extract magic number `500` → `DefaultEstimatedOutputTokens`
- [ ] Remove or document dead code: `GPT4oInputPricePer1K`, `GPT4oOutputPricePer1K`
- [ ] Remove or document dead code: `ClaudeHaikuInputPricePer1K`, `ClaudeHaikuOutputPricePer1K`
- [ ] All tests pass after cleanup
- [ ] Grep finds pricing constants only in pricing.go

**Acceptance Criteria:**
- [AC1] Single source of truth for pricing
- [AC2] CostTracker uses pricing.go
- [AC3] Dead code removed or justified
- [AC4] Magic numbers extracted
- [AC5] Clear package boundaries documented

---

### S1: Token Category Types and Structures (3 pts)

**Files to create:**
- [ ] `internal/agentic/budget_v2.go`
- [ ] `internal/agentic/budget_v2_errors.go`
- [ ] `internal/agentic/budget_v2_constants.go`

**Checklist:**
- [ ] Define `TokenCategory` enum (infrastructure, context, user_query, output)
- [ ] Define `TokenBreakdown` struct with computed fields
- [ ] Define `BudgetConfigV2` struct with YAML tags
- [ ] Create sentinel errors in budget_v2_errors.go:
  - [ ] `ErrUserQueryTooLong`
  - [ ] `ErrCostCeilingExceeded`
  - [ ] `ErrContextTruncationNeeded`
  - [ ] `ErrInvalidCategoryRatio`
  - [ ] `ErrUnknownCategory`
  - [ ] `ErrNegativeAllocation`
  - [ ] `ErrBudgetConfigInvalid`
- [ ] Create constants in budget_v2_constants.go:
  - [ ] `DefaultMaxUserQueryTokens = 500`
  - [ ] `DefaultMaxContextTokens = 3000`
  - [ ] `DefaultMaxOutputTokens = 2000`
  - [ ] `DefaultMaxCostPerRequestUSD = 0.05`
  - [ ] `CategoryWarningThreshold = 0.9`
  - [ ] `CostWarningThreshold = 0.8`
  - [ ] `MaxValidationLatencyMs = 10`
  - [ ] `MaxTokenCountingLatencyMs = 10`
- [ ] All exported types have godoc comments
- [ ] No circular dependencies

**Go Team Mandatory:**
- [ ] Constants have documentation comments
- [ ] Use composition over inheritance
- [ ] Constants for category strings (prevent typos)

**Acceptance Criteria:**
- [AC1] TokenCategory enum defined with 4 values
- [AC2] TokenBreakdown struct with all fields
- [AC3] BudgetConfigV2 loadable from YAML

---

### S2: Token Counter Implementation (5 pts)

**Files to create:**
- [ ] `internal/agentic/token_counter.go`

**Checklist:**
- [ ] Define `TokenCounter` interface:
  - [ ] `Count(text string) int`
  - [ ] `CountMessages([]openai.ChatCompletionMessage) int`
- [ ] Implement `TiktokenCounter` for gpt-4o-mini
- [ ] Implement `EstimateCounter` fallback (~2.5 chars/token)
- [ ] Cache encoding per model (lazy init)
- [ ] Thread-safe implementation
- [ ] Handle Unicode/Vietnamese correctly
- [ ] Log warning when fallback used

**Performance Requirements:**
- [ ] Count 5000 chars < 10ms
- [ ] No allocation per call after init
- [ ] Benchmark tests prove performance

**Dependencies:**
- [ ] `github.com/pkoukk/tiktoken-go` added to go.mod

**Acceptance Criteria:**
- [AC1] TokenCounter interface defined
- [AC2] TiktokenCounter handles Vietnamese
- [AC3] EstimateCounter as fallback
- [AC4] Performance < 10ms

---

## Sprint 2: Core Logic + Config (16 pts)

### S3: Category-Aware Validation Logic (8 pts)

**Files to modify:**
- [ ] `internal/agentic/budget_v2.go`

**Checklist:**
- [ ] Implement `ValidateTokenCategories()`:
  ```go
  func (bt *BudgetTrackerV2) ValidateTokenCategories(
      ctx context.Context,
      agentID string,
      breakdown *TokenBreakdown,
  ) (*ValidationResult, error)
  ```
- [ ] User query hard limit enforcement
- [ ] Short query always passes (regardless of system prompt size)
- [ ] Context soft limit with truncation suggestion
- [ ] Cost ceiling enforcement using pricing.go
- [ ] Return structured `ValidationResult`

**Go Team Mandatory:**
- [ ] Accept `context.Context` as first parameter
- [ ] Use error wrapping: `fmt.Errorf("agent %s: %w", agentID, err)`
- [ ] Use named constants from budget_v2_constants.go
- [ ] All methods use pointer receivers
- [ ] Single Responsibility - validation only
- [ ] Early return pattern

**Test Scenarios (15+ cases):**
- [ ] Short query passes with large system prompt
- [ ] Long query rejected with user-friendly error
- [ ] Context truncation triggered
- [ ] Cost ceiling hit
- [ ] Edge cases (zero tokens, negative, max int)

**Acceptance Criteria:**
- [AC1] User query hard limit enforcement
- [AC2] Short query always passes
- [AC3] Context soft limit truncation
- [AC4] Cost ceiling enforcement

---

### S4: User-Friendly Error Messages (3 pts)

**Files to modify:**
- [ ] `internal/agentic/budget_v2.go`

**Checklist:**
- [ ] Implement error formatting functions:
  - [ ] `formatUserQueryError()` → "Câu hỏi quá dài. Vui lòng rút gọn."
  - [ ] `formatCostError()` → "Yêu cầu phức tạp, vui lòng chia nhỏ"
  - [ ] `formatSystemError()` → "Hệ thống đang bận. Vui lòng thử lại sau."
- [ ] No token numbers in user messages
- [ ] No dollar amounts in user messages
- [ ] Error category in JSON response

**i18n Ready:**
- [ ] Messages externalized for future i18n
- [ ] No string concatenation in hot path
- [ ] Consistent message format

**Acceptance Criteria:**
- [AC1] Query too long message (Vietnamese)
- [AC2] Cost exceeded message
- [AC3] System error message
- [AC4] Error category in response

---

### S5: Configuration Schema V2 (5 pts)

**Files to modify:**
- [ ] `internal/agentic/config.go`

**Checklist:**
- [ ] Add `BudgetV2` field to crew config struct
- [ ] Parse budget_v2 section from crew.yaml:
  - [ ] `defaults.max_user_query_tokens`
  - [ ] `defaults.max_context_tokens`
  - [ ] `defaults.max_cost_per_request_usd`
  - [ ] Per-agent overrides
- [ ] Backward compatibility with old budget section
- [ ] V2 takes precedence over V1
- [ ] Validate config at startup (not runtime)
- [ ] Hot-reload supported

**Validation Rules:**
- [ ] No negative values
- [ ] Required fields present
- [ ] Reasonable defaults for optional fields

**Acceptance Criteria:**
- [AC1] budget_v2 section parsed
- [AC2] Backward compatibility
- [AC3] V2 takes precedence
- [AC4] Invalid config fails fast

---

## Sprint 3: Integration + Tests (24 pts)

### S6: Integration with Agent Execution (8 pts)

**Files to modify/create:**
- [ ] `internal/agentic/agent.go`
- [ ] `internal/agentic/crew.go`
- [ ] `internal/agentic/budget_v2_metrics.go` (CREATE)

**Checklist:**
- [ ] Modify `ExecuteAgentWithBudget()` to use V2 when enabled
- [ ] Feature flag: `settings.feature_flags.use_budget_v2`
- [ ] Calculate `TokenBreakdown` correctly:
  - [ ] `SystemPromptTokens = count(system messages)`
  - [ ] `RAGContextTokens = count(context injection)`
  - [ ] `UserQueryTokens = count(user's last message)`
- [ ] Apply context truncation when suggested
- [ ] Record cost per category after LLM call

**Prometheus Metrics (budget_v2_metrics.go):**
- [ ] `budget_v2_category_usage_ratio` (gauge)
- [ ] `budget_v2_category_exhausted_total` (counter)
- [ ] `budget_v2_validation_duration_seconds` (histogram)
- [ ] `budget_v2_short_query_rejected_total` (counter)
- [ ] `budget_v2_context_truncated_total` (counter)

**Structured Logging:**
- [ ] Log with: agent_id, user_query_tokens, context_tokens, estimated_cost_usd, validation_result, latency_ms

**Go Team Mandatory:**
- [ ] All operations accept `context.Context`
- [ ] Feature flag for safe rollout
- [ ] Metrics for V1 vs V2 comparison

**Acceptance Criteria:**
- [AC1] Pre-call validation uses V2
- [AC2] Token breakdown calculated correctly
- [AC3] Context truncation applied
- [AC4] Cost recorded per category

---

### S7: Response Metadata Enhancement (3 pts)

**Files to modify:**
- [ ] `handlers/chat.go`
- [ ] `handlers/chat_types.go`

**Checklist:**
- [ ] Add `Metadata` field to response struct:
  - [ ] `token_breakdown.system_prompt_tokens`
  - [ ] `token_breakdown.context_tokens`
  - [ ] `token_breakdown.user_query_tokens`
  - [ ] `token_breakdown.output_tokens`
  - [ ] `token_breakdown.total_tokens`
  - [ ] `context_truncated` (bool)
  - [ ] `original_context_tokens` (if truncated)
  - [ ] `truncated_context_tokens` (if truncated)
  - [ ] `cost_usd`
- [ ] Only include if client requests (header/param)
- [ ] No sensitive internal data exposed

**Acceptance Criteria:**
- [AC1] Token breakdown in success response
- [AC2] Truncation flag in response
- [AC3] Cost in response

---

### S8: Unit and Integration Tests (13 pts)

**Files to create:**
- [ ] `internal/agentic/budget_v2_test.go`
- [ ] `internal/agentic/budget_v2_bench_test.go`
- [ ] `tests/e2e/budget_v2_test.go`

**Unit Tests (budget_v2_test.go):**
- [ ] Table-driven tests for all validation scenarios
- [ ] Short query passes (original bug fix!)
- [ ] Long query rejected
- [ ] Large system prompt doesn't reject user
- [ ] Context truncation triggered
- [ ] Cost ceiling hit
- [ ] All error message formats
- [ ] Error wrapping tests (`errors.Is()`)

**Benchmark Tests (budget_v2_bench_test.go):**
- [ ] Token counting < 10ms
- [ ] Validation < 10ms
- [ ] No goroutine leaks after 1000 requests

**Integration Tests (tests/e2e/budget_v2_test.go):**
- [ ] E2E flow with actual LLM call
- [ ] Vietnamese short query succeeds
- [ ] Response includes token breakdown
- [ ] V1 backward compatibility

**Go Team Mandatory:**
- [ ] All tests pass with `-race` flag
- [ ] Property-based tests for ratio invariants (optional)
- [ ] Coverage >= 90% for budget_v2.go
- [ ] Coverage >= 85% for token_counter.go
- [ ] Coverage = 100% for budget_v2_errors.go

**Acceptance Criteria:**
- [AC1] Unit tests >= 90% coverage
- [AC2] Integration tests E2E
- [AC3] Backward compatibility tests
- [AC4] Performance benchmarks pass

---

## Definition of Done

### Story 0 (Cleanup) - MUST COMPLETE FIRST
- [ ] No duplicate pricing constants
- [ ] No hardcoded prices outside pricing.go
- [ ] Dead code removed or documented
- [ ] Magic numbers → named constants
- [ ] Package boundaries documented

### Stories 1-8 (V2 Implementation)
- [ ] All 8 stories implemented and merged
- [ ] Test coverage >= 90%
- [ ] Integration tests passing
- [ ] Performance benchmarks met (<10ms)
- [ ] Documentation updated
- [ ] Feature flag working
- [ ] Original bug confirmed fixed
- [ ] No regressions
- [ ] Linter clean

### Go Team Mandatory Requirements
- [ ] `context.Context` as first parameter
- [ ] Error wrapping with `%w`
- [ ] Sentinel errors in budget_v2_errors.go
- [ ] Named constants (no magic numbers)
- [ ] Pointer receivers consistently
- [ ] Prometheus metrics exposed
- [ ] Structured logging
- [ ] `go test -race` passes
- [ ] Benchmark tests verify <10ms SLA
- [ ] ADR document created

---

## Quick Reference: Dependency Order

```
Start here:
┌───────────┐
│    S0     │ ─── Cleanup first (no deps)
└───────────┘
      │
      ▼
┌───────────┐
│    S1     │ ─── Types + Errors + Constants
└───────────┘
      │
      ├─────────────┐
      ▼             ▼
┌───────────┐ ┌───────────┐
│    S2     │ │    S5     │
│ (Counter) │ │ (Config)  │
└───────────┘ └───────────┘
      │             │
      └──────┬──────┘
             ▼
       ┌───────────┐
       │    S3     │ ─── Core Validation
       └───────────┘
             │
      ┌──────┴──────┐
      ▼             ▼
┌───────────┐ ┌───────────┐
│    S4     │ │    S6     │
│ (Errors)  │ │(Integrate)│
└───────────┘ └───────────┘
                    │
                    ▼
              ┌───────────┐
              │    S7     │ ─── Metadata
              └───────────┘
                    │
                    ▼
              ┌───────────┐
              │    S8     │ ─── All Tests
              └───────────┘
```

---

## Commands

View board: `*board:budget-v2`
Move story: `*move:S0:todo`
Start story: `*start:S0`
Complete story: `*done:S0`
Block story: `*block:S1 "waiting for S0"`
