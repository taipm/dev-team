---
step: 3d
name: template
title: Templates & Prompts
agent: template-agent
trigger: oppm_created
parallel: true
group: document_generation
---

# Step 3d: Templates & Prompts

## Objective
Tạo prompt library, SEO templates, và style guides.

## Agent
📐 **Template Agent**

## Trigger
- Signal: `oppm_created` từ Step 2
- Parallel với: Step 3a, 3b, 3c

## Input
```yaml
project_context:
  name: string
  niche: string
  tools: array
  content_type: string
output_path: output/{project}/
```

## Actions

### 3d.1 Create Prompt Library
```yaml
actions:
  - Generate prompts for each tool
  - Categorize by purpose
  - Include examples and tips
```

### 3d.2 Create SEO Templates
```yaml
actions:
  - Create title templates
  - Create description templates
  - Create tag templates
```

### 3d.3 Create Content Style Guide
```yaml
actions:
  - Define voice and tone
  - Set formatting rules
  - List do's and don'ts
```

### 3d.4 Create Brand Guidelines
```yaml
actions:
  - Basic visual identity
  - Messaging framework
  - Consistency rules
```

## Outputs
```text
output/{project}/
└── 05-reference/
    ├── prompt-library.md
    ├── seo-templates.md
    ├── content-style-guide.md
    └── brand-guidelines.md
```

## Signals
```yaml
on_complete:
  - templates_ready
  - payload:
      template_docs: [paths]
```

## Error Handling
| Error | Recovery |
|-------|----------|
| No tools specified | Use generic prompts |
| Niche unclear | Ask or use general |

## Transition
→ **Step 4: Review** (after all parallel steps complete)
