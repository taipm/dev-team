/**
 * Tool Registry
 * Registry công cụ
 *
 * Level 1 Compliance: Register and execute tools
 */

import { Tool, ToolResult, ValidationResult } from './types';
import { PermissionChecker } from './permission-checker';

export class ToolRegistry {
  private tools: Map<string, Tool> = new Map();
  private permissionChecker?: PermissionChecker;

  /**
   * Register a tool
   * Đăng ký công cụ
   */
  register(tool: Tool): void {
    this.tools.set(tool.name, tool);
  }

  /**
   * Get a registered tool
   * Lấy công cụ đã đăng ký
   */
  get(name: string): Tool | undefined {
    return this.tools.get(name);
  }

  /**
   * List all registered tools
   * Liệt kê tất cả công cụ đã đăng ký
   */
  list(): string[] {
    return Array.from(this.tools.keys());
  }

  /**
   * Set permission checker for tool execution
   * Đặt bộ kiểm tra quyền cho thực thi công cụ
   */
  setPermissionChecker(checker: PermissionChecker): void {
    this.permissionChecker = checker;
  }

  /**
   * Execute a tool with permission checking
   * Thực thi công cụ với kiểm tra quyền
   */
  async execute(name: string, params: Record<string, unknown>): Promise<ToolResult> {
    // 1. Find tool
    const tool = this.get(name);
    if (!tool) {
      return {
        success: false,
        error: `Tool not found: ${name}`
      };
    }

    // 2. Check permissions
    if (this.permissionChecker) {
      const paramString = this.getPermissionParam(name, params);
      const permission = this.permissionChecker.check(name, paramString);

      if (!permission.allowed) {
        return {
          success: false,
          error: `Permission denied: ${permission.reason}`
        };
      }
    }

    // 3. Validate parameters
    const validation = tool.validate(params);
    if (!validation.valid) {
      return {
        success: false,
        error: `Validation failed: ${validation.error}`
      };
    }

    // 4. Execute tool
    try {
      return await tool.execute(params);
    } catch (error) {
      return {
        success: false,
        error: `Execution failed: ${error instanceof Error ? error.message : String(error)}`
      };
    }
  }

  /**
   * Get parameter string for permission checking
   * Lấy chuỗi tham số để kiểm tra quyền
   */
  private getPermissionParam(name: string, params: Record<string, unknown>): string {
    switch (name) {
      case 'Read':
      case 'Write':
      case 'Edit':
        return params.file_path as string || '';
      case 'Bash':
        return params.command as string || '';
      case 'Glob':
        return params.pattern as string || '';
      case 'Grep':
        return params.pattern as string || '';
      case 'WebFetch':
        return params.url as string || '';
      default:
        return JSON.stringify(params);
    }
  }
}

/**
 * Abstract base class for tools
 * Lớp cơ sở trừu tượng cho công cụ
 */
export abstract class BaseTool implements Tool {
  abstract name: string;
  abstract execute(params: Record<string, unknown>): Promise<ToolResult>;
  abstract validate(params: Record<string, unknown>): ValidationResult;

  /**
   * Helper to create success result
   */
  protected success(data: unknown): ToolResult {
    return { success: true, data };
  }

  /**
   * Helper to create error result
   */
  protected error(message: string): ToolResult {
    return { success: false, error: message };
  }

  /**
   * Helper to create validation success
   */
  protected valid(): ValidationResult {
    return { valid: true };
  }

  /**
   * Helper to create validation error
   */
  protected invalid(message: string): ValidationResult {
    return { valid: false, error: message };
  }
}
