/**
 * Glob Tool
 * Công cụ tìm file theo pattern
 *
 * Level 1 Compliance
 */

import { glob as globFunc } from 'glob';
import * as path from 'path';
import { BaseTool } from '../tool-registry';
import { ToolResult, ValidationResult, GlobParams } from '../types';

export class GlobTool extends BaseTool {
  name = 'Glob';

  async execute(params: Record<string, unknown>): Promise<ToolResult> {
    const { pattern, path: basePath } = params as GlobParams;

    try {
      // Determine search directory
      const searchDir = basePath || process.cwd();

      // Execute glob
      const files = await globFunc(pattern, {
        cwd: searchDir,
        nodir: true,
        dot: true,
        absolute: false
      });

      // Sort files (by modification time would require additional stat calls)
      // For minimal implementation, sort alphabetically
      files.sort();

      return this.success({
        files,
        count: files.length
      });
    } catch (error) {
      return this.error(`Glob failed: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  validate(params: Record<string, unknown>): ValidationResult {
    const { pattern, path: basePath } = params as Partial<GlobParams>;

    if (!pattern) {
      return this.invalid('pattern is required');
    }

    if (typeof pattern !== 'string') {
      return this.invalid('pattern must be a string');
    }

    if (basePath !== undefined && typeof basePath !== 'string') {
      return this.invalid('path must be a string');
    }

    return this.valid();
  }
}
