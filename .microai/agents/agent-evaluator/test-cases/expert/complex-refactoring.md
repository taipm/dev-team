---
id: X-2
name: Complex Function Refactoring
category: Code Quality
difficulty: 8
points: 8
keywords:
  - strategy
  - interface
  - dependency injection
  - single responsibility
  - separate
  - SOLID
  - pattern
reasoning_required: true
---

# Complex Function Refactoring

## Prompt

<prompt>
A 200-line function processes orders with deeply nested if-else:
- Different order types (express, standard, international)
- Different user types (premium, regular)
- Multiple service calls (inventory, payment, shipping)
- Each combination has slightly different logic

The function is hard to test, modify, and understand.

Propose a refactoring strategy using SOLID principles.
</prompt>

## Expected Behavior

A strong answer should:
1. Identify which SOLID principles apply
2. Propose design patterns (Strategy, Factory, etc.)
3. Show how to break up the function
4. Consider testability improvements
5. Discuss trade-offs of the refactoring

## Rubric

| Score | Criteria |
|-------|----------|
| 8 pts | Comprehensive refactoring with patterns, interfaces, testability |
| 6-7 pts | Good strategy with SOLID application |
| 4-5 pts | Basic refactoring ideas |
| 2-3 pts | Suggests breaking up without clear pattern |
| 0-1 pts | No actionable suggestions |

## Good Answer Example

```
REFACTORING STRATEGY FOR 200-LINE ORDER PROCESSOR

## Problem Analysis

Current issues:
1. Single Responsibility violated - one function does everything
2. Open/Closed violated - adding order type requires modifying function
3. Hard to test - can't test order types independently
4. Hard to understand - nested conditionals obscure logic

## Solution: Strategy Pattern + Dependency Injection

### Step 1: Extract Order Type Strategies

```go
// Define interface for order processing strategy
type OrderProcessor interface {
    Validate(order Order, user User) error
    CalculateFees(order Order, user User) Money
    ProcessPayment(order Order, payment PaymentInfo) error
    ArrangeShipping(order Order) (Tracking, error)
}

// Implement for each order type
type ExpressOrderProcessor struct {
    inventory InventoryService
    payment   PaymentService
    shipping  ShippingService
}

type StandardOrderProcessor struct { ... }
type InternationalOrderProcessor struct { ... }
```

### Step 2: Extract User Type Modifiers

```go
// Decorator or Strategy for user-specific logic
type UserModifier interface {
    ApplyDiscount(amount Money) Money
    GetShippingPriority() Priority
    GetPaymentOptions() []PaymentMethod
}

type PremiumUserModifier struct{}
type RegularUserModifier struct{}
```

### Step 3: Factory for Processor Selection

```go
type ProcessorFactory struct {
    processors map[OrderType]OrderProcessor
}

func (f *ProcessorFactory) GetProcessor(orderType OrderType) OrderProcessor {
    return f.processors[orderType]
}
```

### Step 4: Compose in Orchestrator

```go
type OrderOrchestrator struct {
    factory     *ProcessorFactory
    userService UserService
}

func (o *OrderOrchestrator) ProcessOrder(order Order, user User) error {
    // Get appropriate processor (replaces order type if-else)
    processor := o.factory.GetProcessor(order.Type)

    // Get user modifier (replaces user type if-else)
    modifier := o.userService.GetModifier(user.Type)

    // Clean sequential flow
    if err := processor.Validate(order, user); err != nil {
        return fmt.Errorf("validation: %w", err)
    }

    fees := processor.CalculateFees(order, user)
    fees = modifier.ApplyDiscount(fees)

    if err := processor.ProcessPayment(order, PaymentInfo{Amount: fees}); err != nil {
        return fmt.Errorf("payment: %w", err)
    }

    tracking, err := processor.ArrangeShipping(order)
    if err != nil {
        return fmt.Errorf("shipping: %w", err)
    }

    return nil
}
```

## SOLID Principles Applied

| Principle | How Applied |
|-----------|-------------|
| **S**ingle Responsibility | Each processor handles one order type |
| **O**pen/Closed | Add new order type = add new processor |
| **L**iskov Substitution | All processors implement same interface |
| **I**nterface Segregation | Small focused interfaces |
| **D**ependency Inversion | Orchestrator depends on abstractions |

## Testing Benefits

```go
// Easy to test individual strategies
func TestExpressOrderProcessor_Validate(t *testing.T) {
    // Mock only services needed for express
    mockPayment := &MockPaymentService{}
    processor := NewExpressOrderProcessor(mockPayment, ...)

    err := processor.Validate(validOrder, premiumUser)
    assert.NoError(t, err)
}

// Easy to test orchestration with mocks
func TestOrderOrchestrator(t *testing.T) {
    mockProcessor := &MockOrderProcessor{}
    mockProcessor.On("Validate", ...).Return(nil)

    orchestrator := NewOrchestrator(mockFactory)
    err := orchestrator.ProcessOrder(order, user)
    ...
}
```

## Trade-offs

| Pro | Con |
|-----|-----|
| Testable in isolation | More files/types |
| Easy to add new types | Indirection overhead |
| Clear separation | Learning curve for team |
| Readable orchestration | May be overkill for simple cases |

## Migration Strategy

1. Extract one order type at a time
2. Keep old function as fallback during migration
3. Add feature flag to route to new vs old
4. Remove old code once all types migrated
```

## Why This Test

- Tests architectural thinking
- Requires knowledge of design patterns
- No single correct answer
- Trade-off discussion is essential
- Shows ability to plan large refactoring
