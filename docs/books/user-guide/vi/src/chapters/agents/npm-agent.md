# npm-agent - Quản Lý npm Packages

Agent chuyên gia về npm ecosystem.

## Tổng Quan

**npm-agent** giúp:
- Quản lý dependencies
- Publish packages
- Tạo npm installers
- Xử lý npm registry issues

## Kích Hoạt

```
/microai:npm
```

## Capabilities

### 1. Dependency Management

```
Kiểm tra và update dependencies lỗi thời
```

```
Tìm và fix vulnerabilities trong packages
```

### 2. Package Publishing

```
Publish package này lên npm registry
```

### 3. Installer Creation

```
Tạo npm installer cho dev-team
```

### 4. Registry Troubleshooting

```
Fix lỗi 403 khi publish
```

## Ví Dụ Session

```
You: /microai:npm

npm-agent: 📦 NPM Agent sẵn sàng!
Tôi là chuyên gia npm. Bạn cần giúp gì?

You: Publish package với scope @myorg

npm-agent: Để publish package với scope, cần:

1. **Login với scope**:
   npm login --scope=@myorg

2. **Kiểm tra package.json**:
   {
     "name": "@myorg/package-name",
     "publishConfig": {
       "access": "public"
     }
   }

3. **Publish**:
   npm publish --access public

Tôi kiểm tra package.json của bạn nhé?

You: Có

npm-agent: ✅ package.json đã có scope
⚠️ Thiếu publishConfig.access
Tôi sẽ thêm vào...
✅ Đã update package.json
Chạy `npm publish --access public` để publish
```

## Common Tasks

| Task | Command |
|------|---------|
| Check outdated | `npm outdated` |
| Update all | `npm update` |
| Audit security | `npm audit` |
| Fix vulnerabilities | `npm audit fix` |

## Xem Thêm

- [go-dev-portable](./go-dev-agent.md)
- [Agents Có Sẵn](./built-in-agents.md)
