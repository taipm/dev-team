# Fact Extraction Rules

> Quy tắc nghiêm ngặt cho việc trích xuất facts từ code

## The Golden Rule

```
╔═══════════════════════════════════════════════════════════════════════╗
║                                                                        ║
║   IF YOU DIDN'T SEE IT IN THE CODE, DON'T CLAIM IT                    ║
║                                                                        ║
║   IF YOU CLAIM IT, SHOW THE CODE                                       ║
║                                                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
```

## Fact Types

### 1. Structure Facts
**What:** How code is organized

```yaml
# Example
type: structure
content: "UserService được định nghĩa tại internal/service/"
evidence:
  file: internal/service/user.go
  lines: 10-35
  snippet: |
    type UserService struct {
        repo UserRepository
        cache Cache
    }
```

### 2. Behavior Facts
**What:** What code does

```yaml
# Example
type: behavior
content: "Login function validates credentials rồi tạo JWT token"
evidence:
  file: internal/auth/login.go
  lines: 45-67
  snippet: |
    func (s *AuthService) Login(ctx context.Context, creds Credentials) (*Token, error) {
        if err := s.validateCredentials(creds); err != nil {
            return nil, err
        }
        return s.generateJWT(creds.UserID)
    }
```

### 3. Relationship Facts
**What:** How components connect

```yaml
# Example
type: relationship
content: "AuthService depends on UserRepository"
evidence:
  file: internal/auth/service.go
  lines: 12-15
  snippet: |
    type AuthService struct {
        userRepo UserRepository  // <-- dependency
    }
```

### 4. Pattern Facts
**What:** Recurring structures/conventions

```yaml
# Example
type: pattern
content: "Repository pattern được sử dụng cho data access"
evidence:
  - file: internal/user/repository.go
    snippet: "type UserRepository interface {...}"
  - file: internal/order/repository.go
    snippet: "type OrderRepository interface {...}"
  - file: internal/product/repository.go
    snippet: "type ProductRepository interface {...}"
```

## Extraction Process

### Step 1: Search
```yaml
input: question + search_hints

actions:
  - Glob for file patterns
  - Grep for keywords
  - List matching files

output: file_list[]
```

### Step 2: Read
```yaml
input: file_list[]

actions:
  - Read each relevant file
  - Focus on sections matching question
  - Note line numbers

output: file_contents[]
```

### Step 3: Extract
```yaml
input: file_contents[]

actions:
  - Identify facts relevant to question
  - Copy exact code snippets
  - Record file:line references
  - Classify fact type

output: facts[]
```

### Step 4: Validate
```yaml
input: facts[]

validation:
  - Evidence exists? → YES/NO
  - Line numbers correct? → Verify
  - Snippet matches source? → Check
  - No assumption words? → Scan

output: validated_facts[]
```

## Forbidden Patterns

### Never Use These Words
| Word | Why Forbidden | Alternative |
|------|---------------|-------------|
| probably | Indicates uncertainty | "NOT FOUND" or remove |
| likely | Indicates assumption | State fact or omit |
| maybe | Indicates guess | Verify or omit |
| seems | Indicates interpretation | Quote code directly |
| I think | Indicates opinion | Show evidence |
| should be | Indicates expectation | Check actual code |
| typically | Indicates generalization | Show specific instance |

### Never Make These Claims

```
❌ "This service handles authentication"
   → Without seeing auth code

❌ "The database is PostgreSQL"
   → Without seeing connection string

❌ "Tests use Jest framework"
   → Without seeing jest.config or test files

❌ "This follows clean architecture"
   → Without mapping all layers with evidence
```

### Always Do These Instead

```
✓ "auth.go:15-45 defines AuthService with Login(), Logout(), ValidateToken()"
   → Specific, with evidence

✓ "config.yaml:12 contains DATABASE_URL=postgres://..."
   → Direct quote from file

✓ "jest.config.js exists at project root with testMatch: ['**/*.test.ts']"
   → Verified file existence

✓ "Found 4 layers: cmd/ (entry), internal/service/ (business),
   internal/repository/ (data), pkg/ (shared) - matching clean architecture"
   → Evidence-backed conclusion
```

## Confidence Levels

### HIGH Confidence
- Direct code evidence
- Unambiguous meaning
- Verified file/line

```yaml
confidence: high
when:
  - Found exact code implementation
  - File and line verified
  - No interpretation needed
```

### MEDIUM Confidence
- Indirect evidence
- Some interpretation needed
- Config-based inference

```yaml
confidence: medium
when:
  - Found import but not usage
  - Found config but not implementation
  - Pattern partially matches
```

### NO CLAIM (Not "LOW")
- Insufficient evidence
- Too much interpretation
- Cannot verify

```yaml
# Don't make the claim at all
# Instead:
response: "NOT FOUND IN CODE SCANNED"
searched:
  - patterns tried
  - files checked
  - keywords searched
```

## Evidence Template

```markdown
## Fact: {fact_id}

**Question:** {question being answered}
**Type:** {structure|behavior|relationship|pattern}

**Finding:**
{Clear description of what was found}

**Evidence:**
```
File: {relative/path}
Lines: {start}-{end}

{actual code snippet}
```

**Confidence:** {HIGH|MEDIUM}
**Verified:** {timestamp}
```

## Common Mistakes to Avoid

1. **Paraphrasing instead of quoting**
   - Bad: "It validates input"
   - Good: `validator.go:23: if err := validate(input); err != nil`

2. **Generalizing from single instance**
   - Bad: "All services use dependency injection"
   - Good: "Found DI in UserService (user.go:10), OrderService (order.go:12)"

3. **Inferring behavior from names**
   - Bad: "handleAuth() handles authentication"
   - Good: "handleAuth() at auth.go:45 calls validateToken() and returns user"

4. **Claiming absence without thorough search**
   - Bad: "There are no tests"
   - Good: "Searched *_test.go, *_spec.*, test/* - 0 matches found"
