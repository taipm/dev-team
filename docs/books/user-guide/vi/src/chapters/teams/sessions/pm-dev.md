# pm-dev-session

Dialogue giữa Product Manager và Developer.

## Kích Hoạt

```
/microai:pm-dev-session
```

## Mục Đích

- Requirements refinement
- Technical specification
- Effort estimation
- Feasibility analysis

## Roles

### 📋 Product Manager
- Define requirements
- Prioritize features
- Clarify business value
- Accept/negotiate scope

### 👨‍💻 Developer
- Technical feasibility
- Effort estimation
- Propose alternatives
- Identify dependencies

## Output Formats

### 1. Technical Specification

```markdown
# Technical Spec: [Feature]

## Overview
[Business context and goal]

## Requirements
### Functional
- FR-1: ...
- FR-2: ...

### Non-Functional
- NFR-1: Performance - ...
- NFR-2: Security - ...

## Technical Approach
[How we'll build it]

## Dependencies
- [Dependency 1]
- [Dependency 2]

## Risks
| Risk | Mitigation |
|------|------------|
| ... | ... |

## Estimation
| Component | Effort |
|-----------|--------|
| Backend | 3 days |
| Frontend | 2 days |
| Testing | 1 day |
| **Total** | **6 days** |
```

### 2. Estimation Breakdown

```markdown
# Estimation: [Feature]

## Assumptions
- [Assumption 1]
- [Assumption 2]

## Breakdown

| Task | Best | Expected | Worst |
|------|------|----------|-------|
| API design | 0.5d | 1d | 2d |
| Implementation | 2d | 3d | 5d |
| Testing | 1d | 1.5d | 2d |
| **Total** | 3.5d | 5.5d | 9d |

## Confidence: 70%

## Notes
- [Important considerations]
```

## Ví Dụ Session

```
You: /microai:pm-dev-session

PM: 📋 Tôi muốn thêm feature export reports to PDF.
Users cần export dashboard data hàng tháng.

Developer: 👨‍💻 OK! Để estimate, tôi cần clarify:
1. Reports nào cần export?
2. Format cố định hay customizable?
3. Export ngay hay async (email)?

PM: 📋
1. 3 reports: Sales, Inventory, Customer
2. Fixed format cho mỗi report
3. Cho reports nhỏ: ngay. Lớn: async

Developer: 👨‍💻 Clear. Technical approach:

**Sync (< 1000 rows)**:
- Generate PDF server-side
- Return as download

**Async (> 1000 rows)**:
- Queue job
- Generate in background
- Send email with link

**Dependency**: Cần PDF library (puppeteer hoặc pdfkit)

PM: 📋 Sounds good. Effort bao nhiêu?

Developer: 👨‍💻

| Task | Effort |
|------|--------|
| PDF template design | 1 day |
| Sync export | 1.5 days |
| Async + queue | 2 days |
| Email notification | 0.5 day |
| Testing | 1 day |
| **Total** | **6 days** |

**Risks**:
- Complex charts in PDF có thể cần thêm 1 day
- Email deliverability testing

PM: 📋 6 days OK. Có thể release phần sync trước,
async sau không? MVP approach.

Developer: 👨‍💻 Được! MVP scope:

**Phase 1 (3 days)**:
- Sync export only
- Reports < 1000 rows
- 3 report types

**Phase 2 (3 days)**:
- Async cho large reports
- Email notifications

PM: 📋 Perfect! Đi Phase 1 trước.
Tạo Tech Spec cho Phase 1?

Developer: 👨‍💻

# Tech Spec: PDF Export - Phase 1

## Scope
Export Sales, Inventory, Customer reports
to PDF for reports < 1000 rows.

## Requirements
- FR-1: User clicks "Export PDF" on dashboard
- FR-2: PDF downloads immediately
- FR-3: Support 3 report types
- NFR-1: < 5s generation time

## Approach
- Use pdfkit library
- Pre-designed templates
- Server-side generation

## Estimation: 3 days
```

## Xem Thêm

- [Session Teams Overview](../session-teams.md)
- [Estimation Best Practices](../../workflows/estimation.md)
