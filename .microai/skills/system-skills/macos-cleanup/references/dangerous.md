# Dangerous Operations

> Các thao tác nguy hiểm cần cẩn thận - có thể mất dữ liệu!

## ⚠️ Warning Level Guide

| Level | Meaning |
|-------|---------|
| 🟢 Safe | Có thể xóa thoải mái, regenerate được |
| 🟡 Careful | Kiểm tra trước khi xóa |
| 🔴 Dangerous | Có thể mất dữ liệu vĩnh viễn |

## 🔴 DANGEROUS: Downloads Cleanup

```bash
# DANGEROUS - Review trước khi xóa!
# Liệt kê files cũ hơn 30 ngày
find ~/Downloads -mtime +30 -type f -exec ls -lh {} \;

# Chỉ xóa sau khi review
find ~/Downloads -mtime +30 -type f -delete
```

**Risks:**
- Có thể chứa files quan trọng chưa move
- Installer packages cần giữ lại
- Documents đã download

**Safe alternative:**
```bash
# Move to trash thay vì delete
find ~/Downloads -mtime +30 -type f -exec mv {} ~/.Trash/ \;
```

## 🔴 DANGEROUS: Application Support

```bash
# NEVER delete blindly!
# ~/Library/Application Support/ chứa app data quan trọng

# Chỉ xóa cho apps đã uninstall
# Kiểm tra app còn tồn tại không trước khi xóa data
```

**Safe apps to clean (nếu không dùng):**
- Slack caches
- Discord caches
- Chrome/Firefox profiles (cẩn thận passwords!)

## 🔴 DANGEROUS: Keychain & Credentials

```bash
# NEVER delete these:
# ~/Library/Keychains/
# ~/.ssh/
# ~/.gnupg/
# ~/.aws/
# ~/.config/gcloud/
```

## 🟡 CAREFUL: Xcode iOS DeviceSupport

```bash
# Mỗi iOS version ~ 5GB
ls -la ~/Library/Developer/Xcode/iOS\ DeviceSupport/

# Giữ lại version đang dùng (check iPhone Settings > General > About)
# Có thể xóa versions cũ
```

**Check current iOS version:**
```bash
# Xem devices đang connect
xcrun xctrace list devices
```

## 🟡 CAREFUL: Docker Volumes

```bash
# Volumes có thể chứa database data!
docker volume ls

# Chỉ xóa volumes orphaned
docker volume prune

# DANGEROUS - xóa tất cả volumes
docker volume prune -a  # ⚠️ Mất database data!
```

## 🟡 CAREFUL: Git Objects

```bash
# Git có garbage collection tự động
# Chỉ chạy nếu repo quá lớn

git gc --aggressive --prune=now

# DANGEROUS - rewrite history
git reflog expire --expire=now --all
git gc --prune=now
```

## 🟢 SAFE: What's Always Safe

```bash
# User caches - apps sẽ recreate
rm -rf ~/Library/Caches/*

# Logs cũ
sudo rm -rf /private/var/log/asl/*.asl

# Temp files
rm -rf /private/var/folders/*/*

# Derived data - Xcode rebuilds
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# npm/pnpm cache - download lại được
npm cache clean --force
pnpm store prune

# Brew cache - download lại được
brew cleanup --prune=all
```

## Recovery Tips

### Nếu lỡ xóa nhầm:

1. **Trash vẫn còn?**
   ```bash
   # Check trash
   ls ~/.Trash/
   ```

2. **Time Machine backup?**
   ```bash
   # Enter Time Machine
   tmutil restore /path/to/file
   ```

3. **Cloud sync?**
   - iCloud: Check icloud.com
   - Dropbox: Check version history
   - Git: Check remote repos

### Prevent Mistakes

```bash
# Alias rm to move to trash instead
alias rm='mv -t ~/.Trash/'

# Or use trash-cli
brew install trash-cli
alias rm='trash'
```

## Pre-Cleanup Checklist

Before running aggressive cleanup:

- [ ] Time Machine backup recent?
- [ ] Important projects committed & pushed?
- [ ] No running builds/compiles?
- [ ] Docker containers stopped?
- [ ] Know what's in Downloads folder?
- [ ] Xcode projects closed?
