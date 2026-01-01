/**
 * Write Tool
 * Công cụ ghi file
 *
 * Level 1 Compliance
 */

import * as fs from 'fs';
import * as path from 'path';
import { BaseTool } from '../tool-registry';
import { ToolResult, ValidationResult, WriteParams } from '../types';

export class WriteTool extends BaseTool {
  name = 'Write';

  async execute(params: Record<string, unknown>): Promise<ToolResult> {
    const { file_path, content } = params as WriteParams;

    try {
      // Create parent directories if needed
      const dir = path.dirname(file_path);
      if (!fs.existsSync(dir)) {
        await fs.promises.mkdir(dir, { recursive: true });
      }

      // Write file
      await fs.promises.writeFile(file_path, content, 'utf-8');

      return this.success({
        success: true,
        bytes_written: Buffer.byteLength(content, 'utf-8')
      });
    } catch (error) {
      return this.error(`Failed to write file: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  validate(params: Record<string, unknown>): ValidationResult {
    const { file_path, content } = params as Partial<WriteParams>;

    if (!file_path) {
      return this.invalid('file_path is required');
    }

    if (typeof file_path !== 'string') {
      return this.invalid('file_path must be a string');
    }

    if (content === undefined || content === null) {
      return this.invalid('content is required');
    }

    if (typeof content !== 'string') {
      return this.invalid('content must be a string');
    }

    return this.valid();
  }
}
