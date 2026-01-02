# Free GitHub Features for Security

This document lists GitHub security features available for FREE on both public and private repositories.

## Feature Comparison Matrix

| Feature | Public Repos | Private Repos (Free) | How to Enable |
|---------|--------------|----------------------|---------------|
| .gitignore | Yes | Yes | Add file |
| Pre-commit hooks | Yes | Yes | Local tool |
| CODEOWNERS | Yes | Yes | Add file |
| README/SECURITY.md | Yes | Yes | Add file |
| Dependabot alerts | Yes | Yes | Settings > Security |
| Dependabot security updates | Yes | Yes | Settings > Security |
| Secret scanning (basic) | Yes | Limited patterns | Settings > Security |
| Secret scanning (push protection) | Yes | No (Enterprise only) | - |
| Branch protection (basic) | Yes | Yes | Settings > Branches |
| Branch protection (advanced) | Yes | No (Team/Enterprise) | - |
| GitHub Actions | 2000 min/mo | 2000 min/mo | Add workflows |
| Code scanning (CodeQL) | Yes | Limited | Settings > Security |

## Branch Protection: Free vs Paid

### Free Tier (Public & Private)

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  -f required_status_checks='{"strict":true,"contexts":["ci"]}' \
  -f required_pull_request_reviews='{"required_approving_review_count":1}'
```

Available:
- Require pull request before merging
- Require approvals (specify count)
- Require status checks to pass
- Require branches to be up to date
- Enforce admins (optional)

### Paid Only (Team/Enterprise)

- Require code owner reviews
- Restrict who can push to matching branches
- Require signed commits
- Require linear history
- Allow specified actors to bypass

## Secret Scanning Comparison

### Free (Public Repos)
- Scans for 100+ partner patterns (AWS, GitHub, Slack, etc.)
- Alerts repository admins
- Partner notification available

### Free (Private Repos)
- GitHub's own patterns only
- Basic detection

### Paid (GitHub Advanced Security)
- Custom patterns
- Push protection (blocks commits with secrets)
- Historical scanning
- Alert management

## Recommended Free Alternatives

### Secret Detection (Local, FREE)

Use pre-commit hooks with these tools:

1. **detect-secrets** (Yelp)
   ```bash
   pip install detect-secrets
   detect-secrets scan > .secrets.baseline
   ```

2. **gitleaks**
   ```bash
   brew install gitleaks
   gitleaks detect
   ```

3. **trufflehog**
   ```bash
   brew install trufflehog
   trufflehog git file://. --only-verified
   ```

### Code Scanning (FREE)

1. **CodeQL (GitHub's own)**
   - Free for public repos
   - Limited free for private repos
   - Create `.github/workflows/codeql.yml`

2. **Language-specific scanners in CI**
   - Go: `gosec`, `govulncheck`
   - Python: `bandit`, `pip-audit`
   - Node: `npm audit`
   - Java: `SpotBugs`, `OWASP Dependency-Check`

## Cost-Effective Security Strategy

### Tier 1: Essential (FREE)

1. `.gitignore` with sensitive patterns
2. Pre-commit hooks with gitleaks/detect-secrets
3. Basic branch protection
4. Dependabot enabled
5. CI with security scanning

### Tier 2: Enhanced (Still FREE)

1. CODEOWNERS for review requirements
2. SECURITY.md for vulnerability reporting
3. CodeQL for public repos
4. Signed commits (GPG setup)

### Tier 3: Enterprise (Paid)

1. Push protection for secrets
2. Custom secret patterns
3. Advanced branch protection
4. GitHub Advanced Security

## Enabling Free Features

### Dependabot

```bash
# Enable via UI: Settings > Security > Dependabot

# Or add config file:
cat > .github/dependabot.yml << EOF
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
EOF
```

### Basic Branch Protection

```bash
# Via GitHub CLI
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  -f required_status_checks='{"strict":true,"contexts":["ci"]}' \
  -f enforce_admins=false \
  -f required_pull_request_reviews='{"required_approving_review_count":1}' \
  -f restrictions=null
```

### Secret Scanning (Public Repos)

```bash
# Enable via UI: Settings > Security > Secret scanning

# Or via API
gh api repos/{owner}/{repo} \
  --method PATCH \
  -f security_and_analysis='{"secret_scanning":{"status":"enabled"}}'
```

## Summary

For private repositories on free tier:
1. **Use pre-commit hooks** for secret detection (local, always free)
2. **Enable Dependabot** for dependency updates
3. **Configure basic branch protection** for review requirements
4. **Add security scanning** in CI workflows
5. **Create SECURITY.md** for responsible disclosure
