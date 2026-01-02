# Cleanup Scripts Reference

> Chi tiết các scripts dọn dẹp cho từng category.

## Interactive Cleanup Script

```bash
#!/bin/bash
# interactive-cleanup.sh - Cleanup với confirm từng bước

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

confirm() {
    read -p "$1 [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

show_size() {
    if [ -d "$1" ]; then
        du -sh "$1" 2>/dev/null | cut -f1
    else
        echo "N/A"
    fi
}

echo -e "${GREEN}=== macOS Interactive Cleanup ===${NC}"
echo ""

# 1. Show current disk usage
echo -e "${YELLOW}Current Disk Usage:${NC}"
df -h / | grep -E "^/|Filesystem"
echo ""

# 2. User Caches
CACHE_SIZE=$(show_size ~/Library/Caches)
echo -e "User Caches: ${YELLOW}$CACHE_SIZE${NC}"
if confirm "Clean user caches?"; then
    rm -rf ~/Library/Caches/*
    echo -e "${GREEN}✓ Cleaned${NC}"
fi
echo ""

# 3. Homebrew
if command -v brew &> /dev/null; then
    BREW_CACHE=$(show_size $(brew --cache))
    echo -e "Homebrew cache: ${YELLOW}$BREW_CACHE${NC}"
    if confirm "Clean Homebrew?"; then
        brew cleanup --prune=all
        brew autoremove
        echo -e "${GREEN}✓ Cleaned${NC}"
    fi
    echo ""
fi

# 4. Xcode
if [ -d ~/Library/Developer/Xcode/DerivedData ]; then
    XCODE_SIZE=$(show_size ~/Library/Developer/Xcode/DerivedData)
    echo -e "Xcode DerivedData: ${YELLOW}$XCODE_SIZE${NC}"
    if confirm "Clean Xcode DerivedData?"; then
        rm -rf ~/Library/Developer/Xcode/DerivedData/*
        echo -e "${GREEN}✓ Cleaned${NC}"
    fi
    echo ""
fi

# 5. Docker
if command -v docker &> /dev/null; then
    echo -e "Docker usage:"
    docker system df 2>/dev/null || echo "Docker not running"
    if confirm "Clean Docker (unused)?"; then
        docker system prune -f
        echo -e "${GREEN}✓ Cleaned${NC}"
    fi
    echo ""
fi

# 6. npm/pnpm
if command -v npm &> /dev/null; then
    echo -e "npm cache:"
    npm cache ls 2>/dev/null | wc -l | xargs echo "entries:"
    if confirm "Clean npm cache?"; then
        npm cache clean --force
        echo -e "${GREEN}✓ Cleaned${NC}"
    fi
fi

if command -v pnpm &> /dev/null; then
    if confirm "Clean pnpm store?"; then
        pnpm store prune
        echo -e "${GREEN}✓ Cleaned${NC}"
    fi
fi
echo ""

# 7. Trash
TRASH_SIZE=$(show_size ~/.Trash)
echo -e "Trash: ${YELLOW}$TRASH_SIZE${NC}"
if confirm "Empty Trash?"; then
    rm -rf ~/.Trash/*
    echo -e "${GREEN}✓ Emptied${NC}"
fi
echo ""

# Final report
echo -e "${GREEN}=== Cleanup Complete ===${NC}"
echo -e "${YELLOW}New Disk Usage:${NC}"
df -h / | grep -E "^/|Filesystem"
```

## Find Large Directories

```bash
#!/bin/bash
# find-large.sh - Tìm thư mục lớn nhất

echo "=== Top 20 Largest Directories in Home ==="
du -sh ~/* ~/.[!.]* 2>/dev/null | sort -hr | head -20

echo ""
echo "=== Largest in Library ==="
du -sh ~/Library/* 2>/dev/null | sort -hr | head -10

echo ""
echo "=== Node Modules (all projects) ==="
find ~ -name "node_modules" -type d -prune 2>/dev/null | while read dir; do
    du -sh "$dir" 2>/dev/null
done | sort -hr | head -10
```

## Clean Node Modules Script

```bash
#!/bin/bash
# clean-node-modules.sh - Dọn node_modules trong projects

TARGET_DIR="${1:-.}"
DRY_RUN="${2:-true}"

echo "Scanning for node_modules in: $TARGET_DIR"
echo "Dry run: $DRY_RUN"
echo ""

TOTAL=0
while IFS= read -r dir; do
    SIZE=$(du -sk "$dir" 2>/dev/null | cut -f1)
    SIZE_MB=$((SIZE / 1024))
    TOTAL=$((TOTAL + SIZE_MB))
    echo "$SIZE_MB MB: $dir"

    if [ "$DRY_RUN" = "false" ]; then
        rm -rf "$dir"
        echo "  → Deleted"
    fi
done < <(find "$TARGET_DIR" -name "node_modules" -type d -prune 2>/dev/null)

echo ""
echo "Total: ${TOTAL} MB"

if [ "$DRY_RUN" = "true" ]; then
    echo ""
    echo "This was a dry run. To actually delete, run:"
    echo "  $0 $TARGET_DIR false"
fi
```

## Claude Code Specific Cleanup

```bash
#!/bin/bash
# claude-code-cleanup.sh - Cleanup cho Claude Code environment

echo "=== Claude Code Environment Cleanup ==="

# Claude cache/data
CLAUDE_DIRS=(
    ~/.claude
    ~/.config/claude
    ~/Library/Application\ Support/Claude
    ~/Library/Caches/Claude
)

for dir in "${CLAUDE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        SIZE=$(du -sh "$dir" 2>/dev/null | cut -f1)
        echo "$SIZE: $dir"
    fi
done

echo ""
echo "Note: Be careful with ~/.claude - contains sessions and settings"
echo ""

# Safe to clean:
echo "Safe to clean:"
echo "  - ~/Library/Caches/Claude/*"
echo "  - Old session logs"

# Dangerous:
echo ""
echo "DO NOT delete:"
echo "  - ~/.claude/settings.json"
echo "  - ~/.claude/projects/ (active project data)"
```

## Scheduled Cleanup (launchd)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.weekly-cleanup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>rm -rf ~/Library/Caches/* ; brew cleanup --prune=all 2>/dev/null</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>0</integer>
        <key>Hour</key>
        <integer>3</integer>
    </dict>
</dict>
</plist>
```

Save to `~/Library/LaunchAgents/com.user.weekly-cleanup.plist` và load:
```bash
launchctl load ~/Library/LaunchAgents/com.user.weekly-cleanup.plist
```
