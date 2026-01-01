# Team Decisions Log

> Decisions made by team consensus. Newest first.

---

## 2024-12-30: Team Structure with Memory System

**Participants**: father-agent, user

**Context**: Cần thiết lập Backend Team với khả năng persist context giữa các sessions.

**Decision**: Áp dụng Memory System template cho toàn team với:
- team-memory/ cho shared state
- Mỗi agent có memory/ riêng
- backend-lead có dispatch-log.md

**Reasoning**:
- Giúp agents nhớ context giữa sessions
- Track handoffs giữa agents
- Log decisions cho future reference

**Dissenting Views**: None

**Action Items**:
- [x] Create team-memory structure
- [ ] Add memory to each specialist

**Review Date**: 2025-01-15

---

## 2024-12-30: Specialist Agent Selection

**Participants**: father-agent, user

**Context**: Cần xác định các specialist agents cho Backend Team.

**Decision**: 6 specialists dựa trên domain analysis:
1. agentic-agent (internal/agentic/)
2. hpsm-agent (internal/hpsm/, tools/hpsm/)
3. mongodb-agent (internal/database/)
4. gateway-agent (gateway-server/)
5. pattern-agent (services/pattern/, internal/catalog/)
6. middleware-agent (internal/middleware/)

**Reasoning**:
- Mỗi agent có domain rõ ràng
- Coverage toàn bộ codebase quan trọng
- Không overlap responsibilities

**Action Items**:
- [x] Create backend-lead
- [x] Create agentic-agent
- [ ] Create mongodb-agent
- [ ] Create pattern-agent
- [ ] Create middleware-agent
- [ ] Review existing hpsm-agent, gateway-agent

**Review Date**: N/A (structural decision)

---
