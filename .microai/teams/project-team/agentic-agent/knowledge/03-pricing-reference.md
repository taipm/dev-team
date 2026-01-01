# Pricing Reference - Single Source of Truth

> pricing.go là SINGLE SOURCE OF TRUTH cho tất cả pricing constants.

---

## CRITICAL RULE

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                         ⚠️  CRITICAL RULE  ⚠️                              ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  ALL pricing constants MUST be defined in:                                ║
║                                                                            ║
║    internal/agentic/pricing.go                                            ║
║                                                                            ║
║  DO NOT:                                                                   ║
║    ❌ Hardcode prices in other files                                      ║
║    ❌ Duplicate pricing constants                                         ║
║    ❌ Calculate costs without using GetModelPricing()                     ║
║                                                                            ║
║  ALWAYS:                                                                   ║
║    ✅ Import pricing from internal/agentic                                ║
║    ✅ Use GetModelPricing(model) to get prices                            ║
║    ✅ Use CalculateCost(input, output, model) for cost                    ║
║                                                                            ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

## pricing.go Structure

```go
package agentic

// Pricing constants per 1M tokens
// Source: https://openai.com/pricing
const (
    // GPT-4o (omni)
    GPT4oInputPrice  = 2.50   // $2.50 per 1M input tokens
    GPT4oOutputPrice = 10.00  // $10.00 per 1M output tokens

    // GPT-4o mini
    GPT4oMiniInputPrice  = 0.15  // $0.15 per 1M input tokens
    GPT4oMiniOutputPrice = 0.60  // $0.60 per 1M output tokens

    // GPT-4 Turbo
    GPT4TurboInputPrice  = 10.00  // $10.00 per 1M input tokens
    GPT4TurboOutputPrice = 30.00  // $30.00 per 1M output tokens

    // GPT-3.5 Turbo
    GPT35TurboInputPrice  = 0.50  // $0.50 per 1M input tokens
    GPT35TurboOutputPrice = 1.50  // $1.50 per 1M output tokens
)

// Model name mappings
var modelAliases = map[string]string{
    "gpt-4o":            "gpt-4o",
    "gpt-4o-2024-08-06": "gpt-4o",
    "gpt-4o-mini":       "gpt-4o-mini",
    "gpt-4-turbo":       "gpt-4-turbo",
    "gpt-3.5-turbo":     "gpt-3.5-turbo",
}

// GetModelPricing returns input and output prices for a model
func GetModelPricing(model string) (inputPrice, outputPrice float64) {
    // Normalize model name
    normalizedModel := normalizeModelName(model)

    switch normalizedModel {
    case "gpt-4o":
        return GPT4oInputPrice, GPT4oOutputPrice
    case "gpt-4o-mini":
        return GPT4oMiniInputPrice, GPT4oMiniOutputPrice
    case "gpt-4-turbo":
        return GPT4TurboInputPrice, GPT4TurboOutputPrice
    case "gpt-3.5-turbo":
        return GPT35TurboInputPrice, GPT35TurboOutputPrice
    default:
        // Default to gpt-4o-mini pricing for unknown models
        return GPT4oMiniInputPrice, GPT4oMiniOutputPrice
    }
}

// CalculateCost calculates the cost for a given usage
func CalculateCost(inputTokens, outputTokens int, model string) float64 {
    inputPrice, outputPrice := GetModelPricing(model)

    inputCost := float64(inputTokens) * inputPrice / 1_000_000
    outputCost := float64(outputTokens) * outputPrice / 1_000_000

    return inputCost + outputCost
}

// normalizeModelName maps model aliases to canonical names
func normalizeModelName(model string) string {
    if canonical, exists := modelAliases[model]; exists {
        return canonical
    }
    return model
}
```

---

## Current Pricing Table

| Model | Input (per 1M) | Output (per 1M) | Notes |
|-------|----------------|-----------------|-------|
| gpt-4o | $2.50 | $10.00 | Main model |
| gpt-4o-mini | $0.15 | $0.60 | Default, cost-effective |
| gpt-4-turbo | $10.00 | $30.00 | Legacy |
| gpt-3.5-turbo | $0.50 | $1.50 | Legacy |

---

## How to Use

### In Other Files

```go
package mypackage

import (
    "your-project/internal/agentic"
)

func calculateMyCost(inputTokens, outputTokens int, model string) float64 {
    // ✅ CORRECT: Use the central function
    return agentic.CalculateCost(inputTokens, outputTokens, model)
}

// ❌ WRONG: Don't do this
func badCalculation(inputTokens, outputTokens int) float64 {
    // Hardcoded prices = BAD
    inputCost := float64(inputTokens) * 0.15 / 1_000_000
    outputCost := float64(outputTokens) * 0.60 / 1_000_000
    return inputCost + outputCost
}
```

### Getting Prices for Display

```go
func displayModelPricing(model string) {
    inputPrice, outputPrice := agentic.GetModelPricing(model)

    fmt.Printf("Model: %s\n", model)
    fmt.Printf("  Input:  $%.2f per 1M tokens\n", inputPrice)
    fmt.Printf("  Output: $%.2f per 1M tokens\n", outputPrice)
}
```

---

## Adding New Models

### Step 1: Add Constants

```go
// In pricing.go
const (
    // ... existing constants ...

    // New Model (added YYYY-MM-DD)
    NewModelInputPrice  = X.XX
    NewModelOutputPrice = X.XX
)
```

### Step 2: Add to Alias Map

```go
var modelAliases = map[string]string{
    // ... existing aliases ...
    "new-model":           "new-model",
    "new-model-2024-XX":   "new-model",
}
```

### Step 3: Add Case in GetModelPricing

```go
func GetModelPricing(model string) (inputPrice, outputPrice float64) {
    switch normalizedModel {
    // ... existing cases ...
    case "new-model":
        return NewModelInputPrice, NewModelOutputPrice
    }
}
```

### Step 4: Add Test

```go
func TestGetModelPricing_NewModel(t *testing.T) {
    input, output := GetModelPricing("new-model")

    assert.Equal(t, NewModelInputPrice, input)
    assert.Equal(t, NewModelOutputPrice, output)
}
```

---

## Cost Tracking Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    COST TRACKING FLOW                                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. PRE-CALL ESTIMATION                                                  │
│     │                                                                    │
│     ├─→ Count tokens (token_counter.go)                                 │
│     ├─→ Get prices (pricing.go → GetModelPricing)                       │
│     ├─→ Estimate cost (pricing.go → CalculateCost)                      │
│     └─→ Check budget (budget.go → CanProceed)                           │
│                                                                          │
│  2. API CALL                                                             │
│     │                                                                    │
│     └─→ OpenAI returns actual usage                                     │
│                                                                          │
│  3. POST-CALL RECORDING                                                  │
│     │                                                                    │
│     ├─→ Get actual tokens from response                                 │
│     ├─→ Calculate actual cost (pricing.go → CalculateCost)              │
│     ├─→ Record in budget (budget.go → RecordUsage)                      │
│     └─→ Log to MongoDB (cost_tracker.go)                                │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Cost Tracker (services/cost_tracker.go)

```go
// CostTracker logs costs to MongoDB for billing/analytics
type CostTracker struct {
    db         *mongo.Database
    collection *mongo.Collection
}

type CostLogEntry struct {
    Timestamp    time.Time `bson:"timestamp"`
    RequestID    string    `bson:"request_id"`
    UserID       string    `bson:"user_id"`
    Model        string    `bson:"model"`
    InputTokens  int       `bson:"input_tokens"`
    OutputTokens int       `bson:"output_tokens"`
    Cost         float64   `bson:"cost"`
    AgentName    string    `bson:"agent_name,omitempty"`
    CrewName     string    `bson:"crew_name,omitempty"`
}

func (ct *CostTracker) LogCost(ctx context.Context, entry CostLogEntry) error {
    // Use pricing.go to calculate cost
    entry.Cost = agentic.CalculateCost(
        entry.InputTokens,
        entry.OutputTokens,
        entry.Model,
    )

    _, err := ct.collection.InsertOne(ctx, entry)
    return err
}
```

---

## Common Mistakes

### Mistake 1: Hardcoded Prices

```go
// ❌ BAD
cost := float64(tokens) * 0.15 / 1_000_000

// ✅ GOOD
cost := agentic.CalculateCost(inputTokens, outputTokens, model)
```

### Mistake 2: Wrong Price Unit

```go
// ❌ BAD - Prices are per 1M tokens, not per 1K
cost := float64(tokens) * inputPrice / 1000

// ✅ GOOD - Divide by 1_000_000
cost := float64(tokens) * inputPrice / 1_000_000
```

### Mistake 3: Ignoring Output Token Price

```go
// ❌ BAD - Output tokens are more expensive!
totalCost := float64(inputTokens + outputTokens) * inputPrice / 1_000_000

// ✅ GOOD - Calculate separately
inputCost := float64(inputTokens) * inputPrice / 1_000_000
outputCost := float64(outputTokens) * outputPrice / 1_000_000
totalCost := inputCost + outputCost
```

---

## Updating Prices

When OpenAI updates pricing:

1. **Check OpenAI pricing page**: https://openai.com/pricing
2. **Update constants in pricing.go**
3. **Add comment with date of change**
4. **Run all tests**
5. **Notify team of price change**

```go
// GPT-4o pricing (updated 2024-XX-XX)
// Previous: $2.50 / $10.00
// New: $X.XX / $X.XX
const (
    GPT4oInputPrice  = X.XX
    GPT4oOutputPrice = X.XX
)
```
