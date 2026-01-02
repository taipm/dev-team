---
name: git-push
description: "Safe git workflow with integrated security checks. Use when: git push, commit and push, safe push, push with check, git-check, security push. Runs pre-commit hooks and secret scanning before allowing push."
description_vi: "Git workflow an toan voi kiem tra bao mat tich hop. Su dung khi: git push, commit va push, push an toan, push voi kiem tra. Chay pre-commit hooks va quet secrets truoc khi cho phep push."
version: "1.0.0"
license: apache-2.0
tags: [git, push, commit, add, security, pre-commit, secret-detection, gitleaks, workflow]
category: development-skills
created: "2026-01-02"
author: MicroAI Team
---

# Git Push Skill

> Safe git workflow with integrated security checks (git-check).

## Quick Start

```bash
# Invoke the skill
/microai:git-push

# Or with specific message
/microai:git-push "feat: add new feature"
```

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    GIT-PUSH WORKFLOW                            │
├─────────────────────────────────────────────────────────────────┤
│  Phase 1: git-check (Security)                                  │
│  ├── Pre-commit hooks (gitleaks, detect-private-key)           │
│  ├── Quick secret pattern scan                                  │
│  ├── .env file detection in staging                            │
│  └── .gitignore coverage validation                            │
│                                                                  │
│  Phase 2: git-add (Staging)                                     │
│  ├── Show unstaged changes                                      │
│  ├── User selects files to stage                               │
│  └── Confirm staged changes                                     │
│                                                                  │
│  Phase 3: git-commit (Commit)                                   │
│  ├── Suggest conventional commit message                        │
│  ├── User confirms or modifies message                         │
│  └── Create commit                                              │
│                                                                  │
│  Phase 4: git-push (Push)                                       │
│  ├── Detect remote branch                                       │
│  ├── Set upstream if needed                                     │
│  └── Push changes                                               │
└─────────────────────────────────────────────────────────────────┘
```

## Phase 1: git-check (Integrated Security)

### What It Checks

| Check | Description | Blocking |
|-------|-------------|----------|
| Pre-commit hooks | Runs installed pre-commit hooks | Yes |
| Secret patterns | Scans for AWS keys, API tokens, private keys | Yes |
| .env files | Detects .env files in staged changes | Yes |
| .gitignore | Validates sensitive patterns coverage | Warning |

### Security Patterns Detected

```regex
# AWS Keys
AKIA[0-9A-Z]{16}
aws_secret_access_key\s*=\s*[A-Za-z0-9/+=]{40}

# GitHub Tokens
ghp_[A-Za-z0-9]{36}
github_pat_[A-Za-z0-9]{22}_[A-Za-z0-9]{59}

# Generic API Keys
api[_-]?key\s*[:=]\s*['"][A-Za-z0-9]{20,}['"]
secret[_-]?key\s*[:=]\s*['"][A-Za-z0-9]{20,}['"]

# Private Keys
-----BEGIN (RSA |DSA |EC |OPENSSH )?PRIVATE KEY-----
```

### Exit Behavior

- **PASS**: All checks pass -> Continue to Phase 2
- **FAIL**: Any blocking check fails -> Stop workflow, show issues
- **No bypass**: Security is non-negotiable

## Phase 2: git-add (Staging)

### Workflow

1. Show current git status
2. Display unstaged changes with diff summary
3. Ask user which files to stage:
   - `all` - Stage all changes
   - `modified` - Only modified files
   - `select` - Interactive selection
4. Show final staged files for confirmation

### Commands Used

```bash
git status --porcelain
git diff --stat
git add <files>
git diff --cached --stat
```

## Phase 3: git-commit (Commit)

### Conventional Commit Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructure
- `test`: Tests
- `chore`: Maintenance

### AI-Suggested Message

Based on staged changes, suggest a commit message:

```bash
# Analyze staged files
git diff --cached --name-only
git diff --cached --stat

# Generate suggestion based on:
# - File types changed
# - Number of files
# - Nature of changes (add/modify/delete)
```

### Commands Used

```bash
git commit -m "<message>"
```

## Phase 4: git-push (Push)

### Pre-push Checks

1. Verify remote exists
2. Check current branch
3. Detect if upstream is set

### Push Options

```bash
# Normal push
git push

# Set upstream (first push)
git push -u origin <branch>

# Force push (BLOCKED by default)
# Requires explicit --force flag and confirmation
```

### Force Push Protection

Force push to `main`/`master` is **always blocked** unless:
1. User explicitly passes `--force` flag
2. User confirms with "I understand the risks"
3. Branch is not protected

## Integration with github-setup

This skill references `github-setup` for extended capabilities:

### When to Use github-setup

| Scenario | Command |
|----------|---------|
| Full security audit | `/microai:github-setup audit` |
| Setup new repository | `/microai:github-setup setup` |
| Configure pre-commit | `/microai:github-setup` |
| Branch protection | `/microai:github-setup` |

### Shared Resources

- `.gitignore` templates from github-setup
- Pre-commit configuration patterns
- Security best practices reference

## Scripts

### git-check.sh

Location: `./scripts/git-check.sh`

Quick security check script that:
- Runs pre-commit hooks
- Scans for secrets in staged files
- Validates .gitignore coverage
- Returns exit code 0 (pass) or 1 (fail)

## Usage Examples

### Basic Push

```bash
User: /microai:git-push

Agent:
╔═══════════════════════════════════════════════════════════════╗
║              🚀 GIT-PUSH v1.0                                  ║
║           Safe Git Workflow with Security Check                ║
╠═══════════════════════════════════════════════════════════════╣
║  Phase 1: Security Check                                       ║
║  ✅ Pre-commit hooks: PASSED                                   ║
║  ✅ Secret scan: No secrets found                              ║
║  ✅ .env files: None in staging                                ║
║                                                                 ║
║  Phase 2: Staged Changes                                        ║
║  📄 src/main.go (+45, -12)                                     ║
║  📄 README.md (+10, -2)                                        ║
║                                                                 ║
║  Suggested commit: "feat: add user authentication"             ║
║                                                                 ║
║  Proceed with commit and push? [Y/n]                           ║
╚═══════════════════════════════════════════════════════════════╝
```

### With Custom Message

```bash
User: /microai:git-push "fix: resolve login timeout issue"

Agent:
✅ Security check passed
✅ Changes staged (2 files)
✅ Committed: fix: resolve login timeout issue
✅ Pushed to origin/main
```

### Security Block

```bash
User: /microai:git-push

Agent:
╔═══════════════════════════════════════════════════════════════╗
║              🚀 GIT-PUSH v1.0                                  ║
╠═══════════════════════════════════════════════════════════════╣
║  Phase 1: Security Check                                       ║
║  ❌ BLOCKED: Security issues found                             ║
║                                                                 ║
║  Issues:                                                        ║
║  1. 🔑 Potential AWS key in config/aws.json:15                 ║
║     Pattern: AKIA...                                           ║
║                                                                 ║
║  2. 📄 .env file staged for commit                             ║
║     File: .env                                                  ║
║                                                                 ║
║  Action Required:                                               ║
║  - Remove secrets from staged files                            ║
║  - Add .env to .gitignore                                      ║
║  - Run /microai:github-setup audit for full check              ║
╚═══════════════════════════════════════════════════════════════╝
```

## Best Practices

### Before Using This Skill

1. Ensure pre-commit is installed: `pip install pre-commit`
2. Install hooks: `pre-commit install`
3. Run initial audit: `/microai:github-setup audit`

### Recommended .gitignore Patterns

```gitignore
# Environment
.env
.env.*
*.local

# Secrets
*.pem
*.key
*.p12
credentials/
secrets/

# IDE
.idea/
.vscode/
*.swp
```

## References

- [Git Workflow Best Practices](./references/01-git-workflow.md)
- [GitHub Setup Skill](../github-setup/SKILL.md)
- [Security Best Practices](../github-setup/references/02-security-best-practices.md)
