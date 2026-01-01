/**
 * Install Command Template for NPM Package Installer
 *
 * Features:
 * - Interactive prompts with inquirer
 * - Progress indicators with ora
 * - Colored output with chalk
 * - Merge/Overwrite strategies
 * - Component selection
 */

import { existsSync, mkdirSync, copyFileSync, readdirSync, statSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import chalk from 'chalk';
import ora from 'ora';
import inquirer from 'inquirer';
import fsExtra from 'fs-extra';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const TEMPLATES_DIR = join(__dirname, '../../templates');

/**
 * Copy directory recursively (overwrites existing)
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
 * Merge directory - copy only missing files (safe mode)
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
 * Check for existing installation
 */
function checkExisting(targetPath, dirName) {
  return existsSync(join(targetPath, dirName));
}

/**
 * Main install function
 */
export async function install(options) {
  const targetPath = options.path;
  const spinner = ora();

  // Welcome message
  console.log(chalk.blue('\n📦 Package Installer\n'));
  console.log(chalk.gray(`Target: ${targetPath}\n`));

  // Check for existing installation
  const hasExisting = checkExisting(targetPath, '.config'); // Change to your dir

  if (hasExisting && !options.force) {
    if (options.interactive !== false) {
      const { action } = await inquirer.prompt([
        {
          type: 'list',
          name: 'action',
          message: 'Existing installation found. What would you like to do?',
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

  // Component selection (customize for your package)
  let components = ['config', 'templates', 'scripts'];

  if (options.interactive !== false) {
    const { selectedComponents } = await inquirer.prompt([
      {
        type: 'checkbox',
        name: 'selectedComponents',
        message: 'Select components to install:',
        choices: [
          { name: 'Configuration files', value: 'config', checked: true },
          { name: 'Templates', value: 'templates', checked: true },
          { name: 'Scripts', value: 'scripts', checked: true }
        ]
      }
    ]);
    components = selectedComponents;
  }

  if (components.length === 0) {
    console.log(chalk.yellow('\n⚠️  No components selected.\n'));
    return;
  }

  // Start installation
  spinner.start('Installing...');

  try {
    // Install each component
    for (const component of components) {
      spinner.text = `Installing ${component}...`;

      const src = join(TEMPLATES_DIR, component);
      const dest = join(targetPath, component);

      if (existsSync(src)) {
        if (options.force) {
          copyDirSync(src, dest);
        } else {
          mergeDirSync(src, dest);
        }
      }
    }

    spinner.succeed(chalk.green('Installation complete!'));

    // Show summary
    console.log(chalk.blue('\n📁 Installed:\n'));
    for (const component of components) {
      console.log(chalk.gray(`  ✓ ${component}/`));
    }

    // Next steps
    console.log(chalk.blue('\n📝 Next steps:\n'));
    console.log('1. Review installed files');
    console.log('2. Customize configuration');
    console.log('3. Run your setup commands');

  } catch (error) {
    spinner.fail(chalk.red('Installation failed'));
    console.error(chalk.red(`\nError: ${error.message}\n`));
    process.exit(1);
  }
}
