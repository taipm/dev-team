#!/bin/bash
# ============================================================================
# MicroAI Hook: Initialize Environment
# Type: SessionStart
# Description: Loads environment variables and initializes session
# ============================================================================

# Configuration
LOG_DIR=".microai/logs"
SESSION_LOG="$LOG_DIR/sessions.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# ============================================================================
# 1. Load environment files (in order of priority)
# ============================================================================

# Project-level env (lowest priority)
if [ -f ".env" ]; then
    set -a
    source .env 2>/dev/null || true
    set +a
fi

# Local overrides
if [ -f ".env.local" ]; then
    set -a
    source .env.local 2>/dev/null || true
    set +a
fi

# MicroAI specific env
if [ -f ".microai/.env" ]; then
    set -a
    source .microai/.env 2>/dev/null || true
    set +a
fi

# Development env (highest priority for dev work)
if [ -f ".env.development" ]; then
    set -a
    source .env.development 2>/dev/null || true
    set +a
fi

# ============================================================================
# 2. Log session start
# ============================================================================

{
    echo "========================================"
    echo "Session Started: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Working Directory: $(pwd)"
    echo "User: ${USER:-unknown}"
    echo "Shell: ${SHELL:-unknown}"

    # Log git info if available
    if command -v git &> /dev/null && [ -d ".git" ]; then
        BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
        COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
        echo "Git Branch: $BRANCH"
        echo "Git Commit: $COMMIT"
    fi

    echo "========================================"
} >> "$SESSION_LOG"

# ============================================================================
# 3. Check prerequisites (optional warnings)
# ============================================================================

# Check for required tools
MISSING_TOOLS=""

if ! command -v jq &> /dev/null; then
    MISSING_TOOLS="$MISSING_TOOLS jq"
fi

if ! command -v git &> /dev/null; then
    MISSING_TOOLS="$MISSING_TOOLS git"
fi

if [ -n "$MISSING_TOOLS" ]; then
    echo "Warning: Some tools are missing:$MISSING_TOOLS" >&2
    echo "Some hooks may not work correctly" >&2
fi

# ============================================================================
# 4. Create session context file (for other hooks to use)
# ============================================================================

SESSION_CONTEXT=".microai/.session-context"
{
    echo "SESSION_START=$(date '+%Y-%m-%d %H:%M:%S')"
    echo "WORKING_DIR=$(pwd)"
    echo "USER=${USER:-unknown}"
} > "$SESSION_CONTEXT"

# Always exit 0 - session should start even if some setup fails
exit 0
