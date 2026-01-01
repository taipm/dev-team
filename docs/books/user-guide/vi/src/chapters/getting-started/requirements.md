# Yêu Cầu Hệ Thống

Các yêu cầu cần thiết trước khi cài đặt dev-team framework.

## Yêu Cầu Bắt Buộc

### Node.js

| Phiên bản | Trạng thái |
|-----------|------------|
| >= 18.0.0 | ✅ Supported |
| 16.x | ⚠️ Không khuyến nghị |
| < 16.0 | ❌ Không hỗ trợ |

**Kiểm tra phiên bản:**

```bash
node --version
# v18.17.0 hoặc cao hơn
```

**Cài đặt Node.js:**

```bash
# macOS (Homebrew)
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Windows (Chocolatey)
choco install nodejs

# Hoặc download từ https://nodejs.org/
```

### npm

npm đi kèm với Node.js. Kiểm tra:

```bash
npm --version
# 8.x.x hoặc cao hơn
```

### Claude Code

Claude Code là CLI chính thức của Anthropic cho Claude.

**Kiểm tra:**

```bash
claude --version
```

**Cài đặt:**

Xem hướng dẫn tại [claude.ai/code](https://claude.ai/code)

## Yêu Cầu Tùy Chọn

### Git

Cần thiết cho version control và một số tính năng.

```bash
git --version
# git version 2.x.x
```

### pnpm (thay thế npm)

Nếu bạn prefer pnpm:

```bash
# Cài đặt
npm install -g pnpm

# Kiểm tra
pnpm --version
```

## Hệ Điều Hành

| OS | Trạng thái | Ghi chú |
|----|------------|---------|
| macOS 12+ | ✅ Full support | Khuyến nghị |
| Ubuntu 20.04+ | ✅ Full support | |
| Windows 10/11 | ✅ Full support | WSL2 khuyến nghị |
| Other Linux | ⚠️ Partial | Cần test |

## Kiểm Tra Tổng Thể

Chạy script sau để kiểm tra tất cả requirements:

```bash
#!/bin/bash
echo "Checking requirements..."

# Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -ge 18 ]; then
        echo "✅ Node.js: $(node --version)"
    else
        echo "⚠️ Node.js: $(node --version) (cần >= 18.0.0)"
    fi
else
    echo "❌ Node.js: Chưa cài đặt"
fi

# npm
if command -v npm &> /dev/null; then
    echo "✅ npm: $(npm --version)"
else
    echo "❌ npm: Chưa cài đặt"
fi

# Claude Code
if command -v claude &> /dev/null; then
    echo "✅ Claude Code: Đã cài đặt"
else
    echo "❌ Claude Code: Chưa cài đặt"
fi

# Git
if command -v git &> /dev/null; then
    echo "✅ Git: $(git --version)"
else
    echo "⚠️ Git: Chưa cài đặt (optional)"
fi

echo "Done!"
```

## Troubleshooting

### Node.js version quá cũ

```bash
# Sử dụng nvm để quản lý versions
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Cài đặt Node 18
nvm install 18
nvm use 18
```

### Permission errors khi cài npm packages

```bash
# Tạo directory cho global packages
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

# Thêm vào PATH (~/.bashrc hoặc ~/.zshrc)
export PATH=~/.npm-global/bin:$PATH
```

### Claude Code không tìm thấy

Đảm bảo Claude Code được cài đặt và có trong PATH. Xem hướng dẫn tại [claude.ai/code](https://claude.ai/code).

## Bước Tiếp Theo

Sau khi đã đáp ứng tất cả yêu cầu:

- [Cài đặt qua npm](./npm-install.md)
- [Cài đặt](./installation.md)
