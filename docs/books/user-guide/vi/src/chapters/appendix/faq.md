# FAQ

Các câu hỏi thường gặp.

## General

### dev-team là gì?

dev-team là framework cung cấp AI agents và teams để hỗ trợ phát triển phần mềm. Bao gồm specialized agents, thinking teams, và session-based dialogues.

### dev-team có miễn phí không?

dev-team framework miễn phí. Tuy nhiên, bạn cần có Claude Code subscription để sử dụng.

### dev-team hỗ trợ ngôn ngữ nào?

Agents có thể làm việc với mọi ngôn ngữ lập trình. Một số agents chuyên biệt cho Go, npm/Node.js.

## Installation

### Làm sao để cập nhật dev-team?

```bash
npx @microai.club/dev-team@alpha install --force
```

### Có thể cài trên nhiều projects không?

Có, mỗi project cần cài đặt riêng.

### dev-team có conflict với Claude Code settings không?

Không, dev-team merge với settings có sẵn (trừ khi chọn overwrite).

## Agents

### Agent nào nên dùng đầu tiên?

`/microai:deep-question` - đơn giản và hữu ích cho mọi domain.

### Làm sao để biết agent nào phù hợp?

Xem [Agent Gallery](../agents/gallery.md) hoặc descriptions trong command list.

### Có thể tạo agent mới không?

Có, dùng `/microai:father` để tạo agent mới.

## Teams

### Team khác Agent thế nào?

- Agent: một expert, một perspective
- Team: nhiều experts, nhiều perspectives, có workflow

### Khi nào nên dùng Team?

Khi vấn đề phức tạp, cần phân tích từ nhiều góc độ.

### Deep Thinking Team có bao nhiêu Titans?

7 Titans: Socrates, Aristotle, Musk, Feynman, Munger, Polya, Da Vinci.

## Commands

### Slash commands ở đâu?

```
.claude/commands/
```

### Làm sao tạo custom command?

Tạo file `.md` trong `.claude/commands/custom/` với YAML frontmatter.

### Command không hoạt động?

1. Kiểm tra file tồn tại
2. Verify YAML syntax
3. Restart Claude Code

## Skills

### Skill khác Command thế nào?

- Command: kích hoạt agent/team
- Skill: workflow với reference files

### Skills nằm ở đâu?

```
.claude/skills/
```

## Troubleshooting

### "Unknown command" error?

- Verify command file exists
- Check YAML frontmatter
- Restart Claude Code

### Agent không respond đúng?

- Provide more context
- Check agent definition
- Try simpler request first

### Performance chậm?

- Use simpler agents (sonnet vs opus)
- Break task into smaller parts
- Reduce context size

## Best Practices

### Tips cho beginners?

1. Bắt đầu với `/microai:deep-question`
2. Provide clear context
3. Engage in dialogue
4. Iterate on output

### Tips cho advanced users?

1. Combine agents và teams
2. Create custom agents
3. Use memory system
4. Document patterns

## Xem Thêm

- [Troubleshooting](../workflows/troubleshooting.md)
- [Best Practices](../workflows/best-practices.md)
