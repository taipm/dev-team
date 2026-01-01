# Troubleshooting

Xử lý các vấn đề thường gặp.

## Installation Issues

### Command not found

**Triệu chứng**:
```
dev-team: command not found
```

**Giải pháp**:
```bash
# Dùng npx
npx @microai.club/dev-team@alpha install

# Hoặc install global
npm install -g @microai.club/dev-team@alpha
```

### Permission denied

**Triệu chứng**:
```
Error: EACCES: permission denied
```

**Giải pháp**:
```bash
# Fix hook permissions
chmod +x .microai/hooks/**/*.sh

# Hoặc với sudo (not recommended)
sudo npm install -g @microai.club/dev-team@alpha
```

## Command Issues

### Slash command không hoạt động

**Triệu chứng**:
```
Unknown command: /microai:deep-question
```

**Giải pháp**:
1. Kiểm tra file tồn tại:
   ```bash
   ls .claude/commands/microai/deep-question.md
   ```

2. Kiểm tra YAML frontmatter:
   ```yaml
   ---
   name: 'deep-question'
   description: '...'
   ---
   ```

3. Restart Claude Code

### Agent không kích hoạt

**Triệu chứng**:
Agent không respond như expected.

**Giải pháp**:
1. Kiểm tra agent file path trong command
2. Verify agent.md có đúng format
3. Check permissions trong settings.json

## Team Issues

### Team phases không chuyển

**Triệu chứng**:
Stuck ở một phase.

**Giải pháp**:
```
*next    # Force next phase
*status  # Check current state
```

### Observer commands không hoạt động

**Triệu chứng**:
`*status` không được recognize.

**Giải pháp**:
- Đảm bảo đang trong team session
- Dùng đúng syntax: `*command` (có asterisk)

## Configuration Issues

### Settings không được apply

**Triệu chứng**:
Permissions không đúng.

**Giải pháp**:
1. Check JSON syntax:
   ```bash
   cat .claude/settings.json | jq .
   ```

2. Verify merge với settings.local.json

3. Restart Claude Code

### Tools bị denied

**Triệu chứng**:
```
Permission denied for Bash(...)
```

**Giải pháp**:
1. Thêm vào settings.json:
   ```json
   {
     "permissions": {
       "allow": ["Bash(git:*)"]
     }
   }
   ```

2. Hoặc settings.local.json cho personal

## Performance Issues

### Response chậm

**Triệu chứng**:
Agent/Team respond chậm.

**Giải pháp**:
- Reduce context size
- Use simpler agent (sonnet vs opus)
- Break task into smaller parts

### Memory/Context issues

**Triệu chứng**:
Agent "quên" context trước đó.

**Giải pháp**:
- Summarize periodically
- Use memory system
- Start fresh session

## Getting Help

### Check logs

```bash
cat .microai/logs/latest.log
```

### Verify installation

```bash
dev-team doctor
```

### Report issues

```
https://github.com/microai/dev-team/issues
```

## Common Error Messages

| Error | Meaning | Fix |
|-------|---------|-----|
| `ENOENT` | File not found | Check path |
| `EACCES` | Permission denied | Fix permissions |
| `EPERM` | Operation not permitted | Check settings |
| `SyntaxError` | Invalid JSON/YAML | Fix syntax |

## Xem Thêm

- [Installation](../getting-started/installation.md)
- [Configuration](../getting-started/configuration.md)
