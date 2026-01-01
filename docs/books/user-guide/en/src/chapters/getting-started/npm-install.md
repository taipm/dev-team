# Installing via npm

Detailed guide for installing dev-team via npm.

## Quick Install

```bash
cd your-project
npx @microai.club/dev-team@alpha install
```

## Installation Options

### Interactive Mode (Default)

```bash
npx @microai.club/dev-team@alpha install
```

The wizard will ask about:
- Components to install
- How to handle existing directories

### Non-interactive Mode

```bash
npx @microai.club/dev-team@alpha install --no-interactive
```

Installs all default components.

### Force Overwrite

```bash
npx @microai.club/dev-team@alpha install --force
```

Overwrites all existing files.

### Custom Path

```bash
npx @microai.club/dev-team@alpha install --path /path/to/project
```

## Global Installation

To use as a CLI tool:

```bash
npm install -g @microai.club/dev-team@alpha
dev-team install
```

## See Also

- [Verifying Installation](./verification.md)
- [Initial Configuration](./configuration.md)
