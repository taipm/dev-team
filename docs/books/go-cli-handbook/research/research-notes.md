# Research Notes: Building CLI Applications with Go

## Research Summary

| Metric | Value |
|--------|-------|
| **Date** | 2026-01-02 |
| **Sources Found** | 15+ |
| **Code Examples** | 12 |
| **Confidence Level** | High |

---

## Chapter 1-2: Foundations & Arguments

### Go CLI Development Overview

**Why Go for CLI Tools:**
- Single static binary (no runtime dependencies)
- Fast startup time
- Cross-compilation built-in
- Strong standard library

**Standard Library Packages:**
- `flag` - Basic flag parsing
- `os` - Environment, args, exit codes
- `os/exec` - Running external commands
- `io` - Reader/Writer interfaces

**Verified Code Example:**
```go
package main

import (
    "flag"
    "fmt"
    "os"
)

func main() {
    name := flag.String("name", "World", "Name to greet")
    flag.Parse()

    fmt.Printf("Hello, %s!\n", *name)
    os.Exit(0)
}
```

---

## Chapter 3: Cobra Framework

### Current Status
- **Latest Version:** v1.8+ (December 2025)
- **Adoption:** 184,322+ projects
- **Major Users:** Kubernetes, Docker, GitHub CLI, Hugo
- **Source:** [GitHub - spf13/cobra](https://github.com/spf13/cobra)
- **Docs:** [cobra.dev](https://cobra.dev/)

### Key Features (2025)
- Subcommand-based architecture
- POSIX-compliant flags (short & long)
- Automatic shell completion (bash, zsh, fish, PowerShell)
- Auto-generated man pages
- Active Help system (real-time hints during tab completion)
- Seamless Viper integration

### Verified Code Example
```go
package main

import (
    "fmt"
    "github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
    Use:   "myapp",
    Short: "My CLI application",
    Run: func(cmd *cobra.Command, args []string) {
        fmt.Println("Hello from root command")
    },
}

func init() {
    rootCmd.AddCommand(&cobra.Command{
        Use:   "serve",
        Short: "Start the server",
        Run: func(cmd *cobra.Command, args []string) {
            fmt.Println("Starting server...")
        },
    })
}

func main() {
    rootCmd.Execute()
}
```

### Best Practices
- Use cobra-cli generator for scaffolding
- Design commands as actions, args as things, flags as modifiers
- Implement pre/post-run hooks for setup/cleanup
- Use persistent flags for global options

**References:**
- [Cobra Developer Guide](https://cobra.dev/)
- [JetBrains Go CLI Tutorial](https://www.jetbrains.com/guide/go/tutorials/cli-apps-go-cobra/creating_cli/)
- [Build CLI Tools with Cobra 2025](https://codezup.com/create-cli-cobra-go-guide/)

---

## Chapter 5: Terminal UI (Bubble Tea)

### Current Status
- **Framework:** Elm Architecture-based
- **Adoption:** 10,000+ dependent repositories
- **Major Users:** Microsoft Azure, Cockroach Labs, NVIDIA
- **Source:** [GitHub - charmbracelet/bubbletea](https://github.com/charmbracelet/bubbletea)

### Architecture (MVU Pattern)
- **Model:** Application state
- **Update:** Handle events, update state
- **View:** Render UI based on state

### Ecosystem
| Library | Purpose |
|---------|---------|
| Bubbles | Pre-built components (inputs, tables, spinners) |
| Lip Gloss | Styling and layout |
| Harmonica | Spring animations |
| BubbleZone | Mouse event tracking |
| Glamour | Markdown rendering |

### Verified Code Example
```go
package main

import (
    "fmt"
    tea "github.com/charmbracelet/bubbletea"
)

type Model struct {
    message string
}

func (m Model) Init() tea.Cmd {
    return nil
}

func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
    switch msg.(type) {
    case tea.KeyMsg:
        return m, tea.Quit
    }
    return m, nil
}

func (m Model) View() string {
    return fmt.Sprintf("Hello, %s!\nPress any key to exit.\n", m.message)
}

func main() {
    p := tea.NewProgram(Model{message: "Bubble Tea"})
    p.Run()
}
```

**References:**
- [Bubble Tea GitHub](https://github.com/charmbracelet/bubbletea)
- [Bubble Tea Tutorial](https://github.com/charmbracelet/bubbletea/tree/master/tutorials)
- [Building Terminal UI with Bubble Tea](https://sngeth.com/go/terminal/ui/bubble-tea/2025/08/17/building-terminal-ui-with-bubble-tea/)

---

## Chapter 6: Configuration (Viper)

### Current Status
- **Integration:** Seamless Cobra binding
- **Source:** [GitHub - spf13/viper](https://github.com/spf13/viper)

### Supported Formats
JSON, TOML, YAML, HCL, INI, envfile, Java Properties

### Key Features
- Environment variable binding with prefix
- Live reloading with change callbacks
- Flag binding with pflag
- Struct unmarshaling

### Verified Code Example
```go
package main

import (
    "fmt"
    "github.com/spf13/viper"
)

func main() {
    viper.SetConfigName("config")
    viper.SetConfigType("yaml")
    viper.AddConfigPath(".")

    viper.SetEnvPrefix("MYAPP")
    viper.AutomaticEnv()

    if err := viper.ReadInConfig(); err != nil {
        fmt.Println("No config file found, using defaults")
    }

    fmt.Println("Database:", viper.GetString("database.host"))
}
```

### Alternative: Koanf
For smaller binaries and fewer dependencies, consider [koanf](https://github.com/knadh/koanf)

---

## Chapter 7: Error Handling

### Best Practices (2025)

1. **Log at Boundaries:** Log errors at entry/exit points, not in business logic
2. **Error Wrapping:** Use `fmt.Errorf("context: %w", err)`
3. **Modern Inspection:** Use `errors.Is()` and `errors.As()`
4. **Human-Readable Messages:** Tailor for end users
5. **Early Returns:** Avoid deeply nested error handling

### Verified Pattern
```go
if err := operation(); err != nil {
    return fmt.Errorf("operation failed at stage X: %w", err)
}
```

### Exit Codes
- 0: Success
- 1: General error
- 2: Misuse of command

---

## Chapter 8: Testing

### Approaches
- Unit tests for command logic
- Integration tests for full commands
- Table-driven tests for flag combinations
- Golden file testing for output verification

---

## Chapter 10: Distribution (GoReleaser)

### Current Status
- **Latest Version:** 2.0.0 (2024)
- **Languages:** Go, Rust, Zig, Python, TypeScript
- **Source:** [goreleaser.com](https://goreleaser.com/)

### Key Features
- Multi-platform binary compilation
- Package management (Homebrew, APK, Deb, RPM)
- Container image building
- Code signing and notarization
- SBOM generation

### Basic Configuration
```yaml
version: 2
project_name: myapp

builds:
  - env:
      - CGO_ENABLED=0
    goos:
      - linux
      - darwin
      - windows
    goarch:
      - amd64
      - arm64

archives:
  - format: tar.gz
    format_overrides:
      - goos: windows
        format: zip
```

### Cross-Compilation Best Practices

**Without CGO (Recommended):**
```bash
GOOS=linux GOARCH=amd64 go build -o app-linux-amd64
GOOS=darwin GOARCH=arm64 go build -o app-darwin-arm64
```

**With CGO (Using Zig):**
```bash
CGO_ENABLED=1 GOOS=linux GOARCH=amd64 \
  CC="zig cc -target x86_64-linux" \
  go build
```

---

## Go Language Features (2025)

### Go 1.21
- `log/slog`: Structured logging (standard library)
- `slices`, `maps`, `cmp` packages

### Go 1.22
- Loop variable capture fixed
- Integer range iteration: `for i := range n {}`

### Go 1.23
- Iterator functions for range
- GODEBUG directive in go.mod

### Go 1.24
- Generic type aliases
- Tool directives in go.mod
- `os.Root` for restricted filesystem
- Swiss Tables map implementation

---

## Recommended Stack (2025)

| Component | Library |
|-----------|---------|
| CLI Framework | Cobra |
| Configuration | Viper or Koanf |
| Logging | log/slog |
| Terminal UI | Bubble Tea + Lip Gloss |
| Distribution | GoReleaser |
| Testing | testing + testify |

---

## References

### Official Documentation
- [Cobra CLI Framework](https://cobra.dev/)
- [GoReleaser](https://goreleaser.com/)
- [Bubble Tea](https://github.com/charmbracelet/bubbletea)
- [Go Release History](https://go.dev/doc/devel/release)

### Tutorials
- [Building CLI Apps with Cobra & Viper](https://www.glukhov.org/post/2025/11/go-cli-applications-with-cobra-and-viper/)
- [JetBrains CLI Tutorial](https://www.jetbrains.com/guide/go/tutorials/cli-apps-go-cobra/creating_cli/)
- [Bubble Tea Deep Dive](https://sngeth.com/go/terminal/ui/bubble-tea/2025/08/17/building-terminal-ui-with-bubble-tea/)
- [Terminal UI with Bubble Tea](https://packagemain.tech/p/terminal-ui-bubble-tea)
