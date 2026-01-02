#!/bin/bash
# git-check.sh - Quick security check before git push
# Part of git-push skill for MicroAI
# License: Apache 2.0
#
# Exit codes:
#   0 - All checks passed, safe to proceed
#   1 - Security issues found, block operation
#
# Usage: ./git-check.sh [--verbose]

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

VERBOSE=${1:-""}
ISSUES_FOUND=0
WARNINGS_FOUND=0

# Helper functions
log_pass() { echo -e "${GREEN}✅ PASS${NC}: $1"; }
log_fail() { echo -e "${RED}❌ FAIL${NC}: $1"; ISSUES_FOUND=$((ISSUES_FOUND + 1)); }
log_warn() { echo -e "${YELLOW}⚠️  WARN${NC}: $1"; WARNINGS_FOUND=$((WARNINGS_FOUND + 1)); }
log_info() { if [[ -n "$VERBOSE" ]]; then echo -e "ℹ️  INFO: $1"; fi; }

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 GIT-CHECK: Quick Security Scan"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    log_fail "Not a git repository"
    exit 1
fi

# Get staged files
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || echo "")
if [[ -z "$STAGED_FILES" ]]; then
    echo "ℹ️  No staged files to check"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 Result: No files staged for commit"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 0
fi

echo ""
echo "📁 Staged files: $(echo "$STAGED_FILES" | wc -l | tr -d ' ')"
echo ""

# ============================================================================
# CHECK 1: Pre-commit hooks (if installed)
# ============================================================================
echo "─── Check 1: Pre-commit Hooks ───"

if command -v pre-commit &>/dev/null; then
    if [[ -f ".pre-commit-config.yaml" ]]; then
        log_info "Running pre-commit hooks..."
        if pre-commit run --files "$STAGED_FILES" 2>/dev/null; then
            log_pass "Pre-commit hooks passed"
        else
            log_fail "Pre-commit hooks failed"
        fi
    else
        log_warn "pre-commit installed but no .pre-commit-config.yaml found"
    fi
else
    log_warn "pre-commit not installed (recommended: pip install pre-commit)"
fi

echo ""

# ============================================================================
# CHECK 2: Secret patterns in staged files
# ============================================================================
echo "─── Check 2: Secret Pattern Scan ───"

# Patterns to detect
SECRET_PATTERNS=(
    # AWS
    'AKIA[0-9A-Z]{16}'
    'aws_secret_access_key\s*=\s*[A-Za-z0-9/+=]{40}'
    # GitHub
    'ghp_[A-Za-z0-9]{36}'
    'github_pat_[A-Za-z0-9]{22}_[A-Za-z0-9]{59}'
    'gho_[A-Za-z0-9]{36}'
    'ghu_[A-Za-z0-9]{36}'
    # Generic
    'api[_-]?key\s*[:=]\s*['\''"][A-Za-z0-9]{20,}['\''"]'
    'secret[_-]?key\s*[:=]\s*['\''"][A-Za-z0-9]{20,}['\''"]'
    'password\s*[:=]\s*['\''"][^'\''\"]{8,}['\''"]'
    # Private keys
    '-----BEGIN (RSA |DSA |EC |OPENSSH )?PRIVATE KEY-----'
    # Slack
    'xox[baprs]-[0-9]{10,13}-[0-9]{10,13}-[a-zA-Z0-9]{24}'
)

SECRETS_FOUND=0
for pattern in "${SECRET_PATTERNS[@]}"; do
    while IFS= read -r file; do
        if [[ -f "$file" ]]; then
            if grep -qE "$pattern" "$file" 2>/dev/null; then
                log_fail "Potential secret in $file (pattern: ${pattern:0:30}...)"
                SECRETS_FOUND=$((SECRETS_FOUND + 1))
            fi
        fi
    done <<< "$STAGED_FILES"
done

if [[ $SECRETS_FOUND -eq 0 ]]; then
    log_pass "No secret patterns detected"
fi

echo ""

# ============================================================================
# CHECK 3: .env files in staging
# ============================================================================
echo "─── Check 3: Environment Files ───"

ENV_FILES=$(echo "$STAGED_FILES" | grep -E '^\.env|\.env\.' || true)
if [[ -n "$ENV_FILES" ]]; then
    while IFS= read -r env_file; do
        log_fail ".env file staged: $env_file"
    done <<< "$ENV_FILES"
else
    log_pass "No .env files in staging"
fi

echo ""

# ============================================================================
# CHECK 4: .gitignore coverage
# ============================================================================
echo "─── Check 4: .gitignore Coverage ───"

if [[ -f ".gitignore" ]]; then
    REQUIRED_PATTERNS=(".env" "*.pem" "*.key" "credentials")
    MISSING_PATTERNS=()

    for pattern in "${REQUIRED_PATTERNS[@]}"; do
        if ! grep -qF "$pattern" .gitignore 2>/dev/null; then
            MISSING_PATTERNS+=("$pattern")
        fi
    done

    if [[ ${#MISSING_PATTERNS[@]} -eq 0 ]]; then
        log_pass ".gitignore covers essential patterns"
    else
        log_warn ".gitignore missing: ${MISSING_PATTERNS[*]}"
    fi
else
    log_warn "No .gitignore file found"
fi

echo ""

# ============================================================================
# SUMMARY
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $ISSUES_FOUND -gt 0 ]]; then
    echo -e "📊 Result: ${RED}BLOCKED${NC} - $ISSUES_FOUND issue(s) found"
    echo ""
    echo "🛠️  Actions required:"
    echo "   - Remove secrets from staged files"
    echo "   - Unstage .env files: git reset HEAD <file>"
    echo "   - Run full audit: /microai:github-setup audit"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 1
elif [[ $WARNINGS_FOUND -gt 0 ]]; then
    echo -e "📊 Result: ${GREEN}PASSED${NC} with $WARNINGS_FOUND warning(s)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 0
else
    echo -e "📊 Result: ${GREEN}PASSED${NC} - All checks passed"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 0
fi
