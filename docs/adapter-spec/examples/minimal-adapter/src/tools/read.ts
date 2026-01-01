/**
 * Read Tool
 * Công cụ đọc file
 *
 * Level 1 Compliance
 */

import * as fs from 'fs';
import { BaseTool } from '../tool-registry';
import { ToolResult, ValidationResult, ReadParams } from '../types';

export class ReadTool extends BaseTool {
  name = 'Read';

  async execute(params: Record<string, unknown>): Promise<ToolResult> {
    const { file_path, offset, limit } = params as ReadParams;

    try {
      // Check if file exists
      if (!fs.existsSync(file_path)) {
        return this.error(`File not found: ${file_path}`);
      }

      // Read file content
      const content = await fs.promises.readFile(file_path, 'utf-8');
      const lines = content.split('\n');

      // Apply offset and limit
      const startLine = offset || 0;
      const endLine = limit ? startLine + limit : lines.length;
      const selectedLines = lines.slice(startLine, endLine);

      // Format with line numbers (1-based, right-aligned)
      const maxLineNum = endLine;
      const lineNumWidth = String(maxLineNum).length + 1;

      const numberedContent = selectedLines
        .map((line, i) => {
          const lineNum = String(startLine + i + 1).padStart(lineNumWidth);
          return `${lineNum}\t${line}`;
        })
        .join('\n');

      return this.success({
        content: numberedContent,
        total_lines: lines.length
      });
    } catch (error) {
      return this.error(`Failed to read file: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  validate(params: Record<string, unknown>): ValidationResult {
    const { file_path, offset, limit } = params as Partial<ReadParams>;

    if (!file_path) {
      return this.invalid('file_path is required');
    }

    if (typeof file_path !== 'string') {
      return this.invalid('file_path must be a string');
    }

    if (offset !== undefined && (typeof offset !== 'number' || offset < 0)) {
      return this.invalid('offset must be a non-negative number');
    }

    if (limit !== undefined && (typeof limit !== 'number' || limit < 1)) {
      return this.invalid('limit must be a positive number');
    }

    return this.valid();
  }
}
