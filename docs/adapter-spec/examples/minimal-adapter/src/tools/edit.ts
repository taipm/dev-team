/**
 * Edit Tool
 * Công cụ sửa file
 *
 * Level 1 Compliance
 */

import * as fs from 'fs';
import { BaseTool } from '../tool-registry';
import { ToolResult, ValidationResult, EditParams } from '../types';

export class EditTool extends BaseTool {
  name = 'Edit';

  async execute(params: Record<string, unknown>): Promise<ToolResult> {
    const { file_path, old_string, new_string, replace_all } = params as EditParams;

    try {
      // Check if file exists
      if (!fs.existsSync(file_path)) {
        return this.error(`File not found: ${file_path}`);
      }

      // Read current content
      const content = await fs.promises.readFile(file_path, 'utf-8');

      // Check if old_string exists
      if (!content.includes(old_string)) {
        return this.error(`String not found in file: "${old_string.substring(0, 50)}..."`);
      }

      // Replace
      let newContent: string;
      let replacements: number;

      if (replace_all) {
        // Count occurrences
        const regex = new RegExp(this.escapeRegex(old_string), 'g');
        replacements = (content.match(regex) || []).length;
        newContent = content.replace(regex, new_string);
      } else {
        // Replace first occurrence only
        newContent = content.replace(old_string, new_string);
        replacements = 1;
      }

      // Write back
      await fs.promises.writeFile(file_path, newContent, 'utf-8');

      return this.success({
        success: true,
        replacements
      });
    } catch (error) {
      return this.error(`Failed to edit file: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  validate(params: Record<string, unknown>): ValidationResult {
    const { file_path, old_string, new_string } = params as Partial<EditParams>;

    if (!file_path) {
      return this.invalid('file_path is required');
    }

    if (typeof file_path !== 'string') {
      return this.invalid('file_path must be a string');
    }

    if (old_string === undefined || old_string === null) {
      return this.invalid('old_string is required');
    }

    if (typeof old_string !== 'string') {
      return this.invalid('old_string must be a string');
    }

    if (new_string === undefined || new_string === null) {
      return this.invalid('new_string is required');
    }

    if (typeof new_string !== 'string') {
      return this.invalid('new_string must be a string');
    }

    if (old_string === new_string) {
      return this.invalid('old_string and new_string must be different');
    }

    return this.valid();
  }

  /**
   * Escape special regex characters
   */
  private escapeRegex(str: string): string {
    return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }
}
