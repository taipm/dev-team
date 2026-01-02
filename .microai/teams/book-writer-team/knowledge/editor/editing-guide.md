# Editing Guide

Guidelines for editing technical content.

## Grammar Essentials

### Subject-Verb Agreement
```
Wrong: The list of items are empty.
Right: The list of items is empty.

Wrong: Each of the functions require testing.
Right: Each of the functions requires testing.
```

### Tense Consistency
```
Wrong: The function returns a value and logged it.
Right: The function returns a value and logs it.

Wrong: First, create the file. Then you will add content.
Right: First, create the file. Then add content.
```

### Active vs Passive Voice
```
Passive: The configuration file is loaded by the system.
Active: The system loads the configuration file.

Passive: Errors can be handled using try-catch.
Active: Handle errors using try-catch.
```

## Technical Writing Style

### Terminology Consistency
Create and maintain a terminology table:

| Use | Don't Use |
|-----|-----------|
| JavaScript | Javascript, JS |
| Node.js | NodeJS, node |
| API | api, Api |
| ID | id, Id |
| URL | url, Url |
| database | data base, DB |

### Capitalization Rules
- Product names: as officially written (PostgreSQL, macOS)
- Programming terms: language standard (boolean, null)
- File extensions: lowercase (.js, .py, .md)
- Commands: as typed (npm install, git push)

### Abbreviations
- Define on first use: "Application Programming Interface (API)"
- Use abbreviated form after: "The API returns..."
- Common terms may skip definition: HTML, CSS, JSON

## Sentence Structure

### Avoiding Wordiness
```
Wordy: Due to the fact that the server is down...
Better: Because the server is down...

Wordy: In order to start the application...
Better: To start the application...

Wordy: At this point in time...
Better: Now...
```

### Removing Filler Words
```
With filler: Actually, you can just use a loop here.
Without: Use a loop here.

With filler: Basically, the function returns true.
Without: The function returns true.
```

### Parallel Structure
```
Wrong: The system will start, running, and then stops.
Right: The system will start, run, and then stop.

Wrong: Configure the server, setup the database, and deployment.
Right: Configure the server, set up the database, and deploy.
```

## Code Block Formatting

### Language Hints
Always specify:
```python
# Python code here
```
```javascript
// JavaScript code here
```
```bash
# Shell commands here
```
```yaml
# YAML configuration here
```

### Consistent Indentation
- Pick 2 or 4 spaces, stick with it
- Never mix tabs and spaces
- Configure editor to convert tabs

### Line Length
- Max 80-100 characters per line
- Break long lines logically:
```python
result = some_function(
    first_argument,
    second_argument,
    third_argument
)
```

### Comments
- Keep inline comments brief
- Use block comments for explanations
- Remove debug comments
- Ensure comments match code

## Formatting Consistency

### Headers
```
# Chapter Title (H1) - One per file
## Major Section (H2)
### Subsection (H3)
#### Minor Heading (H4) - Use sparingly
```

### Lists
Bulleted (unordered):
```markdown
- First item
- Second item
- Third item
```

Numbered (ordered):
```markdown
1. First step
2. Second step
3. Third step
```

### Emphasis
- **Bold** for important terms (first use)
- `Code` for code, commands, file names
- *Italics* for emphasis (use sparingly)
- Do not combine (**_avoid this_**)

### Links
```markdown
[Descriptive text](URL)

Wrong: Click [here](URL)
Right: See the [installation guide](URL)
```

## Common Mistakes to Fix

### Word Confusion
| Confused | Meaning |
|----------|---------|
| affect/effect | affect = verb, effect = noun |
| its/it's | its = possessive, it's = it is |
| their/there/they're | their = possessive, there = place |
| then/than | then = time, than = comparison |

### Technical Mistakes
| Wrong | Right |
|-------|-------|
| Seperate | Separate |
| Occured | Occurred |
| Dependancy | Dependency |
| Asyncronous | Asynchronous |
| Recieve | Receive |

### Punctuation
- Comma before "and" in lists of 3+ (Oxford comma)
- Periods inside quotation marks (US style)
- One space after periods
- Hyphens for compound modifiers (well-known pattern)

## Editing Checklist

### First Pass: Correctness
- [ ] Spelling errors fixed
- [ ] Grammar errors fixed
- [ ] Code syntax correct
- [ ] Facts verified

### Second Pass: Clarity
- [ ] Complex sentences simplified
- [ ] Jargon defined
- [ ] Transitions smooth
- [ ] Flow logical

### Third Pass: Style
- [ ] Terminology consistent
- [ ] Voice consistent
- [ ] Formatting uniform
- [ ] Length appropriate

### Final Pass: Polish
- [ ] Headers make sense standalone
- [ ] Lists parallel
- [ ] Code blocks complete
- [ ] Links working

## Edit Tracking

### Comment Format
For tracking changes:
```
[EDIT: Changed "X" to "Y" - reason]
[QUERY: Is this correct?]
[SUGGESTION: Consider rephrasing...]
[STET: Keep original - reason]
```

### Severity Levels
| Level | Description | Action |
|-------|-------------|--------|
| Critical | Error, will confuse readers | Must fix |
| Major | Unclear or inconsistent | Should fix |
| Minor | Style/preference issue | Nice to fix |
| Note | Observation | Consider |

## Style Guide Template

Create for each book:
```markdown
# {Book Title} Style Guide

## Terminology
- API (not api)
- JavaScript (not JS)
- [Other terms...]

## Code Style
- 4 spaces indentation
- Max 80 char line length
- [Other rules...]

## Voice
- Second person ("you")
- Active voice preferred
- [Other guidelines...]

## Formatting
- Oxford comma: Yes
- [Other rules...]
```
