# Interview Assessment: Coin Change (Medium DP)

## Session Info

| Field | Value |
|-------|-------|
| Session ID | 2024-12-31-interview-coin-change |
| Date | 2024-12-31 |
| Mode | Interview Prep |
| Duration | ~25 minutes |
| Difficulty | Medium |
| Problem | Coin Change (Unbounded Knapsack) |

---

## Problem Given

### Statement

You are given an integer array `coins` representing coins of different denominations and an integer `amount` representing a total amount of money.

Return the **fewest number of coins** that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return `-1`.

You may assume that you have an infinite number of each kind of coin.

### Constraints
- 1 ≤ coins.length ≤ 12
- 1 ≤ coins[i] ≤ 2³¹ - 1
- 0 ≤ amount ≤ 10⁴

### Examples
```
Input: coins = [1, 2, 5], amount = 11
Output: 3
Explanation: 11 = 5 + 5 + 1

Input: coins = [2], amount = 3
Output: -1

Input: coins = [1], amount = 0
Output: 0
```

---

## Candidate Performance

### Timeline

| Time | Event |
|------|-------|
| 0:00 | Problem presented |
| 2:00 | Finished clarifying questions |
| 5:00 | Explained approach (disproved greedy, proposed DP) |
| 8:00 | Started coding |
| 15:00 | Finished coding |
| 20:00 | Tested solution with examples |
| 25:00 | Discussed optimization |

### Approach Evolution

1. **Initial Thought:** Considered greedy (always pick largest coin)
2. **Disproved Greedy:** Found counterexample [1,3,4], amount=6
3. **Final Approach:** Bottom-up DP with state dp[i] = min coins for amount i

---

## Assessment Criteria

### 1. Problem Understanding

**Score:** 5/5

| Aspect | Observation |
|--------|-------------|
| Clarifying questions | Asked 4 good questions (infinite coins, order, edge cases) |
| Edge case identification | Identified amount=0 and impossible cases |
| Constraint awareness | Noted n ≤ 12, amount ≤ 10⁴ |

### 2. Approach Selection

**Score:** 5/5

| Aspect | Observation |
|--------|-------------|
| Algorithm choice | Correctly identified DP |
| Disproved greedy | Provided clear counterexample |
| Trade-off analysis | Discussed time/space complexity |

### 3. Coding Quality

**Score:** 5/5

| Aspect | Observation |
|--------|-------------|
| Code correctness | First attempt correct |
| Code readability | Clear variable names, comments |
| Syntax accuracy | No errors |
| Variable naming | Descriptive (dp, coin, complement) |

### 4. Testing & Debugging

**Score:** 5/5

| Aspect | Observation |
|--------|-------------|
| Test case selection | Traced through Example 1 |
| Edge case coverage | Tested amount=0, impossible case |
| Debugging approach | N/A - code correct first try |

### 5. Communication

**Score:** 5/5

| Aspect | Observation |
|--------|-------------|
| Clarity of explanation | Very clear throughout |
| Thought process verbalization | Excellent "thinking out loud" |
| Response to feedback | Receptive, answered follow-ups well |

---

## Solution Analysis

### Candidate's Solution

```python
def coin_change(coins: list[int], amount: int) -> int:
    if amount == 0:
        return 0

    dp = [float('inf')] * (amount + 1)
    dp[0] = 0

    for i in range(1, amount + 1):
        for coin in coins:
            if coin <= i:
                dp[i] = min(dp[i], dp[i - coin] + 1)

    return dp[amount] if dp[amount] != float('inf') else -1
```

### Complexity

| Metric | Candidate's Answer | Actual | Correct? |
|--------|-------------------|--------|----------|
| Time | O(amount × n) | O(amount × n) | ✅ |
| Space | O(amount) | O(amount) | ✅ |

### Correctness Verification

| Case | Input | Expected | Output | Status |
|------|-------|----------|--------|--------|
| Basic | [1,2,5], 11 | 3 | 3 | ✅ |
| Impossible | [2], 3 | -1 | -1 | ✅ |
| Zero | [1], 0 | 0 | 0 | ✅ |
| Single coin | [3], 9 | 3 | 3 | ✅ |

---

## Score Summary

| Criteria | Score | Weight | Weighted |
|----------|-------|--------|----------|
| Problem Understanding | 5/5 | 15% | 0.75 |
| Approach Selection | 5/5 | 25% | 1.25 |
| Coding Quality | 5/5 | 30% | 1.50 |
| Testing & Debugging | 5/5 | 15% | 0.75 |
| Communication | 5/5 | 15% | 0.75 |
| **Total** | | 100% | **5.0/5** |

---

## Final Verdict

### Decision

**Result:** ⭐⭐⭐⭐⭐ STRONG HIRE

| Verdict | Criteria |
|---------|----------|
| Strong Hire | 4.5+ overall, optimal solution, excellent communication |
| Hire | 3.5-4.4, working solution, good communication |
| Borderline | 2.5-3.4, partial solution with guidance |
| No Hire | <2.5, could not solve with hints |

### Reasoning

Candidate demonstrated:
- Strong problem-solving methodology
- Solid DP understanding
- Excellent communication skills
- Production-quality code

---

## Feedback for Candidate

### Strengths

- Systematic approach: clarify → analyze → implement → test
- Excellent counterexample for disproving greedy
- Clear DP state definition
- Clean, readable code
- Thorough edge case handling

### Areas for Improvement

- Could discuss space optimization (though not necessary here)
- Could mention related problems (Unbounded Knapsack family)

### Recommended Practice

| Topic | Resources |
|-------|-----------|
| DP Patterns | LeetCode DP Study Plan |
| Knapsack Variants | 0/1, Unbounded, Bounded |
| Similar Problems | Perfect Squares, Minimum Cost for Tickets |

---

## Follow-up Questions Discussed

1. **Space optimization**: Can you reduce to O(1) space? → No, need all previous states

2. **Reconstruct path**: How to return which coins used? → Track parent pointer

3. **Bounded coins**: What if each coin can only be used once? → 0/1 Knapsack variant

---

## Sign-off

| Agent | Role | Status |
|-------|------|--------|
| Algo-Master 🧙 | Interviewer | ✅ Strong Hire |
| Code Reviewer 🔍 | Evaluator | ✅ Approved |
| Developer 👨‍💻 | Candidate | ✅ Completed |

---

## Interview Tips from This Session

| Tip | Example |
|-----|---------|
| Always ask clarifying questions | "Can coins be used multiple times?" |
| Try simple approaches first | Greedy → counterexample → DP |
| Define DP state clearly | "dp[i] = min coins for amount i" |
| Trace through examples | Manual walkthrough of dp array |
| Handle edge cases explicitly | amount=0, impossible case |
| Communicate throughout | "I'm thinking DP because..." |

---

**Generated by Dev-Algo Team Simulation**
**Interview Duration:** ~25 minutes
**Total Turns:** 6
