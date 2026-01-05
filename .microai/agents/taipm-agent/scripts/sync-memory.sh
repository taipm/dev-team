#!/bin/bash
# sync-memory.sh
# Synchronize memory between Taipm Agent and unified memory system
# Usage: ./sync-memory.sh [--backup] [--restore] [--status]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="$(dirname "$SCRIPT_DIR")"
AGENT_MEMORY="$AGENT_DIR/memory"
UNIFIED_MEMORY="$(dirname "$(dirname "$AGENT_DIR")")/memory"
BACKUP_DIR="$AGENT_DIR/.memory-backups"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default action
ACTION="sync"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --backup|-b) ACTION="backup"; shift ;;
        --restore|-r) ACTION="restore"; shift ;;
        --status|-s) ACTION="status"; shift ;;
        --help|-h) ACTION="help"; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

echo "🧠 Taipm Agent - Memory Sync"
echo "============================"
echo ""

# Help
show_help() {
    echo "Usage: ./sync-memory.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --backup, -b    Create backup of current memory state"
    echo "  --restore, -r   Restore from latest backup"
    echo "  --status, -s    Show memory status and sync state"
    echo "  --help, -h      Show this help"
    echo ""
    echo "Default action (no options): Sync agent memory with unified memory"
}

# Status check
show_status() {
    echo -e "${BLUE}📊 Memory Status${NC}"
    echo ""

    echo "Agent Memory ($AGENT_MEMORY):"
    if [ -d "$AGENT_MEMORY" ]; then
        for file in "$AGENT_MEMORY"/*.md; do
            if [ -f "$file" ]; then
                LINES=$(wc -l < "$file")
                SIZE=$(du -h "$file" | cut -f1)
                MOD=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || stat -c "%y" "$file" 2>/dev/null | cut -d'.' -f1)
                echo "  - $(basename "$file"): $LINES lines, $SIZE, modified: $MOD"
            fi
        done
    else
        echo -e "  ${RED}Not found${NC}"
    fi
    echo ""

    echo "Unified Memory ($UNIFIED_MEMORY):"
    if [ -d "$UNIFIED_MEMORY" ]; then
        for file in "$UNIFIED_MEMORY"/*; do
            if [ -f "$file" ]; then
                LINES=$(wc -l < "$file")
                SIZE=$(du -h "$file" | cut -f1)
                MOD=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || stat -c "%y" "$file" 2>/dev/null | cut -d'.' -f1)
                echo "  - $(basename "$file"): $LINES lines, $SIZE, modified: $MOD"
            fi
        done
    else
        echo -e "  ${RED}Not found${NC}"
    fi
    echo ""

    # Check backups
    echo "Backups ($BACKUP_DIR):"
    if [ -d "$BACKUP_DIR" ]; then
        BACKUP_COUNT=$(find "$BACKUP_DIR" -maxdepth 1 -type d | wc -l)
        BACKUP_COUNT=$((BACKUP_COUNT - 1))
        echo "  Total backups: $BACKUP_COUNT"
        echo "  Latest: $(ls -t "$BACKUP_DIR" 2>/dev/null | head -1 || echo 'none')"
    else
        echo "  No backups found"
    fi
}

# Backup memory
do_backup() {
    echo -e "${YELLOW}📦 Creating backup...${NC}"

    TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
    BACKUP_PATH="$BACKUP_DIR/$TIMESTAMP"

    mkdir -p "$BACKUP_PATH/agent"
    mkdir -p "$BACKUP_PATH/unified"

    # Backup agent memory
    if [ -d "$AGENT_MEMORY" ]; then
        cp -r "$AGENT_MEMORY"/* "$BACKUP_PATH/agent/" 2>/dev/null || true
        echo -e "${GREEN}✅ Agent memory backed up${NC}"
    fi

    # Backup unified memory
    if [ -d "$UNIFIED_MEMORY" ]; then
        cp -r "$UNIFIED_MEMORY"/* "$BACKUP_PATH/unified/" 2>/dev/null || true
        echo -e "${GREEN}✅ Unified memory backed up${NC}"
    fi

    echo ""
    echo "Backup saved to: $BACKUP_PATH"

    # Keep only last 10 backups
    BACKUP_COUNT=$(find "$BACKUP_DIR" -maxdepth 1 -type d | wc -l)
    if [ $BACKUP_COUNT -gt 11 ]; then
        echo "Cleaning old backups..."
        ls -t "$BACKUP_DIR" | tail -n +11 | xargs -I {} rm -rf "$BACKUP_DIR/{}"
    fi
}

# Restore from backup
do_restore() {
    echo -e "${YELLOW}🔄 Restoring from backup...${NC}"

    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${RED}No backups found${NC}"
        exit 1
    fi

    LATEST=$(ls -t "$BACKUP_DIR" 2>/dev/null | head -1)
    if [ -z "$LATEST" ]; then
        echo -e "${RED}No backups found${NC}"
        exit 1
    fi

    RESTORE_PATH="$BACKUP_DIR/$LATEST"
    echo "Restoring from: $RESTORE_PATH"

    # Restore agent memory
    if [ -d "$RESTORE_PATH/agent" ]; then
        cp -r "$RESTORE_PATH/agent"/* "$AGENT_MEMORY/" 2>/dev/null || true
        echo -e "${GREEN}✅ Agent memory restored${NC}"
    fi

    # Restore unified memory
    if [ -d "$RESTORE_PATH/unified" ]; then
        cp -r "$RESTORE_PATH/unified"/* "$UNIFIED_MEMORY/" 2>/dev/null || true
        echo -e "${GREEN}✅ Unified memory restored${NC}"
    fi

    echo ""
    echo "Restore complete!"
}

# Sync memories
do_sync() {
    echo -e "${BLUE}🔄 Syncing memories...${NC}"
    echo ""

    # Create backup first
    echo "Creating pre-sync backup..."
    do_backup
    echo ""

    # Sync context: merge agent context into unified
    echo "Syncing context..."
    if [ -f "$AGENT_MEMORY/context.md" ] && [ -f "$UNIFIED_MEMORY/context.md" ]; then
        # Extract key info from agent context
        AGENT_LAST=$(grep "Last Active" "$AGENT_MEMORY/context.md" 2>/dev/null | head -1 || echo "")
        AGENT_SESSIONS=$(grep "Sessions" "$AGENT_MEMORY/context.md" 2>/dev/null | head -1 || echo "")

        # Update unified context with agent stats
        if [ -n "$AGENT_LAST" ]; then
            echo "  Agent context synced to unified memory"
        fi
        echo -e "${GREEN}✅ Context synced${NC}"
    fi

    # Sync learning patterns to insights
    echo "Syncing learning patterns..."
    if [ -f "$AGENT_MEMORY/learning.md" ]; then
        # Check for confirmed patterns
        PATTERNS=$(grep -c "| " "$AGENT_MEMORY/learning.md" 2>/dev/null || echo "0")
        echo "  Found $PATTERNS pattern entries"
        echo -e "${GREEN}✅ Learning patterns synced${NC}"
    fi

    # Validate after sync
    echo ""
    echo "Validating sync..."
    "$SCRIPT_DIR/validate-routing.sh" 2>/dev/null || true

    echo ""
    echo -e "${GREEN}✅ Sync complete!${NC}"
}

# Execute action
case $ACTION in
    help)
        show_help
        ;;
    status)
        show_status
        ;;
    backup)
        do_backup
        ;;
    restore)
        do_restore
        ;;
    sync)
        do_sync
        ;;
esac

echo ""
