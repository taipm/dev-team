# Hướng dẫn tạo NPM Package cho Claude Code Configuration

Tài liệu này hướng dẫn chi tiết cách tạo một npm package để phân phối cấu hình Claude Code, cho phép người dùng cài đặt dễ dàng qua lệnh `npx`.

---

## Mục lục

1. [Tổng quan](#1-tổng-quan)
2. [Cấu trúc dự án](#2-cấu-trúc-dự-án)
3. [Tạo package.json](#3-tạo-packagejson)
4. [Tạo CLI Script](#4-tạo-cli-script)
5. [Tạo Install Command](#5-tạo-install-command)
6. [Tạo Templates](#6-tạo-templates)
7. [Test Package](#7-test-package)
8. [Publish lên NPM](#8-publish-lên-npm)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. Tổng quan

### Mục tiêu
Tạo một npm package cho phép người dùng cài đặt cấu hình Claude Code vào project của họ bằng lệnh:

```bash
npx @your-org/package-name@alpha install
```

### Cách hoạt động
1. Người dùng chạy `npx @your-org/package-name install`
2. NPX tải package từ npm registry
3. Chạy CLI script được định nghĩa trong `bin`
4. CLI copy các file template vào thư mục `.claude/` của project

---

## 2. Cấu trúc dự án

```
your-package/
├── bin/
│   └── cli.js              # Entry point (executable)
├── src/
│   ├── commands/
│   │   └── install.js      # Install command logic
│   └── index.js            # Module exports
├── templates/
│   └── .claude/            # Template files to copy
│       ├── CLAUDE.md
│       ├── settings.json
│       ├── agents/
│       │   └── README.md
│       ├── skills/
│       │   └── README.md
│       └── commands/
│           └── README.md
├── package.json
├── README.md
└── .gitignore
```

---

## 3. Tạo package.json

### 3.1. Khởi tạo project

```bash
mkdir my-claude-config
cd my-claude-config
npm init -y
```

### 3.2. Cấu hình package.json

```json
{
  "name": "@your-org/package-name",
  "version": "1.0.0-alpha.1",
  "description": "Claude Code configuration framework",
  "main": "src/index.js",
  "type": "module",
  "bin": {
    "package-name": "./bin/cli.js"
  },
  "files": [
    "bin/",
    "src/",
    "templates/"
  ],
  "scripts": {
    "test": "node bin/cli.js --version",
    "prepublishOnly": "npm test"
  },
  "keywords": [
    "claude-code",
    "cli",
    "agents"
  ],
  "author": "Your Name",
  "license": "MIT",
  "engines": {
    "node": ">=18.0.0"
  },
  "dependencies": {
    "chalk": "^5.3.0",
    "commander": "^12.1.0",
    "fs-extra": "^11.2.0",
    "inquirer": "^9.3.7",
    "ora": "^8.1.1"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/your-org/package-name.git"
  }
}
```

### 3.3. Giải thích các field quan trọng

| Field | Mô tả |
|-------|-------|
| `name` | Tên package, dùng scoped name `@org/name` để tránh trùng |
| `type: "module"` | Cho phép dùng ES6 import/export |
| `bin` | Map command name → executable script |
| `files` | Chỉ định files được publish lên npm |
| `engines` | Yêu cầu Node.js version tối thiểu |

### 3.4. Cài đặt dependencies

```bash
npm install chalk commander fs-extra inquirer ora
```

---

## 4. Tạo CLI Script

### 4.1. Tạo file bin/cli.js

```bash
mkdir -p bin
touch bin/cli.js
chmod +x bin/cli.js
```

### 4.2. Nội dung bin/cli.js

```javascript
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
  .name('package-name')
  .description('Claude Code configuration framework')
  .version(packageJson.version);

program
  .command('install')
  .description('Install configuration to your project')
  .option('-p, --path <path>', 'Target installation path', process.cwd())
  .option('-f, --force', 'Overwrite existing files', false)
  .option('--no-interactive', 'Skip interactive prompts')
  .action(install);

program
  .command('update')
  .description('Update existing configuration')
  .option('-p, --path <path>', 'Target path', process.cwd())
  .action((options) => {
    console.log('Update command - coming soon');
  });

program
  .command('list')
  .description('List available agents and skills')
  .action(() => {
    console.log('\n📦 Available Components:\n');
    console.log('Agents: (in .claude/agents/)');
    console.log('Skills: (in .claude/skills/)');
    console.log('Commands: (in .claude/commands/)');
  });

program.parse();

// Show help if no command
if (!process.argv.slice(2).length) {
  program.outputHelp();
}
```

### 4.3. Lưu ý quan trọng

- **Shebang bắt buộc:** `#!/usr/bin/env node` phải ở dòng đầu tiên
- **Execute permission:** `chmod +x bin/cli.js`

---

## 5. Tạo Install Command

### 5.1. Tạo file src/commands/install.js

```bash
mkdir -p src/commands
touch src/commands/install.js
```

### 5.2. Nội dung install.js

```javascript
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
 * Check existing installation
 */
function checkExistingInstallation(targetPath) {
  const claudeDir = join(targetPath, '.claude');
  return existsSync(claudeDir);
}

/**
 * Main install function
 */
export async function install(options) {
  const targetPath = options.path;
  const spinner = ora();

  console.log(chalk.blue('\n🚀 Package Installer\n'));
  console.log(chalk.gray(`Target: ${targetPath}\n`));

  // Check for existing installation
  if (checkExistingInstallation(targetPath) && !options.force) {
    if (options.interactive !== false) {
      const { action } = await inquirer.prompt([
        {
          type: 'list',
          name: 'action',
          message: 'Existing .claude directory found. What would you like to do?',
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
      console.log(chalk.yellow('⚠️  Existing .claude found. Use --force to overwrite.\n'));
      return;
    }
  }

  // Select components
  let components = ['claude-md', 'settings', 'agents', 'skills', 'commands'];

  if (options.interactive !== false) {
    const { selectedComponents } = await inquirer.prompt([
      {
        type: 'checkbox',
        name: 'selectedComponents',
        message: 'Select components to install:',
        choices: [
          { name: 'CLAUDE.md (project context)', value: 'claude-md', checked: true },
          { name: 'settings.json (team config)', value: 'settings', checked: true },
          { name: 'agents/ (agent templates)', value: 'agents', checked: true },
          { name: 'skills/ (skill templates)', value: 'skills', checked: true },
          { name: 'commands/ (command templates)', value: 'commands', checked: true }
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
  spinner.start('Installing configuration...');

  try {
    const claudeDir = join(targetPath, '.claude');
    mkdirSync(claudeDir, { recursive: true });

    // Install components
    const componentMap = {
      'claude-md': { src: 'CLAUDE.md', isDir: false },
      'settings': { src: 'settings.json', isDir: false },
      'agents': { src: 'agents', isDir: true },
      'skills': { src: 'skills', isDir: true },
      'commands': { src: 'commands', isDir: true }
    };

    for (const comp of components) {
      const { src, isDir } = componentMap[comp];
      const srcPath = join(TEMPLATES_DIR, '.claude', src);
      const destPath = join(claudeDir, src);

      if (existsSync(srcPath)) {
        if (isDir) {
          if (options.force || !existsSync(destPath)) {
            copyDirSync(srcPath, destPath);
          } else {
            // Merge - copy missing files
            mkdirSync(destPath, { recursive: true });
            const files = readdirSync(srcPath);
            for (const file of files) {
              const srcFile = join(srcPath, file);
              const destFile = join(destPath, file);
              if (!existsSync(destFile)) {
                if (statSync(srcFile).isDirectory()) {
                  copyDirSync(srcFile, destFile);
                } else {
                  copyFileSync(srcFile, destFile);
                }
              }
            }
          }
        } else {
          if (options.force || !existsSync(destPath)) {
            copyFileSync(srcPath, destPath);
          }
        }
      }
    }

    // Update .gitignore
    const gitignorePath = join(targetPath, '.gitignore');
    const gitignoreEntry = '\n# Claude Code local settings\n.claude/settings.local.json\n';

    if (existsSync(gitignorePath)) {
      const content = fsExtra.readFileSync(gitignorePath, 'utf-8');
      if (!content.includes('settings.local.json')) {
        fsExtra.appendFileSync(gitignorePath, gitignoreEntry);
      }
    } else {
      fsExtra.writeFileSync(gitignorePath, gitignoreEntry.trim() + '\n');
    }

    spinner.succeed(chalk.green('Installation complete!'));

    // Show summary
    console.log(chalk.blue('\n📁 Installed structure:\n'));
    console.log(chalk.gray('.claude/'));
    if (components.includes('claude-md')) console.log(chalk.gray('├── CLAUDE.md'));
    if (components.includes('settings')) console.log(chalk.gray('├── settings.json'));
    if (components.includes('agents')) console.log(chalk.gray('├── agents/'));
    if (components.includes('skills')) console.log(chalk.gray('├── skills/'));
    if (components.includes('commands')) console.log(chalk.gray('└── commands/'));

    console.log(chalk.blue('\n📝 Next steps:\n'));
    console.log('1. Edit .claude/CLAUDE.md with your project context');
    console.log('2. Customize .claude/settings.json for your team');
    console.log('3. Add agents to .claude/agents/');
    console.log(chalk.gray('\nSee README files in each directory for templates.\n'));

  } catch (error) {
    spinner.fail(chalk.red('Installation failed'));
    console.error(chalk.red(`\nError: ${error.message}\n`));
    process.exit(1);
  }
}
```

### 5.3. Tạo src/index.js

```javascript
// Entry point for programmatic usage
export { install } from './commands/install.js';
export const version = '1.0.0-alpha.1';
```

---

## 6. Tạo Templates

### 6.1. Tạo cấu trúc thư mục

```bash
mkdir -p templates/.claude/agents
mkdir -p templates/.claude/skills
mkdir -p templates/.claude/commands
```

### 6.2. Tạo templates/.claude/CLAUDE.md

```markdown
# Project Name

## Overview
Brief description of your project.

## Project Structure
Describe your project structure here.

## Development Guidelines
- Code style conventions
- Architecture notes
- Team standards

## Quick Start
How to work with Claude Code in this project.
```

### 6.3. Tạo templates/.claude/settings.json

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(git:*)"
    ],
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(secrets/**)"
    ]
  }
}
```

### 6.4. Tạo templates/.claude/agents/README.md

```markdown
# Agents Directory

Create custom agents by adding `.md` files here.

## Agent Template

\`\`\`yaml
---
name: agent-name
description: "When to use this agent"
tools: Read, Grep, Edit
model: sonnet
---

Your agent's system prompt here.
\`\`\`

## Best Practices
1. One agent = one responsibility
2. Include trigger keywords in description
3. Only allow necessary tools
```

### 6.5. Tạo templates/.claude/skills/README.md

```markdown
# Skills Directory

Create skills by adding folders with `SKILL.md` files.

## Skill Template

\`\`\`yaml
---
name: skill-name
description: "What this skill does"
allowed-tools: Read, Grep
---

Skill instructions here.
\`\`\`

## Structure
\`\`\`
skills/
└── my-skill/
    ├── SKILL.md
    └── reference.md
\`\`\`
```

### 6.6. Tạo templates/.claude/commands/README.md

```markdown
# Commands Directory

Create custom slash commands by adding `.md` files.

## Command Template

\`\`\`yaml
---
description: "Short description"
---

Command prompt content.
Use $ARGUMENTS for user input.
\`\`\`

## Example

/review command:
\`\`\`yaml
---
description: "Review code changes"
---

Review the current git diff for issues.
Focus on: $ARGUMENTS
\`\`\`
```

---

## 7. Test Package

### 7.1. Test CLI locally

```bash
# Test version
node bin/cli.js --version

# Test help
node bin/cli.js --help

# Test install (dry run)
mkdir /tmp/test-project
node bin/cli.js install --path /tmp/test-project --no-interactive
ls -la /tmp/test-project/.claude/
```

### 7.2. Test với npm pack

```bash
# Tạo tarball
npm pack

# Install từ tarball
npm install -g ./package-name-1.0.0-alpha.1.tgz

# Test
package-name --version
package-name install --help

# Cleanup
npm uninstall -g package-name
```

---

## 8. Publish lên NPM

### 8.1. Tạo tài khoản NPM

1. Đăng ký tại https://www.npmjs.com/signup
2. Verify email

### 8.2. Đăng nhập NPM CLI

```bash
npm login
```

### 8.3. Tạo Organization (optional)

Nếu dùng scoped package `@org/name`:
1. Vào https://www.npmjs.com/org/create
2. Tạo organization

### 8.4. Tạo Access Token với Bypass 2FA

1. Vào https://www.npmjs.com/settings/YOUR_USERNAME/tokens
2. Click **"Generate New Token"** → **"Granular Access Token"**
3. Đặt tên token
4. **Tick chọn "Bypass two-factor authentication (2FA)"**
5. Chọn packages scope
6. Click **Generate**
7. **Copy token ngay lập tức** (chỉ hiển thị 1 lần)

### 8.5. Cấu hình token

```bash
# Cập nhật ~/.npmrc
echo "//registry.npmjs.org/:_authToken=npm_YOUR_TOKEN" > ~/.npmrc
```

### 8.6. Publish

```bash
# Publish với tag alpha (cho pre-release)
npm publish --tag alpha --access public

# Publish phiên bản stable
npm publish --access public
```

### 8.7. Verify

```bash
# Xem package info
npm view @your-org/package-name

# Test install
npx @your-org/package-name@alpha install
```

---

## 9. Troubleshooting

### Lỗi E403 - Two-factor authentication required

**Nguyên nhân:** Token không có quyền bypass 2FA

**Giải pháp:**
1. Tạo token mới với "Bypass 2FA" được bật từ đầu
2. Hoặc dùng OTP: `npm publish --otp=123456`

### Lỗi E403 - Package name forbidden

**Nguyên nhân:** Tên package quá chung hoặc đã bị chiếm

**Giải pháp:** Dùng scoped package `@your-org/package-name`

### Lỗi EOTP

**Nguyên nhân:** Token trong ~/.npmrc không có bypass 2FA

**Giải pháp:**
```bash
# Cập nhật token mới
echo "//registry.npmjs.org/:_authToken=npm_NEW_TOKEN" > ~/.npmrc
```

### CLI không chạy được

**Nguyên nhân:** Thiếu shebang hoặc execute permission

**Giải pháp:**
```bash
# Kiểm tra dòng đầu có #!/usr/bin/env node
head -1 bin/cli.js

# Set execute permission
chmod +x bin/cli.js
```

### Templates không được copy

**Nguyên nhân:** Thiếu trong `files` array

**Giải pháp:** Đảm bảo package.json có:
```json
{
  "files": ["bin/", "src/", "templates/"]
}
```

---

## Tham khảo

- [NPM Documentation](https://docs.npmjs.com/)
- [Commander.js](https://github.com/tj/commander.js)
- [Inquirer.js](https://github.com/SBoudrias/Inquirer.js)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
