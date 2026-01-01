# Cài đặt

Hướng dẫn cài đặt @microai.club/dev-team cho project của bạn.

---

## Yêu cầu

- **Node.js:** >= 18.0.0
- **npm** hoặc **npx**
- **Claude Code:** Đã cài đặt và đăng nhập

---

## Cài đặt nhanh

Mở terminal trong thư mục project và chạy:

```bash
npx @microai.club/dev-team@alpha install
```

---

## Tùy chọn cài đặt

### Interactive mode (mặc định)

```bash
npx @microai.club/dev-team@alpha install
```

Cho phép bạn:
- Chọn components muốn cài đặt
- Quyết định merge hoặc overwrite nếu đã có `.claude/`

### Non-interactive mode

```bash
npx @microai.club/dev-team@alpha install --no-interactive
```

Cài đặt tất cả components mà không hỏi.

### Force overwrite

```bash
npx @microai.club/dev-team@alpha install --force
```

Ghi đè tất cả files hiện có.

### Cài đặt vào đường dẫn khác

```bash
npx @microai.club/dev-team@alpha install --path /path/to/project
```

---

## Kết quả sau cài đặt

Sau khi cài đặt, thư mục `.claude/` sẽ được tạo:

```
your-project/
└── .claude/
    ├── CLAUDE.md       # Project context cho Claude
    ├── settings.json   # Team configuration (shared qua git)
    ├── agents/         # Agent templates
    │   └── README.md
    ├── skills/         # Skill templates
    │   └── README.md
    └── commands/       # Command templates
        └── README.md
```

---

## Cập nhật

Khi có version mới:

```bash
npx @microai.club/dev-team@alpha install
# Chọn "Merge" để giữ files hiện có và thêm files mới
```

---

## Gỡ cài đặt

Xóa thư mục `.claude/`:

```bash
rm -rf .claude/
```

---

## Tiếp theo

- [Bắt đầu nhanh](./quick-start.md) - Làm quen trong 5 phút
- [Cấu hình](./configuration.md) - Tùy chỉnh settings
