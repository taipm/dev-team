# Command Entry Template

Sử dụng template này để tạo command file trong `.claude/commands/`.

---

## Template

```markdown
---
name: '{command-name}'
description: '{Agent Name} - {short description of capabilities}'
---

You must fully embody this agent's persona and follow all activation instructions exactly as specified. NEVER break character until given an exit command.

<agent-activation CRITICAL="TRUE">
1. LOAD the FULL agent file from @.claude/agents/{agent-name}/agent.md
2. READ its entire contents - this contains the complete agent persona, knowledge base, and instructions
3. Execute ALL activation steps exactly as written in the agent file
4. Apply {Domain} Best Practices to all tasks
5. Stay in character throughout the session
</agent-activation>

## Quick Reference

When activated, this agent specializes in:
- {Capability 1}
- {Capability 2}
- {Capability 3}
- {Capability 4}

## Knowledge Files Available

Load relevant knowledge based on task keywords:
- `01-{topic}.md` - {Brief description}
- `02-{topic}.md` - {Brief description}
- `03-{topic}.md` - {Brief description}
```

---

## Rules

```
1. name PHẢI match với agent name
   - Đây là command user sẽ gõ: /{name}

2. description PHẢI ngắn gọn
   - Hiển thị trong help/autocomplete
   - Max ~80 characters

3. Path trong LOAD PHẢI đúng
   - Bắt đầu với @
   - Relative từ project root

4. Quick Reference giúp user biết agent làm gì
   - 4-6 bullet points
   - Action-oriented language

5. Knowledge Files list giúp transparency
   - User biết có gì available
   - Agent biết load gì
```

---

## Examples

### Simple Command

```markdown
---
name: 'gateway'
description: 'Gateway Agent - API Gateway, middleware, auth, rate limiting'
---

You must fully embody this agent's persona...

<agent-activation CRITICAL="TRUE">
1. LOAD the FULL agent file from @.claude/agents/gateway-agent/agent.md
2. READ its entire contents
3. Execute ALL activation steps
4. Stay in character
</agent-activation>
```

### With Subcommands

```markdown
---
name: 'go-team'
description: 'Go Development Team - Full development lifecycle'
---

<agent-activation CRITICAL="TRUE">
1. LOAD from @.claude/agents/go-team/orchestrator.md
2. Display team menu
3. Route to specialized agents as needed
</agent-activation>

## Available Sub-Agents

- `*architect` - System design
- `*coder` - Implementation
- `*reviewer` - Code review
- `*tester` - Testing
```

---

## Checklist

```
□ File location: .claude/commands/{name}.md
□ name field matches intended command
□ description is concise
□ Path to agent.md is correct
□ CRITICAL="TRUE" is set
□ Quick reference included
□ Knowledge files listed
```
