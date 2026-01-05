---
id: H-5
name: SQL Injection Detection
category: Security
difficulty: 6
points: 7
keywords:
  - SQL injection
  - parameterized
  - prepared
  - error handling
  - sanitize
  - query
  - placeholder
---

# SQL Injection Detection

## Prompt

<prompt>
```go
func getUserData(w http.ResponseWriter, r *http.Request) {
    userID := r.URL.Query().Get("id")
    query := fmt.Sprintf("SELECT * FROM users WHERE id = '%s'", userID)
    rows, _ := db.Query(query)
    // ... process rows
}
```

Identify ALL security issues and fix them.
</prompt>

## Expected Behavior

The answer should identify:
1. **SQL Injection** - Primary vulnerability
2. **Error ignored** - `_` on db.Query error
3. **No input validation** - userID not validated
4. **Potential info leak** - Error details to client

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | Identifies SQL injection + error handling + provides secure code |
| 6 pts | Identifies SQL injection with parameterized query fix |
| 5 pts | Identifies SQL injection with partial fix |
| 4 pts | Identifies injection without proper fix |
| 3 pts | Mentions security concern vaguely |
| 2 pts | Notices something wrong |
| 0 pts | Says code is secure |

## Good Answer Example

```
SECURITY ISSUES:

1. SQL INJECTION (Critical - OWASP Top 10)
   User input directly concatenated into SQL query.
   Attacker can inject: id=' OR '1'='1' --
   This would return ALL users.

   Worse: id='; DROP TABLE users; --
   Could delete the entire table.

2. ERROR IGNORED (High)
   rows, _ := db.Query() ignores errors.
   - Database errors are silently swallowed
   - Could mask injection attempts
   - Hard to debug issues

3. NO INPUT VALIDATION (Medium)
   - userID could be empty string
   - No length limit
   - No format validation (should be numeric?)

4. POTENTIAL INFO LEAK (Low)
   - If errors are returned to client, could leak DB structure
   - Stack traces shouldn't be shown in production

SECURE VERSION:

func getUserData(w http.ResponseWriter, r *http.Request) {
    userID := r.URL.Query().Get("id")

    // Input validation
    if userID == "" {
        http.Error(w, "id parameter required", http.StatusBadRequest)
        return
    }

    // Validate format (assuming numeric IDs)
    if _, err := strconv.Atoi(userID); err != nil {
        http.Error(w, "invalid id format", http.StatusBadRequest)
        return
    }

    // Parameterized query - PREVENTS SQL INJECTION
    query := "SELECT id, name, email FROM users WHERE id = $1"
    rows, err := db.Query(query, userID)
    if err != nil {
        log.Printf("database error: %v", err) // Log internally
        http.Error(w, "internal error", http.StatusInternalServerError)
        return
    }
    defer rows.Close()

    // ... process rows with error checking
}

Key fixes:
1. Use parameterized queries ($1 placeholder)
2. Check and handle all errors
3. Validate input before use
4. Don't leak error details to client
5. Select specific columns, not SELECT *
```

## Why This Test

- SQL injection is OWASP #1 vulnerability
- Tests security awareness
- Multiple issues require comprehensive review
- Solution demonstrates defense in depth
