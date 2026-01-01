# Kanban Tool - Bug Tracking Board

> **Kanban** là CÔNG CỤ visual management để track bug lifecycle.

---

## Nguyên Lý Kanban

### Core Principles

1. **Visualize Work**: Mọi bug đều visible trên board
2. **Limit WIP**: Giới hạn số bug đang xử lý
3. **Manage Flow**: Theo dõi bug flow qua các stages
4. **Explicit Policies**: Rules rõ ràng cho mỗi column
5. **Continuous Improvement**: Retrospective định kỳ

---

## Board Configuration

### Columns

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           BUG KANBAN BOARD                                  │
├─────────────┬─────────────┬─────────────┬─────────────┬─────────────────────┤
│  BACKLOG    │  ANALYZING  │  READY      │  IN PROGRESS│  DONE               │
│  WIP: ∞     │  WIP: 3     │  WIP: 5     │  WIP: 2     │  Archive weekly     │
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────────────┤
│ Unprocessed │ 5Why/5W2H   │ Solution    │ Being       │ Verified &          │
│ bugs        │ in progress │ spec ready  │ fixed       │ closed              │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────────────┘
```

### Column Definitions

| Column | Entry Criteria | Exit Criteria | WIP |
|--------|----------------|---------------|-----|
| **BACKLOG** | Bug reported | Triaged, severity assigned | ∞ |
| **ANALYZING** | Prioritized for analysis | 5W2H + 5Why complete | 3 |
| **READY** | Root cause known, solution spec'd | Assigned to specialist | 5 |
| **IN PROGRESS** | Specialist accepted | Fix implemented & tested | 2 |
| **DONE** | Verified in staging | Deployed to prod | Archive |

---

## Bug Card Structure

### Card Template (YAML)

```yaml
id: BUG-{NNN}
title: "{Short description - max 60 chars}"
severity: critical | high | medium | low
status: backlog | analyzing | ready | in_progress | done
priority: P0 | P1 | P2 | P3

# Metadata
reported: YYYY-MM-DD
reporter: "{who found it}"
assignee: "{specialist-agent}"
labels:
  - "{category}"  # performance, security, data, api, etc.

# Tracking
created: YYYY-MM-DD
updated: YYYY-MM-DD
resolved: YYYY-MM-DD

# Links
related_bugs: [BUG-XXX]
blocks: [BUG-YYY]
blocked_by: [BUG-ZZZ]
```

### Card Visual

```
┌─────────────────────────────────────┐
│ [CRITICAL] BUG-007                  │
├─────────────────────────────────────┤
│ Race condition in RouteMessage      │
├─────────────────────────────────────┤
│ 📁 services/agentrouter/router.go  │
│ 👤 router-agent                     │
│ 📅 2024-12-30                       │
├─────────────────────────────────────┤
│ [performance] [concurrency]         │
└─────────────────────────────────────┘
```

---

## Severity Levels

| Level | Color | SLA | Definition |
|-------|-------|-----|------------|
| **CRITICAL** | 🔴 Red | 4h | System down, data loss, security breach |
| **HIGH** | 🟠 Orange | 24h | Major feature broken, workaround difficult |
| **MEDIUM** | 🟡 Yellow | 1 week | Feature degraded, workaround exists |
| **LOW** | 🟢 Green | Backlog | Minor issue, cosmetic, edge case |

### Priority Matrix

```
              IMPACT
         Low    Med    High
       ┌──────┬──────┬──────┐
  High │  P2  │  P1  │  P0  │
URGENCY├──────┼──────┼──────┤
  Med  │  P3  │  P2  │  P1  │
       ├──────┼──────┼──────┤
  Low  │  P3  │  P3  │  P2  │
       └──────┴──────┴──────┘
```

---

## WIP Limits

### Why Limits?

- **Focus**: Fewer bugs = deeper analysis
- **Flow**: Avoid bottlenecks
- **Quality**: Better fixes, less rework
- **Visibility**: Clear picture of capacity

### Enforcement

```
IF column.bugs.count >= column.wip_limit:
  → Block new bugs from entering
  → Focus on moving existing bugs forward
  → Escalate if blocked
```

---

## Workflow Rules

### BACKLOG → ANALYZING

- [ ] Severity assigned
- [ ] Basic reproduction steps documented
- [ ] Not a duplicate
- [ ] Within WIP limit for ANALYZING

### ANALYZING → READY

- [ ] 5W2H documentation complete
- [ ] 5Why root cause identified
- [ ] Solution approach defined
- [ ] Specialist identified

### READY → IN PROGRESS

- [ ] Specialist available
- [ ] No blockers
- [ ] Within WIP limit for IN PROGRESS
- [ ] Acceptance criteria clear

### IN PROGRESS → DONE

- [ ] Fix implemented
- [ ] Unit tests pass
- [ ] Code reviewed
- [ ] Tested in staging
- [ ] No regression

---

## Metrics

### Key Metrics

| Metric | Formula | Target |
|--------|---------|--------|
| **Lead Time** | DONE.date - BACKLOG.date | < 7 days |
| **Cycle Time** | DONE.date - IN_PROGRESS.date | < 2 days |
| **Throughput** | Bugs DONE per week | Trending up |
| **WIP Age** | Days in current column | < 3 days |

### Health Indicators

```
🟢 Healthy: All columns within WIP, bugs flowing
🟡 Warning: 1 column at WIP limit
🔴 Blocked: Multiple columns at WIP, bugs stuck
```

---

## Board Commands

### View Board

```bash
*board              # Show full Kanban board
*board --summary    # Show counts only
*board --blocked    # Show blocked items
```

### Move Bug

```bash
*move BUG-007 analyzing   # Move to ANALYZING
*move BUG-007 ready       # Move to READY
*move BUG-007 done        # Move to DONE
```

### Query

```bash
*bugs --status=analyzing
*bugs --severity=critical
*bugs --assignee=router-agent
*bugs --label=performance
```

---

## Integration

### With 5Why

Khi bug vào ANALYZING:
1. Apply 5Why để tìm root cause
2. Document trong bug card
3. Move to READY khi có solution

### With 5W2H

Khi bug vào ANALYZING:
1. Apply 5W2H để document đầy đủ
2. Ensure all 7 questions answered
3. Attach to bug card

---

## File Location

Bug Kanban board được lưu tại:
```
.claude/agents/microai/teams/project-team/bugs-agent/memory/bug-backlog.md
```
