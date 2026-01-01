# NPM Publishing Guide

## 1. Pre-Publishing Checklist

### Package.json Required Fields

```json
{
  "name": "@scope/package-name",  // Unique on npm
  "version": "1.0.0",             // Semantic version
  "description": "Clear description",
  "main": "src/index.js",
  "bin": { "cmd": "./bin/cli.js" },
  "files": ["bin/", "src/", "templates/"],
  "keywords": ["relevant", "keywords"],
  "author": "Name <email>",
  "license": "MIT",
  "repository": { "type": "git", "url": "..." },
  "engines": { "node": ">=18.0.0" }
}
```

### Verify Package Contents

```bash
# See what will be published
npm pack --dry-run

# Create tarball and inspect
npm pack
tar -tzf package-name-1.0.0.tgz
```

## 2. Authentication

### Login to npm

```bash
npm login
# Enter username, password, email

# Verify logged in
npm whoami
```

### Scoped Packages (Organizations)

```bash
# Check org membership
npm org ls <org-name>

# Login with scope
npm login --scope=@org-name
```

### NPM Token (for CI/CD)

```bash
# Create token at npmjs.com/settings/tokens
# Add to ~/.npmrc
//registry.npmjs.org/:_authToken=npm_xxxxx
```

## 3. Publishing Commands

### Standard Package

```bash
npm publish
```

### Scoped Package (Public)

```bash
# Scoped packages are private by default
npm publish --access public
```

### With Distribution Tag

```bash
# Alpha release
npm publish --tag alpha --access public

# Beta release
npm publish --tag beta --access public

# Latest (default)
npm publish --tag latest --access public
```

### With 2FA/OTP

```bash
npm publish --otp 123456 --access public
```

## 4. Version Management

### Semantic Versioning

```
MAJOR.MINOR.PATCH[-PRERELEASE]

1.0.0        - Initial release
1.0.1        - Patch: bug fixes
1.1.0        - Minor: new features (backward compatible)
2.0.0        - Major: breaking changes
1.0.0-alpha.1 - Prerelease
```

### Bump Version

```bash
# Patch: 1.0.0 -> 1.0.1
npm version patch

# Minor: 1.0.0 -> 1.1.0
npm version minor

# Major: 1.0.0 -> 2.0.0
npm version major

# Prerelease: 1.0.0 -> 1.0.1-alpha.0
npm version prerelease --preid=alpha

# Specific version
npm version 2.0.0-beta.1
```

## 5. Post-Publishing

### Verify Publication

```bash
# View package info
npm view @scope/package-name

# View all versions
npm view @scope/package-name versions

# Test installation
npx @scope/package-name --version
```

### Unpublish (within 72 hours)

```bash
# Specific version
npm unpublish @scope/package-name@1.0.0

# Entire package (use with caution!)
npm unpublish @scope/package-name --force
```

### Deprecate

```bash
npm deprecate @scope/package-name@1.0.0 "Use v2.0.0 instead"
```

## 6. Common Issues & Solutions

### "You must be logged in"

```bash
npm login
npm whoami  # verify
```

### "402 Payment Required" (scoped package)

```bash
# Scoped packages default to private (requires paid account)
# Use --access public for free public packages
npm publish --access public
```

### "OTP required"

```bash
# If you have 2FA enabled
npm publish --otp <6-digit-code>
```

### "Package name already exists"

- Choose a different name
- Or use a scoped name: @yourorg/package-name

### "Cannot publish over existing version"

```bash
# Bump version first
npm version patch
npm publish --access public
```

## 7. Best Practices

### Files to Include

```json
"files": [
  "bin/",      // CLI executables
  "src/",      // Source code
  "dist/",     // Built files (if applicable)
  "templates/" // Template files
]
```

### Files to Exclude (automatic)

- node_modules/
- .git/
- .npmrc
- *.log

### Create .npmignore (optional)

```
# .npmignore
__tests__/
*.test.js
.eslintrc
.prettierrc
docs/
coverage/
```

### README.md Essentials

1. Package name and description
2. Installation command
3. Quick start / Usage example
4. Configuration options
5. API reference (if applicable)
6. License
