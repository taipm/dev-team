# MicroAI Skills

> Skills từ [Anthropic Skills Repository](https://github.com/anthropics/skills) được tổ chức và Việt hóa cho dự án dev-team.

## Overview / Tổng quan

Skills là các gói modular cung cấp specialized knowledge, workflows và tool integrations để mở rộng khả năng của Claude. Mỗi skill được kích hoạt dựa trên description matching với yêu cầu của người dùng.

## Categories / Danh mục

### 📄 Document Skills
Xử lý các định dạng tài liệu Office và PDF.

| Skill | Description | Mô tả tiếng Việt |
|-------|-------------|------------------|
| [docx](document-skills/docx/) | Word document creation, editing, analysis | Tạo, chỉnh sửa và phân tích tài liệu Word |
| [pdf](document-skills/pdf/) | PDF manipulation, extraction, forms | Xử lý PDF: trích xuất, merge/split, forms |
| [pptx](document-skills/pptx/) | PowerPoint presentation creation | Tạo và chỉnh sửa bài thuyết trình |
| [xlsx](document-skills/xlsx/) | Excel spreadsheet with formulas | Bảng tính Excel với công thức và định dạng |

### 🛠️ Development Skills
Công cụ phát triển phần mềm và tích hợp.

| Skill | Description | Mô tả tiếng Việt |
|-------|-------------|------------------|
| [mcp-builder](development-skills/mcp-builder/) | Build MCP servers for LLM integration | Xây dựng MCP servers cho tích hợp LLM |
| [skill-creator](development-skills/skill-creator/) | Create new Claude skills | Tạo skills mới cho Claude |
| [webapp-testing](development-skills/webapp-testing/) | Test web apps with Playwright | Test ứng dụng web với Playwright |
| [web-artifacts-builder](development-skills/web-artifacts-builder/) | Build complex web artifacts | Tạo web artifacts phức tạp |

### 🎨 Design Skills
Thiết kế và sáng tạo visual.

| Skill | Description | Mô tả tiếng Việt |
|-------|-------------|------------------|
| [algorithmic-art](design-skills/algorithmic-art/) | Generative art with p5.js | Nghệ thuật thuật toán với p5.js |
| [canvas-design](design-skills/canvas-design/) | Visual art for posters, designs | Thiết kế visual art cho posters |
| [frontend-design](design-skills/frontend-design/) | Production-grade UI design | Thiết kế UI production-grade |
| [theme-factory](design-skills/theme-factory/) | Apply themes to artifacts | Áp dụng themes cho artifacts |

### 💬 Communication Skills
Viết và giao tiếp trong doanh nghiệp.

| Skill | Description | Mô tả tiếng Việt |
|-------|-------------|------------------|
| [doc-coauthoring](communication-skills/doc-coauthoring/) | Co-author documentation | Cộng tác viết tài liệu |
| [internal-comms](communication-skills/internal-comms/) | Internal communications | Viết internal communications |
| [slack-gif-creator](communication-skills/slack-gif-creator/) | Animated GIFs for Slack | Tạo GIFs động cho Slack |

## Quick Stats / Thống kê

- **Total Skills**: 15
- **Categories**: 4 (Document, Development, Design, Communication)
- **Source**: [anthropics/skills](https://github.com/anthropics/skills)
- **License**: Apache 2.0 / Source-available (xem LICENSE.txt trong mỗi skill)

## Usage / Cách sử dụng

Skills được Claude tự động kích hoạt dựa trên context và description matching. Ví dụ:
- "Tạo file Excel với công thức" → triggers `xlsx` skill
- "Build an MCP server" → triggers `mcp-builder` skill
- "Design a landing page" → triggers `frontend-design` skill

## Structure / Cấu trúc

```
.microai/skills/
├── README.md                 # This file
├── skills-registry.yaml      # Registry of all skills
├── LICENSE.txt               # License information
│
├── document-skills/          # Office & PDF processing
│   ├── docx/
│   ├── pdf/
│   ├── pptx/
│   └── xlsx/
│
├── development-skills/       # Dev tools & integrations
│   ├── mcp-builder/
│   ├── skill-creator/
│   ├── webapp-testing/
│   └── web-artifacts-builder/
│
├── design-skills/            # Creative & visual
│   ├── algorithmic-art/
│   ├── canvas-design/
│   ├── frontend-design/
│   └── theme-factory/
│
└── communication-skills/     # Enterprise writing
    ├── doc-coauthoring/
    ├── internal-comms/
    └── slack-gif-creator/
```

## Credits

- Original skills from [Anthropic Skills Repository](https://github.com/anthropics/skills)
- Vietnamese translations and organization by dev-team
- See individual skill folders for specific licenses
