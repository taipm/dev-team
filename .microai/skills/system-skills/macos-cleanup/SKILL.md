---
name: macos-cleanup
description: |
  When Claude needs to free up disk space on macOS, clean caches, remove unused files,
  or optimize storage. Triggers: cleanup, disk space, free space, dọn dẹp, xóa cache,
  giải phóng dung lượng, node_modules, brew cleanup, docker prune
description_vi: |
  Khi Claude cần giải phóng dung lượng ổ đĩa trên macOS, dọn cache, xóa file không dùng,
  hoặc tối ưu storage. Bao gồm: cache hệ thống, node_modules, brew, Xcode, Docker, trash.
license: apache-2.0
version: "1.0.0"
---

# macOS Cleanup Skill

> Giải phóng dung lượng ổ đĩa trên macOS một cách an toàn và hiệu quả.

## Quick Start

```bash
# Xem tổng quan dung lượng
df -h /

# Kiểm tra dung lượng thư mục lớn nhất
du -sh ~/* 2>/dev/null | sort -hr | head -20

# Dọn dẹp nhanh (safe)
rm -rf ~/Library/Caches/*
brew cleanup --prune=all
```

## Cleanup Categories

### 1. System Caches (Safe)
```bash
# User caches (~2-10GB typical)
rm -rf ~/Library/Caches/*

# System logs
sudo rm -rf /private/var/log/asl/*.asl

# Temporary files
rm -rf /private/var/folders/*/*
```

### 2. Developer Cleanup (Safe)
```bash
# Node modules (có thể rất lớn!)
find . -name "node_modules" -type d -prune -exec du -sh {} \;
find . -name "node_modules" -type d -prune -exec rm -rf {} \;

# Python virtual environments
find . -name ".venv" -type d -exec rm -rf {} \;
find . -name "__pycache__" -type d -exec rm -rf {} \;

# Go build cache
go clean -cache -modcache

# Rust build artifacts
rm -rf ~/.cargo/registry/cache/*
```

### 3. Homebrew Cleanup
```bash
# Xem dung lượng brew
du -sh $(brew --cache)
du -sh $(brew --prefix)/Cellar

# Cleanup
brew cleanup --prune=all
brew autoremove

# Xóa cache downloads
rm -rf $(brew --cache)/*
```

### 4. Xcode Cleanup (Lớn nhất!)
```bash
# Derived Data (thường 10-50GB!)
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Archives (old builds)
rm -rf ~/Library/Developer/Xcode/Archives/*

# iOS Device Support (mỗi version ~5GB)
ls -la ~/Library/Developer/Xcode/iOS\ DeviceSupport/
# Giữ lại version đang dùng, xóa cũ

# Simulators không dùng
xcrun simctl delete unavailable
```

### 5. Docker Cleanup
```bash
# Xem dung lượng Docker
docker system df

# Cleanup (safe - chỉ unused)
docker system prune -f

# Aggressive (xóa cả images không dùng)
docker system prune -a -f --volumes
```

### 6. Trash & Downloads
```bash
# Empty trash
rm -rf ~/.Trash/*

# Old downloads (>30 days)
find ~/Downloads -mtime +30 -type f -delete
```

## Safety Levels

### Safe Mode (Default)
Chỉ xóa những thứ có thể regenerate:
- Caches, logs, temp files
- node_modules (npm install lại được)
- Build artifacts

### Aggressive Mode
Thêm:
- Docker images không dùng
- Old iOS simulators
- Xcode archives

### Dangerous (Cần confirm)
- Xóa Downloads
- Empty Trash
- Remove brew packages

## Full Cleanup Script

```bash
#!/bin/bash
# macos-cleanup.sh - Safe full cleanup

echo "=== macOS Cleanup Script ==="
echo "Calculating current usage..."
df -h / | tail -1

echo ""
echo "=== Step 1: User Caches ==="
du -sh ~/Library/Caches 2>/dev/null
rm -rf ~/Library/Caches/*
echo "✓ User caches cleared"

echo ""
echo "=== Step 2: Homebrew ==="
brew cleanup --prune=all 2>/dev/null
brew autoremove 2>/dev/null
echo "✓ Homebrew cleaned"

echo ""
echo "=== Step 3: Xcode DerivedData ==="
if [ -d ~/Library/Developer/Xcode/DerivedData ]; then
    du -sh ~/Library/Developer/Xcode/DerivedData
    rm -rf ~/Library/Developer/Xcode/DerivedData/*
    echo "✓ DerivedData cleared"
fi

echo ""
echo "=== Step 4: Docker ==="
if command -v docker &> /dev/null; then
    docker system prune -f 2>/dev/null
    echo "✓ Docker cleaned"
fi

echo ""
echo "=== Step 5: npm/pnpm cache ==="
npm cache clean --force 2>/dev/null
pnpm store prune 2>/dev/null
echo "✓ npm/pnpm cache cleaned"

echo ""
echo "=== Results ==="
df -h / | tail -1
echo "Done!"
```

## Common Locations & Sizes

| Location | Typical Size | Safe to Delete |
|----------|--------------|----------------|
| `~/Library/Caches` | 2-10 GB | ✅ Yes |
| `node_modules` (all) | 5-50 GB | ✅ Yes |
| `Xcode DerivedData` | 10-50 GB | ✅ Yes |
| `Docker images` | 5-30 GB | ⚠️ Careful |
| `brew cache` | 1-5 GB | ✅ Yes |
| `iOS DeviceSupport` | 5-20 GB | ⚠️ Keep current |
| `~/Downloads` | Variable | ⚠️ Review first |
| `~/.Trash` | Variable | ✅ Yes |

## References
- [Detailed scripts](./references/scripts.md)
- [Dangerous operations](./references/dangerous.md)
