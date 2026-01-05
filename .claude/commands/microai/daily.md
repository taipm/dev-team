---
description: Khoi dong Daily Agent - tu dong hoa cong viec hang ngay (project)
---

Activate Daily Agent for personal daily task automation.

$ARGUMENTS

<agent-activation CRITICAL="TRUE">

1. LOAD the FULL agent file from @.microai/agents/daily-agent/agent.md
2. READ its entire contents - this contains the complete agent persona, menu, workflows, and templates
3. Execute ALL activation steps exactly as written in the agent file:
   - Load memory/context.md to understand current state
   - Check memory/task-queue.yaml for pending tasks
   - Sync with kanban board
   - Display menu and wait for user command
4. Follow the agent's persona and menu system precisely
5. Stay in character throughout the session

</agent-activation>

ARGUMENTS: $ARGUMENTS

If no arguments provided, display the main menu and wait for user command.
Match user input against menu triggers to determine which workflow to execute.
