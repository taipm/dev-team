# Git Push Skill Activation

Safe git workflow with integrated security checks (git-check).

<skill-activation>

## Load Skill

READ the skill documentation from: `.microai/skills/development-skills/git-push/SKILL.md`

## Workflow

Execute the 4-phase git-push workflow:

### Phase 1: Security Check (git-check)

Run integrated security checks:

```bash
# Run git-check script
./.microai/skills/development-skills/git-push/scripts/git-check.sh
```

If checks fail -> STOP and display issues
If checks pass -> Continue to Phase 2

### Phase 2: Staging (git-add)

1. Show current git status
2. Display unstaged changes
3. Ask user which files to stage (all/modified/select)
4. Stage selected files
5. Show staged changes summary

### Phase 3: Commit (git-commit)

1. Analyze staged changes
2. Suggest conventional commit message based on:
   - File types modified
   - Nature of changes (add/modify/delete)
3. Ask user to confirm or modify message
4. Create commit with message

### Phase 4: Push (git-push)

1. Check remote configuration
2. Detect if upstream is set
3. Push changes
4. Display success message with commit URL

## Arguments

If arguments provided: $ARGUMENTS

Use as commit message (skip message suggestion phase)

## Security Rules

- NEVER bypass security checks
- NEVER force push without explicit user confirmation
- NEVER push .env files or secrets
- ALWAYS run git-check before any push operation

## Integration

For full security audit: `/microai:github-setup audit`
For repository setup: `/microai:github-setup setup`

</skill-activation>

ARGUMENTS: $ARGUMENTS
