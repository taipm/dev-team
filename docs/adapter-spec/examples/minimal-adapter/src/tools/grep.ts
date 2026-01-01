/**
 * Grep Tool
 * Công cụ tìm nội dung file
 *
 * Level 1 Compliance
 */

import * as fs from 'fs';
import { glob } from 'glob';
import * as path from 'path';
import { BaseTool } from '../tool-registry';
import { ToolResult, ValidationResult, GrepParams } from '../types';

interface GrepMatch {
  file: string;
  line_number: number;
  content: string;
}

export class GrepTool extends BaseTool {
  name = 'Grep';

  async execute(params: Record<string, unknown>): Promise<ToolResult> {
    const grepParams = params as GrepParams;
    const {
      pattern,
      path: searchPath,
      glob: fileGlob,
      output_mode = 'files_with_matches'
    } = grepParams;

    const caseInsensitive = grepParams['-i'] || false;
    const showLineNumbers = grepParams['-n'] !== false; // Default true

    try {
      // Create regex
      const flags = caseInsensitive ? 'gi' : 'g';
      const regex = new RegExp(pattern, flags);

      // Find files to search
      let files: string[];
      const baseDir = searchPath || process.cwd();

      if (fileGlob) {
        files = await glob(fileGlob, { cwd: baseDir, nodir: true, absolute: true });
      } else if (fs.existsSync(baseDir) && fs.statSync(baseDir).isFile()) {
        files = [baseDir];
      } else {
        files = await glob('**/*', { cwd: baseDir, nodir: true, absolute: true });
      }

      // Search each file
      const allMatches: GrepMatch[] = [];
      const filesWithMatches: Set<string> = new Set();
      const matchCounts: Map<string, number> = new Map();

      for (const file of files) {
        try {
          const content = await fs.promises.readFile(file, 'utf-8');
          const lines = content.split('\n');

          let fileMatchCount = 0;

          for (let i = 0; i < lines.length; i++) {
            const line = lines[i];
            if (regex.test(line)) {
              fileMatchCount++;
              filesWithMatches.add(file);

              if (output_mode === 'content') {
                allMatches.push({
                  file: path.relative(baseDir, file),
                  line_number: i + 1,
                  content: line
                });
              }
            }
            // Reset regex lastIndex for global flag
            regex.lastIndex = 0;
          }

          if (fileMatchCount > 0) {
            matchCounts.set(path.relative(baseDir, file), fileMatchCount);
          }
        } catch {
          // Skip files that can't be read (binary, permission, etc.)
        }
      }

      // Return based on output mode
      switch (output_mode) {
        case 'content':
          return this.success({
            matches: allMatches,
            total_matches: allMatches.length
          });

        case 'count':
          return this.success({
            counts: Object.fromEntries(matchCounts),
            total_matches: Array.from(matchCounts.values()).reduce((a, b) => a + b, 0)
          });

        case 'files_with_matches':
        default:
          return this.success({
            files: Array.from(filesWithMatches).map(f => path.relative(baseDir, f)),
            total_matches: filesWithMatches.size
          });
      }
    } catch (error) {
      return this.error(`Grep failed: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  validate(params: Record<string, unknown>): ValidationResult {
    const { pattern } = params as Partial<GrepParams>;

    if (!pattern) {
      return this.invalid('pattern is required');
    }

    if (typeof pattern !== 'string') {
      return this.invalid('pattern must be a string');
    }

    // Validate regex
    try {
      new RegExp(pattern);
    } catch {
      return this.invalid(`Invalid regex pattern: ${pattern}`);
    }

    return this.valid();
  }
}
