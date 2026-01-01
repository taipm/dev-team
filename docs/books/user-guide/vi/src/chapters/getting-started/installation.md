# Cài Đặt

Hướng dẫn cài đặt **@microai.club/dev-team** vào dự án của bạn.

## Yêu Cầu Hệ Thống

Trước khi cài đặt, đảm bảo bạn đã có:

| Yêu cầu | Phiên bản | Ghi chú |
|---------|-----------|---------|
| Node.js | >= 18.0.0 | [Download](https://nodejs.org/) |
| npm | >= 8.0.0 | Đi kèm với Node.js |
| Claude Code | Mới nhất | [Hướng dẫn cài đặt](https://claude.ai/code) |

### Kiểm tra phiên bản hiện tại

```bash
# Kiểm tra Node.js
node --version  # Kết quả: v18.x.x hoặc cao hơn

# Kiểm tra npm
npm --version   # Kết quả: 8.x.x hoặc cao hơn
```

## Cài Đặt Nhanh

### Sử dụng npx (Khuyến nghị)

```bash
# Di chuyển đến thư mục dự án
cd your-project

# Chạy installer
npx @microai.club/dev-team@alpha install
```

### Cài đặt toàn cục

```bash
# Cài đặt package
npm install -g @microai.club/dev-team@alpha

# Chạy installer
dev-team install
```

## Quá Trình Cài Đặt

Khi chạy `dev-team install`, bạn sẽ thấy:

### 1. Chọn thành phần cài đặt

```
? Chọn các thành phần muốn cài đặt:
  ◉ CLAUDE.md (project context)
  ◉ settings.json (team configuration)
  ◉ agents/ (agent templates)
  ◉ skills/ (skill templates)
  ◉ commands/ (slash commands)
  ◉ MicroAI Framework (.microai/)
  ◉ Hooks (automation)
```

### 2. Xử lý thư mục tồn tại

Nếu dự án đã có `.claude/` hoặc `.microai/`:

```
? Thư mục .claude/ đã tồn tại. Bạn muốn:
  ❯ Merge (giữ file cũ, thêm file mới)
    Overwrite (ghi đè tất cả)
    Cancel (hủy bỏ)
```

> **Khuyến nghị**: Chọn **Merge** để giữ nguyên cấu hình hiện có.

### 3. Hoàn thành

```
✔ Đã cài đặt thành công!

Cấu trúc đã tạo:
├── .claude/
│   ├── CLAUDE.md
│   ├── settings.json
│   ├── agents/
│   ├── skills/
│   └── commands/
└── .microai/
    ├── agents/
    ├── commands/
    ├── hooks/
    └── kanban/
```

## Tùy Chọn Cài Đặt

### Non-interactive mode

```bash
# Cài đặt tất cả mà không hỏi
dev-team install --no-interactive
```

### Force overwrite

```bash
# Ghi đè tất cả file hiện có
dev-team install --force
```

### Chỉ định đường dẫn

```bash
# Cài đặt vào thư mục khác
dev-team install --path /path/to/project
```

### Kết hợp tùy chọn

```bash
# Force install vào thư mục cụ thể
dev-team install --path /path/to/project --force --no-interactive
```

## Sau Khi Cài Đặt

### 1. Cấu hình settings.local.json

Tạo file `.claude/settings.local.json` cho cấu hình cá nhân:

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)"
    ]
  }
}
```

> **Lưu ý**: File này không nên commit vào git.

### 2. Thêm vào .gitignore

Installer tự động thêm vào `.gitignore`:

```
# Claude Code local settings
.claude/settings.local.json

# MicroAI local settings
.microai/settings.local.json
.microai/logs/
```

### 3. Kiểm tra cài đặt

```bash
# Liệt kê các thành phần đã cài
dev-team list
```

## Gỡ Cài Đặt

Để gỡ dev-team khỏi dự án:

```bash
# Xóa thư mục
rm -rf .claude/ .microai/
```

> **Cảnh báo**: Thao tác này sẽ xóa tất cả agents, skills, và cấu hình tùy chỉnh.

## Troubleshooting

### Lỗi "command not found"

```bash
# Thử với npx
npx @microai.club/dev-team@alpha install

# Hoặc kiểm tra PATH
echo $PATH
```

### Lỗi permission denied

```bash
# Thêm quyền thực thi cho hooks
chmod +x .microai/hooks/**/*.sh
```

### Lỗi npm registry

```bash
# Kiểm tra registry
npm config get registry

# Nếu cần, đặt lại về default
npm config set registry https://registry.npmjs.org/
```

## Bước Tiếp Theo

- [Kiểm tra cài đặt](./verification.md)
- [Cấu hình ban đầu](./configuration.md)
- [Quickstart 5 phút](./quickstart.md)
