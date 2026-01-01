# System Design Checklist

## Overview
Checklist để đảm bảo system design addresses các concerns quan trọng. Sử dụng trong dev-architect sessions khi reviewing hoặc proposing designs.

---

## 1. Requirements Clarity

### Functional Requirements
- [ ] Core features clearly defined
- [ ] User flows documented
- [ ] API contracts specified
- [ ] Data models identified
- [ ] Integration points listed

### Non-Functional Requirements
- [ ] Performance targets defined (latency, throughput)
- [ ] Scalability requirements (users, data volume)
- [ ] Availability requirements (SLA, uptime)
- [ ] Security requirements (authentication, authorization, data protection)
- [ ] Compliance requirements (GDPR, PCI-DSS, HIPAA)

### Constraints
- [ ] Budget constraints
- [ ] Timeline constraints
- [ ] Technology constraints
- [ ] Team skill constraints
- [ ] Legacy system constraints

---

## 2. Architecture Overview

### High-Level Design
- [ ] System context diagram
- [ ] Container diagram (C4 Level 2)
- [ ] Key components identified
- [ ] Component responsibilities clear
- [ ] Boundaries between components defined

### Communication
- [ ] Internal communication patterns defined
- [ ] External API design specified
- [ ] Sync vs async decisions documented
- [ ] Message formats agreed upon
- [ ] Error handling strategy defined

### Data Architecture
- [ ] Data storage decisions made
- [ ] Data models designed
- [ ] Data flow documented
- [ ] Data consistency strategy defined
- [ ] Data retention policies considered

---

## 3. Scalability

### Horizontal Scaling
- [ ] Stateless services where possible
- [ ] Session management strategy
- [ ] Load balancing approach
- [ ] Auto-scaling policies

### Data Scaling
- [ ] Database sharding strategy (if needed)
- [ ] Read replicas for read-heavy workloads
- [ ] Caching strategy defined
- [ ] CDN for static assets

### Capacity Planning
```
Questions to answer:
- Expected users: ___
- Peak concurrent users: ___
- Requests per second (avg): ___
- Requests per second (peak): ___
- Data growth rate: ___/month
- Storage requirements: ___TB in 1 year
```

---

## 4. Reliability & Availability

### Failure Modes
- [ ] Single points of failure identified
- [ ] Failure scenarios documented
- [ ] Recovery procedures defined
- [ ] Fallback mechanisms in place

### High Availability
- [ ] Multi-zone/region deployment
- [ ] Database failover strategy
- [ ] Health checks configured
- [ ] Circuit breakers implemented

### Disaster Recovery
- [ ] Backup strategy defined
- [ ] Recovery Point Objective (RPO)
- [ ] Recovery Time Objective (RTO)
- [ ] Disaster recovery runbook

### Availability Targets
| Availability | Downtime/Year | Downtime/Month |
|--------------|---------------|----------------|
| 99% | 3.65 days | 7.31 hours |
| 99.9% | 8.76 hours | 43.83 minutes |
| 99.99% | 52.56 minutes | 4.38 minutes |
| 99.999% | 5.26 minutes | 26.3 seconds |

---

## 5. Security

### Authentication & Authorization
- [ ] Authentication mechanism (OAuth, JWT, SAML)
- [ ] Authorization model (RBAC, ABAC)
- [ ] Session management
- [ ] Password policies
- [ ] MFA support

### Data Security
- [ ] Data encryption at rest
- [ ] Data encryption in transit (TLS)
- [ ] Sensitive data handling (PII)
- [ ] Data masking for non-prod
- [ ] Key management strategy

### Network Security
- [ ] Network segmentation
- [ ] Firewall rules
- [ ] API rate limiting
- [ ] DDoS protection
- [ ] WAF configuration

### Application Security
- [ ] Input validation
- [ ] Output encoding
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Dependency vulnerability scanning

---

## 6. Performance

### Response Time Targets
```
Type           | Target    | Acceptable
---------------|-----------|------------
Page load      | < 2s      | < 4s
API response   | < 200ms   | < 500ms
Search query   | < 100ms   | < 300ms
Report generation | < 30s  | < 60s
```

### Optimization Strategies
- [ ] Caching strategy (application, database, CDN)
- [ ] Database query optimization
- [ ] Connection pooling
- [ ] Async processing for heavy operations
- [ ] Lazy loading
- [ ] Compression (gzip, brotli)

### Performance Testing
- [ ] Load testing plan
- [ ] Stress testing plan
- [ ] Performance benchmarks defined
- [ ] Performance monitoring in place

---

## 7. Observability

### Logging
- [ ] Logging strategy defined
- [ ] Log levels standardized
- [ ] Structured logging format
- [ ] Centralized log aggregation
- [ ] Log retention policy

### Metrics
- [ ] Key metrics identified (RED: Rate, Errors, Duration)
- [ ] Business metrics defined
- [ ] Metrics collection mechanism
- [ ] Dashboards designed
- [ ] Alerting thresholds set

### Tracing
- [ ] Distributed tracing implemented
- [ ] Trace context propagation
- [ ] Trace sampling strategy

### Monitoring & Alerting
- [ ] Health check endpoints
- [ ] Synthetic monitoring
- [ ] Alert runbooks
- [ ] On-call rotation

---

## 8. Operations

### Deployment
- [ ] CI/CD pipeline defined
- [ ] Deployment strategy (blue-green, canary, rolling)
- [ ] Rollback procedure
- [ ] Feature flags for gradual rollout
- [ ] Environment parity (dev, staging, prod)

### Configuration Management
- [ ] Environment-specific configuration
- [ ] Secret management
- [ ] Configuration versioning
- [ ] Dynamic configuration updates

### Infrastructure
- [ ] Infrastructure as Code (Terraform, Pulumi)
- [ ] Container orchestration (Kubernetes)
- [ ] Auto-scaling configuration
- [ ] Cost optimization

---

## 9. Development Experience

### Local Development
- [ ] Easy local setup (docker-compose)
- [ ] Mock external dependencies
- [ ] Seed data for development
- [ ] Documentation for setup

### Testing
- [ ] Unit test strategy
- [ ] Integration test strategy
- [ ] E2E test strategy
- [ ] Test data management
- [ ] CI test automation

### Documentation
- [ ] API documentation (OpenAPI/Swagger)
- [ ] Architecture diagrams
- [ ] ADRs for key decisions
- [ ] Runbooks for operations
- [ ] Onboarding guide

---

## 10. Migration & Evolution

### Migration Strategy
- [ ] Data migration plan
- [ ] Feature migration plan
- [ ] Backward compatibility approach
- [ ] Migration rollback plan

### Future Considerations
- [ ] Extensibility points identified
- [ ] Deprecation strategy
- [ ] Version strategy
- [ ] Technical debt tracking

---

## Quick Review Checklist

### Before Design Review
```
□ Requirements documented
□ Constraints understood
□ Stakeholders identified
□ Success criteria defined
```

### During Design Review
```
□ Architecture diagrams clear
□ Trade-offs discussed
□ Alternatives considered
□ Risks identified
□ ADR drafted
```

### After Design Review
```
□ ADR finalized
□ Action items assigned
□ Timeline agreed
□ Follow-up scheduled
```

---

## Design Review Questions

### For Architect
1. What are the key design decisions?
2. What alternatives were considered?
3. What are the main trade-offs?
4. How does this scale to 10x load?
5. What happens when X fails?

### For Developer
1. How complex is the implementation?
2. What's the estimated timeline?
3. What dependencies are needed?
4. What's the testing strategy?
5. What could go wrong during implementation?

### For Both
1. Are requirements fully understood?
2. Is the design documented enough?
3. What are the biggest risks?
4. What needs clarification?
5. When should we revisit this decision?
