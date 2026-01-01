# Tổng Quan Team

Giới thiệu về hệ thống Team trong dev-team framework.

## Team Là Gì?

**Team** là một nhóm agents phối hợp với nhau để giải quyết vấn đề phức tạp. Mỗi team có:

- **Agents**: Các thành viên với vai trò khác nhau
- **Workflow**: Quy trình phối hợp giữa các agents
- **Team Memory**: Bộ nhớ chung cho cả team
- **Handoff Protocol**: Cách chuyển giao công việc

## Tại Sao Dùng Team?

### So sánh với Agent đơn lẻ

| Khía cạnh | Agent đơn | Team |
|-----------|-----------|------|
| Góc nhìn | Một | Nhiều |
| Độ phức tạp | Vấn đề đơn giản | Vấn đề phức tạp |
| Tốc độ | Nhanh | Chậm hơn nhưng toàn diện |
| Phù hợp | Nhiệm vụ rõ ràng | Cần phân tích sâu |

### Lợi ích của Team

1. **Đa góc nhìn**: Mỗi agent nhìn vấn đề từ góc độ khác
2. **Kiểm tra chéo**: Agents thách thức ý tưởng của nhau
3. **Toàn diện**: Không bỏ sót khía cạnh quan trọng
4. **Chuyên môn hóa**: Mỗi agent chuyên sâu một mảng

## Các Loại Team

### 1. Deep Thinking Team

Team tư duy sâu với 7 Titans (các nhà tư tưởng nổi tiếng):

| Titan | Vai trò | Phương pháp |
|-------|---------|-------------|
| 🔮 Socrates | Đặt câu hỏi | Maieutic questioning |
| 🧬 Aristotle | Logic | Syllogistic reasoning |
| ⚡ Musk | Phá vỡ | First principles |
| 🔬 Feynman | Đơn giản | Feynman technique |
| 🎭 Munger | Wisdom | Mental models |
| 📐 Polya | Giải quyết | Problem-solving heuristics |
| 🎨 Da Vinci | Sáng tạo | Creative synthesis |

**Khi nào dùng**: Vấn đề phức tạp cần phân tích đa chiều.

### 2. Session Teams

Teams mô phỏng hội thoại giữa các vai trò:

| Team | Vai trò | Mục đích |
|------|---------|----------|
| dev-user | Developer + End User | Tạo User Story |
| dev-architect | Developer + Architect | System Design |
| dev-qa | Developer + QA | Testing & Review |
| dev-security | Developer + Security | Security Review |
| pm-dev | PM + Developer | Requirements |
| dev-algo | Developer + Algorithm Expert | Problem Solving |

**Khi nào dùng**: Cần góc nhìn từ các vai trò khác nhau.

### 3. Specialized Teams

Teams chuyên môn cho domain cụ thể:

- **go-team**: Phát triển Go
- **mining-team**: Data mining
- **deep-research**: Nghiên cứu papers
- **project-team**: Quản lý dự án

## Cách Gọi Team

### Qua Slash Command

```
/microai:deep-thinking
```

### Ví dụ sử dụng

```
You: /microai:dev-architect-session

Maestro: 🏗️ Dev-Architect Session bắt đầu!

Tôi sẽ điều phối cuộc thảo luận giữa:
- 👨‍💻 Developer (bạn)
- 🏛️ Solution Architect

Vấn đề thiết kế bạn muốn thảo luận?

You: Cần thiết kế hệ thống message queue cho microservices

Architect: Để hiểu rõ hơn về yêu cầu:
1. Throughput mong đợi là bao nhiêu msg/s?
2. Có yêu cầu về ordering không?
3. At-least-once hay exactly-once delivery?

You: 10k msg/s, cần ordering trong partition, at-least-once ok

Architect: Với yêu cầu đó, tôi đề xuất:

Option 1: Apache Kafka
- Pros: High throughput, partition ordering
- Cons: Phức tạp vận hành

Option 2: Amazon SQS FIFO
- Pros: Managed, ordering
- Cons: Giới hạn throughput

Developer, bạn nghĩ option nào phù hợp hơn?
...
```

## Workflow của Team

### Deep Thinking Team: 5 Phases

```
Phase 1: UNDERSTAND
└── Socrates đặt câu hỏi làm rõ

Phase 2: DECONSTRUCT
└── Aristotle phân tích cấu trúc

Phase 3: CHALLENGE
└── Musk thách thức giả định

Phase 4: SOLVE
├── Feynman đơn giản hóa
├── Polya giải quyết
└── Munger áp dụng mental models

Phase 5: SYNTHESIZE
└── Da Vinci tổng hợp sáng tạo
```

### Session Teams: Turn-based

```
Turn 1: Role A đưa ra ý kiến
Turn 2: Role B phản hồi, thách thức
Turn 3: Role A điều chỉnh
Turn 4: Role B đề xuất cải tiến
...
Kết thúc: Đạt được đồng thuận
```

## Observer Commands

Trong phiên team, bạn có thể dùng các lệnh:

| Command | Mô tả |
|---------|-------|
| `*status` | Xem trạng thái hiện tại |
| `*focus {titan}` | Tập trung vào một titan cụ thể |
| `*pause` | Tạm dừng phân tích |
| `*continue` | Tiếp tục |
| `*summarize` | Tóm tắt đến thời điểm hiện tại |

## Best Practices

### 1. Chuẩn bị context đầy đủ

```
Dự án: E-commerce platform
Tech stack: Go, PostgreSQL, Redis
Vấn đề: Scaling order processing từ 1k → 100k orders/day
Ràng buộc: Budget hạn chế, team nhỏ
```

### 2. Để team hoàn thành workflow

Đừng interrupt giữa chừng. Mỗi phase đều quan trọng.

### 3. Sử dụng observer commands

Khi cần điều hướng hoặc làm rõ.

### 4. Review tổng hợp cuối cùng

Team sẽ tạo synthesis - đây là output quan trọng nhất.

## Bước Tiếp Theo

- [Team là gì? (chi tiết)](./what-is-team.md)
- [Deep Thinking Team](./deep-thinking-team.md)
- [Session Teams](./session-teams.md)
