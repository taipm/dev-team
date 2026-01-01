# Technical Specification Guide

## Overview
Hướng dẫn viết Technical Specs cho PM-Dev collaboration sessions.

---

## 1. When to Write Tech Specs

### Always Write Spec For:
- New features affecting multiple components
- API changes
- Database schema changes
- System architecture changes
- Features requiring coordination across teams

### Skip Spec For:
- Bug fixes (simple)
- Small UI tweaks
- Configuration changes
- Well-understood, routine tasks

---

## 2. Tech Spec Structure

### Standard Template

```markdown
# Technical Specification: {Feature Name}

## 1. Overview
### 1.1 Summary
{One paragraph description}

### 1.2 Background
{Context and motivation}

### 1.3 Goals
- {Goal 1}
- {Goal 2}

### 1.4 Non-Goals
- {Explicitly out of scope 1}
- {Explicitly out of scope 2}

## 2. Requirements
### 2.1 Functional Requirements
{User stories or requirements}

### 2.2 Non-Functional Requirements
- Performance: {requirements}
- Security: {requirements}
- Scalability: {requirements}

## 3. Technical Design
### 3.1 Architecture Overview
{Diagram or description}

### 3.2 Data Model
{Schema changes}

### 3.3 API Design
{Endpoints, request/response}

### 3.4 Dependencies
{External and internal dependencies}

## 4. Implementation Plan
### 4.1 Milestones
{Breakdown of work}

### 4.2 Timeline
{Estimated schedule}

## 5. Testing Strategy
{How to verify correctness}

## 6. Rollout Plan
{How to deploy safely}

## 7. Risks & Mitigations
{What could go wrong}

## 8. Open Questions
{Unresolved decisions}

## 9. Appendix
{Additional details, references}
```

---

## 3. Section Deep Dives

### Overview Section

**Summary** - Answer: What are we building and why?
```markdown
This spec proposes adding a real-time notification system
that alerts users when their orders are updated. Currently,
users must manually check order status, leading to support
tickets and poor user experience.
```

**Goals** - Measurable outcomes
```markdown
### Goals
- Reduce order status support tickets by 30%
- Deliver order updates within 5 seconds of status change
- Support 100K concurrent users
```

**Non-Goals** - Prevent scope creep
```markdown
### Non-Goals
- Push notifications to mobile devices (future phase)
- Marketing notifications (separate system)
- Historical notification retrieval (not needed initially)
```

### Technical Design Section

**Architecture Overview**
```markdown
### Architecture

```
┌─────────┐     ┌─────────────┐     ┌─────────────┐
│  Order  │────▶│ Event Queue │────▶│ Notification│
│ Service │     │  (Redis)    │     │   Service   │
└─────────┘     └─────────────┘     └──────┬──────┘
                                           │
                                    ┌──────┴──────┐
                                    │  WebSocket  │
                                    │   Server    │
                                    └──────┬──────┘
                                           │
                                    ┌──────┴──────┐
                                    │   Browser   │
                                    │   Client    │
                                    └─────────────┘
```

**Data Flow:**
1. Order Service publishes status change to Redis
2. Notification Service consumes events
3. Sends to connected users via WebSocket
```

**Data Model**
```markdown
### Data Model

#### New Table: notifications

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | FK to users |
| type | VARCHAR(50) | Notification type |
| payload | JSONB | Notification data |
| read_at | TIMESTAMP | When user read it |
| created_at | TIMESTAMP | Creation time |

#### Index
- user_id, created_at (for listing user notifications)
```

**API Design**
```markdown
### API Endpoints

#### GET /api/notifications
List user's notifications

**Request:**
```
GET /api/notifications?limit=20&offset=0
Authorization: Bearer {token}
```

**Response:**
```json
{
  "notifications": [
    {
      "id": "uuid",
      "type": "order_status",
      "payload": {
        "order_id": "123",
        "status": "shipped"
      },
      "read_at": null,
      "created_at": "2024-01-15T10:00:00Z"
    }
  ],
  "total": 45
}
```

#### POST /api/notifications/{id}/read
Mark notification as read
```

### Implementation Plan

```markdown
### Milestones

#### Milestone 1: Backend Infrastructure (Week 1)
- [ ] Set up Redis pub/sub
- [ ] Create notification service
- [ ] Implement database schema
- [ ] Basic API endpoints

#### Milestone 2: WebSocket Layer (Week 2)
- [ ] WebSocket server setup
- [ ] Connection management
- [ ] Authentication integration

#### Milestone 3: Frontend Integration (Week 3)
- [ ] WebSocket client
- [ ] Notification UI component
- [ ] State management

#### Milestone 4: Polish & Deploy (Week 4)
- [ ] End-to-end testing
- [ ] Performance testing
- [ ] Monitoring setup
- [ ] Staged rollout
```

### Testing Strategy

```markdown
### Testing Strategy

#### Unit Tests
- Notification service logic
- Event processing
- API endpoints

#### Integration Tests
- Redis pub/sub flow
- WebSocket connection
- Database operations

#### Load Tests
- 100K concurrent WebSocket connections
- 10K notifications per second
- Failover scenarios

#### E2E Tests
- Complete flow: order → notification → UI
- Multi-device scenarios
```

### Risks & Mitigations

```markdown
### Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| WebSocket scaling | Medium | High | Use sticky sessions, horizontal scaling |
| Redis failure | Low | High | Redis Cluster with failover |
| Notification delay | Medium | Medium | Monitoring, alerting, SLA |
| Client disconnection | High | Low | Reconnection with exponential backoff |
```

---

## 4. Estimation in Tech Specs

### Breakdown Format

```markdown
### Effort Estimate

| Component | Estimate | Confidence | Notes |
|-----------|----------|------------|-------|
| Backend API | 3 days | High | Standard CRUD |
| WebSocket server | 5 days | Medium | New technology |
| Frontend integration | 3 days | High | Similar to existing |
| Testing | 4 days | Medium | Load testing setup |
| Documentation | 1 day | High | |
| **Total** | **16 days** | **Medium** | |

### Assumptions
- Redis cluster already available
- No major changes to auth system
- Dedicated dev resources

### Dependencies
- DevOps: Redis cluster setup (Week 1)
- Frontend: Design mockups (Week 1)
```

---

## 5. Review Checklist

### Before Submission
- [ ] Problem clearly stated
- [ ] Goals are measurable
- [ ] Non-goals explicitly listed
- [ ] Architecture diagram included
- [ ] API contracts defined
- [ ] Data model changes documented
- [ ] Estimates with assumptions
- [ ] Risks identified
- [ ] Testing strategy outlined

### During Review
- [ ] Security implications considered
- [ ] Scalability addressed
- [ ] Edge cases handled
- [ ] Backwards compatibility checked
- [ ] Monitoring/observability planned

---

## 6. Spec Lifecycle

```
┌─────────────┐
│   Draft     │ ← Initial write-up
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Review    │ ← Team feedback
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Approved   │ ← Ready to implement
└──────┬──────┘
       │
       ▼
┌─────────────┐
│Implementing │ ← In progress
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Complete   │ ← Shipped
└─────────────┘
```

---

## 7. PM-Dev Collaboration Tips

### For PM:
- Provide clear requirements before spec
- Review spec for user experience impact
- Ask clarifying questions
- Validate scope alignment

### For Dev:
- Explain technical decisions simply
- Flag risks early
- Provide realistic estimates
- Document assumptions

### In Collaboration:
- Use diagrams for complex flows
- Align on scope before details
- Document decisions and rationale
- Iterate based on feedback

---

## References

- [Design Docs at Google](https://www.industrialempathy.com/posts/design-docs-at-google/)
- [Technical Specification Template](https://github.com/joelparkerhenderson/architecture-decision-record)
