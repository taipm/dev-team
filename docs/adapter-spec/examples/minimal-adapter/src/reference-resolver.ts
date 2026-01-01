/**
 * Reference Resolver
 * Bộ phân giải tham chiếu
 *
 * Level 1 Compliance: Resolve @-references, load file content
 */

import * as fs from 'fs';
import * as path from 'path';
import { ReferenceType, ResolvedReference } from './types';

export class ReferenceResolver {
  private projectRoot: string;
  private userHome: string;

  constructor(projectRoot: string, userHome: string) {
    this.projectRoot = projectRoot;
    this.userHome = userHome;
  }

  /**
   * Resolve @-reference to absolute path
   * Phân giải tham chiếu @ thành đường dẫn tuyệt đối
   *
   * Reference types:
   * - @.microai/...  → Project's .microai directory
   * - @./...         → Project root relative
   * - @~/.claude/... → User home .claude directory
   * - @/...          → Absolute path (discouraged)
   */
  resolve(ref: string): ResolvedReference {
    if (!ref.startsWith('@')) {
      throw new Error(`Invalid reference: ${ref} (must start with @)`);
    }

    const refPath = ref.substring(1); // Remove @
    let type: ReferenceType;
    let absolutePath: string;

    // .microai/ reference
    if (refPath.startsWith('.microai/')) {
      type = 'microai';
      absolutePath = path.join(this.projectRoot, refPath);
    }
    // Project root reference
    else if (refPath.startsWith('./')) {
      type = 'project';
      absolutePath = path.join(this.projectRoot, refPath.substring(2));
    }
    // User home reference
    else if (refPath.startsWith('~/.claude/')) {
      type = 'home';
      absolutePath = path.join(this.userHome, '.claude', refPath.substring(10));
    }
    // Absolute path (discouraged but supported)
    else if (refPath.startsWith('/')) {
      type = 'absolute';
      absolutePath = refPath;
    }
    // Default: relative to project root
    else {
      type = 'project';
      absolutePath = path.join(this.projectRoot, refPath);
    }

    return {
      type,
      originalRef: ref,
      absolutePath
    };
  }

  /**
   * Load content from @-reference
   * Load nội dung từ tham chiếu @
   */
  async load(ref: string): Promise<string> {
    const resolved = this.resolve(ref);
    let targetPath = resolved.absolutePath;

    // Check if file exists
    if (!fs.existsSync(targetPath)) {
      // Try with common extensions
      const extensions = ['.md', '.yaml', '.yml', '.json', '.txt'];
      let found = false;

      for (const ext of extensions) {
        const withExt = targetPath + ext;
        if (fs.existsSync(withExt)) {
          targetPath = withExt;
          found = true;
          break;
        }
      }

      if (!found) {
        throw new Error(`Reference not found: ${ref} (tried ${resolved.absolutePath})`);
      }
    }

    return fs.promises.readFile(targetPath, 'utf-8');
  }

  /**
   * Find all @-references in content
   * Tìm tất cả tham chiếu @ trong nội dung
   */
  findReferences(content: string): string[] {
    // Match @-references that aren't in code blocks or comments
    const regex = /@[\w./-]+/g;
    const matches = content.match(regex) || [];

    // Deduplicate
    return [...new Set(matches)];
  }

  /**
   * Expand all @-references in content
   * Mở rộng tất cả tham chiếu @ trong nội dung
   */
  async expandReferences(content: string): Promise<string> {
    const refs = this.findReferences(content);
    let expanded = content;

    for (const ref of refs) {
      try {
        const refContent = await this.load(ref);
        expanded = expanded.replace(new RegExp(this.escapeRegex(ref), 'g'), refContent);
      } catch (error) {
        console.warn(`Could not expand reference ${ref}:`, error);
        // Keep original reference if can't expand
      }
    }

    return expanded;
  }

  /**
   * Resolve reference relative to a base file
   * Phân giải tham chiếu tương đối với file gốc
   *
   * This is used when a loaded file contains references
   * that should be relative to that file's location.
   */
  resolveRelative(ref: string, basePath: string): ResolvedReference {
    // If ref is @./ then it's relative to the base file's directory
    if (ref.startsWith('@./')) {
      const baseDir = path.dirname(basePath);
      const relativePath = ref.substring(3);
      const absolutePath = path.join(baseDir, relativePath);

      return {
        type: 'project',
        originalRef: ref,
        absolutePath
      };
    }

    // Otherwise use standard resolution
    return this.resolve(ref);
  }

  /**
   * Escape special regex characters
   */
  private escapeRegex(str: string): string {
    return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }
}
