# NPM Troubleshooting Guide

## Authentication Issues

### Problem: "ENEEDAUTH - You need to be logged in"

```bash
# Solution: Login to npm
npm login

# Verify
npm whoami
```

### Problem: "E401 - Incorrect or missing authentication"

```bash
# Check current auth
cat ~/.npmrc

# Re-login
npm logout
npm login
```

### Problem: "E402 - Payment Required"

Scoped packages (`@org/package`) are private by default.

```bash
# Solution: Publish as public
npm publish --access public
```

### Problem: "EOTP - OTP required"

2FA is enabled on your account.

```bash
# Solution: Provide OTP
npm publish --otp 123456 --access public
```

## Publishing Issues

### Problem: "E403 - Forbidden - Package name already exists"

**Solutions:**

1. Choose a different name
2. Use a scoped name: `@yourscope/package-name`
3. Check if you have permission (if it's your package)

### Problem: "Cannot publish over existing version"

```bash
# Solution: Bump version first
npm version patch  # or minor, major
npm publish --access public
```

### Problem: "Package too large"

```bash
# Check what's being published
npm pack --dry-run

# Solution: Use "files" field in package.json
{
  "files": [
    "bin/",
    "src/",
    "templates/"
  ]
}
```

### Problem: "Invalid package name"

Rules for npm package names:
- Lowercase only
- No spaces (use hyphens)
- No special characters except `-` and `_`
- Max 214 characters

```json
// Good
"name": "my-package"
"name": "@org/my-package"

// Bad
"name": "My Package"
"name": "my@package"
```

## CLI Issues

### Problem: "command not found" after install

```bash
# Check if bin is correct in package.json
{
  "bin": {
    "my-cli": "./bin/cli.js"
  }
}

# Make sure cli.js has shebang
#!/usr/bin/env node

# Make executable
chmod +x bin/cli.js
```

### Problem: "Cannot find module" in CLI

```bash
# Check import paths are correct
# Use proper ES module syntax
import { something } from '../src/module.js';  # Include .js extension!

# Or use __dirname correctly for ES modules
import { fileURLToPath } from 'url';
import { dirname } from 'path';
const __dirname = dirname(fileURLToPath(import.meta.url));
```

### Problem: CLI works locally but not after npm install

```bash
# Check "files" includes all needed directories
{
  "files": [
    "bin/",
    "src/",
    "templates/"
  ]
}

# Test with npm pack
npm pack
# Then install the tarball locally
npm install ./package-1.0.0.tgz -g
```

## Dependency Issues

### Problem: "peer dependency not met"

```bash
# Install peer dependencies
npm install peer-package

# Or ignore (not recommended)
npm install --legacy-peer-deps
```

### Problem: "vulnerabilities found"

```bash
# View vulnerabilities
npm audit

# Auto-fix
npm audit fix

# Force fix (may have breaking changes)
npm audit fix --force
```

### Problem: "ERESOLVE - dependency conflict"

```bash
# Try with legacy resolution
npm install --legacy-peer-deps

# Or force
npm install --force

# Better: Fix the version conflicts in package.json
```

## Version Issues

### Problem: "Git working directory not clean"

npm version creates a git commit. Working directory must be clean.

```bash
# Solution: Commit or stash changes first
git add .
git commit -m "Pre-version changes"
npm version patch
```

### Problem: Published wrong version

Within 72 hours:
```bash
npm unpublish @scope/package@1.0.0
```

After 72 hours:
```bash
# Can only deprecate
npm deprecate @scope/package@1.0.0 "Use version X instead"
```

## Network Issues

### Problem: "ETIMEDOUT" or "ECONNRESET"

```bash
# Check npm registry
npm config get registry

# Reset to default
npm config set registry https://registry.npmjs.org/

# Try with different network
# Check proxy settings
npm config get proxy
npm config get https-proxy
```

### Problem: "certificate has expired"

```bash
# Update npm
npm install -g npm@latest

# Or disable strict SSL (not recommended for production)
npm config set strict-ssl false
```

## Quick Diagnostic Commands

```bash
# Check npm configuration
npm config list

# Check logged in user
npm whoami

# Check package info
npm view @scope/package-name

# See what will be published
npm pack --dry-run

# Check for outdated dependencies
npm outdated

# Check for vulnerabilities
npm audit
```
