# Phương pháp Polya

> George Polya's 4-Step Problem Solving Method

## Overview

Phương pháp Polya là framework kinh điển để giải quyết bài toán, bao gồm 4 bước:

1. **Understand the Problem** (Hiểu vấn đề)
2. **Devise a Plan** (Lập kế hoạch)
3. **Carry Out the Plan** (Thực hiện)
4. **Look Back** (Nhìn lại)

---

## Step 1: Understand the Problem

### Questions to Ask
- Đề bài cho gì? (What is given?)
- Cần tìm/chứng minh gì? (What is unknown/to prove?)
- Có điều kiện gì? (What are the conditions?)
- Có thể vẽ hình không? (Can you draw a figure?)
- Có thể đặt ký hiệu không? (Can you introduce notation?)

### Checklist
- [ ] Đọc kỹ đề bài
- [ ] Liệt kê dữ kiện
- [ ] Xác định mục tiêu
- [ ] Vẽ hình (nếu có thể)
- [ ] Đặt ẩn/ký hiệu

---

## Step 2: Devise a Plan

### Strategies
1. **Tìm pattern**: Thử các trường hợp nhỏ
2. **Chia nhỏ**: Chia bài toán thành các phần
3. **Làm ngược**: Bắt đầu từ kết quả
4. **Tương tự**: Nhớ bài tương tự đã giải
5. **Generalize/Specialize**: Tổng quát hóa hoặc đặc biệt hóa
6. **Auxiliary elements**: Thêm yếu tố phụ (đường phụ, ẩn phụ)

### Questions
- Đã gặp bài tương tự chưa?
- Có định lý nào áp dụng được?
- Có thể đặt ẩn phụ không?
- Có thể giải bài đơn giản hơn trước?

---

## Step 3: Carry Out the Plan

### Guidelines
- Thực hiện từng bước một cách cẩn thận
- Kiểm tra mỗi bước trước khi tiếp tục
- Nếu gặp khó khăn, quay lại Step 2
- Ghi chép rõ ràng

### Common Pitfalls
- Bỏ qua điều kiện
- Sai dấu
- Chia cho 0
- Căn bậc hai âm

---

## Step 4: Look Back

### Verification
- Kiểm tra kết quả có hợp lý không?
- Thử lại với giá trị cụ thể
- Có cách giải khác không?

### Learning
- Kỹ thuật nào hữu ích?
- Có thể tổng quát hóa không?
- Ghi nhớ cho bài sau

---

## Application Examples

### Example 1: Equation
```
Bài: Giải x² - 5x + 6 = 0

Step 1: Understand
- Given: Phương trình bậc 2
- Find: Giá trị x
- Condition: x ∈ ℝ

Step 2: Plan
- Sử dụng công thức nghiệm hoặc phân tích

Step 3: Execute
- x² - 5x + 6 = (x-2)(x-3) = 0
- x = 2 hoặc x = 3

Step 4: Look Back
- Thử: 2² - 5(2) + 6 = 0 ✓
- Thử: 3² - 5(3) + 6 = 0 ✓
```

### Example 2: Proof
```
Bài: Chứng minh √2 là số vô tỉ

Step 1: Understand
- Cần CM: √2 không thể viết dạng p/q

Step 2: Plan
- Phản chứng: Giả sử √2 = p/q (tối giản)

Step 3: Execute
- √2 = p/q → 2 = p²/q² → p² = 2q²
- → p² chẵn → p chẵn → p = 2k
- → 4k² = 2q² → q² = 2k² → q chẵn
- Mâu thuẫn với p/q tối giản

Step 4: Look Back
- Logic chặt chẽ ✓
- Không có lỗ hổng ✓
```

---

## Quick Reference Card

| Step | Action | Time |
|------|--------|------|
| 1. Understand | Read, draw, notation | 20% |
| 2. Plan | Strategy, recall similar | 30% |
| 3. Execute | Careful calculation | 40% |
| 4. Look Back | Verify, learn | 10% |
