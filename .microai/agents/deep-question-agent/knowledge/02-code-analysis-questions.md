# Code Analysis Question Library

> Thư viện câu hỏi cốt tử khi phân tích mã nguồn, architecture, và technical decisions.

---

## Mục lục

1. [Architecture Questions](#1-architecture-questions)
2. [Code Quality Questions](#2-code-quality-questions)
3. [Dependencies Questions](#3-dependencies-questions)
4. [Security Questions](#4-security-questions)
5. [Performance Questions](#5-performance-questions)
6. [Maintainability Questions](#6-maintainability-questions)
7. [Testing Questions](#7-testing-questions)
8. [Data & State Questions](#8-data--state-questions)
9. [Error Handling Questions](#9-error-handling-questions)
10. [Deployment & Operations Questions](#10-deployment--operations-questions)

---

## 1. Architecture Questions

### Foundational

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Tại sao chọn kiến trúc này thay vì alternatives?" | First Principles | Challenge convention |
| "Vấn đề gốc mà architecture này giải quyết là gì?" | 5 Whys | Find true purpose |
| "Nếu build lại từ đầu hôm nay, có chọn cách này không?" | First Principles | Check relevance |
| "Architecture này scale như thế nào khi 10x users?" | Pre-mortem | Test limits |

### Structural

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Single point of failure ở đâu?" | Pre-mortem | Identify risks |
| "Component nào tightly coupled nhất? Tại sao?" | 6W2H | Find dependencies |
| "Nếu component X fail, impact lan ra đến đâu?" | Devil's Advocate | Test isolation |
| "Boundaries giữa các services được define thế nào?" | Socratic | Clarify design |

### Decision Tracing

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Decision này được made bởi ai, khi nào, với context gì?" | 6W2H | Understand history |
| "Trade-off chính khi chọn approach này là gì?" | Socratic L3 | Surface implications |
| "Có decision nào cần revisit không?" | Pre-mortem | Identify tech debt |

---

## 2. Code Quality Questions

### Readability

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Newcomer cần bao lâu để hiểu function này?" | Feynman | Test clarity |
| "Tên này convey đúng intent không?" | Socratic L1 | Check naming |
| "Comment có cần thiết không, hay code self-documenting?" | First Principles | Challenge redundancy |
| "Giải thích flow này cho junior developer?" | Feynman | Test understanding |

### Complexity

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Function này làm bao nhiêu việc?" | 6W2H | Check SRP |
| "Có thể break down thành smaller functions không?" | First Principles | Simplify |
| "Cyclomatic complexity của method này?" | 6W2H (How much) | Measure complexity |
| "Nesting level có quá deep không? Tại sao?" | 5 Whys | Understand cause |

### Patterns & Anti-patterns

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Pattern này có fit với problem không?" | Socratic L2 | Check assumptions |
| "Có over-engineering ở đây không?" | Devil's Advocate | Challenge design |
| "Code smell nào đang có? (God class, Long method, etc.)" | Pre-mortem | Identify issues |
| "Tại sao dùng inheritance thay vì composition?" | First Principles | Challenge convention |

---

## 3. Dependencies Questions

### External Dependencies

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Dependencies nào critical nhất cho production?" | 6W2H | Prioritize risk |
| "Nếu dependency X không còn maintained thì sao?" | Pre-mortem | Plan for future |
| "License của dependency này có phù hợp không?" | 6W2H | Legal check |
| "Có dependency nào có known vulnerabilities không?" | Pre-mortem | Security check |

### Internal Dependencies

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Module nào được import nhiều nhất? Tại sao?" | 5 Whys | Find central points |
| "Có circular dependency không?" | Pre-mortem | Check structure |
| "Nếu refactor module X, bao nhiêu nơi bị ảnh hưởng?" | Devil's Advocate | Measure coupling |
| "Dependency graph có hợp lý không?" | Socratic L4 | Alternative views |

### Versioning

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Có dependency nào bị pin version cũ không? Tại sao?" | 5 Whys | Understand constraints |
| "Upgrade path cho major dependencies là gì?" | Pre-mortem | Plan ahead |
| "Breaking changes nào cần monitor?" | Pre-mortem | Risk awareness |

---

## 4. Security Questions

### Authentication & Authorization

| Question | Framework | Purpose |
|----------|-----------|---------|
| "User được authenticate như thế nào?" | 6W2H | Understand flow |
| "Authorization check xảy ra ở đâu? Có consistent không?" | Socratic L3 | Verify implementation |
| "Session được manage và invalidate như thế nào?" | 6W2H | Check completeness |
| "Nếu attacker có access token, họ làm được gì?" | Devil's Advocate | Test boundaries |

### Data Protection

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Data nhạy cảm được bảo vệ thế nào at rest và in transit?" | 6W2H | Check encryption |
| "PII được handle như thế nào? Compliance requirements?" | 6W2H | Legal/compliance |
| "Ai có access đến production data?" | 6W2H (Who) | Access control |
| "Data retention policy là gì?" | 6W2H (When) | Lifecycle |

### Attack Surface

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Endpoints nào public? Input validation ở đâu?" | 6W2H | Map surface |
| "SQL injection, XSS, CSRF được prevent thế nào?" | Pre-mortem | OWASP check |
| "Nếu attacker muốn exploit system, họ sẽ nhắm vào đâu?" | Devil's Advocate | Adversarial thinking |
| "Trust boundaries ở đâu?" | Socratic L1 | Clarify boundaries |

### Secrets Management

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Secrets được store và rotate như thế nào?" | 6W2H | Check practices |
| "Có secret nào hardcoded trong code không?" | Pre-mortem | Find vulnerabilities |
| "Nếu secret bị leak, recovery process là gì?" | Pre-mortem | Incident response |

---

## 5. Performance Questions

### Bottlenecks

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Bottleneck chính của system ở đâu?" | 5 Whys | Find root cause |
| "Response time chậm vì lý do gì?" | 5 Whys | Drill down |
| "Database queries nào chậm nhất?" | 6W2H | Identify hot spots |
| "N+1 query có xảy ra ở đâu không?" | Pre-mortem | Common issue |

### Scalability

| Question | Framework | Purpose |
|----------|-----------|---------|
| "System scale horizontally hay vertically? Tại sao?" | First Principles | Challenge approach |
| "Cần bao nhiêu resources cho 10x current load?" | 6W2H (How much) | Capacity planning |
| "Stateful components nào sẽ là vấn đề khi scale?" | Pre-mortem | Identify blockers |
| "Caching strategy là gì?" | 6W2H | Understand approach |

### Optimization

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Đã profile chưa hay optimize dựa trên intuition?" | Socratic L3 | Check evidence |
| "Premature optimization ở đâu không?" | Devil's Advocate | Challenge |
| "Memory usage có reasonable không?" | 6W2H (How much) | Resource check |
| "Network calls có cần thiết không? Có batch được không?" | First Principles | Reduce overhead |

---

## 6. Maintainability Questions

### Code Evolution

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Thêm feature mới vào module này khó không? Tại sao?" | 5 Whys | Test extensibility |
| "Phần nào của codebase ai cũng sợ touch?" | Pre-mortem | Find danger zones |
| "Tech debt đang tích lũy ở đâu?" | Socratic L2 | Surface assumptions |
| "Refactoring priority list là gì?" | 6W2H | Prioritize work |

### Documentation

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Documentation có up-to-date không?" | Socratic L3 | Verify accuracy |
| "New team member cần docs gì để onboard?" | Feynman | Test completeness |
| "Architecture decisions được document ở đâu?" | 6W2H (Where) | Find ADRs |
| "API documentation có đầy đủ không?" | 6W2H | Coverage check |

### Knowledge Distribution

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Nếu [person] nghỉ, ai biết về component X?" | Pre-mortem | Bus factor |
| "Knowledge silos ở đâu?" | Socratic L4 | Multiple perspectives |
| "Code review process đảm bảo knowledge sharing không?" | 6W2H | Process check |

---

## 7. Testing Questions

### Coverage

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Test coverage là bao nhiêu? Có meaningful không?" | 6W2H + Socratic | Quantity vs Quality |
| "Critical paths có được test không?" | Pre-mortem | Risk coverage |
| "Edge cases nào chưa được cover?" | Devil's Advocate | Find gaps |
| "Có integration tests không? Scope của chúng?" | 6W2H | Test types |

### Quality

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Tests có brittle không? Fail vì wrong reasons?" | 5 Whys | Test reliability |
| "Tests có chạy nhanh không? Blocking CI?" | 6W2H (How much) | Performance |
| "Mocking strategy là gì? Có over-mock không?" | Socratic L2 | Check assumptions |
| "Tests có readable và maintainable không?" | Feynman | Test clarity |

### Missing Tests

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Nếu bug xảy ra, test nào đáng lẽ phải catch?" | Pre-mortem | Gap analysis |
| "Có test cho error conditions không?" | Devil's Advocate | Negative paths |
| "Load/stress testing có không?" | 6W2H | Test types |

---

## 8. Data & State Questions

### Data Model

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Data model có reflect business domain không?" | Feynman | Check alignment |
| "Normalization level có appropriate không?" | First Principles | Challenge design |
| "Schema evolution được handle thế nào?" | Pre-mortem | Plan for change |
| "Có orphaned data không?" | Pre-mortem | Data integrity |

### State Management

| Question | Framework | Purpose |
|----------|-----------|---------|
| "State được manage ở đâu?" | 6W2H (Where) | Locate state |
| "Có global state không? Có cần thiết không?" | First Principles | Challenge |
| "State synchronization giữa components thế nào?" | 6W2H (How) | Understand flow |
| "Race conditions có thể xảy ra ở đâu?" | Pre-mortem | Concurrency issues |

### Data Flow

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Data đi từ input đến output qua những transformations nào?" | 6W2H | Trace flow |
| "Single source of truth ở đâu?" | Socratic L1 | Clarify |
| "Data consistency được guarantee thế nào?" | 6W2H (How) | Check mechanisms |

---

## 9. Error Handling Questions

### Strategy

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Error handling strategy tổng thể là gì?" | 6W2H | Understand approach |
| "Errors được propagate như thế nào?" | 6W2H (How) | Trace flow |
| "Có distinction giữa expected vs unexpected errors không?" | Socratic L1 | Clarify types |
| "Recovery mechanisms là gì?" | Pre-mortem | Plan for failure |

### User Experience

| Question | Framework | Purpose |
|----------|-----------|---------|
| "User thấy gì khi error xảy ra?" | Feynman | Test clarity |
| "Error messages có actionable không?" | Socratic L5 | Check implications |
| "Có graceful degradation không?" | Pre-mortem | Fallback strategy |

### Observability

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Errors được log và monitor như thế nào?" | 6W2H | Check visibility |
| "Alerting strategy là gì?" | 6W2H | Response planning |
| "Đủ context để debug production issues không?" | Pre-mortem | Troubleshooting |

---

## 10. Deployment & Operations Questions

### CI/CD

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Pipeline mất bao lâu? Có bottleneck không?" | 6W2H (How much) | Efficiency |
| "Rollback process là gì?" | Pre-mortem | Recovery plan |
| "Có canary/blue-green deployment không?" | 6W2H | Risk reduction |
| "Ai có quyền deploy to production?" | 6W2H (Who) | Access control |

### Monitoring

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Metrics nào được track?" | 6W2H (What) | Coverage |
| "SLIs/SLOs được define chưa?" | 6W2H | Objectives |
| "Nếu system down lúc 3AM, biết ngay không?" | Pre-mortem | Alerting |
| "Dashboards có useful không?" | Feynman | Clarity |

### Incident Response

| Question | Framework | Purpose |
|----------|-----------|---------|
| "Incident response process là gì?" | 6W2H | Procedure |
| "Post-mortem có được làm không?" | 6W2H | Learning |
| "Runbooks có cho common incidents không?" | Pre-mortem | Preparation |
| "On-call rotation như thế nào?" | 6W2H (Who, When) | Responsibility |

---

## Question Selection Guide

### By Code Review Stage

| Stage | Focus Questions |
|-------|-----------------|
| **Initial Review** | Architecture, Naming, Complexity |
| **Deep Dive** | Dependencies, Data Flow, Error Handling |
| **Security Review** | Auth, Data Protection, Attack Surface |
| **Pre-Production** | Testing, Deployment, Monitoring |

### By Risk Level

| Risk Level | Priority Questions |
|------------|-------------------|
| **High Risk** | Security, Single Point of Failure, Recovery |
| **Medium Risk** | Performance, Scalability, Error Handling |
| **Low Risk** | Code Quality, Documentation, Naming |

### By Team Experience

| Experience | Question Style |
|------------|----------------|
| **New to codebase** | 6W2H (comprehensive coverage) |
| **Familiar** | 5 Whys, Devil's Advocate (challenge assumptions) |
| **Expert** | First Principles, Pre-mortem (strategic thinking) |

---

*Load file này khi topic type = code/architecture/technical*
