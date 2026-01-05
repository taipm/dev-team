# OPPM Framework & Methodology

## Overview

One-Page Project Management (OPPM) là phương pháp quản lý dự án được phát triển bởi **Clark A. Campbell** (2007). Nguyên tắc cốt lõi: **Mọi thông tin quan trọng của dự án phải nằm gọn trong 1 trang giấy.**

---

## 5 Essential Elements

```
┌─────────────────────────────────────────────────────────────────┐
│                    THE OPPM FRAMEWORK                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  1. HEADER                                               │   │
│  │     Project name, owner, period, last update date        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                         │                                       │
│                         ▼                                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  2. OBJECTIVES (3-5 max)                                 │   │
│  │     Measurable goals, success criteria                   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                         │                                       │
│                         ▼                                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  3. TASKS/ACTIVITIES (10-15 max)                         │   │
│  │     Major work items with owners                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                         │                                       │
│                         ▼                                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  4. TIMELINE/SCHEDULE                                    │   │
│  │     Visual matrix: Tasks × Time periods                  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                         │                                       │
│                         ▼                                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  5. STATUS & METRICS                                     │   │
│  │     RAG status, budget, key metrics                      │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Element 1: Header

### Required Fields

| Field | Description | Example |
|-------|-------------|---------|
| Project Name | Tên dự án, ngắn gọn | "Mobile App v2.0" |
| Owner | PM hoặc người chịu trách nhiệm | "Nguyen Van A" |
| Period | Start → End | "Q1 2026 (Jan-Mar)" |
| Updated | Ngày cập nhật lần cuối | "2026-01-04" |

### Format

```
╔═══════════════════════════════════════════════════════════════════╗
║  PROJECT: Mobile App v2.0                     Owner: Nguyen Van A ║
║  Period: Jan 2026 → Mar 2026                  Updated: 2026-01-04 ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

## Element 2: Objectives

### Rules

1. **3-5 objectives maximum** - nếu nhiều hơn, không fit 1 page
2. **Measurable** - phải đo lường được
3. **SMART format** - Specific, Measurable, Achievable, Relevant, Time-bound

### Good vs Bad Objectives

| Bad | Good |
|-----|------|
| "Improve performance" | "Reduce page load time to <2s" |
| "Better UX" | "Achieve NPS score >50" |
| "More features" | "Release 3 new features by Q1 end" |
| "Happy customers" | "Reduce support tickets by 30%" |

### Format

```
╔═══════════════════════════════════════════════════════════════════╗
║  OBJECTIVES                                                       ║
╠═══════════════════════════════════════════════════════════════════╣
║  ○ 1. Reduce page load time to <2s (currently 4.5s)              ║
║  ○ 2. Achieve 95% crash-free sessions (currently 89%)            ║
║  ○ 3. Release iOS and Android apps by Mar 15                     ║
║  ○ 4. Onboard 1000 beta users by Feb 28                          ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

## Element 3: Tasks/Activities

### Rules

1. **10-15 tasks maximum** - giữ high-level
2. **Each task has an owner** - accountability
3. **Verb-based naming** - "Design", "Implement", "Test", "Deploy"
4. **Group related tasks** - dùng numbering (1.1, 1.2...)

### Format

```
  TASKS                                                    Owner
  ──────────────────────────────────────────────────────────────────
  1. Design & Planning
     1.1 Complete UI/UX designs                            @designer
     1.2 Finalize technical architecture                   @tech-lead
  2. Development
     2.1 Implement core features                           @dev-team
     2.2 API integration                                   @backend
  3. Testing & Launch
     3.1 QA testing cycle                                  @qa-team
     3.2 Beta release                                      @pm
     3.3 Production deployment                             @devops
```

---

## Element 4: Timeline/Schedule Matrix

### Structure

Matrix format: **Rows = Tasks**, **Columns = Time periods**

### Time Period Options

| Project Length | Period Type | Example |
|----------------|-------------|---------|
| 1-4 weeks | Days | D1, D2, D3... |
| 1-3 months | Weeks | W1, W2, W3... |
| 3-12 months | Months | M1, M2, M3... or Jan, Feb... |
| >1 year | Quarters | Q1, Q2, Q3... |

### Visual Indicators

```
██  = Active (đang làm trong period này)
░░  = Planned (dự kiến, chưa bắt đầu)
▓▓  = Completed (đã hoàn thành)
──  = Delayed (trễ so với kế hoạch)
    = Not applicable (không làm trong period này)
```

### Format

```
╔═══════════════════════════════════════════════════════════════════╗
║  TASKS                           │  W1  W2  W3  W4  W5  │ Owner   ║
╠══════════════════════════════════╪══════════════════════╪═════════╣
║  1.1 Complete UI/UX designs      │  ▓▓  ▓▓              │ @design ║
║  1.2 Finalize architecture       │  ▓▓                  │ @tech   ║
║  2.1 Implement core features     │      ██  ██  ░░      │ @dev    ║
║  2.2 API integration             │          ██  ██  ░░  │ @back   ║
║  3.1 QA testing cycle            │              ░░  ░░  │ @qa     ║
║  3.2 Beta release                │                  ░░  │ @pm     ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

## Element 5: Status & Metrics

### RAG Status

```
🟢 GREEN (On Track)    - Đúng kế hoạch, không có risk
🟡 YELLOW (At Risk)    - Có risk, cần attention
🔴 RED (Blocked)       - Đang blocked, cần escalation
```

### Key Metrics

Tùy project type, chọn 2-3 metrics quan trọng nhất:

| Project Type | Suggested Metrics |
|--------------|-------------------|
| Software | Velocity, Bug count, Test coverage |
| General | Budget spent, Milestones hit, Deliverables |
| Agile | Sprint burndown, Story points, Team velocity |
| Personal | Goals completed, Habits streak, Time invested |

### Format

```
╔═══════════════════════════════════════════════════════════════════╗
║  STATUS: 🟡 At Risk                                               ║
║  ─────────────────────────────────────────────────────────────────║
║  BUDGET:     $45,000 / $60,000 (75%)  ████████████████░░░░        ║
║  VELOCITY:   32 pts/sprint (target: 35)                           ║
║  RISKS:      Backend API delay (-3 days)                          ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

## OPPM Best Practices

### DO

```
✓ Update weekly (hoặc bi-weekly)
✓ Keep it to ONE page - nghiêm ngặt
✓ Use color coding for quick scanning
✓ Share with all stakeholders
✓ Focus on major activities only
✓ Include dependencies if critical
```

### DON'T

```
✗ Don't include detailed task breakdowns (link to backlog)
✗ Don't list every meeting or small task
✗ Don't use more than 15 tasks
✗ Don't skip owners
✗ Don't update less than monthly
✗ Don't hide bad news - transparency is key
```

---

## Quick Reference: OPPM Checklist

```
□ Header complete? (Name, Owner, Period, Updated)
□ 3-5 measurable objectives?
□ 10-15 high-level tasks?
□ Every task has an owner?
□ Timeline matrix visible?
□ Status indicator present?
□ Fits on ONE page?
□ Updated within last 2 weeks?
```

---

## References

- Campbell, Clark A. (2007). *One-Page Project Manager*
- Campbell, Clark A. (2010). *The New One-Page Project Manager*
