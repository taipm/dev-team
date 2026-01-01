# Kiểm Tra Cài Đặt

Hướng dẫn xác nhận dev-team đã được cài đặt đúng.

## Kiểm Tra Cấu Trúc Thư Mục

```bash
ls -la .claude/ .microai/
```

Kết quả mong đợi:

```
.claude/
├── CLAUDE.md
├── settings.json
├── agents/
├── skills/
└── commands/

.microai/
├── agents/
├── commands/
├── hooks/
└── kanban/
```

## Kiểm Tra Trong Claude Code

```bash
claude
```

Gõ:
```
/help
```

Nếu thấy danh sách commands có `/microai:*`, cài đặt thành công.

## Test Agent Đầu Tiên

```
/microai:deep-question
```

Agent sẽ chào và sẵn sàng nhận câu hỏi.

## Khắc Phục Sự Cố

### Không thấy commands

Kiểm tra `.claude/commands/` có files không:
```bash
ls -la .claude/commands/
```

### Permission denied

```bash
chmod +x .microai/hooks/**/*.sh
```

## Xem Thêm

- [Cấu Hình Ban Đầu](./configuration.md)
- [Làm Quen Trong 5 Phút](./quickstart.md)
