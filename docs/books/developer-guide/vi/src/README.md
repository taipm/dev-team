# Hướng Dẫn Phát Triển @microai.club/dev-team

Chào mừng bạn đến với **Hướng Dẫn Phát Triển** của dev-team framework!

## Giới Thiệu

Cuốn sách này dành cho những developer muốn **tạo mới** và **mở rộng** các thành phần của dev-team framework:

- Tạo **Agents** tùy chỉnh cho domain cụ thể
- Xây dựng **Teams** với nhiều agents phối hợp
- Phát triển **Skills** tái sử dụng
- Thiết lập **Commands** để kích hoạt nhanh
- Cấu hình **Hooks** cho automation

## Yêu Cầu Kiến Thức

Trước khi đọc cuốn sách này, bạn nên:

1. Đã quen với việc sử dụng dev-team (xem [User Guide](../../user-guide/vi/src/README.md))
2. Hiểu cơ bản về YAML và Markdown
3. Có kinh nghiệm với Claude Code

## Cấu Trúc Cuốn Sách

| Phần | Nội dung | Dành cho |
|------|----------|----------|
| Phần 1-2 | Kiến trúc & Tạo Agent | Tất cả developers |
| Phần 3 | Tạo Team | Multi-agent systems |
| Phần 4-5 | Skills & Commands | Automation |
| Phần 6 | Hooks System | Customization |
| Phần 7-8 | Knowledge & Memory | Advanced |
| Phần 9-10 | Best Practices & Case Studies | Production |

## Bắt Đầu Từ Đâu?

### Muốn tạo Agent đầu tiên?

Đọc [Phần 2: Tạo Agent](./chapters/creating-agents/basic-agent.md)

### Muốn hiểu kiến trúc?

Đọc [Phần 1: Kiến Trúc Tổng Quan](./chapters/architecture/overview.md)

### Muốn tạo Team?

Đọc [Phần 3: Tạo Team](./chapters/creating-teams/basic-team.md)

## Quy Ước Trong Cuốn Sách

### Code Examples

```yaml
# ✅ Good - Đây là cách nên làm
name: my-agent
description: Agent mô tả rõ ràng

# ❌ Bad - Tránh làm như này
name: a
description: ...
```

### Callouts

> **Lưu ý**: Thông tin quan trọng cần ghi nhớ

> **Cảnh báo**: Điều cần tránh hoặc chú ý đặc biệt

> **Mẹo**: Gợi ý hữu ích để làm việc hiệu quả hơn

## Tài Nguyên Bổ Sung

- **Templates**: Xem [Phụ lục: Templates](./chapters/appendix/templates.md)
- **Reference Manual**: Tra cứu chi tiết tại [Reference Manual](../../reference/vi/src/README.md)
- **GitHub**: [github.com/taipm/dev-team](https://github.com/taipm/dev-team)

---

Hãy bắt đầu với [Kiến Trúc MicroAI](./chapters/architecture/overview.md)!
