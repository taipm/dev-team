# One-Page Team Session Command

Khởi động One-Page Team session - Auto-generate full document stack từ OPPM

## Command

```
/microai:one-page-session [project-description]
```

## Description

One-Page Team là AI Team gồm 6 agents chuyên biệt, tự động tạo đầy đủ document stack (15+ tài liệu) từ một project description.

## Team Members

| Agent | Icon | Role |
|-------|------|------|
| Orchestrator | 📋 | Team Lead, điều phối workflow |
| OPPM | 📄 | Tạo One-Page PM |
| Doc | 📚 | Technical & Planning docs |
| Track | 📊 | Tracking & Metrics |
| SOP | 📝 | Procedures & Checklists |
| Template | 📐 | Prompts & Templates |

## Workflow

```text
Step 1 → Step 2 → Step 3a,3b,3c,3d (parallel) → Step 4 → Step 5 → Step 6
 INIT     OPPM        DOC/TRACK/SOP/TEMPL         REVIEW   EXPORT  SUMMARY
```

## Usage Examples

### Quick Start
```
/microai:one-page-session Dự án AI YouTube tự động hóa
```

### With Details
```
/microai:one-page-session Kế hoạch launch startup SaaS trong 6 tháng,
budget 50k, target 1000 users
```

## Output

```text
output/{project-name}/
├── 01-oppm/           2 files (oppm.md, oppm.pdf)
├── 02-technical/      4 files (setup, pipeline, api, scripts)
├── 03-planning/       6 files (phases, calendar, risks)
├── 04-tracking/       4 files (tracker, dashboard, logs)
└── 05-reference/     10 files (sops, checklists, templates)

Total: ~26 documents auto-generated
```

## Session Commands

| Command | Action |
|---------|--------|
| `*start` | Bắt đầu session mới |
| `*status` | Xem trạng thái hiện tại |
| `*pause` | Pause và save checkpoint |
| `*resume` | Resume từ checkpoint |
| `*export` | Export tất cả sang PDF |

## Requirements

- pandoc với xelatex (cho PDF export)
- Arial Unicode MS font (Vietnamese support)

---

**Invoke workflow at:** `.microai/teams/one-page-team/workflow.md`
