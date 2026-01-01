# Skills Mapping Guide

> Hướng dẫn chọn skills phù hợp cho từng loại agent.

---

## 1. Tổng quan

Skills là các gói modular cung cấp specialized capabilities cho agents. Khác với knowledge files (tĩnh), skills cung cấp workflows và utilities có thể thực thi.

```
┌─────────────────────────────────────────────────────────────────┐
│                    SKILLS ARCHITECTURE                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Agent                 Skills                                  │
│   ┌─────────┐           ┌─────────────┐                        │
│   │ Persona │──────────▶│ Capabilities │                        │
│   │Knowledge│           │ Workflows   │                        │
│   │ Memory  │           │ Utilities   │                        │
│   └─────────┘           └─────────────┘                        │
│                                                                 │
│   Agent = WHO (expert với persona)                              │
│   Skill = WHAT (khả năng cụ thể)                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Available Skills

### 2.1 Document Skills

**Location**: `.microai/skills/document-skills/`

| Skill | Purpose | Use When |
|-------|---------|----------|
| `docx` | Word documents | Creating, editing, analyzing .docx files |
| `pdf` | PDF processing | Extract, merge, split, fill forms |
| `pptx` | PowerPoint | Creating presentations |
| `xlsx` | Excel spreadsheets | Formulas, data analysis, visualization |

### 2.2 Development Skills

**Location**: `.microai/skills/development-skills/`

| Skill | Purpose | Use When |
|-------|---------|----------|
| `mcp-builder` | Build MCP servers | Creating LLM integrations |
| `skill-creator` | Create new skills | Meta-task: creating skills |
| `webapp-testing` | Playwright testing | Testing web applications |
| `web-artifacts-builder` | Complex web artifacts | React/Tailwind multi-component |

### 2.3 Design Skills

**Location**: `.microai/skills/design-skills/`

| Skill | Purpose | Use When |
|-------|---------|----------|
| `algorithmic-art` | Generative art | p5.js, particle systems |
| `canvas-design` | Visual art | Posters, static designs |
| `frontend-design` | Production UI | Websites, dashboards |
| `theme-factory` | Theme styling | Apply themes to artifacts |

### 2.4 Communication Skills

**Location**: `.microai/skills/communication-skills/`

| Skill | Purpose | Use When |
|-------|---------|----------|
| `doc-coauthoring` | Collaborative docs | Proposals, specs, decision docs |
| `internal-comms` | Internal communications | Reports, newsletters, FAQs |
| `slack-gif-creator` | Animated GIFs | Slack emoji, message GIFs |

---

## 3. Agent → Skills Mapping

### 3.1 By Agent Domain

```yaml
# ═══════════════════════════════════════════════════════════════
# META AGENTS
# ═══════════════════════════════════════════════════════════════
father-agent:
  skills: [skill-creator]
  reason: "Creates new agents and skills"

# ═══════════════════════════════════════════════════════════════
# DEVELOPMENT AGENTS
# ═══════════════════════════════════════════════════════════════
go-dev-agent:
  skills: [webapp-testing]
  reason: "Testing Go web applications"

backend-dev-agent:
  skills: [mcp-builder, webapp-testing]
  reason: "Build integrations, test APIs"

frontend-dev-agent:
  skills: [frontend-design, theme-factory, web-artifacts-builder]
  reason: "UI design and complex artifacts"

# ═══════════════════════════════════════════════════════════════
# DOCUMENTATION AGENTS
# ═══════════════════════════════════════════════════════════════
doc-manager-agent:
  skills: [docx, pdf, pptx, xlsx]
  reason: "Handle all document formats"

reporter-agent:
  skills: [docx, pdf, xlsx, internal-comms]
  reason: "Generate reports in various formats"

latex-agent:
  skills: [pdf]
  reason: "PDF output from LaTeX"

# ═══════════════════════════════════════════════════════════════
# TESTING AGENTS
# ═══════════════════════════════════════════════════════════════
tester-agent:
  skills: [webapp-testing]
  reason: "End-to-end web testing"

qa-agent:
  skills: [webapp-testing, doc-coauthoring]
  reason: "Testing + test documentation"

# ═══════════════════════════════════════════════════════════════
# DESIGN AGENTS
# ═══════════════════════════════════════════════════════════════
ui-designer-agent:
  skills: [frontend-design, canvas-design, theme-factory]
  reason: "Full design capabilities"

creative-agent:
  skills: [algorithmic-art, canvas-design, slack-gif-creator]
  reason: "Creative visual outputs"

# ═══════════════════════════════════════════════════════════════
# COMMUNICATION AGENTS
# ═══════════════════════════════════════════════════════════════
pm-agent:
  skills: [doc-coauthoring, internal-comms, pptx]
  reason: "Documentation and presentations"

scrum-master-agent:
  skills: [internal-comms]
  reason: "Status updates and reports"
```

### 3.2 Skill Matrix

```
                    │ docx │ pdf │ pptx │ xlsx │ mcp │ test │ ui │ art │ comms │
────────────────────┼──────┼─────┼──────┼──────┼─────┼──────┼────┼─────┼───────┤
father-agent        │      │     │      │      │     │      │    │     │       │
go-dev-agent        │      │     │      │      │     │  ✓   │    │     │       │
doc-manager-agent   │  ✓   │  ✓  │  ✓   │  ✓   │     │      │    │     │       │
reporter-agent      │  ✓   │  ✓  │      │  ✓   │     │      │    │     │   ✓   │
tester-agent        │      │     │      │      │     │  ✓   │    │     │       │
frontend-agent      │      │     │      │      │     │      │ ✓  │     │       │
creative-agent      │      │     │      │      │     │      │    │  ✓  │       │
pm-agent            │      │     │  ✓   │      │     │      │    │     │   ✓   │
```

---

## 4. How to Add Skills to Agent

### 4.1 In Frontmatter

```yaml
---
name: doc-manager-agent
description: |
  Document management specialist...
model: sonnet
color: yellow
icon: "📄"
tools:
  - Read
  - Write
  - Bash
language: vi

# ADD SKILLS HERE
skills:
  - docx
  - pdf
  - pptx
  - xlsx
---
```

### 4.2 In Workflow (Reference)

```markdown
## Workflow: Generate Report

1. Gather data from sources
   → Agent handles

2. Create Excel analysis
   → Load skill: xlsx

3. Generate PDF report
   → Load skill: pdf

4. Create presentation
   → Load skill: pptx
```

---

## 5. Rules & Best Practices

### 5.1 Selection Rules

```
✅ DO:
- Match skills to agent's primary domain
- Keep skill list focused (2-4 skills max)
- Only add skills agent will actually use

❌ DON'T:
- Add all skills to every agent
- Add unrelated skills "just in case"
- Duplicate functionality (knowledge vs skill)
```

### 5.2 Skill vs Knowledge

| Aspect | Skill | Knowledge |
|--------|-------|-----------|
| **Type** | Executable workflow | Reference information |
| **Location** | `.microai/skills/` | `agent/knowledge/` |
| **Format** | SKILL.md + utilities | Markdown files |
| **Usage** | Call during task | Load for context |
| **Example** | `pdf` (create PDFs) | `pdf-best-practices.md` |

### 5.3 When NOT to Add Skills

```
- Agent already has domain knowledge
- Skill functionality overlaps with agent's core
- Agent is read-only/analysis focused
- Skills add unnecessary complexity
```

---

## 6. Validation

### 6.1 Check Available Skills

```bash
# List all skills
ls .microai/skills/*/

# Check skill exists
test -f .microai/skills/document-skills/pdf/SKILL.md && echo "Valid"
```

### 6.2 Validate Agent Skills

```bash
# Check skills field in agent
grep "^skills:" .microai/agents/*/agent.md

# Validate skill references
for skill in $(yq '.skills[]' agent.md); do
  test -d ".microai/skills/*/$skill" || echo "Invalid: $skill"
done
```

---

## 7. Migration

### 7.1 Adding Skills to Existing Agent

```yaml
# BEFORE
---
name: reporter-agent
model: sonnet
tools: [Read, Write]
language: vi
---

# AFTER
---
name: reporter-agent
model: sonnet
tools: [Read, Write]
language: vi
skills:              # NEW
  - pdf
  - xlsx
  - internal-comms
---
```

### 7.2 Update Checklist

```
□ Identify agent's primary domain
□ Select 2-4 relevant skills
□ Add skills field to frontmatter
□ Update workflow if needed
□ Test agent with skills
```

---

## 8. Quick Reference

| Agent Type | Recommended Skills |
|------------|-------------------|
| Meta/Orchestration | `skill-creator` |
| Development | `mcp-builder`, `webapp-testing` |
| Documentation | `docx`, `pdf`, `pptx`, `xlsx` |
| Testing | `webapp-testing` |
| Frontend/Design | `frontend-design`, `theme-factory`, `canvas-design` |
| Creative | `algorithmic-art`, `canvas-design`, `slack-gif-creator` |
| Communication | `doc-coauthoring`, `internal-comms` |
| Reports | `xlsx`, `pdf`, `internal-comms` |
