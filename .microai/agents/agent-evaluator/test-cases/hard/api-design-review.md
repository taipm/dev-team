---
id: H-3
name: REST API Design Review
category: Architecture
difficulty: 5
points: 7
keywords:
  - redundant
  - verb
  - RESTful
  - resource
  - inconsistent
  - HTTP method
  - URL
---

# REST API Design Review

## Prompt

<prompt>
Review this REST API design:

```
POST /users/create
GET /users/getUser?id=123
PUT /users/updateUser
DELETE /users/deleteUser?id=123
GET /users/getAllUsers
```

List the design problems and suggest improvements.
</prompt>

## Expected Behavior

The answer should identify:
1. Redundant verbs in URLs (create, getUser, updateUser, deleteUser)
2. Inconsistent patterns (query param vs path param)
3. Non-RESTful resource naming
4. Missing resource identifiers in URLs

## Rubric

| Score | Criteria |
|-------|----------|
| 7 pts | Comprehensive review with complete RESTful redesign |
| 6 pts | Identifies 3+ issues with improvements |
| 5 pts | Identifies major issues with some improvements |
| 4 pts | Identifies 2-3 issues |
| 3 pts | Identifies 1-2 issues |
| 2 pts | Vague criticism without specifics |
| 0 pts | Says design is fine |

## Good Answer Example

```
Problems:

1. REDUNDANT VERBS IN URLs
   HTTP methods already convey the action. "create", "getUser",
   "updateUser", "deleteUser" are redundant.
   - POST already means create
   - GET already means read
   - PUT already means update
   - DELETE already means delete

2. INCONSISTENT ID PLACEMENT
   - GET /users/getUser?id=123 (query param)
   - DELETE /users/deleteUser?id=123 (query param)
   Should use path parameters: /users/123

3. NON-RESTFUL NAMING
   - "getUser", "getAllUsers" are RPC-style, not RESTful
   - REST uses resources (nouns), not actions (verbs)

4. MISSING RESOURCE IN PUT
   - PUT /users/updateUser has no user ID
   - How do we know which user to update?

5. PLURAL INCONSISTENCY
   - "/users" is plural (good)
   - But "getUser" is singular (inconsistent)

CORRECTED RESTFUL DESIGN:

POST   /users           → Create new user (body contains user data)
GET    /users           → List all users
GET    /users/:id       → Get specific user
PUT    /users/:id       → Update user (full replacement)
PATCH  /users/:id       → Partial update
DELETE /users/:id       → Delete user

Additional improvements:
- GET /users?name=john    → Search/filter
- GET /users?page=2&limit=20 → Pagination
```

## Why This Test

- Tests REST API design knowledge
- Requires understanding of HTTP semantics
- Common issue in real APIs
- Solution shows architectural best practices
