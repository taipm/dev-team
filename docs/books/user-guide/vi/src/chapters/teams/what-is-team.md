# Team Là Gì?

Giải thích chi tiết về khái niệm Team trong dev-team.

## Định Nghĩa

**Team** là một nhóm agents làm việc cùng nhau theo một workflow định sẵn để giải quyết vấn đề phức tạp.

## Cấu Trúc Team

```
team-name/
├── workflow.md          # Team workflow definition
├── agents/              # Team member agents
│   ├── lead.md
│   ├── specialist-1.md
│   └── specialist-2.md
└── team-memory/         # Shared memory
    ├── context.md
    ├── decisions.md
    └── handoffs.md
```

## So Sánh Team vs Agent

| Khía Cạnh | Agent Đơn | Team |
|-----------|-----------|------|
| Góc nhìn | Một | Nhiều |
| Complexity | Đơn giản | Phức tạp |
| Coordination | Không | Có workflow |
| Output | Trực tiếp | Tổng hợp |

## Các Loại Team

### 1. Sequential Teams
Agents làm việc tuần tự, chuyển giao kết quả.

### 2. Parallel Teams
Agents làm việc song song, tổng hợp kết quả.

### 3. Consultation Teams
Lead agent tham vấn specialists khi cần.

## Team Workflow

```yaml
phases:
  - name: understand
    agent: lead
    description: Thu thập thông tin

  - name: analyze
    agents: [specialist-1, specialist-2]
    parallel: true
    description: Phân tích từ nhiều góc độ

  - name: synthesize
    agent: lead
    description: Tổng hợp kết quả
```

## Khi Nào Dùng Team?

### Nên dùng Team khi:

- Vấn đề phức tạp, nhiều khía cạnh
- Cần nhiều góc nhìn chuyên môn
- Muốn phân tích toàn diện
- Output cần structured và comprehensive

### Dùng Agent đơn khi:

- Tác vụ rõ ràng, một domain
- Cần kết quả nhanh
- Không cần nhiều perspectives

## Xem Thêm

- [Teams vs Agents](./teams-vs-agents.md)
- [Cách Gọi Team](./invoking-teams.md)
