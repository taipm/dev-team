# 07 - Command System | Hệ thống Command

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

The Command System enables **user-friendly agent invocation** through slash commands and supports **cross-file references** with @-syntax.

Hệ thống Command cho phép **gọi agent thân thiện với người dùng** qua slash commands và hỗ trợ **tham chiếu chéo file** với cú pháp @.

---

## Directory Structure | Cấu trúc thư mục

```
.microai/commands/
├── {namespace}/
│   ├── {command-name}.md       # Command definition
│   ├── {another-command}.md
│   └── ...
└── ...

# Example | Ví dụ
.microai/commands/
├── microai/
│   ├── go-dev.md               # /microai:go-dev
│   ├── go-refactor.md          # /microai:go-refactor
│   └── deep-thinking.md        # /microai:deep-thinking
└── custom/
    └── my-agent.md             # /custom:my-agent
```

---

## Command File Format | Định dạng file Command

### YAML Frontmatter | Frontmatter YAML

```yaml
---
name: '{command-name}'           # REQUIRED: Unique identifier
description: '{Description}'     # REQUIRED: When to use this command
argument-hint: "[args format]"   # OPTIONAL: Hint for arguments
---
```

### Command Body | Nội dung Command

```markdown
---
name: 'go-dev'
description: 'Go development specialist for implementing, debugging, and refactoring Go code'
argument-hint: "[task description]"
---

<agent-activation CRITICAL="TRUE">

1. LOAD the Go development agent from @.microai/agents/microai/go-dev-agent/agent.md
2. EXECUTE the activation protocol defined in the agent file
3. APPLY knowledge from @.microai/agents/microai/go-dev-agent/knowledge/
4. BEGIN interaction with the user

</agent-activation>

## Task Context

User task: $ARGUMENTS

## Additional Instructions

- Focus on idiomatic Go code
- Follow the patterns in the agent's knowledge base
- Update memory at session end
```

---

## @-Reference Syntax | Cú pháp tham chiếu @

### Reference Types | Các loại tham chiếu

```
@{path}                          # Reference to load file content

Types:
1. @.microai/{path}              # Core framework path
2. @./{path}                     # Project root relative
3. @~/.claude/{path}             # User home (platform-specific)
4. @{absolute-path}              # Absolute path (discouraged)
```

### Resolution Rules | Quy tắc phân giải

```python
def resolve_reference(ref: str, context: Context) -> str:
    """
    Resolve @-reference to absolute path.
    Phân giải tham chiếu @ thành đường dẫn tuyệt đối.
    """
    if not ref.startswith("@"):
        raise ValueError(f"Invalid reference: {ref}")

    path = ref[1:]  # Remove @

    # 1. Core framework reference
    if path.startswith(".microai/"):
        return f"{context.project_root}/{path}"

    # 2. Project root reference
    if path.startswith("./"):
        return f"{context.project_root}/{path[2:]}"

    # 3. User home reference
    if path.startswith("~/.claude/"):
        return f"{context.user_home}/.claude/{path[10:]}"

    # 4. Absolute path (discouraged but supported)
    if path.startswith("/"):
        return path

    # Default: treat as relative to project root
    return f"{context.project_root}/{path}"
```

### Reference Loading | Load tham chiếu

```python
def load_reference(ref: str, context: Context) -> str:
    """
    Load and return content of referenced file.
    Load và trả về nội dung file được tham chiếu.
    """
    path = resolve_reference(ref, context)

    if not file_exists(path):
        # Try with common extensions
        for ext in [".md", ".yaml", ".json", ".txt"]:
            if file_exists(path + ext):
                path = path + ext
                break
        else:
            raise FileNotFoundError(f"Reference not found: {ref}")

    return read_file(path)
```

---

## Variable Substitution | Thay thế biến

### Available Variables | Các biến khả dụng

| Variable | Description | Example |
|----------|-------------|---------|
| `$ARGUMENTS` | User input after command | `/go-dev fix auth bug` → `fix auth bug` |
| `$PROJECT_ROOT` | Absolute project path | `/Users/dev/my-project` |
| `$AGENT_NAME` | Current agent name | `go-dev` |
| `$TIMESTAMP` | ISO 8601 timestamp | `2025-12-31T10:30:00Z` |
| `$USER_NAME` | Current user name | `taipm` |
| `$PLATFORM` | Adapter platform | `claude-code` |

### Substitution Example | Ví dụ thay thế

```markdown
# Before substitution | Trước khi thay thế
User task: $ARGUMENTS
Project: $PROJECT_ROOT
Time: $TIMESTAMP

# After substitution | Sau khi thay thế
User task: implement JWT authentication
Project: /Users/dev/my-project
Time: 2025-12-31T10:30:00Z
```

---

## Command Invocation | Gọi Command

### Syntax | Cú pháp

```
/{namespace}:{command-name} [arguments]

Examples | Ví dụ:
/microai:go-dev fix the race condition in worker pool
/microai:deep-thinking analyze this architecture decision
/custom:my-agent help with documentation
```

### Invocation Flow | Luồng gọi

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: Parse command                                       │
│ ═══════════════════════                                     │
│ Input: "/microai:go-dev fix race condition"                │
│ Parse: namespace="microai", command="go-dev",              │
│        arguments="fix race condition"                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 2: Load command file                                   │
│ ══════════════════════════                                  │
│ Path: .microai/commands/microai/go-dev.md                  │
│ Content: YAML frontmatter + activation instructions         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 3: Substitute variables                                │
│ ════════════════════════════                                │
│ $ARGUMENTS → "fix race condition"                          │
│ $PROJECT_ROOT → "/Users/dev/my-project"                    │
│ $TIMESTAMP → "2025-12-31T10:30:00Z"                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 4: Resolve @-references                                │
│ ════════════════════════════                                │
│ @.microai/agents/microai/go-dev-agent/agent.md             │
│ → Load file content                                         │
│ → Include in context                                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 5: Execute activation protocol                         │
│ ════════════════════════════════════                        │
│ Follow <agent-activation> instructions                      │
│ Load agent, memory, knowledge                               │
│ Begin interaction                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## Command Discovery | Khám phá Command

### Discovery Algorithm | Thuật toán khám phá

```python
def discover_commands(project_root: str) -> List[Command]:
    """
    Discover all available commands.
    Khám phá tất cả command khả dụng.
    """
    commands = []
    commands_dir = f"{project_root}/.microai/commands"

    if not directory_exists(commands_dir):
        return commands

    # Scan namespaces
    for namespace in list_directories(commands_dir):
        namespace_dir = f"{commands_dir}/{namespace}"

        # Scan command files
        for file in glob(f"{namespace_dir}/*.md"):
            command = parse_command_file(file)
            command.namespace = namespace
            command.full_name = f"{namespace}:{command.name}"
            commands.append(command)

    return commands


def parse_command_file(path: str) -> Command:
    """
    Parse a command file.
    Parse file command.
    """
    content = read_file(path)
    frontmatter, body = split_frontmatter(content)

    return Command(
        name=frontmatter["name"],
        description=frontmatter["description"],
        argument_hint=frontmatter.get("argument-hint", ""),
        body=body,
        path=path
    )
```

### Listing Commands | Liệt kê Commands

```
> /help commands

Available Commands | Các command khả dụng:

microai:
  /microai:go-dev [task]        - Go development specialist
  /microai:go-refactor [file]   - Go code refactoring
  /microai:deep-thinking [topic] - Multi-agent analysis

custom:
  /custom:my-agent [task]       - My custom agent
```

---

## Nested References | Tham chiếu lồng nhau

### Handling Nested @-References | Xử lý tham chiếu @ lồng nhau

Agent files may contain references to other files (knowledge, memory).

```markdown
# In agent.md
Load knowledge from @./knowledge/01-patterns.md

# Resolution:
# If agent.md is at .microai/agents/go-dev/agent.md
# Then @./knowledge/01-patterns.md resolves to:
# .microai/agents/go-dev/knowledge/01-patterns.md
```

### Resolution Context | Context phân giải

```python
def load_with_context(ref: str, base_path: str, context: Context) -> str:
    """
    Load reference with context-aware resolution.
    Load tham chiếu với phân giải theo context.
    """
    # Create new context with current file's directory as base
    local_context = context.copy()
    local_context.current_dir = dirname(base_path)

    # Resolve relative references from current file's location
    if ref.startswith("@./"):
        return f"{local_context.current_dir}/{ref[3:]}"

    # Other references use standard resolution
    return resolve_reference(ref, context)
```

---

## Command Chaining | Chuỗi Command

### Sequential Commands | Commands tuần tự

```
# Run multiple commands in sequence
# Chạy nhiều command tuần tự

/microai:go-dev implement the feature
# ... work completes ...
/microai:go-review review the implementation
# ... review completes ...
/custom:commit-helper create commit message
```

### Programmatic Chaining | Chuỗi theo chương trình

```markdown
# In command file, invoke another command
# Trong file command, gọi command khác

<agent-activation CRITICAL="TRUE">

1. LOAD @.microai/agents/microai/go-dev-agent/agent.md
2. EXECUTE task: $ARGUMENTS
3. ON COMPLETION: suggest running /microai:go-review

</agent-activation>
```

---

## Best Practices | Thực hành tốt nhất

### 1. Use Descriptive Names | Dùng tên mô tả

```yaml
# Good | Tốt
name: 'go-dev'
description: 'Go development specialist for implementing, debugging, and refactoring Go code'

# Bad | Tệ
name: 'dev1'
description: 'Development'
```

### 2. Provide Argument Hints | Cung cấp gợi ý argument

```yaml
# Good | Tốt
argument-hint: "[file path] [refactoring type: rename|extract|inline]"

# Bad | Tệ
argument-hint: "[args]"
```

### 3. Use Relative References | Dùng tham chiếu tương đối

```markdown
# Good - Portable | Tốt - Di động
@.microai/agents/go-dev/agent.md

# Bad - Not portable | Tệ - Không di động
@/Users/taipm/projects/my-project/.microai/agents/go-dev/agent.md
```

### 4. Document Dependencies | Ghi chú phụ thuộc

```markdown
---
name: 'team-analysis'
description: 'Run full team analysis on a problem'
---

<!-- Dependencies | Phụ thuộc -->
This command requires:
- @.microai/agents/microai/teams/deep-thinking-team/ (team agents)
- @.microai/agents/microai/maestro/agent.md (orchestrator)

<agent-activation CRITICAL="TRUE">
...
</agent-activation>
```

---

## Implementation Requirements | Yêu cầu implement

### For Level 1 Compliance | Cho tuân thủ Level 1

Adapters MUST:

1. **Parse command files**
   - Extract YAML frontmatter
   - Parse body content

2. **Substitute variables**
   - Support at least: `$ARGUMENTS`, `$PROJECT_ROOT`

3. **Resolve @-references**
   - Support `.microai/` and `./` prefixes
   - Load and inline referenced content

4. **Execute commands**
   - Handle `/namespace:command args` syntax
   - Pass arguments correctly

### Command Execution Algorithm | Thuật toán thực thi Command

```python
def execute_command(input: str, context: Context) -> Result:
    """
    Execute a slash command.
    Thực thi slash command.
    """
    # 1. Parse input
    match = parse_command_input(input)
    if not match:
        return Error("Invalid command format")

    namespace = match.group("namespace")
    command_name = match.group("command")
    arguments = match.group("arguments") or ""

    # 2. Load command file
    command_path = f"{context.project_root}/.microai/commands/{namespace}/{command_name}.md"
    if not file_exists(command_path):
        return Error(f"Command not found: {namespace}:{command_name}")

    command = parse_command_file(command_path)

    # 3. Substitute variables
    body = command.body
    body = body.replace("$ARGUMENTS", arguments)
    body = body.replace("$PROJECT_ROOT", context.project_root)
    body = body.replace("$TIMESTAMP", get_iso_timestamp())
    body = body.replace("$AGENT_NAME", command_name)
    body = body.replace("$PLATFORM", context.platform)

    # 4. Resolve @-references
    references = find_all_references(body)
    for ref in references:
        content = load_reference(ref, context)
        body = body.replace(ref, content)

    # 5. Execute activation protocol
    return execute_activation(body, context)


def parse_command_input(input: str) -> Optional[Match]:
    """
    Parse command input string.
    Parse chuỗi input command.
    """
    pattern = r"^/(?P<namespace>[\w-]+):(?P<command>[\w-]+)(?:\s+(?P<arguments>.+))?$"
    return re.match(pattern, input)
```

---

## Summary | Tóm tắt

| Component | Description | Required Level |
|-----------|-------------|----------------|
| Command file format | YAML frontmatter + body | Level 1 |
| @-reference resolution | Load file content | Level 1 |
| Variable substitution | `$ARGUMENTS`, `$PROJECT_ROOT` | Level 1 |
| Nested references | References within loaded files | Level 2 |
| Command discovery | List available commands | Level 2 |
| Command chaining | Sequential command execution | Level 3 |

---

*Next: [08-permission-model.md](./08-permission-model.md) - Security & Permissions*
