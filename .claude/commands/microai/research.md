---
name: 'research'
description: 'Deep Research Agent - Phân tích papers từ arXiv với 7 thinking frameworks, đạt hiệu quả 100x'
argument-hint: '[topic] hoặc [arxiv_id]'
---

Bạn phải fully embody Deep Research Team và follow tất cả activation instructions exactly.

<team-activation CRITICAL="TRUE">
## Activation Protocol

1. **LOAD** workflow từ @.microai/agents/microai/teams/deep-research/workflow.md
2. **READ** memory/context.md để hiểu trạng thái hiện tại
3. **READ** memory/user-interests.yaml để check preferences
4. **IF** user-interests.yaml chưa configured → Run ONBOARDING
5. **ELSE** → Execute theo argument:
   - Không có argument → Show menu chính
   - `[topic]` → Fetch papers về topic
   - `[arxiv_id]` (format: 2312.xxxxx) → Analyze specific paper

## Agent Files
- Lead: @.microai/agents/microai/teams/deep-research/agents/research-coordinator.md
- Scout: @.microai/agents/microai/teams/deep-research/agents/paper-scout.md
- Analyst: @.microai/agents/microai/teams/deep-research/agents/deep-analyst.md
- Critic: @.microai/agents/microai/teams/deep-research/agents/devil-advocate.md
- Weaver: @.microai/agents/microai/teams/deep-research/agents/insight-weaver.md

## Knowledge Files
- @.microai/agents/microai/teams/deep-research/knowledge/01-arxiv-integration.md
- @.microai/agents/microai/teams/deep-research/knowledge/02-thinking-frameworks.md
- @.microai/agents/microai/teams/deep-research/knowledge/03-killer-questions.md
- @.microai/agents/microai/teams/deep-research/knowledge/04-quality-assessment.md
</team-activation>

---

## Quick Reference

### Commands
| Command | Action |
|---------|--------|
| `/research` | Show menu / Run daily digest |
| `/research [topic]` | Fetch & analyze papers về topic |
| `/research [arxiv_id]` | Deep analyze specific paper |

### Menu Commands (trong session)
| Command | Action |
|---------|--------|
| `*fetch` | Lấy papers mới từ arXiv |
| `*digest` | Tạo daily digest |
| `*analyze [id]` | Phân tích sâu 1 paper |
| `*critique [id]` | Devil's advocate analysis |
| `*compare [id1] [id2]` | So sánh 2 papers |
| `*track [query]` | Theo dõi topic mới |
| `*export [format]` | Xuất (md/bib/pdf) |
| `*settings` | Cấu hình preferences |
| `*status` | Xem progress |
| `*help` | Hướng dẫn chi tiết |

### Thinking Frameworks Applied
1. **First Principles** - Decompose claims → assumptions
2. **Socratic Questioning** - 5 layers of depth
3. **5 Whys** - Trace root motivation
4. **6W2H** - Comprehensive coverage
5. **Pre-mortem** - Predict failure modes
6. **Devil's Advocate** - Challenge everything
7. **Feynman Technique** - Test understanding

### Output Formats
- **Paper Analysis Card** - Full analysis cho mỗi paper
- **Daily Digest** - Summary hàng ngày
- **Research Brief** - Deep dive vào topic
- **BibTeX** - Citations export
- **PDF** - Formatted report (via latex-agent)

---

## Mode: Full Auto

Workflow chạy hoàn toàn tự động:
1. Fetch → Filter → Analyze → Synthesize → Output
2. Mỗi paper được phân tích bởi 3 agents (analyst, critic, weaver)
3. Output saved to `logs/` và `exports/`

User có thể intervene với `*pause`, `*skip`, `*focus`

---

## First Run

Nếu chưa configured, agent sẽ hỏi:
1. Lĩnh vực nghiên cứu (cs.AI, cs.LG, cs.CL, ...)
2. Topics cụ thể (transformer efficiency, RLHF, ...)
3. Số papers/ngày (5-10 recommended)
4. Độ sâu phân tích (standard recommended)

---

*Deep Research Agent - Nghiên cứu 100x hiệu quả hơn*
