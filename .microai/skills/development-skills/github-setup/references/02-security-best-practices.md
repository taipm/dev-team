# Security Best Practices

Comprehensive guide for securing GitHub repositories.

## Defense in Depth

Implement multiple layers of security:

```
Layer 1: Developer Machine
├── Pre-commit hooks (secret detection)
├── IDE extensions (security linting)
└── Local testing before push

Layer 2: Git Repository
├── .gitignore (prevent accidental commits)
├── Branch protection (require reviews)
└── CODEOWNERS (enforce ownership)

Layer 3: CI/CD Pipeline
├── Security scanning (SAST, DAST)
├── Dependency auditing
└── Container scanning

Layer 4: GitHub Platform
├── Dependabot (automated updates)
├── Secret scanning
└── Code scanning (CodeQL)

Layer 5: Runtime
├── Environment variables
├── Secret managers (Vault, AWS Secrets)
└── Least privilege access
```

## Secret Detection Tools

### detect-secrets (Yelp)

Best for: Baseline creation and incremental scanning

```bash
# Install
pip install detect-secrets

# Create baseline
detect-secrets scan > .secrets.baseline

# Update baseline (after review)
detect-secrets scan --baseline .secrets.baseline

# Audit findings
detect-secrets audit .secrets.baseline
```

### gitleaks

Best for: Pre-commit and CI integration

```bash
# Install
brew install gitleaks

# Scan current state
gitleaks detect -v

# Scan git history
gitleaks detect --source . --log-opts="--all"

# Create config
cat > .gitleaks.toml << EOF
[extend]
useDefault = true

[[rules]]
description = "Custom API Key"
regex = '''CUSTOM_[a-zA-Z0-9]{32}'''
tags = ["custom", "api"]
EOF
```

### trufflehog

Best for: Deep historical scanning

```bash
# Install
brew install trufflehog

# Scan repository
trufflehog git file://. --only-verified

# Scan with entropy checks
trufflehog filesystem . --include-detectors="all"
```

## Common Secret Patterns

| Type | Regex Pattern | Example |
|------|---------------|---------|
| AWS Access Key | `AKIA[0-9A-Z]{16}` | AKIAIOSFODNN7EXAMPLE |
| AWS Secret Key | `[0-9a-zA-Z/+]{40}` | wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY |
| GitHub Token | `gh[ps]_[a-zA-Z0-9]{36}` | ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
| GitHub OAuth | `gho_[a-zA-Z0-9]{36}` | gho_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
| Slack Token | `xox[baprs]-[0-9]{10,12}-[a-zA-Z0-9]{24}` | xoxb-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx |
| Private Key | `-----BEGIN.*PRIVATE KEY-----` | -----BEGIN RSA PRIVATE KEY----- |
| Generic API Key | `api_key[[:space:]]*=[[:space:]]*['\"][^'\"]+['\"]` | api_key = "abc123" |
| Generic Secret | `secret[[:space:]]*=[[:space:]]*['\"][^'\"]+['\"]` | secret = "xyz789" |
| Generic Password | `password[[:space:]]*=[[:space:]]*['\"][^'\"]+['\"]` | password = "hunter2" |

## Sensitive File Patterns

Files that should ALWAYS be in .gitignore:

```gitignore
# Environment files
.env
.env.*
.envrc

# Private keys
*.pem
*.key
*.p12
*.pfx
*.jks
*.keystore

# Credentials
credentials.json
service-account*.json
*_credentials.*
*.credential

# Cloud configs
.aws/
.gcloud/
.azure/
kubeconfig

# Database
*.sqlite
*.db
*.sql (sometimes)

# SSH
id_rsa
id_ecdsa
id_ed25519
known_hosts

# IDE with secrets
.idea/
.vscode/settings.json

# Logs with sensitive data
*.log
logs/
```

## Branch Protection Configuration

### Recommended Settings

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  -f required_status_checks='{
    "strict": true,
    "contexts": ["ci", "security"]
  }' \
  -f enforce_admins=false \
  -f required_pull_request_reviews='{
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false
  }' \
  -f restrictions=null \
  -f required_linear_history=false \
  -f allow_force_pushes=false \
  -f allow_deletions=false
```

### Settings Explained

| Setting | Recommendation | Why |
|---------|---------------|-----|
| `required_status_checks.strict` | `true` | Require branch to be up-to-date |
| `required_approving_review_count` | `1-2` | Balance security and velocity |
| `dismiss_stale_reviews` | `true` | Re-review after changes |
| `enforce_admins` | `false` | Allow emergency fixes |
| `allow_force_pushes` | `false` | Protect history |
| `allow_deletions` | `false` | Prevent accidental deletion |

## CI/CD Security Checklist

### Workflow Best Practices

```yaml
# Good: Pin actions to SHA
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1

# Avoid: Using mutable tags
- uses: actions/checkout@v4  # Can change

# Good: Minimal permissions
permissions:
  contents: read
  pull-requests: write

# Avoid: Default permissions (write-all)
```

### Secrets Handling

```yaml
# Good: Use secrets
env:
  API_KEY: ${{ secrets.API_KEY }}

# Good: Mask custom secrets
- run: echo "::add-mask::$CUSTOM_SECRET"

# Avoid: Echo secrets
- run: echo ${{ secrets.API_KEY }}  # Exposed in logs
```

### Dependency Security

```yaml
# Run security scans
- name: Security scan
  run: |
    # Go
    govulncheck ./...

    # Python
    pip-audit

    # Node
    npm audit --audit-level=high

    # Docker
    trivy image $IMAGE_NAME
```

## Incident Response

### Secret Exposed in Git History

1. **Immediately rotate the secret**
   ```bash
   # Generate new credentials in provider's console
   # Update secrets in GitHub Settings
   ```

2. **Remove from history (if recent)**
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/file" \
     --prune-empty --tag-name-filter cat -- --all
   git push origin --force --all
   ```

3. **Use BFG Repo-Cleaner (faster)**
   ```bash
   bfg --replace-text passwords.txt repo.git
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   git push --force
   ```

4. **Notify affected parties**

5. **Update monitoring**

### Secret in Active PR

1. Close the PR immediately
2. Delete the branch
3. Rotate the secret
4. Open new PR with clean history

## Security Audit Script

Quick security check:

```bash
#!/bin/bash
# Run: bash security-check.sh

echo "=== Security Quick Check ==="

# Check for secrets
echo "Checking for secrets..."
grep -rn "password\|secret\|api_key\|token" \
  --include="*.{go,py,js,ts,java}" \
  --exclude-dir={node_modules,vendor,.git} . 2>/dev/null | head -20

# Check .gitignore
echo "Checking .gitignore..."
for pattern in ".env" "*.pem" "*.key" "secret"; do
  if ! grep -q "$pattern" .gitignore 2>/dev/null; then
    echo "  Missing: $pattern"
  fi
done

# Check for .env files
echo "Checking for .env files..."
find . -name ".env*" -not -path "./node_modules/*" 2>/dev/null

echo "=== Done ==="
```
