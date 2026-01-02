# Technical Writing Fundamentals

Core principles for writing effective technical content.

## The 5 Cs of Technical Writing

### 1. Clear
- Use simple, direct language
- One idea per sentence
- Active voice preferred
- Define jargon before using it

### 2. Concise
- Remove unnecessary words
- Avoid redundancy
- Get to the point quickly
- Every word should earn its place

### 3. Correct
- Verify all technical claims
- Test all code examples
- Use accurate terminology
- Cite authoritative sources

### 4. Complete
- Cover all necessary topics
- Include all steps in procedures
- Provide context and background
- Don't assume knowledge not in prerequisites

### 5. Consistent
- Use same terminology throughout
- Follow style guide
- Maintain consistent voice
- Use parallel structure

## Audience-First Approach

### Know Your Reader
- **Skill Level:** Beginner / Intermediate / Advanced
- **Goals:** What do they want to achieve?
- **Pain Points:** What frustrates them?
- **Time:** How much can they invest?

### Writing for Learning
- Start with the "why" before the "how"
- Build on what reader already knows
- Use analogies to explain new concepts
- Provide hands-on practice opportunities

## Content Structure

### Chapter Structure
```
1. Hook - Why this matters
2. Learning Objectives - What they'll learn
3. Prerequisites - What they need to know
4. Main Content - Core material
5. Exercises - Practice what they learned
6. Summary - Key takeaways
7. Next Steps - Where to go from here
```

### Section Structure
```
1. Introduction - Context and overview
2. Explanation - The concept
3. Example - Show it in action
4. Practice - Let reader try it
5. Recap - Reinforce key points
```

## Code Examples Best Practices

### Characteristics of Good Code Examples
- **Complete:** Can be run as-is
- **Minimal:** No unnecessary complexity
- **Commented:** Explain non-obvious parts
- **Progressive:** Build from simple to complex

### Code Presentation
```markdown
```python
# Clear comment explaining what this does
def example_function(param):
    """Docstring explaining purpose."""
    result = param * 2  # Inline comment for clarity
    return result

# How to use it
output = example_function(5)  # Returns 10
```
```

## Voice and Tone

### Recommended Voice
- Friendly but professional
- Conversational, like explaining to a colleague
- Encouraging but not patronizing
- Confident but humble

### Words to Use
- "Let's explore..."
- "Consider this approach..."
- "Here's what's happening..."
- "You might wonder..."

### Words to Avoid
- "Simply..." (dismissive of difficulty)
- "Obviously..." (nothing is obvious to learners)
- "Just..." (minimizes complexity)
- "Clearly..." (assumes understanding)

## Formatting Guidelines

### Headings
- Use H1 for chapter titles only
- H2 for major sections
- H3 for subsections
- Don't skip levels (H2 → H4)

### Lists
- Use numbered lists for sequences/steps
- Use bulleted lists for non-sequential items
- Keep parallel structure within lists
- Limit list items to reasonable length

### Emphasis
- **Bold** for key terms first introduction
- `Code style` for code, commands, file names
- *Italics* for emphasis (use sparingly)

### Code Blocks
- Always specify language for syntax highlighting
- Keep lines under 80 characters when possible
- Use consistent indentation (2 or 4 spaces)
- Include expected output when relevant

## Quality Metrics

### Good Technical Content Should
- Be technically accurate (verified)
- Be up-to-date (current versions)
- Be well-organized (logical flow)
- Be engaging (holds attention)
- Be practical (applicable immediately)

### Red Flags to Avoid
- Outdated information
- Untested code
- Unclear explanations
- Missing context
- Inconsistent terminology
