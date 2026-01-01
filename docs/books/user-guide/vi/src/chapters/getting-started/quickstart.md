# Làm Quen Trong 5 Phút

Hướng dẫn nhanh để bắt đầu sử dụng dev-team framework.

## Bước 1: Cài Đặt (1 phút)

```bash
cd your-project
npx @microai.club/dev-team@alpha install
```

Chọn tất cả thành phần và chờ cài đặt hoàn tất.

## Bước 2: Mở Claude Code (30 giây)

```bash
claude
```

Claude Code sẽ tự động đọc cấu hình từ `.claude/` và `.microai/`.

## Bước 3: Thử Agent Đầu Tiên (1 phút)

Gõ trong Claude Code:

```
/microai:deep-question
```

Deep Question Agent sẽ được kích hoạt và giúp bạn đặt câu hỏi sâu về vấn đề.

### Ví dụ hội thoại

```
You: /microai:deep-question

Agent: Chào mừng bạn đến với Deep Question Agent!
Tôi sẽ giúp bạn đặt câu hỏi sâu theo 7 phương pháp tư duy.

Bạn muốn khám phá vấn đề gì hôm nay?

You: Tại sao microservices lại phức tạp?

Agent: Câu hỏi hay! Để hiểu sâu hơn, tôi sẽ áp dụng một số phương pháp:

🔍 **5 Why Analysis**:
1. Tại sao microservices phức tạp?
   → Vì có nhiều service cần phối hợp
2. Tại sao cần phối hợp nhiều?
   → Vì mỗi service có logic riêng
   ...

🎯 **First Principles**:
- Điều cốt lõi của distributed systems là gì?
- Network latency có thể tránh được không?
...
```

## Bước 4: Thử Team Đầu Tiên (2 phút)

Gõ trong Claude Code:

```
/microai:deep-thinking
```

Deep Thinking Team với 7 Titans sẽ được kích hoạt:

```
You: /microai:deep-thinking

Maestro: 🎭 Deep Thinking Team đã sẵn sàng!

Nhóm tư duy gồm 7 Titans:
- 🔮 Socrates - Đặt câu hỏi
- 🧬 Aristotle - Logic
- ⚡ Musk - First Principles
- 🔬 Feynman - Đơn giản hóa
- 🎭 Munger - Mental Models
- 📐 Polya - Problem Solving
- 🎨 Da Vinci - Sáng tạo

Vấn đề bạn muốn team phân tích?

You: Thiết kế hệ thống authentication cho ứng dụng mobile

Maestro: Bắt đầu phiên phân tích 5 pha!

📍 PHASE 1: UNDERSTAND
Socrates đang đặt câu hỏi làm rõ...
```

## Bước 5: Khám Phá Thêm (30 giây)

### Commands có sẵn

```bash
# Liệt kê tất cả commands
dev-team list

# Hoặc trong Claude Code
/help
```

### Session Teams phổ biến

| Command | Mô tả |
|---------|-------|
| `/microai:dev-user-session` | Developer + End User tạo User Story |
| `/microai:dev-architect-session` | Developer + Architect thiết kế hệ thống |
| `/microai:dev-qa-session` | Developer + QA review và test |

## Tổng Kết

Trong 5 phút, bạn đã:

1. ✅ Cài đặt dev-team framework
2. ✅ Kích hoạt Deep Question Agent
3. ✅ Sử dụng Deep Thinking Team
4. ✅ Biết các commands có sẵn

## Bước Tiếp Theo

- **Tìm hiểu Agents**: [Tổng quan Agent](../agents/overview.md)
- **Khám phá Teams**: [Tổng quan Team](../teams/overview.md)
- **Workflows thực tế**: [Use Cases](../workflows/use-cases.md)

## Gợi Ý Sử Dụng

### Khi nào dùng Agent?

- Nhiệm vụ đơn giản, rõ ràng
- Cần chuyên gia trong một lĩnh vực
- Không cần nhiều góc nhìn

### Khi nào dùng Team?

- Vấn đề phức tạp, nhiều khía cạnh
- Cần phân tích sâu từ nhiều góc độ
- Muốn có sự phối hợp giữa các vai trò

---

> **Mẹo**: Thử `/microai:father` để tạo agent tùy chỉnh cho domain của bạn!
