/**
 * MicroAI Minimal Adapter
 * Adapter tối thiểu cho MicroAI
 *
 * Level 1 Compliance Implementation
 *
 * This is a reference implementation demonstrating the minimal
 * requirements for a MicroAI adapter.
 */

import * as os from 'os';
import { SettingsLoader } from './settings-loader';
import { ToolRegistry } from './tool-registry';
import { PermissionChecker } from './permission-checker';
import { ReferenceResolver } from './reference-resolver';
import { AgentLoader } from './agent-loader';
import { createCoreTools } from './tools';
import {
  MicroAISettings,
  Agent,
  ToolResult,
  ExecutionContext
} from './types';

export class MicroAIAdapter {
  private projectRoot: string;
  private userHome: string;
  private adapterDir: string;

  // Components
  private settingsLoader: SettingsLoader;
  private toolRegistry: ToolRegistry;
  private permissionChecker: PermissionChecker;
  private referenceResolver: ReferenceResolver;
  private agentLoader: AgentLoader;

  // State
  private settings: MicroAISettings;
  private activeAgent?: Agent;
  private context: ExecutionContext;

  /**
   * Create a new MicroAI adapter
   * Tạo adapter MicroAI mới
   *
   * @param projectRoot - Project root directory
   * @param adapterDir - Adapter directory name (default: '.claude')
   */
  constructor(projectRoot: string, adapterDir: string = '.claude') {
    this.projectRoot = projectRoot;
    this.userHome = os.homedir();
    this.adapterDir = adapterDir;

    // Initialize context
    this.context = {
      projectRoot: this.projectRoot,
      userHome: this.userHome,
      platform: 'minimal-adapter',
      sessionId: this.generateSessionId(),
      timestamp: new Date().toISOString()
    };

    // Initialize components
    this.settingsLoader = new SettingsLoader(projectRoot, adapterDir);
    this.settings = this.settingsLoader.load();

    this.referenceResolver = new ReferenceResolver(projectRoot, this.userHome);
    this.agentLoader = new AgentLoader(projectRoot, this.referenceResolver);
    this.permissionChecker = new PermissionChecker(this.settings);

    // Initialize tool registry with core tools
    this.toolRegistry = new ToolRegistry();
    this.toolRegistry.setPermissionChecker(this.permissionChecker);

    for (const tool of createCoreTools()) {
      this.toolRegistry.register(tool);
    }
  }

  // ===========================================================================
  // Public API
  // ===========================================================================

  /**
   * Discover all available agents
   * Khám phá tất cả agent khả dụng
   */
  async discoverAgents(): Promise<Agent[]> {
    return this.agentLoader.discover();
  }

  /**
   * Load an agent by path
   * Load agent theo đường dẫn
   */
  async loadAgent(agentPath: string): Promise<Agent> {
    return this.agentLoader.load(agentPath);
  }

  /**
   * Activate an agent and get the full prompt
   * Kích hoạt agent và lấy prompt đầy đủ
   */
  async activateAgent(agent: Agent): Promise<string> {
    this.activeAgent = agent;

    // Update permission checker with agent restrictions
    this.permissionChecker = new PermissionChecker(this.settings, agent);
    this.toolRegistry.setPermissionChecker(this.permissionChecker);

    // Update context
    this.context.agentName = agent.name;

    // Generate activation prompt
    return this.agentLoader.activate(agent);
  }

  /**
   * Execute a tool
   * Thực thi công cụ
   */
  async executeTool(toolName: string, params: Record<string, unknown>): Promise<ToolResult> {
    return this.toolRegistry.execute(toolName, params);
  }

  /**
   * List available tools
   * Liệt kê công cụ khả dụng
   */
  listTools(): string[] {
    let tools = this.toolRegistry.list();

    // If agent has tool restrictions, filter
    if (this.activeAgent?.tools) {
      tools = tools.filter(t => this.activeAgent!.tools!.includes(t));
    }

    return tools;
  }

  /**
   * Check if a tool operation is permitted
   * Kiểm tra thao tác công cụ có được phép không
   */
  checkPermission(toolName: string, param: string): { allowed: boolean; reason: string } {
    return this.permissionChecker.check(toolName, param);
  }

  /**
   * Resolve an @-reference
   * Phân giải tham chiếu @
   */
  resolveReference(ref: string): string {
    return this.referenceResolver.resolve(ref).absolutePath;
  }

  /**
   * Load content from an @-reference
   * Load nội dung từ tham chiếu @
   */
  async loadReference(ref: string): Promise<string> {
    return this.referenceResolver.load(ref);
  }

  /**
   * Get current execution context
   * Lấy context thực thi hiện tại
   */
  getContext(): ExecutionContext {
    return { ...this.context };
  }

  /**
   * Get current settings
   * Lấy cấu hình hiện tại
   */
  getSettings(): MicroAISettings {
    return { ...this.settings };
  }

  /**
   * Get active agent
   * Lấy agent đang hoạt động
   */
  getActiveAgent(): Agent | undefined {
    return this.activeAgent;
  }

  // ===========================================================================
  // Private Methods
  // ===========================================================================

  private generateSessionId(): string {
    return `session-${Date.now()}-${Math.random().toString(36).substring(7)}`;
  }
}

// ===========================================================================
// Exports
// ===========================================================================

export * from './types';
export { SettingsLoader } from './settings-loader';
export { ToolRegistry, BaseTool } from './tool-registry';
export { PermissionChecker } from './permission-checker';
export { ReferenceResolver } from './reference-resolver';
export { AgentLoader } from './agent-loader';
export * from './tools';
