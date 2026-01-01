# settings.json

Cấu hình team-shared cho dev-team.

## Vị Trí

```
.claude/settings.json
```

## Cấu Trúc

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)",
      "WebFetch(domain:github.com)"
    ],
    "deny": [
      "Read(.env)",
      "Bash(rm -rf:*)"
    ]
  }
}
```

## Permissions

### allow

Danh sách patterns cho phép mà không cần xác nhận:

```json
"allow": [
  "Bash(git:*)",        // Tất cả git commands
  "Bash(npm:*)",        // Tất cả npm commands
  "Read(**/*.go)",      // Đọc file Go
  "WebFetch(domain:X)"  // Fetch từ domain X
]
```

### deny

Patterns bị chặn:

```json
"deny": [
  "Read(.env)",         // Không đọc .env
  "Bash(rm -rf:*)"      // Không xóa recursive
]
```

## Ví Dụ Thực Tế

### Dự Án Go

```json
{
  "permissions": {
    "allow": [
      "Bash(go:*)",
      "Bash(git:*)",
      "Read(**/*.go)"
    ]
  }
}
```

### Dự Án Node.js

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(node:*)",
      "Bash(git:*)"
    ]
  }
}
```

## Lưu Ý

- File này được commit vào git
- Team members dùng chung settings này
- Dùng `settings.local.json` cho cài đặt cá nhân

## Xem Thêm

- [settings.local.json](./settings-local.md)
- [Cấu Trúc Thư Mục](./directory-structure.md)
