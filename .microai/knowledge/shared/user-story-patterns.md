# User Story Patterns

> Shared knowledge for PM-Dev and Dev-QA teams

## Overview

Best practices for writing, refining, and validating user stories.

---

## 1. User Story Format

### Standard Template
```
As a [type of user],
I want [goal/desire],
So that [benefit/value].
```

### Examples
```
As a new customer,
I want to create an account with my email,
So that I can save my preferences and order history.
```

---

## 2. INVEST Criteria

Quality checklist for user stories:

| Criterion | Description | Check |
|-----------|-------------|-------|
| **I**ndependent | Can be developed separately | No hidden dependencies? |
| **N**egotiable | Details can be discussed | Not over-specified? |
| **V**aluable | Delivers user/business value | Why does this matter? |
| **E**stimable | Team can estimate effort | Enough detail to size? |
| **S**mall | Fits in one sprint | Can complete in 1-3 days? |
| **T**estable | Clear acceptance criteria | How do we verify? |

---

## 3. Acceptance Criteria

### Given-When-Then Format
```
Given [precondition/context],
When [action/trigger],
Then [expected outcome].
```

### Example
```
Given I am on the login page,
When I enter valid credentials and click Login,
Then I should be redirected to my dashboard.
```

### Multiple Criteria
- Use bullet points
- Cover happy path AND edge cases
- Include validation rules
- Specify error messages

---

## 4. Story Splitting Patterns

### By Workflow Steps
Original: "User can checkout"
Split into:
1. User can view cart summary
2. User can enter shipping address
3. User can select payment method
4. User can confirm order

### By Data Variations
Original: "User can export report"
Split into:
1. Export as PDF
2. Export as CSV
3. Export as Excel

### By User Roles
Original: "User can manage products"
Split into:
1. Admin can create products
2. Admin can edit products
3. Manager can view products

### By Operations (CRUD)
- Create
- Read (List/Detail)
- Update
- Delete

---

## 5. Story Mapping

```
┌─────────────────────────────────────────────────┐
│  USER JOURNEY (Activities)                       │
│  Browse → Search → Select → Purchase → Receive   │
├─────────────────────────────────────────────────┤
│  MVP (Walking Skeleton)                          │
│  [List items] [Basic search] [Add to cart] [Pay] │
├─────────────────────────────────────────────────┤
│  Release 2                                       │
│  [Categories] [Filters] [Save cart] [Track]     │
├─────────────────────────────────────────────────┤
│  Release 3                                       │
│  [Recommendations] [Advanced] [Wishlist] [Review]│
└─────────────────────────────────────────────────┘
```

---

## 6. Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Technical task | No user value visible | Reframe from user perspective |
| Too large | Can't complete in sprint | Split using patterns above |
| Too small | Overhead > value | Combine related items |
| Solution-focused | "Add a button" | Focus on goal, not implementation |
| Missing "so that" | No clear value | Ask "why does user need this?" |

---

## 7. Definition of Ready

Story is ready for sprint when:
- [ ] User story follows standard format
- [ ] Meets INVEST criteria
- [ ] Has acceptance criteria
- [ ] Dependencies identified
- [ ] Estimated by team
- [ ] UX mockups attached (if UI)
- [ ] Technical approach discussed

---

## 8. Definition of Done

Story is done when:
- [ ] Code complete and reviewed
- [ ] Unit tests written
- [ ] Acceptance criteria verified
- [ ] Documentation updated
- [ ] Deployed to staging
- [ ] PO/QA approved

---

## Quick Reference Card

```
FORMAT:     As a [who], I want [what], So that [why]
CRITERIA:   Given [context], When [action], Then [result]
INVEST:     Independent, Negotiable, Valuable, Estimable, Small, Testable
SPLIT BY:   Workflow | Data | Roles | CRUD
```

---

*Last updated: 2024-12-31*
*Applicable teams: pm-dev, dev-qa*
