---
description: "GitHub repository setup and security audit - secure repo configuration"
argument-hint: "[setup|audit] [language]"
---

# GitHub Setup Skill Activation

Load and execute the github-setup skill for repository security configuration.

<activation>
  <step n="1">LOAD the skill from @.microai/skills/development-skills/github-setup/SKILL.md</step>
  <step n="2">READ and UNDERSTAND all templates and references</step>
  <step n="3">EXECUTE based on user command (setup/audit)</step>
</activation>

## Quick Commands

| Command | Description |
|---------|-------------|
| `*setup go` | Setup new Go repository with security |
| `*setup python` | Setup new Python repository |
| `*setup node` | Setup new Node.js repository |
| `*audit` | Audit existing repository security |
| `*template gitignore-go` | Generate Go .gitignore |
| `*template ci-python` | Generate Python CI workflow |

## Arguments

- `setup [go|python|node]` - Initialize repository with templates
- `audit` - Run security audit on current repository
- No args - Show menu and wait for command

## Available Templates

### .gitignore
- `templates/gitignore/go.gitignore`
- `templates/gitignore/python.gitignore`
- `templates/gitignore/node.gitignore`

### CI/CD Workflows
- `templates/workflows/go-ci.yml`
- `templates/workflows/python-ci.yml`
- `templates/workflows/node-ci.yml`
- `templates/workflows/release.yml`

### Security
- `templates/security/SECURITY.md`
- `templates/security/CODEOWNERS`
- `templates/security/dependabot.yml`
- `templates/hooks/pre-commit-config.yaml`

## Scripts

- `scripts/audit-repo.sh` - Automated security audit
- `scripts/setup-repo.sh` - Automated repository setup

## References

- `references/01-free-github-features.md`
- `references/02-security-best-practices.md`
- `references/03-branch-protection-api.md`
