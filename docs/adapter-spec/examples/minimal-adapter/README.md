# MicroAI Minimal Adapter

> Reference implementation for Level 1 compliance

Triển khai tham chiếu cho tuân thủ Level 1

---

## Overview | Tổng quan

This is a minimal adapter skeleton implementing **Level 1 compliance** of the MicroAI Adapter Specification. Use it as a starting point for building adapters for other platforms.

Đây là skeleton adapter tối thiểu triển khai **tuân thủ Level 1** của MicroAI Adapter Specification. Sử dụng làm điểm bắt đầu để xây dựng adapter cho các nền tảng khác.

---

## Structure | Cấu trúc

```
minimal-adapter/
├── package.json              # Dependencies and scripts
├── tsconfig.json             # TypeScript configuration
├── README.md                 # This file
└── src/
    ├── index.ts              # Main adapter class
    ├── types.ts              # Type definitions
    ├── settings-loader.ts    # Settings parser (Level 1)
    ├── permission-checker.ts # Permission validation (Level 1)
    ├── reference-resolver.ts # @-reference resolution (Level 1)
    ├── agent-loader.ts       # Agent loading (Level 1)
    ├── tool-registry.ts      # Tool management (Level 1)
    └── tools/
        ├── index.ts          # Tool exports
        ├── read.ts           # Read tool
        ├── write.ts          # Write tool
        ├── edit.ts           # Edit tool
        ├── glob.ts           # Glob tool
        ├── grep.ts           # Grep tool
        ├── bash.ts           # Bash tool
        └── ask-user-question.ts  # AskUserQuestion tool
```

---

## Installation | Cài đặt

```bash
cd examples/minimal-adapter
npm install
npm run build
```

---

## Usage | Sử dụng

### Basic Usage | Sử dụng cơ bản

```typescript
import { MicroAIAdapter } from './dist';

// Create adapter for a project
const adapter = new MicroAIAdapter('/path/to/project');

// Discover agents
const agents = await adapter.discoverAgents();
console.log('Available agents:', agents.map(a => a.name));

// Load and activate an agent
const agent = await adapter.loadAgent('.microai/agents/my-agent/agent.md');
const prompt = await adapter.activateAgent(agent);
console.log('Agent prompt:', prompt);

// Execute tools
const result = await adapter.executeTool('Read', {
  file_path: 'src/main.go'
});
console.log('Tool result:', result);

// Check permissions
const permission = adapter.checkPermission('Bash', 'rm -rf /');
console.log('Permission:', permission);
// { allowed: false, reason: "Denied by pattern: Bash(rm -rf:*)" }
```

### Integrating with Your Platform | Tích hợp với nền tảng của bạn

```typescript
import { MicroAIAdapter, ToolResult } from './dist';

class MyPlatformAdapter {
  private adapter: MicroAIAdapter;

  constructor(projectRoot: string) {
    // Use your platform's adapter directory
    this.adapter = new MicroAIAdapter(projectRoot, '.myplatform');
  }

  // Wrap tool execution for your platform
  async onToolRequest(toolName: string, params: any): Promise<ToolResult> {
    // Add pre-execution hooks here
    const result = await this.adapter.executeTool(toolName, params);
    // Add post-execution hooks here
    return result;
  }

  // Handle agent activation
  async activateAgentByName(name: string): Promise<string> {
    const agents = await this.adapter.discoverAgents();
    const agent = agents.find(a => a.name === name);
    if (!agent) {
      throw new Error(`Agent not found: ${name}`);
    }
    return this.adapter.activateAgent(agent);
  }
}
```

---

## Compliance Level | Mức độ tuân thủ

### Level 1 (Implemented) | Level 1 (Đã triển khai)

- [x] Settings Loader
  - [x] Parse `settings.json`
  - [x] Handle missing file gracefully
- [x] Core Tools
  - [x] Read (with offset/limit)
  - [x] Write (with directory creation)
  - [x] Edit (with replace_all)
  - [x] Glob (recursive patterns)
  - [x] Grep (regex, output modes)
  - [x] Bash (with timeout)
  - [x] AskUserQuestion (CLI implementation)
- [x] Agent System
  - [x] YAML frontmatter parsing
  - [x] Agent discovery
  - [x] Agent activation
- [x] Reference Resolution
  - [x] @.microai/ references
  - [x] @./ references
  - [x] Reference expansion
- [x] Permission Checking
  - [x] Deny-first resolution
  - [x] Exact/prefix/glob patterns

### Level 2 (Partial) | Level 2 (Một phần)

- [x] `settings.local.json` support
- [x] Agent tool restrictions
- [x] Basic knowledge loading (core_files only)
- [x] Basic memory loading (context.md, decisions.md)
- [ ] Full keyword-based knowledge selection
- [ ] TodoWrite tool
- [ ] LSP tool

### Level 3 (Not Implemented) | Level 3 (Chưa triển khai)

- [ ] Team coordination
- [ ] Hook system
- [ ] WebFetch/WebSearch tools
- [ ] Session archiving

---

## Extending | Mở rộng

### Adding a New Tool | Thêm công cụ mới

```typescript
import { BaseTool, ToolResult, ValidationResult } from './dist';

class MyCustomTool extends BaseTool {
  name = 'MyTool';

  async execute(params: Record<string, unknown>): Promise<ToolResult> {
    // Your implementation here
    return this.success({ data: 'result' });
  }

  validate(params: Record<string, unknown>): ValidationResult {
    if (!params.required_field) {
      return this.invalid('required_field is required');
    }
    return this.valid();
  }
}

// Register in adapter
adapter.toolRegistry.register(new MyCustomTool());
```

### Custom Permission Patterns | Pattern quyền tùy chỉnh

Extend `PermissionChecker` to support custom patterns:

```typescript
class CustomPermissionChecker extends PermissionChecker {
  protected matchesParam(pattern: string, param: string): boolean {
    // Add custom pattern matching
    if (pattern.startsWith('custom:')) {
      // Your logic
      return true;
    }

    // Fall back to default
    return super.matchesParam(pattern, param);
  }
}
```

---

## Testing | Kiểm thử

```bash
# Run compliance tests
npm test

# Test specific compliance level
npm test -- --grep "Level 1"
```

---

## License | Giấy phép

MIT

---

## See Also | Xem thêm

- [MicroAI Adapter Specification](../../README.md)
- [Compliance Checklist](../../11-compliance-checklist.md)
- [Implementation Guide](../../10-implementation-guide.md)
