# Observer Commands

Các commands để điều khiển Deep Thinking Team.

## Status Commands

| Command | Mô tả | Ví dụ |
|---------|-------|-------|
| `*status` | Xem trạng thái hiện tại | Phase, active Titan, progress |
| `*history` | Xem lịch sử phases | Đã qua những phase nào |
| `*output` | Xem output hiện tại | Kết quả tạm thời |

## Focus Commands

| Command | Mô tả | Ví dụ |
|---------|-------|-------|
| `*focus Socrates` | Yêu cầu Socrates trả lời | Cần câu hỏi sâu |
| `*focus Musk` | Yêu cầu Musk trả lời | Cần first principles |
| `*focus Feynman` | Yêu cầu Feynman trả lời | Cần giải thích đơn giản |

## Flow Commands

| Command | Mô tả | Ví dụ |
|---------|-------|-------|
| `*next` | Chuyển phase tiếp | Đã đủ thông tin |
| `*back` | Quay lại phase trước | Cần thêm analysis |
| `*skip` | Bỏ qua phase | Phase không cần thiết |
| `*extend` | Kéo dài phase | Cần thêm thời gian |

## Control Commands

| Command | Mô tả | Ví dụ |
|---------|-------|-------|
| `*pause` | Tạm dừng | Cần suy nghĩ |
| `*continue` | Tiếp tục | Sẵn sàng |
| `*fast` | Chế độ nhanh | Cần kết quả gấp |
| `*thorough` | Chế độ kỹ | Vấn đề quan trọng |

## Summary Commands

| Command | Mô tả | Ví dụ |
|---------|-------|-------|
| `*summarize` | Tóm tắt tiến trình | Overview |
| `*insights` | Xem insights chính | Key findings |
| `*actions` | Xem action items | Next steps |

## Ví Dụ Sử Dụng

### Kiểm tra trạng thái

```
You: *status

Maestro: 📊 Current Status
━━━━━━━━━━━━━━━━━━━━━━━━━
Phase: ANALYZE (2/5)
Active Titan: Aristotle
Progress: 40%

Completed:
✅ UNDERSTAND - Key questions answered

Pending:
⏳ EXPLORE
⏳ SYNTHESIZE
⏳ VALIDATE
```

### Focus vào Titan cụ thể

```
You: *focus Feynman

Feynman: 🔬 Để tôi giải thích đơn giản...

Hãy tưởng tượng hệ thống như một nhà hàng:
- API Gateway = Người tiếp tân
- Services = Các đầu bếp chuyên biệt
- Database = Kho nguyên liệu
- Cache = Quầy chuẩn bị sẵn

Khi khách order (request):
1. Tiếp tân ghi nhận (Gateway)
2. Chuyển cho đầu bếp phù hợp (Service)
3. Đầu bếp lấy nguyên liệu (Database)
4. Hoặc dùng đồ chuẩn bị sẵn (Cache)

Có rõ hơn không?
```

### Chuyển phase

```
You: *next

Maestro: ⏭️ Moving to EXPLORE phase

Musk: ⚡ Tôi sẽ challenge mọi thứ!

Quên những gì đang có đi.
Nếu thiết kế từ đầu với công nghệ hiện tại:
- Tại sao cần traditional database?
- Tại sao không edge computing?
- 10x scale thì design khác thế nào?
```

## Tips

1. **Dùng `*status` thường xuyên** - Biết mình đang ở đâu
2. **`*focus` khi cần expertise** - Gọi đúng Titan cho câu hỏi
3. **`*fast` cho vấn đề đơn giản** - Tiết kiệm thời gian
4. **`*thorough` cho quyết định quan trọng** - Đảm bảo chất lượng

## Xem Thêm

- [7 Titans](./titans.md)
- [5-Phase Protocol](./protocol.md)
