# Examples Gallery

> Bộ sưu tập các skills mẫu với annotations chi tiết.

---

## 1. Commit Helper Skill

> Giúp viết commit messages theo chuẩn.

### Cấu trúc

```
.claude/skills/commit-helper/
├── SKILL.md
└── examples.md
```

### SKILL.md

```yaml
---
name: commit-helper
description: "Write commit messages following Conventional Commits specification"
---

# Commit Helper

## Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

## Types

| Type | Mô tả | Ví dụ |
|------|-------|-------|
| `feat` | Feature mới | `feat(auth): add OAuth2` |
| `fix` | Sửa bug | `fix(api): handle null` |
| `docs` | Documentation | `docs: update README` |
| `style` | Formatting | `style: fix indentation` |
| `refactor` | Refactor | `refactor: extract helper` |
| `test` | Tests | `test: add unit tests` |
| `chore` | Maintenance | `chore: update deps` |

## Rules

1. **Subject** ≤ 50 ký tự
2. **No period** ở cuối subject
3. **Imperative mood** - "add" không phải "added"
4. **Body** wrap ở 72 ký tự
5. Body giải thích **WHY**, không phải WHAT

## Examples

### Good

```
feat(auth): add JWT token refresh

Implement automatic token refresh when access token expires.
Users will no longer be logged out unexpectedly.

Closes #123
```

### Bad

```
fix bug
```

```
updated stuff
```
```

### Điểm nổi bật

- ✅ Clear type table
- ✅ Numbered rules
- ✅ Good/Bad examples
- ✅ Focused scope

---

## 2. API Designer Skill

> Thiết kế RESTful APIs theo best practices.

### Cấu trúc

```
.claude/skills/api-designer/
├── SKILL.md
├── conventions.md
└── examples/
    ├── rest-crud.md
    └── rest-pagination.md
```

### SKILL.md

```yaml
---
name: api-designer
description: "Design RESTful APIs following REST best practices and OpenAPI specification"
allowed-tools: Read, Write
---

# API Designer

## Purpose

Design consistent, well-documented RESTful APIs.

## URL Conventions

| Pattern | Method | Action |
|---------|--------|--------|
| `/resources` | GET | List all |
| `/resources` | POST | Create new |
| `/resources/{id}` | GET | Get one |
| `/resources/{id}` | PUT | Update |
| `/resources/{id}` | DELETE | Delete |

## Naming Rules

1. Use **plural nouns** for resources
2. Use **kebab-case** for multi-word
3. Use **query params** for filtering
4. Use **path params** for identity

```
✅ /users
✅ /user-profiles
✅ /users?status=active
✅ /users/123

❌ /getUsers
❌ /user_profiles
❌ /users/active
```

## Response Format

```json
{
  "data": { ... },
  "meta": {
    "page": 1,
    "total": 100
  },
  "errors": []
}
```

## Status Codes

| Code | When |
|------|------|
| 200 | Success |
| 201 | Created |
| 204 | No Content (delete) |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Server Error |

## References

- [Conventions](./conventions.md)
- [CRUD Example](./examples/rest-crud.md)
- [Pagination](./examples/rest-pagination.md)
```

### Điểm nổi bật

- ✅ URL patterns table
- ✅ Good/Bad URL examples
- ✅ Response format template
- ✅ Status codes reference
- ✅ Linked reference files

---

## 3. Database Schema Skill

> Thiết kế database schemas và migrations.

### Cấu trúc

```
.claude/skills/db-schema/
├── SKILL.md
├── normalization.md
├── indexing.md
└── naming.md
```

### SKILL.md

```yaml
---
name: db-schema
description: "Design database schemas, write migrations, and optimize queries"
allowed-tools: Read, Write
---

# Database Schema Designer

## Naming Conventions

| Entity | Convention | Example |
|--------|------------|---------|
| Tables | snake_case, plural | `users`, `order_items` |
| Columns | snake_case | `first_name`, `created_at` |
| Primary Key | `id` | `id` |
| Foreign Key | `{table}_id` | `user_id` |
| Indexes | `idx_{table}_{columns}` | `idx_users_email` |

## Common Patterns

### Timestamps

```sql
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

### Soft Delete

```sql
deleted_at TIMESTAMP NULL,
INDEX idx_deleted_at (deleted_at)
```

### Audit Fields

```sql
created_by INT REFERENCES users(id),
updated_by INT REFERENCES users(id)
```

## Normalization

| Form | Rule |
|------|------|
| 1NF | No repeating groups |
| 2NF | No partial dependencies |
| 3NF | No transitive dependencies |

## Index Strategy

```
✅ Index foreign keys
✅ Index frequently queried columns
✅ Composite index for multi-column queries
❌ Don't over-index (write penalty)
```

## References

- [Normalization Guide](./normalization.md)
- [Indexing Strategy](./indexing.md)
- [Naming Guide](./naming.md)
```

### Điểm nổi bật

- ✅ Naming conventions table
- ✅ Copy-paste SQL snippets
- ✅ Normalization summary
- ✅ Index do/don't

---

## 4. Test Writer Skill

> Viết tests cho code.

### Cấu trúc

```
.claude/skills/test-writer/
├── SKILL.md
└── patterns/
    ├── unit-tests.md
    └── integration-tests.md
```

### SKILL.md

```yaml
---
name: test-writer
description: "Write unit tests, integration tests following testing best practices"
allowed-tools: Read, Write, Bash
---

# Test Writer

## Test Structure

### Arrange-Act-Assert (AAA)

```javascript
test('should calculate total correctly', () => {
  // Arrange
  const cart = new Cart();
  cart.add({ price: 100 });
  cart.add({ price: 200 });

  // Act
  const total = cart.getTotal();

  // Assert
  expect(total).toBe(300);
});
```

## Naming Convention

```
test_<action>_<scenario>_<expected>

# Examples
test_login_with_valid_credentials_returns_token
test_login_with_invalid_password_throws_error
test_getUser_when_not_found_returns_null
```

## Test Types

| Type | Scope | Speed |
|------|-------|-------|
| Unit | Single function | Fast |
| Integration | Multiple components | Medium |
| E2E | Full system | Slow |

## What to Test

```
✅ Business logic
✅ Edge cases
✅ Error handling
✅ Input validation

❌ Framework code
❌ Simple getters/setters
❌ External libraries
```

## Mocking

```javascript
// Mock external dependency
jest.mock('./api', () => ({
  fetchUser: jest.fn().mockResolvedValue({ id: 1, name: 'Test' })
}));
```

## Coverage Goals

| Type | Target |
|------|--------|
| Statements | > 80% |
| Branches | > 70% |
| Functions | > 80% |
| Lines | > 80% |

## References

- [Unit Test Patterns](./patterns/unit-tests.md)
- [Integration Test Patterns](./patterns/integration-tests.md)
```

### Điểm nổi bật

- ✅ AAA pattern template
- ✅ Naming convention with examples
- ✅ What to test / not test
- ✅ Coverage targets

---

## 5. Documentation Skill

> Viết technical documentation.

### Cấu trúc

```
.claude/skills/doc-writer/
├── SKILL.md
└── templates/
    ├── readme-template.md
    └── api-doc-template.md
```

### SKILL.md

```yaml
---
name: doc-writer
description: "Write technical documentation, READMEs, and API docs"
allowed-tools: Read, Write
---

# Documentation Writer

## README Structure

```markdown
# Project Name

Brief description.

## Installation

```bash
npm install project-name
```

## Quick Start

```javascript
import { thing } from 'project-name';
thing.doSomething();
```

## Documentation

- [API Reference](./docs/api.md)
- [Examples](./examples/)

## License

MIT
```

## API Documentation

### Function Doc

```javascript
/**
 * Calculate the total price of items.
 *
 * @param {Item[]} items - Array of items with price property
 * @param {number} discount - Discount percentage (0-100)
 * @returns {number} Total price after discount
 * @throws {Error} If discount is invalid
 *
 * @example
 * const total = calculateTotal([{price: 100}], 10);
 * // returns 90
 */
function calculateTotal(items, discount) { ... }
```

## Style Guide

| Element | Style |
|---------|-------|
| Headings | Title Case |
| Code | Fenced blocks |
| Lists | Use bullets |
| Tables | For comparisons |

## Tips

1. **Lead with examples** - Show, don't just tell
2. **Keep it updated** - Outdated docs are harmful
3. **Link related docs** - Cross-reference
4. **Include troubleshooting** - Common issues

## Templates

- [README Template](./templates/readme-template.md)
- [API Doc Template](./templates/api-doc-template.md)
```

### Điểm nổi bật

- ✅ README template
- ✅ JSDoc format
- ✅ Style guide
- ✅ Practical tips

---

## 6. Security Checker Skill

> Kiểm tra security issues trong code.

### Cấu trúc

```
.claude/skills/security-checker/
├── SKILL.md
└── vulnerabilities.md
```

### SKILL.md

```yaml
---
name: security-checker
description: "Check code for security vulnerabilities, OWASP top 10"
allowed-tools: Read
---

# Security Checker

## OWASP Top 10

| # | Vulnerability | Check |
|---|---------------|-------|
| 1 | Injection | Parameterized queries |
| 2 | Broken Auth | Strong sessions |
| 3 | Sensitive Data | Encryption |
| 4 | XXE | Disable DTD |
| 5 | Broken Access | RBAC |
| 6 | Misconfiguration | Defaults |
| 7 | XSS | Output encoding |
| 8 | Deserialization | Validate input |
| 9 | Components | Update deps |
| 10 | Logging | Audit trail |

## Code Patterns

### SQL Injection

```javascript
// ❌ Vulnerable
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ Safe
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

### XSS

```javascript
// ❌ Vulnerable
element.innerHTML = userInput;

// ✅ Safe
element.textContent = userInput;
```

### Secrets

```
❌ Hardcoded secrets
❌ Secrets in git
❌ Secrets in logs

✅ Environment variables
✅ Secret managers
✅ .gitignore sensitive files
```

## Checklist

```
□ No hardcoded secrets
□ Input validation
□ Output encoding
□ Parameterized queries
□ HTTPS only
□ Secure headers
□ Updated dependencies
□ Error messages sanitized
```

## References

- [Vulnerabilities Detail](./vulnerabilities.md)
- [OWASP](https://owasp.org/Top10/)
```

### Điểm nổi bật

- ✅ OWASP reference table
- ✅ Vulnerable/Safe code examples
- ✅ Security checklist
- ✅ External references

---

## Tóm tắt các Patterns

| Skill | Key Features |
|-------|--------------|
| commit-helper | Type table, rules, examples |
| api-designer | URL patterns, status codes |
| db-schema | Naming conventions, SQL snippets |
| test-writer | AAA pattern, coverage goals |
| doc-writer | Templates, style guide |
| security-checker | OWASP checklist, code patterns |

---

## Tiếp theo

- [Trở về tổng quan](./README.md)
- [Tạo Skill mới](./04-creating-skills.md)
