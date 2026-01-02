#!/bin/bash
# GitHub Repository Security Audit Script
# Usage: bash audit-repo.sh [repo-path]
#
# This script performs automated security checks on a GitHub repository.
# It checks for common security issues and provides recommendations.

set -e

REPO_PATH="${1:-.}"
cd "$REPO_PATH"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
WARNINGS=0
FAILED=0

echo ""
echo "========================================"
echo "   GitHub Repository Security Audit"
echo "========================================"
echo "   Path: $(pwd)"
echo "   Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"
echo ""

# Check if git repo
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}[ERROR] Not a git repository!${NC}"
    exit 1
fi

# =============================================================================
# Section 1: Essential Files
# =============================================================================
echo -e "${BLUE}=== 1. Essential Files ===${NC}"

# Check .gitignore
if [ -f ".gitignore" ]; then
    echo -e "${GREEN}[PASS] .gitignore exists${NC}"
    ((PASSED++))

    # Check for sensitive patterns
    SENSITIVE_PATTERNS=(".env" "secret" "credential" ".pem" ".key" "api_key")
    MISSING_PATTERNS=()

    for pattern in "${SENSITIVE_PATTERNS[@]}"; do
        if ! grep -qi "$pattern" .gitignore 2>/dev/null; then
            MISSING_PATTERNS+=("$pattern")
        fi
    done

    if [ ${#MISSING_PATTERNS[@]} -eq 0 ]; then
        echo -e "       - Covers sensitive file patterns"
    else
        echo -e "${YELLOW}       - Missing patterns: ${MISSING_PATTERNS[*]}${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "${RED}[FAIL] .gitignore missing${NC}"
    ((FAILED++))
fi

# Check SECURITY.md
if [ -f "SECURITY.md" ]; then
    echo -e "${GREEN}[PASS] SECURITY.md exists${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}[WARN] SECURITY.md missing${NC}"
    ((WARNINGS++))
fi

# Check README.md
if [ -f "README.md" ]; then
    echo -e "${GREEN}[PASS] README.md exists${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}[WARN] README.md missing${NC}"
    ((WARNINGS++))
fi

# Check LICENSE
if [ -f "LICENSE" ] || [ -f "LICENSE.txt" ] || [ -f "LICENSE.md" ]; then
    echo -e "${GREEN}[PASS] LICENSE exists${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}[WARN] LICENSE missing${NC}"
    ((WARNINGS++))
fi

# =============================================================================
# Section 2: Code Ownership
# =============================================================================
echo ""
echo -e "${BLUE}=== 2. Code Ownership ===${NC}"

# Check CODEOWNERS
if [ -f ".github/CODEOWNERS" ] || [ -f "CODEOWNERS" ] || [ -f "docs/CODEOWNERS" ]; then
    echo -e "${GREEN}[PASS] CODEOWNERS configured${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}[WARN] CODEOWNERS not configured${NC}"
    ((WARNINGS++))
fi

# =============================================================================
# Section 3: Dependency Management
# =============================================================================
echo ""
echo -e "${BLUE}=== 3. Dependency Management ===${NC}"

# Check Dependabot
if [ -f ".github/dependabot.yml" ] || [ -f ".github/dependabot.yaml" ]; then
    echo -e "${GREEN}[PASS] Dependabot configured${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}[WARN] Dependabot not configured${NC}"
    ((WARNINGS++))
fi

# =============================================================================
# Section 4: CI/CD Security
# =============================================================================
echo ""
echo -e "${BLUE}=== 4. CI/CD Configuration ===${NC}"

# Check for GitHub Actions workflows
if [ -d ".github/workflows" ]; then
    WORKFLOW_COUNT=$(find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$WORKFLOW_COUNT" -gt 0 ]; then
        echo -e "${GREEN}[PASS] GitHub Actions configured ($WORKFLOW_COUNT workflows)${NC}"
        ((PASSED++))

        # Check for hardcoded secrets in workflows (exclude GitHub secrets syntax ${{ }})
        # shellcheck disable=SC2016
        SECRET_REFS=$(grep -rn "password\|secret\|api_key\|token" .github/workflows/ 2>/dev/null | grep -v '\${{' | grep -v '#' | head -5)
        if [ -n "$SECRET_REFS" ]; then
            echo -e "${RED}[FAIL] Potential hardcoded secrets in workflows:${NC}"
            echo "$SECRET_REFS" | while read -r line; do
                echo -e "       ${YELLOW}$line${NC}"
            done
            ((FAILED++))
        fi
    else
        echo -e "${YELLOW}[WARN] .github/workflows exists but no workflows found${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}[WARN] No GitHub Actions workflows${NC}"
    ((WARNINGS++))
fi

# =============================================================================
# Section 5: Pre-commit Hooks
# =============================================================================
echo ""
echo -e "${BLUE}=== 5. Pre-commit Hooks ===${NC}"

if [ -f ".pre-commit-config.yaml" ]; then
    echo -e "${GREEN}[PASS] Pre-commit configured${NC}"
    ((PASSED++))

    # Check for secret detection hooks
    if grep -qE "detect-secrets|gitleaks|trufflehog" .pre-commit-config.yaml 2>/dev/null; then
        echo -e "       - Secret detection enabled"
    else
        echo -e "${YELLOW}       - No secret detection hooks found${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}[WARN] Pre-commit not configured${NC}"
    ((WARNINGS++))
fi

# =============================================================================
# Section 6: Secret Scanning
# =============================================================================
echo ""
echo -e "${BLUE}=== 6. Secret Scan (Quick) ===${NC}"

# Define file patterns to scan (reserved for future use)
# shellcheck disable=SC2034
FILE_PATTERNS="*.go *.py *.js *.ts *.java *.rb *.php *.cs *.rs"

# Quick secret patterns check
SECRET_PATTERNS="password[[:space:]]*=[[:space:]]*['\"][^'\"]+['\"]|secret[[:space:]]*=[[:space:]]*['\"][^'\"]+['\"]|api_key[[:space:]]*=[[:space:]]*['\"][^'\"]+['\"]|AKIA[0-9A-Z]{16}|-----BEGIN.*PRIVATE KEY-----|ghp_[a-zA-Z0-9]{36}|xox[baprs]-[0-9]{10,12}-[0-9]{10,12}-[a-zA-Z0-9]{24}"

EXCLUDE_DIRS="node_modules vendor .venv venv __pycache__ .git dist build"
EXCLUDE_ARGS=""
for dir in $EXCLUDE_DIRS; do
    EXCLUDE_ARGS="$EXCLUDE_ARGS --exclude-dir=$dir"
done

# shellcheck disable=SC2086
SECRET_FILES=$(grep -rln $EXCLUDE_ARGS -E "$SECRET_PATTERNS" . 2>/dev/null | head -10)

if [ -n "$SECRET_FILES" ]; then
    echo -e "${RED}[FAIL] Potential secrets found in:${NC}"
    echo "$SECRET_FILES" | while read -r file; do
        echo -e "       ${YELLOW}- $file${NC}"
    done
    ((FAILED++))
else
    echo -e "${GREEN}[PASS] No obvious secrets in code${NC}"
    ((PASSED++))
fi

# =============================================================================
# Section 7: .env Files Check
# =============================================================================
echo ""
echo -e "${BLUE}=== 7. Environment Files ===${NC}"

ENV_FILES=$(find . -name ".env" -o -name ".env.*" 2>/dev/null | grep -v node_modules | grep -v vendor | head -10)

if [ -n "$ENV_FILES" ]; then
    echo -e "${YELLOW}[WARN] .env files found (should not be committed):${NC}"
    echo "$ENV_FILES" | while read -r file; do
        echo -e "       ${YELLOW}- $file${NC}"
    done
    ((WARNINGS++))

    # Check if they're in .gitignore
    if [ -f ".gitignore" ] && grep -q "\.env" .gitignore; then
        echo -e "       - ${GREEN}(.env is in .gitignore)${NC}"
    else
        echo -e "       - ${RED}(.env NOT in .gitignore!)${NC}"
        ((FAILED++))
    fi
else
    echo -e "${GREEN}[PASS] No .env files found in repository${NC}"
    ((PASSED++))
fi

# =============================================================================
# Section 8: Branch Protection (if gh available)
# =============================================================================
echo ""
echo -e "${BLUE}=== 8. Branch Protection ===${NC}"

if command -v gh &> /dev/null; then
    # Check if we're in a GitHub repo with remote
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

    if [ -n "$REMOTE_URL" ] && [[ "$REMOTE_URL" == *"github.com"* ]]; then
        REPO_INFO=$(gh repo view --json owner,name 2>/dev/null || echo "")

        if [ -n "$REPO_INFO" ]; then
            OWNER=$(echo "$REPO_INFO" | grep -o '"login":"[^"]*' | cut -d'"' -f4)
            REPO=$(echo "$REPO_INFO" | grep -o '"name":"[^"]*' | cut -d'"' -f4)

            if [ -n "$OWNER" ] && [ -n "$REPO" ]; then
                PROTECTION=$(gh api "repos/$OWNER/$REPO/branches/main/protection" 2>/dev/null || echo "none")

                if [ "$PROTECTION" != "none" ] && [ -n "$PROTECTION" ]; then
                    echo -e "${GREEN}[PASS] Branch protection enabled on main${NC}"
                    ((PASSED++))
                else
                    echo -e "${YELLOW}[WARN] Branch protection not configured on main${NC}"
                    ((WARNINGS++))
                fi
            else
                echo -e "${YELLOW}[SKIP] Could not determine repo info${NC}"
            fi
        else
            echo -e "${YELLOW}[SKIP] Not authenticated with gh or not a GitHub repo${NC}"
        fi
    else
        echo -e "${YELLOW}[SKIP] Not a GitHub repository${NC}"
    fi
else
    echo -e "${YELLOW}[SKIP] GitHub CLI not available (install with: brew install gh)${NC}"
fi

# =============================================================================
# Summary
# =============================================================================
echo ""
echo "========================================"
echo "               Summary"
echo "========================================"
echo ""
echo -e "  ${GREEN}Passed:   $PASSED${NC}"
echo -e "  ${YELLOW}Warnings: $WARNINGS${NC}"
echo -e "  ${RED}Failed:   $FAILED${NC}"
echo ""

TOTAL=$((PASSED + WARNINGS + FAILED))
if [ $TOTAL -gt 0 ]; then
    SCORE=$((PASSED * 100 / TOTAL))
    echo "  Score: $SCORE%"
fi

echo ""
echo "========================================"

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Action Required: Fix $FAILED failed check(s)${NC}"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}Recommended: Address $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${GREEN}All checks passed!${NC}"
    exit 0
fi
