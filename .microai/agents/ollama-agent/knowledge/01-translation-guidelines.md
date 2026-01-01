# Translation Guidelines - Quy Tắc Dịch EN→VI

> Hướng dẫn chi tiết cho việc dịch tài liệu kỹ thuật từ tiếng Anh sang tiếng Việt.

---

## 1. Nguyên Tắc Cơ Bản

### 1.1 Ưu Tiên Độ Rõ Ràng

```
ĐÚNG:  "Để cài đặt package, chạy lệnh sau:"
SAI:   "Để cài đặt gói phần mềm, thực thi câu lệnh phía dưới:"
       (quá dài dòng, không tự nhiên)
```

### 1.2 Giữ Nguyên Khi Cần Thiết

| Loại | Ví dụ | Lý do |
|------|-------|-------|
| Tech terms phổ biến | API, HTTP, JSON, CLI | Ai cũng hiểu |
| Commands | `npm install` | Phải chính xác |
| Code | `const x = 1` | Không bao giờ dịch |
| Paths | `/usr/bin` | System paths |
| URLs | `https://...` | Links |

### 1.3 Dịch Tự Nhiên

```
ĐÚNG:  "Bạn cần cài đặt Node.js trước khi tiếp tục."
SAI:   "Bạn cần thiết lập Node.js trước khi bạn tiếp tục."
       (lặp "bạn", không tự nhiên)
```

---

## 2. Quy Tắc Cụ Thể

### 2.1 Headings

```markdown
# Getting Started
→ # Bắt Đầu

## Installation
→ ## Cài Đặt

### Prerequisites
→ ### Yêu Cầu
```

**Lưu ý:** Giữ nguyên level heading (#, ##, ###)

### 2.2 Code Blocks

```markdown
ORIGINAL:
To install, run:
```bash
npm install mypackage
```

TRANSLATED:
Để cài đặt, chạy:
```bash
npm install mypackage   ← KHÔNG DỊCH
```
```

### 2.3 Inline Code

```markdown
ORIGINAL:
Use the `--verbose` flag for detailed output.

TRANSLATED:
Sử dụng flag `--verbose` để xem output chi tiết.
         ↑ giữ nguyên
```

### 2.4 Links

```markdown
ORIGINAL:
See the [documentation](https://docs.example.com) for details.

TRANSLATED:
Xem [tài liệu](https://docs.example.com) để biết thêm chi tiết.
     ↑ dịch   ↑ giữ nguyên URL
```

### 2.5 Tables

```markdown
ORIGINAL:
| Command | Description |
|---------|-------------|
| `start` | Start server |
| `stop`  | Stop server  |

TRANSLATED:
| Lệnh    | Mô tả        |
|---------|--------------|
| `start` | Khởi động server |
| `stop`  | Dừng server      |
  ↑ giữ nguyên code
```

### 2.6 Lists

```markdown
ORIGINAL:
- Install dependencies
- Configure settings
- Run the application

TRANSLATED:
- Cài đặt dependencies
- Cấu hình settings
- Chạy ứng dụng
```

---

## 3. Terminology Rules

### 3.1 Luôn Giữ Nguyên

| Term | Lý do |
|------|-------|
| API | Chuẩn quốc tế |
| HTTP/HTTPS | Protocol names |
| JSON/XML/YAML | Data formats |
| CLI | Command Line Interface |
| GUI | Graphical UI |
| URL/URI | Web standards |
| SDK | Software Dev Kit |
| IDE | Dev environment |
| Git | Version control |
| Docker | Container platform |
| npm/yarn/pnpm | Package managers |

### 3.2 Dịch Với Context

| English | Formal | Casual Dev |
|---------|--------|------------|
| repository | kho lưu trữ | repo |
| commit | cam kết | commit |
| branch | nhánh | branch |
| merge | hợp nhất | merge |
| deploy | triển khai | deploy |
| debug | gỡ lỗi | debug |

### 3.3 Luôn Dịch

| English | Vietnamese |
|---------|------------|
| Introduction | Giới thiệu |
| Getting Started | Bắt đầu |
| Installation | Cài đặt |
| Configuration | Cấu hình |
| Usage | Sử dụng |
| Examples | Ví dụ |
| Prerequisites | Yêu cầu |
| Features | Tính năng |
| Contributing | Đóng góp |
| License | Giấy phép |
| Changelog | Lịch sử thay đổi |
| FAQ | Câu hỏi thường gặp |

---

## 4. Style Guide

### 4.1 Tone

```
✓ Thân thiện nhưng chuyên nghiệp
✓ Dùng "bạn" thay vì "người dùng"
✓ Câu ngắn gọn, rõ ràng
✗ Không quá formal: "quý vị", "xin mời"
✗ Không quá casual: "mày", "tao"
```

### 4.2 Sentence Structure

```
ORIGINAL:
"Before you can use this feature, you need to enable it in settings."

DỊCH TỐT:
"Trước khi sử dụng tính năng này, bạn cần bật nó trong settings."

DỊCH KÉM:
"Trước khi bạn có thể sử dụng tính năng này, bạn cần phải bật nó lên trong phần cài đặt."
(quá dài, lặp lại)
```

### 4.3 Technical Accuracy

```
ORIGINAL:
"The function returns a Promise that resolves to a user object."

DỊCH ĐÚNG:
"Function trả về một Promise resolve thành user object."

DỊCH SAI:
"Hàm trả về một lời hứa giải quyết thành đối tượng người dùng."
(dịch technical terms không cần thiết)
```

---

## 5. Common Patterns

### 5.1 Instructions

```
ORIGINAL:
1. Open the terminal
2. Navigate to the project directory
3. Run `npm install`

TRANSLATED:
1. Mở terminal
2. Di chuyển đến thư mục project
3. Chạy `npm install`
```

### 5.2 Notes/Warnings

```markdown
ORIGINAL:
> **Note:** This feature is experimental.

TRANSLATED:
> **Lưu ý:** Tính năng này đang thử nghiệm.

ORIGINAL:
> **Warning:** This will delete all data.

TRANSLATED:
> **Cảnh báo:** Thao tác này sẽ xóa toàn bộ dữ liệu.
```

### 5.3 Examples

```markdown
ORIGINAL:
For example, to create a new file:
```bash
touch newfile.txt
```

TRANSLATED:
Ví dụ, để tạo file mới:
```bash
touch newfile.txt   ← giữ nguyên
```
```

---

## 6. Quality Checklist

```
□ Markdown formatting giữ nguyên
□ Code blocks không bị sửa
□ Links hoạt động
□ Technical terms nhất quán
□ Đọc tự nhiên bằng tiếng Việt
□ Không có lỗi chính tả
□ Headings đúng level
□ Tables đúng format
```

---

## 7. Edge Cases

### 7.1 Mixed Language Sentences

```
ORIGINAL:
"Use the `map()` function to iterate over the array."

DỊCH:
"Sử dụng function `map()` để iterate qua array."
      ↑ dịch    ↑ giữ    ↑ dịch  ↑ giữ
```

### 7.2 Brand Names

```
Giữ nguyên:
- GitHub, GitLab
- Docker, Kubernetes
- React, Vue, Angular
- Node.js, Python, Go
```

### 7.3 Acronyms

```
First mention: giải thích
"API (Application Programming Interface) là..."

Sau đó: dùng acronym
"API cho phép..."
```

---

## 8. Review Criteria

| Aspect | Weight | Check |
|--------|--------|-------|
| Accuracy | 30% | Meaning preserved? |
| Fluency | 25% | Natural Vietnamese? |
| Terminology | 20% | Consistent with glossary? |
| Formatting | 15% | Markdown intact? |
| Completeness | 10% | Nothing missing? |
