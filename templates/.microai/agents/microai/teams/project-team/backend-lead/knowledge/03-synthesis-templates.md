# Synthesis Templates - Backend Lead

> Templates để tổng hợp và báo cáo kết quả cho user.

---

## Template 1: Execution Plan

Dùng khi bắt đầu task, trình bày plan cho user.

```markdown
## 🎯 Execution Plan

**Request:** {user's original request}

### Analysis
{Brief analysis of what needs to be done}

### Domains Involved
| Domain | Specialist | Scope |
|--------|------------|-------|
| {domain1} | {agent1} | {what they'll do} |
| {domain2} | {agent2} | {what they'll do} |

### Task Breakdown

**Phase 1: {phase name}**
| # | Task | Specialist | Depends On |
|---|------|------------|------------|
| 1 | {task description} | {agent} | - |
| 2 | {task description} | {agent} | - |

**Phase 2: {phase name}**
| # | Task | Specialist | Depends On |
|---|------|------------|------------|
| 3 | {task description} | {agent} | Task 1, 2 |

### Execution Mode
- Phase 1: Parallel
- Phase 2: Sequential (after Phase 1)

---

Bắt đầu thực hiện...
```

---

## Template 2: Progress Update

Dùng để cập nhật tiến độ trong quá trình thực hiện.

```markdown
## 🔄 Progress Update

### Completed
| Task | Specialist | Status | Notes |
|------|------------|--------|-------|
| {task1} | {agent1} | ✅ Done | {brief result} |
| {task2} | {agent2} | ✅ Done | {brief result} |

### In Progress
| Task | Specialist | Status | ETA |
|------|------------|--------|-----|
| {task3} | {agent3} | 🔄 Running | ~{time} |

### Pending
| Task | Specialist | Waiting For |
|------|------------|-------------|
| {task4} | {agent4} | Task 3 |

---

Đang chờ {task3} hoàn thành để tiếp tục...
```

---

## Template 3: Final Report

Dùng khi hoàn thành toàn bộ tasks.

```markdown
## ✅ Execution Complete

**Request:** {user's original request}

### Summary
{1-2 sentences về những gì đã làm}

### Tasks Completed
| # | Task | Specialist | Result |
|---|------|------------|--------|
| 1 | {task1} | {agent1} | {result} |
| 2 | {task2} | {agent2} | {result} |
| 3 | {task3} | {agent3} | {result} |

### Files Changed
```
{path/to/file1.go}  - {brief change description}
{path/to/file2.go}  - {brief change description}
{path/to/file3.go}  - {brief change description}
```

### Key Changes
1. **{Change 1 title}**
   - {detail}
   - {detail}

2. **{Change 2 title}**
   - {detail}
   - {detail}

### Tests to Run
```bash
go test ./internal/agentic/...
go test ./internal/hpsm/...
```

### Recommendations
- {recommendation 1}
- {recommendation 2}

---

Cần thêm gì nữa không?
```

---

## Template 4: Investigation Report

Dùng khi task là investigation/analysis.

```markdown
## 🔍 Investigation Report

**Question:** {what was investigated}

### Findings

#### From agentic-agent
{findings about agentic domain}

#### From hpsm-agent
{findings about HPSM domain}

#### From mongodb-agent
{findings about database domain}

### Root Cause Analysis
{synthesized analysis from all findings}

### Impact Assessment
| Area | Impact | Severity |
|------|--------|----------|
| {area1} | {impact} | High/Medium/Low |
| {area2} | {impact} | High/Medium/Low |

### Recommended Actions
| Priority | Action | Specialist |
|----------|--------|------------|
| 1 | {action} | {agent} |
| 2 | {action} | {agent} |
| 3 | {action} | {agent} |

---

Bạn muốn tôi thực hiện recommended actions không?
```

---

## Template 5: Error/Blocker Report

Dùng khi gặp lỗi hoặc blocker.

```markdown
## ⚠️ Blocker Encountered

### Task
{task that was being executed}

### Specialist
{agent that encountered the issue}

### Error
```
{error message or description}
```

### Analysis
{what might have caused this}

### Options
1. **{Option 1}** - {description}
   - Pros: {pros}
   - Cons: {cons}

2. **{Option 2}** - {description}
   - Pros: {pros}
   - Cons: {cons}

### Recommendation
{which option I recommend and why}

---

Bạn chọn option nào?
```

---

## Template 6: Conflict Resolution

Dùng khi có conflict giữa specialists.

```markdown
## ⚔️ Conflict Detected

### Conflicting Changes

**Specialist 1: {agent1}**
```
{what agent1 wants to change}
```

**Specialist 2: {agent2}**
```
{what agent2 wants to change}
```

### Conflict Point
{where and why they conflict}

### Resolution Options

| Option | Description | Recommended By |
|--------|-------------|----------------|
| A | {merge approach} | Backend Lead |
| B | {prioritize agent1} | {agent1} |
| C | {prioritize agent2} | {agent2} |

### My Recommendation
Option {X} vì {reason}

---

Bạn đồng ý với recommendation không?
```

---

## Quick Status Formats

### Inline Status

```
✅ agentic-agent: Done - Fixed timeout issue
🔄 hpsm-agent: Running - Implementing retry
⏳ mongodb-agent: Pending - Waiting for schema
❌ pattern-agent: Blocked - Need clarification
```

### Task Card

```
┌─────────────────────────────────────────┐
│ Task: Implement retry mechanism          │
├─────────────────────────────────────────┤
│ Specialist: hpsm-agent                   │
│ Status: 🔄 In Progress                   │
│ Files: internal/hpsm/client.go           │
│ Progress: 60%                            │
└─────────────────────────────────────────┘
```

### Completion Summary

```
╔═══════════════════════════════════════════════════════════════╗
║                    EXECUTION SUMMARY                           ║
╠═══════════════════════════════════════════════════════════════╣
║  Total Tasks: 5                                                ║
║  Completed:   5 ✅                                             ║
║  Failed:      0                                                ║
║  Files Changed: 8                                              ║
║  Specialists Used: 3 (agentic, hpsm, mongodb)                 ║
╚═══════════════════════════════════════════════════════════════╝
```
