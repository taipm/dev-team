#!/usr/bin/env node

/**
 * CLI Template for NPM Package Installer
 *
 * Usage: Replace placeholders with your package specifics
 * - PACKAGE_NAME: Your CLI command name
 * - PACKAGE_DESCRIPTION: What your package does
 */

import { Command } from 'commander';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { readFileSync } from 'fs';
import { install } from '../src/commands/install.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Load package.json for version info
const packageJson = JSON.parse(
  readFileSync(join(__dirname, '../package.json'), 'utf-8')
);

const program = new Command();

// Main program setup
program
  .name('PACKAGE_NAME')
  .description('PACKAGE_DESCRIPTION')
  .version(packageJson.version);

// Install command - the main functionality
program
  .command('install')
  .description('Install configuration to your project')
  .option('-p, --path <path>', 'Target installation path', process.cwd())
  .option('-f, --force', 'Overwrite existing files', false)
  .option('--no-interactive', 'Skip interactive prompts')
  .action(install);

// Update command (optional)
program
  .command('update')
  .description('Update existing configuration')
  .option('-p, --path <path>', 'Target path', process.cwd())
  .action((options) => {
    console.log('Update command - implement as needed');
  });

// List command (optional)
program
  .command('list')
  .description('List available components')
  .action(() => {
    console.log('\nAvailable Components:\n');
    console.log('  - Component 1');
    console.log('  - Component 2');
  });

// Parse arguments
program.parse();

// Show help if no command provided
if (!process.argv.slice(2).length) {
  program.outputHelp();
}
