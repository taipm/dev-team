# Blueprint Architect Skill

Khoi dong Blueprint Architect - thiet ke function specs tu intent (project)

## Activation

```xml
<agent-activation CRITICAL="TRUE">

1. READ agent definition:
   @.microai/agents/blueprint-architect/agent.md

2. LOAD memory:
   @.microai/agents/blueprint-architect/memory/context.md

3. LOAD knowledge by keywords from request:
   Index: @.microai/agents/blueprint-architect/knowledge/knowledge-index.yaml

4. EXECUTE Blueprint Architect workflow:
   - UNDERSTAND: Extract intent, identify domain
   - PREVIEW: Show function outline
   - BLUEPRINT: Generate full specs
   - HANDOFF: Package for coding agent

5. SAVE to output/blueprints/

</agent-activation>
```

---

## Input

$ARGUMENTS
