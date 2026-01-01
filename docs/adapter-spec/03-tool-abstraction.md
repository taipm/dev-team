# 03 - Tool Abstraction | Trừu tượng hóa Tool

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

MicroAI defines a **canonical set of abstract tools** that adapters must implement. This abstraction allows agents to work across platforms without modification.

MicroAI định nghĩa **bộ tool trừu tượng chuẩn** mà các adapter phải implement. Sự trừu tượng này cho phép agent hoạt động đa nền tảng mà không cần sửa đổi.

---

## Canonical Tool List | Danh sách Tool chuẩn

### Required Tools (Level 1) | Tool bắt buộc

| Tool | Category | Description | Mô tả |
|------|----------|-------------|-------|
| `Read` | File | Read file contents | Đọc nội dung file |
| `Write` | File | Create/overwrite file | Tạo/ghi đè file |
| `Edit` | File | Line-based edits | Sửa file theo dòng |
| `Glob` | File | Pattern-based file search | Tìm file theo pattern |
| `Grep` | File | Content search with regex | Tìm nội dung với regex |
| `Bash` | System | Execute shell commands | Thực thi lệnh shell |
| `AskUserQuestion` | UI | Request user input | Yêu cầu input từ user |

### Standard Tools (Level 2) | Tool tiêu chuẩn

| Tool | Category | Description | Mô tả |
|------|----------|-------------|-------|
| `TodoWrite` | Task | Task list management | Quản lý danh sách task |
| `LSP` | Code | Language Server Protocol | Giao thức Language Server |

### Extended Tools (Level 3) | Tool mở rộng

| Tool | Category | Description | Mô tả |
|------|----------|-------------|-------|
| `WebFetch` | Network | Fetch URL content | Lấy nội dung URL |
| `WebSearch` | Network | Web search | Tìm kiếm web |

---

## Tool Specifications | Đặc tả Tool

### Read

Read file contents with optional pagination.

Đọc nội dung file với phân trang tùy chọn.

```typescript
interface ReadTool {
  name: "Read";

  execute(params: {
    file_path: string;      // Absolute path to file
    offset?: number;        // Line number to start (1-based)
    limit?: number;         // Number of lines to read
  }): Promise<{
    content: string;        // File content with line numbers
    total_lines: number;    // Total lines in file
  }>;
}

// Example | Ví dụ
Read({ file_path: "/path/to/file.go" })
// Returns | Trả về:
// "     1\tfunc main() {\n     2\t    fmt.Println(\"Hello\")\n     3\t}"

Read({ file_path: "/path/to/file.go", offset: 10, limit: 5 })
// Returns lines 10-14 | Trả về dòng 10-14
```

### Write

Create or overwrite a file.

Tạo hoặc ghi đè file.

```typescript
interface WriteTool {
  name: "Write";

  execute(params: {
    file_path: string;      // Absolute path to file
    content: string;        // Content to write
  }): Promise<{
    success: boolean;
    bytes_written: number;
  }>;
}

// Example | Ví dụ
Write({
  file_path: "/path/to/new-file.go",
  content: "package main\n\nfunc main() {}\n"
})
```

### Edit

Make line-based edits to existing files.

Sửa file theo dòng.

```typescript
interface EditTool {
  name: "Edit";

  execute(params: {
    file_path: string;      // Absolute path to file
    old_string: string;     // Exact text to find
    new_string: string;     // Replacement text
    replace_all?: boolean;  // Replace all occurrences (default: false)
  }): Promise<{
    success: boolean;
    replacements: number;   // Number of replacements made
  }>;
}

// Example | Ví dụ
Edit({
  file_path: "/path/to/file.go",
  old_string: "fmt.Println(\"Hello\")",
  new_string: "fmt.Println(\"Hello, World!\")"
})
```

### Glob

Search for files matching a pattern.

Tìm file theo pattern.

```typescript
interface GlobTool {
  name: "Glob";

  execute(params: {
    pattern: string;        // Glob pattern (e.g., "**/*.go")
    path?: string;          // Base directory (default: cwd)
  }): Promise<{
    files: string[];        // Matching file paths
    count: number;
  }>;
}

// Example | Ví dụ
Glob({ pattern: "**/*.go" })
// Returns | Trả về:
// { files: ["main.go", "pkg/server.go", "internal/handler.go"], count: 3 }

Glob({ pattern: "*.md", path: "/docs" })
// Searches only in /docs | Chỉ tìm trong /docs
```

### Grep

Search file contents with regex.

Tìm nội dung file với regex.

```typescript
interface GrepTool {
  name: "Grep";

  execute(params: {
    pattern: string;        // Regex pattern
    path?: string;          // Directory or file to search
    glob?: string;          // File pattern filter (e.g., "*.go")
    output_mode?: "content" | "files_with_matches" | "count";
    "-i"?: boolean;         // Case insensitive
    "-n"?: boolean;         // Show line numbers
    "-A"?: number;          // Lines after match
    "-B"?: number;          // Lines before match
    "-C"?: number;          // Lines around match
  }): Promise<{
    matches: Match[];
    total_matches: number;
  }>;
}

interface Match {
  file: string;
  line_number: number;
  content: string;
}

// Example | Ví dụ
Grep({
  pattern: "func.*Error",
  glob: "*.go",
  output_mode: "content",
  "-n": true
})
```

### Bash

Execute shell commands.

Thực thi lệnh shell.

```typescript
interface BashTool {
  name: "Bash";

  execute(params: {
    command: string;        // Shell command
    timeout?: number;       // Timeout in ms (default: 120000)
    cwd?: string;           // Working directory
    run_in_background?: boolean;
  }): Promise<{
    stdout: string;
    stderr: string;
    exit_code: number;
  }>;
}

// Example | Ví dụ
Bash({ command: "go build ./..." })
Bash({ command: "git status" })
Bash({ command: "npm install", timeout: 300000 })
```

### AskUserQuestion

Request input or confirmation from user.

Yêu cầu input hoặc xác nhận từ user.

```typescript
interface AskUserQuestionTool {
  name: "AskUserQuestion";

  execute(params: {
    questions: Question[];
  }): Promise<{
    answers: Record<string, string>;
  }>;
}

interface Question {
  question: string;         // The question text
  header: string;           // Short label (max 12 chars)
  options: Option[];        // 2-4 options
  multiSelect?: boolean;    // Allow multiple selections
}

interface Option {
  label: string;            // Option text (1-5 words)
  description: string;      // Explanation
}

// Example | Ví dụ
AskUserQuestion({
  questions: [{
    question: "Which database should we use?",
    header: "Database",
    options: [
      { label: "PostgreSQL", description: "Relational, ACID compliant" },
      { label: "MongoDB", description: "Document store, flexible schema" },
      { label: "Redis", description: "In-memory, key-value store" }
    ],
    multiSelect: false
  }]
})
```

### TodoWrite

Manage task lists.

Quản lý danh sách task.

```typescript
interface TodoWriteTool {
  name: "TodoWrite";

  execute(params: {
    todos: Todo[];
  }): Promise<{
    success: boolean;
  }>;
}

interface Todo {
  content: string;          // Task description (imperative)
  status: "pending" | "in_progress" | "completed";
  activeForm: string;       // Present continuous form
}

// Example | Ví dụ
TodoWrite({
  todos: [
    { content: "Implement user authentication", status: "in_progress", activeForm: "Implementing user authentication" },
    { content: "Add unit tests", status: "pending", activeForm: "Adding unit tests" },
    { content: "Review security", status: "pending", activeForm: "Reviewing security" }
  ]
})
```

### LSP

Language Server Protocol operations.

Các thao tác Language Server Protocol.

```typescript
interface LSPTool {
  name: "LSP";

  execute(params: {
    operation: LSPOperation;
    filePath: string;
    line: number;           // 1-based
    character: number;      // 1-based
  }): Promise<LSPResult>;
}

type LSPOperation =
  | "goToDefinition"
  | "findReferences"
  | "hover"
  | "documentSymbol"
  | "workspaceSymbol"
  | "goToImplementation"
  | "prepareCallHierarchy"
  | "incomingCalls"
  | "outgoingCalls";

// Example | Ví dụ
LSP({
  operation: "goToDefinition",
  filePath: "/path/to/file.go",
  line: 25,
  character: 10
})
```

### WebFetch

Fetch content from URLs.

Lấy nội dung từ URL.

```typescript
interface WebFetchTool {
  name: "WebFetch";

  execute(params: {
    url: string;            // Full URL
    prompt: string;         // What to extract from page
  }): Promise<{
    content: string;        // Extracted/processed content
  }>;
}

// Example | Ví dụ
WebFetch({
  url: "https://go.dev/doc/effective_go",
  prompt: "Extract the section about error handling"
})
```

### WebSearch

Search the web.

Tìm kiếm web.

```typescript
interface WebSearchTool {
  name: "WebSearch";

  execute(params: {
    query: string;
    allowed_domains?: string[];
    blocked_domains?: string[];
  }): Promise<{
    results: SearchResult[];
  }>;
}

interface SearchResult {
  title: string;
  url: string;
  snippet: string;
}

// Example | Ví dụ
WebSearch({
  query: "Go context cancellation best practices 2024",
  allowed_domains: ["go.dev", "golang.org"]
})
```

---

## Permission Patterns | Pattern quyền hạn

Tools can be restricted using permission patterns.

Tools có thể bị giới hạn bằng permission patterns.

### Syntax | Cú pháp

```
Tool(pattern)

Where pattern can be:
- Exact match: "git status"
- Prefix match: "git:*"
- Glob: "**/*.go"
- Domain: "domain:github.com"
```

### Examples | Ví dụ

```yaml
permissions:
  allow:
    # Bash patterns
    - "Bash(git:*)"           # All git commands
    - "Bash(npm:*)"           # All npm commands
    - "Bash(go:*)"            # All go commands
    - "Bash(make:*)"          # All make commands

    # Read patterns
    - "Read(**/*.go)"         # All Go files
    - "Read(**/*.md)"         # All Markdown files
    - "Read(src/**)"          # Everything in src/

    # Edit patterns
    - "Edit(src/**)"          # Edit files in src/
    - "Edit(**/*.go)"         # Edit Go files

    # Web patterns
    - "WebFetch(domain:github.com)"
    - "WebFetch(domain:go.dev)"

  deny:
    # Security-sensitive files
    - "Read(.env)"
    - "Read(.env.*)"
    - "Read(secrets/**)"
    - "Read(**/*.pem)"
    - "Read(**/*.key)"
    - "Read(**/*secret*)"

    # Dangerous operations
    - "Bash(rm -rf:*)"
    - "Bash(sudo:*)"
    - "Write(.env)"
```

---

## Tool Mapping by Platform | Ánh xạ Tool theo nền tảng

### Claude Code

```yaml
Read: Read (built-in)
Write: Write (built-in)
Edit: Edit (built-in)
Glob: Glob (built-in)
Grep: Grep (built-in)
Bash: Bash (built-in)
AskUserQuestion: AskUserQuestion (built-in)
TodoWrite: TodoWrite (built-in)
LSP: LSP (built-in)
WebFetch: WebFetch (built-in)
WebSearch: WebSearch (built-in)
```

### OpenCode (hypothetical)

```yaml
Read: opencode.file.read()
Write: opencode.file.write()
Edit: opencode.file.edit()
Glob: opencode.search.glob()
Grep: opencode.search.grep()
Bash: opencode.system.exec()
AskUserQuestion: opencode.ui.prompt()
TodoWrite: opencode.task.update()
LSP: opencode.lsp.*
WebFetch: opencode.http.fetch()
WebSearch: opencode.search.web()
```

### VS Code (hypothetical)

```yaml
Read: vscode.workspace.fs.readFile()
Write: vscode.workspace.fs.writeFile()
Edit: vscode.TextEdit + applyEdit()
Glob: vscode.workspace.findFiles()
Grep: vscode.workspace.findTextInFiles()
Bash: vscode.ProcessExecution
AskUserQuestion: vscode.window.showQuickPick()
TodoWrite: custom extension
LSP: vscode.languages.*
WebFetch: fetch()
WebSearch: custom extension
```

---

## Implementation Requirements | Yêu cầu implement

### For All Tools | Cho tất cả Tools

1. **Validate inputs** before execution
2. **Check permissions** against settings.json
3. **Handle errors** gracefully with clear messages
4. **Timeout long operations** (default: 2 minutes)
5. **Return consistent format** as specified

### Error Handling | Xử lý lỗi

```typescript
interface ToolError {
  tool: string;
  error_type: "permission_denied" | "not_found" | "timeout" | "invalid_input" | "execution_failed";
  message: string;
  details?: any;
}

// Example | Ví dụ
{
  tool: "Read",
  error_type: "permission_denied",
  message: "Reading .env files is not allowed",
  details: { file: ".env", matched_rule: "Read(.env)" }
}
```

---

## Summary | Tóm tắt

| Level | Tools | Required For |
|-------|-------|--------------|
| **Level 1** | Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion | Minimal compliance |
| **Level 2** | + TodoWrite, LSP | Standard compliance |
| **Level 3** | + WebFetch, WebSearch | Full compliance |

---

*Next: [04-knowledge-system.md](./04-knowledge-system.md) - Knowledge Loading & Indexing*
