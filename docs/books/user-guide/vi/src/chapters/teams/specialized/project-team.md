# project-team

Team quản lý dự án với các specialized roles.

## Tổng Quan

project-team hỗ trợ project management với planning, tracking, và coordination.

## Team Roles

| Role | Responsibility |
|------|----------------|
| PM | Project planning, tracking |
| Tech Lead | Technical decisions |
| Scrum Master | Process facilitation |

## Use Cases

- Sprint planning
- Project kickoff
- Risk assessment
- Progress reporting

## Kích Hoạt

```
/microai:project
```

## Workflow

```
┌───────────────┐
│  Requirements │
└───────┬───────┘
        │
┌───────▼───────┐
│  Planning     │ ← Break down, estimate
└───────┬───────┘
        │
┌───────▼───────┐
│  Execution    │ ← Track, coordinate
└───────┬───────┘
        │
┌───────▼───────┐
│  Reporting    │ ← Status, metrics
└───────────────┘
```

## Output Formats

### Sprint Plan

```markdown
# Sprint [X] Plan

## Goal
[Sprint objective]

## Capacity
- Available: X days
- Planned: Y story points

## Backlog

| ID | Story | Points | Assigned |
|----|-------|--------|----------|
| US-1 | ... | 3 | Dev A |
| US-2 | ... | 5 | Dev B |

## Risks
- [Risk 1]

## Dependencies
- [Dependency 1]
```

### Status Report

```markdown
# Status Report: [Date]

## Summary
🟢 On Track / 🟡 At Risk / 🔴 Blocked

## Progress
- Completed: X stories
- In Progress: Y stories
- Remaining: Z stories

## Metrics
- Velocity: X points
- Burndown: [chart]

## Issues & Risks
- [Issue 1]: [Status]

## Next Week
- [Planned work]
```

## Ví Dụ Session

```
You: /microai:project

Project Team: 📊 Project Team ready!
How can we help with your project?
- Sprint planning
- Status reporting
- Risk assessment

You: Help plan next sprint for payment feature

PM: 📋 Let's plan Sprint 5!

**Sprint Goal**: Implement basic payment flow

**Available Capacity**:
- 3 developers × 8 days = 24 dev-days
- Historical velocity: 30 points

**Proposed Backlog**:

| Priority | Story | Points | Notes |
|----------|-------|--------|-------|
| P1 | Payment API | 8 | Core flow |
| P1 | Checkout UI | 5 | Frontend |
| P1 | Order integration | 5 | Connect order |
| P2 | Payment history | 5 | Nice to have |
| P2 | Receipt email | 3 | Nice to have |
| **Total** | | **26** | |

Tech Lead: 🛠️ Technical notes:
- Payment API needs PSP integration first
- Checkout UI can start after API design
- Order integration depends on Payment API

Scrum Master: 🏃 Process notes:
- P1 items = must complete
- P2 items = stretch goals
- Daily standups at 10am
- Demo Friday 4pm

**Risks**:
1. PSP sandbox may have delays
2. Payment testing needs special setup

**Mitigation**:
1. Start PSP integration day 1
2. Setup test environment sprint day 1
```

## Xem Thêm

- [Specialized Teams Overview](../specialized-teams.md)
- [Best Practices](../../workflows/best-practices.md)
