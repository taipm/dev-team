# Cài Đặt Qua npm

Hướng dẫn chi tiết cài đặt dev-team qua npm.

## Cài Đặt Nhanh

```bash
cd your-project
npx @microai.club/dev-team@alpha install
```

## Các Tùy Chọn Cài Đặt

### Interactive Mode (Mặc định)

```bash
npx @microai.club/dev-team@alpha install
```

Wizard sẽ hỏi:
- Components muốn cài
- Xử lý thư mục tồn tại

### Non-interactive Mode

```bash
npx @microai.club/dev-team@alpha install --no-interactive
```

Cài đặt tất cả components mặc định.

### Force Overwrite

```bash
npx @microai.club/dev-team@alpha install --force
```

Ghi đè tất cả files tồn tại.

### Custom Path

```bash
npx @microai.club/dev-team@alpha install --path /path/to/project
```

## Global Installation

Nếu muốn dùng như CLI tool:

```bash
npm install -g @microai.club/dev-team@alpha
dev-team install
```

## Xem Thêm

- [Kiểm Tra Cài Đặt](./verification.md)
- [Cấu Hình Ban Đầu](./configuration.md)
