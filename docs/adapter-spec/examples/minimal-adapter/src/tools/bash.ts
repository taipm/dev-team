/**
 * Bash Tool
 * Công cụ thực thi shell
 *
 * Level 1 Compliance
 */

import { exec } from 'child_process';
import { BaseTool } from '../tool-registry';
import { ToolResult, ValidationResult, BashParams } from '../types';

export class BashTool extends BaseTool {
  name = 'Bash';

  async execute(params: Record<string, unknown>): Promise<ToolResult> {
    const { command, timeout = 120000, cwd } = params as BashParams;

    return new Promise((resolve) => {
      const options = {
        cwd: cwd || process.cwd(),
        timeout,
        maxBuffer: 10 * 1024 * 1024, // 10MB
        shell: '/bin/bash'
      };

      exec(command, options, (error, stdout, stderr) => {
        if (error && error.killed) {
          resolve(this.error(`Command timed out after ${timeout}ms`));
          return;
        }

        resolve(this.success({
          stdout: stdout.toString(),
          stderr: stderr.toString(),
          exit_code: error ? error.code || 1 : 0
        }));
      });
    });
  }

  validate(params: Record<string, unknown>): ValidationResult {
    const { command, timeout } = params as Partial<BashParams>;

    if (!command) {
      return this.invalid('command is required');
    }

    if (typeof command !== 'string') {
      return this.invalid('command must be a string');
    }

    if (timeout !== undefined) {
      if (typeof timeout !== 'number' || timeout < 0) {
        return this.invalid('timeout must be a non-negative number');
      }

      if (timeout > 600000) {
        return this.invalid('timeout cannot exceed 600000ms (10 minutes)');
      }
    }

    return this.valid();
  }
}
