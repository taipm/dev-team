# System Requirements

Prerequisites for installing dev-team.

## Required Software

| Software | Version | Notes |
|----------|---------|-------|
| Node.js | >= 18.0.0 | [Download](https://nodejs.org/) |
| npm | >= 8.0.0 | Comes with Node.js |
| Claude Code | Latest | [Installation guide](https://claude.ai/code) |

## Check Current Versions

```bash
# Check Node.js
node --version  # Should be v18.x.x or higher

# Check npm
npm --version   # Should be 8.x.x or higher
```

## Installing Node.js

### macOS

```bash
# Using Homebrew
brew install node@18

# Or download from nodejs.org
```

### Linux

```bash
# Using nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18
```

### Windows

Download installer from [nodejs.org](https://nodejs.org/)

## Installing Claude Code

Claude Code is required to run dev-team agents and teams.

1. Get subscription at [claude.ai/code](https://claude.ai/code)
2. Install Claude Code CLI
3. Login with your account

## See Also

- [Installing via npm](./npm-install.md)
- [Verifying Installation](./verification.md)
