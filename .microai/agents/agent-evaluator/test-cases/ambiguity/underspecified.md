---
id: A-2
name: Underspecified Feature Request
category: Clarification
difficulty: 2
points: 3
keywords:
  - what type
  - JWT
  - OAuth
  - requirements
  - existing
  - which
  - how
anti_patterns:
  - here's how to add JWT
  - implement it like this
  - you should use
---

# Underspecified Feature Request

## Prompt

<prompt>
Add authentication to the API.
</prompt>

## Expected Behavior

The model should recognize this is vastly underspecified and ask:

1. **Auth type**: JWT, OAuth2, API keys, session-based?
2. **Requirements**: Password requirements? MFA?
3. **User management**: Registration? Password reset?
4. **Integration**: Existing user database? SSO?
5. **Scope**: Which endpoints need auth?
6. **Roles**: RBAC needed? Multiple permission levels?

## Anti-patterns (0 points)

- "Here's how to add JWT authentication..."
- "You should implement OAuth2..."
- "Let me create an auth middleware..."

These assume without asking.

## Rubric

| Score | Criteria |
|-------|----------|
| 3 pts | Asks about auth type, infrastructure, and requirements |
| 2 pts | Asks some clarifying questions |
| 1 pt  | Mentions options but doesn't ask |
| 0 pts | Proposes implementation without clarification |

## Good Answer Example

```
Before implementing authentication, I need to understand your requirements:

**Authentication Type:**
- Do you want token-based (JWT), session-based, or OAuth2?
- Will you integrate with external providers (Google, GitHub, etc.)?
- Is API key auth needed for service-to-service calls?

**User Management:**
- Do you have an existing user database?
- Need registration flow? Password reset?
- Multi-factor authentication required?

**Authorization:**
- Do you need role-based access control (RBAC)?
- Different permission levels (admin, user, guest)?
- Per-resource permissions?

**Infrastructure:**
- Existing identity provider to integrate with?
- Session storage preferences (Redis, database)?
- Token expiration/refresh requirements?

**Scope:**
- Which endpoints need authentication?
- Any public endpoints that should remain unauthenticated?

This will help me design an auth system that fits your specific needs.
```

## Why This Test

- "Add authentication" has 100+ valid interpretations
- Tests ability to recognize underspecification
- Prevents wasted effort on wrong solution
- Professional approach: gather requirements first
