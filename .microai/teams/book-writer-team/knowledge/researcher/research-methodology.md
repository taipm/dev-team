# Research Methodology

Guidelines for research and fact-checking in technical writing.

## Source Hierarchy

### Tier 1: Primary Sources (Most Authoritative)
- Official documentation
- Language/framework specifications
- Original research papers
- Author's direct communications

### Tier 2: Authoritative Secondary Sources
- Books by recognized experts
- Conference talks from creators
- Official tutorials and guides
- Peer-reviewed technical articles

### Tier 3: Community Sources
- Well-maintained blog posts
- Stack Overflow accepted answers
- GitHub discussions
- Technical forums

### Tier 4: Supplementary (Use with Caution)
- Personal blogs
- Social media
- AI-generated content
- Undated articles

## Source Evaluation Criteria

### CRAAP Test for Technical Sources
- **Currency:** Is this up-to-date for current versions?
- **Relevance:** Does this address our specific topic?
- **Authority:** Who wrote this? Are they credible?
- **Accuracy:** Is this verifiable and correct?
- **Purpose:** Why was this written? Any bias?

### Red Flags
- No date or very old date
- Unknown author
- No sources or references
- Contradicts official docs
- Marketing content
- Obvious errors in examples

## Research Process

### Step 1: Initial Survey
```
1. Start with official documentation
2. Identify key concepts and terminology
3. Note any version-specific information
4. List topics needing deeper research
```

### Step 2: Deep Dive
```
1. Search for each topic specifically
2. Gather multiple sources
3. Cross-reference claims
4. Document contradictions
```

### Step 3: Verification
```
1. Test all code examples
2. Verify claims against official docs
3. Check for version compatibility
4. Note any caveats or limitations
```

### Step 4: Synthesis
```
1. Compile verified information
2. Organize by chapter/topic
3. Flag uncertain areas
4. Prepare for writer handoff
```

## Code Example Verification

### Testing Checklist
- [ ] Code compiles/runs without errors
- [ ] Output matches description
- [ ] Works with stated versions
- [ ] Dependencies are documented
- [ ] Edge cases are handled
- [ ] Error handling is appropriate

### Version Documentation
```yaml
code_example:
  language: "Python"
  version: "3.11+"
  dependencies:
    - name: "requests"
      version: "2.31.0"
  tested_on: "2024-01-15"
  tested_by: "researcher-agent"
```

## Citation Format

### For Official Documentation
```
[{Project} Documentation: {Topic}]({URL})
Version: {version}
Accessed: {date}
```

### For Books
```
{Author}. "{Title}". {Publisher}, {Year}. Chapter {N}.
```

### For Blog Posts/Articles
```
{Author}. "{Title}". {Site/Publication}, {Date}.
URL: {URL}
Accessed: {date}
```

## Research Notes Template

```markdown
# Research Notes: {Chapter/Topic}

## Summary
{Brief overview of findings}

## Key Concepts

### {Concept 1}
**Definition:** {definition}
**Source:** {source with URL}
**Verified:** Yes/No
**Notes:** {any caveats or additional context}

### {Concept 2}
[...]

## Code Examples

### Example 1: {Description}
**Source:** {where found}
**Tested:** Yes/No
**Result:** Pass/Fail
**Version:** {language/framework version}

```{language}
{code}
```

**Notes:** {any issues or modifications needed}

## Best Practices
(from authoritative sources)

1. {Practice 1} - Source: {source}
2. {Practice 2} - Source: {source}

## Common Mistakes
(documented pitfalls)

1. {Mistake 1} - Why it's wrong: {explanation}
2. {Mistake 2} - Why it's wrong: {explanation}

## Conflicting Information
(where sources disagree)

### {Topic of conflict}
- Source A says: {claim}
- Source B says: {different claim}
- Resolution: {how to handle}

## Open Questions
(things still unclear)

1. {Question 1}
2. {Question 2}

## References
1. [{Title}]({URL}) - {description}
2. [{Title}]({URL}) - {description}
```

## Handling Outdated Information

### Signs of Outdated Content
- Uses deprecated methods/syntax
- References old version numbers
- Links are broken
- Conflicts with current official docs

### Documentation Approach
```
- Note the original source date
- Verify against current documentation
- Document what has changed
- Provide updated alternative if needed
```

## Research Handoff

### What to Provide to Writer
1. Organized research notes by chapter
2. Verified code examples
3. Authoritative source list
4. Known limitations/caveats
5. Open questions flagged
6. Suggested content approach
