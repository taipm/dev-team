# Budget System - Deep Dive

> Chi tiết về Budget v1, v2 và cách track token/cost.

---

## Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    BUDGET SYSTEM ARCHITECTURE                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│                        ┌─────────────────┐                              │
│                        │  BudgetTracker  │                              │
│                        │  (Facade)       │                              │
│                        └────────┬────────┘                              │
│                                 │                                        │
│                    ┌────────────┴────────────┐                          │
│                    │                         │                          │
│            ┌───────▼───────┐         ┌───────▼───────┐                  │
│            │   Budget V1   │         │   Budget V2   │                  │
│            │  (Simple)     │         │  (Category)   │                  │
│            └───────┬───────┘         └───────┬───────┘                  │
│                    │                         │                          │
│                    └────────────┬────────────┘                          │
│                                 │                                        │
│                        ┌────────▼────────┐                              │
│                        │  TokenCounter   │                              │
│                        │  (tiktoken)     │                              │
│                        └────────┬────────┘                              │
│                                 │                                        │
│                        ┌────────▼────────┐                              │
│                        │    Pricing      │                              │
│                        │  (SSOT)         │                              │
│                        └─────────────────┘                              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Budget V1 (budget.go)

### Structure

```go
type BudgetTracker struct {
    maxCost       float64  // Max cost per request (e.g., $0.05)
    maxTokens     int      // Max tokens per request (e.g., 10000)
    currentCost   float64  // Accumulated cost
    currentTokens int      // Accumulated tokens
    mu            sync.Mutex
}
```

### Key Methods

```go
// Create new tracker
func NewBudgetTracker(maxCost float64, maxTokens int) *BudgetTracker

// Pre-call validation
func (b *BudgetTracker) CanProceed(estimatedTokens int) bool {
    b.mu.Lock()
    defer b.mu.Unlock()

    estimatedCost := b.estimateCost(estimatedTokens)
    return b.currentCost + estimatedCost <= b.maxCost &&
           b.currentTokens + estimatedTokens <= b.maxTokens
}

// Post-call recording
func (b *BudgetTracker) RecordUsage(inputTokens, outputTokens int, model string) {
    b.mu.Lock()
    defer b.mu.Unlock()

    cost := calculateCost(inputTokens, outputTokens, model)
    b.currentCost += cost
    b.currentTokens += inputTokens + outputTokens
}

// Check if budget exceeded
func (b *BudgetTracker) IsExceeded() bool
```

### Workflow

```
1. PRE-CALL
   │
   ├─→ Estimate tokens for request
   ├─→ Call CanProceed(estimatedTokens)
   └─→ If false: Return budget exceeded error

2. API CALL
   │
   └─→ Execute OpenAI API call

3. POST-CALL
   │
   ├─→ Get actual usage from response
   ├─→ Call RecordUsage(input, output, model)
   └─→ Log to cost_tracker (MongoDB)
```

---

## Budget V2 (budget_v2.go)

### Structure

```go
type TokenCategory int

const (
    CategorySystem TokenCategory = iota
    CategoryHistory
    CategoryInput
    CategoryOutput
)

type BudgetV2 struct {
    // Per-category limits
    limits map[TokenCategory]int

    // Per-category usage
    usage map[TokenCategory]int

    // Cost tracking
    maxCost     float64
    currentCost float64

    // Model for pricing
    model string

    mu sync.RWMutex
}
```

### Key Methods

```go
// Create with category limits
func NewBudgetV2(opts BudgetV2Options) *BudgetV2

// Check specific category
func (b *BudgetV2) CanAddTokens(category TokenCategory, tokens int) bool

// Record by category
func (b *BudgetV2) RecordTokens(category TokenCategory, tokens int) error

// Get usage breakdown
func (b *BudgetV2) GetUsage() map[TokenCategory]int

// Get metrics for Prometheus
func (b *BudgetV2) GetMetrics() BudgetV2Metrics
```

### Token Categories Explained

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    TOKEN CATEGORIES                                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  SYSTEM TOKENS                                                           │
│  ─────────────                                                          │
│  - System prompt định nghĩa agent behavior                              │
│  - Typically fixed per agent                                             │
│  - Limit: e.g., 2000 tokens                                             │
│                                                                          │
│  HISTORY TOKENS                                                          │
│  ──────────────                                                         │
│  - Conversation history (previous messages)                              │
│  - Grows with conversation length                                        │
│  - Limit: e.g., 4000 tokens                                             │
│  - May need truncation strategy                                          │
│                                                                          │
│  INPUT TOKENS                                                            │
│  ────────────                                                           │
│  - Current user input                                                    │
│  - Variable per request                                                  │
│  - Limit: e.g., 2000 tokens                                             │
│                                                                          │
│  OUTPUT TOKENS                                                           │
│  ─────────────                                                          │
│  - Model's response                                                      │
│  - Estimated pre-call, actual post-call                                  │
│  - Limit: e.g., 2000 tokens                                             │
│  - Most expensive (higher price per token)                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Budget V2 Workflow

```
1. INITIALIZATION
   │
   └─→ BudgetV2 created with category limits

2. PRE-CALL VALIDATION
   │
   ├─→ Count system tokens → RecordTokens(CategorySystem, n)
   ├─→ Count history tokens → RecordTokens(CategoryHistory, n)
   ├─→ Count input tokens → RecordTokens(CategoryInput, n)
   ├─→ Estimate output → CanAddTokens(CategoryOutput, estimated)
   └─→ Check total cost → CanProceed()

3. API CALL
   │
   └─→ Execute with max_tokens = remaining output budget

4. POST-CALL
   │
   ├─→ Record actual output → RecordTokens(CategoryOutput, actual)
   ├─→ Calculate cost
   └─→ Export metrics
```

---

## Token Counter (token_counter.go)

### Using tiktoken

```go
import "github.com/pkoukk/tiktoken-go"

type TokenCounter struct {
    encoding *tiktoken.Tiktoken
}

func NewTokenCounter(model string) (*TokenCounter, error) {
    enc, err := tiktoken.EncodingForModel(model)
    if err != nil {
        // Fallback to cl100k_base for unknown models
        enc, err = tiktoken.GetEncoding("cl100k_base")
    }
    return &TokenCounter{encoding: enc}, nil
}

func (tc *TokenCounter) Count(text string) int {
    tokens := tc.encoding.Encode(text, nil, nil)
    return len(tokens)
}

func (tc *TokenCounter) CountMessages(messages []Message) int {
    total := 0
    for _, msg := range messages {
        total += tc.Count(msg.Content)
        total += 4 // Per-message overhead
    }
    total += 2 // Priming tokens
    return total
}
```

### Model Encodings

| Model | Encoding | Notes |
|-------|----------|-------|
| gpt-4o | cl100k_base | Default for GPT-4 family |
| gpt-4o-mini | cl100k_base | Same as GPT-4o |
| gpt-3.5-turbo | cl100k_base | Same encoding |
| text-embedding-* | cl100k_base | For embeddings |

---

## Common Issues & Fixes

### Issue 1: Token Count Mismatch

**Symptom:** Our count differs from OpenAI's usage.

**Causes:**
1. Not counting message overhead (+4 per message)
2. Not counting priming tokens (+2)
3. Wrong encoding for model

**Fix:**
```go
func (tc *TokenCounter) CountMessages(messages []Message) int {
    total := 0
    for _, msg := range messages {
        total += tc.Count(msg.Content)
        total += tc.Count(msg.Role)
        total += 4 // <im_start>{role}\n{content}<im_end>\n
    }
    total += 2 // Priming for assistant response
    return total
}
```

### Issue 2: Budget Not Enforced

**Symptom:** Requests exceed budget but proceed anyway.

**Causes:**
1. CanProceed() not called before API call
2. Race condition in concurrent requests

**Fix:**
```go
// Ensure atomic check-and-reserve
func (b *BudgetTracker) ReserveTokens(tokens int) (bool, func()) {
    b.mu.Lock()
    defer b.mu.Unlock()

    if !b.canProceed(tokens) {
        return false, nil
    }

    b.currentTokens += tokens
    release := func() {
        b.mu.Lock()
        b.currentTokens -= tokens
        b.mu.Unlock()
    }

    return true, release
}
```

### Issue 3: Incorrect Cost Calculation

**Symptom:** Cost doesn't match billing.

**Causes:**
1. Using wrong pricing constants
2. Not using pricing.go (SSOT)

**Fix:**
```go
// ALWAYS use pricing.go
import "internal/agentic"

cost := agentic.CalculateCost(inputTokens, outputTokens, model)
```

---

## Testing Strategies

### Unit Tests

```go
func TestBudgetV2_CategoryLimits(t *testing.T) {
    budget := NewBudgetV2(BudgetV2Options{
        MaxSystemTokens:  1000,
        MaxHistoryTokens: 2000,
        MaxInputTokens:   1000,
        MaxOutputTokens:  1000,
    })

    // Should succeed
    assert.True(t, budget.CanAddTokens(CategorySystem, 500))

    // Should fail - exceeds limit
    assert.False(t, budget.CanAddTokens(CategorySystem, 1500))
}
```

### Integration Tests

```go
func TestBudgetWithRealTokenCounter(t *testing.T) {
    counter, _ := NewTokenCounter("gpt-4o")
    budget := NewBudgetV2(...)

    text := "Hello, world!"
    tokens := counter.Count(text)

    budget.RecordTokens(CategoryInput, tokens)

    // Verify against known count
    assert.Equal(t, 4, tokens) // "Hello, world!" = 4 tokens
}
```

### Benchmark Tests

```go
func BenchmarkBudgetV2_RecordTokens(b *testing.B) {
    budget := NewBudgetV2(defaultOptions)

    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        budget.RecordTokens(CategoryInput, 100)
    }
}
```

---

## Configuration

### Environment Variables

```bash
# Budget limits
BUDGET_MAX_COST=0.05           # Max cost per request ($)
BUDGET_MAX_TOKENS=10000        # Max total tokens
BUDGET_ESTIMATED_OUTPUT=500    # Estimated output tokens

# Category limits (v2)
BUDGET_MAX_SYSTEM_TOKENS=2000
BUDGET_MAX_HISTORY_TOKENS=4000
BUDGET_MAX_INPUT_TOKENS=2000
BUDGET_MAX_OUTPUT_TOKENS=2000
```

### Config Struct

```go
type BudgetConfig struct {
    MaxCost              float64 `env:"BUDGET_MAX_COST" default:"0.05"`
    MaxTokens            int     `env:"BUDGET_MAX_TOKENS" default:"10000"`
    EstimatedOutput      int     `env:"BUDGET_ESTIMATED_OUTPUT" default:"500"`

    // V2 specific
    MaxSystemTokens      int     `env:"BUDGET_MAX_SYSTEM_TOKENS" default:"2000"`
    MaxHistoryTokens     int     `env:"BUDGET_MAX_HISTORY_TOKENS" default:"4000"`
    MaxInputTokens       int     `env:"BUDGET_MAX_INPUT_TOKENS" default:"2000"`
    MaxOutputTokens      int     `env:"BUDGET_MAX_OUTPUT_TOKENS" default:"2000"`
}
```
