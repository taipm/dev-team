/**
 * Settings Loader
 * Bộ load cấu hình
 *
 * Level 1 Compliance: Parse settings.json
 * Level 2 Compliance: Merge with settings.local.json
 */

import * as fs from 'fs';
import * as path from 'path';
import { MicroAISettings, PermissionsConfig, HooksConfig, HookEntry } from './types';

export class SettingsLoader {
  private projectRoot: string;
  private adapterDir: string;

  /**
   * @param projectRoot - Project root directory
   * @param adapterDir - Adapter directory name (e.g., '.claude', '.opencode')
   */
  constructor(projectRoot: string, adapterDir: string = '.claude') {
    this.projectRoot = projectRoot;
    this.adapterDir = adapterDir;
  }

  /**
   * Load and merge settings
   * Load và merge cấu hình
   */
  load(): MicroAISettings {
    // Load team settings (required)
    const teamSettings = this.loadFile('settings.json');

    // Load local settings (optional, Level 2)
    const localSettings = this.loadFile('settings.local.json');

    // Merge with local overriding team
    return this.merge(teamSettings, localSettings);
  }

  /**
   * Load a settings file
   * Load file cấu hình
   */
  private loadFile(filename: string): Partial<MicroAISettings> {
    const fullPath = path.join(this.projectRoot, this.adapterDir, filename);

    if (!fs.existsSync(fullPath)) {
      return {};
    }

    try {
      const content = fs.readFileSync(fullPath, 'utf-8');
      return JSON.parse(content);
    } catch (error) {
      console.warn(`Failed to parse ${filename}:`, error);
      return {};
    }
  }

  /**
   * Merge team and local settings
   * Merge cấu hình team và local
   *
   * Strategy:
   * - permissions: local extends team (arrays concatenated)
   * - enabledPlugins: local overrides team
   * - mcpServers: local extends team
   * - hooks: local extends team
   * - model: local overrides team
   */
  private merge(
    team: Partial<MicroAISettings>,
    local: Partial<MicroAISettings>
  ): MicroAISettings {
    return {
      permissions: this.mergePermissions(
        team.permissions,
        local.permissions
      ),
      enabledPlugins: {
        ...team.enabledPlugins,
        ...local.enabledPlugins
      },
      mcpServers: {
        ...team.mcpServers,
        ...local.mcpServers
      },
      hooks: this.mergeHooks(team.hooks, local.hooks),
      model: {
        ...team.model,
        ...local.model
      }
    };
  }

  /**
   * Merge permissions (concatenate arrays)
   * Merge quyền (nối các mảng)
   */
  private mergePermissions(
    team?: PermissionsConfig,
    local?: PermissionsConfig
  ): PermissionsConfig {
    return {
      allow: [
        ...(team?.allow || []),
        ...(local?.allow || [])
      ],
      deny: [
        ...(team?.deny || []),
        ...(local?.deny || [])
      ]
    };
  }

  /**
   * Merge hooks (concatenate arrays per hook type)
   * Merge hooks (nối mảng theo từng loại hook)
   */
  private mergeHooks(
    team?: HooksConfig,
    local?: HooksConfig
  ): HooksConfig {
    const hookTypes: (keyof HooksConfig)[] = [
      'PreToolUse',
      'PostToolUse',
      'UserPromptSubmit',
      'SessionStart',
      'SessionEnd'
    ];

    const merged: HooksConfig = {};

    for (const hookType of hookTypes) {
      const teamHooks = team?.[hookType] || [];
      const localHooks = local?.[hookType] || [];

      if (teamHooks.length || localHooks.length) {
        merged[hookType] = [...teamHooks, ...localHooks];
      }
    }

    return merged;
  }

  /**
   * Get default settings when no file exists
   * Lấy cấu hình mặc định khi không có file
   */
  static getDefaults(): MicroAISettings {
    return {
      permissions: {
        allow: [],
        deny: [
          'Read(.env)',
          'Read(.env.*)',
          'Read(secrets/**)',
          'Read(**/*.pem)',
          'Read(**/*.key)',
          'Bash(rm -rf:*)',
          'Bash(sudo:*)'
        ]
      },
      enabledPlugins: {},
      mcpServers: {},
      hooks: {},
      model: {
        default: 'sonnet'
      }
    };
  }
}
