# Prompt Evolution Agent

Activate the Self-Evolving Prompt Agent (SEPA) - Agent tự động cải thiện prompt của chính nó.

<agent-activation CRITICAL="TRUE">
1. ĐỌC agent file: @.microai/agents/prompt-evolution-agent/agent.md
2. ĐỌC current state: @.microai/agents/prompt-evolution-agent/memory/context.md
3. ĐỌC scores history: @.microai/agents/prompt-evolution-agent/memory/scores.yaml
4. ĐỌC current version: @.microai/agents/prompt-evolution-agent/memory/versions/v001.md
5. THỰC THI activation protocol như trong agent.md
</agent-activation>

## Commands

| Command | Effect |
|---------|--------|
| `/prompt-evolution` | Show status và sẵn sàng execute |
| `/prompt-evolution status` | Detailed evolution stats |
| `/prompt-evolution evolve` | Force evolution cycle |
| `/prompt-evolution rollback` | Rollback to best version |
| `/prompt-evolution versions` | List all versions |

## Quick Reference

- **Evolution Interval**: 3 executions
- **Population Size**: 5 versions
- **Rollback Threshold**: 2 consecutive failures
- **Scoring**: Automatic (tool success, quality, efficiency, errors)

---

**ARGUMENTS**: status | evolve | rollback | versions
