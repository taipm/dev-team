# Branch Protection API Reference

Complete guide for configuring branch protection via GitHub API.

## Prerequisites

```bash
# Install GitHub CLI
brew install gh

# Authenticate
gh auth login

# Verify authentication
gh auth status
```

## View Current Protection

```bash
# Get protection settings
gh api repos/{owner}/{repo}/branches/main/protection

# Pretty print
gh api repos/{owner}/{repo}/branches/main/protection | jq .
```

## Enable Protection

### Minimal Protection

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  -f required_pull_request_reviews='{"required_approving_review_count":1}'
```

### Standard Protection

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  -f required_status_checks='{"strict":true,"contexts":["ci"]}' \
  -f required_pull_request_reviews='{"required_approving_review_count":1}' \
  -f enforce_admins=false \
  -f restrictions=null
```

### Strict Protection

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  -f required_status_checks='{
    "strict": true,
    "contexts": ["lint", "test", "security"]
  }' \
  -f enforce_admins=true \
  -f required_pull_request_reviews='{
    "required_approving_review_count": 2,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false,
    "require_last_push_approval": false
  }' \
  -f restrictions=null \
  -f required_linear_history=true \
  -f allow_force_pushes=false \
  -f allow_deletions=false
```

## Remove Protection

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method DELETE
```

## Individual Settings

### Required Status Checks

```bash
# Enable strict status checks
gh api repos/{owner}/{repo}/branches/main/protection/required_status_checks \
  --method PATCH \
  -f strict=true \
  -f contexts='["ci", "test"]'

# Get current settings
gh api repos/{owner}/{repo}/branches/main/protection/required_status_checks
```

### Pull Request Reviews

```bash
# Update review requirements
gh api repos/{owner}/{repo}/branches/main/protection/required_pull_request_reviews \
  --method PATCH \
  -f required_approving_review_count=2 \
  -f dismiss_stale_reviews=true

# Get current settings
gh api repos/{owner}/{repo}/branches/main/protection/required_pull_request_reviews
```

### Enforce Admins

```bash
# Enable (admins must follow rules too)
gh api repos/{owner}/{repo}/branches/main/protection/enforce_admins \
  --method POST

# Disable
gh api repos/{owner}/{repo}/branches/main/protection/enforce_admins \
  --method DELETE
```

### Restrictions

```bash
# Restrict who can push (requires paid plan for private repos)
gh api repos/{owner}/{repo}/branches/main/protection/restrictions \
  --method PUT \
  -f users='["username1"]' \
  -f teams='["team-slug"]'

# Remove restrictions
gh api repos/{owner}/{repo}/branches/main/protection/restrictions \
  --method DELETE
```

## API Parameters Reference

### required_status_checks

| Parameter | Type | Description |
|-----------|------|-------------|
| `strict` | boolean | Require branch to be up to date before merging |
| `contexts` | array | Status checks that must pass (e.g., ["ci", "test"]) |

### required_pull_request_reviews

| Parameter | Type | Description | Free Tier |
|-----------|------|-------------|-----------|
| `required_approving_review_count` | integer | Number of approvals needed (1-6) | Yes |
| `dismiss_stale_reviews` | boolean | Dismiss approvals on new commits | Yes |
| `require_code_owner_reviews` | boolean | Require CODEOWNERS approval | No |
| `require_last_push_approval` | boolean | Last pusher can't self-approve | No |
| `dismissal_restrictions` | object | Who can dismiss reviews | No |
| `bypass_pull_request_allowances` | object | Who can bypass requirements | No |

### Top-level settings

| Parameter | Type | Description | Free Tier |
|-----------|------|-------------|-----------|
| `enforce_admins` | boolean | Apply rules to admins | Yes |
| `required_linear_history` | boolean | Require linear history | Yes |
| `allow_force_pushes` | boolean | Allow force pushes | Yes |
| `allow_deletions` | boolean | Allow branch deletion | Yes |
| `restrictions` | object | Restrict who can push | No |
| `required_signatures` | boolean | Require signed commits | No |

## Complete Example Script

```bash
#!/bin/bash
# setup-branch-protection.sh
# Usage: bash setup-branch-protection.sh owner/repo [branch]

REPO="${1:?Usage: $0 owner/repo [branch]}"
BRANCH="${2:-main}"

echo "Setting up branch protection for $REPO/$BRANCH"

gh api "repos/$REPO/branches/$BRANCH/protection" \
  --method PUT \
  --input - << 'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["ci"]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false
  },
  "restrictions": null,
  "required_linear_history": false,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF

echo "Done! Verifying..."
gh api "repos/$REPO/branches/$BRANCH/protection" | jq '{
  status_checks: .required_status_checks.strict,
  review_count: .required_pull_request_reviews.required_approving_review_count,
  enforce_admins: .enforce_admins.enabled,
  allow_force_pushes: .allow_force_pushes.enabled
}'
```

## Common Issues

### Error: Not Found

```bash
# Check if branch exists
gh api repos/{owner}/{repo}/branches

# Check if you have admin access
gh api repos/{owner}/{repo} | jq '.permissions'
```

### Error: Required status check not found

```bash
# First, push a commit that triggers the workflow
# Then the status check will be available

# Or use wildcard (if supported)
-f required_status_checks='{"strict":false,"contexts":[]}'
```

### Error: Cannot use feature on private repo

Some features require paid plans:
- `require_code_owner_reviews`: Team plan
- `restrictions`: Team plan
- `required_signatures`: Team plan
- `bypass_pull_request_allowances`: Enterprise

## Automation

### GitHub Actions Workflow

```yaml
name: Setup Branch Protection

on:
  push:
    branches: [main]
    paths: ['.github/branch-protection.json']

jobs:
  protect:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      admin: write  # Needed for branch protection

    steps:
      - uses: actions/checkout@v4

      - name: Apply protection
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          gh api repos/${{ github.repository }}/branches/main/protection \
            --method PUT \
            --input .github/branch-protection.json
```

### Config File

```json
// .github/branch-protection.json
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["lint", "test", "build"]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
```
