# Review Checklist

Comprehensive checklist for technical review.

## Technical Accuracy Review

### Code Verification
- [ ] All code examples compile/run without errors
- [ ] Output matches what's described in text
- [ ] Version requirements are clearly stated
- [ ] Dependencies are documented
- [ ] Error handling is appropriate
- [ ] Security best practices followed

### Concept Verification
- [ ] Technical claims are accurate
- [ ] Terminology is correct
- [ ] Best practices are current
- [ ] No deprecated methods used (unless noted)
- [ ] Edge cases are addressed

### Source Verification
- [ ] Claims backed by authoritative sources
- [ ] URLs are working
- [ ] Information is current
- [ ] No copyright issues

## Learning Progression Review

### Prerequisites
- [ ] Prerequisites clearly stated
- [ ] Prerequisites are sufficient
- [ ] Earlier chapters prepare for later ones
- [ ] No assumed knowledge beyond prerequisites

### Concept Flow
- [ ] Simple concepts come before complex
- [ ] New concepts build on previous ones
- [ ] Difficulty increases gradually
- [ ] No sudden jumps in complexity

### Completeness
- [ ] All learning objectives covered
- [ ] No unexplained concepts
- [ ] All referenced topics explained
- [ ] No dangling references

## Exercise Review

### Exercise Quality
- [ ] Instructions are clear
- [ ] Difficulty is appropriate
- [ ] Time estimates reasonable
- [ ] Solutions are correct
- [ ] Solutions are explained

### Skill Coverage
- [ ] Exercises cover key concepts
- [ ] Variety of exercise types
- [ ] Progressive difficulty
- [ ] Real-world relevance

## Code Quality Review

### Readability
- [ ] Code is self-documenting
- [ ] Comments explain "why" not "what"
- [ ] Naming is clear and consistent
- [ ] Formatting is consistent

### Best Practices
- [ ] Follows language conventions
- [ ] No anti-patterns
- [ ] Proper error handling
- [ ] Secure coding practices

### Runability
- [ ] Complete, runnable examples
- [ ] No missing imports
- [ ] No missing setup steps
- [ ] Works on stated versions

## Quality Gates

### Gate 1: Technical Accuracy
**Criteria:**
- All code tested and working
- All claims verified
- No factual errors

**Pass if:** Zero critical technical errors

### Gate 2: Completeness
**Criteria:**
- All learning objectives covered
- All exercises have solutions
- No incomplete sections

**Pass if:** 100% content complete

### Gate 3: Learning Quality
**Criteria:**
- Logical progression
- Clear explanations
- Appropriate difficulty

**Pass if:** Score >= 80/100 on learning assessment

### Gate 4: Code Quality
**Criteria:**
- All examples work
- Follow best practices
- Properly documented

**Pass if:** All code examples pass validation

## Scoring Rubric

### Technical Accuracy (30 points)
| Score | Criteria |
|-------|----------|
| 30 | Zero errors, all verified |
| 20-29 | Minor errors only |
| 10-19 | Some major errors |
| 0-9 | Critical errors present |

### Learning Quality (25 points)
| Score | Criteria |
|-------|----------|
| 25 | Excellent flow and clarity |
| 20-24 | Good with minor issues |
| 10-19 | Some gaps or confusion |
| 0-9 | Major learning barriers |

### Completeness (20 points)
| Score | Criteria |
|-------|----------|
| 20 | 100% complete |
| 15-19 | 90-99% complete |
| 10-14 | 80-89% complete |
| 0-9 | Below 80% complete |

### Code Quality (15 points)
| Score | Criteria |
|-------|----------|
| 15 | All examples excellent |
| 10-14 | Minor issues |
| 5-9 | Some examples problematic |
| 0-4 | Many issues |

### Exercise Quality (10 points)
| Score | Criteria |
|-------|----------|
| 10 | Excellent exercises |
| 7-9 | Good with minor issues |
| 4-6 | Adequate |
| 0-3 | Needs significant work |

### Total Score Interpretation
| Score | Grade | Recommendation |
|-------|-------|----------------|
| 90-100 | A | Ready for publish |
| 80-89 | B | Minor revisions |
| 70-79 | C | Moderate revisions |
| 60-69 | D | Major revisions |
| <60 | F | Needs rewrite |

## Issue Severity Levels

### Critical
Must fix before publication.
- Incorrect code that won't work
- Factual errors that mislead
- Security vulnerabilities
- Missing essential content

### Major
Should be fixed.
- Confusing explanations
- Incomplete examples
- Outdated information
- Missing context

### Minor
Nice to fix.
- Typos in prose
- Style inconsistencies
- Slightly unclear wording
- Minor formatting issues

### Note
For consideration.
- Suggestions for improvement
- Alternative approaches
- Enhancement ideas
- Future considerations

## Review Report Template

```markdown
# Review Report: {Chapter/Book Title}

## Summary
- **Reviewer:** reviewer-agent
- **Date:** {date}
- **Quality Score:** {X}/100
- **Grade:** {A-F}
- **Status:** {Pass/Needs Revision/Fail}

## Quality Gate Status
| Gate | Status | Notes |
|------|--------|-------|
| Technical Accuracy | ✓/✗ | {notes} |
| Completeness | ✓/✗ | {notes} |
| Learning Quality | ✓/✗ | {notes} |
| Code Quality | ✓/✗ | {notes} |

## Issues Found

### Critical ({count})
1. **{Issue Title}**
   - Location: {chapter/section/line}
   - Description: {what's wrong}
   - Impact: {why it matters}
   - Suggested Fix: {how to fix}

### Major ({count})
[Same format]

### Minor ({count})
[Same format]

## Code Validation Results
| Example | Location | Tested | Result | Notes |
|---------|----------|--------|--------|-------|
| {name} | {loc} | ✓/✗ | Pass/Fail | {notes} |

## Recommendations
1. {recommendation}
2. {recommendation}

## Next Steps
- [ ] {action item}
- [ ] {action item}
```
