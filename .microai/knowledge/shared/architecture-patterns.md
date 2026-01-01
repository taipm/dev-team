# Architecture Patterns Reference

> Shared knowledge for Dev-Architect and Dev-Security teams

## Overview

Common software architecture patterns and when to apply them.

---

## 1. Layered Architecture

```
┌─────────────────────────────────┐
│     Presentation Layer          │
├─────────────────────────────────┤
│     Business Logic Layer        │
├─────────────────────────────────┤
│     Data Access Layer           │
├─────────────────────────────────┤
│     Database                    │
└─────────────────────────────────┘
```

### When to Use
- Traditional enterprise applications
- Clear separation of concerns needed
- Team organized by layer expertise

### Trade-offs
| Pros | Cons |
|------|------|
| Easy to understand | Can be monolithic |
| Clear dependencies | Changes cascade through layers |
| Testable in isolation | Over-engineering risk |

---

## 2. Microservices

```
┌─────────┐  ┌─────────┐  ┌─────────┐
│ Service │  │ Service │  │ Service │
│    A    │  │    B    │  │    C    │
└────┬────┘  └────┬────┘  └────┬────┘
     │            │            │
     └────────────┼────────────┘
                  │
          ┌───────▼───────┐
          │  API Gateway  │
          └───────────────┘
```

### When to Use
- Large teams (2+ pizza rule)
- Independent deployment needed
- Different tech stacks per service
- High scalability requirements

### Trade-offs
| Pros | Cons |
|------|------|
| Independent scaling | Distributed complexity |
| Technology flexibility | Network latency |
| Fault isolation | Data consistency challenges |
| Team autonomy | Operational overhead |

---

## 3. Event-Driven Architecture

```
┌─────────┐         ┌─────────────┐         ┌─────────┐
│ Producer│ ──────► │ Event Broker│ ──────► │ Consumer│
└─────────┘         │  (Kafka)    │         └─────────┘
                    └─────────────┘
                          │
                    ┌─────▼─────┐
                    │ Consumer B │
                    └───────────┘
```

### When to Use
- Decoupled systems
- Async processing
- Real-time data needs
- Audit trail required

### Trade-offs
| Pros | Cons |
|------|------|
| Loose coupling | Eventual consistency |
| Scalability | Debugging complexity |
| Audit trail | Event ordering challenges |

---

## 4. Hexagonal (Ports & Adapters)

```
                    ┌─────────────────────┐
     ┌─────────────►│                     │◄──────────────┐
     │              │    Domain Logic     │               │
     │   Adapters   │     (Core)          │   Adapters    │
     │   (Driving)  │                     │   (Driven)    │
     │              └─────────────────────┘               │
     │                      ▲                             │
  ┌──┴──┐               ┌───┴───┐               ┌────────┴┐
  │ REST │               │ Ports │               │ Database│
  │ API  │               │       │               │ Adapter │
  └──────┘               └───────┘               └─────────┘
```

### When to Use
- Domain-driven design
- High testability needed
- External systems integration
- Future infrastructure changes expected

### Trade-offs
| Pros | Cons |
|------|------|
| Highly testable | Learning curve |
| Infrastructure agnostic | More code to maintain |
| Clear boundaries | Can be overkill for simple apps |

---

## 5. CQRS (Command Query Responsibility Segregation)

```
┌─────────┐     ┌─────────────┐     ┌─────────────┐
│ Commands│────►│ Write Model │────►│ Write DB    │
└─────────┘     └─────────────┘     └──────┬──────┘
                                           │ Event
                                           ▼
┌─────────┐     ┌─────────────┐     ┌─────────────┐
│ Queries │◄────│ Read Model  │◄────│ Read DB     │
└─────────┘     └─────────────┘     └─────────────┘
```

### When to Use
- Read/write patterns very different
- Complex domains
- High read scalability needed
- Event sourcing scenarios

### Trade-offs
| Pros | Cons |
|------|------|
| Optimized read/write | Increased complexity |
| Scalability | Eventual consistency |
| Flexibility | More infrastructure |

---

## 6. Pattern Selection Guide

| Scenario | Recommended Pattern |
|----------|---------------------|
| Simple CRUD app | Layered |
| Large distributed team | Microservices |
| Real-time processing | Event-Driven |
| Complex domain logic | Hexagonal |
| Heavy read workloads | CQRS |
| High availability needed | Microservices + Event |

---

## 7. Security Considerations

### Per Pattern
| Pattern | Key Security Concerns |
|---------|----------------------|
| Layered | Validate at every layer |
| Microservices | Service-to-service auth, API Gateway |
| Event-Driven | Event authenticity, encryption at rest |
| Hexagonal | Input validation at ports |
| CQRS | Separate auth for read/write |

### General Principles
- Defense in depth
- Principle of least privilege
- Secure defaults
- Fail securely

---

## Quick Reference

```
Layered      → Simple, clear separation
Microservices → Independent, scalable
Event-Driven  → Decoupled, async
Hexagonal    → Testable, domain-centric
CQRS         → Optimized read/write
```

---

*Last updated: 2024-12-31*
*Applicable teams: dev-architect, dev-security*
