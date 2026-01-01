# 5-Minute Quickstart

Quick guide to get started with the dev-team framework.

## Step 1: Install (1 minute)

```bash
cd your-project
npx @microai.club/dev-team@alpha install
```

Select all components and wait for installation to complete.

## Step 2: Open Claude Code (30 seconds)

```bash
claude
```

Claude Code will automatically read the configuration from `.claude/` and `.microai/`.

## Step 3: Try Your First Agent (1 minute)

Type in Claude Code:

```
/microai:deep-question
```

The Deep Question Agent will be activated and help you ask deep questions about problems.

### Example Conversation

```
You: /microai:deep-question

Agent: Welcome to the Deep Question Agent!
I'll help you ask deep questions using 7 thinking methods.

What problem would you like to explore today?

You: Why are microservices so complex?

Agent: Great question! Let me apply some methods:

🔍 **5 Why Analysis**:
1. Why are microservices complex?
   → Many services need coordination
2. Why do they need coordination?
   → Each service has its own logic
   ...

🎯 **First Principles**:
- What's the core of distributed systems?
- Can network latency be avoided?
...
```

## Step 4: Try Your First Team (2 minutes)

Type in Claude Code:

```
/microai:deep-thinking
```

The Deep Thinking Team with 7 Titans will be activated:

```
You: /microai:deep-thinking

Maestro: 🎭 Deep Thinking Team is ready!

Team of 7 Titans:
- 🔮 Socrates - The Questioner
- 🧬 Aristotle - The Logician
- ⚡ Musk - The Disruptor
- 🔬 Feynman - The Explainer
- 🎭 Munger - The Sage
- 📐 Polya - The Solver
- 🎨 Da Vinci - The Connector

What problem would you like the team to analyze?

You: Design an authentication system for a mobile app

Maestro: Starting 5-phase analysis!

📍 PHASE 1: UNDERSTAND
Socrates is asking clarifying questions...
```

## Step 5: Explore More (30 seconds)

### Available Commands

```bash
# List all commands
dev-team list

# Or in Claude Code
/help
```

### Popular Session Teams

| Command | Description |
|---------|-------------|
| `/microai:dev-user-session` | Developer + End User create User Story |
| `/microai:dev-architect-session` | Developer + Architect design system |
| `/microai:dev-qa-session` | Developer + QA review and test |

## Summary

In 5 minutes, you have:

1. ✅ Installed the dev-team framework
2. ✅ Activated the Deep Question Agent
3. ✅ Used the Deep Thinking Team
4. ✅ Discovered available commands

## Next Steps

- **Learn about Agents**: [Agent Overview](../agents/overview.md)
- **Explore Teams**: [Team Overview](../teams/overview.md)
- **Real Workflows**: [Use Cases](../workflows/use-cases.md)

## Usage Tips

### When to Use an Agent?

- Simple, clear tasks
- Need an expert in one area
- Don't need multiple perspectives

### When to Use a Team?

- Complex, multi-faceted problems
- Need deep analysis from multiple angles
- Want coordination between different roles

---

> **Tip**: Try `/microai:father` to create a custom agent for your domain!
