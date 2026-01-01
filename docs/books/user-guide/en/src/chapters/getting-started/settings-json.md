# settings.json

Team-shared configuration for dev-team.

## Location

```
.claude/settings.json
```

## Structure

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)",
      "WebFetch(domain:github.com)"
    ],
    "deny": [
      "Read(.env)",
      "Bash(rm -rf:*)"
    ]
  }
}
```

## Permissions

### allow

Patterns allowed without confirmation:

```json
"allow": [
  "Bash(git:*)",        // All git commands
  "Bash(npm:*)",        // All npm commands
  "Read(**/*.go)",      // Read Go files
  "WebFetch(domain:X)"  // Fetch from domain X
]
```

### deny

Blocked patterns:

```json
"deny": [
  "Read(.env)",         // Don't read .env
  "Bash(rm -rf:*)"      // No recursive delete
]
```

## Examples

### Go Project

```json
{
  "permissions": {
    "allow": [
      "Bash(go:*)",
      "Bash(git:*)",
      "Read(**/*.go)"
    ]
  }
}
```

### Node.js Project

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(node:*)",
      "Bash(git:*)"
    ]
  }
}
```

## Notes

- This file is committed to git
- Team members share these settings
- Use `settings.local.json` for personal settings

## See Also

- [settings.local.json](./settings-local.md)
- [Directory Structure](./directory-structure.md)
