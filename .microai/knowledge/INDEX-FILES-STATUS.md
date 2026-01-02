# Knowledge Index Files Status

**Date:** 2026-01-01
**Status:** UNUSED but RETAINED

## Current Situation

There are **31 knowledge-index.yaml** files across the ecosystem:
- 8 in `.microai/agents/`
- 23 in `.microai/teams/`

## Usage Status

| Tool/Agent | Uses Index? | Notes |
|------------|-------------|-------|
| father-agent | Mentions but doesn't load | Documents that indexes should exist |
| Agent activation | NO | Agents load files by path, not via index |
| Any script | NO | No automation consumes these files |

## Why Retained?

1. **Future potential**: Smart loading could use these indexes
2. **Documentation value**: They document available knowledge
3. **Low cost**: Small files, no harm keeping them

## Recommended Future Action

Either:
1. **DELETE ALL** - If we decide indexes are unnecessary
2. **IMPLEMENT TOOLING** - Create loader that uses indexes for smart loading

## File Locations

```
.microai/agents/*/knowledge/knowledge-index.yaml
.microai/teams/*/knowledge/knowledge-index.yaml
.microai/teams/project-team/*/knowledge/knowledge-index.yaml
```

---

*Part of Knowledge Forge audit - 2026-01-01*
