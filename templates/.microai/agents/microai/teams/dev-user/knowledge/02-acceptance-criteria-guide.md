# Acceptance Criteria Writing Guide

> Standards for writing clear, testable, unambiguous acceptance criteria.

---

## The Given-When-Then Format

### Structure
```
Given: [precondition/context]
When: [action/trigger]
Then: [expected outcome]
And: [additional outcome] (optional)
```

### Good Example
```
AC1: Successful Login

Given: User has a verified account
When: User enters valid email and password and clicks Login
Then: User is redirected to dashboard
And: Session is created with 24-hour expiry
```

### Bad Example (Avoid)
```
AC1: Login works properly
- User can login
- Dashboard shows
```

---

## Quality Checklist for Each AC

| Criterion | Check |
|-----------|-------|
| **Specific** | No vague words like "should", "might", "properly" |
| **Measurable** | Can be verified with a test |
| **Achievable** | Technically feasible |
| **Relevant** | Ties to user story value |
| **Testable** | Clear pass/fail criteria |

### Words to Avoid

| Avoid | Replace With |
|-------|--------------|
| "fast" | "< 2 seconds" |
| "user-friendly" | specific UX behavior |
| "properly" | exact expected behavior |
| "should" | "will" or "must" |
| "easy" | specific interaction steps |
| "secure" | specific security measure |

---

## Common AC Patterns

### Authentication ACs

```
AC: Successful Registration
Given: User is on registration page
When: User enters valid email, password (8+ chars with number), and submits
Then: Account is created
And: Verification email is sent
And: User sees "Check your email" message

AC: Failed Registration - Duplicate Email
Given: Email "test@example.com" already registered
When: New user tries to register with same email
Then: Registration fails
And: Error message "Email already in use" is shown
And: No duplicate account is created

AC: Password Reset Request
Given: User has verified account
When: User requests password reset with registered email
Then: Reset link is sent to email
And: Link expires after 1 hour
And: Success message shown (regardless of email existence - security)
```

### CRUD Operations ACs

```
AC: Create Item - Success
Given: User is authenticated
And: User has "create" permission
When: User submits valid item data
Then: Item is created in database
And: Success message shown
And: User is redirected to item detail page

AC: Create Item - Validation Error
Given: User submits item with missing required field "name"
When: Form is submitted
Then: Item is NOT created
And: Validation error shown next to "name" field
And: Other field values are preserved

AC: Delete Item - With Confirmation
Given: User views item they own
When: User clicks "Delete"
Then: Confirmation dialog appears
When: User confirms deletion
Then: Item is soft-deleted (not hard deleted)
And: User is redirected to list
And: Success message shown
```

### Search/Filter ACs

```
AC: Search with Results
Given: Database has items matching "keyword"
When: User searches for "keyword"
Then: Matching items are displayed
And: Search term is highlighted in results
And: Result count is shown

AC: Search with No Results
Given: No items match "nonexistent"
When: User searches for "nonexistent"
Then: Empty state message is shown
And: Suggestion to try different keywords
And: No error is thrown

AC: Filter Combination
Given: Items exist with various statuses and dates
When: User filters by status="active" AND date="last 7 days"
Then: Only items matching BOTH criteria are shown
And: Active filters are visible
And: "Clear all" option is available
```

---

## Edge Cases to Always Consider

### Input Edge Cases
- Empty input
- Maximum length input
- Special characters
- Unicode/emoji
- SQL injection attempts
- XSS attempts

### State Edge Cases
- First time user (no data)
- User with lots of data
- Concurrent modifications
- Stale data
- Network failure mid-operation

### Permission Edge Cases
- Unauthenticated user
- Authenticated but unauthorized
- Admin vs regular user
- Owner vs viewer

---

## AC Quantity Guidelines

| Story Size | Typical AC Count | Focus |
|------------|------------------|-------|
| Simple (1 day) | 2-3 | Happy path + 1 error |
| Medium (2-3 days) | 4-6 | Happy + errors + edges |
| Large (1 week) | 7-10 | Consider splitting story |
| Epic | - | Split into smaller stories |

---

## Templates for Common Features

### API Endpoint Template
```
AC: [Method] /endpoint - Success
Given: Valid request with required fields
And: User is authenticated
When: Request is sent
Then: Response status is 200/201
And: Response body contains expected data
And: Response time < 500ms

AC: [Method] /endpoint - Validation Error
Given: Request missing required field "X"
When: Request is sent
Then: Response status is 400
And: Error message indicates missing field

AC: [Method] /endpoint - Unauthorized
Given: Request without auth token
When: Request is sent
Then: Response status is 401
And: No data is returned
```

### Form Submission Template
```
AC: Form Submit - Success
Given: All required fields filled correctly
When: User clicks Submit
Then: Data is saved
And: Success message shown
And: Form is cleared/redirected

AC: Form Submit - Validation
Given: Required field is empty
When: User clicks Submit
Then: Form is NOT submitted
And: Error shown on invalid field
And: Valid fields retain values
```

---

## Sign-Off Checklist

Before finalizing ACs, verify:

- [ ] Each AC has Given/When/Then
- [ ] No ambiguous language
- [ ] Happy path covered
- [ ] Key error cases covered
- [ ] Edge cases for important flows
- [ ] ACs are independent (can test separately)
- [ ] Total ACs reasonable for story size
- [ ] EndUser understands and agrees

---

*Reference for Solo Dev agent during synthesis phase*
