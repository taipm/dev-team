#!/usr/bin/env node

import { Command } from 'commander';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { readFileSync } from 'fs';
import { install } from '../src/commands/install.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const packageJson = JSON.parse(
  readFileSync(join(__dirname, '../package.json'), 'utf-8')
);

const program = new Command();

program
  .name('dev-team')
  .description('Claude Code configuration framework for development teams')
  .version(packageJson.version);

program
  .command('install')
  .description('Install dev-team configuration to your project')
  .option('-p, --path <path>', 'Target installation path', process.cwd())
  .option('-f, --force', 'Overwrite existing files', false)
  .option('--no-interactive', 'Skip interactive prompts')
  .action(install);

program
  .command('update')
  .description('Update existing dev-team configuration')
  .option('-p, --path <path>', 'Target path', process.cwd())
  .action((options) => {
    console.log('Update command - coming soon');
  });

program
  .command('list')
  .description('List available agents and skills')
  .action(() => {
    console.log('\n📦 Available Components:\n');
    console.log('Agents:');
    console.log('  - (templates available in .claude/agents/)');
    console.log('\nSkills:');
    console.log('  - (templates available in .claude/skills/)');
    console.log('\nCommands:');
    console.log('  - (templates available in .claude/commands/)');
  });

program.parse();

// Show help if no command provided
if (!process.argv.slice(2).length) {
  program.outputHelp();
}
