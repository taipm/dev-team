# Submitting Pull Request

Hướng dẫn đóng góp code vào dev-team.

---

## Quy trình

### 1. Fork Repository

Vào https://github.com/taipm/dev-team và click "Fork".

### 2. Clone Fork

```bash
git clone https://github.com/YOUR_USERNAME/dev-team.git
cd dev-team
```

### 3. Add Upstream

```bash
git remote add upstream https://github.com/taipm/dev-team.git
```

### 4. Create Branch

```bash
git checkout -b feature/my-feature
```

Naming convention:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `refactor/` - Code restructuring

### 5. Make Changes

Follow [Code Style](./code-style.md).

### 6. Commit

```bash
git add .
git commit -m "feat: add new feature"
```

### 7. Push

```bash
git push origin feature/my-feature
```

### 8. Create Pull Request

1. Go to your fork on GitHub
2. Click "Compare & pull request"
3. Fill in PR template
4. Submit

---

## PR Template

```markdown
## Summary
Brief description of changes.

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Documentation
- [ ] Refactoring

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Tests pass locally
- [ ] No breaking changes

## Related Issues
Fixes #123
```

---

## Commit Messages

### Format

```
<type>: <short description>

[optional body]

[optional footer]
```

### Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no logic change |
| `refactor` | Code restructure |
| `test` | Adding tests |
| `chore` | Maintenance |

### Examples

```
feat: add go-review agent with Linus style

Add new agent for Go code review with
brutally honest feedback style.

Closes #42
```

```
fix: correct hook script permissions

chmod +x was not being applied during install.
```

---

## Review Process

### What Reviewers Check

1. **Code quality** - Clean, readable code
2. **Tests** - Changes tested locally
3. **Documentation** - README/docs updated
4. **Breaking changes** - Backwards compatibility
5. **Style** - Follows conventions

### Responding to Feedback

1. Address all comments
2. Push fixes to same branch
3. Reply to comments when resolved
4. Request re-review

---

## Types of Contributions

### Adding New Agent

1. Create agent file in `templates/.microai/agents/`
2. Follow [Agent Specification](../reference/agent-spec.md)
3. Add to `docs/agents/built-in-agents.md`
4. Test with Claude Code

### Adding New Hook

1. Create script in `templates/.microai/hooks/`
2. Make executable
3. Update `templates/.microai/hooks.json`
4. Document in `docs/guides/using-hooks.md`

### Fixing Bugs

1. Create issue first (if not exists)
2. Reference issue in PR
3. Add regression test if possible

### Improving Documentation

1. Fix typos, broken links
2. Add missing information
3. Improve clarity

---

## After Merge

### Sync Fork

```bash
git checkout main
git fetch upstream
git merge upstream/main
git push origin main
```

### Delete Branch

```bash
git branch -d feature/my-feature
git push origin --delete feature/my-feature
```

---

## Getting Help

- **Questions**: Open issue with "question" label
- **Bugs**: Open issue with "bug" label
- **Features**: Open issue with "enhancement" label

---

## Code of Conduct

- Be respectful
- Constructive feedback only
- Welcome newcomers
- Focus on the code, not the person

---

## Tiếp theo

- [Development Setup](./development-setup.md)
- [Code Style](./code-style.md)
