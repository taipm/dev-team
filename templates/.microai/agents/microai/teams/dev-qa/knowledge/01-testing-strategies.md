# Testing Strategies - Knowledge Base

## Test Pyramid

```
                    ┌─────────────┐
                    │    E2E      │  ← Ít nhất, chậm nhất, đắt nhất
                    │   Tests     │
                   ─┴─────────────┴─
                  ┌─────────────────┐
                  │  Integration    │  ← Vừa phải
                  │    Tests        │
                 ─┴─────────────────┴─
                ┌───────────────────────┐
                │      Unit Tests       │  ← Nhiều nhất, nhanh nhất, rẻ nhất
                └───────────────────────┘
```

### Unit Tests (70-80%)
- Test individual functions/methods
- Fast, isolated, no external dependencies
- Mock external services
- Focus: Business logic, edge cases

### Integration Tests (15-25%)
- Test component interactions
- Database, API calls, file system
- Focus: Data flow, contracts

### E2E Tests (5-10%)
- Test complete user flows
- Real browser, real services
- Focus: Critical paths only

---

## Risk-Based Testing Prioritization

### Risk Matrix

| Impact ↓ / Likelihood → | Low | Medium | High |
|------------------------|-----|--------|------|
| **High** | Medium | High | Critical |
| **Medium** | Low | Medium | High |
| **Low** | Skip | Low | Medium |

### Prioritization Factors

1. **Business Impact**
   - Revenue affected?
   - User data at risk?
   - Compliance issues?

2. **User Impact**
   - How many users affected?
   - Workaround available?
   - Frequency of use?

3. **Technical Risk**
   - New technology?
   - Complex logic?
   - Integration points?

### Priority Allocation

| Priority | Test Coverage | Examples |
|----------|---------------|----------|
| P1 - Critical | 100% | Auth, Payment, Data integrity |
| P2 - High | 80% | Core features, Admin functions |
| P3 - Medium | 60% | Secondary features |
| P4 - Low | As time allows | Nice-to-have features |

---

## Edge Case Discovery Techniques

### Equivalence Partitioning
Divide inputs into groups that should behave similarly:
- Valid ranges: 1-100 → test 50
- Invalid ranges: <1, >100 → test 0, 101

### Boundary Value Analysis
Test at boundaries:
- min-1, min, min+1
- max-1, max, max+1

### Common Edge Cases

| Category | Edge Cases |
|----------|------------|
| **Strings** | Empty "", null, whitespace, max length, unicode, emoji, special chars |
| **Numbers** | 0, -1, MAX_INT, MIN_INT, NaN, Infinity, decimals |
| **Arrays** | Empty [], single item, max items, duplicates |
| **Dates** | Leap year, month boundaries, timezone changes, DST |
| **Files** | 0 bytes, max size, wrong extension, corrupt file |

### State-Based Testing
- Initial state → transitions → final state
- Concurrent state changes
- Invalid state transitions

---

## Security Testing Checklist

### Authentication
- [ ] Brute force protection
- [ ] Session timeout
- [ ] Password requirements
- [ ] MFA implementation
- [ ] Remember me security

### Authorization
- [ ] Role-based access control
- [ ] Resource ownership validation
- [ ] Privilege escalation prevention
- [ ] API endpoint protection

### Input Validation
- [ ] SQL injection (`'; DROP TABLE--`)
- [ ] XSS (`<script>alert(1)</script>`)
- [ ] Command injection (`; rm -rf /`)
- [ ] Path traversal (`../../etc/passwd`)
- [ ] SSRF (server-side request forgery)

### Data Protection
- [ ] Sensitive data encryption
- [ ] PII handling
- [ ] Logging sensitive data (don't!)
- [ ] Data exposure in errors

---

## Performance Testing Patterns

### Load Testing
- Normal load: Expected concurrent users
- Peak load: Maximum expected users
- Stress load: Beyond capacity

### Metrics to Monitor
- Response time (p50, p95, p99)
- Throughput (requests/second)
- Error rate
- Resource utilization (CPU, memory, DB connections)

### Performance Red Flags
- Response time > 2s for UI
- API response > 500ms
- Database queries > 100ms
- N+1 query patterns
- Memory leaks

### Testing Scenarios
```yaml
scenarios:
  - name: "Normal Load"
    users: 100
    duration: "5m"

  - name: "Peak Load"
    users: 500
    duration: "10m"

  - name: "Stress Test"
    users: 1000
    ramp_up: "5m"
    duration: "15m"
```

---

## Test Data Management

### Test Data Types
- **Static data**: Reference data, configurations
- **Dynamic data**: Created per test, cleaned up after
- **Production-like data**: Anonymized prod data

### Data Generation Strategies
```yaml
strategies:
  - faker: Random realistic data
  - fixtures: Predefined scenarios
  - factories: Programmatic generation
  - snapshots: Real data copies
```

### Data Cleanup
- Before test: Reset to known state
- After test: Clean up created data
- Isolation: Tests don't affect each other

---

## Test Environment Best Practices

### Environment Parity
```
DEV → STAGING → PROD
 ↓       ↓        ↓
Same configs, scaled down
Same services, test data
Same infrastructure, isolated
```

### Configuration Management
- Environment variables
- Feature flags
- Config files per environment
- Secrets management

### Test Environment Checklist
- [ ] Isolated from production
- [ ] Same versions as prod
- [ ] Test data available
- [ ] External services mocked/stubbed
- [ ] Logs accessible
- [ ] Easy to reset
