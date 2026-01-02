#!/bin/bash
# GitHub Repository Setup Script
# Usage: bash setup-repo.sh [language] [repo-path]
#
# Sets up a repository with security best practices:
# - .gitignore (language-specific)
# - SECURITY.md
# - CODEOWNERS
# - dependabot.yml
# - pre-commit hooks
# - CI workflow

set -e

# Arguments
LANGUAGE="${1:-generic}"
REPO_PATH="${2:-.}"

# Get script directory (where templates are)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
# shellcheck disable=SC2034
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

cd "$REPO_PATH"

echo ""
echo "========================================"
echo "   GitHub Repository Setup"
echo "========================================"
echo "   Language: $LANGUAGE"
echo "   Path: $(pwd)"
echo "========================================"
echo ""

# =============================================================================
# Initialize Git if needed
# =============================================================================
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${BLUE}Initializing git repository...${NC}"
    git init
    echo ""
fi

# =============================================================================
# Create directories
# =============================================================================
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p .github/workflows
echo -e "${GREEN}  Created .github/workflows/${NC}"

# =============================================================================
# Copy .gitignore
# =============================================================================
echo ""
echo -e "${BLUE}Setting up .gitignore...${NC}"

if [ -f "$SKILL_DIR/templates/gitignore/${LANGUAGE}.gitignore" ]; then
    cp "$SKILL_DIR/templates/gitignore/${LANGUAGE}.gitignore" .gitignore
    echo -e "${GREEN}  Copied ${LANGUAGE}.gitignore${NC}"
else
    echo -e "${YELLOW}  No template for '$LANGUAGE', creating generic .gitignore${NC}"
    cat > .gitignore << 'EOF'
# Environment variables - CRITICAL
.env
.env.local
.env.*.local
.envrc

# Secrets - CRITICAL
*.pem
*.key
*.p12
*.pfx
secrets/
credentials/
private/
.secrets/

# API keys and tokens
*.token
api_keys.json
service-account*.json

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Build output
dist/
build/
out/

# Dependencies
node_modules/
vendor/
.venv/
venv/

# Logs
*.log
logs/

# Temporary files
tmp/
temp/
*.tmp
EOF
fi

# =============================================================================
# Copy SECURITY.md
# =============================================================================
echo ""
echo -e "${BLUE}Setting up SECURITY.md...${NC}"

if [ ! -f "SECURITY.md" ]; then
    cp "$SKILL_DIR/templates/security/SECURITY.md" SECURITY.md
    echo -e "${GREEN}  Created SECURITY.md${NC}"
    echo -e "${YELLOW}  TODO: Update email address in SECURITY.md${NC}"
else
    echo -e "${YELLOW}  SECURITY.md already exists, skipping${NC}"
fi

# =============================================================================
# Copy CODEOWNERS
# =============================================================================
echo ""
echo -e "${BLUE}Setting up CODEOWNERS...${NC}"

if [ ! -f ".github/CODEOWNERS" ]; then
    cp "$SKILL_DIR/templates/security/CODEOWNERS" .github/CODEOWNERS
    echo -e "${GREEN}  Created .github/CODEOWNERS${NC}"
    echo -e "${YELLOW}  TODO: Update @your-username in CODEOWNERS${NC}"
else
    echo -e "${YELLOW}  CODEOWNERS already exists, skipping${NC}"
fi

# =============================================================================
# Copy dependabot.yml
# =============================================================================
echo ""
echo -e "${BLUE}Setting up Dependabot...${NC}"

if [ ! -f ".github/dependabot.yml" ]; then
    cp "$SKILL_DIR/templates/security/dependabot.yml" .github/dependabot.yml
    echo -e "${GREEN}  Created .github/dependabot.yml${NC}"
    echo -e "${YELLOW}  TODO: Uncomment relevant package ecosystem in dependabot.yml${NC}"
else
    echo -e "${YELLOW}  dependabot.yml already exists, skipping${NC}"
fi

# =============================================================================
# Copy pre-commit config
# =============================================================================
echo ""
echo -e "${BLUE}Setting up pre-commit hooks...${NC}"

if [ ! -f ".pre-commit-config.yaml" ]; then
    cp "$SKILL_DIR/templates/hooks/pre-commit-config.yaml" .pre-commit-config.yaml
    echo -e "${GREEN}  Created .pre-commit-config.yaml${NC}"
    echo -e "${YELLOW}  TODO: Uncomment language-specific hooks${NC}"
else
    echo -e "${YELLOW}  .pre-commit-config.yaml already exists, skipping${NC}"
fi

# =============================================================================
# Copy CI workflow
# =============================================================================
echo ""
echo -e "${BLUE}Setting up CI workflow...${NC}"

if [ ! -f ".github/workflows/ci.yml" ]; then
    if [ -f "$SKILL_DIR/templates/workflows/${LANGUAGE}-ci.yml" ]; then
        cp "$SKILL_DIR/templates/workflows/${LANGUAGE}-ci.yml" .github/workflows/ci.yml
        echo -e "${GREEN}  Created .github/workflows/ci.yml (${LANGUAGE})${NC}"
    else
        echo -e "${YELLOW}  No CI template for '$LANGUAGE', skipping${NC}"
        echo -e "${YELLOW}  Available: go, python, node${NC}"
    fi
else
    echo -e "${YELLOW}  CI workflow already exists, skipping${NC}"
fi

# =============================================================================
# Create README.md if missing
# =============================================================================
echo ""
echo -e "${BLUE}Checking README.md...${NC}"

if [ ! -f "README.md" ]; then
    REPO_NAME=$(basename "$(pwd)")
    cat > README.md << EOF
# ${REPO_NAME}

## Description

TODO: Add project description

## Installation

TODO: Add installation instructions

## Usage

TODO: Add usage instructions

## Contributing

Please read [SECURITY.md](SECURITY.md) for security guidelines.

## License

TODO: Add license information
EOF
    echo -e "${GREEN}  Created README.md${NC}"
else
    echo -e "${YELLOW}  README.md already exists, skipping${NC}"
fi

# =============================================================================
# Summary
# =============================================================================
echo ""
echo "========================================"
echo "              Setup Complete"
echo "========================================"
echo ""
echo "Files created/updated:"
echo "  - .gitignore"
echo "  - SECURITY.md"
echo "  - .github/CODEOWNERS"
echo "  - .github/dependabot.yml"
echo "  - .pre-commit-config.yaml"
[ -f ".github/workflows/ci.yml" ] && echo "  - .github/workflows/ci.yml"
echo "  - README.md"
echo ""
echo "========================================"
echo "              Next Steps"
echo "========================================"
echo ""
echo -e "${BLUE}1. Install pre-commit:${NC}"
echo "   pip install pre-commit"
echo "   pre-commit install"
echo ""
echo -e "${BLUE}2. Create secrets baseline:${NC}"
echo "   pip install detect-secrets"
echo "   detect-secrets scan > .secrets.baseline"
echo ""
echo -e "${BLUE}3. Update configuration files:${NC}"
echo "   - SECURITY.md: Update email address"
echo "   - CODEOWNERS: Update @your-username"
echo "   - dependabot.yml: Uncomment relevant ecosystems"
echo "   - pre-commit: Uncomment language-specific hooks"
echo ""
echo -e "${BLUE}4. Make initial commit:${NC}"
echo "   git add ."
echo "   git commit -m 'chore: initial security setup'"
echo ""
echo -e "${BLUE}5. Configure branch protection:${NC}"
echo "   gh api repos/{owner}/{repo}/branches/main/protection \\"
echo "     --method PUT \\"
echo "     -f required_status_checks='{\"strict\":true,\"contexts\":[\"ci\"]}' \\"
echo "     -f required_pull_request_reviews='{\"required_approving_review_count\":1}'"
echo ""
echo -e "${BLUE}6. Verify setup:${NC}"
echo "   bash $SCRIPT_DIR/audit-repo.sh"
echo ""
