# Writing Patterns

Patterns and techniques for effective technical writing.

## Opening Patterns

### The Problem Hook
Start by presenting a problem the reader faces.
```
"You've just deployed your application, and users are reporting
it's slow. Where do you even start looking?"
```

### The Promise Hook
State what the reader will be able to do.
```
"By the end of this chapter, you'll be able to profile your
application and identify performance bottlenecks in minutes."
```

### The Story Hook
Start with a relatable scenario.
```
"Imagine it's Friday evening. You're about to leave when an
alert fires: database connections maxed out. This chapter
will ensure you know exactly what to do."
```

### The Question Hook
Pose an intriguing question.
```
"Why do some APIs respond in milliseconds while others take
seconds? The answer might surprise you."
```

## Explanation Patterns

### Concept-Example-Practice
```
1. Explain the concept abstractly
2. Show a concrete example
3. Let reader practice with exercise
```

### Building Blocks
```
1. Start with simplest possible version
2. Add one feature at a time
3. Show complete version at end
```

### Compare and Contrast
```
1. Show the old/wrong way
2. Explain problems with it
3. Show the new/right way
4. Explain the improvement
```

### Before and After
```
1. Show code before optimization/refactor
2. Walk through changes
3. Show final result
4. Explain benefits
```

## Code Explanation Patterns

### Line-by-Line Walkthrough
```python
def process_data(items):
    results = []           # Create empty list for results
    for item in items:     # Iterate through each item
        if item.valid:     # Check if item is valid
            results.append(item.process())  # Process and store
    return results         # Return all processed items
```

### Numbered Callouts
```python
def authenticate(user, password):
    hash = compute_hash(password)  # (1)
    stored = get_stored_hash(user) # (2)
    return hash == stored          # (3)
```
1. Convert password to secure hash
2. Retrieve stored hash from database
3. Compare hashes for match

### Progressive Disclosure
```python
# Version 1: Basic
def greet():
    print("Hello")

# Version 2: With name
def greet(name):
    print(f"Hello, {name}")

# Version 3: With default
def greet(name="World"):
    print(f"Hello, {name}")

# Version 4: Production-ready
def greet(name: str = "World") -> str:
    """Return a greeting message."""
    return f"Hello, {name}"
```

## Transition Patterns

### Between Sections
- "Now that we understand X, let's look at Y..."
- "With this foundation, we can explore..."
- "This leads us to an important question..."
- "But what happens when...?"

### Between Concepts
- "This is similar to... but differs in..."
- "Think of it as..."
- "Another way to look at this..."
- "In contrast to what we saw earlier..."

### Between Chapters
- "In this chapter, we covered... Next, we'll..."
- "You now have the tools to... In Chapter N, we'll build on this..."
- "We've laid the groundwork. Now it's time to..."

## Exercise Patterns

### Guided Exercise
```markdown
### Exercise: Create a User Model

**Goal:** Practice creating a model with validation.

**Starting Point:**
```python
class User:
    pass
```

**Requirements:**
1. Add `name` and `email` attributes
2. Validate email contains `@`
3. Raise `ValueError` for invalid email

**Hints:**
- Use `__init__` for initialization
- Consider a separate `validate_email` method

<details>
<summary>Solution</summary>
[Code solution with explanation]
</details>
```

### Challenge Exercise
```markdown
### Challenge: Build a Cache System

**Difficulty:** Medium
**Time:** 20-30 minutes

**The Task:**
Build an in-memory cache with expiration.

**Requirements:**
- Store key-value pairs
- Set expiration time per entry
- Auto-expire old entries
- Thread-safe

**Test Cases:**
```python
cache = Cache()
cache.set("key", "value", ttl=60)  # Expires in 60s
assert cache.get("key") == "value"
# After 60 seconds...
assert cache.get("key") is None
```
```

### Refactoring Exercise
```markdown
### Exercise: Improve This Code

**The Problem:**
The following code works but has issues:

```python
def f(x):
    y = []
    for i in x:
        if i > 0:
            y.append(i * 2)
    return y
```

**Your Task:**
1. Identify 3 problems with this code
2. Refactor to fix them
3. Add type hints and docstring
```

## Warning/Note Patterns

### Warning Box
```markdown
> **Warning:** Never store passwords in plain text.
> Always use a secure hashing algorithm like bcrypt.
```

### Note Box
```markdown
> **Note:** This feature requires Python 3.10+.
> Earlier versions need to use the `typing_extensions` package.
```

### Tip Box
```markdown
> **Tip:** Use `Ctrl+C` to interrupt long-running commands
> in your terminal.
```

### Pro Tip
```markdown
> **Pro Tip:** Combine `grep` with `find` for powerful
> search: `find . -name "*.py" -exec grep "pattern" {} +`
```

## Summary Patterns

### Key Points List
```markdown
## Summary

In this chapter, you learned:

- **Concept 1:** Brief description
- **Concept 2:** Brief description
- **Concept 3:** Brief description

Key takeaway: [One sentence summary]
```

### Before/After Comparison
```markdown
## Summary

**Before this chapter:**
- You struggled with X
- Y was confusing
- Z seemed complex

**Now you can:**
- Handle X confidently
- Understand Y clearly
- Implement Z easily
```

### Checklist Summary
```markdown
## Summary Checklist

After this chapter, you should be able to:

- [ ] Create a basic X
- [ ] Configure Y settings
- [ ] Troubleshoot common Z issues
- [ ] Optimize performance of W
```

## Tone Guidelines

### Do
- "Let's explore..."
- "You might be wondering..."
- "Consider this approach..."
- "Here's a common pattern..."

### Don't
- "It's obvious that..."
- "Simply do X..."
- "Just add..."
- "Of course, you should..."

## Length Guidelines

### Sentence Length
- Aim for 15-20 words average
- Max 30 words per sentence
- Break long sentences into two

### Paragraph Length
- 3-5 sentences typical
- Max 7 sentences
- One idea per paragraph

### Section Length
- 300-600 words for explanation
- 100-300 words for examples
- Variable for code (but explain all of it)
