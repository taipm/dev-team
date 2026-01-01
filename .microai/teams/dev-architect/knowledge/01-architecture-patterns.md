# Architecture Patterns Knowledge Base

## Overview
Tài liệu tham khảo về các architecture patterns phổ biến, khi nào sử dụng, và trade-offs.

---

## 1. Architectural Styles

### Monolithic Architecture
```
┌─────────────────────────────────────┐
│           Application               │
├─────────────────────────────────────┤
│  UI │ Business Logic │ Data Access  │
├─────────────────────────────────────┤
│            Database                 │
└─────────────────────────────────────┘
```

**When to use:**
- Small team (< 5 developers)
- Simple domain
- MVP/Prototype phase
- Tight deadline

**Trade-offs:**
| Pros | Cons |
|------|------|
| Simple deployment | Hard to scale specific parts |
| Easy debugging | Large codebase over time |
| Low latency (no network hops) | Technology lock-in |
| Easier testing | Team coupling |

### Modular Monolith
```
┌─────────────────────────────────────┐
│           Application               │
├──────────┬──────────┬───────────────┤
│ Module A │ Module B │   Module C    │
│ (Users)  │ (Orders) │  (Payments)   │
├──────────┴──────────┴───────────────┤
│         Shared Infrastructure       │
├─────────────────────────────────────┤
│            Database                 │
└─────────────────────────────────────┘
```

**When to use:**
- Medium team (5-15 developers)
- Clear bounded contexts
- Need for future microservices migration
- Balance simplicity and modularity

**Trade-offs:**
| Pros | Cons |
|------|------|
| Clear module boundaries | Still single deployment unit |
| Easier refactoring | Requires discipline to maintain boundaries |
| Path to microservices | Shared database complexity |
| Better team ownership | Module dependency management |

### Microservices Architecture
```
┌─────────┐     ┌─────────┐     ┌─────────┐
│ Service │     │ Service │     │ Service │
│    A    │────▶│    B    │────▶│    C    │
│  (API)  │     │ (Logic) │     │  (Data) │
└────┬────┘     └────┬────┘     └────┬────┘
     │               │               │
     ▼               ▼               ▼
  ┌─────┐        ┌─────┐        ┌─────┐
  │ DB  │        │ DB  │        │ DB  │
  └─────┘        └─────┘        └─────┘
```

**When to use:**
- Large team (15+ developers)
- Multiple teams working independently
- High scalability requirements
- Different tech stacks needed

**Trade-offs:**
| Pros | Cons |
|------|------|
| Independent deployment | Operational complexity |
| Technology flexibility | Network latency |
| Team autonomy | Data consistency challenges |
| Scalability | Debugging distributed systems |

---

## 2. Communication Patterns

### Synchronous Communication

#### REST API
```
Client ──HTTP/JSON──▶ Server
       ◀──Response───
```
- **Best for**: CRUD operations, simple requests
- **Considerations**: Tight coupling, timeouts, error handling

#### gRPC
```
Client ──Protocol Buffers──▶ Server
       ◀──Binary Response───
```
- **Best for**: Internal service communication, high performance
- **Considerations**: Schema management, debugging complexity

### Asynchronous Communication

#### Message Queue
```
Producer ──▶ Queue ──▶ Consumer
           (FIFO)
```
- **Best for**: Decoupling, load leveling, guaranteed delivery
- **Options**: RabbitMQ, Amazon SQS, Azure Service Bus

#### Event Bus / Pub-Sub
```
Publisher ──▶ Event Bus ──▶ Subscriber A
                       ──▶ Subscriber B
                       ──▶ Subscriber C
```
- **Best for**: Event-driven architecture, multiple consumers
- **Options**: Kafka, Redis Pub/Sub, AWS SNS

---

## 3. Data Patterns

### Database per Service
```
┌─────────┐     ┌─────────┐     ┌─────────┐
│Service A│     │Service B│     │Service C│
└────┬────┘     └────┬────┘     └────┬────┘
     │               │               │
     ▼               ▼               ▼
┌─────────┐     ┌─────────┐     ┌─────────┐
│PostgreSQL│    │ MongoDB │     │  Redis  │
└─────────┘     └─────────┘     └─────────┘
```

**Benefits**: Loose coupling, tech flexibility
**Challenges**: Data consistency, joins across services

### Shared Database
```
┌─────────┐     ┌─────────┐     ┌─────────┐
│Service A│     │Service B│     │Service C│
└────┬────┘     └────┬────┘     └────┬────┘
     │               │               │
     └───────────────┼───────────────┘
                     ▼
              ┌───────────┐
              │  Database │
              └───────────┘
```

**Benefits**: Simple, ACID transactions
**Challenges**: Schema coupling, single point of failure

### CQRS (Command Query Responsibility Segregation)
```
┌───────────────┐          ┌───────────────┐
│   Commands    │          │    Queries    │
│ (Write Model) │          │ (Read Model)  │
└───────┬───────┘          └───────┬───────┘
        │                          │
        ▼                          ▼
┌───────────────┐          ┌───────────────┐
│  Write DB     │ ──sync─▶ │   Read DB     │
│ (Normalized)  │          │(Denormalized) │
└───────────────┘          └───────────────┘
```

**When to use:**
- Read-heavy workloads với complex queries
- Different scaling needs for read/write
- Event sourcing systems

### Event Sourcing
```
┌─────────────────────────────────────────┐
│              Event Store                │
├─────────────────────────────────────────┤
│ Event 1: UserCreated {id, name, email}  │
│ Event 2: UserUpdated {id, name}         │
│ Event 3: UserDeleted {id}               │
└─────────────────────────────────────────┘
         │
         ▼ (Replay events)
┌─────────────────────────────────────────┐
│         Current State (Projection)       │
└─────────────────────────────────────────┘
```

**When to use:**
- Audit trail requirements
- Temporal queries ("state at time X")
- Complex domain with rich history

---

## 4. Integration Patterns

### API Gateway
```
┌────────┐
│ Client │
└───┬────┘
    │
    ▼
┌────────────────┐
│   API Gateway  │  ← Authentication, Rate Limiting, Routing
└───┬────┬────┬──┘
    │    │    │
    ▼    ▼    ▼
┌────┐ ┌────┐ ┌────┐
│ A  │ │ B  │ │ C  │
└────┘ └────┘ └────┘
```

**Responsibilities:**
- Request routing
- Authentication/Authorization
- Rate limiting
- Request/Response transformation
- Caching

### Service Mesh
```
┌─────────────────┐     ┌─────────────────┐
│    Service A    │     │    Service B    │
│  ┌───────────┐  │     │  ┌───────────┐  │
│  │   Proxy   │◀─┼─────┼─▶│   Proxy   │  │
│  └───────────┘  │     │  └───────────┘  │
└─────────────────┘     └─────────────────┘
         │                       │
         └───────────┬───────────┘
                     ▼
            ┌─────────────────┐
            │  Control Plane  │
            │ (Istio, Linkerd)│
            └─────────────────┘
```

**Provides:**
- Service discovery
- Load balancing
- mTLS encryption
- Observability
- Traffic management

---

## 5. Resilience Patterns

### Circuit Breaker
```
States:
CLOSED ──(failures > threshold)──▶ OPEN
   ▲                                 │
   │                        (timeout)│
   │                                 ▼
   └────(success)──── HALF-OPEN ◀───┘
```

**Implementation:**
```python
# Pseudocode
if circuit.is_open():
    if circuit.timeout_expired():
        circuit.set_half_open()
    else:
        raise CircuitOpenError()

try:
    result = call_service()
    circuit.record_success()
    return result
except Exception:
    circuit.record_failure()
    if circuit.should_trip():
        circuit.set_open()
    raise
```

### Retry with Exponential Backoff
```
Attempt 1: Immediate
Attempt 2: Wait 1s
Attempt 3: Wait 2s
Attempt 4: Wait 4s
Attempt 5: Wait 8s (max)
```

### Bulkhead Pattern
```
┌─────────────────────────────────────┐
│            Application              │
├────────────┬────────────┬───────────┤
│ Pool A (10)│ Pool B (20)│Pool C (5) │
│  Critical  │  Standard  │   Batch   │
└────────────┴────────────┴───────────┘
```

**Purpose**: Isolate failures, prevent cascade

---

## 6. Decision Framework

### Architecture Selection Criteria

| Factor | Monolith | Modular Monolith | Microservices |
|--------|----------|------------------|---------------|
| Team Size | 1-5 | 5-15 | 15+ |
| Domain Complexity | Low | Medium | High |
| Scalability Needs | Moderate | Moderate-High | High |
| Deployment Frequency | Low-Medium | Medium | High |
| Operational Maturity | Any | Medium | High |
| Time to Market | Fast | Medium | Slow initially |

### Questions to Ask

1. **What are the scalability requirements?**
2. **How many teams will work on this?**
3. **What is the deployment frequency target?**
4. **What is the team's operational maturity?**
5. **Are there different availability requirements per component?**
6. **What is the acceptable complexity budget?**

---

## References

- [Martin Fowler - Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/)
- [Microsoft - Cloud Design Patterns](https://docs.microsoft.com/en-us/azure/architecture/patterns/)
- [Sam Newman - Building Microservices](https://samnewman.io/books/building_microservices_2nd_edition/)
