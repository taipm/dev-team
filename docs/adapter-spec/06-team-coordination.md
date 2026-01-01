# 06 - Team Coordination | Phối hợp nhóm

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

The Team Coordination system enables **multi-agent collaboration** where specialized agents work together on complex tasks, sharing context and handing off work.

Hệ thống Team Coordination cho phép **phối hợp đa agent** khi các agent chuyên biệt cùng làm việc trên task phức tạp, chia sẻ context và bàn giao công việc.

---

## Directory Structure | Cấu trúc thư mục

```
.microai/agents/{namespace}/teams/{team-name}/
├── team-memory/                    # SHARED across all members
│   ├── context.md                  # Team-wide current state
│   ├── decisions.md                # Team decisions log
│   ├── handoffs.md                 # Agent-to-agent transfers
│   └── blockers.md                 # Current blockers
│
├── lead-agent/                     # Team orchestrator
│   ├── agent.md                    # Lead agent definition
│   └── memory/
│       ├── context.md              # Lead's personal context
│       └── dispatch-log.md         # Task dispatch tracking
│
├── specialist-agent-1/             # Team member
│   ├── agent.md
│   └── memory/
│
└── specialist-agent-2/             # Team member
    ├── agent.md
    └── memory/
```

---

## Team Memory | Memory nhóm

### team-memory/context.md

**Purpose | Mục đích**: Shared state visible to all team members.

```markdown
# Team Context | Context nhóm

> Team: Deep Thinking Team
> Last updated: 2025-12-31

---

## Active Problem | Vấn đề đang giải quyết

**Problem**: Design scalable authentication system for microservices

**Constraints | Ràng buộc**:
- Must support 10M+ users
- Sub-100ms authentication latency
- Cross-service token validation

---

## Team Status | Trạng thái nhóm

| Agent | Status | Current Task |
|-------|--------|--------------|
| Maestro (Lead) | Active | Coordinating analysis |
| Dijkstra | Complete | Algorithm analysis |
| Linus | In Progress | Systems design review |
| Bezos | Pending | Customer impact analysis |

---

## Shared Findings | Phát hiện chung

### From Dijkstra (Algorithm Analysis):
- JWT validation is O(1) with proper caching
- Token refresh is the bottleneck, not validation

### From Linus (Systems Review):
- Centralized auth service is single point of failure
- Recommend distributed validation with shared secret

---

## Agreed Approach | Phương án đã thống nhất

1. Use asymmetric JWT (RS256)
2. Distribute public key to all services
3. Centralize token issuance only

---

## Open Questions | Câu hỏi mở

- [ ] How to handle key rotation?
- [ ] Token revocation strategy?

---
```

### team-memory/decisions.md

**Purpose | Mục đích**: Record team-level decisions.

```markdown
# Team Decisions | Quyết định nhóm

---

## 2025-12-31: Use Asymmetric JWT (RS256)

**Proposed by | Đề xuất bởi**: Dijkstra
**Approved by | Phê duyệt bởi**: Maestro (Lead)

**Context | Bối cảnh**:
Need token validation across 20+ microservices without network calls.

**Decision | Quyết định**:
Use RS256 (RSA + SHA256) instead of HS256 (HMAC).

**Reasoning | Lý do**:
- Services only need public key (safe to distribute)
- No shared secret management
- Can rotate keys without service restart

**Dissenting Views | Ý kiến khác**:
- Linus: "RS256 is slower than HS256" - Accepted tradeoff for security

**Implementation Impact | Ảnh hưởng triển khai**:
- Auth service owns private key
- All services receive public key via config
- Key rotation every 90 days

---
```

### team-memory/handoffs.md

**Purpose | Mục đích**: Track work transfers between agents.

```markdown
# Handoff Log | Nhật ký bàn giao

---

## 2025-12-31 10:30: Maestro → Dijkstra

**Task | Nhiệm vụ**: Analyze JWT validation algorithm complexity

**Context Provided | Context cung cấp**:
- Token structure: header.payload.signature
- Expected volume: 100K validations/second
- Current approach: HS256 with shared secret

**Expected Deliverable | Kết quả mong đợi**:
- Time complexity analysis
- Space complexity for caching
- Bottleneck identification

**Status | Trạng thái**: ✅ Complete

**Result Summary | Tóm tắt kết quả**:
- Validation: O(1) with signature cache
- Bottleneck: Token refresh, not validation
- Recommendation: Use RS256 for distribution

---

## 2025-12-31 11:00: Maestro → Linus

**Task | Nhiệm vụ**: Review system architecture for auth service

**Context Provided | Context cung cấp**:
- Dijkstra's analysis (see above)
- Current: Single auth service
- Goal: Distributed validation

**Expected Deliverable | Kết quả mong đợi**:
- Architecture diagram
- Failure mode analysis
- Scalability assessment

**Status | Trạng thái**: 🔄 In Progress

---

## 2025-12-31 11:30: Linus → Bezos (Planned)

**Task | Nhiệm vụ**: Analyze customer impact of proposed architecture

**Context Provided | Context cung cấp**:
- (Will include Linus's architecture recommendation)

**Expected Deliverable | Kết quả mong đợi**:
- User experience impact
- Migration risk assessment
- Rollout strategy

**Status | Trạng thái**: ⏳ Pending

---
```

### team-memory/blockers.md

**Purpose | Mục đích**: Track issues blocking team progress.

```markdown
# Current Blockers | Điểm nghẽn hiện tại

---

## BLOCKER-001: Key Rotation Strategy Undefined

**Identified by | Phát hiện bởi**: Linus
**Identified at | Phát hiện lúc**: 2025-12-31 11:15
**Blocking | Đang chặn**: Final architecture approval

**Description | Mô tả**:
RS256 requires key rotation for security. Need strategy for:
- How often to rotate (90 days? 30 days?)
- How to distribute new public keys
- How to handle in-flight tokens during rotation

**Proposed Solutions | Giải pháp đề xuất**:
1. Multiple active keys (kid in JWT header)
2. Grace period for old key (24h overlap)
3. Push new key via config service

**Owner | Người phụ trách**: Linus
**Status | Trạng thái**: 🔄 Investigating

---

## BLOCKER-002: [RESOLVED] Token Size Concern

**Identified by | Phát hiện bởi**: Dijkstra
**Resolved by | Giải quyết bởi**: Maestro
**Resolution | Cách giải quyết**: Accept larger token size (800B vs 400B) as acceptable tradeoff for RS256 security benefits.

---
```

---

## Lead Agent Protocol | Protocol Agent dẫn đầu

### Dispatch Protocol | Protocol phân công

The lead agent (orchestrator) coordinates team work:

```xml
<dispatch_protocol>
  <step n="1">
    <action>Analyze incoming task</action>
    <details>Identify required expertise, subtasks, dependencies</details>
  </step>

  <step n="2">
    <action>Select specialists</action>
    <details>Match subtasks to agent capabilities</details>
  </step>

  <step n="3">
    <action>Prepare handoff context</action>
    <details>Extract relevant information for specialist</details>
  </step>

  <step n="4">
    <action>Log to dispatch-log.md</action>
    <details>Record task, specialist, context, expected deliverable</details>
  </step>

  <step n="5">
    <action>Invoke specialist</action>
    <details>Call with @agent reference and context</details>
  </step>

  <step n="6">
    <action>Collect and integrate results</action>
    <details>Update team-memory/context.md with findings</details>
  </step>

  <step n="7">
    <action>Synthesize final response</action>
    <details>Combine specialist outputs into cohesive answer</details>
  </step>
</dispatch_protocol>
```

### dispatch-log.md Format | Định dạng dispatch-log.md

```markdown
# Dispatch Log | Nhật ký phân công

---

## Session: 2025-12-31

### Task: Design Scalable Auth System

**Received | Nhận**: 10:00
**Status | Trạng thái**: In Progress

**Dispatch Plan | Kế hoạch phân công**:

| Order | Specialist | Subtask | Status | Duration |
|-------|------------|---------|--------|----------|
| 1 | Dijkstra | Algorithm analysis | ✅ Done | 15min |
| 2 | Linus | Systems architecture | 🔄 Active | - |
| 3 | Bezos | Customer impact | ⏳ Pending | - |
| 4 | Jobs | UX considerations | ⏳ Pending | - |

**Findings Integration | Tích hợp kết quả**:

1. **Dijkstra** → JWT validation O(1), recommend RS256
2. **Linus** → (awaiting)
3. **Bezos** → (awaiting)

---
```

---

## Handoff Protocol | Protocol bàn giao

### Standard Handoff | Bàn giao tiêu chuẩn

```markdown
## YYYY-MM-DD HH:MM: {From Agent} → {To Agent}

**Task | Nhiệm vụ**: {Brief description}

**Context Provided | Context cung cấp**:
- {Key information 1}
- {Key information 2}
- {Relevant files/findings}

**Files Involved | File liên quan**:
| File | State | Notes |
|------|-------|-------|
| `path/file.go` | Modified | Added auth handler |

**Expected Deliverable | Kết quả mong đợi**:
- {Specific output 1}
- {Specific output 2}

**Deadline/Priority | Hạn/Ưu tiên**: {High/Medium/Low}

**Status | Trạng thái**: ⏳ Pending / 🔄 In Progress / ✅ Complete / ❌ Blocked
```

### Handoff Verification | Xác minh bàn giao

```python
def verify_handoff(handoff: Handoff) -> bool:
    """
    Verify handoff has required information.
    Xác minh bàn giao có đủ thông tin cần thiết.
    """
    required_fields = [
        "from_agent",
        "to_agent",
        "task",
        "context",
        "expected_deliverable",
        "timestamp"
    ]

    for field in required_fields:
        if not getattr(handoff, field):
            log_error(f"Handoff missing required field: {field}")
            return False

    # Verify to_agent exists
    if not agent_exists(handoff.to_agent):
        log_error(f"Target agent not found: {handoff.to_agent}")
        return False

    return True
```

---

## Specialist Agent Protocol | Protocol Agent chuyên gia

### Receiving Handoff | Nhận bàn giao

```xml
<specialist_protocol>
  <on_handoff_received>
    <step n="1">
      <action>Load team context</action>
      <details>Read team-memory/context.md</details>
    </step>

    <step n="2">
      <action>Review handoff details</action>
      <details>Understand task, context, expected output</details>
    </step>

    <step n="3">
      <action>Load personal memory</action>
      <details>Read own memory/context.md</details>
    </step>

    <step n="4">
      <action>Execute task</action>
      <details>Apply specialist expertise</details>
    </step>

    <step n="5">
      <action>Prepare deliverable</action>
      <details>Format output as specified</details>
    </step>

    <step n="6">
      <action>Update team context</action>
      <details>Add findings to team-memory/context.md</details>
    </step>

    <step n="7">
      <action>Return to lead</action>
      <details>Report completion with summary</details>
    </step>
  </on_handoff_received>
</specialist_protocol>
```

### Result Format | Định dạng kết quả

```markdown
## Result: {Task Name}

**From | Từ**: {Specialist Agent}
**To | Đến**: {Lead Agent}
**Completed | Hoàn thành**: YYYY-MM-DD HH:MM

---

### Summary | Tóm tắt

{1-2 sentence overview}

---

### Findings | Phát hiện

#### Finding 1: {Title}
{Details}

#### Finding 2: {Title}
{Details}

---

### Recommendations | Khuyến nghị

1. {Recommendation 1}
2. {Recommendation 2}

---

### Confidence Level | Mức độ tin cậy

{High/Medium/Low} - {Brief explanation}

---

### Follow-up Questions | Câu hỏi theo dõi

- {Question for other specialists or user}
```

---

## Team Patterns | Các mẫu nhóm

### 1. Sequential Pipeline | Pipeline tuần tự

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Lead    │ ──▶ │ Agent A  │ ──▶ │ Agent B  │ ──▶ │ Agent C  │
│ (Start)  │     │          │     │          │     │ (Final)  │
└──────────┘     └──────────┘     └──────────┘     └──────────┘

Use when: Tasks have clear dependencies
Dùng khi: Task có phụ thuộc rõ ràng
```

### 2. Parallel Fan-out | Song song phân tán

```
                 ┌──────────┐
             ┌──▶│ Agent A  │──┐
             │   └──────────┘  │
┌──────────┐ │   ┌──────────┐  │   ┌──────────┐
│  Lead    │─┼──▶│ Agent B  │──┼──▶│  Lead    │
│ (Start)  │ │   └──────────┘  │   │ (Merge)  │
└──────────┘ │   ┌──────────┐  │   └──────────┘
             └──▶│ Agent C  │──┘
                 └──────────┘

Use when: Independent analyses can run in parallel
Dùng khi: Các phân tích độc lập có thể chạy song song
```

### 3. Expert Consultation | Tham vấn chuyên gia

```
┌──────────┐     ┌──────────┐
│  Lead    │◀───▶│ Expert A │
│          │     └──────────┘
│          │     ┌──────────┐
│          │◀───▶│ Expert B │
│          │     └──────────┘
└──────────┘

Use when: Lead needs specialist input on specific questions
Dùng khi: Lead cần input chuyên gia cho câu hỏi cụ thể
```

---

## Implementation Requirements | Yêu cầu implement

### For Level 3 Compliance | Cho tuân thủ Level 3

Adapters MUST:

1. **Support team directory structure**
   - Recognize `teams/{name}/` directories
   - Distinguish `team-memory/` from agent `memory/`

2. **Implement team memory loading**
   - Load team-memory/* for all team members
   - Merge with individual agent memory

3. **Support handoff operations**
   - Parse handoff records
   - Track handoff status
   - Notify agents of pending handoffs

4. **Provide team context APIs**
   - List team members
   - Get team state
   - Update shared context

### Team Loading Algorithm | Thuật toán load Team

```python
def load_team(team_path: str) -> Team:
    """
    Load team with all members and shared memory.
    Load team với tất cả thành viên và memory chung.
    """
    team = Team()

    # Load team-level memory
    team.memory = load_team_memory(f"{team_path}/team-memory")

    # Discover and load team members
    for agent_dir in list_directories(team_path):
        if agent_dir == "team-memory":
            continue

        agent_path = f"{team_path}/{agent_dir}"
        agent = load_agent(f"{agent_path}/agent.md")
        agent.memory = load_memory(agent_path)

        # Identify lead agent
        if agent.is_lead or agent_dir.endswith("-lead"):
            team.lead = agent
        else:
            team.members.append(agent)

    return team


def activate_team_member(team: Team, agent: Agent) -> Context:
    """
    Activate a team member with combined context.
    Kích hoạt thành viên team với context kết hợp.
    """
    context = Context()

    # Load team context first (shared)
    context.add_section("Team Context", team.memory.context)
    context.add_section("Team Decisions", team.memory.decisions[-5:])

    # Then load personal context
    context.add_section("Personal Context", agent.memory.context)

    # Load pending handoffs for this agent
    pending = get_pending_handoffs(team.memory.handoffs, agent.name)
    if pending:
        context.add_section("Pending Handoffs", pending)

    return context
```

---

## Example: Deep Thinking Team | Ví dụ: Nhóm Suy nghĩ sâu

```
.microai/agents/microai/teams/deep-thinking-team/
├── team-memory/
│   ├── context.md              # Current problem being analyzed
│   ├── decisions.md            # Agreed approaches
│   └── handoffs.md             # Work assignments
│
├── maestro/                    # Lead - Orchestrator
│   ├── agent.md
│   └── memory/
│       └── dispatch-log.md     # Who was assigned what
│
├── dijkstra/                   # Specialist - Algorithms
│   ├── agent.md
│   └── memory/
│
├── linus/                      # Specialist - Systems
│   ├── agent.md
│   └── memory/
│
├── feynman/                    # Specialist - Explanation
│   ├── agent.md
│   └── memory/
│
└── socrates/                   # Specialist - Questions
    ├── agent.md
    └── memory/
```

---

## Summary | Tóm tắt

| Component | Purpose | Level |
|-----------|---------|-------|
| `team-memory/context.md` | Shared team state | Level 3 |
| `team-memory/decisions.md` | Team-level decisions | Level 3 |
| `team-memory/handoffs.md` | Work transfer tracking | Level 3 |
| `dispatch-log.md` | Lead's task assignment log | Level 3 |
| Handoff Protocol | Structured work transfer | Level 3 |
| Parallel Execution | Concurrent specialist work | Level 3 |

---

*Next: [07-command-system.md](./07-command-system.md) - Commands & @-References*
