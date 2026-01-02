# Knowledge Forge - Central Knowledge Architecture

**Version:** 1.0
**Date:** 2026-01-01
**Status:** DESIGN

---

## Vision

> "One source of truth, smart loading, zero duplication"

Transform 39 scattered knowledge directories into a unified, layered knowledge system.

---

## Architecture: 4 Layers

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         KNOWLEDGE FORGE                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                               │
│   .microai/knowledge/                                                        │
│   │                                                                           │
│   ├── registry.yaml              ← SINGLE SOURCE OF TRUTH                    │
│   │                                                                           │
│   ├── universal/                 ← LAYER 1: Everyone can use                 │
│   │   ├── thinking/              Thinking frameworks, methodologies          │
│   │   ├── patterns/              Language-agnostic patterns                  │
│   │   └── processes/             Development processes                       │
│   │                                                                           │
│   ├── domains/                   ← LAYER 2: Language/Tech specific           │
│   │   ├── go/                    Go language knowledge                       │
│   │   ├── security/              Security knowledge                          │
│   │   ├── testing/               Testing knowledge                           │
│   │   └── devops/                DevOps knowledge                            │
│   │                                                                           │
│   ├── roles/                     ← LAYER 3: Role-specific                    │
│   │   ├── architect/             Architecture decisions                      │
│   │   ├── reviewer/              Code review                                 │
│   │   ├── pm/                    Product management                          │
│   │   └── qa/                    Quality assurance                           │
│   │                                                                           │
│   └── projects/                  ← LAYER 4: Project-specific (gitignored)    │
│       └── {project}/             Per-project learned knowledge               │
│                                                                               │
│   DEPENDENCY RULE:                                                            │
│   Layer 4 → Layer 3 → Layer 2 → Layer 1                                      │
│   (Inner can depend on outer, never reverse)                                 │
│                                                                               │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Layer Definitions

### Layer 1: Universal (`universal/`)

**Purpose:** Language-agnostic knowledge usable by ANY agent

**Content:**
```
universal/
├── thinking/
│   ├── thinking-frameworks.md      # Socratic, 5-Why, First Principles
│   ├── problem-solving.md          # Polya method, PDSA
│   └── decision-making.md          # Mental models, inversion
│
├── patterns/
│   ├── design-patterns.md          # Common software patterns
│   ├── anti-patterns.md            # What NOT to do
│   └── architecture-patterns.md    # System architecture
│
└── processes/
    ├── code-review.md              # Review checklist
    ├── estimation.md               # Estimation techniques
    └── documentation.md            # Doc standards
```

**Token Budget:** ~10,000 tokens total
**Auto-load:** Rarely (only thinking frameworks for relevant agents)

---

### Layer 2: Domains (`domains/`)

**Purpose:** Technology/language-specific knowledge

**Content:**
```
domains/
├── go/
│   ├── fundamentals.md             # Go basics, idioms
│   ├── concurrency.md              # Goroutines, channels
│   ├── http-patterns.md            # HTTP handling
│   ├── error-handling.md           # Error patterns
│   ├── testing.md                  # Go testing
│   └── performance.md              # Optimization
│
├── security/
│   ├── owasp-top-10.md             # Web vulnerabilities
│   ├── secure-coding.md            # Secure code practices
│   ├── threat-modeling.md          # Threat analysis
│   └── penetration-testing.md      # Attack methodology
│
├── testing/
│   ├── strategies.md               # Test strategies
│   ├── tdd.md                      # Test-driven development
│   └── coverage.md                 # Coverage analysis
│
└── devops/
    ├── docker.md                   # Containerization
    ├── ci-cd.md                    # Pipelines
    └── monitoring.md               # Observability
```

**Token Budget:** ~30,000 tokens total
**Auto-load:** Based on agent's domain tag

---

### Layer 3: Roles (`roles/`)

**Purpose:** Role-specific workflows and checklists

**Content:**
```
roles/
├── architect/
│   ├── adr-template.md             # Architecture Decision Records
│   ├── system-design.md            # Design checklist
│   └── tech-spec.md                # Technical specifications
│
├── reviewer/
│   ├── review-checklist.md         # Code review checklist
│   ├── pr-template.md              # PR description template
│   └── feedback-guide.md           # How to give feedback
│
├── pm/
│   ├── user-stories.md             # User story format
│   ├── acceptance-criteria.md      # AC guidelines
│   └── prioritization.md           # Backlog prioritization
│
└── qa/
    ├── test-plan.md                # Test plan template
    ├── bug-report.md               # Bug report format
    └── regression.md               # Regression testing
```

**Token Budget:** ~15,000 tokens total
**Auto-load:** Based on agent's role tag

---

### Layer 4: Projects (`projects/`)

**Purpose:** Project-specific learned knowledge (NOT shared)

**Content:**
```
projects/
└── {project-name}/
    ├── decisions.md                # Project decisions
    ├── learned-patterns.md         # What worked
    ├── learned-anti-patterns.md    # What didn't work
    └── conventions.md              # Project conventions
```

**Token Budget:** Unlimited (project-specific)
**Auto-load:** Always for project agents
**Git Status:** GITIGNORED (each project has its own)

---

## Registry Schema

```yaml
# registry.yaml - Single Source of Truth

version: "2.0"
last_updated: "2026-01-01"

# Layer 1: Universal
universal:
  thinking/thinking-frameworks:
    file: universal/thinking/thinking-frameworks.md
    tokens: 1500
    tags: [thinking, methodology, socratic]
    description: "7 thinking frameworks including Socratic method"

  patterns/design-patterns:
    file: universal/patterns/design-patterns.md
    tokens: 2000
    tags: [patterns, design, architecture]
    description: "Common software design patterns"

# Layer 2: Domains
domains:
  go/fundamentals:
    file: domains/go/fundamentals.md
    tokens: 2500
    tags: [go, basics, idioms]
    depends_on: []
    description: "Go language fundamentals and idioms"

  go/concurrency:
    file: domains/go/concurrency.md
    tokens: 1800
    tags: [go, concurrency, goroutines]
    depends_on: [go/fundamentals]
    description: "Go concurrency patterns"

  security/owasp-top-10:
    file: domains/security/owasp-top-10.md
    tokens: 3000
    tags: [security, owasp, vulnerabilities]
    description: "OWASP Top 10 security vulnerabilities"

# Layer 3: Roles
roles:
  reviewer/review-checklist:
    file: roles/reviewer/review-checklist.md
    tokens: 1200
    tags: [review, checklist, quality]
    description: "Code review checklist"

  pm/user-stories:
    file: roles/pm/user-stories.md
    tokens: 1000
    tags: [pm, agile, requirements]
    description: "User story format and INVEST criteria"

# Agent Knowledge Mappings
agents:
  go-dev-agent:
    auto_load:
      - go/fundamentals
      - go/error-handling
    on_demand:
      concurrency_task: [go/concurrency]
      http_task: [go/http-patterns]
      security_review: [security/owasp-top-10]

  go-review-linus-agent:
    auto_load:
      - go/fundamentals
      - reviewer/review-checklist
    on_demand:
      security_check: [security/owasp-top-10]
      performance_review: [go/performance]

# Token Budgets
budgets:
  default_auto_load: 5000
  max_on_demand: 10000
  warning_threshold: 8000
```

---

## Migration Plan

### Phase 1: Create Structure (Day 1)

```bash
mkdir -p .microai/knowledge/{universal,domains,roles,projects}
mkdir -p .microai/knowledge/universal/{thinking,patterns,processes}
mkdir -p .microai/knowledge/domains/{go,security,testing,devops}
mkdir -p .microai/knowledge/roles/{architect,reviewer,pm,qa}
```

### Phase 2: Consolidate Universal (Day 2)

| Source | Target |
|--------|--------|
| deep-question-agent/01-thinking-frameworks.md | universal/thinking/thinking-frameworks.md |
| go-team/architect/01-architecture-patterns.md | universal/patterns/architecture-patterns.md |
| shared/estimation-techniques.md | universal/processes/estimation.md |

### Phase 3: Consolidate Domains (Day 3-4)

| Source | Target |
|--------|--------|
| go-dev-agent/knowledge/* | domains/go/* |
| shared/owasp-top-10.md | domains/security/owasp-top-10.md |
| go-team/test/01-test-strategies.md | domains/testing/strategies.md |

### Phase 4: Consolidate Roles (Day 5)

| Source | Target |
|--------|--------|
| go-team/reviewer/01-review-checklist.md | roles/reviewer/review-checklist.md |
| go-team/pm/01-user-stories.md | roles/pm/user-stories.md |
| go-team/architect/02-adr-guide.md | roles/architect/adr-template.md |

### Phase 5: Update Agents (Day 6-7)

Update each agent.md to reference new central locations.

### Phase 6: Cleanup (Day 8)

Remove old scattered knowledge files after verification.

---

## Smart Loading Algorithm

```python
def load_knowledge(agent, task_context):
    """Load relevant knowledge for agent based on task"""

    # 1. Always load auto_load from registry
    knowledge = []
    for k in registry.agents[agent].auto_load:
        knowledge.append(load_file(k))

    # 2. Check task context for on_demand triggers
    for trigger, files in registry.agents[agent].on_demand.items():
        if trigger in task_context:
            for f in files:
                if total_tokens(knowledge) + tokens(f) < budget:
                    knowledge.append(load_file(f))

    # 3. Respect token budget
    while total_tokens(knowledge) > registry.budgets.max_on_demand:
        knowledge.pop()  # Remove lowest priority

    return knowledge
```

---

## Benefits

| Aspect | Before | After |
|--------|--------|-------|
| **Files** | 148 scattered | ~50 organized |
| **Duplicates** | 13+ sets | 0 |
| **Directories** | 39 | 4 layers |
| **Source of Truth** | Multiple | 1 registry |
| **Token Usage** | Unknown | Measured & budgeted |
| **Discovery** | Hard | registry.yaml |
| **Maintenance** | N places | 1 place |

---

## Open Questions

1. **Versioning:** How to handle Go 1.22 vs 1.23 knowledge?
2. **Project Layer:** Should learned patterns be promotable to shared?
3. **Migration:** Big bang or gradual strangler fig?
4. **Index Files:** Delete 31 existing ones or repurpose?

---

*Knowledge Forge - "One source of truth, smart loading, zero duplication"*
