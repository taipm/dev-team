# Chapter 3: Using Cobra for Professional CLIs

> "Complexity is the enemy of execution."
> — Tony Robbins

## Introduction

In Chapters 1 and 2, we built CLI applications using Go's standard library. While the `flag` package is powerful, building complex applications with subcommands, shell completions, and auto-generated documentation requires significant boilerplate code.

Enter Cobra—the CLI framework that powers some of the most popular command-line tools in the world: Kubernetes (`kubectl`), Docker, GitHub CLI (`gh`), Hugo, and hundreds more. Cobra provides a battle-tested foundation for building professional-grade CLI applications with minimal effort.

This chapter introduces Cobra's architecture, teaches you to structure applications with commands and subcommands, and shows you how to leverage its powerful features like shell completions and Viper integration.

**In this chapter, you will learn:**
- Cobra's architecture and design philosophy
- How to structure applications with commands and subcommands
- Working with persistent and local flags
- Generating shell completions automatically
- Integrating with Viper for configuration management

---

## Why Cobra?

Before diving into code, let's understand why Cobra has become the de facto standard for Go CLI development.

### Industry Adoption

| Tool | Company | Stars |
|------|---------|-------|
| kubectl | Google/CNCF | 100k+ |
| docker | Docker | 68k+ |
| gh | GitHub | 35k+ |
| hugo | Hugo Authors | 72k+ |
| terraform | HashiCorp | 40k+ |
| helm | CNCF | 26k+ |

**Cobra itself has 35,000+ stars and is used in 184,000+ projects.**

### What Cobra Provides

| Feature | Standard Library | Cobra |
|---------|-----------------|-------|
| Basic flags | ✅ | ✅ |
| Subcommands | Manual | ✅ Built-in |
| Nested subcommands | Complex | ✅ Easy |
| Shell completions | ❌ | ✅ Automatic |
| Man page generation | ❌ | ✅ Automatic |
| Markdown docs | ❌ | ✅ Automatic |
| Flag grouping | ❌ | ✅ Built-in |
| Viper integration | ❌ | ✅ Seamless |
| Validation hooks | ❌ | ✅ Pre/Post Run |

---

## Getting Started with Cobra

### Installation

```bash
# Add Cobra to your project
go get -u github.com/spf13/cobra@latest

# Optional: Install the Cobra CLI generator
go install github.com/spf13/cobra-cli@latest
```

### Project Structure

A typical Cobra application follows this structure:

```
myapp/
├── cmd/
│   ├── root.go        # Root command (entry point)
│   ├── serve.go       # serve subcommand
│   ├── config.go      # config subcommand
│   └── version.go     # version subcommand
├── internal/
│   └── ...            # Business logic
├── main.go            # Minimal main function
└── go.mod
```

The `main.go` file is intentionally minimal:

```go
package main

import "myapp/cmd"

func main() {
	cmd.Execute()
}
```

All the CLI logic lives in the `cmd/` package.

---

## Your First Cobra Application

Let's build a complete task management CLI to demonstrate Cobra's features.

### Step 1: Initialize the Project

```bash
mkdir taskctl && cd taskctl
go mod init taskctl
go get github.com/spf13/cobra@latest
```

### Step 2: Create the Root Command

Create `cmd/root.go`:

```go
package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var (
	// Global flags
	verbose bool
	cfgFile string
)

// rootCmd represents the base command
var rootCmd = &cobra.Command{
	Use:   "taskctl",
	Short: "A task management CLI tool",
	Long: `taskctl is a command-line task manager that helps you
organize and track your daily tasks efficiently.

Examples:
  taskctl add "Buy groceries"
  taskctl list --status pending
  taskctl done 1`,
	// Run when no subcommand is provided
	Run: func(cmd *cobra.Command, args []string) {
		// Show help if no subcommand
		cmd.Help()
	},
}

// Execute is called by main.main()
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func init() {
	// Persistent flags are global to the application
	rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false,
		"Enable verbose output")
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "",
		"Config file (default: $HOME/.taskctl.yaml)")

	// Local flags only apply to this command
	rootCmd.Flags().BoolP("version", "V", false, "Show version information")
}
```

### Step 3: Create Subcommands

Create `cmd/add.go`:

```go
package cmd

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
)

var (
	priority string
	dueDate  string
	tags     []string
)

var addCmd = &cobra.Command{
	Use:   "add [task description]",
	Short: "Add a new task",
	Long: `Add a new task to your task list.

The task description can be provided as arguments or will be
prompted if not provided.`,
	Example: `  taskctl add "Buy groceries"
  taskctl add "Finish report" --priority high --due 2024-12-31
  taskctl add "Review PR" --tag work --tag urgent`,
	Args: cobra.MinimumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		description := strings.Join(args, " ")

		if verbose {
			fmt.Println("[DEBUG] Adding task...")
		}

		// Simulate adding task
		fmt.Printf("Added task: %s\n", description)
		if priority != "" {
			fmt.Printf("  Priority: %s\n", priority)
		}
		if dueDate != "" {
			fmt.Printf("  Due: %s\n", dueDate)
		}
		if len(tags) > 0 {
			fmt.Printf("  Tags: %v\n", tags)
		}

		return nil
	},
}

func init() {
	// Register with root command
	rootCmd.AddCommand(addCmd)

	// Local flags for this command
	addCmd.Flags().StringVarP(&priority, "priority", "p", "",
		"Task priority (low, medium, high)")
	addCmd.Flags().StringVarP(&dueDate, "due", "d", "",
		"Due date (YYYY-MM-DD)")
	addCmd.Flags().StringSliceVarP(&tags, "tag", "t", nil,
		"Add tags (can be repeated)")
}
```

Create `cmd/list.go`:

```go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var (
	statusFilter string
	showAll      bool
	limit        int
)

var listCmd = &cobra.Command{
	Use:     "list",
	Aliases: []string{"ls", "l"},
	Short:   "List tasks",
	Long:    `Display tasks with optional filtering by status.`,
	Example: `  taskctl list
  taskctl list --status pending
  taskctl list --all --limit 10`,
	Run: func(cmd *cobra.Command, args []string) {
		if verbose {
			fmt.Println("[DEBUG] Listing tasks...")
		}

		fmt.Println("Tasks:")
		fmt.Println("  1. [pending] Buy groceries")
		fmt.Println("  2. [done] Finish report")
		fmt.Println("  3. [pending] Review PR")

		if statusFilter != "" {
			fmt.Printf("\n(Filtered by status: %s)\n", statusFilter)
		}
	},
}

func init() {
	rootCmd.AddCommand(listCmd)

	listCmd.Flags().StringVarP(&statusFilter, "status", "s", "",
		"Filter by status (pending, done, all)")
	listCmd.Flags().BoolVarP(&showAll, "all", "a", false,
		"Show all tasks including archived")
	listCmd.Flags().IntVarP(&limit, "limit", "n", 10,
		"Maximum number of tasks to show")
}
```

Create `cmd/done.go`:

```go
package cmd

import (
	"fmt"
	"strconv"

	"github.com/spf13/cobra"
)

var doneCmd = &cobra.Command{
	Use:   "done [task-id]",
	Short: "Mark a task as done",
	Long:  `Mark one or more tasks as completed.`,
	Example: `  taskctl done 1
  taskctl done 1 2 3`,
	Args: cobra.MinimumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		for _, arg := range args {
			id, err := strconv.Atoi(arg)
			if err != nil {
				return fmt.Errorf("invalid task ID: %s", arg)
			}

			if verbose {
				fmt.Printf("[DEBUG] Marking task %d as done\n", id)
			}

			fmt.Printf("Task %d marked as done\n", id)
		}
		return nil
	},
}

func init() {
	rootCmd.AddCommand(doneCmd)
}
```

### Step 4: Create main.go

```go
package main

import "taskctl/cmd"

func main() {
	cmd.Execute()
}
```

### Step 5: Build and Test

```bash
# Build
go build -o taskctl

# Test commands
./taskctl --help
./taskctl add "Buy groceries" --priority high
./taskctl list --status pending
./taskctl done 1 2
./taskctl -v add "Test task"
```

---

## Cobra Command Anatomy

Understanding the `cobra.Command` struct is essential:

```go
var exampleCmd = &cobra.Command{
	// Basic identification
	Use:   "example [flags] [args]",  // Usage pattern
	Short: "One-line description",     // Shown in parent's help
	Long:  `Detailed description...`,  // Shown in command's help

	// Aliases for the command
	Aliases: []string{"ex", "e"},

	// Examples in help output
	Example: `  myapp example --flag value
  myapp ex arg1 arg2`,

	// Version (if command has its own version)
	Version: "1.0.0",

	// Argument validation
	Args: cobra.ExactArgs(2),  // or MinimumNArgs, MaximumNArgs, etc.

	// Execution functions (in order)
	PersistentPreRun:  func(cmd *cobra.Command, args []string) {},
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error { return nil },
	PreRun:            func(cmd *cobra.Command, args []string) {},
	PreRunE:           func(cmd *cobra.Command, args []string) error { return nil },
	Run:               func(cmd *cobra.Command, args []string) {},
	RunE:              func(cmd *cobra.Command, args []string) error { return nil },
	PostRun:           func(cmd *cobra.Command, args []string) {},
	PostRunE:          func(cmd *cobra.Command, args []string) error { return nil },
	PersistentPostRun: func(cmd *cobra.Command, args []string) {},
	PersistentPostRunE: func(cmd *cobra.Command, args []string) error { return nil },

	// Disable features
	SilenceUsage:  true,   // Don't show usage on error
	SilenceErrors: true,   // Don't print errors (handle manually)
	Hidden:        false,  // Hide from help output

	// Deprecation
	Deprecated: "use 'newcmd' instead",
}
```

### Argument Validators

Cobra provides built-in argument validators:

```go
// Exact number of arguments
Args: cobra.ExactArgs(2)

// Range of arguments
Args: cobra.RangeArgs(1, 3)

// Minimum arguments
Args: cobra.MinimumNArgs(1)

// Maximum arguments
Args: cobra.MaximumNArgs(5)

// No arguments allowed
Args: cobra.NoArgs

// Any number of arguments
Args: cobra.ArbitraryArgs

// Custom validation
Args: func(cmd *cobra.Command, args []string) error {
    if len(args) < 1 {
        return fmt.Errorf("requires at least one argument")
    }
    if !isValidID(args[0]) {
        return fmt.Errorf("invalid ID: %s", args[0])
    }
    return nil
}

// Validate args are in a list
Args: cobra.OnlyValidArgs
ValidArgs: []string{"start", "stop", "restart"}
```

---

## Flags Deep Dive

### Persistent vs Local Flags

```go
// Persistent flags: inherited by all subcommands
rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "Config file")

// Local flags: only for this command
serveCmd.Flags().IntVarP(&port, "port", "p", 8080, "Port to listen on")
```

### Required Flags

```go
func init() {
	serveCmd.Flags().StringVarP(&host, "host", "H", "", "Host to bind to")
	serveCmd.MarkFlagRequired("host")
}
```

### Flag Groups

```go
func init() {
	// Mutually exclusive flags
	cmd.Flags().String("json", "", "Output as JSON")
	cmd.Flags().String("yaml", "", "Output as YAML")
	cmd.MarkFlagsMutuallyExclusive("json", "yaml")

	// Required together
	cmd.Flags().String("username", "", "Username")
	cmd.Flags().String("password", "", "Password")
	cmd.MarkFlagsRequiredTogether("username", "password")

	// At least one required
	cmd.Flags().String("file", "", "Input file")
	cmd.Flags().String("url", "", "Input URL")
	cmd.MarkFlagsOneRequired("file", "url")
}
```

### Custom Flag Types with pflag

Cobra uses `pflag` (POSIX-compliant flags). Create custom types:

```go
package main

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
)

// LogLevel custom type
type LogLevel string

const (
	LogDebug LogLevel = "debug"
	LogInfo  LogLevel = "info"
	LogWarn  LogLevel = "warn"
	LogError LogLevel = "error"
)

func (l *LogLevel) String() string {
	return string(*l)
}

func (l *LogLevel) Set(v string) error {
	switch strings.ToLower(v) {
	case "debug", "info", "warn", "error":
		*l = LogLevel(strings.ToLower(v))
		return nil
	default:
		return fmt.Errorf("must be one of: debug, info, warn, error")
	}
}

func (l *LogLevel) Type() string {
	return "level"
}

var logLevel = LogLevel(LogInfo)

func init() {
	rootCmd.PersistentFlags().Var(&logLevel, "log-level",
		"Log level (debug, info, warn, error)")
}
```

---

## Command Hierarchy

### Nested Subcommands

Build deep command trees like `kubectl get pods`:

```go
// cmd/config.go
var configCmd = &cobra.Command{
	Use:   "config",
	Short: "Manage configuration",
}

func init() {
	rootCmd.AddCommand(configCmd)
}

// cmd/config_get.go
var configGetCmd = &cobra.Command{
	Use:   "get [key]",
	Short: "Get a configuration value",
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Config value for %s: ...\n", args[0])
	},
}

func init() {
	configCmd.AddCommand(configGetCmd)
}

// cmd/config_set.go
var configSetCmd = &cobra.Command{
	Use:   "set [key] [value]",
	Short: "Set a configuration value",
	Args:  cobra.ExactArgs(2),
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Setting %s = %s\n", args[0], args[1])
	},
}

func init() {
	configCmd.AddCommand(configSetCmd)
}

// cmd/config_list.go
var configListCmd = &cobra.Command{
	Use:     "list",
	Aliases: []string{"ls"},
	Short:   "List all configuration",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Configuration:")
		fmt.Println("  key1 = value1")
		fmt.Println("  key2 = value2")
	},
}

func init() {
	configCmd.AddCommand(configListCmd)
}
```

This creates:
```bash
./myapp config get database.host
./myapp config set database.host localhost
./myapp config list
./myapp config ls  # alias
```

---

## Pre/Post Run Hooks

Hooks execute in order, allowing setup and cleanup:

```go
var rootCmd = &cobra.Command{
	Use: "myapp",
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		// Runs before ANY command (including subcommands)
		// Perfect for: loading config, setting up logging, auth
		fmt.Println("[PersistentPreRun] Loading configuration...")
		return loadConfig()
	},
	PersistentPostRun: func(cmd *cobra.Command, args []string) {
		// Runs after ANY command
		// Perfect for: cleanup, metrics, saving state
		fmt.Println("[PersistentPostRun] Cleanup complete")
	},
}

var serveCmd = &cobra.Command{
	Use: "serve",
	PreRunE: func(cmd *cobra.Command, args []string) error {
		// Runs before this command only (after PersistentPreRun)
		fmt.Println("[PreRun] Validating server configuration...")
		return validateServerConfig()
	},
	RunE: func(cmd *cobra.Command, args []string) error {
		fmt.Println("[Run] Starting server...")
		return startServer()
	},
	PostRun: func(cmd *cobra.Command, args []string) {
		// Runs after this command only (before PersistentPostRun)
		fmt.Println("[PostRun] Server shutdown complete")
	},
}
```

**Execution order:**
1. `PersistentPreRun` (root)
2. `PreRun` (command)
3. `Run` (command)
4. `PostRun` (command)
5. `PersistentPostRun` (root)

---

## Shell Completions

Cobra automatically generates shell completions.

### Built-in Completion Command

Cobra adds a `completion` subcommand automatically:

```bash
# Generate bash completions
./myapp completion bash > /etc/bash_completion.d/myapp

# Generate zsh completions
./myapp completion zsh > "${fpath[1]}/_myapp"

# Generate fish completions
./myapp completion fish > ~/.config/fish/completions/myapp.fish

# Generate PowerShell completions
./myapp completion powershell > myapp.ps1
```

### Custom Completions

Add completions for flags and arguments:

```go
var statusCmd = &cobra.Command{
	Use:   "status [resource]",
	Short: "Show resource status",
	// Static valid args
	ValidArgs: []string{"pods", "services", "deployments"},
	Run: func(cmd *cobra.Command, args []string) {
		// ...
	},
}

func init() {
	// Dynamic flag completions
	statusCmd.Flags().String("namespace", "", "Kubernetes namespace")
	statusCmd.RegisterFlagCompletionFunc("namespace",
		func(cmd *cobra.Command, args []string, toComplete string) ([]string, cobra.ShellCompDirective) {
			// Return namespaces from cluster
			namespaces := getNamespaces() // Your function
			return namespaces, cobra.ShellCompDirectiveNoFileComp
		})

	// Dynamic argument completions
	rootCmd.AddCommand(statusCmd)
}

// For dynamic valid args based on context
var getCmd = &cobra.Command{
	Use: "get [resource]",
	ValidArgsFunction: func(cmd *cobra.Command, args []string, toComplete string) ([]string, cobra.ShellCompDirective) {
		if len(args) != 0 {
			return nil, cobra.ShellCompDirectiveNoFileComp
		}
		return []string{"pods", "services", "nodes"}, cobra.ShellCompDirectiveNoFileComp
	},
	Run: func(cmd *cobra.Command, args []string) {
		// ...
	},
}
```

### Shell Completion Directives

Control completion behavior:

```go
cobra.ShellCompDirectiveError           // Error occurred
cobra.ShellCompDirectiveNoSpace         // Don't add space after completion
cobra.ShellCompDirectiveNoFileComp      // Don't complete files
cobra.ShellCompDirectiveFilterFileExt   // Filter by extension
cobra.ShellCompDirectiveFilterDirs      // Only complete directories
cobra.ShellCompDirectiveKeepOrder       // Keep completion order
```

---

## Integrating with Viper

Viper provides configuration management that integrates seamlessly with Cobra.

### Basic Integration

```go
package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var cfgFile string

var rootCmd = &cobra.Command{
	Use:   "myapp",
	Short: "My application",
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		return initConfig()
	},
}

func init() {
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "",
		"config file (default: $HOME/.myapp.yaml)")

	// Bind flags to viper
	rootCmd.PersistentFlags().String("log-level", "info", "Log level")
	viper.BindPFlag("log-level", rootCmd.PersistentFlags().Lookup("log-level"))

	// Environment variable binding
	viper.SetEnvPrefix("MYAPP")
	viper.AutomaticEnv()
}

func initConfig() error {
	if cfgFile != "" {
		viper.SetConfigFile(cfgFile)
	} else {
		home, err := os.UserHomeDir()
		if err != nil {
			return err
		}

		viper.AddConfigPath(home)
		viper.AddConfigPath(".")
		viper.SetConfigName(".myapp")
		viper.SetConfigType("yaml")
	}

	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); !ok {
			return err
		}
		// Config file not found, use defaults
	} else {
		fmt.Println("Using config file:", viper.ConfigFileUsed())
	}

	return nil
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
```

### Configuration Precedence

With Viper, configuration follows this precedence (highest to lowest):

1. Explicit `Set` calls
2. Command-line flags
3. Environment variables
4. Config file
5. Default values

```go
// In your command
func init() {
	serveCmd.Flags().IntP("port", "p", 8080, "Port to listen on")
	viper.BindPFlag("server.port", serveCmd.Flags().Lookup("port"))
	viper.SetDefault("server.port", 8080)
}

// Usage
port := viper.GetInt("server.port")
```

### Config File Example

`.myapp.yaml`:
```yaml
log-level: debug

server:
  port: 3000
  host: 0.0.0.0

database:
  host: localhost
  port: 5432
  name: myapp
```

---

## Documentation Generation

Cobra can auto-generate documentation.

### Man Pages

```go
package main

import (
	"log"

	"github.com/spf13/cobra/doc"
	"myapp/cmd"
)

func main() {
	header := &doc.GenManHeader{
		Title:   "MYAPP",
		Section: "1",
	}

	err := doc.GenManTree(cmd.RootCmd, header, "./man/")
	if err != nil {
		log.Fatal(err)
	}
}
```

### Markdown Documentation

```go
package main

import (
	"log"

	"github.com/spf13/cobra/doc"
	"myapp/cmd"
)

func main() {
	err := doc.GenMarkdownTree(cmd.RootCmd, "./docs/")
	if err != nil {
		log.Fatal(err)
	}
}
```

### YAML/JSON Documentation

```go
// Generate YAML
doc.GenYamlTree(cmd.RootCmd, "./docs/")

// Generate JSON (via REST documentation)
doc.GenReSTTree(cmd.RootCmd, "./docs/")
```

---

## Exercises

### Exercise 1: File Manager CLI

**Difficulty:** Easy
**Time:** ~20 minutes

**Goal:** Build a file manager CLI with Cobra.

**Requirements:**
1. Commands: `list`, `copy`, `move`, `delete`
2. Global `--verbose` flag
3. `list` command with `--hidden` and `--long` flags

<details>
<summary>Solution</summary>

```go
// cmd/root.go
package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var verbose bool

var rootCmd = &cobra.Command{
	Use:   "fm",
	Short: "A simple file manager",
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false,
		"Enable verbose output")
}

// cmd/list.go
package cmd

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/cobra"
)

var (
	showHidden bool
	longFormat bool
)

var listCmd = &cobra.Command{
	Use:     "list [path]",
	Aliases: []string{"ls", "l"},
	Short:   "List directory contents",
	Args:    cobra.MaximumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		path := "."
		if len(args) > 0 {
			path = args[0]
		}

		if verbose {
			fmt.Printf("[DEBUG] Listing: %s\n", path)
		}

		entries, err := os.ReadDir(path)
		if err != nil {
			return err
		}

		for _, entry := range entries {
			name := entry.Name()

			// Skip hidden files unless --hidden
			if !showHidden && name[0] == '.' {
				continue
			}

			if longFormat {
				info, _ := entry.Info()
				fmt.Printf("%s %8d %s\n",
					info.Mode(),
					info.Size(),
					name)
			} else {
				fmt.Println(name)
			}
		}

		return nil
	},
}

func init() {
	rootCmd.AddCommand(listCmd)

	listCmd.Flags().BoolVarP(&showHidden, "hidden", "a", false,
		"Show hidden files")
	listCmd.Flags().BoolVarP(&longFormat, "long", "l", false,
		"Use long listing format")
}

// cmd/copy.go
package cmd

import (
	"fmt"
	"io"
	"os"

	"github.com/spf13/cobra"
)

var copyCmd = &cobra.Command{
	Use:     "copy [source] [dest]",
	Aliases: []string{"cp"},
	Short:   "Copy a file",
	Args:    cobra.ExactArgs(2),
	RunE: func(cmd *cobra.Command, args []string) error {
		src, dst := args[0], args[1]

		if verbose {
			fmt.Printf("[DEBUG] Copying %s to %s\n", src, dst)
		}

		source, err := os.Open(src)
		if err != nil {
			return err
		}
		defer source.Close()

		dest, err := os.Create(dst)
		if err != nil {
			return err
		}
		defer dest.Close()

		_, err = io.Copy(dest, source)
		if err != nil {
			return err
		}

		fmt.Printf("Copied %s to %s\n", src, dst)
		return nil
	},
}

func init() {
	rootCmd.AddCommand(copyCmd)
}
```

</details>

---

### Exercise 2: HTTP Client CLI

**Difficulty:** Medium
**Time:** ~25 minutes

**Goal:** Build an HTTP client like a simple `curl`.

**Requirements:**
1. Commands: `get`, `post`
2. Flags: `--header` (repeatable), `--output`, `--timeout`
3. `post` command with `--data` flag
4. JSON output option

<details>
<summary>Solution</summary>

```go
// cmd/root.go
package cmd

import (
	"os"
	"time"

	"github.com/spf13/cobra"
)

var (
	headers    []string
	outputFile string
	timeout    time.Duration
)

var rootCmd = &cobra.Command{
	Use:   "httpc",
	Short: "A simple HTTP client",
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.PersistentFlags().StringSliceVarP(&headers, "header", "H", nil,
		"HTTP headers (repeatable)")
	rootCmd.PersistentFlags().StringVarP(&outputFile, "output", "o", "",
		"Write output to file")
	rootCmd.PersistentFlags().DurationVarP(&timeout, "timeout", "t",
		30*time.Second, "Request timeout")
}

// cmd/get.go
package cmd

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

var getCmd = &cobra.Command{
	Use:   "get [url]",
	Short: "Make a GET request",
	Args:  cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		url := args[0]

		client := &http.Client{Timeout: timeout}

		req, err := http.NewRequest("GET", url, nil)
		if err != nil {
			return err
		}

		// Add headers
		for _, h := range headers {
			parts := strings.SplitN(h, ":", 2)
			if len(parts) == 2 {
				req.Header.Add(strings.TrimSpace(parts[0]),
					strings.TrimSpace(parts[1]))
			}
		}

		resp, err := client.Do(req)
		if err != nil {
			return err
		}
		defer resp.Body.Close()

		// Write output
		var out io.Writer = os.Stdout
		if outputFile != "" {
			f, err := os.Create(outputFile)
			if err != nil {
				return err
			}
			defer f.Close()
			out = f
		}

		fmt.Fprintf(os.Stderr, "HTTP %s\n", resp.Status)
		_, err = io.Copy(out, resp.Body)
		return err
	},
}

func init() {
	rootCmd.AddCommand(getCmd)
}

// cmd/post.go
package cmd

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

var postData string

var postCmd = &cobra.Command{
	Use:   "post [url]",
	Short: "Make a POST request",
	Args:  cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		url := args[0]

		client := &http.Client{Timeout: timeout}

		req, err := http.NewRequest("POST", url, strings.NewReader(postData))
		if err != nil {
			return err
		}

		// Add headers
		for _, h := range headers {
			parts := strings.SplitN(h, ":", 2)
			if len(parts) == 2 {
				req.Header.Add(strings.TrimSpace(parts[0]),
					strings.TrimSpace(parts[1]))
			}
		}

		// Default Content-Type for POST
		if req.Header.Get("Content-Type") == "" {
			req.Header.Set("Content-Type", "application/json")
		}

		resp, err := client.Do(req)
		if err != nil {
			return err
		}
		defer resp.Body.Close()

		var out io.Writer = os.Stdout
		if outputFile != "" {
			f, err := os.Create(outputFile)
			if err != nil {
				return err
			}
			defer f.Close()
			out = f
		}

		fmt.Fprintf(os.Stderr, "HTTP %s\n", resp.Status)
		_, err = io.Copy(out, resp.Body)
		return err
	},
}

func init() {
	rootCmd.AddCommand(postCmd)

	postCmd.Flags().StringVarP(&postData, "data", "d", "",
		"Request body data")
}
```

</details>

---

### Exercise 3: Git-like CLI

**Difficulty:** Medium
**Time:** ~30 minutes

**Goal:** Build a simplified git-like CLI demonstrating nested commands.

**Requirements:**
1. Commands: `init`, `status`, `add`, `commit`, `remote add`, `remote list`
2. `commit` with `--message` (required) and `--amend` flags
3. Nested `remote` command with `add` and `list` subcommands

<details>
<summary>Solution</summary>

```go
// cmd/root.go
package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "mygit",
	Short: "A simplified git clone",
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

// cmd/init.go
package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var initCmd = &cobra.Command{
	Use:   "init [directory]",
	Short: "Initialize a new repository",
	Args:  cobra.MaximumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		dir := "."
		if len(args) > 0 {
			dir = args[0]
		}

		// Create .mygit directory
		gitDir := dir + "/.mygit"
		if err := os.MkdirAll(gitDir, 0755); err != nil {
			return err
		}

		fmt.Printf("Initialized empty repository in %s\n", gitDir)
		return nil
	},
}

func init() {
	rootCmd.AddCommand(initCmd)
}

// cmd/status.go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var statusCmd = &cobra.Command{
	Use:   "status",
	Short: "Show repository status",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("On branch main")
		fmt.Println("")
		fmt.Println("Changes not staged for commit:")
		fmt.Println("  modified: README.md")
		fmt.Println("")
		fmt.Println("Untracked files:")
		fmt.Println("  new_file.txt")
	},
}

func init() {
	rootCmd.AddCommand(statusCmd)
}

// cmd/add.go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var addAll bool

var addCmd = &cobra.Command{
	Use:   "add [files...]",
	Short: "Add files to staging area",
	Args:  cobra.MinimumNArgs(0),
	Run: func(cmd *cobra.Command, args []string) {
		if addAll {
			fmt.Println("Adding all changes to staging area")
			return
		}

		if len(args) == 0 {
			fmt.Println("Nothing specified, nothing added.")
			return
		}

		for _, file := range args {
			fmt.Printf("Added: %s\n", file)
		}
	},
}

func init() {
	rootCmd.AddCommand(addCmd)
	addCmd.Flags().BoolVarP(&addAll, "all", "A", false, "Add all changes")
}

// cmd/commit.go
package cmd

import (
	"fmt"
	"time"

	"github.com/spf13/cobra"
)

var (
	commitMessage string
	commitAmend   bool
)

var commitCmd = &cobra.Command{
	Use:   "commit",
	Short: "Record changes to the repository",
	RunE: func(cmd *cobra.Command, args []string) error {
		if commitAmend {
			fmt.Println("Amending previous commit...")
		}

		// Generate fake commit hash
		hash := fmt.Sprintf("%x", time.Now().UnixNano())[:7]

		fmt.Printf("[main %s] %s\n", hash, commitMessage)
		fmt.Println(" 1 file changed, 10 insertions(+)")

		return nil
	},
}

func init() {
	rootCmd.AddCommand(commitCmd)

	commitCmd.Flags().StringVarP(&commitMessage, "message", "m", "",
		"Commit message")
	commitCmd.MarkFlagRequired("message")

	commitCmd.Flags().BoolVar(&commitAmend, "amend", false,
		"Amend previous commit")
}

// cmd/remote.go
package cmd

import (
	"github.com/spf13/cobra"
)

var remoteCmd = &cobra.Command{
	Use:   "remote",
	Short: "Manage remote repositories",
}

func init() {
	rootCmd.AddCommand(remoteCmd)
}

// cmd/remote_add.go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var remoteAddCmd = &cobra.Command{
	Use:   "add [name] [url]",
	Short: "Add a remote repository",
	Args:  cobra.ExactArgs(2),
	Run: func(cmd *cobra.Command, args []string) {
		name, url := args[0], args[1]
		fmt.Printf("Added remote '%s': %s\n", name, url)
	},
}

func init() {
	remoteCmd.AddCommand(remoteAddCmd)
}

// cmd/remote_list.go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var remoteVerbose bool

var remoteListCmd = &cobra.Command{
	Use:     "list",
	Aliases: []string{"ls"},
	Short:   "List remote repositories",
	Run: func(cmd *cobra.Command, args []string) {
		if remoteVerbose {
			fmt.Println("origin  https://github.com/user/repo.git (fetch)")
			fmt.Println("origin  https://github.com/user/repo.git (push)")
		} else {
			fmt.Println("origin")
		}
	},
}

func init() {
	remoteCmd.AddCommand(remoteListCmd)
	remoteListCmd.Flags().BoolVarP(&remoteVerbose, "verbose", "v", false,
		"Show remote URLs")
}
```

</details>

---

### Exercise 4: Complete Task Manager

**Difficulty:** Hard
**Time:** ~45 minutes

**Goal:** Extend the task manager with Viper integration and completions.

**Requirements:**
1. Full Viper configuration (config file, env vars, flags)
2. Shell completions for status values
3. Pre-run hooks for config loading
4. `config` subcommand with `get`, `set`, `list`
5. Persistent storage in JSON file

<details>
<summary>Solution</summary>

```go
// cmd/root.go
package cmd

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var cfgFile string

// Task represents a task
type Task struct {
	ID          int      `json:"id"`
	Description string   `json:"description"`
	Status      string   `json:"status"`
	Priority    string   `json:"priority"`
	Tags        []string `json:"tags"`
}

// TaskStore holds all tasks
type TaskStore struct {
	Tasks  []Task `json:"tasks"`
	NextID int    `json:"next_id"`
}

var store TaskStore

var rootCmd = &cobra.Command{
	Use:   "taskctl",
	Short: "A task management CLI",
	PersistentPreRunE: func(cmd *cobra.Command, args []string) error {
		return initConfig()
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "",
		"config file (default: $HOME/.taskctl.yaml)")
	rootCmd.PersistentFlags().Bool("verbose", false, "Enable verbose output")

	viper.BindPFlag("verbose", rootCmd.PersistentFlags().Lookup("verbose"))
	viper.SetEnvPrefix("TASKCTL")
	viper.AutomaticEnv()
}

func initConfig() error {
	if cfgFile != "" {
		viper.SetConfigFile(cfgFile)
	} else {
		home, _ := os.UserHomeDir()
		viper.AddConfigPath(home)
		viper.SetConfigName(".taskctl")
		viper.SetConfigType("yaml")
	}

	viper.SetDefault("data_file", filepath.Join(os.TempDir(), "tasks.json"))

	if err := viper.ReadInConfig(); err == nil {
		if viper.GetBool("verbose") {
			fmt.Println("Using config:", viper.ConfigFileUsed())
		}
	}

	return loadTasks()
}

func loadTasks() error {
	dataFile := viper.GetString("data_file")

	data, err := os.ReadFile(dataFile)
	if err != nil {
		if os.IsNotExist(err) {
			store = TaskStore{NextID: 1}
			return nil
		}
		return err
	}

	return json.Unmarshal(data, &store)
}

func saveTasks() error {
	dataFile := viper.GetString("data_file")

	data, err := json.MarshalIndent(store, "", "  ")
	if err != nil {
		return err
	}

	return os.WriteFile(dataFile, data, 0644)
}

// cmd/add.go
package cmd

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var (
	addPriority string
	addTags     []string
)

var addCmd = &cobra.Command{
	Use:   "add [description]",
	Short: "Add a new task",
	Args:  cobra.MinimumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		task := Task{
			ID:          store.NextID,
			Description: strings.Join(args, " "),
			Status:      "pending",
			Priority:    addPriority,
			Tags:        addTags,
		}

		store.Tasks = append(store.Tasks, task)
		store.NextID++

		if err := saveTasks(); err != nil {
			return err
		}

		if viper.GetBool("verbose") {
			fmt.Printf("[DEBUG] Task saved to %s\n", viper.GetString("data_file"))
		}

		fmt.Printf("Added task #%d: %s\n", task.ID, task.Description)
		return nil
	},
}

func init() {
	rootCmd.AddCommand(addCmd)

	addCmd.Flags().StringVarP(&addPriority, "priority", "p", "medium",
		"Priority (low, medium, high)")
	addCmd.RegisterFlagCompletionFunc("priority", func(cmd *cobra.Command,
		args []string, toComplete string) ([]string, cobra.ShellCompDirective) {
		return []string{"low", "medium", "high"}, cobra.ShellCompDirectiveNoFileComp
	})

	addCmd.Flags().StringSliceVarP(&addTags, "tag", "t", nil, "Add tags")
}

// cmd/list.go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var listStatus string

var listCmd = &cobra.Command{
	Use:     "list",
	Aliases: []string{"ls"},
	Short:   "List tasks",
	Run: func(cmd *cobra.Command, args []string) {
		if len(store.Tasks) == 0 {
			fmt.Println("No tasks found.")
			return
		}

		for _, task := range store.Tasks {
			if listStatus != "" && task.Status != listStatus {
				continue
			}

			priority := ""
			if task.Priority == "high" {
				priority = " [HIGH]"
			}

			fmt.Printf("%d. [%s]%s %s\n",
				task.ID, task.Status, priority, task.Description)
		}
	},
}

func init() {
	rootCmd.AddCommand(listCmd)

	listCmd.Flags().StringVarP(&listStatus, "status", "s", "",
		"Filter by status")
	listCmd.RegisterFlagCompletionFunc("status", func(cmd *cobra.Command,
		args []string, toComplete string) ([]string, cobra.ShellCompDirective) {
		return []string{"pending", "done"}, cobra.ShellCompDirectiveNoFileComp
	})
}

// cmd/done.go
package cmd

import (
	"fmt"
	"strconv"

	"github.com/spf13/cobra"
)

var doneCmd = &cobra.Command{
	Use:   "done [id]",
	Short: "Mark task as done",
	Args:  cobra.ExactArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		id, err := strconv.Atoi(args[0])
		if err != nil {
			return fmt.Errorf("invalid task ID: %s", args[0])
		}

		for i := range store.Tasks {
			if store.Tasks[i].ID == id {
				store.Tasks[i].Status = "done"
				if err := saveTasks(); err != nil {
					return err
				}
				fmt.Printf("Task #%d marked as done\n", id)
				return nil
			}
		}

		return fmt.Errorf("task #%d not found", id)
	},
	ValidArgsFunction: func(cmd *cobra.Command, args []string,
		toComplete string) ([]string, cobra.ShellCompDirective) {
		var ids []string
		for _, t := range store.Tasks {
			if t.Status == "pending" {
				ids = append(ids, fmt.Sprintf("%d", t.ID))
			}
		}
		return ids, cobra.ShellCompDirectiveNoFileComp
	},
}

func init() {
	rootCmd.AddCommand(doneCmd)
}

// cmd/config.go
package cmd

import (
	"github.com/spf13/cobra"
)

var configCmd = &cobra.Command{
	Use:   "config",
	Short: "Manage configuration",
}

func init() {
	rootCmd.AddCommand(configCmd)
}

// cmd/config_get.go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var configGetCmd = &cobra.Command{
	Use:   "get [key]",
	Short: "Get a config value",
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		key := args[0]
		value := viper.Get(key)
		if value == nil {
			fmt.Printf("%s is not set\n", key)
		} else {
			fmt.Printf("%s = %v\n", key, value)
		}
	},
}

func init() {
	configCmd.AddCommand(configGetCmd)
}

// cmd/config_list.go
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var configListCmd = &cobra.Command{
	Use:     "list",
	Aliases: []string{"ls"},
	Short:   "List all config values",
	Run: func(cmd *cobra.Command, args []string) {
		settings := viper.AllSettings()
		for key, value := range settings {
			fmt.Printf("%s = %v\n", key, value)
		}
	},
}

func init() {
	configCmd.AddCommand(configListCmd)
}
```

</details>

---

## Common Mistakes

### Mistake 1: Forgetting to Call AddCommand

**The Problem:**
```go
var myCmd = &cobra.Command{...}

func init() {
	// Forgot to add to parent!
	// rootCmd.AddCommand(myCmd)
}
```

**The Fix:** Always add commands to their parent in `init()`:
```go
func init() {
	rootCmd.AddCommand(myCmd)
}
```

---

### Mistake 2: Using Run When Errors Can Occur

**The Problem:**
```go
Run: func(cmd *cobra.Command, args []string) {
	if err := doSomething(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)  // Abrupt exit
	}
}
```

**The Fix:** Use `RunE` for proper error handling:
```go
RunE: func(cmd *cobra.Command, args []string) error {
	return doSomething()  // Cobra handles the error
}
```

---

### Mistake 3: Not Binding Flags to Viper

**The Problem:**
```go
// Flag defined but not bound
cmd.Flags().String("port", "8080", "Port")

// In command:
port := cmd.Flags().Lookup("port").Value.String()  // Manual lookup
```

**The Fix:** Bind flags to Viper for unified config:
```go
cmd.Flags().String("port", "8080", "Port")
viper.BindPFlag("port", cmd.Flags().Lookup("port"))

// In command:
port := viper.GetString("port")  // Works with env vars too
```

---

## Summary

In this chapter, you learned:

- **Cobra's architecture:** Commands, flags, and the execution lifecycle provide a robust foundation for CLI applications.

- **Project structure:** Organizing code with separate files per command keeps applications maintainable as they grow.

- **Flags and arguments:** Persistent vs local flags, required flags, flag groups, and custom flag types give you complete control over input.

- **Command hierarchy:** Nested subcommands like `app config get` are trivial to implement with Cobra's `AddCommand`.

- **Shell completions:** Automatic and custom completions make your CLI more user-friendly.

- **Viper integration:** Seamless configuration management with precedence: flags > env vars > config file > defaults.

### Key Takeaways

1. Use `RunE` instead of `Run` when errors can occur
2. Persistent flags on root are inherited by all subcommands
3. Bind flags to Viper for unified configuration
4. Shell completions are free—just generate them
5. Pre/PostRun hooks are perfect for setup and cleanup

---

## What's Next

You now have the tools to build professional CLI applications. In Chapter 4, we'll dive into working with files and streams—reading from stdin, processing files efficiently, and handling different data formats like JSON, YAML, and CSV.

---

## Further Reading

- [Cobra User Guide](https://cobra.dev/)
- [Cobra GitHub Repository](https://github.com/spf13/cobra)
- [Viper Configuration](https://github.com/spf13/viper)
- [kubectl Source Code](https://github.com/kubernetes/kubectl) - Real-world Cobra example
- [GitHub CLI Source](https://github.com/cli/cli) - Modern Cobra patterns
