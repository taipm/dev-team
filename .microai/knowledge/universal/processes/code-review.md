# Universal Code Review Checklist

> Language-agnostic guidelines for effective code review.

---

## Review Philosophy

```
Code review is about:
  ✓ Finding bugs before production
  ✓ Sharing knowledge across team
  ✓ Maintaining code quality
  ✓ Teaching and learning

Code review is NOT about:
  ✗ Proving you're smarter
  ✗ Style wars
  ✗ Blocking for trivial issues
  ✗ Ego battles
```

---

## Before You Start

### For the Author

| Action | Why |
|--------|-----|
| Self-review first | Catch obvious issues |
| Run tests | Don't waste reviewer time |
| Keep PRs small (<400 lines) | Easier to review thoroughly |
| Write clear description | Explain the "why" |
| Link to ticket/issue | Provide context |

### For the Reviewer

| Action | Why |
|--------|-----|
| Understand the context | Read ticket first |
| Allocate uninterrupted time | Don't rush |
| Check out the branch | Run it locally if needed |
| Review in one sitting | Avoid fragmented feedback |

---

## The Review Checklist

### 1. Correctness

```
[ ] Does the code do what it claims?
[ ] Are edge cases handled?
[ ] Are error paths correct?
[ ] Does it match requirements?
[ ] Are there off-by-one errors?
```

### 2. Security

```
[ ] Input validation present?
[ ] SQL injection protected?
[ ] XSS protected?
[ ] Authentication/authorization correct?
[ ] Secrets not hardcoded?
[ ] Sensitive data not logged?
```

### 3. Performance

```
[ ] Obvious performance issues?
[ ] N+1 queries?
[ ] Unnecessary loops?
[ ] Resource leaks (memory, connections)?
[ ] Appropriate data structures?
```

### 4. Maintainability

```
[ ] Code is readable?
[ ] Functions are focused (single purpose)?
[ ] Names are clear and consistent?
[ ] No magic numbers?
[ ] Complex logic is commented?
```

### 5. Testing

```
[ ] Tests included for changes?
[ ] Edge cases tested?
[ ] Error cases tested?
[ ] Tests are readable?
[ ] All tests pass?
```

### 6. Design

```
[ ] Follows existing patterns?
[ ] Appropriate abstraction level?
[ ] Dependencies reasonable?
[ ] Changes isolated properly?
[ ] Not over-engineered?
```

---

## Giving Feedback

### Tone Guidelines

| Instead of | Say |
|------------|-----|
| "This is wrong" | "I think this might cause X because..." |
| "You should..." | "Consider..." or "What about..." |
| "Why did you..." | "Can you help me understand..." |
| "Obviously..." | (just don't) |

### Feedback Categories

```
[blocking]  : Must fix before merge
[suggestion]: Good to fix, not required
[question]  : Need clarification
[nit]       : Minor style, optional
[praise]    : What's done well
```

### Examples

```
[blocking] This null check is missing and will crash
in production when user.email is undefined.

[suggestion] Consider extracting this into a helper
function for reuse in the other handler.

[question] Why is this timeout set to 30s? The API
typically responds in <1s.

[nit] Prefer `const` over `let` here since it's
never reassigned.

[praise] Great error handling here - the custom
error types make debugging much easier!
```

---

## Receiving Feedback

### Mindset

```
- Code is not you
- Feedback improves the code
- Reviewers are on your side
- Every comment is worth considering
- It's okay to disagree (respectfully)
```

### Responding

| Feedback | Response |
|----------|----------|
| Valid | "Good catch, fixed in [commit]" |
| Question | Answer clearly, add comment if needed |
| Disagree | "Here's my reasoning: [X]. What do you think?" |
| Unclear | "Can you clarify what you mean by [Y]?" |

---

## Common Issues to Watch For

### Security Red Flags

| Pattern | Risk |
|---------|------|
| String concatenation in queries | SQL Injection |
| User input in HTML | XSS |
| Hardcoded credentials | Credential leak |
| Weak crypto | Data breach |
| Missing auth checks | Unauthorized access |

### Performance Red Flags

| Pattern | Risk |
|---------|------|
| Loop inside loop with data call | N+1 problem |
| Loading entire table | Memory exhaustion |
| No pagination | Performance degradation |
| Synchronous I/O in hot path | Blocking |

### Maintainability Red Flags

| Pattern | Risk |
|---------|------|
| 500+ line files | Hard to understand |
| Deep nesting (>3 levels) | Complex logic |
| No tests | Fear of changes |
| Copy-pasted code | Inconsistent fixes |

---

## Review Efficiency

### Time Guidelines

| PR Size | Suggested Time |
|---------|----------------|
| < 100 lines | 15-30 min |
| 100-300 lines | 30-60 min |
| 300-500 lines | 60-90 min |
| > 500 lines | Request split |

### Prioritization

```
1. Security issues       (review first)
2. Correctness issues    (review second)
3. Performance issues    (review third)
4. Design concerns       (discuss)
5. Style/nits            (mention briefly)
```

---

## Approval Guidelines

### Approve When

- Code is correct
- No security issues
- Tests pass
- Meets requirements
- Minor issues can be addressed in follow-up

### Request Changes When

- Security vulnerabilities exist
- Logic is incorrect
- Tests are missing or failing
- Major design issues

### Hold Off When

- More context needed
- Needs discussion with team
- Blocked on external dependency

---

## Quick Reference Card

```
MUST CHECK:
  ✓ Correctness
  ✓ Security
  ✓ Tests pass
  ✓ Error handling

SHOULD CHECK:
  ○ Performance
  ○ Maintainability
  ○ Design patterns

FEEDBACK:
  [blocking]   - Must fix
  [suggestion] - Consider
  [nit]        - Optional
  [praise]     - What's good
```

---

*Knowledge Forge: Universal Layer*
*Applicable to: All reviewers, all languages*
