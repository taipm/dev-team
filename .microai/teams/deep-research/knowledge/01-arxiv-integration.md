# arXiv Integration Guide

## Overview

Hướng dẫn tích hợp với arXiv API để fetch papers tự động. Document này cover API patterns, rate limits, và best practices.

---

## arXiv API Basics

### Base URL
```
http://export.arxiv.org/api/query
```

### Query Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `search_query` | Search terms | `all:transformer` |
| `id_list` | Specific arXiv IDs | `2312.12345,2312.12346` |
| `start` | Result offset | `0` |
| `max_results` | Max papers | `50` (max 2000) |
| `sortBy` | Sort field | `relevance`, `lastUpdatedDate`, `submittedDate` |
| `sortOrder` | Sort direction | `ascending`, `descending` |

---

## Search Query Syntax

### Field Prefixes

| Prefix | Field | Example |
|--------|-------|---------|
| `ti:` | Title | `ti:transformer` |
| `au:` | Author | `au:vaswani` |
| `abs:` | Abstract | `abs:attention mechanism` |
| `co:` | Comment | `co:accepted ICLR` |
| `jr:` | Journal ref | `jr:nature` |
| `cat:` | Category | `cat:cs.AI` |
| `rn:` | Report number | - |
| `id:` | arXiv ID | `id:2312.12345` |
| `all:` | All fields | `all:LLM agents` |

### Boolean Operators

```
AND  - Both terms required
OR   - Either term
ANDNOT - Exclude term
```

**Examples:**
```
# Papers about transformers in cs.AI or cs.LG
(cat:cs.AI OR cat:cs.LG) AND all:transformer

# Papers by specific author about attention
au:vaswani AND all:attention

# Recent LLM papers excluding surveys
all:large language model ANDNOT ti:survey
```

### Phrase Matching

Sử dụng double quotes cho exact phrases:
```
all:"chain of thought"
ti:"language model"
```

---

## Category Codes

### Computer Science (cs.*)

| Code | Name | Focus |
|------|------|-------|
| cs.AI | Artificial Intelligence | General AI, reasoning, planning |
| cs.LG | Machine Learning | Learning algorithms, neural nets |
| cs.CL | Computation and Language | NLP, text processing |
| cs.CV | Computer Vision | Image/video understanding |
| cs.CR | Cryptography and Security | Security, privacy |
| cs.SE | Software Engineering | Software development |
| cs.DC | Distributed Computing | Parallel, distributed systems |
| cs.PL | Programming Languages | Language design, compilers |
| cs.DB | Databases | Data management |
| cs.IR | Information Retrieval | Search, recommendation |
| cs.HC | Human-Computer Interaction | UX, interfaces |
| cs.RO | Robotics | Robot control, planning |
| cs.NE | Neural and Evolutionary | Bio-inspired computing |

### Statistics (stat.*)

| Code | Name |
|------|------|
| stat.ML | Machine Learning |
| stat.ME | Methodology |
| stat.TH | Theory |
| stat.CO | Computation |

### Mathematics (math.*)

| Code | Name |
|------|------|
| math.OC | Optimization and Control |
| math.ST | Statistics Theory |
| math.NA | Numerical Analysis |
| math.PR | Probability |

### Other Common

| Code | Name |
|------|------|
| eess.SP | Signal Processing |
| eess.AS | Audio and Speech |
| q-bio.NC | Neurons and Cognition |
| quant-ph | Quantum Physics |

---

## API Response Format

### Atom XML Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>ArXiv Query: ...</title>
  <opensearch:totalResults>1234</opensearch:totalResults>
  <opensearch:startIndex>0</opensearch:startIndex>
  <opensearch:itemsPerPage>50</opensearch:itemsPerPage>

  <entry>
    <id>http://arxiv.org/abs/2312.12345v1</id>
    <updated>2024-12-30T00:00:00Z</updated>
    <published>2024-12-29T00:00:00Z</published>
    <title>Paper Title Here</title>
    <summary>Abstract text here...</summary>
    <author>
      <name>First Author</name>
    </author>
    <author>
      <name>Second Author</name>
    </author>
    <arxiv:comment>Accepted to ICLR 2025</arxiv:comment>
    <link href="http://arxiv.org/abs/2312.12345v1" rel="alternate" type="text/html"/>
    <link title="pdf" href="http://arxiv.org/pdf/2312.12345v1" rel="related" type="application/pdf"/>
    <arxiv:primary_category term="cs.AI"/>
    <category term="cs.AI"/>
    <category term="cs.LG"/>
  </entry>
  <!-- More entries... -->
</feed>
```

### Key Fields to Extract

| Field | XPath | Notes |
|-------|-------|-------|
| arXiv ID | `entry/id` | Extract from URL |
| Title | `entry/title` | May have newlines |
| Abstract | `entry/summary` | May have LaTeX |
| Authors | `entry/author/name` | List |
| Published | `entry/published` | ISO datetime |
| Updated | `entry/updated` | Latest version |
| PDF URL | `entry/link[@title='pdf']/@href` | Direct PDF |
| Primary Category | `entry/arxiv:primary_category/@term` | Main category |
| Categories | `entry/category/@term` | All categories |
| Comment | `entry/arxiv:comment` | Optional |
| Journal Ref | `entry/arxiv:journal_ref` | If published |

---

## Rate Limits & Best Practices

### Rate Limits
```yaml
limits:
  requests_per_second: 1  # Be conservative
  max_results_per_query: 2000
  recommended_batch_size: 50

  rate_limit_response:
    - HTTP 429 Too Many Requests
    - "rate limit" in error message
```

### Best Practices

1. **Cache Aggressively**
   - Papers don't change (only new versions)
   - Cache metadata for 24 hours minimum
   - Cache PDFs locally if needed

2. **Batch Requests**
   - Use `max_results=50` per request
   - Paginate with `start` parameter
   - Don't hit API for same query repeatedly

3. **Respect Rate Limits**
   - Add 3-second delay between requests
   - Exponential backoff on 429
   - Use RSS for daily monitoring

4. **Optimize Queries**
   - Be specific with categories
   - Use date sorting for freshness
   - Combine related terms with OR

---

## Common Query Patterns

### Daily New Papers in Category
```python
# Fetch last 24 hours of cs.AI papers
query = "cat:cs.AI"
params = {
    "sortBy": "submittedDate",
    "sortOrder": "descending",
    "max_results": 100
}
# Then filter by date in results
```

### Keyword Search with Category Filter
```python
query = "(cat:cs.AI OR cat:cs.LG) AND all:transformer efficiency"
params = {
    "sortBy": "relevance",
    "max_results": 50
}
```

### Author-Based Search
```python
query = "au:hinton OR au:lecun OR au:bengio"
params = {
    "sortBy": "submittedDate",
    "sortOrder": "descending",
    "max_results": 30
}
```

### Multi-Topic Monitoring
```python
queries = [
    "all:RLHF reinforcement learning human feedback",
    "all:multimodal vision language",
    "all:efficient inference LLM",
]
# Run each query separately, merge results
```

---

## RSS Feeds (Alternative)

Khi API rate limited hoặc cho daily monitoring:

### Feed URLs
```
https://arxiv.org/rss/cs.AI
https://arxiv.org/rss/cs.LG
https://arxiv.org/rss/cs.CL
https://arxiv.org/rss/cs.CV
```

### RSS Entry Format
```xml
<item>
  <title>Paper Title. (arXiv:2312.12345v1 [cs.AI])</title>
  <link>http://arxiv.org/abs/2312.12345</link>
  <description>
    &lt;p&gt;Authors: First Author, Second Author&lt;/p&gt;
    &lt;p&gt;Abstract text here...&lt;/p&gt;
  </description>
  <pubDate>Mon, 30 Dec 2024 00:00:00 GMT</pubDate>
</item>
```

### Parsing RSS
```python
# Extract from title
import re
match = re.search(r'arXiv:(\d+\.\d+)(v\d+)?\s*\[([^\]]+)\]', title)
arxiv_id = match.group(1)
version = match.group(2) or "v1"
category = match.group(3)

# Extract authors from description
authors_match = re.search(r'Authors?: ([^<]+)', description)
authors = authors_match.group(1).split(', ')
```

---

## Semantic Scholar Enhancement

Bổ sung citation data từ Semantic Scholar:

### API Endpoint
```
https://api.semanticscholar.org/graph/v1/paper/arXiv:{arxiv_id}
```

### Fields to Fetch
```
fields=citationCount,influentialCitationCount,publicationDate,venue,authors
```

### Response
```json
{
  "paperId": "...",
  "citationCount": 150,
  "influentialCitationCount": 25,
  "venue": "NeurIPS 2024",
  "authors": [
    {"name": "Author Name", "hIndex": 45}
  ]
}
```

### Rate Limits
- 100 requests per 5 minutes without API key
- 1000 requests per 5 minutes with free API key

---

## Error Handling

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| 403 Forbidden | Blocked IP | Wait 1 hour, use proxy |
| 429 Too Many Requests | Rate limit | Exponential backoff |
| 500 Server Error | arXiv down | Retry after delay |
| Empty results | Bad query | Check query syntax |
| Malformed XML | Encoding issue | Handle special chars |

### Retry Strategy
```python
def fetch_with_retry(url, max_retries=3):
    delays = [10, 30, 60]  # seconds
    for i in range(max_retries):
        try:
            response = fetch(url)
            if response.status == 429:
                time.sleep(delays[i])
                continue
            return response
        except NetworkError:
            time.sleep(delays[i])
    raise MaxRetriesExceeded()
```

---

## Quick Reference

### Minimal Fetch Query
```
http://export.arxiv.org/api/query?search_query=cat:cs.AI&sortBy=submittedDate&sortOrder=descending&max_results=20
```

### Full Query Template
```
http://export.arxiv.org/api/query?
  search_query=(cat:cs.AI+OR+cat:cs.LG)+AND+all:transformer
  &sortBy=submittedDate
  &sortOrder=descending
  &start=0
  &max_results=50
```

### Key URLs

| Resource | URL |
|----------|-----|
| API Base | `http://export.arxiv.org/api/query` |
| Paper Page | `https://arxiv.org/abs/{id}` |
| PDF | `https://arxiv.org/pdf/{id}.pdf` |
| RSS Feed | `https://arxiv.org/rss/{category}` |
| API Docs | `https://info.arxiv.org/help/api/` |
