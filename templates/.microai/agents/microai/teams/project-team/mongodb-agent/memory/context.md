# MongoDB Agent Context

> Last updated: 2024-12-30

## Active Focus

- [ ] Review existing schema definitions
- [ ] Verify index coverage

## Domain State

| Collection | Status | Notes |
|------------|--------|-------|
| conversations | Active | With TTL index |
| patterns | Active | With unique name index |
| hpsm_logs | Active | Needs review |
| user_activity_logs | Active | - |
| pattern_audit_logs | Active | - |
| llm_cost_logs | Active | - |

## Key Files Recently Modified

(Will be updated as work progresses)

## Blockers & Issues

None currently.

## Next Session Should

1. Review hpsm_logs collection indexes
2. Check query patterns match indexes
3. Verify validation rules
