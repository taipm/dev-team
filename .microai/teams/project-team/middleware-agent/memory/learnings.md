# Middleware Agent Learnings

> Security patterns discovered.

---

## Authentication

### Pattern: Always Validate JWT

**Observation**: Never trust client-provided tokens.

**Solution**: Always verify signature and expiration.

**Example**:
```go
// Good: Full validation
claims, err := validateJWT(tokenString, secret)
if err != nil {
    http.Error(w, "Unauthorized", http.StatusUnauthorized)
    return
}
```

**Anti-pattern**:
```go
// ❌ Never skip validation
claims := decodeJWTWithoutVerification(token)
```

---

## Quick Reference

| Pattern | Category | When to Apply |
|---------|----------|---------------|
| Always Validate JWT | Auth | Every request |
