---
name: one-page-team
description: AI Team tạo document stack hoàn chỉnh từ One-Page Project Management - auto-generate 15+ tài liệu hỗ trợ
model: opus
tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite, AskUserQuestion]
language: vi
color: "#FF6B35"
icon: "📋"
version: "2.0"

output_folder: ./logs

checkpoint:
  enabled: true
  storage_path: ./checkpoints
  git_integration: false
  auto_checkpoint: true

communication:
  enabled: true
  bus_path: ./communication
  message_timeout_ms: 5000
  topics:
    - project_analysis
    - oppm_created
    - docs_created
    - tracking_ready
    - sops_created
    - templates_ready
    - review_complete

kanban:
  enabled: true
  board_path: ./kanban/board.yaml
  signals:
    on_step_start: true
    on_step_complete: true
    on_agent_activate: true
  wip_enforcement: true

parallel:
  enabled: true
  max_workers: 4
  parallelizable_groups:
    - name: document_generation
      steps: [step-03a-doc, step-03b-track, step-03c-sop, step-03d-template]

autonomous:
  enabled: false
  level: balanced
  thresholds:
    min_coverage: 80
    max_iterations: 3
---

# One-Page Team Workflow v2.0

> 📋 "Từ ý tưởng đến document stack hoàn chỉnh trong 1 session"

```text
╔═══════════════════════════════════════════════════════════════════════════════╗
║                         ONE-PAGE TEAM v2.0                                     ║
║              Complete Project Documentation System                             ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║                                                                                ║
║  Input:  Mô tả dự án từ user                                                   ║
║  Output: 15+ tài liệu tự động (OPPM + Technical + Planning + Tracking + Ref)   ║
║                                                                                ║
║  Commands:                                                                     ║
║    *start      - Bắt đầu session mới                                          ║
║    *status     - Xem trạng thái hiện tại                                       ║
║    *resume     - Tiếp tục session đã pause                                     ║
║    *export     - Export tất cả sang PDF                                        ║
║                                                                                ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

---

## Team Members

| Agent | Icon | Role | Focus | Outputs |
|-------|------|------|-------|---------|
| **Orchestrator** | 📋 | Team Lead | Phân tích, phân công, tổng hợp | Project Analysis, Task Assignment |
| **OPPM** | 📄 | OPPM Specialist | One-Page PM, PDF export | oppm.md, oppm.pdf |
| **Doc** | 📚 | Documentation | Technical & Planning docs | 8 detailed documents |
| **Track** | 📊 | Tracking | Metrics & Dashboards | 4 tracking documents |
| **SOP** | 📝 | Procedures | SOPs & Checklists | 5 procedure documents |
| **Template** | 📐 | Templates | Prompts & Templates | 4 template files |

---

## Workflow Architecture

```text
USER INPUT: "Tạo document stack cho dự án XYZ"
     │
     ▼
╔═════════════════════════════════════════════════════════════════════════════╗
║  STEP 1: INIT                                                                ║
║  📋 Orchestrator Agent                                                       ║
║  ├── Phân tích yêu cầu user                                                  ║
║  ├── Xác định project type, scope, timeline                                  ║
║  ├── Xác định document stack cần thiết                                       ║
║  └── Phân công tasks cho các agents                                          ║
║  [BREAKPOINT: Confirm project analysis?]                                     ║
╚═════════════════════════════════════════════════════════════════════════════╝
     │
     ▼
╔═════════════════════════════════════════════════════════════════════════════╗
║  STEP 2: OPPM                                                                ║
║  📄 OPPM Agent                                                               ║
║  ├── Thu thập thông tin chi tiết (objectives, tasks, timeline)               ║
║  ├── Tạo OPPM với 5 yếu tố bắt buộc                                          ║
║  ├── Validate one-page constraint                                            ║
║  └── Export PDF                                                              ║
║  [SIGNAL: oppm_created → triggers parallel generation]                       ║
╚═════════════════════════════════════════════════════════════════════════════╝
     │
     ├──────────────────────┬──────────────────────┬──────────────────────┐
     ▼                      ▼                      ▼                      ▼
╔════════════════╗   ╔════════════════╗   ╔════════════════╗   ╔════════════════╗
║ STEP 3a: DOC   ║   ║ STEP 3b: TRACK ║   ║ STEP 3c: SOP   ║   ║ STEP 3d: TEMPL ║
║ 📚 Doc Agent   ║   ║ 📊 Track Agent ║   ║ 📝 SOP Agent   ║   ║ 📐 Template    ║
║                ║   ║                ║   ║                ║   ║                ║
║ ├─ Tool Setup  ║   ║ ├─ Tracker     ║   ║ ├─ Phase SOPs  ║   ║ ├─ Prompts     ║
║ ├─ Pipeline    ║   ║ ├─ Dashboard   ║   ║ ├─ Checklist   ║   ║ ├─ SEO         ║
║ ├─ Phase Docs  ║   ║ ├─ Prod Log    ║   ║ └─ Decisions   ║   ║ ├─ Style       ║
║ └─ Calendar    ║   ║ └─ Retro       ║   ║                ║   ║ └─ Brand       ║
║                ║   ║                ║   ║                ║   ║                ║
║ [PARALLEL]     ║   ║ [PARALLEL]     ║   ║ [PARALLEL]     ║   ║ [PARALLEL]     ║
╚════════════════╝   ╚════════════════╝   ╚════════════════╝   ╚════════════════╝
     │                      │                      │                      │
     └──────────────────────┴──────────────────────┴──────────────────────┘
                                        │
                                        ▼
╔═════════════════════════════════════════════════════════════════════════════╗
║  STEP 4: REVIEW                                                              ║
║  📋 Orchestrator Agent                                                       ║
║  ├── Collect outputs từ tất cả agents                                        ║
║  ├── Validate completeness                                                   ║
║  ├── Check cross-references                                                  ║
║  └── Generate document index                                                 ║
║  [BREAKPOINT: Review complete?]                                              ║
╚═════════════════════════════════════════════════════════════════════════════╝
     │
     ▼
╔═════════════════════════════════════════════════════════════════════════════╗
║  STEP 5: EXPORT                                                              ║
║  📋 Orchestrator Agent                                                       ║
║  ├── Export key documents to PDF                                             ║
║  ├── Create README.md with links                                             ║
║  └── Open output folder                                                      ║
╚═════════════════════════════════════════════════════════════════════════════╝
     │
     ▼
╔═════════════════════════════════════════════════════════════════════════════╗
║  STEP 6: SUMMARY                                                             ║
║  📋 Orchestrator Agent                                                       ║
║  ├── Display document stack summary                                          ║
║  ├── Show file sizes and locations                                           ║
║  └── Offer next steps                                                        ║
╚═════════════════════════════════════════════════════════════════════════════╝
```

---

## Configuration

### Paths

```yaml
team_root: .microai/teams/one-page-team/
output_base: output/{project-name}/
```

### Session State

```yaml
session:
  project_name: null
  project_type: null
  current_step: null
  agents_status:
    orchestrator: idle
    oppm: idle
    doc: idle
    track: idle
    sop: idle
    template: idle
  documents_created: []
  last_checkpoint: null
```

---

## Observer Controls

| Command | Action |
|---------|--------|
| `*start` | Bắt đầu session mới |
| `*status` | Xem trạng thái hiện tại |
| `*pause` | Pause session, save checkpoint |
| `*resume` | Resume từ checkpoint |
| `*skip [step]` | Bỏ qua step cụ thể |
| `*retry [step]` | Retry step thất bại |
| `*export` | Export tất cả sang PDF |
| `*abort` | Hủy session |

---

## Output Structure

```text
output/{project-name}/
│
├── README.md                      # Index với links đến tất cả documents
│
├── 01-oppm/
│   ├── oppm.md                    # One-Page Project Management
│   └── oppm.pdf                   # PDF export
│
├── 02-technical/
│   ├── tool-setup-guides.md       # Hướng dẫn cài đặt tools
│   ├── pipeline-architecture.md   # Sơ đồ quy trình
│   ├── prompt-library.md          # Thư viện prompts
│   └── batch-scripts/             # Scripts tự động
│
├── 03-planning/
│   ├── phase-1-breakdown.md       # Chi tiết Phase 1
│   ├── phase-2-breakdown.md       # Chi tiết Phase 2
│   ├── phase-3-breakdown.md       # Chi tiết Phase 3
│   ├── phase-4-breakdown.md       # Chi tiết Phase 4
│   ├── content-calendar.md        # Lịch nội dung
│   └── risk-mitigation.md         # Quản lý rủi ro
│
├── 04-tracking/
│   ├── weekly-tracker.md          # Theo dõi hàng tuần
│   ├── metrics-dashboard.md       # Dashboard KPIs
│   ├── production-log.md          # Log sản xuất
│   └── retrospective.md           # Bài học kinh nghiệm
│
└── 05-reference/
    ├── quality-checklist.md       # Checklist chất lượng
    ├── content-style-guide.md     # Hướng dẫn style
    └── seo-templates.md           # Templates SEO
```

---

## Error Handling

| Error | Recovery |
|-------|----------|
| Agent timeout | Retry với increased timeout |
| Validation failed | Show errors, offer manual fix |
| Parallel step failed | Continue others, retry failed |
| Checkpoint corrupted | Start from last valid checkpoint |

---

## Exit Conditions

| Condition | Action |
|-----------|--------|
| All documents created | Proceed to export |
| User abort | Save checkpoint, cleanup |
| Critical error | Save state, report error |
| Session timeout (1h) | Auto-save checkpoint |

---

## Activation Protocol

```xml
<team id="one-page-team" name="One-Page Team" version="2.0">
<activation critical="MANDATORY">
  <step n="1">Load workflow.md</step>
  <step n="2">Initialize session state</step>
  <step n="3">Display menu box</step>
  <step n="4">Greet user: "Xin chào! Tôi là One-Page Team..."</step>
  <step n="5">Wait for *start command or project description</step>
  <step n="6">Execute workflow steps sequentially</step>
  <step n="7">Parallel execution at Step 3</step>
  <step n="8">Review and export</step>
  <step n="9">Display summary</step>
</activation>
</team>
```

---

**"Một dự án thành công bắt đầu từ tài liệu rõ ràng."**
