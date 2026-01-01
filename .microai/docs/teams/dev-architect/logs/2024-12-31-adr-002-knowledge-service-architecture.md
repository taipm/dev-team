---
session_id: "arch-2024-12-31-002"
mode: "design"
topic: "Knowledge Service - Microservices Design"
date: "2024-12-31"
participants:
  - solution-architect
  - developer
turns: 10
status: completed
sign_offs:
  architect: approved
  developer: approved
---

# ADR-002: Knowledge Service Architecture

## Status
**Accepted**

## Date
2024-12-31

## Session Context
- **Session ID**: arch-2024-12-31-002
- **Participants**: Developer, Solution Architect
- **Discussion Turns**: 10
- **Mode**: System Design (Deep Dive)

---

## Executive Summary

This ADR defines a comprehensive architecture for the Knowledge Service, addressing:
1. **Performance & Speed** - Multi-level indexing for O(1) lookups
2. **Upgrade & Extensibility** - Schema versioning with migration system
3. **Core Knowledge Protection** - Three-layer immutable/curated/user model
4. **Poisoning Prevention** - Multi-layer validation with trust levels
5. **Auto-Learning** - Safeguarded feedback loop with human review
6. **Scientific Organization** - Bloom taxonomy + evidence-based structure

**Decision**: Implement as embedded SDK (Library Pattern) with future-ready abstractions.

---

## Context

### Current Pain Points
1. Knowledge loading tightly coupled with sessions
2. No caching (file read every time)
3. No protection against knowledge corruption
4. No learning from sessions
5. Unstructured knowledge organization

### Requirements
- Offline-first (CLI without service)
- Future multi-client support (Web UI, API)
- Scientific knowledge organization
- Protection against poisoning attacks
- Sustainable auto-learning mechanism

---

## Decision Drivers

1. **Offline Support**: Must work without network
2. **Security**: Core knowledge must be tamper-proof
3. **Scalability**: Support 100+ knowledge files
4. **Maintainability**: Clear upgrade paths
5. **Safety**: Prevent knowledge poisoning

---

## Decision

### Primary Decision: SDK Pattern (Not Microservice)

**Chosen**: Embedded Library/SDK with pluggable storage backends.

**Rationale**:
- Works offline (file storage default)
- No infrastructure overhead
- Can upgrade to remote storage later
- Single package distribution

**Rejected Alternatives**:
- Full Microservice: Breaks offline, overkill complexity
- Sidecar Pattern: Deferred to future for caching needs

---

## Architecture

### 1. High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    KNOWLEDGE SDK ARCHITECTURE                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                     KnowledgeSDK                            │ │
│  │  • load(id) → KnowledgeItem                                │ │
│  │  • unload(id) → bool                                       │ │
│  │  • search(query) → List[KnowledgeItem]                     │ │
│  │  • learn(observation) → void                               │ │
│  └────────────────────────────────────────────────────────────┘ │
│         │              │              │              │          │
│         ▼              ▼              ▼              ▼          │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐   │
│  │  Index    │  │   Cache   │  │ Validator │  │ Learning  │   │
│  │  Engine   │  │  Manager  │  │  Engine   │  │ Pipeline  │   │
│  └───────────┘  └───────────┘  └───────────┘  └───────────┘   │
│         │                                           │          │
│         └───────────────────┬───────────────────────┘          │
│                             ▼                                   │
│              ┌─────────────────────────┐                       │
│              │   Storage Backend       │                       │
│              │   (Strategy Pattern)    │                       │
│              └─────────────────────────┘                       │
│                    │              │                             │
│            ┌───────┘              └───────┐                    │
│            ▼                              ▼                    │
│     ┌─────────────┐               ┌─────────────┐             │
│     │LocalStorage │               │RemoteStorage│             │
│     │  (Default)  │               │  (Future)   │             │
│     └─────────────┘               └─────────────┘             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

### 2. Performance & Indexing

#### Multi-Level Index Architecture

```
Level 1: Master Index (Always in memory, <10KB)
├── Knowledge ID → Shard pointer + metadata
└── Bloom filter for fast negative lookup

Level 2: Shard Indexes (Lazy loaded, ~5KB each)
├── security/index.yaml
├── estimation/index.yaml
└── patterns/index.yaml

Level 3: Content Files (Load on demand)
└── Actual knowledge markdown files
```

#### Performance Targets

| Operation | Target Latency |
|-----------|----------------|
| Index lookup | <10ms |
| Single file load (cached) | <5ms |
| Single file load (disk) | <50ms |
| Search (100 files) | <100ms |
| Full reload | <500ms |

#### Caching Strategy: Two-Layer

```
Layer 1: In-Memory LRU Cache
├── Max items: 15
├── Eviction: LRU
└── Scope: Session

Layer 2: File Cache
├── Location: .microai/cache/knowledge/
├── Format: JSON with checksum
├── TTL: Invalidate on source change
└── Max size: 50MB
```

---

### 3. Schema Versioning & Migration

#### Schema Version Format

```yaml
# knowledge/schema/v1.yaml
version: "1.0"
schema:
  knowledge_item:
    required: [id, path, tokens]
    optional: [tags, priority, applicable_teams]
```

#### Migration System

```python
class SchemaMigration:
    migrations = {
        ("1.0", "2.0"): migrate_v1_to_v2,
        ("2.0", "3.0"): migrate_v2_to_v3,
    }

    def migrate(self, data, from_version, to_version):
        # Chain migrations automatically
        pass

    def ensure_compatible(self, data):
        # Auto-migrate on load
        pass
```

#### Extension Points

- Plugin system for custom functionality
- Hook system for lifecycle events
- Pluggable storage backends

---

### 4. Core Knowledge Protection

#### Three-Layer Protection Model

```
┌─────────────────────────────────────────────────────────────┐
│ Layer 0: IMMUTABLE CORE                                      │
│ ├── Shipped with npm package                                │
│ ├── Cryptographically signed                                │
│ ├── Verified on load                                        │
│ └── CANNOT be modified by user                              │
├─────────────────────────────────────────────────────────────┤
│ Layer 1: CURATED                                             │
│ ├── Team-reviewed                                           │
│ ├── Git-versioned                                           │
│ ├── Requires approval to modify                             │
│ └── Audit trail maintained                                  │
├─────────────────────────────────────────────────────────────┤
│ Layer 2: USER                                                │
│ ├── Full user control                                       │
│ ├── No verification required                                │
│ └── Isolated from core                                      │
└─────────────────────────────────────────────────────────────┘
```

#### Access Control Matrix

| Layer | Read | Write | Delete | Source |
|-------|------|-------|--------|--------|
| Core | ✅ All | ❌ None | ❌ None | Package |
| Curated | ✅ All | ⚠️ Reviewed | ⚠️ Reviewed | Git |
| User | ✅ Owner | ✅ Owner | ✅ Owner | Local |

#### Integrity Verification

```python
class KnowledgeIntegrity:
    def verify_core(self) -> Tuple[bool, List[str]]:
        """Verify all core files against signed manifest."""
        manifest = self._load_manifest()
        for file_path, expected_hash in manifest['files'].items():
            actual_hash = sha256(file_path)
            if actual_hash != expected_hash:
                errors.append(f"INTEGRITY VIOLATION: {file_path}")
        return len(errors) == 0, errors
```

---

### 5. Poisoning Prevention

#### Threat Model

| Attack Vector | Description | Mitigation |
|---------------|-------------|------------|
| Malicious Injection | Bad security advice, malicious code | Content validation |
| Auto-Learning Poisoning | False learnings, corrupted patterns | Confidence thresholds, human review |
| Supply Chain Attack | Compromised npm package | Signed manifests, integrity checks |
| Prompt Injection | Hidden instructions in content | Pattern detection |

#### Trust Levels

```yaml
trust_levels:
  verified:
    description: "Cryptographically signed, from official package"
    validation: strict
    auto_load: true

  reviewed:
    description: "Team-reviewed, git-versioned"
    validation: standard
    auto_load: true
    requires_approval: true

  community:
    description: "Community contributed, not reviewed"
    validation: paranoid
    auto_load: false
    show_warning: true

  user:
    description: "User's personal knowledge"
    validation: basic
    sandboxed: true
```

#### Validation Pipeline

```python
class KnowledgeValidator:
    rules = [
        check_structure,
        check_content_safety,
        check_code_blocks,        # Detect rm -rf, eval, etc.
        check_hidden_instructions, # Detect prompt injection
        check_trust_level,
    ]

    def validate(self, content, source) -> ValidationResult:
        for rule in self.rules:
            result = rule(content, source)
            if result.severity == 'critical':
                return ValidationResult(valid=False, blocked=True)
        return ValidationResult(valid=True)
```

#### Suspicious Pattern Detection

```python
suspicious_patterns = [
    r'ignore previous instructions',
    r'disregard all prior',
    r'you are now',
    r'new system prompt',
    r'</?(system|user|assistant)>',
]

dangerous_code_patterns = [
    r'rm\s+-rf\s+/',
    r'eval\s*\(',
    r'os\.system\s*\(',
    r'subprocess\.call.*shell=True',
]
```

---

### 6. Auto-Learning Mechanism

#### Learning Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 AUTO-LEARNING PIPELINE                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Stage 1: COLLECTION                                        │
│  ├── Capture observations from sessions                     │
│  ├── Record: decisions, patterns, errors, feedback          │
│  └── Anti-poisoning validation                              │
│                                                              │
│  Stage 2: VALIDATION                                        │
│  ├── Confidence threshold (≥0.7)                            │
│  ├── Content safety check                                   │
│  └── Reject suspicious observations                         │
│                                                              │
│  Stage 3: AGGREGATION                                       │
│  ├── Cluster similar observations                           │
│  ├── Extract patterns                                       │
│  └── Rank by frequency and confidence                       │
│                                                              │
│  Stage 4: INTEGRATION                                       │
│  ├── Low-risk: Auto-promote to user layer                   │
│  ├── High-risk: Queue for human review                      │
│  └── NEVER auto-promote to core layer                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

#### Safeguards

| Safeguard | Description |
|-----------|-------------|
| Confidence Threshold | Must reach 0.7 before consideration |
| Evidence Count | Minimum 3 occurrences required |
| Human Review | Security-related learnings require approval |
| Layer Restriction | Auto-learning only writes to user layer |
| Rate Limiting | Max 10 learnings per session |

#### Observation Model

```python
@dataclass
class Observation:
    session_id: str
    timestamp: datetime
    type: str  # 'decision', 'pattern', 'error', 'feedback'
    context: dict
    outcome: str
    confidence: float
    user_feedback: Optional[str] = None

@dataclass
class Learning:
    id: str
    pattern: str
    description: str
    evidence_count: int
    confidence: float
    status: str  # 'candidate', 'validated', 'promoted', 'rejected'
```

---

### 7. Scientific Knowledge Organization

#### Knowledge Taxonomy (Bloom-Inspired)

```
Level 6: CREATE
├── Design patterns for novel problems
├── Architecture templates
└── Innovation frameworks

Level 5: EVALUATE
├── Code review checklists
├── Security assessment guides
└── Performance benchmarks

Level 4: ANALYZE
├── Debugging methodologies
├── Root cause analysis
└── Trade-off comparisons

Level 3: APPLY
├── Implementation patterns (how-to)
├── Code templates
└── Step-by-step guides

Level 2: UNDERSTAND
├── Concept explanations
├── Architecture overviews
└── Relationship diagrams

Level 1: REMEMBER (Foundation)
├── Definitions
├── Syntax references
└── API documentation
```

#### Evidence-Based Knowledge Structure

```yaml
id: owasp-top-10-a01

taxonomy:
  level: evaluate
  domain: security
  subdomain: access-control

metadata:
  title: "A01:2021 - Broken Access Control"
  version: "2021.1"
  last_updated: "2024-12-31"

evidence:
  sources:
    - type: standard
      name: "OWASP Top 10 2021"
      credibility: authoritative

    - type: research
      name: "Verizon DBIR 2024"
      finding: "Access control failures in 34% of breaches"

  confidence: 0.95
  citation_count: 1500+

content:
  definition: "..."
  prevention:
    - text: "Deny by default"
      evidence: "OWASP, NIST 800-53"
      confidence: 0.99

relationships:
  related_to: [owasp-a07-xss, owasp-a03-injection]
  supersedes: [owasp-2017-a5]
```

---

### 8. Memory Organization

#### Memory Types

```
┌─────────────────────────────────────────────────────────────┐
│                    MEMORY ARCHITECTURE                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  EPISODIC MEMORY (What happened)                            │
│  └── .microai/memory/sessions/                              │
│      ├── Session records                                    │
│      ├── 90-day retention                                   │
│      └── Queryable by: date, topic, agents, outcome         │
│                                                              │
│  SEMANTIC MEMORY (Facts & Concepts)                         │
│  └── .microai/memory/semantic/                              │
│      ├── entities/ (projects, people, technologies)         │
│      ├── concepts/ (architecture, patterns)                 │
│      └── relationships.yaml                                 │
│                                                              │
│  PROCEDURAL MEMORY (How-to)                                 │
│  └── .microai/memory/procedural/                            │
│      ├── workflows/ (step-by-step)                          │
│      ├── patterns/ (reusable)                               │
│      └── skills/ (learned)                                  │
│                                                              │
│  WORKING MEMORY (Current Context)                           │
│  └── .microai/memory/context/                               │
│      ├── current-session.yaml                               │
│      ├── loaded-knowledge.yaml                              │
│      └── pending-decisions.yaml                             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

#### Retention Policies

| Memory Type | Retention | Archive |
|-------------|-----------|---------|
| Episodic | 90 days | Compressed archive |
| Semantic | Permanent | Versioned |
| Procedural | Permanent | Updated on better methods |
| Working | Session-scoped | Cleared on end |

---

## File Structure

```
.microai/
├── knowledge/
│   ├── core/                    # Layer 0: Immutable
│   │   ├── manifest.json        # Signed integrity manifest
│   │   ├── .signatures/         # Cryptographic signatures
│   │   └── *.md                 # Core knowledge files
│   │
│   ├── curated/                 # Layer 1: Team-reviewed
│   │   ├── .reviews/            # Approval records
│   │   └── *.md                 # Curated knowledge
│   │
│   ├── user/                    # Layer 2: User's own
│   │   └── *.md                 # Personal knowledge
│   │
│   ├── shared/                  # Cross-team (existing)
│   │   ├── registry.yaml
│   │   └── *.md
│   │
│   └── master-index.yaml        # Multi-level index
│
├── memory/
│   ├── sessions/                # Episodic
│   ├── semantic/                # Facts & Concepts
│   ├── procedural/              # How-to
│   └── context/                 # Working memory
│
├── cache/                       # Gitignored
│   └── knowledge/               # File cache
│
└── learning/
    ├── observations/            # Raw observations
    ├── candidates/              # Candidate learnings
    └── review-queue/            # Pending human review

src/knowledge/
├── __init__.py
├── sdk.py                       # Main SDK class
├── models.py                    # Data models
├── index.py                     # Indexing engine
├── cache.py                     # Cache manager
├── validator.py                 # Validation engine
├── integrity.py                 # Integrity verification
├── learning.py                  # Learning pipeline
├── storage/
│   ├── base.py                  # Abstract interface
│   ├── local.py                 # File system
│   └── remote.py                # Future HTTP client
└── exceptions.py                # Custom exceptions
```

---

## Implementation Plan

### Phase 1: Foundation (Week 1-2)
- [ ] SDK core structure
- [ ] Local storage backend
- [ ] Basic caching (in-memory)
- [ ] Master index implementation

### Phase 2: Protection (Week 3)
- [ ] Three-layer protection model
- [ ] Integrity verification
- [ ] Content validation
- [ ] Trust level system

### Phase 3: Performance (Week 4)
- [ ] Multi-level indexing
- [ ] File cache layer
- [ ] Bloom filter for search
- [ ] Performance benchmarks

### Phase 4: Learning (Week 5-6)
- [ ] Observation collection
- [ ] Learning pipeline
- [ ] Human review queue
- [ ] Safe promotion system

### Phase 5: Organization (Week 7)
- [ ] Taxonomy implementation
- [ ] Evidence-based structure
- [ ] Memory system
- [ ] Relationship graph

---

## Consequences

### Positive
- ✅ Offline-first with future remote capability
- ✅ Core knowledge protected from tampering
- ✅ Safe auto-learning with human oversight
- ✅ Scientific knowledge organization
- ✅ High performance at scale
- ✅ Clear upgrade paths

### Negative
- ⚠️ Significant implementation effort (~7 weeks)
- ⚠️ Complexity increase
- ⚠️ Learning system requires monitoring

### Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Integrity check too slow | Low | Medium | Lazy verification, cache results |
| Learning poisoning | Medium | High | Strict validation, human review |
| Cache corruption | Low | Low | Fallback to source files |
| Migration failures | Low | Medium | Backup before migrate, rollback |

---

## Testing Requirements

### Security Tests
- [ ] Path traversal prevention
- [ ] Integrity verification
- [ ] Prompt injection detection
- [ ] Trust level enforcement

### Performance Tests
- [ ] Index lookup <10ms
- [ ] Search 100 files <100ms
- [ ] Full reload <500ms

### Learning Tests
- [ ] Poisoned observation rejection
- [ ] Confidence threshold enforcement
- [ ] Human review queue integration

---

## Sign-off

| Role | Name | Status | Date |
|------|------|--------|------|
| Solution Architect | 🏗️ solution-architect | ✅ Approved | 2024-12-31 |
| Developer | 👨‍💻 developer | ✅ Approved | 2024-12-31 |

---

## References

- ADR-001: Knowledge & Memory System Architecture (foundation)
- OWASP Top 10 2021
- Bloom's Taxonomy of Educational Objectives
- "Designing Data-Intensive Applications" - Martin Kleppmann

---

**Generated by Dev-Architect Team Simulation**
**Session ID:** arch-2024-12-31-002
