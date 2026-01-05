# Architecture Decision Framework

> "Any fool can write code that a computer can understand. Good programmers write code that humans can understand." - Martin Fowler
> "Talk is cheap. Show me the code." - Linus Torvalds

---

## Overview

Framework quyết định kiến trúc kết hợp ADR template của Fowler, systems design principles của Linus, và refactoring catalog.

---

## Fowler's ADR Template

### Architecture Decision Record (ADR)

```markdown
# ADR-[number]: [Short Title]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-xxx]

## Context
[What is the issue that we're seeing that is motivating this decision?]
[What are the forces at play? Technical, political, social, project?]

## Decision Drivers
- [Driver 1: e.g., scalability requirement]
- [Driver 2: e.g., team expertise]
- [Driver 3: e.g., time constraint]
- [Driver 4: e.g., budget limitation]

## Considered Options
1. **Option A**: [Title]
   - Description: [Brief description]
   - Pros: [Advantages]
   - Cons: [Disadvantages]

2. **Option B**: [Title]
   - Description: [Brief description]
   - Pros: [Advantages]
   - Cons: [Disadvantages]

3. **Option C**: [Title]
   - Description: [Brief description]
   - Pros: [Advantages]
   - Cons: [Disadvantages]

## Trade-off Analysis

| Criterion | Weight | Option A | Option B | Option C |
|-----------|--------|----------|----------|----------|
| [Criterion 1] | [1-5] | [++/+/0/-/--] | | |
| [Criterion 2] | [1-5] | | | |
| [Criterion 3] | [1-5] | | | |
| **Weighted Score** | | [total] | [total] | [total] |

Legend: ++ Very Good, + Good, 0 Neutral, - Bad, -- Very Bad

## Decision
[What is the change that we're proposing?]
[State the decision clearly and concisely]

## Rationale
[Why is this the best option given the context?]
[Explain the reasoning behind the decision]

## Consequences

### Positive
- [Good thing that will happen]

### Negative
- [Bad thing we're accepting]

### Risks
- [Risk 1] - Mitigation: [How we'll handle it]

## Review Triggers
Reconsider this decision if:
- [Condition 1]
- [Condition 2]

## References
- [Link to relevant documentation]
- [Link to related ADRs]
```

---

## Linus's System Design Principles

### Code Quality Standards

```yaml
readability_first:
  principle: "Code is read far more than written"
  application:
    - "Names reveal intent"
    - "Functions do one thing"
    - "Comments explain WHY, not WHAT"
  linus_quote: "Bad programmers worry about code. Good programmers worry about data structures."

data_structures_matter:
  principle: "Get data structures right, code writes itself"
  application:
    - "Design data first"
    - "Let data drive code structure"
    - "Simple data = simple code"
  linus_quote: "Show me your flowcharts and conceal your tables, and I shall be mystified. Show me your tables, and I won't need your flowcharts."

simplicity:
  principle: "Complexity is the enemy"
  application:
    - "KISS (Keep It Simple, Stupid)"
    - "Don't over-engineer"
    - "Premature abstraction is evil"
  linus_quote: "Avoid the crap. Do the simple thing first."

correctness:
  principle: "Working > Clever"
  application:
    - "Boring code that works > Clever code that doesn't"
    - "Test edge cases"
    - "Handle errors explicitly"
```

### Code Review Checklist (Linus Style)

```yaml
must_fix:
  - "Race conditions or data corruption risks"
  - "Security vulnerabilities"
  - "Memory leaks or resource leaks"
  - "Undefined behavior"
  - "API breakage without versioning"

should_fix:
  - "Unnecessarily complex code"
  - "Poor naming that hides intent"
  - "Missing error handling"
  - "Code duplication"
  - "Magic numbers without explanation"

consider_fixing:
  - "Inconsistent style"
  - "Suboptimal performance (if not hot path)"
  - "Missing comments on non-obvious code"
  - "Long functions (>50 lines)"

questions_to_ask:
  - "What's the simplest solution that works?"
  - "What happens when this fails?"
  - "Is this the right abstraction level?"
  - "Would I understand this in 6 months?"
```

---

## Trade-off Analysis Matrix

### Standard Criteria

```yaml
performance:
  metrics:
    - "Latency (p50, p95, p99)"
    - "Throughput (req/s)"
    - "Resource usage (CPU, memory)"
  trade_offs:
    - "Performance vs Maintainability"
    - "Latency vs Throughput"

scalability:
  metrics:
    - "Horizontal scaling capability"
    - "Vertical scaling limits"
    - "Cost per unit load"
  trade_offs:
    - "Scalability vs Complexity"
    - "Scalability vs Cost"

maintainability:
  metrics:
    - "Code complexity (cyclomatic)"
    - "Change frequency/difficulty"
    - "Onboarding time for new devs"
  trade_offs:
    - "Maintainability vs Performance"
    - "Maintainability vs Time-to-market"

reliability:
  metrics:
    - "Uptime (nines)"
    - "MTBF (mean time between failures)"
    - "MTTR (mean time to recovery)"
  trade_offs:
    - "Reliability vs Cost"
    - "Reliability vs Complexity"

security:
  metrics:
    - "Attack surface"
    - "Data protection level"
    - "Compliance status"
  trade_offs:
    - "Security vs Usability"
    - "Security vs Performance"

cost:
  metrics:
    - "Development cost"
    - "Operational cost"
    - "Opportunity cost"
  trade_offs:
    - "Cost vs Features"
    - "Build vs Buy"
```

### Trade-off Decision Guide

```yaml
when_to_prioritize:
  performance:
    - "Latency-sensitive applications"
    - "High-frequency trading"
    - "Gaming"
    - "Real-time systems"

  scalability:
    - "Expected rapid growth"
    - "Variable load patterns"
    - "Global deployment"

  maintainability:
    - "Long-lived systems"
    - "Multiple teams"
    - "Frequent changes expected"

  reliability:
    - "Critical infrastructure"
    - "Financial systems"
    - "Healthcare"

  security:
    - "User data handling"
    - "Compliance requirements"
    - "Public-facing systems"

  cost:
    - "Startups with limited runway"
    - "Proof of concepts"
    - "Internal tools"
```

---

## Refactoring Catalog

### Code Smells → Refactorings

```yaml
long_method:
  smell: "Method doing too much"
  symptoms:
    - "> 20 lines"
    - "Multiple levels of abstraction"
    - "Hard to name accurately"
  refactoring: "Extract Method"
  example:
    before: |
      def process_order(order):
          # validate
          if not order.items: raise Error
          if order.total < 0: raise Error
          # calculate
          subtotal = sum(i.price for i in order.items)
          tax = subtotal * 0.1
          total = subtotal + tax
          # save
          db.save(order)
          # notify
          email.send(order.user, "Order confirmed")

    after: |
      def process_order(order):
          validate_order(order)
          calculate_total(order)
          save_order(order)
          notify_customer(order)

large_class:
  smell: "Class with too many responsibilities"
  symptoms:
    - "Many instance variables"
    - "Many methods"
    - "God class"
  refactoring: "Extract Class"

feature_envy:
  smell: "Method uses other class's data more than its own"
  symptoms:
    - "Many getters from other class"
    - "Calculations using other class's fields"
  refactoring: "Move Method"

data_clumps:
  smell: "Same data groups appearing together"
  symptoms:
    - "Same parameters in multiple methods"
    - "Related fields always used together"
  refactoring: "Extract Class, Introduce Parameter Object"

primitive_obsession:
  smell: "Using primitives instead of small objects"
  symptoms:
    - "Strings for email, money, phone"
    - "Validation scattered everywhere"
  refactoring: "Replace Primitive with Value Object"

switch_statements:
  smell: "Complex conditionals"
  symptoms:
    - "Switch on type"
    - "If-else chains"
  refactoring: "Replace Conditional with Polymorphism"

speculative_generality:
  smell: "Unused abstraction 'for the future'"
  symptoms:
    - "Abstract class with only one subclass"
    - "Parameters never used"
  refactoring: "Collapse Hierarchy, Inline Class"

dead_code:
  smell: "Unused code"
  symptoms:
    - "Unreachable code"
    - "Commented out code"
  refactoring: "Remove Dead Code"
```

### Safe Refactoring Process

```yaml
before_refactoring:
  - "Ensure tests exist and pass"
  - "Understand code fully"
  - "Have rollback plan"

during_refactoring:
  - "Small, incremental steps"
  - "Run tests after each step"
  - "Don't change behavior"
  - "One refactoring at a time"

after_refactoring:
  - "All tests still pass"
  - "Code review"
  - "Document what changed and why"
```

---

## Pattern Decision Guide

### When to Use Patterns

```yaml
strategy:
  problem: "Multiple algorithms that should be interchangeable"
  when_use: "3+ implementations of same behavior"
  when_not: "Only 2 options, simple if/else is fine"

factory:
  problem: "Complex object creation"
  when_use: "Creation logic is complex or varies"
  when_not: "Simple constructor is sufficient"

observer:
  problem: "Notify multiple objects of changes"
  when_use: "Many dependents need updates"
  when_not: "Just one or two dependents"

decorator:
  problem: "Add behavior dynamically"
  when_use: "Many optional behaviors that combine"
  when_not: "Fixed set of behaviors"

repository:
  problem: "Decouple domain from data access"
  when_use: "Complex queries, multiple data sources"
  when_not: "Simple CRUD, tight deadline"

general_rule: "If you have to ask, you probably don't need the pattern yet"
```

### Architecture Pattern Selection

```yaml
monolith:
  when_use:
    - "Small team (< 10)"
    - "Simple domain"
    - "Early stage, learning domain"
    - "Need to move fast"
  trade_offs:
    - "+ Simple deployment"
    - "+ Easy debugging"
    - "- Scaling entire system"
    - "- Deployment coupling"

modular_monolith:
  when_use:
    - "Medium team (10-50)"
    - "Clear domain boundaries emerging"
    - "Want microservices benefits without complexity"
  trade_offs:
    - "+ Module boundaries prepare for future"
    - "+ Single deployment unit"
    - "- Discipline required to maintain boundaries"

microservices:
  when_use:
    - "Large team (50+)"
    - "Clear, stable domain boundaries"
    - "Need independent scaling"
    - "Different tech stacks needed"
  trade_offs:
    - "+ Independent deployment"
    - "+ Team autonomy"
    - "- Operational complexity"
    - "- Distributed system challenges"

serverless:
  when_use:
    - "Event-driven workloads"
    - "Unpredictable traffic"
    - "Want zero server management"
  trade_offs:
    - "+ Auto-scaling"
    - "+ Pay per use"
    - "- Cold starts"
    - "- Vendor lock-in"
```

---

## Architecture Review Checklist

```yaml
clarity:
  - "[ ] Architecture is documented and up-to-date"
  - "[ ] Team understands and can explain design"
  - "[ ] ADRs exist for major decisions"

simplicity:
  - "[ ] No unnecessary complexity"
  - "[ ] YAGNI respected"
  - "[ ] Could junior dev understand?"

modularity:
  - "[ ] Clear module boundaries"
  - "[ ] Low coupling between modules"
  - "[ ] High cohesion within modules"

scalability:
  - "[ ] Bottlenecks identified"
  - "[ ] Scaling strategy defined"
  - "[ ] Capacity planning done"

reliability:
  - "[ ] Failure modes identified"
  - "[ ] Recovery procedures documented"
  - "[ ] Monitoring in place"

security:
  - "[ ] Threat model exists"
  - "[ ] Security controls appropriate"
  - "[ ] Secrets managed properly"

operability:
  - "[ ] Deployment automated"
  - "[ ] Logging/monitoring adequate"
  - "[ ] Runbooks for common issues"
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│            ARCHITECTURE DECISION QUICK GUIDE                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ADR TEMPLATE:                                               │
│  Context → Options → Trade-offs → Decision → Consequences   │
│                                                              │
│  LINUS PRINCIPLES:                                           │
│  • Data structures first, code second                        │
│  • Simplicity over cleverness                                │
│  • Working over elegant                                      │
│  • "Show me the code"                                        │
│                                                              │
│  FOWLER PRINCIPLES:                                          │
│  • Every design is a trade-off                               │
│  • Context determines best solution                          │
│  • Patterns are tools, not goals                             │
│  • Refactor continuously                                     │
│                                                              │
│  TRADE-OFF DIMENSIONS:                                       │
│  Performance ↔ Maintainability                               │
│  Scalability ↔ Simplicity                                    │
│  Reliability ↔ Cost                                          │
│  Security ↔ Usability                                        │
│                                                              │
│  REFACTORING RULES:                                          │
│  1. Tests exist and pass                                     │
│  2. Small incremental steps                                  │
│  3. Don't change behavior                                    │
│  4. Run tests after each step                                │
│                                                              │
│  PATTERN RULE:                                               │
│  "If you have to ask, you probably don't need it yet"       │
│                                                              │
│  ARCHITECTURE SELECTION:                                     │
│  Team < 10 → Monolith                                        │
│  Team 10-50 → Modular Monolith                               │
│  Team 50+ → Consider Microservices                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

*"Design is about trade-offs." - Martin Fowler*

*"Bad programmers worry about the code. Good programmers worry about data structures and their relationships." - Linus Torvalds*
