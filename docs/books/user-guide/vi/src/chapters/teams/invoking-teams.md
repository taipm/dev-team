# Cách Gọi Team

Hướng dẫn kích hoạt và làm việc với teams.

## Slash Command

```
/microai:team-name
```

Ví dụ:
```
/microai:deep-thinking
/microai:dev-architect-session
/microai:dev-qa-session
```

## Team Activation Process

Khi gọi team:

1. **Load workflow.md** - Định nghĩa quy trình
2. **Load agents** - Tất cả team members
3. **Load team-memory** - Context chung
4. **Start with lead** - Lead agent điều phối

## Observer Commands

Khi đang trong team session, bạn có thể dùng:

| Command | Mô tả |
|---------|-------|
| `*status` | Xem phase hiện tại |
| `*focus {agent}` | Yêu cầu agent cụ thể |
| `*summarize` | Tóm tắt tiến trình |
| `*pause` | Tạm dừng |
| `*continue` | Tiếp tục |

## Ví Dụ Session

```
You: /microai:deep-thinking

Maestro: 🎭 Deep Thinking Team đã sẵn sàng!

Team gồm 7 Titans:
- 🔮 Socrates - The Questioner
- 🧬 Aristotle - The Logician
- ⚡ Musk - The Disruptor
- 🔬 Feynman - The Explainer
- 🎭 Munger - The Sage
- 📐 Polya - The Solver
- 🎨 Da Vinci - The Connector

Bạn muốn team phân tích vấn đề gì?

You: Thiết kế hệ thống notification cho 1M users

Maestro: 📍 PHASE 1: UNDERSTAND
Chuyển cho Socrates...

Socrates: 🔮 Trước khi thiết kế, tôi cần hiểu:
1. Loại notifications nào? (Push, email, SMS, in-app?)
2. Latency requirements? (Real-time hay delay OK?)
3. Users online cùng lúc tối đa?

You: *status

Maestro: 📊 Current Status:
- Phase: UNDERSTAND (1/5)
- Active: Socrates
- Progress: 20%
- Pending: Aristotle, Musk, Feynman...
```

## Tips

### Cung cấp context đầy đủ

```
Tôi đang làm dự án e-commerce.
Tech stack: Go, PostgreSQL, Redis.
Cần thiết kế payment system.
Yêu cầu: PCI-DSS compliance, 99.99% uptime.
```

### Tham gia tích cực

Teams hoạt động tốt nhất khi bạn:
- Trả lời câu hỏi của agents
- Clarify khi được hỏi
- Provide domain knowledge

### Dùng Observer Commands

- `*status` để biết đang ở đâu
- `*focus Feynman` nếu cần giải thích đơn giản

## Xem Thêm

- [Deep Thinking Team](./deep-thinking-team.md)
- [Session Teams](./session-teams.md)
