# Estimation Techniques Guide

## Overview
Các kỹ thuật estimation cho PM-Dev collaboration.

---

## 1. Why Estimation is Hard

### Common Pitfalls
- Unknown unknowns
- Optimism bias
- Scope creep
- Missing dependencies
- Technical debt
- Integration complexity

### The Cone of Uncertainty
```
Early Project:        ±400%
After Requirements:   ±100%
After Design:         ±50%
After Implementation: ±10%
```

---

## 2. T-Shirt Sizing

### Quick Reference

| Size | Effort | Complexity | Risk | Use When |
|------|--------|------------|------|----------|
| XS | < 4 hours | Trivial | Very Low | Config change, typo fix |
| S | 0.5-1 day | Low | Low | Simple feature, known pattern |
| M | 1-3 days | Medium | Medium | Moderate feature, some unknowns |
| L | 3-5 days | High | High | Complex feature, integration |
| XL | 1-2 weeks | Very High | Very High | New system, many unknowns |

### When to Use
- Sprint planning
- Initial scoping
- Roadmap discussions
- Backlog grooming

### Pros & Cons
| Pros | Cons |
|------|------|
| Fast | Not precise |
| Easy to understand | Subjective |
| Good for comparison | Hard to sum up |

---

## 3. Story Points

### Fibonacci Scale
| Points | Relative Effort |
|--------|-----------------|
| 1 | Trivial |
| 2 | Small |
| 3 | Medium |
| 5 | Large |
| 8 | Very Large |
| 13 | Epic-level |
| 21+ | Too big, split |

### Reference Stories
```markdown
### 1 Point Reference
"Update button text from 'Submit' to 'Save'"

### 3 Point Reference
"Add email validation to registration form"

### 5 Point Reference
"Implement password reset flow"

### 8 Point Reference
"Add export to CSV for user reports"

### 13 Point Reference
"Integrate with third-party payment gateway"
```

### Velocity Tracking
```
Sprint 1: 32 points completed
Sprint 2: 28 points completed
Sprint 3: 35 points completed
───────────────────────────
Average velocity: 32 points/sprint
```

---

## 4. Three-Point Estimation

### Formula
```
Expected = (Optimistic + 4×Likely + Pessimistic) / 6

Standard Deviation = (Pessimistic - Optimistic) / 6
```

### Example
```markdown
### Feature: User Dashboard

| Estimate | Days | Assumptions |
|----------|------|-------------|
| Optimistic | 3 | Everything goes smoothly |
| Likely | 5 | Normal development pace |
| Pessimistic | 10 | API issues, design changes |

Expected = (3 + 4×5 + 10) / 6 = 5.5 days
Std Dev = (10 - 3) / 6 = 1.2 days

**Estimate: 5-7 days (95% confidence)**
```

---

## 5. Work Breakdown Structure (WBS)

### Template
```markdown
## Feature: User Notifications

### 1. Backend (Total: 5 days)
├── 1.1 Database schema (0.5 day)
├── 1.2 API endpoints (2 days)
│   ├── GET /notifications
│   ├── POST /notifications/read
│   └── DELETE /notifications
├── 1.3 WebSocket setup (1.5 days)
└── 1.4 Event handlers (1 day)

### 2. Frontend (Total: 4 days)
├── 2.1 UI components (2 days)
│   ├── Notification list
│   ├── Notification item
│   └── Badge counter
├── 2.2 State management (1 day)
└── 2.3 WebSocket client (1 day)

### 3. Testing (Total: 2 days)
├── 3.1 Unit tests (1 day)
└── 3.2 Integration tests (1 day)

### 4. Documentation (0.5 day)

### Total: 11.5 days
### With buffer (20%): 14 days
```

---

## 6. Planning Poker

### Process
```
1. PM presents user story
2. Team asks clarifying questions
3. Each dev secretly picks estimate card
4. All reveal simultaneously
5. Highest/lowest explain reasoning
6. Discuss and re-estimate if needed
7. Reach consensus
```

### Card Values
```
0, 1, 2, 3, 5, 8, 13, 20, 40, 100, ?, ☕
```

### When Estimates Diverge
- Outliers explain their reasoning
- Often reveals missing information
- Re-estimate after discussion

---

## 7. Estimation Confidence

### Confidence Levels

| Level | Range | When to Use |
|-------|-------|-------------|
| High | ±10% | Done before, well-understood |
| Medium | ±25% | Some unknowns, similar work |
| Low | ±50% | Many unknowns, new technology |
| Swag | ±100% | Pure guess, needs spike |

### Communicating Uncertainty
```markdown
### Estimate with Confidence

"This feature will take approximately 2 weeks (Medium confidence).

The main uncertainty is the third-party API integration.
If their documentation is accurate, closer to 1.5 weeks.
If we encounter issues, could extend to 2.5 weeks.

Recommend: Start with API spike (2 days) to reduce uncertainty."
```

---

## 8. Buffer Guidelines

### Rule of Thumb
| Confidence | Buffer |
|------------|--------|
| High | 10-15% |
| Medium | 20-30% |
| Low | 40-50% |

### Types of Buffer
- **Contingency**: Unknown unknowns
- **Risk buffer**: For identified risks
- **Management reserve**: Scope changes

---

## 9. Estimation Anti-Patterns

### Red Flags

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Single point estimate | No uncertainty | Use ranges |
| Estimate without breakdown | Missing work | Do WBS first |
| Ignoring dependencies | Blocked work | Map dependencies |
| Padding secretly | Erodes trust | Explicit buffer |
| Anchoring | Bias to first number | Estimate independently |
| Planning fallacy | Optimism bias | Use historical data |

---

## 10. PM-Dev Estimation Dialog

### Healthy Conversation
```markdown
**PM**: "How long for the notification feature?"

**Dev**: "Let me break it down:
- Backend: 5 days
- Frontend: 4 days
- Testing: 2 days
- Total: ~11 days

With medium confidence due to WebSocket unknowns.
Could be 9-14 days realistically."

**PM**: "What if we skip WebSocket for MVP?"

**Dev**: "Polling-based would be:
- Backend: 3 days
- Frontend: 2 days
- Testing: 1 day
- Total: ~6 days with high confidence"

**PM**: "Let's do polling for MVP, WebSocket in Phase 2."
```

### Estimation Meeting Template
```markdown
## Estimation Session: {Feature}

### Attendees
- PM: {name}
- Dev: {names}

### Stories Estimated
| Story | Initial | Discussed | Final |
|-------|---------|-----------|-------|
| US-1 | 3/5/8 | Clarified scope | 5 |
| US-2 | 5/5/5 | Consensus | 5 |
| US-3 | 3/8/13 | Needs spike | ? |

### Notes
- {Discussion point 1}
- {Decision made}

### Action Items
- [ ] Spike for US-3 (2 days)
```

---

## 11. Tracking & Improving

### Estimate vs Actual Tracking
```markdown
| Story | Estimate | Actual | Variance | Reason |
|-------|----------|--------|----------|--------|
| US-1 | 5 days | 6 days | +20% | API issues |
| US-2 | 3 days | 2 days | -33% | Reused code |
| US-3 | 8 days | 10 days | +25% | Scope creep |
```

### Improving Over Time
1. Track actual vs estimated
2. Identify patterns in variances
3. Adjust future estimates
4. Build team reference stories
5. Review regularly in retros

---

## References

- [Software Estimation: Demystifying the Black Art - Steve McConnell](https://www.construx.com/books/software-estimation-demystifying-the-black-art/)
- [The Clean Coder - Robert Martin](https://www.amazon.com/Clean-Coder-Conduct-Professional-Programmers/dp/0137081073)
