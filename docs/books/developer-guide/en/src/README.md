# Developer Guide - @microai.club/dev-team

Welcome to the **Developer Guide** for the dev-team framework!

## Introduction

This book is for developers who want to **create** and **extend** components of the dev-team framework:

- Create custom **Agents** for specific domains
- Build **Teams** with multiple coordinating agents
- Develop reusable **Skills**
- Set up **Commands** for quick activation
- Configure **Hooks** for automation

## Prerequisites

Before reading this book, you should:

1. Be familiar with using dev-team (see [User Guide](../../user-guide/en/src/README.md))
2. Have basic understanding of YAML and Markdown
3. Have experience with Claude Code

## Book Structure

| Part | Content | For |
|------|---------|-----|
| Part 1-2 | Architecture & Creating Agents | All developers |
| Part 3 | Creating Teams | Multi-agent systems |
| Part 4-5 | Skills & Commands | Automation |
| Part 6 | Hooks System | Customization |
| Part 7-8 | Knowledge & Memory | Advanced |
| Part 9-10 | Best Practices & Case Studies | Production |

## Where to Start?

### Want to create your first Agent?

Read [Part 2: Creating Agents](./chapters/creating-agents/basic-agent.md)

### Want to understand the architecture?

Read [Part 1: Architecture Overview](./chapters/architecture/overview.md)

### Want to create a Team?

Read [Part 3: Creating Teams](./chapters/creating-teams/basic-team.md)

## Conventions in This Book

### Code Examples

```yaml
# ✅ Good - This is the recommended approach
name: my-agent
description: Agent with clear description

# ❌ Bad - Avoid this
name: a
description: ...
```

### Callouts

> **Note**: Important information to remember

> **Warning**: Things to avoid or pay special attention to

> **Tip**: Helpful suggestions for working more effectively

## Additional Resources

- **Templates**: See [Appendix: Templates](./chapters/appendix/templates.md)
- **Reference Manual**: Detailed reference at [Reference Manual](../../reference/en/src/README.md)
- **GitHub**: [github.com/taipm/dev-team](https://github.com/taipm/dev-team)

---

Let's get started with [MicroAI Architecture](./chapters/architecture/overview.md)!
