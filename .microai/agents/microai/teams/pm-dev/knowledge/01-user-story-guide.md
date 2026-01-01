# User Story Guide

## Overview
Hướng dẫn viết User Stories hiệu quả cho PM-Dev collaboration.

---

## 1. User Story Format

### Basic Format
```
As a [type of user],
I want [some goal],
So that [some reason/benefit].
```

### Good Examples

```markdown
As a returning customer,
I want to see my recently viewed products,
So that I can quickly find items I was considering.
```

```markdown
As an admin user,
I want to export user activity reports to CSV,
So that I can analyze usage patterns in Excel.
```

### Bad Examples

```markdown
❌ As a user,
   I want a better interface,
   So that I can use the app.

   → Too vague. What "better" means? Which interface?
```

```markdown
❌ Implement caching for the API.

   → Technical task, not user story. No user perspective.
```

---

## 2. INVEST Criteria

Good user stories are:

| Criterion | Description | Check |
|-----------|-------------|-------|
| **I**ndependent | Can be developed separately | "Does it need other stories first?" |
| **N**egotiable | Not a contract, details can change | "Is scope flexible?" |
| **V**aluable | Delivers value to user/business | "Why do users care?" |
| **E**stimable | Can estimate effort | "Is it clear enough to estimate?" |
| **S**mall | Fits in a sprint | "Can we finish in < 1 week?" |
| **T**estable | Can verify completion | "How do we know it's done?" |

---

## 3. Acceptance Criteria

### Given-When-Then Format
```markdown
**Given** [precondition/context]
**When** [action taken]
**Then** [expected result]
```

### Example
```markdown
## US-101: User Login

**As a** registered user,
**I want** to log in with my email and password,
**So that** I can access my account.

### Acceptance Criteria

**AC1: Successful Login**
Given I am on the login page
When I enter valid email and password
Then I am redirected to my dashboard
And I see a welcome message with my name

**AC2: Invalid Credentials**
Given I am on the login page
When I enter invalid email or password
Then I see an error message "Invalid credentials"
And I remain on the login page
And the password field is cleared

**AC3: Account Lockout**
Given I have failed login 5 times
When I attempt another login
Then I see "Account locked. Try again in 15 minutes"
And I cannot attempt login
```

---

## 4. Story Breakdown

### Epic → Feature → Story → Task

```
📦 Epic: User Authentication
   │
   ├── 🎯 Feature: Login
   │      ├── 📝 Story: Login with email/password
   │      │      ├── Task: Create login form UI
   │      │      ├── Task: Implement auth API
   │      │      └── Task: Add error handling
   │      ├── 📝 Story: Remember me option
   │      └── 📝 Story: Forgot password
   │
   └── 🎯 Feature: Registration
          ├── 📝 Story: Register with email
          └── 📝 Story: Email verification
```

### Splitting Large Stories

**Horizontal Split (by layer):**
- UI only
- API only
- Database only

**Vertical Split (by workflow):**
- Happy path only
- Error handling
- Edge cases

**By Operations:**
- Create
- Read
- Update
- Delete

**By Data:**
- Single item
- Bulk operations
- Search/filter

---

## 5. Priority Framework

### MoSCoW Method

| Priority | Description | Guideline |
|----------|-------------|-----------|
| **Must** | Critical for release | ~60% of effort |
| **Should** | Important but not critical | ~20% of effort |
| **Could** | Nice to have | ~20% of effort |
| **Won't** | Explicitly excluded | 0% |

### RICE Scoring

```
RICE Score = (Reach × Impact × Confidence) / Effort
```

| Factor | Description | Scale |
|--------|-------------|-------|
| Reach | Users affected per quarter | Number |
| Impact | Effect per user | 3=Massive, 2=High, 1=Med, 0.5=Low, 0.25=Minimal |
| Confidence | How sure are you? | 100%=High, 80%=Med, 50%=Low |
| Effort | Person-months | Number |

### Example RICE Calculation
```
Feature: Export to CSV

Reach: 500 users/quarter
Impact: 2 (High - saves significant time)
Confidence: 80% (some unknowns)
Effort: 1 person-month

RICE = (500 × 2 × 0.8) / 1 = 800
```

---

## 6. Definition of Done

### Story-Level DoD
- [ ] Acceptance criteria met
- [ ] Code reviewed
- [ ] Unit tests written
- [ ] Integration tests passing
- [ ] Documentation updated
- [ ] No critical bugs
- [ ] PM sign-off

### Feature-Level DoD
- [ ] All stories complete
- [ ] E2E tests passing
- [ ] Performance acceptable
- [ ] Security reviewed
- [ ] Deployed to staging
- [ ] QA sign-off

---

## 7. Story Mapping

### Structure
```
                    User Journey
    ──────────────────────────────────────────►
    ┌────────┐   ┌────────┐   ┌────────┐
    │Activity│   │Activity│   │Activity│
    │   1    │   │   2    │   │   3    │
    └────────┘   └────────┘   └────────┘
         │            │            │
    ┌────┴────┐  ┌────┴────┐  ┌────┴────┐
    │ Story A │  │ Story C │  │ Story E │  Release 1
    ├─────────┤  ├─────────┤  ├─────────┤  (MVP)
    │ Story B │  │ Story D │  │ Story F │  Release 2
    └─────────┘  └─────────┘  └─────────┘
```

### Example: E-commerce Checkout
```
Browse → Add to Cart → Checkout → Payment → Confirmation

MVP:
├── View products
├── Add single item
├── Simple checkout
├── Credit card only
└── Email confirmation

Release 2:
├── Product search
├── Cart management
├── Guest checkout
├── Multiple payments
└── Order tracking
```

---

## 8. Templates

### User Story Template
```markdown
## US-{number}: {Title}

**As a** {user type},
**I want** {goal},
**So that** {benefit}.

### Acceptance Criteria

**AC1: {Scenario Name}**
Given {context}
When {action}
Then {expected result}

### Priority
{Must/Should/Could/Won't}

### Notes
- {Additional context}
- {Edge cases}
- {Out of scope}

### Dependencies
- {Dependency 1}

### Design
{Link to mockups if available}
```

### Technical Story Template
```markdown
## TS-{number}: {Title}

**Objective:** {What technical goal}

**Context:** {Why needed, what depends on this}

**Scope:**
- {In scope item 1}
- {In scope item 2}
- Out of scope: {exclusions}

**Acceptance Criteria:**
- [ ] {Technical criterion 1}
- [ ] {Technical criterion 2}

**Dependencies:**
- {Dependency 1}

**Risks:**
- {Risk 1}: {Mitigation}
```

---

## 9. Common Anti-Patterns

### Avoid These

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Technical tasks as stories | No user value visible | Frame as user benefit |
| Giant stories | Can't estimate | Split into smaller stories |
| Vague criteria | Can't verify done | Write specific AC |
| No "so that" | Missing value | Always include benefit |
| Implementation details | Premature | Focus on what, not how |

---

## References

- [User Story Mapping - Jeff Patton](https://www.jpattonassociates.com/user-story-mapping/)
- [INVEST in Good Stories - Bill Wake](https://xp123.com/articles/invest-in-good-stories-and-smart-tasks/)
- [Agile Estimating and Planning - Mike Cohn](https://www.mountaingoatsoftware.com/books/agile-estimating-and-planning)
