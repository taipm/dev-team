# MicroAI Adapter Specification v1.0

> **Tài liệu song ngữ / Bilingual Documentation**
>
> English specifications with Vietnamese examples and comments.
> Tài liệu kỹ thuật tiếng Anh kèm ví dụ và chú thích tiếng Việt.

---

## Overview | Tổng quan

MicroAI is a **Platform-Agnostic AI Agent Framework** that enables AI agents to work across multiple coding assistants (Claude Code, VS Code, OpenCode, Cursor, etc.).

MicroAI là **Framework AI Agent đa nền tảng** cho phép các AI agent hoạt động trên nhiều trợ lý code khác nhau (Claude Code, VS Code, OpenCode, Cursor, v.v.).

### Architecture | Kiến trúc

```
┌─────────────────────────────────────────────────────────────────────────┐
│  LAYER 1: CORE FRAMEWORK (.microai/)                                    │
│  ════════════════════════════════════                                   │
│  Platform-independent agent definitions, knowledge, memory, teams       │
│  Định nghĩa agent, knowledge, memory, teams - độc lập nền tảng         │
│  → THIS IS THE PRODUCT | ĐÂY LÀ SẢN PHẨM CHÍNH                         │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
          ┌─────────────────────────┼─────────────────────────┐
          │                         │                         │
          ▼                         ▼                         ▼
┌─────────────────────┐  ┌─────────────────────┐  ┌─────────────────────┐
│ ADAPTER: .claude/   │  │ ADAPTER: .vscode/   │  │ ADAPTER: .opencode/ │
│ (Claude Code)       │  │ (VS Code/Copilot)   │  │ (OpenCode CLI)      │
│ ✅ IMPLEMENTED      │  │ 🔮 FUTURE           │  │ 🔮 FUTURE           │
└─────────────────────┘  └─────────────────────┘  └─────────────────────┘
```

### Key Principle | Nguyên tắc chính

```
.microai/  →  CORE (portable, no platform dependencies)
               Lõi (di động, không phụ thuộc nền tảng)

.{platform}/  →  ADAPTER (platform-specific activation)
                 Adapter (kích hoạt riêng cho từng nền tảng)
```

---

## Specification Documents | Tài liệu đặc tả

| # | Document | Description | Mô tả |
|---|----------|-------------|-------|
| 01 | [architecture.md](./01-architecture.md) | 3-layer architecture | Kiến trúc 3 lớp |
| 02 | [agent-format.md](./02-agent-format.md) | Agent YAML + Markdown format | Định dạng YAML + Markdown |
| 03 | [tool-abstraction.md](./03-tool-abstraction.md) | Canonical tool list | Danh sách tool chuẩn |
| 04 | [knowledge-system.md](./04-knowledge-system.md) | Knowledge loading & indexing | Hệ thống knowledge |
| 05 | [memory-system.md](./05-memory-system.md) | Memory persistence | Hệ thống lưu trữ memory |
| 06 | [team-coordination.md](./06-team-coordination.md) | Multi-agent teams | Phối hợp đa agent |
| 07 | [command-system.md](./07-command-system.md) | Commands & @-references | Lệnh và tham chiếu @ |
| 08 | [permission-model.md](./08-permission-model.md) | Security & permissions | Bảo mật và quyền hạn |
| 09 | [hooks-system.md](./09-hooks-system.md) | Automation hooks | Hook tự động hóa |
| 10 | [implementation-guide.md](./10-implementation-guide.md) | Building an adapter | Hướng dẫn xây dựng adapter |
| 11 | [compliance-checklist.md](./11-compliance-checklist.md) | Verification tests | Checklist kiểm tra |

---

## Compliance Levels | Mức độ tuân thủ

### Level 1: Minimal | Tối thiểu

Basic agent execution with core tools.
Thực thi agent cơ bản với các tool chính.

**Requirements | Yêu cầu:**
- Parse settings.json permissions
- Load agent.md with YAML frontmatter
- Implement core tools: `Read`, `Write`, `Edit`, `Glob`, `Grep`, `Bash`
- Resolve `@.microai/` references
- Execute agent activation protocol

### Level 2: Standard | Tiêu chuẩn (Recommended | Khuyến nghị)

Full agent system with knowledge and memory.
Hệ thống agent đầy đủ với knowledge và memory.

**Additional Requirements | Yêu cầu thêm:**
- Knowledge-index.yaml parsing & selective loading
- Memory system (context.md, decisions.md, learnings.md)
- Permission pattern matching with wildcards
- `AskUserQuestion` tool
- settings.local.json overrides

### Level 3: Full | Đầy đủ

Complete framework including teams and hooks.
Framework hoàn chỉnh bao gồm teams và hooks.

**Additional Requirements | Yêu cầu thêm:**
- Team memory coordination
- Handoff protocol between agents
- All hooks (PreToolUse, PostToolUse, etc.)
- Session archiving
- LSP and Web tools

---

## Quick Start | Bắt đầu nhanh

### For Adapter Developers | Cho người phát triển adapter

1. **Read Architecture** → Understand 3-layer model

   Đọc kiến trúc → Hiểu mô hình 3 lớp

2. **Implement Tools** → Start with core 6 tools

   Implement tools → Bắt đầu với 6 tool chính

3. **Load Agents** → Parse YAML + activate

   Load agents → Parse YAML + kích hoạt

4. **Test Compliance** → Use checklist

   Test tuân thủ → Dùng checklist

### For Agent Authors | Cho người viết agent

1. **Use .microai/** → Store agents here (portable)

   Dùng .microai/ → Lưu agent ở đây (di động)

2. **No Platform References** → Keep agents generic

   Không tham chiếu nền tảng → Giữ agent tổng quát

3. **Define Tools Abstractly** → Use canonical names

   Định nghĩa tool trừu tượng → Dùng tên chuẩn

---

## Examples | Ví dụ

### Minimal Adapter Skeleton

See [`examples/minimal-adapter/`](./examples/minimal-adapter/) for a basic implementation.

Xem [`examples/minimal-adapter/`](./examples/minimal-adapter/) cho implementation cơ bản.

### OpenCode Adapter

See [`examples/opencode-adapter/`](./examples/opencode-adapter/) for OpenCode CLI integration.

Xem [`examples/opencode-adapter/`](./examples/opencode-adapter/) cho tích hợp OpenCode CLI.

---

## Contributing | Đóng góp

We welcome adapter implementations for new platforms!

Chúng tôi hoan nghênh các adapter implementations cho nền tảng mới!

### Guidelines | Hướng dẫn

1. Implement at least **Level 2 compliance**
2. Include test suite using compliance checklist
3. Document platform-specific features
4. Submit PR with working example

---

## Version History | Lịch sử phiên bản

| Version | Date | Changes | Thay đổi |
|---------|------|---------|----------|
| 1.0 | 2025-12-31 | Initial specification | Đặc tả ban đầu |

---

## License | Giấy phép

MIT License - See [LICENSE](../../LICENSE)

---

*MicroAI - Write Once, Run Anywhere*

*MicroAI - Viết một lần, chạy mọi nơi*
