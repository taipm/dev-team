# dev-security-session

Dialogue giữa Developer và Security Engineer để review bảo mật.

## Kích Hoạt

```
/microai:dev-security-session
```

## Mục Đích

- Security code review
- Threat modeling
- Vulnerability assessment
- Security best practices

## Roles

### 👨‍💻 Developer
- Giải thích implementation
- Discuss security measures đã có
- Respond to findings
- Implement fixes

### 🔒 Security Engineer
- Review for vulnerabilities
- Apply OWASP guidelines
- Create threat models
- Suggest mitigations

## Output Formats

### 1. Security Review Report

```markdown
# Security Review: [Feature/Component]

## Summary
- **Risk Level**: Critical/High/Medium/Low
- **Findings**: X issues found
- **Status**: Needs fixes / Approved

## Findings

### SEC-001: [Title]
- **Severity**: Critical
- **Category**: OWASP A01 - Broken Access Control
- **Location**: file.go:123
- **Description**: ...
- **Recommendation**: ...
- **Reference**: [link]

### SEC-002: [Title]
...

## Positive Findings
- [Good practice found]
```

### 2. Threat Model

```markdown
# Threat Model: [System]

## Assets
- User credentials
- Payment data
- Personal information

## Threat Actors
- External attackers
- Malicious insiders
- Automated bots

## Attack Vectors
| Vector | Likelihood | Impact | Risk |
|--------|------------|--------|------|
| SQL Injection | Medium | High | High |
| CSRF | Low | Medium | Low |

## Mitigations
| Threat | Mitigation | Status |
|--------|------------|--------|
| SQL Injection | Parameterized queries | ✅ |
| CSRF | CSRF tokens | ⚠️ Partial |
```

## Ví Dụ Session

```
You: /microai:dev-security-session

Developer: 👨‍💻 Review API authentication của tôi?

Security: 🔒 OK! Cho tôi xem:
1. Authentication mechanism?
2. Session management?
3. Có rate limiting không?

Developer: 👨‍💻
- JWT tokens, 24h expiry
- Stored in localStorage
- Rate limit: 100 req/min

Security: 🔒 Tôi thấy một số issues:

### SEC-001: Insecure Token Storage
- **Severity**: High
- **Issue**: localStorage vulnerable to XSS
- **Recommendation**: Use httpOnly cookies

### SEC-002: Long Token Expiry
- **Severity**: Medium
- **Issue**: 24h too long for sensitive actions
- **Recommendation**:
  - Access token: 15min
  - Refresh token: 7 days (with rotation)

Developer: 👨‍💻 Về localStorage, team muốn SPA
không dùng cookies. Có alternative?

Security: 🔒 Options:
1. **httpOnly cookie** (recommended) -
   requires same-origin hoặc proper CORS

2. **In-memory + refresh** -
   Store in memory, refresh token in httpOnly

3. **Service Worker** -
   Store token in SW, intercept requests

Option 2 là balance tốt cho SPA:
```javascript
// Access token in memory (XSS-safe)
let accessToken = null;

// Refresh token in httpOnly cookie
// Refresh endpoint: POST /auth/refresh
```

Developer: 👨‍💻 Option 2 hợp lý. Tôi sẽ implement.

Security: 🔒 Perfect! Updated threat model:

## Threat Model Update

| Threat | Before | After | Status |
|--------|--------|-------|--------|
| XSS token theft | High | Low | ✅ Fixed |
| Token replay | Medium | Low | ✅ Shorter expiry |
```

## OWASP Top 10 Coverage

| OWASP | Category | Trong session |
|-------|----------|---------------|
| A01 | Broken Access Control | ✅ |
| A02 | Cryptographic Failures | ✅ |
| A03 | Injection | ✅ |
| A07 | Cross-Site Scripting | ✅ |

## Xem Thêm

- [Session Teams Overview](../session-teams.md)
- [Security Review Workflow](../../workflows/security-review.md)
