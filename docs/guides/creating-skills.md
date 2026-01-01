# Tạo Skill

Hướng dẫn tạo custom skill cho Claude Code.

---

## Skill là gì?

Skill là một "bộ kiến thức" được tổ chức trong folder, có thể chứa:
- **SKILL.md** - File định nghĩa chính
- **Reference files** - Tài liệu bổ sung
- **Examples** - Ví dụ minh họa

Skill khác với Agent ở chỗ nó cung cấp kiến thức, còn Agent định nghĩa hành vi.

---

## Cấu trúc folder

```
.claude/skills/
└── my-skill/
    ├── SKILL.md        # Bắt buộc
    ├── reference.md    # Tùy chọn
    └── examples/       # Tùy chọn
        └── example.md
```

---

## File SKILL.md

```yaml
---
name: my-skill
description: "Use when [trigger condition]"
allowed-tools: Read, Write
---

# My Skill

## Purpose
Mô tả mục đích của skill.

## Guidelines
- Guideline 1
- Guideline 2

## References
See [reference.md](./reference.md) for details.
```

---

## YAML Frontmatter

| Field | Bắt buộc | Mô tả |
|-------|----------|-------|
| `name` | Yes | Tên skill (kebab-case) |
| `description` | Yes | Khi nào dùng skill |
| `allowed-tools` | No | Tools được phép |

---

## Ví dụ: API Designer

```
.claude/skills/
└── api-designer/
    ├── SKILL.md
    ├── conventions.md
    └── examples/
        ├── rest-example.md
        └── graphql-example.md
```

**SKILL.md:**

```yaml
---
name: api-designer
description: "Design RESTful APIs following best practices"
allowed-tools: Read, Write
---

# API Designer

## Purpose
Design consistent, well-documented APIs.

## Conventions
- Use plural nouns for resources
- Use HTTP methods correctly
- Include proper error responses
- Version APIs

## References
- [API Conventions](./conventions.md)
- [REST Example](./examples/rest-example.md)
```

---

## Ví dụ: PDF Generator

```
.claude/skills/
└── pdf-generator/
    ├── SKILL.md
    └── templates.md
```

**SKILL.md:**

```yaml
---
name: pdf-generator
description: "Generate PDF documents from data"
allowed-tools: Read, Write, Bash
---

# PDF Generator

## Capabilities
- Generate reports
- Create invoices
- Export documentation

## Usage
1. Prepare data in JSON format
2. Select template from [templates.md](./templates.md)
3. Generate PDF

## Dependencies
Requires `wkhtmltopdf` or similar.
```

---

## Ví dụ: Database Design

```
.claude/skills/
└── db-design/
    ├── SKILL.md
    ├── normalization.md
    ├── indexing.md
    └── migrations.md
```

**SKILL.md:**

```yaml
---
name: db-design
description: "Design database schemas and migrations"
allowed-tools: Read, Write
---

# Database Design

## Purpose
Design efficient, normalized database schemas.

## Topics
- [Normalization](./normalization.md)
- [Indexing Strategies](./indexing.md)
- [Migrations](./migrations.md)

## Guidelines
- Follow 3NF for most cases
- Add indexes for frequent queries
- Plan for data growth
```

---

## Reference Files

Dùng reference files để:
- Chi tiết hóa từng topic
- Giữ SKILL.md dưới 500 dòng
- Tổ chức kiến thức logic

### Naming conventions

- `conventions.md` - Quy ước
- `examples/` - Thư mục ví dụ
- `templates/` - Thư mục templates
- `reference.md` - Tài liệu tham khảo

---

## Best Practices

### Nên

- SKILL.md dưới 500 dòng
- Dùng reference files cho chi tiết
- Include examples
- Clear trigger keywords trong description

### Không nên

- Nhồi tất cả vào SKILL.md
- Thiếu documentation
- Description quá chung
- Quá nhiều nested folders

---

## Sử dụng skill

### Cách 1: Trigger tự động

Claude tự động load skill khi nhận ra keywords trong description.

### Cách 2: Yêu cầu trực tiếp

```
Use the api-designer skill to design this endpoint.
```

### Cách 3: Trong agent

Agent có thể reference skill trong prompt:

```yaml
---
name: backend-dev
skills: api-designer, db-design
---
```

---

## Troubleshooting

### Skill không load?

1. Kiểm tra có file `SKILL.md` trong folder
2. YAML frontmatter đúng format
3. Name trong frontmatter khớp với folder name
4. Restart Claude Code session

### Reference files không được đọc?

1. Kiểm tra đường dẫn tương đối
2. Dùng markdown links: `[text](./file.md)`

---

## Tiếp theo

- [Skill Specification](../reference/skill-spec.md) - Đặc tả chi tiết
- [Tạo Agent](./creating-agents.md) - Kết hợp skill với agent
