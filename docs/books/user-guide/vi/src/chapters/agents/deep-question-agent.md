# deep-question-agent - Đặt Câu Hỏi Sâu

Agent sử dụng 7 phương pháp tư duy để đặt câu hỏi.

## Tổng Quan

**deep-question-agent** giúp:
- Đặt câu hỏi sâu về vấn đề
- Phát hiện assumptions ẩn
- Mở rộng góc nhìn
- Tìm root causes

## Kích Hoạt

```
/microai:deep-question
```

## 7 Phương Pháp Tư Duy

### 1. 5 Why Analysis
Hỏi "Tại sao?" 5 lần để đến root cause.

### 2. First Principles
Phá vỡ vấn đề về các nguyên lý cơ bản.

### 3. Inversion
Nghĩ ngược: "Làm sao để thất bại?"

### 4. Second-Order Thinking
Hậu quả của hậu quả là gì?

### 5. Assumption Mining
Đâu là các giả định ẩn?

### 6. Analogical Reasoning
Vấn đề tương tự đã được giải quyết ở đâu?

### 7. Constraint Analysis
Ràng buộc thật sự là gì?

## Ví Dụ Session

```
You: /microai:deep-question

deep-question: 🔮 Deep Question Agent sẵn sàng!

Tôi sử dụng 7 phương pháp tư duy để đặt câu hỏi sâu.
Bạn muốn khám phá vấn đề gì?

You: Microservices của chúng tôi quá phức tạp

deep-question: 🔍 **5 Why Analysis**:

1. Tại sao microservices phức tạp?
   → Có quá nhiều services cần coordinate

2. Tại sao cần nhiều services như vậy?
   → Team split theo bounded contexts

3. Tại sao contexts được split như vậy?
   → (Đợi câu trả lời của bạn)

🎯 **First Principles**:
- Microservices cần giải quyết vấn đề gì cốt lõi?
- Đã thử monolith chưa? Kết quả thế nào?

🔄 **Inversion**:
- Điều gì sẽ làm hệ thống PHỨC TẠP HƠN?
- Ngược lại, bỏ điều đó có giảm complexity không?

Câu hỏi nào resonates với bạn nhất?
```

## Use Cases

| Tình huống | Phương pháp phù hợp |
|------------|---------------------|
| Bug lặp lại | 5 Why Analysis |
| Architecture decisions | First Principles |
| Risk assessment | Inversion |
| Long-term planning | Second-Order Thinking |

## Xem Thêm

- [Deep Thinking Team](../teams/deep-thinking-team.md)
- [Giải Quyết Vấn Đề Phức Tạp](../workflows/problem-solving.md)
