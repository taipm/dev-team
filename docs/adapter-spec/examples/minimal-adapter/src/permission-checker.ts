/**
 * Permission Checker
 * Bộ kiểm tra quyền
 *
 * Level 1 Compliance: Basic pattern matching, deny-first resolution
 * Level 2 Compliance: Domain patterns, agent restrictions
 */

import { minimatch } from 'minimatch';
import { MicroAISettings, Agent, PermissionResult } from './types';

export class PermissionChecker {
  private settings: MicroAISettings;
  private agent?: Agent;

  constructor(settings: MicroAISettings, agent?: Agent) {
    this.settings = settings;
    this.agent = agent;
  }

  /**
   * Check if a tool operation is permitted
   * Kiểm tra thao tác tool có được phép không
   *
   * Resolution order:
   * 1. Agent tool restrictions (if agent specifies tools)
   * 2. DENY list (takes precedence)
   * 3. ALLOW list
   * 4. Platform default (deny by default for safety)
   */
  check(tool: string, param: string): PermissionResult {
    // 1. Check agent tool restrictions (Level 2)
    if (this.agent?.tools && this.agent.tools.length > 0) {
      if (!this.agent.tools.includes(tool)) {
        return {
          allowed: false,
          reason: `Agent '${this.agent.name}' does not have access to tool '${tool}'`
        };
      }
    }

    // 2. Check DENY list first (deny takes precedence)
    for (const pattern of this.settings.permissions.deny) {
      if (this.matchesPattern(pattern, tool, param)) {
        return {
          allowed: false,
          reason: `Denied by pattern: ${pattern}`
        };
      }
    }

    // 3. Check ALLOW list
    for (const pattern of this.settings.permissions.allow) {
      if (this.matchesPattern(pattern, tool, param)) {
        return {
          allowed: true,
          reason: `Allowed by pattern: ${pattern}`
        };
      }
    }

    // 4. Default: deny for safety
    return {
      allowed: false,
      reason: 'Not in allow list (default deny)'
    };
  }

  /**
   * Match a permission pattern against tool and param
   * Match pattern quyền với tool và param
   *
   * Pattern formats:
   * - "Tool(exact)" - Exact match
   * - "Tool(prefix:*)" - Prefix match
   * - "Tool(**/*.ext)" - Glob match
   * - "Tool(domain:example.com)" - Domain match (Level 2)
   */
  private matchesPattern(pattern: string, tool: string, param: string): boolean {
    // Parse pattern: Tool(match)
    const match = pattern.match(/^(\w+|\*)\((.+)\)$/);
    if (!match) {
      // Simple tool name match (no params)
      return pattern === tool;
    }

    const [, patternTool, patternMatch] = match;

    // Tool must match (or wildcard)
    if (patternTool !== '*' && patternTool !== tool) {
      return false;
    }

    // Check parameter match
    return this.matchesParam(patternMatch, param);
  }

  /**
   * Match parameter against pattern
   * Match tham số với pattern
   */
  private matchesParam(pattern: string, param: string): boolean {
    // 1. Prefix match (e.g., "git:*")
    if (pattern.endsWith(':*')) {
      const prefix = pattern.slice(0, -2);
      return param.startsWith(prefix);
    }

    // 2. Domain match (e.g., "domain:github.com")
    if (pattern.startsWith('domain:')) {
      const domain = pattern.substring(7);
      return this.matchesDomain(param, domain);
    }

    // 3. Glob match (contains * or **)
    if (pattern.includes('*')) {
      return minimatch(param, pattern, { dot: true });
    }

    // 4. Exact match
    return pattern === param;
  }

  /**
   * Match URL against domain pattern
   * Match URL với pattern domain
   */
  private matchesDomain(urlOrPath: string, domainPattern: string): boolean {
    try {
      // Try to parse as URL
      const url = new URL(urlOrPath);
      const hostname = url.hostname;

      // Subdomain wildcard (e.g., "*.anthropic.com")
      if (domainPattern.startsWith('*.')) {
        const baseDomain = domainPattern.substring(2);
        return hostname === baseDomain || hostname.endsWith('.' + baseDomain);
      }

      // Exact domain match
      return hostname === domainPattern;
    } catch {
      // Not a valid URL, no match
      return false;
    }
  }

  /**
   * Update agent for permission checking
   * Cập nhật agent để kiểm tra quyền
   */
  setAgent(agent?: Agent): void {
    this.agent = agent;
  }
}
