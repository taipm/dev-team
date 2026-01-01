import { existsSync, mkdirSync, copyFileSync, readdirSync, statSync, chmodSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import chalk from 'chalk';
import ora from 'ora';
import inquirer from 'inquirer';
import fsExtra from 'fs-extra';
import { execSync } from 'child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const TEMPLATES_DIR = join(__dirname, '../../templates');

/**
 * Copy directory recursively
 */
function copyDirSync(src, dest) {
  mkdirSync(dest, { recursive: true });
  const entries = readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    const srcPath = join(src, entry.name);
    const destPath = join(dest, entry.name);

    if (entry.isDirectory()) {
      copyDirSync(srcPath, destPath);
    } else {
      copyFileSync(srcPath, destPath);
    }
  }
}

/**
 * Merge directory - copy only missing files
 */
function mergeDirSync(src, dest) {
  mkdirSync(dest, { recursive: true });
  const files = readdirSync(src);
  for (const file of files) {
    const srcFile = join(src, file);
    const destFile = join(dest, file);
    if (!existsSync(destFile)) {
      if (statSync(srcFile).isDirectory()) {
        copyDirSync(srcFile, destFile);
      } else {
        copyFileSync(srcFile, destFile);
      }
    }
  }
}

/**
 * Make all .sh files in directory executable
 */
function makeScriptsExecutable(dir) {
  if (!existsSync(dir)) return;

  const entries = readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const fullPath = join(dir, entry.name);
    if (entry.isDirectory()) {
      makeScriptsExecutable(fullPath);
    } else if (entry.name.endsWith('.sh')) {
      try {
        chmodSync(fullPath, '755');
      } catch (e) {
        // Ignore chmod errors on Windows
      }
    }
  }
}

/**
 * Merge hooks configuration into settings.json
 * Preserves existing user hooks, adds new ones from template
 */
function mergeHooksIntoSettings(hooksConfigPath, settingsPath) {
  if (!existsSync(hooksConfigPath)) return false;

  try {
    // Read hooks config from template
    const hooksConfig = JSON.parse(fsExtra.readFileSync(hooksConfigPath, 'utf-8'));
    const templateHooks = hooksConfig.hooks || {};

    // Read existing settings or create new
    let settings = {};
    if (existsSync(settingsPath)) {
      settings = JSON.parse(fsExtra.readFileSync(settingsPath, 'utf-8'));
    }

    // Initialize hooks section if not exists
    if (!settings.hooks) {
      settings.hooks = {};
    }

    // Merge each hook type
    for (const [hookType, hookArray] of Object.entries(templateHooks)) {
      if (!settings.hooks[hookType]) {
        settings.hooks[hookType] = [];
      }

      // Add hooks that don't already exist (check by command path)
      for (const hook of hookArray) {
        const hookCommand = hook.hooks?.[0]?.command || '';
        const exists = settings.hooks[hookType].some(existingHook => {
          const existingCommand = existingHook.hooks?.[0]?.command || '';
          return existingCommand === hookCommand;
        });

        if (!exists) {
          settings.hooks[hookType].push(hook);
        }
      }
    }

    // Write back settings
    fsExtra.writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + '\n');
    return true;
  } catch (error) {
    console.error(`Warning: Could not merge hooks config: ${error.message}`);
    return false;
  }
}

/**
 * Check if .claude directory already exists
 */
function checkExistingInstallation(targetPath) {
  const claudeDir = join(targetPath, '.claude');
  return existsSync(claudeDir);
}

/**
 * Check if .microai directory already exists
 */
function checkExistingMicroai(targetPath) {
  const microaiDir = join(targetPath, '.microai');
  return existsSync(microaiDir);
}

/**
 * Main install function
 */
export async function install(options) {
  const targetPath = options.path;
  const spinner = ora();

  console.log(chalk.blue('\n🚀 Dev-Team Installer\n'));
  console.log(chalk.gray(`Target: ${targetPath}\n`));

  // Check for existing installation
  const hasExistingClaude = checkExistingInstallation(targetPath);
  const hasExistingMicroai = checkExistingMicroai(targetPath);

  if ((hasExistingClaude || hasExistingMicroai) && !options.force) {
    if (options.interactive !== false) {
      const existing = [];
      if (hasExistingClaude) existing.push('.claude');
      if (hasExistingMicroai) existing.push('.microai');

      const { action } = await inquirer.prompt([
        {
          type: 'list',
          name: 'action',
          message: `Existing ${existing.join(' and ')} directory found. What would you like to do?`,
          choices: [
            { name: 'Merge (keep existing, add missing)', value: 'merge' },
            { name: 'Overwrite (replace all)', value: 'overwrite' },
            { name: 'Cancel', value: 'cancel' }
          ]
        }
      ]);

      if (action === 'cancel') {
        console.log(chalk.yellow('\n⚠️  Installation cancelled.\n'));
        return;
      }

      if (action === 'overwrite') {
        options.force = true;
      }
    } else {
      console.log(chalk.yellow('⚠️  Existing installation found. Use --force to overwrite.\n'));
      return;
    }
  }

  // Select components to install
  let components = ['claude-md', 'settings', 'agents', 'skills', 'commands', 'microai', 'hooks'];

  if (options.interactive !== false) {
    const { selectedComponents } = await inquirer.prompt([
      {
        type: 'checkbox',
        name: 'selectedComponents',
        message: 'Select components to install:',
        choices: [
          { name: chalk.cyan('─── .claude/ ───'), value: 'separator1', disabled: true },
          { name: 'CLAUDE.md (project context)', value: 'claude-md', checked: true },
          { name: 'settings.json (team configuration)', value: 'settings', checked: true },
          { name: 'agents/ (agent templates)', value: 'agents', checked: true },
          { name: 'skills/ (skill templates)', value: 'skills', checked: true },
          { name: 'commands/ (command templates)', value: 'commands', checked: true },
          { name: chalk.cyan('─── .microai/ ───'), value: 'separator2', disabled: true },
          { name: chalk.yellow('★ MicroAI Framework (agents, teams, commands)'), value: 'microai', checked: true },
          { name: chalk.green('★ Hooks (logging, security, protection)'), value: 'hooks', checked: true }
        ]
      }
    ]);
    components = selectedComponents.filter(c => !c.startsWith('separator'));
  }

  if (components.length === 0) {
    console.log(chalk.yellow('\n⚠️  No components selected. Installation cancelled.\n'));
    return;
  }

  // Start installation
  spinner.start('Installing dev-team configuration...');

  try {
    const claudeDir = join(targetPath, '.claude');
    const microaiDir = join(targetPath, '.microai');

    // Create .claude directory
    mkdirSync(claudeDir, { recursive: true });

    // Install .claude components
    if (components.includes('claude-md')) {
      const src = join(TEMPLATES_DIR, '.claude', 'CLAUDE.md');
      const dest = join(claudeDir, 'CLAUDE.md');
      if (existsSync(src) && (options.force || !existsSync(dest))) {
        copyFileSync(src, dest);
      }
    }

    if (components.includes('settings')) {
      const src = join(TEMPLATES_DIR, '.claude', 'settings.json');
      const dest = join(claudeDir, 'settings.json');
      if (existsSync(src) && (options.force || !existsSync(dest))) {
        copyFileSync(src, dest);
      }
    }

    if (components.includes('agents')) {
      const src = join(TEMPLATES_DIR, '.claude', 'agents');
      const dest = join(claudeDir, 'agents');
      if (existsSync(src)) {
        if (options.force) {
          copyDirSync(src, dest);
        } else {
          mergeDirSync(src, dest);
        }
      }
    }

    if (components.includes('skills')) {
      const src = join(TEMPLATES_DIR, '.claude', 'skills');
      const dest = join(claudeDir, 'skills');
      if (existsSync(src)) {
        if (options.force) {
          copyDirSync(src, dest);
        } else {
          mergeDirSync(src, dest);
        }
      }
    }

    if (components.includes('commands')) {
      const src = join(TEMPLATES_DIR, '.claude', 'commands');
      const dest = join(claudeDir, 'commands');
      if (existsSync(src)) {
        if (options.force) {
          copyDirSync(src, dest);
        } else {
          mergeDirSync(src, dest);
        }
      }
    }

    // Install MicroAI Framework
    if (components.includes('microai')) {
      spinner.text = 'Installing MicroAI Framework...';
      const src = join(TEMPLATES_DIR, '.microai');
      if (existsSync(src)) {
        if (options.force) {
          copyDirSync(src, microaiDir);
        } else {
          mergeDirSync(src, microaiDir);
        }
      }
    }

    // Install Hooks
    if (components.includes('hooks')) {
      spinner.text = 'Installing hooks...';

      // Copy hooks scripts to .microai/hooks/
      const hooksSrc = join(TEMPLATES_DIR, '.microai', 'hooks');
      const hooksDest = join(microaiDir, 'hooks');

      if (existsSync(hooksSrc)) {
        mkdirSync(hooksDest, { recursive: true });
        if (options.force) {
          copyDirSync(hooksSrc, hooksDest);
        } else {
          mergeDirSync(hooksSrc, hooksDest);
        }

        // Make all hook scripts executable
        makeScriptsExecutable(hooksDest);
      }

      // Merge hooks config into .claude/settings.json
      const hooksConfigPath = join(TEMPLATES_DIR, '.microai', 'hooks.json');
      const settingsPath = join(claudeDir, 'settings.json');

      // Ensure settings.json exists before merging
      if (!existsSync(settingsPath)) {
        const templateSettings = join(TEMPLATES_DIR, '.claude', 'settings.json');
        if (existsSync(templateSettings)) {
          copyFileSync(templateSettings, settingsPath);
        } else {
          fsExtra.writeFileSync(settingsPath, '{}');
        }
      }

      const hooksMerged = mergeHooksIntoSettings(hooksConfigPath, settingsPath);
      if (hooksMerged) {
        spinner.text = 'Hooks configuration merged into settings.json';
      }
    }

    // Update .gitignore
    const gitignorePath = join(targetPath, '.gitignore');
    const gitignoreEntries = `
# Claude Code local settings
.claude/settings.local.json

# MicroAI local settings
.microai/settings.local.json

# MicroAI logs (auto-generated by hooks)
.microai/logs/

# MicroAI session context
.microai/.session-context
`;

    if (existsSync(gitignorePath)) {
      const content = fsExtra.readFileSync(gitignorePath, 'utf-8');
      if (!content.includes('settings.local.json')) {
        fsExtra.appendFileSync(gitignorePath, gitignoreEntries);
      } else if (!content.includes('.microai/logs/')) {
        // Add logs entry if settings.local was already there but logs wasn't
        fsExtra.appendFileSync(gitignorePath, '\n# MicroAI logs (auto-generated by hooks)\n.microai/logs/\n.microai/.session-context\n');
      }
    } else {
      fsExtra.writeFileSync(gitignorePath, gitignoreEntries.trim() + '\n');
    }

    spinner.succeed(chalk.green('Installation complete!'));

    // Show summary
    console.log(chalk.blue('\n📁 Installed structure:\n'));

    // .claude structure
    console.log(chalk.white('.claude/'));
    if (components.includes('claude-md')) console.log(chalk.gray('├── CLAUDE.md'));
    if (components.includes('settings')) console.log(chalk.gray('├── settings.json'));
    if (components.includes('agents')) console.log(chalk.gray('├── agents/'));
    if (components.includes('skills')) console.log(chalk.gray('├── skills/'));
    if (components.includes('commands')) {
      console.log(chalk.gray('└── commands/'));
      console.log(chalk.gray('    └── microai/    # MicroAI commands'));
    }

    // .microai structure
    if (components.includes('microai') || components.includes('hooks')) {
      console.log(chalk.yellow('\n.microai/'));
      if (components.includes('microai')) {
        console.log(chalk.gray('├── agents/         # Agent definitions'));
        console.log(chalk.gray('│   └── microai/'));
        console.log(chalk.gray('│       ├── agents/ # Individual agents'));
        console.log(chalk.gray('│       └── teams/  # Team structures'));
        console.log(chalk.gray('├── commands/       # Team commands'));
        console.log(chalk.gray('├── kanban/         # Kanban board'));
        console.log(chalk.gray('├── go-refactor/    # Go refactoring patterns'));
      }
      if (components.includes('hooks')) {
        console.log(chalk.green('├── hooks/          # Automation hooks'));
        console.log(chalk.gray('│   ├── pre-tool-use/'));
        console.log(chalk.gray('│   ├── post-tool-use/'));
        console.log(chalk.gray('│   ├── user-prompt-submit/'));
        console.log(chalk.gray('│   └── session-start/'));
        console.log(chalk.gray('└── logs/           # Auto-generated logs'));
      }
    }

    console.log(chalk.blue('\n📝 Next steps:\n'));
    console.log('1. Edit .claude/CLAUDE.md with your project context');
    console.log('2. Customize .claude/settings.json for your team');

    if (components.includes('microai')) {
      console.log(chalk.yellow('\n🤖 MicroAI Commands:'));
      console.log('   /microai go dev      - Start Go development');
      console.log('   /microai go team     - Activate Go team');
      console.log('   /microai kanban show - View Kanban board');
    }

    if (components.includes('hooks')) {
      console.log(chalk.green('\n🔒 Installed Hooks:'));
      console.log('   • PreToolUse:  Log bash commands, block dangerous ops, protect sensitive files');
      console.log('   • PostToolUse: Log file modifications');
      console.log('   • UserPromptSubmit: Log prompts history');
      console.log('   • SessionStart: Initialize environment');
      console.log(chalk.gray('   Logs: .microai/logs/'));
    }

    console.log(chalk.gray('\nSee README files in each directory for details.\n'));

  } catch (error) {
    spinner.fail(chalk.red('Installation failed'));
    console.error(chalk.red(`\nError: ${error.message}\n`));
    process.exit(1);
  }
}
