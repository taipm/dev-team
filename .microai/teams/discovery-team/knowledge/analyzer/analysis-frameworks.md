# Analysis Frameworks

> Frameworks cho việc phân tích patterns và relationships

## Pattern Recognition

### What is a Pattern?
```
Pattern = Recurring structure appearing in 2+ locations
```

**Single instance ≠ Pattern**
**2+ consistent instances = Pattern**

### Pattern Categories

#### 1. Structural Patterns
How code is organized

| Pattern | Signs | Example |
|---------|-------|---------|
| Layered | Distinct folders for each layer | `handlers/`, `services/`, `repositories/` |
| Modular | Self-contained modules | `user/`, `order/`, `product/` each with full stack |
| Monolithic | Everything in one place | Single large package |
| MVC | Model-View-Controller separation | `models/`, `views/`, `controllers/` |

#### 2. Behavioral Patterns
How code behaves

| Pattern | Signs | Example |
|---------|-------|---------|
| Factory | `NewXxx()` functions | `NewUserService()` returning interface |
| Singleton | `GetInstance()` or global var | `var instance *Config` |
| Observer | Subscribe/Publish methods | `eventBus.Subscribe()` |
| Strategy | Interface with multiple implementations | `PaymentStrategy` with `CreditCard`, `PayPal` |

#### 3. Architectural Patterns
High-level design

| Pattern | Signs | Example |
|---------|-------|---------|
| Clean Architecture | Dependency inversion, interfaces | Business logic doesn't import infra |
| Microservices | Multiple services, API communication | `user-service/`, `order-service/` |
| Event-Driven | Message queues, event handlers | Kafka consumers, event sourcing |
| CQRS | Separate read/write models | `QueryService`, `CommandService` |

### Pattern Detection Algorithm

```yaml
for each candidate_pattern:

  step_1_identify:
    # Find potential instances
    search: for characteristic signs
    collect: matching code locations

  step_2_verify:
    # Verify it's actually a pattern
    count: number of occurrences
    if: count < 2
      result: "Not a pattern (single instance)"
    else:
      continue

  step_3_analyze:
    # Check consistency
    compare: all occurrences
    check:
      - Same structure?
      - Same naming convention?
      - Same behavior?

  step_4_document:
    # Create pattern record
    record:
      name: descriptive name
      type: structural/behavioral/architectural
      occurrences: locations[]
      confidence: high/medium
```

## Relationship Mapping

### Relationship Types

| Type | Direction | Meaning | Example |
|------|-----------|---------|---------|
| uses | A → B | A calls/uses B | `Service → Repository` |
| extends | A → B | A inherits B | `Dog → Animal` |
| implements | A → B | A implements B | `PostgresRepo → Repository` |
| creates | A → B | A creates instances of B | `Factory → Product` |
| depends | A → B | A requires B to function | `Handler → Service` |

### Relationship Strength

| Strength | Meaning | Evidence |
|----------|---------|----------|
| Direct | Explicit connection | Import statement, field reference |
| Indirect | Through intermediate | A → B → C (A indirectly depends on C) |
| Inferred | Implied but not explicit | Naming convention, same package |

### Building Relationship Map

```yaml
algorithm:

  step_1_extract_nodes:
    # Identify components
    scan: all discovered facts
    extract:
      - Services
      - Repositories
      - Handlers
      - Models
      - Utilities

  step_2_find_edges:
    # Identify relationships
    for each component_pair:
      check:
        - Import statements
        - Field references
        - Method calls
        - Constructor parameters
      if: relationship_found
        record: {from, to, type, strength}

  step_3_build_graph:
    # Construct graph
    nodes: components[]
    edges: relationships[]
    metadata: evidence[]

  step_4_visualize:
    # Generate visualization
    mermaid: |
      graph TD
        A --> B
        B --> C
```

## Gap Analysis

### Types of Gaps

| Gap Type | Description | Detection |
|----------|-------------|-----------|
| Unanswered | Question not answered | No facts for question |
| Incomplete | Partial answer | Facts missing evidence |
| Unclear | Ambiguous understanding | Conflicting facts |
| Missing | Expected but not found | Common pattern absent |

### Gap Severity

```yaml
severity_levels:

  HIGH:
    criteria:
      - Core functionality unclear
      - Security-related
      - Critical path unknown
    action: Must address before synthesis

  MEDIUM:
    criteria:
      - Secondary functionality
      - Non-critical component
    action: Address if time permits

  LOW:
    criteria:
      - Nice-to-know
      - Edge cases
    action: Document for future
```

### Gap Resolution

```yaml
for each gap:

  option_1_derive_question:
    # Generate follow-up question
    question: |
      Based on gap "{gap.description}",
      we need to answer: {derived question}
    add_to: question_context.derived[]

  option_2_document:
    # Accept as limitation
    document:
      gap: description
      reason: why couldn't resolve
      impact: what we're missing
    add_to: report.gaps[]

  option_3_infer:
    # Careful inference (with warning)
    inference: |
      Based on {evidence},
      it appears that {conclusion}
    confidence: MEDIUM
    warning: "Inferred, not directly evidenced"
```

## Cross-Reference Analysis

### Comparing with History

```yaml
comparison:

  new_findings:
    # What's new since last session
    current_components - last_components
    output: list of new discoveries

  changes:
    # What changed
    for each component in both:
      compare: attributes, relationships
      if: different
        record: change

  missing:
    # What's no longer found
    last_components - current_components
    output: list of missing items
    flag: potential regression or rename

  evolution:
    # Track knowledge growth
    metrics:
      - components_discovered
      - patterns_identified
      - relationships_mapped
      - questions_answered
```

## Analysis Output Template

```yaml
analysis_output:

  summary:
    facts_analyzed: N
    patterns_found: N
    relationships_mapped: N
    gaps_identified: N

  patterns:
    - id: pat-001
      name: "Repository Pattern"
      type: structural
      occurrences: 5
      evidence:
        - user/repository.go:10
        - order/repository.go:12
      confidence: high
      implications: |
        Data access is abstracted through interfaces.
        Easy to swap implementations.

  relationships:
    graph: |
      AuthService --> UserRepository
      UserRepository --> Database
    edges:
      - from: AuthService
        to: UserRepository
        type: uses
        evidence: auth/service.go:15

  gaps:
    - id: gap-001
      description: "Cache invalidation unclear"
      severity: high
      evidence_of_gap: "Found cache writes, no invalidation"
      recommended_question: "When is cache invalidated?"

  insights:
    - "Codebase follows clean architecture"
    - "5 services identified, all use repository pattern"
    - "No centralized error handling found"
```
