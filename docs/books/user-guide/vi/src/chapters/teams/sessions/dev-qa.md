# dev-qa-session

Dialogue giữa Developer và QA Engineer để review và test.

## Kích Hoạt

```
/microai:dev-qa-session
```

## Mục Đích

- Tạo Test Plan comprehensive
- Review code cho bugs
- Viết Bug Reports chi tiết
- Discuss testing strategies

## Roles

### 👨‍💻 Developer
- Giải thích implementation
- Discuss edge cases
- Fix reported issues
- Clarify intended behavior

### 🧪 QA Engineer
- Question assumptions
- Find edge cases
- Write test cases
- Report bugs professionally

## Output Formats

### 1. Test Plan

```markdown
# Test Plan: [Feature Name]

## Scope
- In scope: ...
- Out of scope: ...

## Test Strategy
- Unit tests: [approach]
- Integration tests: [approach]
- E2E tests: [approach]

## Test Cases

### TC-001: [Name]
- **Priority**: High/Medium/Low
- **Preconditions**: ...
- **Steps**:
  1. ...
  2. ...
- **Expected**: ...

### TC-002: [Name]
...
```

### 2. Bug Report

```markdown
# Bug Report

**ID**: BUG-001
**Title**: [Clear, specific title]
**Severity**: Critical/High/Medium/Low
**Priority**: P1/P2/P3

## Environment
- OS: ...
- Version: ...

## Steps to Reproduce
1. ...
2. ...
3. ...

## Expected Behavior
...

## Actual Behavior
...

## Evidence
[Screenshots, logs]

## Impact
...
```

## Ví Dụ Session

```
You: /microai:dev-qa-session

Developer: 👨‍💻 Tôi vừa implement password reset flow.
Cần review và tạo test plan.

QA: 🧪 OK! Để tôi hỏi về flow:
1. User request reset như thế nào?
2. Token expire sau bao lâu?
3. Có rate limit không?

Developer: 👨‍💻
1. Submit email → receive link với token
2. Token expire sau 1 hour
3. 3 requests per hour per email

QA: 🧪 Tốt. Một số edge cases tôi thấy:
- What if email doesn't exist?
- What if token used twice?
- What if user requests new token while old still valid?

Developer: 👨‍💻
- Email không tồn tại: vẫn return success (security)
- Token đã dùng: error message
- Request mới: invalidate token cũ

QA: 🧪 Perfect! Đây là Test Plan:

# Test Plan: Password Reset

## Test Cases

### TC-001: Happy Path Reset
- **Priority**: High
- **Steps**:
  1. Go to forgot password
  2. Enter valid email
  3. Click submit
  4. Open email, click link
  5. Enter new password
- **Expected**: Password changed successfully

### TC-002: Invalid Email
- **Priority**: Medium
- **Steps**:
  1. Enter non-existent email
  2. Click submit
- **Expected**: Same success message (no info leak)

### TC-003: Token Reuse
- **Priority**: High
- **Steps**:
  1. Complete password reset
  2. Click same link again
- **Expected**: Error "Token already used"

### TC-004: Rate Limiting
- **Priority**: Medium
- **Steps**:
  1. Request reset 4 times for same email
- **Expected**: 4th request blocked

### TC-005: Token Expiry
- **Priority**: High
- **Steps**:
  1. Request reset
  2. Wait 61 minutes
  3. Click link
- **Expected**: Error "Token expired"

Developer: 👨‍💻 Comprehensive! Tôi sẽ implement tests theo plan này.
```

## Xem Thêm

- [Session Teams Overview](../session-teams.md)
- [Code Review Workflow](../../workflows/code-review.md)
