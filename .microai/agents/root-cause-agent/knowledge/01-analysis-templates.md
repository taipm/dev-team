# Analysis Templates by Problem Type

> Quick-start templates cho các loại vấn đề thường gặp.

---

## 1. Performance Degradation

```
PROBLEM: [Service/Feature] performance degraded

Step 1 - WHAT:
□ Metric affected: [Response time / Throughput / Error rate]
□ Baseline: [Previous normal value]
□ Current: [Current value]
□ Definition: "[X] increased from [A] to [B] over [time period]"

Step 2 - WHY (5 Whys):
□ Why slow? → [Direct cause: e.g., DB queries slow]
□ Why DB slow? → [e.g., Missing index]
□ Why missing? → [e.g., New query pattern not indexed]
□ Why new pattern? → [e.g., Feature X launched]
□ Why not caught? → [e.g., No perf testing for feature]

Step 3 - HOW:
□ Request flow: [Client → API → Service → DB → ...]
□ Bottleneck location: [Which hop is slow]
□ Resource constraint: [CPU / Memory / IO / Network]

Step 4 - WHERE:
□ Component: [Specific service/module]
□ Layer: [Frontend / Backend / DB / Infra]
□ Hot path: [Which code path]

Step 5 - WHEN:
□ Started: [Date/time]
□ Correlates with: [Deploy / Traffic spike / External event]
□ Pattern: [Constant / Peak hours / Random]

Step 8 - FEEDBACK LOOPS:
□ Retry storms? [Clients retry → more load → more failures]
□ Connection pool exhaustion? [Slow queries → pool full → more queuing]
□ Cache invalidation cascade? [One miss → many misses]
```

---

## 2. Memory Leak

```
PROBLEM: Memory usage growing over time

Step 1 - WHAT:
□ Growth rate: [X MB/hour or day]
□ Crash threshold: [When OOM occurs]
□ Affected instances: [All / Specific pods]

Step 2 - WHY:
□ What's accumulating? [Objects / Connections / Buffers]
□ Why not released? [Reference held / Not closed / Circular ref]
□ Why reference held? [Cache unbounded / Event listener not removed]

Step 3 - HOW:
□ Allocation pattern: [Where objects created]
□ Expected lifecycle: [When should be GC'd]
□ Actual lifecycle: [Why still alive]

Step 4 - WHERE:
□ Heap region: [Old gen / Young gen / Off-heap]
□ Object type: [Class name from heap dump]
□ GC root: [What's holding reference]

Step 5 - WHEN:
□ Growth correlates with: [Requests / Time / Specific operations]
□ Faster under: [Load / Specific features]

Tools:
- Heap dump analysis
- GC logs
- Memory profiler
```

---

## 3. Intermittent Failures

```
PROBLEM: [Operation] fails intermittently

Step 1 - WHAT:
□ Failure rate: [X% of attempts]
□ Error type: [Timeout / Exception / Wrong result]
□ Impact: [User-facing / Background / Data loss]

Step 2 - WHY:
□ Immediate cause: [What error message says]
□ Underlying cause: [Why that error occurs]
□ Root cause: [Why condition exists]

Step 4 - WHERE:
□ Failure point: [Which component throws]
□ Dependency: [External service / DB / Network]
□ Not failing: [What works fine]

Step 5 - WHEN:
□ Time pattern: [Random / Peak hours / Specific times]
□ Correlation: [With deploys / External events / Load]
□ Threshold: [At what load/rate does it fail]

Step 6 - WHO:
□ Affected users: [All / Specific segment]
□ Dependency owner: [Team / External vendor]

Step 7 - ASSUMPTIONS:
□ "Network is reliable" → Actually: [Packet loss / Latency spikes]
□ "Dependency is available" → Actually: [Rate limited / Overloaded]
□ "Retry will succeed" → Actually: [Same failure repeated]

Step 8 - FEEDBACK LOOPS:
□ Retry amplification: [Failures → Retries → More load → More failures]
□ Cascading failures: [A fails → B overloaded → C fails]
```

---

## 4. Data Inconsistency

```
PROBLEM: Data mismatch between [Source A] and [Source B]

Step 1 - WHAT:
□ Discrepancy: [What's different]
□ Scope: [X records / Y% of data]
□ Impact: [Wrong reports / Failed operations]

Step 2 - WHY:
□ How data gets to A: [Write path]
□ How data gets to B: [Sync/replication path]
□ Where divergence: [At which step]

Step 3 - HOW:
□ Data flow: [Source → Transform → Destination]
□ Sync mechanism: [Real-time / Batch / Event-driven]
□ Consistency model: [Eventual / Strong]

Step 5 - WHEN:
□ Lag expected: [X seconds/minutes]
□ Actual lag: [Observed delay]
□ When consistent: [After how long]

Step 7 - ASSUMPTIONS:
□ "Events are ordered" → Actually: [Out of order delivery]
□ "No duplicates" → Actually: [At-least-once delivery]
□ "Idempotent writes" → Actually: [Last-write-wins race]

Step 8 - FEEDBACK LOOPS:
□ Sync backlog: [Lag → More events queued → More lag]
□ Conflict resolution: [Both sources update → Which wins]
```

---

## 5. Build/Deploy Failures

```
PROBLEM: [Build/Deploy] failing

Step 1 - WHAT:
□ Failure type: [Compile / Test / Deploy / Rollout]
□ Error message: [Exact error]
□ Frequency: [Every time / Flaky / Specific conditions]

Step 2 - WHY:
□ Direct cause: [What failed]
□ Why that failed: [Dependency / Config / Code]
□ Why not caught earlier: [Missing test / New change]

Step 4 - WHERE:
□ Pipeline stage: [Which step fails]
□ Environment: [Dev / Staging / Prod]
□ Component: [Which service/module]

Step 5 - WHEN:
□ Started failing: [After which commit/change]
□ Works in: [Local / Other env]
□ Flaky pattern: [Random / Resource-dependent]

Step 6 - WHO:
□ Recent changes by: [Who committed]
□ Owner: [Who can fix]

Step 7 - ASSUMPTIONS:
□ "Env is same as prod" → Actually: [Different versions/config]
□ "Tests are deterministic" → Actually: [Time/order dependent]
□ "Dependencies available" → Actually: [Rate limited / Down]
```

---

## 6. User-Reported Bug

```
PROBLEM: User reports [unexpected behavior]

Step 1 - WHAT:
□ Expected behavior: [What user expected]
□ Actual behavior: [What happened]
□ Reproducible: [Always / Sometimes / Can't reproduce]

Step 2 - WHY:
□ Code doing: [What code actually does]
□ Why different: [Logic error / Edge case / Data issue]
□ Why not caught: [No test / Untested path]

Step 4 - WHERE:
□ Feature: [Which feature/page]
□ Code path: [Which function/module]
□ Data state: [What data triggers this]

Step 5 - WHEN:
□ Started: [Always / After update / Specific conditions]
□ Reproducible when: [Steps to reproduce]

Step 6 - WHO:
□ Affected users: [All / Specific accounts / Roles]
□ User actions: [What user did before bug]

Step 7 - ASSUMPTIONS:
□ "User description accurate" → Verify: [Actually observe]
□ "Same as reported" → Check: [Exact reproduction]
□ "Single cause" → Consider: [Multiple factors]
```

---

## Quick Checklist for Any Problem

```
□ Can I measure it? (If not, define metrics first)
□ When did it start? (Correlate with changes)
□ Who is affected? (Scope the impact)
□ What changed? (Check recent deployments/configs)
□ Is it getting worse? (Trend analysis)
□ What assumptions am I making? (Challenge each)
□ Are there feedback loops? (Self-reinforcing patterns)
□ If I fix X, does problem go away? (Validate root cause)
```
