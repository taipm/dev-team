# Team Cơ Bản

Hướng dẫn tạo team đầu tiên của bạn.

## Tổng Quan

Một team cơ bản bao gồm:
- Thư mục team với cấu trúc chuẩn
- workflow.md định nghĩa quy trình
- Các agent thành viên
- Team memory (optional)

## Bước 1: Tạo Thư Mục Team

```bash
mkdir -p .microai/agents/microai/teams/my-team/{agents,team-memory}
```

Cấu trúc:

```
my-team/
├── workflow.md           # Team workflow definition
├── agents/               # Team member agents
│   ├── lead.md          # Team lead
│   ├── specialist-1.md  # Specialist 1
│   └── specialist-2.md  # Specialist 2
└── team-memory/          # Shared team memory
    ├── context.md
    ├── decisions.md
    └── handoffs.md
```

## Bước 2: Định Nghĩa Workflow

Tạo `workflow.md`:

```yaml
---
name: my-team
description: |
  Mô tả team. Sử dụng khi:
  - Use case 1
  - Use case 2

type: sequential           # sequential | parallel | consultation
lead: lead.md             # Team lead agent

agents:
  - lead.md
  - specialist-1.md
  - specialist-2.md

phases:
  - name: understand
    agent: lead
    description: Hiểu vấn đề

  - name: analyze
    agents: [specialist-1, specialist-2]
    description: Phân tích từ nhiều góc độ

  - name: synthesize
    agent: lead
    description: Tổng hợp kết quả
---

# My Team Workflow

## Tổng Quan

Team này giúp [mục đích chính].

## Quy Trình

### Phase 1: Understand
Lead agent thu thập thông tin và làm rõ yêu cầu.

### Phase 2: Analyze
Các specialists phân tích từ góc độ chuyên môn của mình.

### Phase 3: Synthesize
Lead tổng hợp và đưa ra kết luận.

## Handoff Protocol

Khi chuyển giao giữa các agents:
1. Summarize findings
2. List open questions
3. Specify next steps

## Observer Commands

| Command | Mô tả |
|---------|-------|
| `*status` | Xem phase hiện tại |
| `*focus {agent}` | Yêu cầu agent cụ thể |
| `*summarize` | Tóm tắt |
```

## Bước 3: Tạo Agent Lead

Tạo `agents/lead.md`:

```yaml
---
name: my-team-lead
description: Lead của my-team
model: sonnet
tools: [Read, Write, Edit, Glob, Grep, AskUserQuestion, TodoWrite]
---

# Team Lead

## Persona

Bạn là team lead, điều phối hoạt động của team.

## Trách Nhiệm

1. Tiếp nhận yêu cầu từ user
2. Phân công cho specialists
3. Tổng hợp kết quả
4. Đưa ra kết luận

## Quy Trình Điều Phối

### Khi bắt đầu session
1. Chào mừng và giới thiệu team
2. Thu thập context từ user
3. Xác định phase phù hợp

### Khi kết thúc session
1. Tóm tắt findings
2. Update team-memory/context.md
3. Log decisions quan trọng

## Handoff Template

Khi chuyển giao cho specialist:

```
## Handoff to [Specialist Name]

**Context**: [Tóm tắt tình huống]
**Request**: [Yêu cầu cụ thể]
**Constraints**: [Ràng buộc]
**Expected Output**: [Output mong đợi]
```
```

## Bước 4: Tạo Specialist Agents

Tạo `agents/specialist-1.md`:

```yaml
---
name: my-team-specialist-1
description: Specialist 1 của my-team
model: sonnet
tools: [Read, Glob, Grep]
---

# Specialist 1

## Persona

Bạn là chuyên gia về [lĩnh vực].

## Chuyên Môn

- Expertise 1
- Expertise 2
- Expertise 3

## Quy Trình Phân Tích

1. Nhận handoff từ lead
2. Phân tích theo chuyên môn
3. Document findings
4. Handoff trả lại lead

## Output Format

### Analysis Report

**Topic**: [Chủ đề phân tích]
**Findings**:
1. Finding 1
2. Finding 2

**Recommendations**:
1. Recommendation 1
2. Recommendation 2

**Open Questions**:
- Question 1
- Question 2
```

## Bước 5: Tạo Team Memory

Tạo `team-memory/context.md`:

```markdown
# Team Context

> Last updated: YYYY-MM-DD

## Current Project

**Project**: [Tên dự án]
**Status**: [Active/Paused/Completed]

## Active Tasks

| Task | Assigned | Status |
|------|----------|--------|
| Task 1 | specialist-1 | In Progress |

## Recent Decisions

- [Date]: [Decision summary]

## Blockers

- [ ] Blocker 1
```

Tạo `team-memory/handoffs.md`:

```markdown
# Handoff Log

## YYYY-MM-DD HH:MM

**From**: lead
**To**: specialist-1
**Context**: [Context]
**Request**: [Request]
**Status**: [Pending/Completed]
```

## Bước 6: Tạo Command

Tạo `.claude/commands/myteam/my-team.md`:

```yaml
---
name: 'my-team'
description: 'My Team - mô tả ngắn'
---

Bạn phải kích hoạt team này.

<team-activation CRITICAL="TRUE">
1. LOAD workflow từ @.microai/agents/microai/teams/my-team/workflow.md
2. LOAD tất cả agents trong teams/my-team/agents/
3. LOAD team-memory/context.md
4. Bắt đầu với lead agent
5. Follow workflow phases
</team-activation>
```

## Bước 7: Test Team

```bash
claude

/myteam:my-team
```

## Ví Dụ Thực Tế: Code Review Team

### Cấu Trúc

```
code-review-team/
├── workflow.md
├── agents/
│   ├── reviewer-lead.md
│   ├── security-reviewer.md
│   └── performance-reviewer.md
└── team-memory/
    ├── context.md
    └── review-history.md
```

### workflow.md

```yaml
---
name: code-review-team
description: |
  Team review code toàn diện. Sử dụng khi:
  - Review PR quan trọng
  - Security audit
  - Performance review

type: parallel
lead: reviewer-lead.md

agents:
  - reviewer-lead.md
  - security-reviewer.md
  - performance-reviewer.md

phases:
  - name: setup
    agent: lead
    description: Thu thập context về code cần review

  - name: review
    agents: [security-reviewer, performance-reviewer]
    parallel: true
    description: Review song song từ góc độ khác nhau

  - name: consolidate
    agent: lead
    description: Tổng hợp findings và tạo report
---

# Code Review Team

## Overview

Team gồm 3 reviewers:
- 👨‍💼 Lead: Điều phối, overall quality
- 🔒 Security: OWASP, vulnerabilities
- ⚡ Performance: Bottlenecks, optimization

## Workflow

1. Lead nhận PR/code cần review
2. Security và Performance review song song
3. Lead tổng hợp thành unified report

## Output

### Review Report

**Files Reviewed**: X files
**Lines Changed**: Y lines

**Security Issues**:
- [Critical/High/Medium/Low]: Description

**Performance Issues**:
- [Critical/High/Medium/Low]: Description

**Recommendations**:
1. ...
2. ...

**Verdict**: Approve / Request Changes / Block
```

## Checklist

- [ ] Thư mục team có cấu trúc đúng
- [ ] workflow.md có đầy đủ metadata
- [ ] Có agent lead
- [ ] Các specialist agents có role rõ ràng
- [ ] Team memory được setup
- [ ] Command để kích hoạt team
- [ ] Test team hoạt động

## Bước Tiếp Theo

- [Cấu trúc thư mục Team](./team-structure.md)
- [workflow.md chi tiết](./workflow-file.md)
- [Coordination Patterns](./coordination-patterns.md)
