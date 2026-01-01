# Tài Liệu Tham Khảo @microai.club/dev-team

Chào mừng bạn đến với **Tài Liệu Tham Khảo** của dev-team framework!

## Giới Thiệu

Cuốn sách này cung cấp tài liệu kỹ thuật đầy đủ cho dev-team framework, bao gồm:

- **CLI Reference**: Các lệnh CLI và options
- **Specifications**: Format và schema cho agents, teams, skills, commands
- **APIs**: Hooks, Knowledge, Memory systems
- **Configuration**: settings.json, CLAUDE.md
- **Built-in Components**: Agents và Teams có sẵn

## Cách Sử Dụng

Cuốn sách này được thiết kế để **tra cứu**, không phải đọc từ đầu đến cuối.

### Tra Cứu Nhanh

| Bạn muốn biết về... | Xem phần... |
|---------------------|-------------|
| CLI commands | [Phần 1: CLI Reference](./chapters/cli/overview.md) |
| Agent format | [Phần 2: Agent Specification](./chapters/agent-spec/format.md) |
| Tools available | [Tools Reference](./chapters/agent-spec/tools.md) |
| Team structure | [Phần 4: Team Specification](./chapters/team-spec/format.md) |
| Hooks setup | [Phần 6: Hooks API](./chapters/hooks-api/configuration.md) |
| settings.json | [Phần 9: Configuration](./chapters/config/settings-json.md) |
| Adapter specification | [Phần 10: Adapter Spec](./chapters/adapter-spec/architecture.md) |
| Built-in agents | [Phần 11: Agents](./chapters/built-in/father-agent.md) |
| Built-in teams | [Phần 12: Teams](./chapters/built-in-teams/deep-thinking.md) |

## Quy Ước

### Code Blocks

```yaml
# YAML configuration example
name: example
```

```bash
# Shell command example
dev-team install
```

### Tables

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Unique identifier |

### Markers

- **Required**: Bắt buộc phải có
- **Optional**: Có thể bỏ qua
- **Default**: Giá trị mặc định nếu không chỉ định
- **Deprecated**: Không nên sử dụng, sẽ bị loại bỏ

## Liên Kết

- **User Guide**: [Hướng dẫn sử dụng](../../user-guide/vi/src/README.md)
- **Developer Guide**: [Hướng dẫn phát triển](../../developer-guide/vi/src/README.md)
- **GitHub**: [github.com/taipm/dev-team](https://github.com/taipm/dev-team)

## Phiên Bản

Tài liệu này cho phiên bản: **v1.0.0-alpha.2**

Xem [Changelog](./chapters/appendix/changelog.md) để biết lịch sử thay đổi.

---

Bắt đầu tra cứu với [CLI Reference](./chapters/cli/overview.md).
