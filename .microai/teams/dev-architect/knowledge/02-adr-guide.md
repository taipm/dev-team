# Architecture Decision Records (ADR) Guide

## Overview
ADR là một cách document các architecture decisions một cách nhẹ nhàng và dễ maintain. Mỗi ADR captures một decision, context, và consequences.

---

## 1. Why ADR?

### Problems Without ADR
- "Tại sao chúng ta dùng PostgreSQL thay vì MongoDB?"
- "Ai quyết định dùng microservices?"
- "Context của decision này là gì?"
- "Có alternatives nào đã được xem xét?"

### Benefits of ADR
- **Institutional Memory**: Decisions survive team changes
- **Onboarding**: New members understand "why"
- **Revisiting**: Know when to reconsider decisions
- **Communication**: Async discussion of architecture

---

## 2. ADR Template

### Standard Template
```markdown
# ADR-{number}: {Short Title}

## Status
{Proposed | Accepted | Deprecated | Superseded by ADR-XXX}

## Date
{YYYY-MM-DD}

## Context
{What is the issue that we're seeing that is motivating this decision or change?}

## Decision
{What is the change that we're proposing and/or doing?}

## Consequences
{What becomes easier or more difficult to do because of this change?}
```

### Extended Template (for complex decisions)
```markdown
# ADR-{number}: {Short Title}

## Status
{Proposed | Accepted | Deprecated | Superseded}

## Date
{YYYY-MM-DD}

## Deciders
{List of people involved in the decision}

## Context
{Background information and problem statement}

## Decision Drivers
- {Driver 1}
- {Driver 2}
- {Driver 3}

## Considered Options
1. {Option 1}
2. {Option 2}
3. {Option 3}

## Decision Outcome
Chosen option: "{Option X}" because {justification}

### Positive Consequences
- {Consequence 1}
- {Consequence 2}

### Negative Consequences
- {Consequence 1}
- {Consequence 2}

## Pros and Cons of Options

### Option 1: {Title}
{Description}
- Good, because {argument a}
- Good, because {argument b}
- Bad, because {argument c}

### Option 2: {Title}
{Description}
- Good, because {argument a}
- Bad, because {argument b}

## Links
- {Related ADRs, documents, tickets}
```

---

## 3. ADR Lifecycle

```
┌──────────┐
│ Proposed │ ← Initial draft, seeking feedback
└────┬─────┘
     │
     ▼ (Team agrees)
┌──────────┐
│ Accepted │ ← Decision is active
└────┬─────┘
     │
     ├──────────────────────┐
     ▼                      ▼
┌────────────┐      ┌───────────────────────┐
│ Deprecated │      │ Superseded by ADR-XXX │
│ (no longer │      │ (replaced by newer    │
│  relevant) │      │  decision)            │
└────────────┘      └───────────────────────┘
```

### Status Transitions

| From | To | When |
|------|-----|------|
| Proposed | Accepted | Team approves after discussion |
| Proposed | Rejected | Team decides not to proceed |
| Accepted | Deprecated | Decision no longer applies |
| Accepted | Superseded | New decision replaces this one |

---

## 4. Example ADRs

### ADR-001: Use PostgreSQL as Primary Database
```markdown
# ADR-001: Use PostgreSQL as Primary Database

## Status
Accepted

## Date
2024-01-15

## Context
We need to choose a database for our new e-commerce application.
Requirements:
- ACID compliance for financial transactions
- Support for complex queries (reporting)
- JSON support for flexible product attributes
- Team familiarity

## Decision
We will use PostgreSQL 15 as our primary database.

## Consequences

### Positive
- Strong ACID guarantees for order/payment data
- Excellent JSON support with JSONB
- Mature ecosystem, easy to find developers
- Good performance for our expected load

### Negative
- Not ideal for high-write workloads (may need caching layer)
- Schema migrations require careful planning
- Horizontal scaling more complex than NoSQL
```

### ADR-002: Adopt Modular Monolith Architecture
```markdown
# ADR-002: Adopt Modular Monolith Architecture

## Status
Accepted

## Date
2024-01-20

## Context
We are starting a new project with:
- Team of 6 developers
- Unclear domain boundaries initially
- Need to deliver MVP in 3 months
- Potential for growth to microservices later

## Decision Drivers
- Fast time to market
- Team size constraints
- Need for clear module boundaries
- Future migration path

## Considered Options
1. Traditional Monolith
2. Modular Monolith
3. Microservices from start

## Decision Outcome
Chosen option: "Modular Monolith" because:
- Provides module isolation without operational complexity
- Allows team to discover bounded contexts
- Simple deployment (single artifact)
- Can extract services later if needed

### Positive Consequences
- Simple CI/CD pipeline
- Easy local development
- Clear ownership per module
- Path to microservices when needed

### Negative Consequences
- Still single deployment unit
- Requires discipline to maintain boundaries
- Shared database coupling
```

### ADR-003: Use Event-Driven Communication for Order Processing
```markdown
# ADR-003: Use Event-Driven Communication for Order Processing

## Status
Proposed

## Date
2024-01-25

## Context
Order processing involves multiple steps:
1. Validate order
2. Process payment
3. Update inventory
4. Send notifications
5. Trigger fulfillment

Currently synchronous, causing:
- Long response times (8-10 seconds)
- Cascading failures
- Difficult to add new steps

## Considered Options

### Option 1: Keep Synchronous
- Simple to understand
- Easy debugging
- But: slow, fragile

### Option 2: Async with Message Queue (RabbitMQ)
- Decoupled steps
- Can retry failed steps
- Guaranteed delivery
- But: operational overhead

### Option 3: Event Sourcing
- Full audit trail
- Can replay events
- But: significant complexity, overkill for current needs

## Decision Outcome
Chosen option: "Option 2 - Async with RabbitMQ"

Order Flow:
```
API → OrderCreated event → Queue →
  - PaymentService (processes payment)
  - InventoryService (reserves stock)
  - NotificationService (sends email)
```

### Positive Consequences
- Response time < 500ms (just create order)
- Services can fail independently
- Easy to add new consumers
- Natural retry mechanism

### Negative Consequences
- Need to handle eventual consistency
- Harder to debug (distributed tracing needed)
- Infrastructure cost (message broker)
```

---

## 5. ADR Best Practices

### Do's
- Write ADRs **when** making decisions, not after
- Keep ADRs **short and focused** (1-2 pages max)
- Include **context** - future readers need to understand "why"
- Document **alternatives** considered
- Update status when decisions change
- Store ADRs **close to code** (in repo)
- Number ADRs sequentially

### Don'ts
- Don't write ADRs for trivial decisions
- Don't update content of accepted ADRs (deprecate instead)
- Don't wait for perfection - iterate
- Don't skip the "consequences" section

### What Deserves an ADR?
```
✅ Database choice
✅ Architecture style (monolith vs microservices)
✅ Communication patterns (sync vs async)
✅ Framework selection
✅ Authentication strategy
✅ Caching approach
✅ API design decisions

❌ Code formatting style (use linter config)
❌ Variable naming conventions
❌ Which IDE to use
❌ Git branching strategy (use CONTRIBUTING.md)
```

---

## 6. ADR in Dev-Architect Sessions

### Session Output Format
```markdown
# ADR-XXX: {Title from Discussion}

## Status
Proposed

## Date
{Session Date}

## Session Context
- **Session ID**: {session_id}
- **Participants**: Developer, Solution Architect
- **Discussion Turns**: {count}

## Context
{Synthesized from session discussion}

## Decision
{Agreed approach from dialogue}

## Alternatives Discussed
{Options explored during session}

## Consequences
### Developer Perspective
{Implementation concerns raised}

### Architect Perspective
{Design considerations highlighted}

## Action Items
- [ ] {Follow-up tasks from session}
```

---

## 7. ADR File Organization

### Directory Structure
```
docs/
└── architecture/
    └── decisions/
        ├── 0001-use-postgresql.md
        ├── 0002-modular-monolith.md
        ├── 0003-event-driven-orders.md
        ├── 0004-api-gateway-pattern.md
        └── README.md (index of all ADRs)
```

### Index File (README.md)
```markdown
# Architecture Decision Records

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| 001 | Use PostgreSQL as Primary Database | Accepted | 2024-01-15 |
| 002 | Adopt Modular Monolith | Accepted | 2024-01-20 |
| 003 | Event-Driven Order Processing | Proposed | 2024-01-25 |
| 004 | API Gateway Pattern | Accepted | 2024-02-01 |
```

---

## References

- [Michael Nygard - Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- [ADR GitHub Organization](https://adr.github.io/)
- [MADR Template](https://adr.github.io/madr/)
