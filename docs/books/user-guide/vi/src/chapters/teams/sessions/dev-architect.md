# dev-architect-session

Dialogue giữa Developer và Solution Architect để thiết kế hệ thống.

## Kích Hoạt

```
/microai:dev-architect-session
```

## Mục Đích

- Thiết kế system architecture
- Tạo Architecture Decision Records (ADR)
- Review architectural decisions
- Evaluate trade-offs

## Roles

### 👨‍💻 Developer
- Đặt câu hỏi về implementation
- Thách thức decisions
- Xem xét constraints thực tế
- Đề xuất alternatives

### 🏛️ Solution Architect
- Thiết kế high-level architecture
- Explain rationale
- Consider scalability, reliability
- Document decisions

## Dialogue Flow

```
Turn 1: Developer describe needs
Turn 2: Architect clarify requirements
Turn 3: Developer provide constraints
Turn 4: Architect propose design
Turn 5: Developer challenge decisions
Turn 6: Architect justify with trade-offs
Turn 7: Final design + ADR
```

## Output Formats

### 1. System Design

```
# System Design: [Name]

## Overview
[High-level description]

## Components
- Component A: [purpose]
- Component B: [purpose]

## Data Flow
[Diagram or description]

## Technology Choices
| Component | Technology | Rationale |
|-----------|------------|-----------|
| API | Go | Performance |
| Database | PostgreSQL | ACID |
```

### 2. Architecture Decision Record (ADR)

```
# ADR-001: [Title]

## Status
Proposed | Accepted | Deprecated

## Context
[Why this decision is needed]

## Decision
[What we decided]

## Consequences
### Positive
- [benefit]

### Negative
- [trade-off]

## Alternatives Considered
1. [Alternative A] - rejected because...
2. [Alternative B] - rejected because...
```

## Ví Dụ Session

```
You: /microai:dev-architect-session

Developer: 👨‍💻 Tôi cần thiết kế payment service
cho e-commerce platform.

Architect: 🏛️ Trước khi thiết kế, cần clarify:
1. Volumes dự kiến? (transactions/day)
2. Payment methods nào? (Card, wallet, bank)
3. Compliance requirements? (PCI-DSS?)

Developer: 👨‍💻
- 10K transactions/day, có thể scale 10x
- Cards và bank transfer
- Cần PCI-DSS compliance

Architect: 🏛️ Với PCI-DSS, tôi đề xuất:

**Architecture:**
```
┌─────────┐    ┌─────────────┐    ┌──────────┐
│ API GW  │───▶│ Payment Svc │───▶│ PSP/Bank │
└─────────┘    └─────────────┘    └──────────┘
                     │
                     ▼
              ┌─────────────┐
              │ Vault (keys)│
              └─────────────┘
```

**Key decisions:**
1. Không store card data - dùng PSP tokenization
2. Separate encryption service (Vault)
3. Async processing cho bank transfers

Developer: 👨‍💻 Tại sao không store card data?
Có làm tăng latency không?

Architect: 🏛️ Trade-off:

| Approach | Latency | Compliance | Complexity |
|----------|---------|------------|------------|
| Store cards | Low | PCI Level 1 (hard) | High |
| Tokenization | +50ms | PCI Level 4 (easy) | Low |

+50ms latency chấp nhận được,
đổi lại giảm 90% compliance effort.

Developer: 👨‍💻 Makes sense. Tạo ADR cho quyết định này?

Architect: 🏛️
# ADR-001: Use PSP Tokenization for Card Storage

## Status: Accepted

## Context
Need to handle card payments with PCI-DSS compliance.

## Decision
Use Payment Service Provider tokenization
instead of storing card data ourselves.

## Consequences
### Positive
- Simplified PCI compliance (Level 4)
- Reduced security burden
- Faster time to market

### Negative
- +50ms latency per transaction
- Vendor dependency
```

## Xem Thêm

- [Session Teams Overview](../session-teams.md)
- [System Design Workflow](../../workflows/system-design.md)
