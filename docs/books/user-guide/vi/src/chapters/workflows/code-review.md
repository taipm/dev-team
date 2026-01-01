# Review Code

Workflow review code với dev-team.

## Options

| Need | Agent/Team | Command |
|------|------------|---------|
| Functional review | dev-qa-session | `/microai:dev-qa-session` |
| Security review | dev-security-session | `/microai:dev-security-session` |
| Go code review | go-review-linus | `/microai:go:go-review-linus` |

## Workflow: QA Review

### Bước 1: Kích Hoạt

```
/microai:dev-qa-session
```

### Bước 2: Provide Code

```
Review code trong handlers/user.go
Focus: Error handling và edge cases
```

### Bước 3: Review Output

```markdown
# Code Review: handlers/user.go

## Issues Found

### HIGH: Missing input validation
- Line 45: Email không validate format
- Fix: Add email regex validation

### MEDIUM: Incomplete error handling
- Line 72: Error swallowed, not logged
- Fix: Log error before returning

### LOW: Magic numbers
- Line 30: `if len(name) > 50`
- Fix: Use constant MAX_NAME_LENGTH

## Positive Findings
- Good use of context propagation
- Proper HTTP status codes
```

## Workflow: Security Review

### Bước 1: Kích Hoạt

```
/microai:dev-security-session
```

### Bước 2: Provide Code

```
Review auth middleware cho vulnerabilities
```

### Bước 3: Review Output

```markdown
# Security Review: auth/middleware.go

## Severity: HIGH

### SEC-001: JWT Secret in Code
- Location: line 15
- Issue: Secret hardcoded
- Fix: Use environment variable

### SEC-002: Missing Rate Limiting
- Location: login handler
- Issue: Brute force possible
- Fix: Add rate limiting

## OWASP Coverage
- A02 Cryptographic Failures: ⚠️ Issue found
- A07 Identification Failures: ⚠️ Issue found
```

## Workflow: Linus-style Review

Cho Go code với brutally honest feedback.

### Bước 1: Kích Hoạt

```
/microai:go:go-review-linus
```

### Bước 2: Review

```
Review file service/order.go
```

### Bước 3: Expect Harsh Feedback

```
👿 Code Review:

❌ Line 45: "This error handling is garbage.
   You're eating the error and returning nil?
   That's how you get mystery bugs at 3am."

❌ Line 67: "Why are you allocating inside a loop?
   Did you learn to code yesterday?"

⚠️ Line 82: "At least you got context right.
   Small victories."

Fix these before I look at this again.
```

## Tips

### Specify Focus

```
Review với focus:
- Performance
- Security
- Error handling
- Naming conventions
```

### Provide Context

```
Context:
- High traffic API (1000 req/s)
- User-facing endpoint
- Contains PII
```

### Follow Up

Sau khi fix, có thể re-review:

```
Đã fix theo feedback.
Review lại những thay đổi?
```

## Xem Thêm

- [dev-qa-session](../teams/sessions/dev-qa.md)
- [dev-security-session](../teams/sessions/dev-security.md)
