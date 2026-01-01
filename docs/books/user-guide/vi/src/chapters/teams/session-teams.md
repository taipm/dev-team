# Session Teams

Các teams dạng dialogue turn-based giữa hai roles.

## Tổng Quan

Session Teams là các teams với 2 agents đối thoại qua lại, mô phỏng collaboration giữa các roles khác nhau trong development process.

## Danh Sách Session Teams

| Team | Roles | Use Case |
|------|-------|----------|
| dev-user-session | Developer + End User | Tạo User Stories |
| dev-architect-session | Developer + Architect | System Design |
| dev-qa-session | Developer + QA | Testing & Review |
| dev-security-session | Developer + Security | Security Review |
| pm-dev-session | PM + Developer | Requirements |
| dev-algo-session | Developer + Algorithm Expert | Algorithm Design |

## Cách Hoạt Động

```
┌──────────┐     Dialogue      ┌──────────┐
│  Role A  │ ←───────────────→ │  Role B  │
└──────────┘                   └──────────┘
      │                              │
      └──────────┬───────────────────┘
                 │
                 ▼
           ┌──────────┐
           │  Output  │
           └──────────┘
```

## Output Types

| Team | Output |
|------|--------|
| dev-user-session | User Story + Acceptance Criteria |
| dev-architect-session | ADR, System Design |
| dev-qa-session | Test Plan, Bug Report |
| dev-security-session | Threat Model, Security Report |
| pm-dev-session | Tech Spec, Estimation |
| dev-algo-session | Algorithm Design, Complexity Analysis |

## Observer Commands

Giống như Deep Thinking Team:

```
*status     # Xem turn hiện tại
*switch     # Chuyển role nói
*summarize  # Tóm tắt dialogue
*conclude   # Kết thúc và output
```

## Ví Dụ Session

```
You: /microai:dev-user-session

Developer: 👨‍💻 Xin chào! Tôi là Developer.

End-User: 👤 Xin chào! Tôi là End-User đại diện.

Developer: Bạn cần giải quyết vấn đề gì?

End-User: Tôi muốn có thể track orders của mình...
...

[Sau 5-7 turns]

Output:
📋 User Story: As a customer, I want to track my orders...
✅ Acceptance Criteria:
- Given I have placed an order...
- When I click track...
- Then I see status...
```

## Xem Thêm

- [dev-user-session](./sessions/dev-user.md)
- [dev-architect-session](./sessions/dev-architect.md)
