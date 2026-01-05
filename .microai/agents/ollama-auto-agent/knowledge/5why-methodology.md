# 5-Why Methodology

## Overview

5-Why là kỹ thuật phân tích nguyên nhân gốc rễ (Root Cause Analysis) được phát triển bởi Sakichi Toyoda và sử dụng rộng rãi trong Toyota Production System.

## Nguyên tắc cốt lõi

1. **Bắt đầu từ vấn đề cụ thể**: Định nghĩa rõ ràng vấn đề cần phân tích
2. **Hỏi "Tại sao?" liên tục**: Mỗi câu trả lời dẫn đến câu hỏi "Tại sao?" tiếp theo
3. **Dừng lại ở nguyên nhân gốc rễ**: Khi câu trả lời là nguyên nhân có thể hành động được
4. **Không dừng quá sớm**: 5 là con số gợi ý, có thể ít hơn hoặc nhiều hơn

## Tiêu chí nhận biết Root Cause

Root cause là nguyên nhân khi:

- [ ] Không thể hỏi "Tại sao?" tiếp được nữa một cách logic
- [ ] Đây là yếu tố cơ bản nhất trong chuỗi nguyên nhân
- [ ] Sửa nguyên nhân này sẽ ngăn vấn đề tái diễn
- [ ] Nguyên nhân nằm trong tầm kiểm soát/thay đổi được
- [ ] Hành động sửa chữa có thể thực hiện được

## Ví dụ

```
Problem: Website bị chậm

Why #1: Tại sao website bị chậm?
→ Vì database query mất nhiều thời gian

Why #2: Tại sao database query mất nhiều thời gian?
→ Vì không có index trên cột được query thường xuyên

Why #3: Tại sao không có index?
→ Vì không ai review performance khi thêm feature mới

Why #4: Tại sao không review performance?
→ Vì không có checklist performance trong quy trình code review

ROOT CAUSE: Thiếu checklist performance trong quy trình code review
ACTION: Thêm performance checklist vào code review template
```

## Lưu ý khi phân tích

1. **Tránh blame game**: Focus vào hệ thống, không phải cá nhân
2. **Một nhánh một lúc**: Nếu có nhiều nguyên nhân, phân tích từng nhánh riêng
3. **Evidence-based**: Dựa trên dữ liệu thực tế, không phỏng đoán
4. **Actionable**: Root cause phải dẫn đến hành động cụ thể
