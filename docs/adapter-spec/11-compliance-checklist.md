# 11 - Compliance Checklist | Danh sách kiểm tra tuân thủ

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

This checklist provides **verification tests** for adapter implementations at each compliance level.

Danh sách kiểm tra này cung cấp **các bài test xác minh** cho các adapter implementation ở mỗi mức tuân thủ.

---

## Level 1: Minimal Compliance | Tuân thủ tối thiểu

### Settings | Cài đặt

- [ ] **S1.1** Parse `settings.json` from adapter directory
- [ ] **S1.2** Extract `permissions.allow` array
- [ ] **S1.3** Extract `permissions.deny` array
- [ ] **S1.4** Handle missing `settings.json` gracefully (use defaults)

### Core Tools | Công cụ lõi

- [ ] **T1.1** Implement `Read` tool
  - [ ] Read entire file
  - [ ] Read with offset and limit
  - [ ] Return line numbers in output
  - [ ] Handle missing file error

- [ ] **T1.2** Implement `Write` tool
  - [ ] Create new file
  - [ ] Overwrite existing file
  - [ ] Create parent directories if needed
  - [ ] Return bytes written

- [ ] **T1.3** Implement `Edit` tool
  - [ ] Find and replace exact string
  - [ ] Replace all occurrences (when flag set)
  - [ ] Return replacement count
  - [ ] Handle string not found error

- [ ] **T1.4** Implement `Glob` tool
  - [ ] Match simple patterns (`*.go`)
  - [ ] Match recursive patterns (`**/*.go`)
  - [ ] Respect base path parameter
  - [ ] Return sorted file list

- [ ] **T1.5** Implement `Grep` tool
  - [ ] Search with regex patterns
  - [ ] Filter by file glob
  - [ ] Support output modes (content, files_with_matches, count)
  - [ ] Return line numbers when requested

- [ ] **T1.6** Implement `Bash` tool
  - [ ] Execute shell commands
  - [ ] Capture stdout and stderr
  - [ ] Return exit code
  - [ ] Respect timeout parameter

- [ ] **T1.7** Implement `AskUserQuestion` tool
  - [ ] Present questions to user
  - [ ] Collect answers
  - [ ] Support multiple choice options
  - [ ] Support multi-select mode

### Agent System | Hệ thống Agent

- [ ] **A1.1** Parse YAML frontmatter from `agent.md`
  - [ ] Extract `name` (required)
  - [ ] Extract `description` (required)
  - [ ] Extract `model` (optional)
  - [ ] Extract `tools` (optional)
  - [ ] Extract `language` (optional)

- [ ] **A1.2** Load agent body content (markdown after frontmatter)

- [ ] **A1.3** Discover agents in `.microai/agents/` directory
  - [ ] Scan recursively
  - [ ] Find `agent.md` files
  - [ ] Find standalone `.md` files

### Reference Resolution | Phân giải tham chiếu

- [ ] **R1.1** Resolve `@.microai/` references
- [ ] **R1.2** Resolve `@./` references (project root relative)
- [ ] **R1.3** Load and inline referenced file content
- [ ] **R1.4** Handle missing reference error

### Command System | Hệ thống Command

- [ ] **C1.1** Parse command files from `.microai/commands/`
- [ ] **C1.2** Extract YAML frontmatter (name, description)
- [ ] **C1.3** Substitute `$ARGUMENTS` variable
- [ ] **C1.4** Substitute `$PROJECT_ROOT` variable
- [ ] **C1.5** Execute agent activation from command

### Permission Checking | Kiểm tra quyền

- [ ] **P1.1** Check deny list before allow list
- [ ] **P1.2** Match exact patterns
- [ ] **P1.3** Match prefix patterns (`:*`)
- [ ] **P1.4** Match basic glob patterns (`*`, `**`)
- [ ] **P1.5** Return clear error message when denied

---

## Level 2: Standard Compliance | Tuân thủ tiêu chuẩn

### Settings | Cài đặt

- [ ] **S2.1** Parse `settings.local.json`
- [ ] **S2.2** Merge with team settings (local extends, not replaces)
- [ ] **S2.3** Handle missing `settings.local.json` gracefully

### Knowledge System | Hệ thống Knowledge

- [ ] **K2.1** Parse `knowledge-index.yaml`
- [ ] **K2.2** Load core files (always)
- [ ] **K2.3** Extract keywords from task
- [ ] **K2.4** Normalize keywords using aliases
- [ ] **K2.5** Match keywords to knowledge files
- [ ] **K2.6** Load matched files only (selective loading)
- [ ] **K2.7** Inject knowledge into agent prompt

### Memory System | Hệ thống Memory

- [ ] **M2.1** Load `memory/context.md` on agent activation
- [ ] **M2.2** Load recent entries from `memory/decisions.md` (last 10)
- [ ] **M2.3** Inject memory into agent prompt
- [ ] **M2.4** Save `context.md` at session end
- [ ] **M2.5** Append new decisions to `decisions.md`
- [ ] **M2.6** Append new learnings to `learnings.md`
- [ ] **M2.7** Create memory files if they don't exist

### Agent Restrictions | Giới hạn Agent

- [ ] **A2.1** Parse `tools` from agent frontmatter
- [ ] **A2.2** Restrict tool access to listed tools only
- [ ] **A2.3** Return error when agent tries to use unlisted tool

### Advanced Permissions | Quyền nâng cao

- [ ] **P2.1** Match domain patterns (`domain:github.com`)
- [ ] **P2.2** Match subdomain patterns (`domain:*.anthropic.com`)
- [ ] **P2.3** Apply permission inheritance (team → local → agent)

### Standard Tools | Công cụ tiêu chuẩn

- [ ] **T2.1** Implement `TodoWrite` tool
  - [ ] Accept todo list array
  - [ ] Support status: pending, in_progress, completed
  - [ ] Store todos persistently

- [ ] **T2.2** Implement `LSP` tool
  - [ ] Go to definition
  - [ ] Find references
  - [ ] Hover information
  - [ ] Document symbols

### Variable Substitution | Thay thế biến

- [ ] **V2.1** Substitute `$TIMESTAMP`
- [ ] **V2.2** Substitute `$AGENT_NAME`
- [ ] **V2.3** Substitute `$PLATFORM`
- [ ] **V2.4** Substitute `$USER_NAME`

### Command Discovery | Khám phá Command

- [ ] **C2.1** List available commands
- [ ] **C2.2** Show command descriptions
- [ ] **C2.3** Show argument hints

---

## Level 3: Full Compliance | Tuân thủ đầy đủ

### Team Coordination | Phối hợp nhóm

- [ ] **T3.1** Recognize team directory structure
- [ ] **T3.2** Load `team-memory/` for all team members
- [ ] **T3.3** Merge team memory with individual memory
- [ ] **T3.4** Track handoffs in `handoffs.md`
- [ ] **T3.5** Support lead agent dispatch protocol
- [ ] **T3.6** Support specialist result format

### Hook System | Hệ thống Hook

- [ ] **H3.1** Execute `PreToolUse` hooks before tool execution
- [ ] **H3.2** Execute `PostToolUse` hooks after tool execution
- [ ] **H3.3** Execute `UserPromptSubmit` hooks on user message
- [ ] **H3.4** Execute `SessionStart` hooks on session begin
- [ ] **H3.5** Execute `SessionEnd` hooks on session close
- [ ] **H3.6** Match tool hooks using matcher patterns
- [ ] **H3.7** Substitute all documented variables
- [ ] **H3.8** Block tool execution when hook fails (if continueOnFailure=false)
- [ ] **H3.9** Respect hook timeout

### Extended Tools | Công cụ mở rộng

- [ ] **T3.1** Implement `WebFetch` tool
  - [ ] Fetch URL content
  - [ ] Convert HTML to markdown
  - [ ] Apply prompt to extract information
  - [ ] Handle redirects

- [ ] **T3.2** Implement `WebSearch` tool
  - [ ] Search web with query
  - [ ] Return results with title, URL, snippet
  - [ ] Respect domain filters

### Session Management | Quản lý phiên

- [ ] **S3.1** Archive complex sessions to `sessions/YYYY-MM-DD.md`
- [ ] **S3.2** Generate session summary
- [ ] **S3.3** Track session statistics

### Advanced Knowledge | Knowledge nâng cao

- [ ] **K3.1** Expand topic groups for broader matching
- [ ] **K3.2** Track token budget
- [ ] **K3.3** Prioritize knowledge by priority field

---

## Verification Tests | Bài test xác minh

### Test 1: Agent Loading | Load Agent

```bash
# Command
adapter load-agent .microai/agents/go-dev/agent.md

# Expected Output
{
  "name": "go-dev",
  "description": "Go development specialist...",
  "model": "sonnet",
  "tools": ["Read", "Write", "Edit", "Bash", "Glob", "Grep"],
  "status": "loaded"
}
```

### Test 2: Reference Resolution | Phân giải tham chiếu

```bash
# Command
adapter resolve @.microai/agents/go-dev/knowledge/01-patterns.md

# Expected Output
{
  "path": "/project/.microai/agents/go-dev/knowledge/01-patterns.md",
  "content": "# Go Patterns\n\n## Graceful Shutdown...",
  "size": 3456
}
```

### Test 3: Permission Check | Kiểm tra quyền

```bash
# Command
adapter check-permission "Bash" "rm -rf /"

# Expected Output
{
  "allowed": false,
  "reason": "Denied by pattern: Bash(rm -rf:*)"
}

# Command
adapter check-permission "Read" "src/main.go"

# Expected Output
{
  "allowed": true,
  "reason": "Allowed by pattern: Read(**/*.go)"
}
```

### Test 4: Knowledge Loading | Load Knowledge

```bash
# Command
adapter load-knowledge "Fix race condition in goroutine" .microai/agents/go-dev/

# Expected Output
{
  "loaded_files": [
    "01-core-patterns.md",      # Core (always)
    "08-anti-patterns.md",      # Core (always)
    "06-concurrency.md"         # Matched: "race", "goroutine"
  ],
  "total_tokens": 2150,
  "keywords_matched": ["race", "goroutine"]
}
```

### Test 5: Memory Cycle | Chu kỳ Memory

```bash
# Command
adapter test-memory-cycle .microai/agents/go-dev/

# Expected Output
{
  "loaded": {
    "context": "# Current Context\n...",
    "decisions_count": 3
  },
  "modified": {
    "context": "# Updated Context\n...",
    "new_decisions": 1,
    "new_learnings": 0
  },
  "saved": true
}
```

### Test 6: Command Execution | Thực thi Command

```bash
# Command
adapter execute-command "/microai:go-dev fix auth bug"

# Expected Output
{
  "namespace": "microai",
  "command": "go-dev",
  "arguments": "fix auth bug",
  "agent_activated": "go-dev",
  "prompt_generated": true
}
```

### Test 7: Hook Execution | Thực thi Hook

```bash
# Command
adapter test-hooks PreToolUse Bash "git status"

# Expected Output
{
  "hook_type": "PreToolUse",
  "hooks_matched": 2,
  "hooks_executed": 2,
  "blocked": false,
  "outputs": [
    {"hook": 0, "exit_code": 0, "output": "logged"},
    {"hook": 1, "exit_code": 0, "output": "validated"}
  ]
}
```

### Test 8: Team Loading | Load Team

```bash
# Command
adapter load-team .microai/agents/microai/teams/deep-thinking-team/

# Expected Output
{
  "name": "deep-thinking-team",
  "lead": "maestro",
  "members": ["dijkstra", "linus", "feynman", "socrates"],
  "team_memory": {
    "context": "# Team Context\n...",
    "handoffs_count": 5,
    "blockers_count": 1
  }
}
```

---

## Compliance Report Template | Mẫu báo cáo tuân thủ

```markdown
# MicroAI Adapter Compliance Report

## Adapter Information

| Field | Value |
|-------|-------|
| Adapter Name | {name} |
| Platform | {platform} |
| Version | {version} |
| Test Date | {date} |

## Compliance Level

**Achieved Level**: Level {1|2|3}

## Level 1 Results

| Category | Passed | Failed | Total |
|----------|--------|--------|-------|
| Settings | X | Y | Z |
| Core Tools | X | Y | Z |
| Agent System | X | Y | Z |
| References | X | Y | Z |
| Commands | X | Y | Z |
| Permissions | X | Y | Z |

### Failed Tests

- [ ] **{Test ID}**: {Description of failure}

## Level 2 Results (if applicable)

{Same format as Level 1}

## Level 3 Results (if applicable)

{Same format as Level 1}

## Notes

{Any additional notes or known limitations}
```

---

## Summary | Tóm tắt

| Level | Total Tests | Required to Pass |
|-------|-------------|------------------|
| Level 1 | 28 | All |
| Level 2 | 24 | All Level 1 + All Level 2 |
| Level 3 | 18 | All Level 1 + All Level 2 + All Level 3 |

---

## Quick Reference | Tham chiếu nhanh

### Level 1 Requirements | Yêu cầu Level 1

```
✓ Settings Loader (4 tests)
✓ Core Tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion
✓ Agent Loading with YAML Frontmatter
✓ @-Reference Resolution
✓ Command Execution with Variable Substitution
✓ Permission Checking (deny-first)
```

### Level 2 Requirements | Yêu cầu Level 2

```
✓ All Level 1
✓ settings.local.json Support
✓ Knowledge System with Selective Loading
✓ Memory System (context, decisions, learnings)
✓ Agent Tool Restrictions
✓ Advanced Permission Patterns
✓ TodoWrite and LSP Tools
```

### Level 3 Requirements | Yêu cầu Level 3

```
✓ All Level 2
✓ Team Coordination with Shared Memory
✓ Full Hook System (5 hook types)
✓ WebFetch and WebSearch Tools
✓ Session Archiving
```

---

*End of MicroAI Adapter Specification v1.0*

*MicroAI - Write Once, Run Anywhere*

*MicroAI - Viết một lần, chạy mọi nơi*
