# User Story Patterns

Knowledge cho PM Agent về cách viết User Stories hiệu quả.

## User Story Format

```
As a [role]
I want [feature]
So that [benefit]
```

## Acceptance Criteria (Given-When-Then)

```gherkin
Given [precondition]
When [action]
Then [expected result]
```

## INVEST Criteria

Mỗi user story phải đảm bảo:

| Criteria | Description |
|----------|-------------|
| **I**ndependent | Không phụ thuộc story khác |
| **N**egotiable | Có thể thương lượng scope |
| **V**aluable | Mang lại giá trị cho user |
| **E**stimable | Có thể estimate effort |
| **S**mall | Đủ nhỏ để complete trong sprint |
| **T**estable | Có thể viết test cases |

## Story Point Estimation

| Points | Complexity | Example |
|--------|------------|---------|
| 1 | Trivial | Thay đổi text, config |
| 2 | Simple | CRUD đơn giản |
| 3 | Medium | Feature với logic |
| 5 | Complex | Tích hợp external service |
| 8 | Very Complex | Redesign module |
| 13 | Epic | Cần break down |

## MoSCoW Prioritization

- **Must have**: Bắt buộc cho MVP
- **Should have**: Quan trọng nhưng không critical
- **Could have**: Nice to have
- **Won't have**: Không làm trong phase này

## API Contract Template

```yaml
endpoint: /api/v1/{resource}
method: POST
auth: Bearer token required

request:
  headers:
    Content-Type: application/json
  body:
    field1:
      type: string
      required: true
      validation: max 100 chars
    field2:
      type: integer
      required: false
      default: 0

response:
  success:
    status: 201
    body:
      id: integer
      created_at: datetime
  errors:
    - status: 400
      code: VALIDATION_ERROR
      message: "Invalid input"
    - status: 401
      code: UNAUTHORIZED
      message: "Token required"
    - status: 409
      code: CONFLICT
      message: "Resource already exists"
```

## User Story Examples

### Good Example
```
As a registered user
I want to reset my password via email
So that I can regain access if I forget my password

Acceptance Criteria:
- Given I am on the login page
- When I click "Forgot Password" and enter my email
- Then I receive a reset link within 5 minutes

- Given I have a valid reset link
- When I click it within 24 hours
- Then I can set a new password

- Given I have a valid reset link
- When I click it after 24 hours
- Then I see "Link expired" message
```

### Bad Example (Too vague)
```
As a user
I want password reset
So that it works
```

## Edge Cases Checklist

Luôn hỏi về:
- [ ] Empty input
- [ ] Maximum length
- [ ] Special characters
- [ ] Concurrent requests
- [ ] Network failures
- [ ] Timeout scenarios
- [ ] Permission denied
- [ ] Resource not found
