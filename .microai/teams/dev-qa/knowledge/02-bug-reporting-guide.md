# Bug Reporting Guide - Knowledge Base

## Bug Report Structure

### Essential Fields

```markdown
## Bug Report: [ID]

**Summary:** [One-line description]
**Severity:** [Critical/High/Medium/Low]
**Priority:** [P1/P2/P3/P4]
**Status:** [New/Confirmed/In Progress/Fixed/Verified/Closed]

**Environment:**
- OS: [Windows 11 / macOS 14 / Ubuntu 22.04]
- Browser: [Chrome 120 / Firefox 121 / Safari 17]
- App Version: [v1.2.3]
- Device: [Desktop / Mobile / Tablet]

**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Result:**
[What should happen]

**Actual Result:**
[What actually happens]

**Attachments:**
- Screenshot/Video
- Logs
- Network requests
```

---

## Severity vs Priority Matrix

### Severity (Impact Level)

| Severity | Definition | Examples |
|----------|------------|----------|
| **Critical** | System unusable, data loss, security breach | App crashes, data corruption, auth bypass |
| **High** | Major feature broken, no workaround | Cannot login, payment fails, data not saved |
| **Medium** | Feature impaired, workaround exists | Slow performance, UI glitch, wrong calculation |
| **Low** | Minor issue, cosmetic | Typo, alignment, color wrong |

### Priority (Fix Urgency)

| Priority | Definition | Timeline |
|----------|------------|----------|
| **P1** | Fix immediately | Block release, fix now |
| **P2** | Fix before release | This sprint |
| **P3** | Fix soon | Next sprint |
| **P4** | Fix eventually | Backlog |

### Severity-Priority Mapping

```
                Priority
              P1    P2    P3    P4
            ┌─────┬─────┬─────┬─────┐
   Critical │ ★★★ │ ★★★ │ ★★  │ ★   │
            ├─────┼─────┼─────┼─────┤
Severity    │ ★★★ │ ★★  │ ★★  │ ★   │
   High     ├─────┼─────┼─────┼─────┤
   Medium   │ ★★  │ ★★  │ ★   │ ★   │
            ├─────┼─────┼─────┼─────┤
   Low      │ ★   │ ★   │     │     │
            └─────┴─────┴─────┴─────┘

★★★ = Drop everything, fix now
★★  = High priority this sprint
★   = Schedule appropriately
    = Backlog / won't fix
```

---

## Writing Good Bug Titles

### Bad Examples
- "It doesn't work"
- "Bug in login"
- "Error occurred"

### Good Examples
- "Login fails with 500 error when email contains '+' character"
- "Payment button disabled after selecting PayPal option"
- "User profile image not displaying on Safari 17"

### Title Formula
```
[Component] - [Action] - [Result] - [Condition]

Examples:
- "Checkout - Add to cart - 500 error - when quantity > 99"
- "Profile - Upload avatar - Stuck loading - for PNG > 5MB"
- "Search - Filter by date - Wrong results - timezone UTC+7"
```

---

## Steps to Reproduce Best Practices

### Be Specific
```markdown
# Bad
1. Go to the page
2. Click button
3. Bug appears

# Good
1. Navigate to https://app.example.com/products
2. Click "Add to Cart" button for product ID #12345
3. Enter quantity: 100
4. Click "Checkout" button
5. Observe: Error message "Quantity exceeds maximum" but cart shows 100 items
```

### Include Prerequisites
```markdown
**Prerequisites:**
- User must be logged in
- User must have items in cart
- Browser: Chrome (not Firefox)

**Steps:**
1. ...
```

### Note Intermittent Issues
```markdown
**Reproducibility:** 3/5 attempts
**Suspected trigger:** Happens more often under slow network
```

---

## Attachments Best Practices

### Screenshots
- Highlight the issue area
- Include full context (URL bar, timestamps)
- Annotate if complex

### Videos
- Keep under 60 seconds
- Show before/after states
- Include audio if explaining

### Logs
- Include relevant timestamps
- Filter to relevant entries
- Mask sensitive data

### Network Requests
- Export HAR file
- Highlight failed requests
- Include request/response bodies

---

## Root Cause Analysis Template

### 5 Whys Method

```markdown
**Problem:** User cannot login

**Why 1:** Authentication API returns 500
**Why 2:** Database query timeout
**Why 3:** Missing index on users table
**Why 4:** Index was dropped during migration
**Why 5:** Migration script had bug, no rollback plan

**Root Cause:** Migration script error
**Fix:** Add index back, fix migration script, add rollback
```

### Fishbone Diagram Categories

```
People ───────┐
              │
Process ──────┼──────► PROBLEM
              │
Technology ───┤
              │
Environment ──┘
```

---

## Bug Lifecycle

```
┌─────────┐    ┌───────────┐    ┌────────────┐
│   NEW   │───►│ CONFIRMED │───►│ IN_PROGRESS│
└─────────┘    └───────────┘    └────────────┘
     │              │                  │
     ▼              ▼                  ▼
┌─────────┐    ┌───────────┐    ┌────────────┐
│DUPLICATE│    │ WON'T_FIX │    │   FIXED    │
└─────────┘    └───────────┘    └────────────┘
                                       │
                                       ▼
                               ┌────────────┐
                               │  VERIFIED  │
                               └────────────┘
                                       │
                                       ▼
                               ┌────────────┐
                               │   CLOSED   │
                               └────────────┘
```

### Status Definitions

| Status | Responsible | Actions |
|--------|-------------|---------|
| New | QA | Create report, assign |
| Confirmed | Dev | Reproduce, analyze |
| In Progress | Dev | Implement fix |
| Fixed | Dev | Code complete, ready for test |
| Verified | QA | Fix confirmed working |
| Closed | Auto | Release complete |
| Won't Fix | PM/Dev | Documented reason |
| Duplicate | QA | Link to original |

---

## Communication Templates

### Bug Report Comment - Need More Info
```
@reporter - Cần thêm thông tin để reproduce:
1. Exact URL where issue occurred?
2. Browser version và OS?
3. Có screenshot/video không?

Thanks!
```

### Bug Fixed Comment
```
Fixed in commit [abc123].

**Root cause:** [explanation]
**Fix:** [what changed]

@QA - Ready for verification. Test scenarios:
1. [scenario 1]
2. [scenario 2]
```

### Won't Fix Comment
```
Closing as Won't Fix.

**Reason:** [explanation]
**Alternatives:** [if any]

Đây là decision từ [PM/Tech Lead]. Reopen nếu có thêm context.
```

---

## Common Bug Categories

### Functional
- Feature không hoạt động đúng spec
- Business logic sai
- Missing functionality

### UI/UX
- Layout broken
- Responsive issues
- Accessibility problems

### Performance
- Slow response
- Memory leak
- High CPU usage

### Security
- Authentication bypass
- Data exposure
- Injection vulnerabilities

### Data
- Data loss
- Data corruption
- Sync issues

### Integration
- API contract mismatch
- Third-party service issues
- Version incompatibility
