# Tools Reference

Danh sách đầy đủ các tools có sẵn cho agents.

## Tổng Quan

Tools được chia thành các nhóm:

| Nhóm | Tools | Mục đích |
|------|-------|----------|
| File | Read, Write, Edit | Thao tác file |
| Search | Glob, Grep | Tìm kiếm |
| Execute | Bash | Chạy commands |
| Code | LSP | Code intelligence |
| Web | WebFetch, WebSearch | Network |
| User | AskUserQuestion, TodoWrite | Tương tác |
| Advanced | Task | Sub-agents |

## File Operations

### Read

Đọc nội dung file.

**Syntax:**
```yaml
tools: [Read]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| file_path | string | Yes | Absolute path to file |
| offset | number | No | Line to start from |
| limit | number | No | Number of lines |

**Example Usage:**
```
Read file /path/to/file.go
```

**Notes:**
- Supports text files, images, PDFs
- Max 2000 lines by default
- Lines > 2000 chars are truncated

### Write

Ghi nội dung vào file (overwrite).

**Syntax:**
```yaml
tools: [Write]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| file_path | string | Yes | Absolute path |
| content | string | Yes | Content to write |

**Example Usage:**
```
Write to /path/to/file.go with content...
```

**Notes:**
- Overwrites existing file
- Creates new file if not exists
- Creates parent directories

### Edit

Sửa đổi file bằng string replacement.

**Syntax:**
```yaml
tools: [Edit]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| file_path | string | Yes | Absolute path |
| old_string | string | Yes | Text to replace |
| new_string | string | Yes | Replacement text |
| replace_all | boolean | No | Replace all occurrences |

**Example Usage:**
```
Edit /path/to/file.go
Replace "oldFunc" with "newFunc"
```

**Notes:**
- old_string must be unique (or use replace_all)
- Preserve exact indentation

## Search Operations

### Glob

Tìm files theo pattern.

**Syntax:**
```yaml
tools: [Glob]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| pattern | string | Yes | Glob pattern |
| path | string | No | Search directory |

**Patterns:**

| Pattern | Matches |
|---------|---------|
| `*.go` | Go files in current dir |
| `**/*.go` | All Go files recursively |
| `src/**/*.ts` | TS files in src/ |
| `*.{js,ts}` | JS or TS files |

**Example Usage:**
```
Find all Go files: **/*.go
```

### Grep

Tìm nội dung trong files.

**Syntax:**
```yaml
tools: [Grep]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| pattern | string | Yes | Regex pattern |
| path | string | No | Search path |
| glob | string | No | File pattern |
| output_mode | string | No | content/files_with_matches/count |

**Example Usage:**
```
Search for "func.*Handler" in *.go files
```

**Notes:**
- Uses ripgrep syntax
- Supports regex
- Use `multiline: true` for cross-line patterns

## Execution

### Bash

Chạy shell commands.

**Syntax:**
```yaml
tools: [Bash]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| command | string | Yes | Command to run |
| timeout | number | No | Timeout in ms |
| run_in_background | boolean | No | Run async |

**Example Usage:**
```
Run: npm install
Run: git status
```

**Notes:**
- Max timeout: 10 minutes
- Quote paths with spaces
- Use `&&` for sequential commands

**Security:**
- Subject to permissions in settings.json
- Sandboxed by default

## Code Intelligence

### LSP

Language Server Protocol operations.

**Syntax:**
```yaml
tools: [LSP]
```

**Operations:**

| Operation | Description |
|-----------|-------------|
| goToDefinition | Find symbol definition |
| findReferences | Find all references |
| hover | Get documentation |
| documentSymbol | Get file symbols |
| workspaceSymbol | Search workspace |

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| operation | string | Yes | LSP operation |
| filePath | string | Yes | File path |
| line | number | Yes | Line number (1-based) |
| character | number | Yes | Column (1-based) |

**Example Usage:**
```
Go to definition of symbol at line 42, column 10
```

## Web Operations

### WebFetch

Fetch content từ URL.

**Syntax:**
```yaml
tools: [WebFetch]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| url | string | Yes | URL to fetch |
| prompt | string | Yes | What to extract |

**Example Usage:**
```
Fetch https://docs.example.com and extract API documentation
```

**Notes:**
- HTTP upgraded to HTTPS
- HTML converted to markdown
- Subject to domain permissions

### WebSearch

Tìm kiếm web.

**Syntax:**
```yaml
tools: [WebSearch]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| query | string | Yes | Search query |
| allowed_domains | array | No | Domain whitelist |
| blocked_domains | array | No | Domain blacklist |

**Example Usage:**
```
Search: "Go context best practices 2024"
```

## User Interaction

### AskUserQuestion

Hỏi người dùng.

**Syntax:**
```yaml
tools: [AskUserQuestion]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| questions | array | Yes | List of questions |

**Question Structure:**

```json
{
  "question": "Which approach?",
  "header": "Approach",
  "options": [
    {"label": "Option A", "description": "Description A"},
    {"label": "Option B", "description": "Description B"}
  ],
  "multiSelect": false
}
```

**Notes:**
- Max 4 questions
- Max 4 options per question
- "Other" option auto-added

### TodoWrite

Quản lý task list.

**Syntax:**
```yaml
tools: [TodoWrite]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| todos | array | Yes | List of todos |

**Todo Structure:**

```json
{
  "content": "Task description",
  "status": "pending",
  "activeForm": "Working on task"
}
```

**Status Values:**
- `pending`: Not started
- `in_progress`: Currently working
- `completed`: Done

## Advanced

### Task

Spawn sub-agents.

**Syntax:**
```yaml
tools: [Task]
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| prompt | string | Yes | Task description |
| subagent_type | string | Yes | Agent type |
| model | string | No | Model override |
| run_in_background | boolean | No | Async execution |

**Agent Types:**

| Type | Purpose |
|------|---------|
| Explore | Codebase exploration |
| Plan | Design implementation |
| general-purpose | Complex tasks |

**Example Usage:**
```
Launch Explore agent to find authentication code
```

## Permission Patterns

Tools có thể bị giới hạn qua settings.json:

```json
{
  "permissions": {
    "allow": [
      "Read(**/*.go)",
      "Bash(git:*)",
      "Bash(npm:*)",
      "WebFetch(domain:github.com)"
    ],
    "deny": [
      "Read(.env)",
      "Bash(rm:*)"
    ]
  }
}
```

**Pattern Syntax:**

| Pattern | Description |
|---------|-------------|
| `Read(**/*.go)` | Read only Go files |
| `Bash(git:*)` | Only git commands |
| `WebFetch(domain:X)` | Only domain X |
| `*` | All operations |

## Xem Thêm

- [Read Tool](./tools/read.md)
- [Write Tool](./tools/write.md)
- [Bash Tool](./tools/bash.md)
- [Permission Model](./permission-modes.md)
