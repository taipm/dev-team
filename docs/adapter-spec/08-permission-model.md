# 08 - Permission Model | Mô hình quyền hạn

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

The Permission Model provides **security controls** for tool execution, preventing unauthorized file access, dangerous commands, and network requests.

Mô hình Permission cung cấp **kiểm soát bảo mật** cho việc thực thi tool, ngăn chặn truy cập file trái phép, lệnh nguy hiểm và request mạng.

---

## Configuration Files | Các file cấu hình

### Inheritance Chain | Chuỗi kế thừa

```
┌─────────────────────────────────────────────────────────────┐
│ LEVEL 1: Team/Project Settings (Shared)                     │
│ ═══════════════════════════════════════                     │
│ File: .{platform}/settings.json                            │
│ Scope: Applied to all team members                          │
│ Phạm vi: Áp dụng cho tất cả thành viên                     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ LEVEL 2: Local Settings (Personal Override)                 │
│ ═══════════════════════════════════════════                 │
│ File: .{platform}/settings.local.json                      │
│ Scope: Personal overrides, not committed                    │
│ Phạm vi: Override cá nhân, không commit                    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ LEVEL 3: Agent Restrictions                                 │
│ ═══════════════════════════                                 │
│ File: agent.md (tools: [...] in frontmatter)               │
│ Scope: Agent-specific tool restrictions                     │
│ Phạm vi: Giới hạn tool cho agent cụ thể                    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ FINAL: Effective Permissions                                │
│ ════════════════════════════                                │
│ = Intersection of all levels                                │
│ = Giao của tất cả các level                                │
└─────────────────────────────────────────────────────────────┘
```

---

## settings.json Schema | Schema settings.json

### Complete Schema | Schema đầy đủ

```json
{
  "$schema": "https://microai.dev/schemas/settings.v1.json",

  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)",
      "Bash(go:*)",
      "Read(**/*.go)",
      "Read(**/*.md)",
      "Edit(src/**)",
      "WebFetch(domain:github.com)"
    ],
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(secrets/**)",
      "Read(**/*.pem)",
      "Read(**/*.key)",
      "Bash(rm -rf:*)",
      "Bash(sudo:*)",
      "Write(.env)"
    ]
  },

  "enabledPlugins": {
    "plugin-id-1": true,
    "plugin-id-2": true
  },

  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@some/mcp-server"]
    }
  },

  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "UserPromptSubmit": [...]
  },

  "model": {
    "default": "sonnet",
    "maxTokens": 8192
  }
}
```

### Permissions Section | Phần permissions

```json
{
  "permissions": {
    "allow": [
      // Patterns for explicitly allowed operations
      // Các pattern cho thao tác được cho phép rõ ràng
    ],
    "deny": [
      // Patterns for explicitly denied operations (takes precedence)
      // Các pattern cho thao tác bị từ chối (ưu tiên cao hơn)
    ]
  }
}
```

---

## Permission Pattern Syntax | Cú pháp pattern quyền hạn

### Basic Syntax | Cú pháp cơ bản

```
Tool(pattern)

Where:
- Tool: Tool name (Read, Write, Edit, Bash, WebFetch, etc.)
- pattern: Match pattern for tool argument
```

### Pattern Types | Các loại pattern

#### 1. Exact Match | Khớp chính xác

```json
"Bash(git status)"          // Only 'git status'
"Read(.gitignore)"          // Only .gitignore file
```

#### 2. Prefix Match (with :*) | Khớp prefix

```json
"Bash(git:*)"               // git status, git commit, git push, etc.
"Bash(npm:*)"               // npm install, npm run, npm test, etc.
"Bash(go:*)"                // go build, go test, go run, etc.
```

#### 3. Glob Pattern | Pattern Glob

```json
"Read(**/*.go)"             // All Go files anywhere
"Read(src/**)"              // Everything in src/
"Edit(*.md)"                // Markdown files in root
"Write(tests/**/*.ts)"      // TypeScript files in tests/
```

#### 4. Domain Pattern | Pattern domain

```json
"WebFetch(domain:github.com)"       // github.com only
"WebFetch(domain:*.anthropic.com)"  // Any anthropic.com subdomain
```

### Pattern Examples | Ví dụ pattern

```json
{
  "permissions": {
    "allow": [
      // Shell commands | Lệnh shell
      "Bash(git:*)",                  // All git commands
      "Bash(npm:*)",                  // All npm commands
      "Bash(go:*)",                   // All go commands
      "Bash(make:*)",                 // All make commands
      "Bash(docker:*)",               // All docker commands
      "Bash(kubectl:*)",              // All kubectl commands

      // File reading | Đọc file
      "Read(**/*.go)",                // Go source files
      "Read(**/*.md)",                // Markdown files
      "Read(**/*.yaml)",              // YAML configs
      "Read(**/*.json)",              // JSON files
      "Read(src/**)",                 // Everything in src/
      "Read(docs/**)",                // Everything in docs/

      // File editing | Sửa file
      "Edit(src/**)",                 // Edit source files
      "Edit(**/*.go)",                // Edit Go files
      "Edit(**/*.md)",                // Edit markdown

      // File writing | Ghi file
      "Write(src/**)",                // Write in src/
      "Write(tests/**)",              // Write tests

      // Web access | Truy cập web
      "WebFetch(domain:github.com)",
      "WebFetch(domain:go.dev)",
      "WebFetch(domain:pkg.go.dev)",

      // Search | Tìm kiếm
      "WebSearch"                     // Allow web search
    ],

    "deny": [
      // Sensitive files | File nhạy cảm
      "Read(.env)",                   // Environment files
      "Read(.env.*)",                 // Environment variants
      "Read(secrets/**)",             // Secrets directory
      "Read(**/*.pem)",               // Certificates
      "Read(**/*.key)",               // Private keys
      "Read(**/*secret*)",            // Files with 'secret' in name
      "Read(**/*credential*)",        // Credential files
      "Read(**/*password*)",          // Password files

      // Dangerous commands | Lệnh nguy hiểm
      "Bash(rm -rf:*)",               // Recursive force delete
      "Bash(sudo:*)",                 // Superuser commands
      "Bash(chmod 777:*)",            // Overly permissive chmod
      "Bash(curl | sh)",              // Pipe to shell
      "Bash(wget | sh)",              // Pipe to shell

      // Write protection | Bảo vệ ghi
      "Write(.env)",                  // Don't write .env
      "Write(.git/**)",               // Don't modify .git
      "Write(node_modules/**)",       // Don't modify dependencies
      "Write(vendor/**)"              // Don't modify vendor
    ]
  }
}
```

---

## Permission Resolution | Phân giải quyền hạn

### Resolution Algorithm | Thuật toán phân giải

```python
def check_permission(tool: str, param: str, settings: Settings) -> PermissionResult:
    """
    Check if tool operation is permitted.
    Kiểm tra thao tác tool có được phép không.
    """
    # 1. Check DENY list first (deny takes precedence)
    # Kiểm tra danh sách DENY trước (deny ưu tiên cao hơn)
    for pattern in settings.permissions.deny:
        if matches(tool, param, pattern):
            return PermissionResult(
                allowed=False,
                reason=f"Denied by pattern: {pattern}"
            )

    # 2. Check ALLOW list
    # Kiểm tra danh sách ALLOW
    for pattern in settings.permissions.allow:
        if matches(tool, param, pattern):
            return PermissionResult(
                allowed=True,
                reason=f"Allowed by pattern: {pattern}"
            )

    # 3. Not in either list - use platform default
    # Không có trong cả hai - dùng mặc định của platform
    return PermissionResult(
        allowed=settings.platform_default,
        reason="Using platform default behavior"
    )


def matches(tool: str, param: str, pattern: str) -> bool:
    """
    Check if tool+param matches permission pattern.
    Kiểm tra tool+param có khớp pattern không.
    """
    # Parse pattern: Tool(match)
    match = re.match(r"(\w+)\((.+)\)", pattern)
    if not match:
        return False

    pattern_tool = match.group(1)
    pattern_match = match.group(2)

    # Tool must match
    if pattern_tool != tool:
        return False

    # Check parameter match
    if pattern_match.endswith(":*"):
        # Prefix match
        prefix = pattern_match[:-2]
        return param.startswith(prefix)
    elif "*" in pattern_match:
        # Glob match
        return fnmatch(param, pattern_match)
    elif pattern_match.startswith("domain:"):
        # Domain match
        domain = pattern_match[7:]
        return matches_domain(param, domain)
    else:
        # Exact match
        return param == pattern_match
```

### Resolution Flow | Luồng phân giải

```
Input: Read(.env.local)

┌─────────────────────────────────────────────────────────────┐
│ STEP 1: Check DENY list                                     │
│ ════════════════════════                                    │
│ Pattern: Read(.env.*)                                       │
│ Match: .env.local matches .env.*                           │
│ Result: DENIED ❌                                           │
└─────────────────────────────────────────────────────────────┘

Input: Read(src/main.go)

┌─────────────────────────────────────────────────────────────┐
│ STEP 1: Check DENY list                                     │
│ ════════════════════════                                    │
│ No patterns match src/main.go                              │
│ Continue to ALLOW check...                                  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 2: Check ALLOW list                                    │
│ ═════════════════════════                                   │
│ Pattern: Read(**/*.go)                                      │
│ Match: src/main.go matches **/*.go                         │
│ Result: ALLOWED ✅                                          │
└─────────────────────────────────────────────────────────────┘
```

---

## settings.local.json | Cấu hình cục bộ

### Purpose | Mục đích

Personal overrides that shouldn't be committed to version control.

Override cá nhân không nên commit vào version control.

### Merge Strategy | Chiến lược merge

```python
def merge_settings(team: Settings, local: Settings) -> Settings:
    """
    Merge team and local settings.
    Merge settings team và local.
    """
    merged = Settings()

    # Permissions: local extends team (not replaces)
    # Permissions: local mở rộng team (không thay thế)
    merged.permissions.allow = team.permissions.allow + local.permissions.allow
    merged.permissions.deny = team.permissions.deny + local.permissions.deny

    # Plugins: local overrides team
    # Plugins: local ghi đè team
    merged.enabledPlugins = {**team.enabledPlugins, **local.enabledPlugins}

    # MCP Servers: local extends team
    merged.mcpServers = {**team.mcpServers, **local.mcpServers}

    # Hooks: local extends team
    merged.hooks = merge_hooks(team.hooks, local.hooks)

    return merged
```

### Example | Ví dụ

```json
// settings.json (committed, team-shared)
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Read(**/*.go)"
    ],
    "deny": [
      "Read(.env)"
    ]
  }
}

// settings.local.json (not committed, personal)
{
  "permissions": {
    "allow": [
      "Bash(docker:*)",      // Personal: allow docker
      "Read(secrets/dev.yaml)" // Personal: allow dev secrets
    ],
    "deny": [
      "Read(secrets/prod.yaml)" // Personal: extra deny
    ]
  }
}

// Effective permissions (merged)
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Read(**/*.go)",
      "Bash(docker:*)",
      "Read(secrets/dev.yaml)"
    ],
    "deny": [
      "Read(.env)",
      "Read(secrets/prod.yaml)"
    ]
  }
}
```

---

## Agent-Level Restrictions | Giới hạn cấp Agent

### In agent.md Frontmatter | Trong frontmatter agent.md

```yaml
---
name: 'read-only-reviewer'
description: 'Code reviewer that can only read files'
tools:
  - Read
  - Grep
  - Glob
  # Note: No Write, Edit, or Bash - this agent can only read
---
```

### Restriction Application | Áp dụng giới hạn

```python
def get_agent_permissions(agent: Agent, settings: Settings) -> Permissions:
    """
    Get effective permissions for an agent.
    Lấy permissions có hiệu lực cho agent.
    """
    # Start with global settings
    permissions = settings.permissions.copy()

    # If agent specifies tools, restrict to those tools only
    if agent.tools:
        allowed_tools = set(agent.tools)

        # Filter allow list to only include agent's tools
        permissions.allow = [
            p for p in permissions.allow
            if get_tool_from_pattern(p) in allowed_tools
        ]

        # Add implicit deny for unlisted tools
        all_tools = {"Read", "Write", "Edit", "Glob", "Grep", "Bash",
                     "WebFetch", "WebSearch", "TodoWrite", "LSP", "AskUserQuestion"}
        denied_tools = all_tools - allowed_tools

        for tool in denied_tools:
            permissions.deny.append(f"{tool}(*)")

    return permissions
```

---

## Security Best Practices | Thực hành bảo mật tốt nhất

### 1. Deny by Default for Sensitive Operations | Từ chối mặc định cho thao tác nhạy cảm

```json
{
  "permissions": {
    "deny": [
      // Always deny these patterns
      "Read(.env*)",
      "Read(**/*secret*)",
      "Read(**/*credential*)",
      "Read(**/*.pem)",
      "Read(**/*.key)",
      "Bash(sudo:*)",
      "Bash(rm -rf /)",
      "Write(.git/**)"
    ]
  }
}
```

### 2. Principle of Least Privilege | Nguyên tắc quyền tối thiểu

```json
{
  "permissions": {
    "allow": [
      // Only allow what's needed
      "Bash(git:*)",
      "Read(src/**)",
      "Edit(src/**/*.go)"
      // Don't add "Edit(**)" or "Bash(*)"
    ]
  }
}
```

### 3. Audit Sensitive Access | Kiểm tra truy cập nhạy cảm

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read",
        "command": "echo \"[AUDIT] Read: $INPUT\" >> access.log"
      },
      {
        "matcher": "Bash",
        "command": "echo \"[AUDIT] Bash: $INPUT\" >> access.log"
      }
    ]
  }
}
```

### 4. Separate Team and Personal Secrets | Tách biệt secret team và cá nhân

```
# Team settings (committed)
.claude/settings.json        # No secrets, shared patterns

# Personal settings (gitignored)
.claude/settings.local.json  # Personal API keys, local paths
```

---

## Error Messages | Thông báo lỗi

### Permission Denied | Từ chối quyền

```typescript
interface PermissionError {
  tool: string;
  parameter: string;
  error_type: "permission_denied";
  message: string;
  matched_rule: string;
  suggestion?: string;
}

// Example | Ví dụ
{
  tool: "Read",
  parameter: ".env.local",
  error_type: "permission_denied",
  message: "Reading .env.local is not allowed",
  matched_rule: "Read(.env.*)",
  suggestion: "If you need to read environment files, add to settings.local.json"
}
```

---

## Implementation Requirements | Yêu cầu implement

### For Level 1 Compliance | Cho tuân thủ Level 1

Adapters MUST:

1. **Parse settings.json permissions**
   - Parse allow and deny arrays
   - Handle missing file gracefully

2. **Implement pattern matching**
   - Exact match
   - Prefix match (`:*`)
   - Basic glob (`*`, `**`)

3. **Apply deny-first resolution**
   - Check deny before allow
   - Return clear error messages

### For Level 2 Compliance | Cho tuân thủ Level 2

Adapters MUST also:

1. **Support settings.local.json**
   - Merge with team settings
   - Don't require file to exist

2. **Apply agent restrictions**
   - Parse `tools` from frontmatter
   - Restrict to listed tools only

3. **Support domain patterns**
   - `WebFetch(domain:...)`
   - Subdomain matching

---

## Summary | Tóm tắt

| Feature | Description | Level |
|---------|-------------|-------|
| Basic patterns | Exact, prefix, glob | Level 1 |
| Deny-first resolution | Deny takes precedence | Level 1 |
| settings.local.json | Personal overrides | Level 2 |
| Agent tool restrictions | Frontmatter `tools` | Level 2 |
| Domain patterns | `domain:*.example.com` | Level 2 |
| Merge strategy | Team + local = effective | Level 2 |
| Audit hooks | Log sensitive access | Level 3 |

---

*Next: [09-hooks-system.md](./09-hooks-system.md) - Automation Hooks*
