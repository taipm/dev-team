# 10 - Implementation Guide | Hướng dẫn triển khai

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

This guide provides a **step-by-step roadmap** for building a MicroAI adapter for any AI coding assistant platform.

Hướng dẫn này cung cấp **lộ trình từng bước** để xây dựng adapter MicroAI cho bất kỳ nền tảng AI coding assistant nào.

---

## Adapter Architecture | Kiến trúc Adapter

```
┌─────────────────────────────────────────────────────────────┐
│ YOUR PLATFORM (VS Code, OpenCode, Cursor, etc.)            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ MICROAI ADAPTER                                             │
│ ═══════════════                                             │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │  Settings   │  │    Tool     │  │   Agent     │        │
│  │   Loader    │  │   Registry  │  │   Loader    │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │  Reference  │  │   Memory    │  │   Command   │        │
│  │  Resolver   │  │   System    │  │   System    │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐                          │
│  │ Permission  │  │    Hook     │                          │
│  │   Checker   │  │   Executor  │                          │
│  └─────────────┘  └─────────────┘                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ .microai/ (Core Framework - Platform Independent)           │
└─────────────────────────────────────────────────────────────┘
```

---

## Implementation Steps | Các bước triển khai

### Phase 1: Settings Loader | Bộ load cấu hình

**Priority | Ưu tiên**: HIGH - Required for Level 1

```typescript
// Step 1.1: Define Settings Interface
interface MicroAISettings {
  permissions: {
    allow: string[];
    deny: string[];
  };
  enabledPlugins?: Record<string, boolean>;
  mcpServers?: Record<string, MCPServerConfig>;
  hooks?: HooksConfig;
  model?: ModelConfig;
}

// Step 1.2: Implement Settings Loader
class SettingsLoader {
  private projectRoot: string;

  constructor(projectRoot: string) {
    this.projectRoot = projectRoot;
  }

  load(): MicroAISettings {
    // Load team settings
    const teamSettings = this.loadFile('.{platform}/settings.json');

    // Load local settings (optional)
    const localSettings = this.loadFile('.{platform}/settings.local.json');

    // Merge with local overriding team
    return this.merge(teamSettings, localSettings);
  }

  private loadFile(relativePath: string): Partial<MicroAISettings> {
    const fullPath = path.join(this.projectRoot, relativePath);
    if (!fs.existsSync(fullPath)) {
      return {};
    }
    return JSON.parse(fs.readFileSync(fullPath, 'utf-8'));
  }

  private merge(team: Partial<MicroAISettings>, local: Partial<MicroAISettings>): MicroAISettings {
    return {
      permissions: {
        allow: [...(team.permissions?.allow || []), ...(local.permissions?.allow || [])],
        deny: [...(team.permissions?.deny || []), ...(local.permissions?.deny || [])]
      },
      enabledPlugins: { ...team.enabledPlugins, ...local.enabledPlugins },
      mcpServers: { ...team.mcpServers, ...local.mcpServers },
      hooks: this.mergeHooks(team.hooks, local.hooks),
      model: { ...team.model, ...local.model }
    };
  }
}
```

### Phase 2: Tool Registry | Registry công cụ

**Priority | Ưu tiên**: HIGH - Required for Level 1

```typescript
// Step 2.1: Define Tool Interface
interface Tool {
  name: string;
  execute(params: Record<string, any>): Promise<ToolResult>;
  validate(params: Record<string, any>): ValidationResult;
}

interface ToolResult {
  success: boolean;
  data?: any;
  error?: string;
}

// Step 2.2: Implement Core Tools
class ReadTool implements Tool {
  name = 'Read';

  async execute(params: { file_path: string; offset?: number; limit?: number }): Promise<ToolResult> {
    try {
      const content = await fs.promises.readFile(params.file_path, 'utf-8');
      const lines = content.split('\n');

      const offset = params.offset || 0;
      const limit = params.limit || lines.length;

      const selectedLines = lines.slice(offset, offset + limit);
      const numberedContent = selectedLines
        .map((line, i) => `${String(offset + i + 1).padStart(6)} ${line}`)
        .join('\n');

      return {
        success: true,
        data: {
          content: numberedContent,
          total_lines: lines.length
        }
      };
    } catch (error) {
      return { success: false, error: error.message };
    }
  }

  validate(params: any): ValidationResult {
    if (!params.file_path) {
      return { valid: false, error: 'file_path is required' };
    }
    return { valid: true };
  }
}

// Step 2.3: Create Tool Registry
class ToolRegistry {
  private tools: Map<string, Tool> = new Map();

  register(tool: Tool): void {
    this.tools.set(tool.name, tool);
  }

  get(name: string): Tool | undefined {
    return this.tools.get(name);
  }

  async execute(name: string, params: any): Promise<ToolResult> {
    const tool = this.get(name);
    if (!tool) {
      return { success: false, error: `Tool not found: ${name}` };
    }

    const validation = tool.validate(params);
    if (!validation.valid) {
      return { success: false, error: validation.error };
    }

    return tool.execute(params);
  }
}

// Step 2.4: Initialize with Core Tools
function initializeToolRegistry(): ToolRegistry {
  const registry = new ToolRegistry();

  // Core tools (Level 1)
  registry.register(new ReadTool());
  registry.register(new WriteTool());
  registry.register(new EditTool());
  registry.register(new GlobTool());
  registry.register(new GrepTool());
  registry.register(new BashTool());
  registry.register(new AskUserQuestionTool());

  // Standard tools (Level 2)
  registry.register(new TodoWriteTool());
  registry.register(new LSPTool());

  // Extended tools (Level 3)
  registry.register(new WebFetchTool());
  registry.register(new WebSearchTool());

  return registry;
}
```

### Phase 3: Reference Resolver | Bộ phân giải tham chiếu

**Priority | Ưu tiên**: HIGH - Required for Level 1

```typescript
// Step 3.1: Define Reference Types
type ReferenceType = 'microai' | 'project' | 'home' | 'absolute';

interface ResolvedReference {
  type: ReferenceType;
  originalRef: string;
  absolutePath: string;
  content?: string;
}

// Step 3.2: Implement Reference Resolver
class ReferenceResolver {
  private projectRoot: string;
  private userHome: string;

  constructor(projectRoot: string, userHome: string) {
    this.projectRoot = projectRoot;
    this.userHome = userHome;
  }

  resolve(ref: string): string {
    if (!ref.startsWith('@')) {
      throw new Error(`Invalid reference: ${ref} (must start with @)`);
    }

    const path = ref.substring(1); // Remove @

    // .microai/ reference
    if (path.startsWith('.microai/')) {
      return `${this.projectRoot}/${path}`;
    }

    // Project root reference
    if (path.startsWith('./')) {
      return `${this.projectRoot}/${path.substring(2)}`;
    }

    // User home reference
    if (path.startsWith('~/.claude/')) {
      return `${this.userHome}/.claude/${path.substring(10)}`;
    }

    // Absolute path (discouraged)
    if (path.startsWith('/')) {
      return path;
    }

    // Default: relative to project root
    return `${this.projectRoot}/${path}`;
  }

  async load(ref: string): Promise<string> {
    const absolutePath = this.resolve(ref);

    // Try with extensions if not found
    if (!await this.fileExists(absolutePath)) {
      for (const ext of ['.md', '.yaml', '.json', '.txt']) {
        const withExt = absolutePath + ext;
        if (await this.fileExists(withExt)) {
          return fs.promises.readFile(withExt, 'utf-8');
        }
      }
      throw new Error(`Reference not found: ${ref}`);
    }

    return fs.promises.readFile(absolutePath, 'utf-8');
  }

  // Find all @-references in content
  findReferences(content: string): string[] {
    const regex = /@[\w./-]+/g;
    return [...content.matchAll(regex)].map(m => m[0]);
  }

  // Load content and expand all references
  async expandReferences(content: string): Promise<string> {
    const refs = this.findReferences(content);
    let expanded = content;

    for (const ref of refs) {
      try {
        const refContent = await this.load(ref);
        expanded = expanded.replace(ref, refContent);
      } catch (error) {
        console.warn(`Could not expand reference ${ref}: ${error.message}`);
      }
    }

    return expanded;
  }

  private async fileExists(path: string): Promise<boolean> {
    try {
      await fs.promises.access(path);
      return true;
    } catch {
      return false;
    }
  }
}
```

### Phase 4: Agent Loader | Bộ load Agent

**Priority | Ưu tiên**: HIGH - Required for Level 1

```typescript
// Step 4.1: Define Agent Interface
interface Agent {
  name: string;
  description: string;
  model?: 'opus' | 'sonnet' | 'haiku';
  tools?: string[];
  language?: 'en' | 'vi';
  permissionMode?: string;
  skills?: string[];
  body: string;
  path: string;
}

// Step 4.2: Implement YAML Frontmatter Parser
function parseAgentFile(content: string): { frontmatter: any; body: string } {
  const frontmatterRegex = /^---\n([\s\S]*?)\n---\n([\s\S]*)$/;
  const match = content.match(frontmatterRegex);

  if (!match) {
    throw new Error('Invalid agent file: missing YAML frontmatter');
  }

  const yaml = require('js-yaml');
  const frontmatter = yaml.load(match[1]);
  const body = match[2];

  return { frontmatter, body };
}

// Step 4.3: Implement Agent Loader
class AgentLoader {
  private resolver: ReferenceResolver;
  private projectRoot: string;

  constructor(projectRoot: string, resolver: ReferenceResolver) {
    this.projectRoot = projectRoot;
    this.resolver = resolver;
  }

  async discover(): Promise<Agent[]> {
    const agentsDir = `${this.projectRoot}/.microai/agents`;
    if (!await this.directoryExists(agentsDir)) {
      return [];
    }

    const agents: Agent[] = [];
    await this.scanDirectory(agentsDir, agents);
    return agents;
  }

  async load(agentPath: string): Promise<Agent> {
    const content = await fs.promises.readFile(agentPath, 'utf-8');
    const { frontmatter, body } = parseAgentFile(content);

    return {
      name: frontmatter.name,
      description: frontmatter.description,
      model: frontmatter.model,
      tools: frontmatter.tools,
      language: frontmatter.language,
      permissionMode: frontmatter.permissionMode,
      skills: frontmatter.skills,
      body: body,
      path: agentPath
    };
  }

  async activate(agent: Agent): Promise<string> {
    // 1. Start with agent body
    let prompt = agent.body;

    // 2. Expand @-references
    prompt = await this.resolver.expandReferences(prompt);

    // 3. Load knowledge (if knowledge-index.yaml exists)
    const knowledgeDir = path.dirname(agent.path) + '/knowledge';
    if (await this.directoryExists(knowledgeDir)) {
      const knowledge = await this.loadKnowledge(knowledgeDir, prompt);
      prompt = knowledge + '\n\n' + prompt;
    }

    // 4. Load memory (if memory/ exists)
    const memoryDir = path.dirname(agent.path) + '/memory';
    if (await this.directoryExists(memoryDir)) {
      const memory = await this.loadMemory(memoryDir);
      prompt = memory + '\n\n' + prompt;
    }

    return prompt;
  }

  private async loadKnowledge(knowledgeDir: string, task: string): Promise<string> {
    // Implementation based on 04-knowledge-system.md
    // ...
  }

  private async loadMemory(memoryDir: string): Promise<string> {
    // Implementation based on 05-memory-system.md
    // ...
  }

  private async scanDirectory(dir: string, agents: Agent[]): Promise<void> {
    const entries = await fs.promises.readdir(dir, { withFileTypes: true });

    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);

      if (entry.isDirectory()) {
        // Check for agent.md in subdirectory
        const agentPath = path.join(fullPath, 'agent.md');
        if (await this.fileExists(agentPath)) {
          agents.push(await this.load(agentPath));
        }
        // Recursively scan
        await this.scanDirectory(fullPath, agents);
      } else if (entry.name.endsWith('.md') && entry.name !== 'agent.md') {
        // Standalone agent file
        agents.push(await this.load(fullPath));
      }
    }
  }
}
```

### Phase 5: Permission Checker | Bộ kiểm tra quyền

**Priority | Ưu tiên**: MEDIUM - Required for Level 2

```typescript
// Step 5.1: Implement Pattern Matcher
class PatternMatcher {
  matches(pattern: string, tool: string, param: string): boolean {
    // Parse pattern: Tool(match)
    const match = pattern.match(/^(\w+)\((.+)\)$/);
    if (!match) return false;

    const [, patternTool, patternMatch] = match;

    // Tool must match
    if (patternTool !== tool && patternTool !== '*') {
      return false;
    }

    // Check parameter match
    if (patternMatch.endsWith(':*')) {
      // Prefix match
      const prefix = patternMatch.slice(0, -2);
      return param.startsWith(prefix);
    } else if (patternMatch.includes('*')) {
      // Glob match
      return this.globMatch(param, patternMatch);
    } else if (patternMatch.startsWith('domain:')) {
      // Domain match
      const domain = patternMatch.substring(7);
      return this.domainMatch(param, domain);
    } else {
      // Exact match
      return param === patternMatch;
    }
  }

  private globMatch(str: string, pattern: string): boolean {
    const regexPattern = pattern
      .replace(/\*\*/g, '<<<GLOBSTAR>>>')
      .replace(/\*/g, '[^/]*')
      .replace(/<<<GLOBSTAR>>>/g, '.*');
    return new RegExp(`^${regexPattern}$`).test(str);
  }

  private domainMatch(url: string, domain: string): boolean {
    try {
      const urlDomain = new URL(url).hostname;
      if (domain.startsWith('*.')) {
        const baseDomain = domain.substring(2);
        return urlDomain.endsWith(baseDomain);
      }
      return urlDomain === domain;
    } catch {
      return false;
    }
  }
}

// Step 5.2: Implement Permission Checker
class PermissionChecker {
  private matcher: PatternMatcher;
  private settings: MicroAISettings;
  private agent?: Agent;

  constructor(settings: MicroAISettings, agent?: Agent) {
    this.matcher = new PatternMatcher();
    this.settings = settings;
    this.agent = agent;
  }

  check(tool: string, param: string): PermissionResult {
    // 1. Check agent tool restrictions first
    if (this.agent?.tools && !this.agent.tools.includes(tool)) {
      return {
        allowed: false,
        reason: `Agent ${this.agent.name} does not have access to ${tool}`
      };
    }

    // 2. Check DENY list (takes precedence)
    for (const pattern of this.settings.permissions.deny) {
      if (this.matcher.matches(pattern, tool, param)) {
        return {
          allowed: false,
          reason: `Denied by pattern: ${pattern}`
        };
      }
    }

    // 3. Check ALLOW list
    for (const pattern of this.settings.permissions.allow) {
      if (this.matcher.matches(pattern, tool, param)) {
        return {
          allowed: true,
          reason: `Allowed by pattern: ${pattern}`
        };
      }
    }

    // 4. Default behavior (platform-specific)
    return {
      allowed: this.getDefaultBehavior(tool),
      reason: 'Using platform default'
    };
  }

  private getDefaultBehavior(tool: string): boolean {
    // Platform can define its default behavior
    // Most platforms default to requiring approval
    return false;
  }
}
```

### Phase 6: Memory System | Hệ thống Memory

**Priority | Ưu tiên**: MEDIUM - Required for Level 2

```typescript
// Step 6.1: Define Memory Interface
interface Memory {
  context?: string;
  decisions?: string[];
  learnings?: string[];
}

// Step 6.2: Implement Memory Manager
class MemoryManager {
  private agentPath: string;

  constructor(agentPath: string) {
    this.agentPath = agentPath;
  }

  async load(): Promise<Memory> {
    const memoryDir = path.join(path.dirname(this.agentPath), 'memory');

    const memory: Memory = {};

    // Load context.md (full file)
    const contextPath = path.join(memoryDir, 'context.md');
    if (await this.fileExists(contextPath)) {
      memory.context = await fs.promises.readFile(contextPath, 'utf-8');
    }

    // Load decisions.md (last 10 entries)
    const decisionsPath = path.join(memoryDir, 'decisions.md');
    if (await this.fileExists(decisionsPath)) {
      const content = await fs.promises.readFile(decisionsPath, 'utf-8');
      memory.decisions = this.parseDecisions(content).slice(-10);
    }

    return memory;
  }

  async save(memory: Memory): Promise<void> {
    const memoryDir = path.join(path.dirname(this.agentPath), 'memory');
    await fs.promises.mkdir(memoryDir, { recursive: true });

    // Save context
    if (memory.context) {
      await fs.promises.writeFile(
        path.join(memoryDir, 'context.md'),
        memory.context
      );
    }

    // Append decisions
    if (memory.decisions?.length) {
      const decisionsPath = path.join(memoryDir, 'decisions.md');
      const existing = await this.fileExists(decisionsPath)
        ? await fs.promises.readFile(decisionsPath, 'utf-8')
        : '';
      const newContent = memory.decisions.join('\n\n---\n\n');
      await fs.promises.writeFile(decisionsPath, existing + '\n\n' + newContent);
    }

    // Append learnings
    if (memory.learnings?.length) {
      const learningsPath = path.join(memoryDir, 'learnings.md');
      const existing = await this.fileExists(learningsPath)
        ? await fs.promises.readFile(learningsPath, 'utf-8')
        : '';
      const newContent = memory.learnings.join('\n\n---\n\n');
      await fs.promises.writeFile(learningsPath, existing + '\n\n' + newContent);
    }
  }

  private parseDecisions(content: string): string[] {
    return content.split(/\n---\n/).filter(d => d.trim());
  }
}
```

### Phase 7: Command System | Hệ thống Command

**Priority | Ưu tiên**: MEDIUM - Required for Level 2

```typescript
// Step 7.1: Define Command Interface
interface Command {
  name: string;
  namespace: string;
  description: string;
  argumentHint?: string;
  body: string;
  path: string;
}

// Step 7.2: Implement Command Executor
class CommandExecutor {
  private resolver: ReferenceResolver;
  private agentLoader: AgentLoader;

  constructor(resolver: ReferenceResolver, agentLoader: AgentLoader) {
    this.resolver = resolver;
    this.agentLoader = agentLoader;
  }

  async discover(projectRoot: string): Promise<Command[]> {
    const commandsDir = `${projectRoot}/.microai/commands`;
    if (!await this.directoryExists(commandsDir)) {
      return [];
    }

    const commands: Command[] = [];

    // Scan namespaces
    const namespaces = await fs.promises.readdir(commandsDir);
    for (const namespace of namespaces) {
      const namespaceDir = path.join(commandsDir, namespace);
      const stat = await fs.promises.stat(namespaceDir);
      if (!stat.isDirectory()) continue;

      // Scan command files
      const files = await fs.promises.readdir(namespaceDir);
      for (const file of files) {
        if (!file.endsWith('.md')) continue;

        const commandPath = path.join(namespaceDir, file);
        const command = await this.parseCommandFile(commandPath);
        command.namespace = namespace;
        commands.push(command);
      }
    }

    return commands;
  }

  async execute(input: string, context: ExecutionContext): Promise<string> {
    // Parse input: /{namespace}:{command} [args]
    const match = input.match(/^\/(\w+):(\w+)(?:\s+(.+))?$/);
    if (!match) {
      throw new Error('Invalid command format. Use: /{namespace}:{command} [args]');
    }

    const [, namespace, commandName, args] = match;

    // Find command file
    const commandPath = `${context.projectRoot}/.microai/commands/${namespace}/${commandName}.md`;
    if (!await this.fileExists(commandPath)) {
      throw new Error(`Command not found: ${namespace}:${commandName}`);
    }

    const command = await this.parseCommandFile(commandPath);

    // Substitute variables
    let body = command.body;
    body = body.replace(/\$ARGUMENTS/g, args || '');
    body = body.replace(/\$PROJECT_ROOT/g, context.projectRoot);
    body = body.replace(/\$TIMESTAMP/g, new Date().toISOString());
    body = body.replace(/\$AGENT_NAME/g, commandName);
    body = body.replace(/\$PLATFORM/g, context.platform);

    // Expand @-references
    body = await this.resolver.expandReferences(body);

    return body;
  }

  private async parseCommandFile(path: string): Promise<Command> {
    const content = await fs.promises.readFile(path, 'utf-8');
    const { frontmatter, body } = parseAgentFile(content);

    return {
      name: frontmatter.name,
      namespace: '', // Set by caller
      description: frontmatter.description,
      argumentHint: frontmatter['argument-hint'],
      body: body,
      path: path
    };
  }
}
```

### Phase 8: Hook Executor | Bộ thực thi Hook

**Priority | Ưu tiên**: LOW - Required for Level 3

```typescript
// Step 8.1: Implement Hook Executor
class HookExecutor {
  private settings: MicroAISettings;
  private matcher: PatternMatcher;

  constructor(settings: MicroAISettings) {
    this.settings = settings;
    this.matcher = new PatternMatcher();
  }

  async executePreToolUse(tool: string, input: any): Promise<HookResult> {
    return this.executeHooks('PreToolUse', {
      TOOL_NAME: tool,
      INPUT: JSON.stringify(input),
      TIMESTAMP: new Date().toISOString(),
      SESSION_ID: this.getSessionId()
    }, tool);
  }

  async executePostToolUse(tool: string, input: any, output: any): Promise<void> {
    await this.executeHooks('PostToolUse', {
      TOOL_NAME: tool,
      INPUT: JSON.stringify(input),
      OUTPUT: JSON.stringify(output),
      TIMESTAMP: new Date().toISOString(),
      SESSION_ID: this.getSessionId()
    }, tool);
  }

  async executeUserPromptSubmit(prompt: string): Promise<void> {
    await this.executeHooks('UserPromptSubmit', {
      PROMPT: prompt,
      TIMESTAMP: new Date().toISOString(),
      SESSION_ID: this.getSessionId(),
      USER_NAME: this.getUserName()
    });
  }

  async executeSessionStart(): Promise<void> {
    await this.executeHooks('SessionStart', {
      SESSION_ID: this.getSessionId(),
      TIMESTAMP: new Date().toISOString(),
      PROJECT_ROOT: this.getProjectRoot(),
      PLATFORM: this.getPlatform()
    });
  }

  async executeSessionEnd(): Promise<void> {
    await this.executeHooks('SessionEnd', {
      SESSION_ID: this.getSessionId(),
      TIMESTAMP: new Date().toISOString()
    });
  }

  private async executeHooks(
    hookType: string,
    env: Record<string, string>,
    tool?: string
  ): Promise<HookResult> {
    const hooks = this.settings.hooks?.[hookType] || [];

    for (const hook of hooks) {
      // Check matcher for tool hooks
      if (tool && hook.matcher) {
        if (!this.matcher.matches(hook.matcher, tool, env.INPUT || '')) {
          continue;
        }
      }

      // Execute hook
      const result = await this.executeShell(hook.command, env, hook.timeout || 5000);

      // Check result
      if (result.exitCode !== 0 && !hook.continueOnFailure) {
        return { success: false, blocked: true, message: result.stderr };
      }
    }

    return { success: true };
  }

  private async executeShell(
    command: string,
    env: Record<string, string>,
    timeout: number
  ): Promise<{ exitCode: number; stdout: string; stderr: string }> {
    // Implementation depends on platform
    // Use child_process.exec or similar
  }
}
```

---

## Integration Example | Ví dụ tích hợp

### Complete Adapter | Adapter hoàn chỉnh

```typescript
class MicroAIAdapter {
  private settingsLoader: SettingsLoader;
  private toolRegistry: ToolRegistry;
  private referenceResolver: ReferenceResolver;
  private agentLoader: AgentLoader;
  private permissionChecker: PermissionChecker;
  private memoryManager?: MemoryManager;
  private commandExecutor: CommandExecutor;
  private hookExecutor: HookExecutor;

  private settings: MicroAISettings;
  private activeAgent?: Agent;

  constructor(projectRoot: string, userHome: string) {
    // Initialize components
    this.settingsLoader = new SettingsLoader(projectRoot);
    this.settings = this.settingsLoader.load();

    this.toolRegistry = initializeToolRegistry();
    this.referenceResolver = new ReferenceResolver(projectRoot, userHome);
    this.agentLoader = new AgentLoader(projectRoot, this.referenceResolver);
    this.permissionChecker = new PermissionChecker(this.settings);
    this.commandExecutor = new CommandExecutor(this.referenceResolver, this.agentLoader);
    this.hookExecutor = new HookExecutor(this.settings);
  }

  async startSession(): Promise<void> {
    await this.hookExecutor.executeSessionStart();
  }

  async endSession(): Promise<void> {
    if (this.activeAgent && this.memoryManager) {
      // Save memory
      // ...
    }
    await this.hookExecutor.executeSessionEnd();
  }

  async executeCommand(input: string): Promise<string> {
    if (input.startsWith('/')) {
      // Slash command
      const prompt = await this.commandExecutor.execute(input, {
        projectRoot: this.projectRoot,
        platform: 'your-platform'
      });

      // Activate agent from command
      // ...

      return prompt;
    }

    // Regular tool execution
    // ...
  }

  async executeTool(tool: string, params: any): Promise<ToolResult> {
    // 1. Check permissions
    const permission = this.permissionChecker.check(tool, JSON.stringify(params));
    if (!permission.allowed) {
      return { success: false, error: permission.reason };
    }

    // 2. Execute pre-tool hooks
    const hookResult = await this.hookExecutor.executePreToolUse(tool, params);
    if (hookResult.blocked) {
      return { success: false, error: hookResult.message };
    }

    // 3. Execute tool
    const result = await this.toolRegistry.execute(tool, params);

    // 4. Execute post-tool hooks
    await this.hookExecutor.executePostToolUse(tool, params, result);

    return result;
  }

  async activateAgent(agentPath: string): Promise<string> {
    this.activeAgent = await this.agentLoader.load(agentPath);
    this.memoryManager = new MemoryManager(agentPath);
    this.permissionChecker = new PermissionChecker(this.settings, this.activeAgent);

    return this.agentLoader.activate(this.activeAgent);
  }
}
```

---

## Summary | Tóm tắt

| Phase | Component | Level | Priority |
|-------|-----------|-------|----------|
| 1 | Settings Loader | 1 | HIGH |
| 2 | Tool Registry | 1 | HIGH |
| 3 | Reference Resolver | 1 | HIGH |
| 4 | Agent Loader | 1 | HIGH |
| 5 | Permission Checker | 2 | MEDIUM |
| 6 | Memory System | 2 | MEDIUM |
| 7 | Command System | 2 | MEDIUM |
| 8 | Hook Executor | 3 | LOW |

---

*Next: [11-compliance-checklist.md](./11-compliance-checklist.md) - Verification Tests*
