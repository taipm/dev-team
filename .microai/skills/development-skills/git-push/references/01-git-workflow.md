# Git Workflow Best Practices

Reference guide for safe and efficient git operations.

## Conventional Commits

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(auth): add OAuth2 login` |
| `fix` | Bug fix | `fix(api): resolve timeout issue` |
| `docs` | Documentation | `docs: update README` |
| `style` | Formatting | `style: fix indentation` |
| `refactor` | Code restructure | `refactor: extract helper function` |
| `test` | Tests | `test: add unit tests for auth` |
| `chore` | Maintenance | `chore: update dependencies` |
| `perf` | Performance | `perf: optimize database query` |
| `ci` | CI/CD | `ci: add GitHub Actions workflow` |
| `build` | Build system | `build: update webpack config` |
| `revert` | Revert commit | `revert: revert "feat: add login"` |

### Scope

Optional context for the change:
- `auth`, `api`, `ui`, `db`, `config`, etc.
- Module or component name
- File or directory name

### Breaking Changes

Use `!` after type/scope or add `BREAKING CHANGE:` in footer:

```
feat(api)!: change response format

BREAKING CHANGE: API now returns JSON instead of XML
```

## Git Commands Reference

### Staging

```bash
# Stage all changes
git add .

# Stage specific files
git add file1.go file2.go

# Stage modified files only (no new files)
git add -u

# Interactive staging
git add -p

# Unstage file
git reset HEAD <file>
```

### Committing

```bash
# Commit with message
git commit -m "feat: add feature"

# Commit with body
git commit -m "feat: add feature" -m "Detailed description"

# Amend last commit (before push only)
git commit --amend

# Empty commit (for triggering CI)
git commit --allow-empty -m "chore: trigger CI"
```

### Pushing

```bash
# Push to remote
git push

# Push and set upstream
git push -u origin <branch>

# Push tags
git push --tags

# Force push (DANGEROUS)
git push --force  # Overwrites remote history

# Force push with lease (safer)
git push --force-with-lease  # Fails if remote has new commits
```

### Branching

```bash
# Create branch
git checkout -b feature/new-feature

# Switch branch
git checkout main

# Delete branch
git branch -d feature/old-feature

# Delete remote branch
git push origin --delete feature/old-feature
```

## Force Push Guidelines

### When Force Push is Acceptable

1. Personal feature branch (not shared)
2. After interactive rebase
3. Cleaning up commits before merge
4. Fixing a broken commit (immediately after)

### When Force Push is NEVER Acceptable

1. `main` or `master` branch
2. Shared branches with collaborators
3. Protected branches
4. After PR has been reviewed

### Safe Force Push

```bash
# Use --force-with-lease instead of --force
git push --force-with-lease

# This fails if someone else pushed to the branch
```

## Pre-push Checklist

Before every push, verify:

- [ ] All tests pass
- [ ] No debug code or console.log
- [ ] No hardcoded secrets
- [ ] No .env files staged
- [ ] Commit messages follow convention
- [ ] Changes are in correct branch
- [ ] Remote is correct (origin/fork)

## Handling Secrets

### If You Accidentally Committed a Secret

1. **Do NOT push** (if not pushed yet)
   ```bash
   git reset HEAD~1
   # Remove secret, commit again
   ```

2. **If already pushed:**
   - Revoke/rotate the secret immediately
   - Use BFG Repo-Cleaner or git filter-branch
   - Force push (if allowed)
   - Contact security team

### Prevention

```bash
# Install pre-commit
pip install pre-commit

# Add gitleaks hook
# In .pre-commit-config.yaml:
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.1
    hooks:
      - id: gitleaks
```

## Branch Protection Rules

Recommended for `main`:

- Require pull request reviews
- Require status checks to pass
- Require branches to be up to date
- Include administrators
- Restrict force pushes
- Restrict deletions

Configure via GitHub Settings > Branches > Add rule.

## Common Issues

### Diverged Branches

```bash
# Option 1: Merge (preserves history)
git pull origin main

# Option 2: Rebase (cleaner history)
git pull --rebase origin main

# Option 3: Reset (lose local changes)
git reset --hard origin/main
```

### Undo Last Commit

```bash
# Keep changes staged
git reset --soft HEAD~1

# Keep changes unstaged
git reset HEAD~1

# Discard changes completely
git reset --hard HEAD~1
```

### Stash Changes

```bash
# Save current changes
git stash

# Apply stashed changes
git stash pop

# List stashes
git stash list

# Apply specific stash
git stash apply stash@{0}
```
