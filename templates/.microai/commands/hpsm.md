---
description: HPSM Integration Specialist - upgrade, modify, debug HPSM ticketing system
argument-hint: "[task description]"
---

Use the hpsm-agent to help with this HPSM integration task:

$ARGUMENTS

Load and follow the agent knowledge from:
- `.claude/agents/microai/agents/hpsm-agent/hpsm-agent.md` - Main agent with architecture overview
- `.claude/agents/microai/agents/hpsm-agent/patterns.md` - Development patterns
- `.claude/agents/microai/agents/hpsm-agent/anti-patterns.md` - Anti-patterns to avoid
- `.claude/agents/microai/agents/hpsm-agent/project-decisions.md` - ADRs and conventions

HPSM codebase locations:
- Infrastructure: `src/backend/ask-it-server/internal/hpsm/`
- Tools: `src/backend/ask-it-server/tools/hpsm/`
- Services: `src/backend/ask-it-server/services/hpsm_log.go`

Apply HPSM best practices: 4-tier routing hierarchy, OAuth2 auto-refresh, proper validation, async logging.
