---
name: github-setup
description: |
  GitHub repository setup and security audit. Use when you need to:
  - Initialize a new repository with security best practices
  - Audit an existing repository for security gaps
  - Generate .gitignore, CI/CD workflows, CODEOWNERS, dependabot config
  - Setup pre-commit hooks for secret detection
  - Configure branch protection rules

  Triggers: github setup, repo setup, repository init, security audit,
  gitignore, GitHub Actions, CODEOWNERS, dependabot, SECURITY.md,
  pre-commit hooks, branch protection, secret scanning
license: apache-2.0
version: "1.0.0"
---

# GitHub Setup Skill

> Secure repository setup and security auditing with checklists and automation.

## Quick Start

**Choose your mode:**

| Mode | When to Use | Command |
|------|-------------|---------|
| **Setup** | New repository or adding security to existing | `*setup [language]` |
| **Audit** | Check existing repo for security gaps | `*audit` |
| **Template** | Generate specific config files | `*template [type]` |

## Mode 1: Initial Setup (`*setup`)

Run for new repositories or to add security to existing ones.

### Setup Checklist

```
Phase 1: Foundation (Required)
[ ] 1. Initialize git repository
[ ] 2. Create .gitignore (use templates/gitignore/{language}.gitignore)
[ ] 3. Add LICENSE file
[ ] 4. Create initial README.md

Phase 2: Security (Required)
[ ] 5. Create SECURITY.md (use templates/security/SECURITY.md)
[ ] 6. Setup pre-commit hooks for secret detection
      pip install pre-commit
      cp templates/hooks/pre-commit-config.yaml .pre-commit-config.yaml
      pre-commit install
[ ] 7. Configure CODEOWNERS (use templates/security/CODEOWNERS)
[ ] 8. Add .github/dependabot.yml

Phase 3: CI/CD (Recommended)
[ ] 9. Create .github/workflows/ directory
[ ] 10. Add CI workflow (templates/workflows/{language}-ci.yml)
[ ] 11. Add release workflow if needed

Phase 4: Branch Protection (Recommended)
[ ] 12. Push initial commit to main
[ ] 13. Configure branch protection:
        gh api repos/{owner}/{repo}/branches/main/protection \
          --method PUT \
          -f required_status_checks='{"strict":true,"contexts":["ci"]}' \
          -f enforce_admins=false \
          -f required_pull_request_reviews='{"required_approving_review_count":1}'

Phase 5: Verification
[ ] 14. Run: pre-commit run --all-files
[ ] 15. Push test branch and verify CI runs
[ ] 16. Check Dependabot creates PRs
```

### Quick Setup Script

```bash
# Run automated setup
bash scripts/setup-repo.sh [go|python|node] [repo-path]
```

## Mode 2: Security Audit (`*audit`)

Check existing repositories for security issues.

### Audit Checklist

```
Quick Audit
[ ] Run: bash scripts/audit-repo.sh

Manual Deep Audit

1. Secrets Exposure Check
[ ] Check for hardcoded secrets:
    grep -rn "password\|secret\|api_key\|token" --include="*.{go,py,js,ts}" .
[ ] Check git history for exposed secrets:
    git log -p --all | grep -E "(password|secret|api_key)" | head -50
[ ] Verify .gitignore covers sensitive files:
    cat .gitignore | grep -E "\.env|secret|credential|\.pem|\.key"

2. Access Control Review
[ ] CODEOWNERS file exists and is correct
[ ] Branch protection enabled:
    gh api repos/{owner}/{repo}/branches/main/protection
[ ] Required reviewers configured

3. Dependency Security
[ ] Dependabot configured: cat .github/dependabot.yml
[ ] Check open security PRs: gh pr list --label dependencies
[ ] Run vulnerability check:
    - Go: govulncheck ./...
    - Python: pip-audit
    - Node: npm audit

4. CI/CD Security
[ ] GitHub Actions workflows reviewed
[ ] No hardcoded secrets in workflows
[ ] Secrets use ${{ secrets.* }} format

5. Documentation
[ ] SECURITY.md exists with reporting process
[ ] README includes security notes

6. Pre-commit Hooks
[ ] .pre-commit-config.yaml exists
[ ] Secret detection hooks configured
```

## Mode 3: Templates (`*template`)

Generate specific configuration files.

### Available Templates

| Template | Description | Path |
|----------|-------------|------|
| `gitignore-go` | Go .gitignore | `templates/gitignore/go.gitignore` |
| `gitignore-python` | Python .gitignore | `templates/gitignore/python.gitignore` |
| `gitignore-node` | Node.js .gitignore | `templates/gitignore/node.gitignore` |
| `ci-go` | Go CI workflow | `templates/workflows/go-ci.yml` |
| `ci-python` | Python CI workflow | `templates/workflows/python-ci.yml` |
| `ci-node` | Node.js CI workflow | `templates/workflows/node-ci.yml` |
| `release` | Release workflow | `templates/workflows/release.yml` |
| `security` | SECURITY.md | `templates/security/SECURITY.md` |
| `codeowners` | CODEOWNERS | `templates/security/CODEOWNERS` |
| `dependabot` | Dependabot config | `templates/security/dependabot.yml` |
| `pre-commit` | Pre-commit hooks | `templates/hooks/pre-commit-config.yaml` |

### Usage

```bash
# Copy template to current directory
cp templates/gitignore/go.gitignore .gitignore
cp templates/workflows/go-ci.yml .github/workflows/ci.yml
cp templates/security/SECURITY.md SECURITY.md
```

## Security Features Summary

All features below are **FREE** for both public and private repositories:

| Feature | Tool | Local/Remote |
|---------|------|--------------|
| .gitignore | File | Local |
| Secret detection | detect-secrets, gitleaks | Local (pre-commit) |
| CODEOWNERS | File | GitHub |
| SECURITY.md | File | Local |
| Dependabot | GitHub config | GitHub (FREE) |
| Branch protection (basic) | GitHub API | GitHub (FREE) |
| CI/CD workflows | GitHub Actions | 2000 min/mo FREE |

### Pre-commit Hooks

Secret detection uses local tools (no GitHub dependency):

```yaml
# Key hooks in pre-commit-config.yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    hooks:
      - id: detect-secrets
  - repo: https://github.com/gitleaks/gitleaks
    hooks:
      - id: gitleaks
```

### Branch Protection via API

```bash
# Enable protection (FREE features)
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  -f required_status_checks='{"strict":true,"contexts":["ci"]}' \
  -f required_pull_request_reviews='{"required_approving_review_count":1}'

# View current protection
gh api repos/{owner}/{repo}/branches/main/protection

# Remove protection
gh api repos/{owner}/{repo}/branches/main/protection --method DELETE
```

## CI/CD Workflows

Each workflow includes: lint, test, security scan, build.

### Go Workflow Features
- **Lint**: golangci-lint
- **Test**: go test with coverage
- **Security**: govulncheck, gosec
- **Build**: go build

### Python Workflow Features
- **Lint**: ruff, mypy
- **Test**: pytest with coverage
- **Security**: pip-audit, bandit
- **Build**: (optional)

### Node.js Workflow Features
- **Lint**: eslint
- **Test**: jest/vitest with coverage
- **Security**: npm audit
- **Build**: npm run build

## Scripts

### audit-repo.sh
Automated security audit with colored output:
```bash
bash scripts/audit-repo.sh [repo-path]
```

Checks:
- .gitignore exists and covers sensitive files
- SECURITY.md exists
- CODEOWNERS configured
- Dependabot configured
- GitHub Actions present
- Pre-commit hooks configured
- No obvious secrets in code
- Branch protection status

### setup-repo.sh
Automated repository setup:
```bash
bash scripts/setup-repo.sh [go|python|node] [repo-path]
```

Creates:
- .gitignore for specified language
- SECURITY.md
- .github/CODEOWNERS
- .github/dependabot.yml
- .pre-commit-config.yaml
- .github/workflows/ci.yml

## References

- `references/01-free-github-features.md` - What's free vs paid
- `references/02-security-best-practices.md` - Security deep dive
- `references/03-branch-protection-api.md` - API documentation

## Best Practices

1. **Always** add .env to .gitignore BEFORE creating .env files
2. **Install** pre-commit hooks immediately after cloning
3. **Review** CODEOWNERS when team changes
4. **Check** Dependabot PRs weekly
5. **Update** SECURITY.md contact when team changes
6. **Rotate** secrets if any exposure detected
