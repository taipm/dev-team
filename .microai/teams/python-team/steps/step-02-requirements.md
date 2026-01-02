# Step 02: Requirements Gathering

## Trigger
Sau Step 01 hoàn thành

## Agent
🎯 PM Agent

## Actions

### 1. Clarify Requirements

PM Agent hỏi:
1. Target users là ai?
2. Core features cần có?
3. Non-functional requirements (performance, security)?
4. Integration với external systems?
5. Data models chính?

### 2. Create User Stories

Format:
```markdown
## User Stories

### US-001: {Feature Name}

**As a** {user role}
**I want** {feature description}
**So that** {business value}

**Acceptance Criteria:**
- [ ] AC1: Given {context}, when {action}, then {result}
- [ ] AC2: ...

**Priority:** High/Medium/Low
**Estimate:** {story points}
```

### 3. Define API Contracts (if API project)

```yaml
# OpenAPI format
/api/v1/users:
  post:
    summary: Create new user
    requestBody:
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/UserCreate'
    responses:
      '201':
        description: User created
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/User'
```

### 4. Identify Data Models

```
Models:
- User (id, email, name, created_at)
- Post (id, title, content, author_id, created_at)
- Comment (id, content, post_id, user_id, created_at)
```

### 5. Document Scope

```markdown
## Scope

### In Scope
- Feature A
- Feature B

### Out of Scope
- Feature X (future phase)
- Feature Y (not needed)

### Constraints
- Must use PostgreSQL
- Must support 1000 concurrent users
```

## Output

```
┌─────────────────────────────────────────────────────────────┐
│ 🎯 PM Agent: Requirements Complete                          │
├─────────────────────────────────────────────────────────────┤
│ User Stories: {count}                                        │
│ API Endpoints: {count}                                       │
│ Data Models: {count}                                         │
│                                                              │
│ Saved to: docs/python-team/{date}-{topic}-requirements.md   │
└─────────────────────────────────────────────────────────────┘
```

## BREAKPOINT
Observer reviews requirements trước khi tiếp tục.

Options:
- `[Enter]` - Approve và continue
- `@pm: <feedback>` - Request changes
- `*exit` - Save và exit

## Next Step
→ Step 03: Architecture Design
