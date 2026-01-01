# Dev-Team Documentation Books

> Bộ tài liệu toàn diện cho @microai.club/dev-team
> Comprehensive documentation for @microai.club/dev-team

## Tổng quan / Overview

Bộ tài liệu này bao gồm 3 cuốn sách, mỗi cuốn có 2 phiên bản ngôn ngữ:

This documentation set includes 3 books, each with 2 language versions:

| Sách / Book | Đối tượng / Audience | Mô tả / Description |
|-------------|----------------------|---------------------|
| **User Guide** | Người dùng / Users | Hướng dẫn sử dụng agents, teams, commands |
| **Developer Guide** | Nhà phát triển / Developers | Hướng dẫn tạo mới và mở rộng |
| **Reference Manual** | Tất cả / Everyone | Tài liệu tham khảo kỹ thuật |

## Cấu trúc / Structure

```
docs/books/
├── README.md                    # File này / This file
├── build.sh                     # Build script
├── theme/                       # Custom theme
│   ├── custom.css
│   └── custom.js
│
├── user-guide/                  # Sách 1: Hướng dẫn sử dụng
│   ├── vi/                      # Tiếng Việt
│   │   ├── book.toml
│   │   └── src/
│   │       ├── SUMMARY.md
│   │       └── chapters/
│   └── en/                      # English
│       ├── book.toml
│       └── src/
│
├── developer-guide/             # Sách 2: Hướng dẫn phát triển
│   ├── vi/
│   └── en/
│
└── reference/                   # Sách 3: Tài liệu tham khảo
    ├── vi/
    └── en/
```

## Yêu cầu / Requirements

### Cài đặt mdBook / Install mdBook

```bash
# macOS (Homebrew)
brew install mdbook

# Cargo (Rust)
cargo install mdbook

# Pre-built binaries
# Download from: https://github.com/rust-lang/mdBook/releases
```

## Build

### Build tất cả sách / Build all books

```bash
cd docs/books
./build.sh
```

### Build từng sách / Build individual book

```bash
# User Guide - Vietnamese
cd docs/books/user-guide/vi
mdbook build

# User Guide - English
cd docs/books/user-guide/en
mdbook build

# Tương tự cho các sách khác / Similarly for other books
```

### Serve locally (development)

```bash
cd docs/books/user-guide/vi
mdbook serve --open
```

## Output

Sau khi build, output sẽ nằm trong:

After building, output will be in:

```
docs/books/build/
├── user-guide/
│   ├── vi/          # Vietnamese User Guide
│   └── en/          # English User Guide
├── developer-guide/
│   ├── vi/
│   └── en/
└── reference/
    ├── vi/
    └── en/
```

## Đóng góp / Contributing

### Quy ước đặt tên / Naming Conventions

| Loại / Type | Convention | Ví dụ / Example |
|-------------|------------|-----------------|
| Thư mục / Directory | `kebab-case` | `getting-started/` |
| File chapter | `kebab-case.md` | `creating-agents.md` |
| Images | `kebab-case.png/svg` | `architecture-diagram.svg` |
| Language codes | ISO 639-1 | `vi/`, `en/` |

### Quy trình viết / Writing Process

1. **Vietnamese first**: Viết tiếng Việt trước
2. **English translation**: Dịch sang tiếng Anh
3. **Cross-references**: Đảm bảo links hoạt động
4. **Build test**: Chạy `mdbook build` để kiểm tra

### Style Guide

- Sử dụng heading hierarchy đúng (# → ## → ###)
- Mỗi file chapter nên có một chủ đề rõ ràng
- Code examples phải production-ready
- Sử dụng callouts cho tips/warnings:

```markdown
> **Lưu ý / Note**: Nội dung quan trọng

> **Cảnh báo / Warning**: Nội dung cảnh báo
```

## Thông tin thêm / Additional Info

- **Repository**: https://github.com/taipm/dev-team
- **Package**: @microai.club/dev-team
- **License**: MIT

---

*Được tạo bởi / Created by MicroAI Team*
