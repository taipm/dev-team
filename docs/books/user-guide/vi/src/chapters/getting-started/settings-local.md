# settings.local.json

Cấu hình cá nhân cho dev-team.

## Vị Trí

```
.claude/settings.local.json
.microai/settings.local.json
```

## Mục Đích

- Settings riêng của mỗi developer
- Không commit vào git
- Override settings từ `settings.json`

## Cấu Trúc

```json
{
  "permissions": {
    "allow": [
      "Bash(docker:*)"
    ]
  }
}
```

## Ví Dụ

### Cho phép thêm commands

```json
{
  "permissions": {
    "allow": [
      "Bash(docker:*)",
      "Bash(kubectl:*)",
      "Bash(make:*)"
    ]
  }
}
```

### Debug mode

```json
{
  "debug": true,
  "logLevel": "verbose"
}
```

## Tạo File

```bash
echo '{
  "permissions": {
    "allow": []
  }
}' > .claude/settings.local.json
```

## Gitignore

Đảm bảo file được ignore:

```bash
# Trong .gitignore
.claude/settings.local.json
.microai/settings.local.json
```

## Xem Thêm

- [settings.json](./settings-json.md)
- [Cấu Hình Ban Đầu](./configuration.md)
