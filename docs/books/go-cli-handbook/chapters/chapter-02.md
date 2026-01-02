# Chapter 2: Parsing Arguments and Flags

> "A program should be light and agile, its subroutines connected like a string of pearls."
> — The Tao of Programming

## Introduction

In Chapter 1, we built a simple CLI application using the `flag` package. But real-world CLI tools need more sophisticated argument handling: positional arguments, required flags, custom types, environment variable fallbacks, and even manual subcommand routing.

This chapter takes you deeper into Go's argument parsing capabilities. We'll master the standard library's `flag` package, learn to handle positional arguments elegantly, create custom flag types for domain-specific validation, and implement environment variable integration. By the end, you'll have the skills to build CLI tools with professional-grade argument handling.

**In this chapter, you will learn:**
- Advanced techniques with the `flag` package
- How to handle positional arguments alongside flags
- Creating custom flag types for validation and parsing
- Implementing environment variable fallbacks
- Building manual subcommand routing

---

## The flag Package Deep Dive

The standard library's `flag` package is more powerful than most developers realize. Let's explore its advanced features.

### Flag Definition Methods

Go provides two styles for defining flags:

**Pointer Style (returns *T):**
```go
name := flag.String("name", "default", "description")
// name is *string, use *name to get value
```

**Variable Style (binds to existing variable):**
```go
var name string
flag.StringVar(&name, "name", "default", "description")
// name is string, use directly
```

The variable style is often cleaner when you have many flags or want to organize them in a struct:

```go
package main

import (
	"flag"
	"fmt"
)

type Config struct {
	Host    string
	Port    int
	Verbose bool
	Timeout int
}

func main() {
	cfg := Config{}

	flag.StringVar(&cfg.Host, "host", "localhost", "Server host")
	flag.IntVar(&cfg.Port, "port", 8080, "Server port")
	flag.BoolVar(&cfg.Verbose, "verbose", false, "Enable verbose output")
	flag.BoolVar(&cfg.Verbose, "v", false, "Enable verbose output (shorthand)")
	flag.IntVar(&cfg.Timeout, "timeout", 30, "Connection timeout in seconds")

	flag.Parse()

	fmt.Printf("Config: %+v\n", cfg)
}
```

### Supported Flag Types

The `flag` package supports these built-in types:

| Type | Functions | Example |
|------|-----------|---------|
| `bool` | `Bool`, `BoolVar` | `--verbose`, `-v` |
| `int` | `Int`, `IntVar` | `--port 8080` |
| `int64` | `Int64`, `Int64Var` | `--size 1073741824` |
| `uint` | `Uint`, `UintVar` | `--count 100` |
| `uint64` | `Uint64`, `Uint64Var` | `--offset 9223372036854775808` |
| `float64` | `Float64`, `Float64Var` | `--rate 0.5` |
| `string` | `String`, `StringVar` | `--name "value"` |
| `time.Duration` | `Duration`, `DurationVar` | `--timeout 30s` |

**Duration flags are particularly useful:**

```go
package main

import (
	"flag"
	"fmt"
	"time"
)

func main() {
	timeout := flag.Duration("timeout", 30*time.Second, "Request timeout")
	interval := flag.Duration("interval", 5*time.Minute, "Check interval")

	flag.Parse()

	fmt.Printf("Timeout: %v\n", *timeout)
	fmt.Printf("Interval: %v\n", *interval)
}
```

```bash
./myapp --timeout 2m30s --interval 1h
# Timeout: 2m30s
# Interval: 1h0m0s
```

### Flag Syntax Variations

The `flag` package accepts multiple syntax forms:

```bash
# All equivalent for string flags
./app -name=value
./app -name value
./app --name=value
./app --name value

# Boolean flags
./app -verbose        # sets to true
./app -verbose=true   # explicit true
./app -verbose=false  # explicit false

# Note: -verbose false does NOT work as expected!
# It sets verbose=true and "false" becomes a positional argument
```

**Important:** Boolean flags don't consume the next argument. Use `=` syntax for explicit values.

### Custom Usage Messages

Override `flag.Usage` to create professional help output:

```go
package main

import (
	"flag"
	"fmt"
	"os"
)

var (
	host    string
	port    int
	verbose bool
)

func init() {
	flag.StringVar(&host, "host", "localhost", "Server hostname")
	flag.StringVar(&host, "H", "localhost", "Server hostname (shorthand)")
	flag.IntVar(&port, "port", 8080, "Server port number")
	flag.IntVar(&port, "p", 8080, "Server port number (shorthand)")
	flag.BoolVar(&verbose, "verbose", false, "Enable verbose output")
	flag.BoolVar(&verbose, "v", false, "Enable verbose output (shorthand)")

	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, `Usage: %s [OPTIONS] COMMAND

A powerful server management tool.

Options:
  -H, --host string     Server hostname (default "localhost")
  -p, --port int        Server port number (default 8080)
  -v, --verbose         Enable verbose output

Commands:
  start     Start the server
  stop      Stop the server
  status    Show server status

Examples:
  %s --host 0.0.0.0 --port 3000 start
  %s -H localhost -p 8080 status

`, os.Args[0], os.Args[0], os.Args[0])
	}
}

func main() {
	flag.Parse()

	if flag.NArg() == 0 {
		flag.Usage()
		os.Exit(2)
	}

	command := flag.Arg(0)
	fmt.Printf("Running command: %s on %s:%d\n", command, host, port)
}
```

---

## Positional Arguments

Flags are great for options, but many commands need positional arguments too:

```bash
cp source.txt destination.txt       # Two positional args
grep "pattern" file1.txt file2.txt  # Pattern + multiple files
git commit -m "message" file.txt    # Mix of flags and args
```

### Accessing Positional Arguments

After `flag.Parse()`, positional arguments are available via:

```go
flag.Args()  // []string of all remaining arguments
flag.Arg(0)  // First positional argument (empty string if none)
flag.Arg(n)  // Nth positional argument
flag.NArg()  // Number of positional arguments
```

**Example: File copy tool**

```go
package main

import (
	"flag"
	"fmt"
	"io"
	"os"
)

func main() {
	force := flag.Bool("force", false, "Overwrite destination if exists")
	flag.Bool("f", false, "Overwrite destination if exists (shorthand)")

	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [OPTIONS] SOURCE DEST\n\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "Copy SOURCE file to DEST.\n\n")
		fmt.Fprintf(os.Stderr, "Options:\n")
		flag.PrintDefaults()
	}

	flag.Parse()

	// Validate positional arguments
	if flag.NArg() != 2 {
		fmt.Fprintln(os.Stderr, "Error: exactly 2 arguments required")
		flag.Usage()
		os.Exit(2)
	}

	source := flag.Arg(0)
	dest := flag.Arg(1)

	// Check if destination exists
	if !*force {
		if _, err := os.Stat(dest); err == nil {
			fmt.Fprintf(os.Stderr, "Error: %s already exists (use --force to overwrite)\n", dest)
			os.Exit(1)
		}
	}

	// Copy the file
	if err := copyFile(source, dest); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Copied %s to %s\n", source, dest)
}

func copyFile(src, dst string) error {
	source, err := os.Open(src)
	if err != nil {
		return fmt.Errorf("cannot open source: %w", err)
	}
	defer source.Close()

	destination, err := os.Create(dst)
	if err != nil {
		return fmt.Errorf("cannot create destination: %w", err)
	}
	defer destination.Close()

	_, err = io.Copy(destination, source)
	if err != nil {
		return fmt.Errorf("copy failed: %w", err)
	}

	return nil
}
```

### Variable Number of Arguments

Many tools accept multiple files or inputs:

```go
package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	pattern := flag.String("pattern", "", "Search pattern (required)")
	ignoreCase := flag.Bool("i", false, "Case-insensitive search")
	lineNumbers := flag.Bool("n", false, "Show line numbers")

	flag.Parse()

	// Validate required flags
	if *pattern == "" {
		fmt.Fprintln(os.Stderr, "Error: --pattern is required")
		os.Exit(2)
	}

	// Get file arguments (or use stdin if none)
	files := flag.Args()
	if len(files) == 0 {
		files = []string{"-"} // Convention: - means stdin
	}

	fmt.Printf("Searching for %q in %d file(s)\n", *pattern, len(files))
	fmt.Printf("Options: ignoreCase=%v, lineNumbers=%v\n", *ignoreCase, *lineNumbers)

	for _, file := range files {
		fmt.Printf("  - %s\n", file)
	}
}
```

---

## Custom Flag Types

The built-in types cover most cases, but sometimes you need custom parsing. Any type implementing `flag.Value` can be used as a flag:

```go
type Value interface {
	String() string
	Set(string) error
}
```

### Example: String Slice Flag

Accept multiple values for the same flag:

```go
package main

import (
	"flag"
	"fmt"
	"strings"
)

// StringSlice implements flag.Value for []string
type StringSlice []string

func (s *StringSlice) String() string {
	return strings.Join(*s, ", ")
}

func (s *StringSlice) Set(value string) error {
	*s = append(*s, value)
	return nil
}

func main() {
	var tags StringSlice
	flag.Var(&tags, "tag", "Add a tag (can be repeated)")

	var exclude StringSlice
	flag.Var(&exclude, "exclude", "Exclude pattern (can be repeated)")

	flag.Parse()

	fmt.Printf("Tags: %v\n", tags)
	fmt.Printf("Exclude: %v\n", exclude)
}
```

```bash
./app --tag dev --tag production --exclude "*.log" --exclude "*.tmp"
# Tags: [dev production]
# Exclude: [*.log *.tmp]
```

### Example: Enum Flag

Restrict values to a predefined set:

```go
package main

import (
	"flag"
	"fmt"
	"os"
	"strings"
)

// LogLevel restricts valid log levels
type LogLevel string

const (
	LogDebug LogLevel = "debug"
	LogInfo  LogLevel = "info"
	LogWarn  LogLevel = "warn"
	LogError LogLevel = "error"
)

var validLevels = []LogLevel{LogDebug, LogInfo, LogWarn, LogError}

func (l *LogLevel) String() string {
	return string(*l)
}

func (l *LogLevel) Set(value string) error {
	v := LogLevel(strings.ToLower(value))
	for _, valid := range validLevels {
		if v == valid {
			*l = v
			return nil
		}
	}
	return fmt.Errorf("must be one of: %v", validLevels)
}

func main() {
	level := LogLevel(LogInfo) // default
	flag.Var(&level, "level", "Log level (debug, info, warn, error)")

	flag.Parse()

	fmt.Printf("Log level: %s\n", level)
}
```

```bash
./app --level debug
# Log level: debug

./app --level invalid
# invalid value "invalid" for flag -level: must be one of: [debug info warn error]
```

### Example: Key-Value Flag

Parse key=value pairs:

```go
package main

import (
	"flag"
	"fmt"
	"strings"
)

// KeyValue stores key=value pairs
type KeyValue map[string]string

func (kv *KeyValue) String() string {
	if *kv == nil {
		return ""
	}
	pairs := make([]string, 0, len(*kv))
	for k, v := range *kv {
		pairs = append(pairs, fmt.Sprintf("%s=%s", k, v))
	}
	return strings.Join(pairs, ", ")
}

func (kv *KeyValue) Set(value string) error {
	if *kv == nil {
		*kv = make(map[string]string)
	}

	parts := strings.SplitN(value, "=", 2)
	if len(parts) != 2 {
		return fmt.Errorf("expected key=value format, got %q", value)
	}

	key := strings.TrimSpace(parts[0])
	val := strings.TrimSpace(parts[1])

	if key == "" {
		return fmt.Errorf("key cannot be empty")
	}

	(*kv)[key] = val
	return nil
}

func main() {
	var labels KeyValue
	flag.Var(&labels, "label", "Add a label (key=value, can be repeated)")

	var env KeyValue
	flag.Var(&env, "env", "Set environment variable (KEY=value)")

	flag.Parse()

	fmt.Printf("Labels: %v\n", labels)
	fmt.Printf("Environment: %v\n", env)
}
```

```bash
./app --label app=web --label tier=frontend --env PORT=8080 --env DEBUG=true
# Labels: map[app:web tier:frontend]
# Environment: map[DEBUG:true PORT:8080]
```

---

## Environment Variable Fallbacks

Professional CLI tools read configuration from multiple sources with clear precedence:

```
Command-line flags (highest priority)
    ↓
Environment variables
    ↓
Configuration file
    ↓
Default values (lowest priority)
```

### Manual Environment Fallback

```go
package main

import (
	"flag"
	"fmt"
	"os"
	"strconv"
)

func getEnvString(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return fallback
}

func getEnvInt(key string, fallback int) int {
	if value, exists := os.LookupEnv(key); exists {
		if i, err := strconv.Atoi(value); err == nil {
			return i
		}
	}
	return fallback
}

func getEnvBool(key string, fallback bool) bool {
	if value, exists := os.LookupEnv(key); exists {
		if b, err := strconv.ParseBool(value); err == nil {
			return b
		}
	}
	return fallback
}

func main() {
	// Default values come from environment, then hardcoded defaults
	host := flag.String("host", getEnvString("APP_HOST", "localhost"), "Server host")
	port := flag.Int("port", getEnvInt("APP_PORT", 8080), "Server port")
	debug := flag.Bool("debug", getEnvBool("APP_DEBUG", false), "Enable debug mode")

	flag.Parse()

	fmt.Printf("Host: %s\n", *host)
	fmt.Printf("Port: %d\n", *port)
	fmt.Printf("Debug: %v\n", *debug)
}
```

```bash
# Use defaults
./app
# Host: localhost, Port: 8080, Debug: false

# Environment variables
APP_HOST=0.0.0.0 APP_PORT=3000 ./app
# Host: 0.0.0.0, Port: 3000, Debug: false

# Flags override environment
APP_PORT=3000 ./app --port 9000
# Host: localhost, Port: 9000, Debug: false
```

### Generic Environment Helper

Create a reusable pattern:

```go
package main

import (
	"flag"
	"fmt"
	"os"
	"strconv"
	"time"
)

// EnvFlag creates a flag with environment variable fallback
func EnvFlag[T any](name, env string, defaultVal T, usage string, parser func(string) (T, error)) *T {
	result := defaultVal

	// Check environment variable
	if envVal, exists := os.LookupEnv(env); exists {
		if parsed, err := parser(envVal); err == nil {
			result = parsed
		}
	}

	// Register flag (will override env if provided)
	ptr := new(T)
	*ptr = result

	// Create appropriate flag based on type
	switch any(result).(type) {
	case string:
		flag.StringVar(any(ptr).(*string), name, any(result).(string),
			fmt.Sprintf("%s (env: %s)", usage, env))
	case int:
		flag.IntVar(any(ptr).(*int), name, any(result).(int),
			fmt.Sprintf("%s (env: %s)", usage, env))
	case bool:
		flag.BoolVar(any(ptr).(*bool), name, any(result).(bool),
			fmt.Sprintf("%s (env: %s)", usage, env))
	}

	return ptr
}

// Simpler approach without generics
type Config struct {
	Host    string
	Port    int
	Timeout time.Duration
	Debug   bool
}

func LoadConfig() *Config {
	cfg := &Config{}

	// Define flags with env fallbacks in description
	flag.StringVar(&cfg.Host, "host", envOr("APP_HOST", "localhost"),
		"Server host (env: APP_HOST)")
	flag.IntVar(&cfg.Port, "port", envOrInt("APP_PORT", 8080),
		"Server port (env: APP_PORT)")
	flag.DurationVar(&cfg.Timeout, "timeout", envOrDuration("APP_TIMEOUT", 30*time.Second),
		"Request timeout (env: APP_TIMEOUT)")
	flag.BoolVar(&cfg.Debug, "debug", envOrBool("APP_DEBUG", false),
		"Enable debug mode (env: APP_DEBUG)")

	return cfg
}

func envOr(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func envOrInt(key string, fallback int) int {
	if v := os.Getenv(key); v != "" {
		if i, err := strconv.Atoi(v); err == nil {
			return i
		}
	}
	return fallback
}

func envOrDuration(key string, fallback time.Duration) time.Duration {
	if v := os.Getenv(key); v != "" {
		if d, err := time.ParseDuration(v); err == nil {
			return d
		}
	}
	return fallback
}

func envOrBool(key string, fallback bool) bool {
	if v := os.Getenv(key); v != "" {
		if b, err := strconv.ParseBool(v); err == nil {
			return b
		}
	}
	return fallback
}

func main() {
	cfg := LoadConfig()
	flag.Parse()

	fmt.Printf("Configuration:\n")
	fmt.Printf("  Host: %s\n", cfg.Host)
	fmt.Printf("  Port: %d\n", cfg.Port)
	fmt.Printf("  Timeout: %v\n", cfg.Timeout)
	fmt.Printf("  Debug: %v\n", cfg.Debug)
}
```

---

## Manual Subcommand Routing

Before learning Cobra in Chapter 3, let's understand how to implement subcommands manually. This knowledge helps you appreciate what frameworks provide.

### Basic Subcommand Pattern

```go
package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(2)
	}

	// First argument is the subcommand
	switch os.Args[1] {
	case "serve":
		serveCmd(os.Args[2:])
	case "config":
		configCmd(os.Args[2:])
	case "version":
		versionCmd()
	case "help", "--help", "-h":
		printUsage()
	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n\n", os.Args[1])
		printUsage()
		os.Exit(2)
	}
}

func printUsage() {
	fmt.Println(`Usage: myapp <command> [options]

Commands:
  serve     Start the server
  config    Manage configuration
  version   Show version information
  help      Show this help message

Run 'myapp <command> --help' for command-specific help.`)
}

func serveCmd(args []string) {
	fs := flag.NewFlagSet("serve", flag.ExitOnError)
	host := fs.String("host", "localhost", "Host to bind to")
	port := fs.Int("port", 8080, "Port to listen on")

	fs.Usage = func() {
		fmt.Println(`Usage: myapp serve [options]

Start the HTTP server.

Options:`)
		fs.PrintDefaults()
	}

	fs.Parse(args)

	fmt.Printf("Starting server on %s:%d\n", *host, *port)
}

func configCmd(args []string) {
	if len(args) < 1 {
		fmt.Println(`Usage: myapp config <subcommand>

Subcommands:
  get <key>       Get a configuration value
  set <key> <val> Set a configuration value
  list            List all configuration`)
		os.Exit(2)
	}

	switch args[0] {
	case "get":
		if len(args) < 2 {
			fmt.Fprintln(os.Stderr, "Error: key required")
			os.Exit(2)
		}
		fmt.Printf("Getting config: %s\n", args[1])

	case "set":
		if len(args) < 3 {
			fmt.Fprintln(os.Stderr, "Error: key and value required")
			os.Exit(2)
		}
		fmt.Printf("Setting %s = %s\n", args[1], args[2])

	case "list":
		fmt.Println("Listing all configuration...")

	default:
		fmt.Fprintf(os.Stderr, "Unknown config subcommand: %s\n", args[0])
		os.Exit(2)
	}
}

func versionCmd() {
	fmt.Println("myapp version 1.0.0")
}
```

### Using flag.FlagSet for Isolation

Each subcommand should have its own `FlagSet` to avoid conflicts:

```go
package main

import (
	"flag"
	"fmt"
	"os"
)

// Global flags (apply to all commands)
var (
	verbose bool
	config  string
)

func main() {
	// Parse global flags first
	globalFlags := flag.NewFlagSet("global", flag.ContinueOnError)
	globalFlags.BoolVar(&verbose, "verbose", false, "Enable verbose output")
	globalFlags.BoolVar(&verbose, "v", false, "Enable verbose output (shorthand)")
	globalFlags.StringVar(&config, "config", "", "Config file path")
	globalFlags.StringVar(&config, "c", "", "Config file path (shorthand)")

	// Find where subcommand starts (first non-flag argument)
	var cmdIndex int
	for i, arg := range os.Args[1:] {
		if arg[0] != '-' {
			cmdIndex = i + 1
			break
		}
		// Handle flags that consume next argument
		if arg == "-c" || arg == "--config" {
			continue
		}
	}

	// Parse global flags (everything before subcommand)
	if cmdIndex > 1 {
		globalFlags.Parse(os.Args[1:cmdIndex])
	}

	if cmdIndex == 0 || cmdIndex >= len(os.Args) {
		fmt.Fprintln(os.Stderr, "Error: command required")
		os.Exit(2)
	}

	command := os.Args[cmdIndex]
	cmdArgs := os.Args[cmdIndex+1:]

	if verbose {
		fmt.Printf("[DEBUG] Command: %s, Args: %v\n", command, cmdArgs)
		if config != "" {
			fmt.Printf("[DEBUG] Config file: %s\n", config)
		}
	}

	switch command {
	case "init":
		initCmd(cmdArgs)
	case "run":
		runCmd(cmdArgs)
	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n", command)
		os.Exit(2)
	}
}

func initCmd(args []string) {
	fs := flag.NewFlagSet("init", flag.ExitOnError)
	template := fs.String("template", "default", "Project template to use")
	force := fs.Bool("force", false, "Overwrite existing files")

	fs.Parse(args)

	projectName := "."
	if fs.NArg() > 0 {
		projectName = fs.Arg(0)
	}

	fmt.Printf("Initializing project: %s\n", projectName)
	fmt.Printf("  Template: %s\n", *template)
	fmt.Printf("  Force: %v\n", *force)
}

func runCmd(args []string) {
	fs := flag.NewFlagSet("run", flag.ExitOnError)
	watch := fs.Bool("watch", false, "Watch for changes")
	port := fs.Int("port", 3000, "Port to run on")

	fs.Parse(args)

	fmt.Printf("Running application on port %d\n", *port)
	if *watch {
		fmt.Println("Watch mode enabled")
	}
}
```

---

## Exercises

### Exercise 1: Calculator CLI

**Difficulty:** Easy
**Time:** ~15 minutes

**Goal:** Build a calculator that takes an operation and numbers as arguments.

**Requirements:**
1. Support operations: `add`, `subtract`, `multiply`, `divide`
2. Accept any number of numeric arguments
3. Support `--precision` flag for decimal places (default: 2)
4. Handle division by zero gracefully

**Example Usage:**
```bash
./calc add 1 2 3 4 5
# Result: 15.00

./calc multiply 2 3 4 --precision 0
# Result: 24

./calc divide 10 3 --precision 4
# Result: 3.3333
```

<details>
<summary>Solution</summary>

```go
package main

import (
	"flag"
	"fmt"
	"os"
	"strconv"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Usage: calc <operation> [--precision N] numbers...")
		fmt.Fprintln(os.Stderr, "Operations: add, subtract, multiply, divide")
		os.Exit(2)
	}

	operation := os.Args[1]

	// Create flag set for this command
	fs := flag.NewFlagSet("calc", flag.ExitOnError)
	precision := fs.Int("precision", 2, "Decimal places in result")

	fs.Parse(os.Args[2:])

	// Parse numbers from remaining arguments
	args := fs.Args()
	if len(args) == 0 {
		fmt.Fprintln(os.Stderr, "Error: at least one number required")
		os.Exit(2)
	}

	numbers := make([]float64, len(args))
	for i, arg := range args {
		n, err := strconv.ParseFloat(arg, 64)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %q is not a valid number\n", arg)
			os.Exit(2)
		}
		numbers[i] = n
	}

	var result float64
	switch operation {
	case "add":
		for _, n := range numbers {
			result += n
		}
	case "subtract":
		result = numbers[0]
		for _, n := range numbers[1:] {
			result -= n
		}
	case "multiply":
		result = 1
		for _, n := range numbers {
			result *= n
		}
	case "divide":
		result = numbers[0]
		for _, n := range numbers[1:] {
			if n == 0 {
				fmt.Fprintln(os.Stderr, "Error: division by zero")
				os.Exit(1)
			}
			result /= n
		}
	default:
		fmt.Fprintf(os.Stderr, "Error: unknown operation %q\n", operation)
		os.Exit(2)
	}

	format := fmt.Sprintf("Result: %%.%df\n", *precision)
	fmt.Printf(format, result)
}
```

</details>

---

### Exercise 2: URL Flag Type

**Difficulty:** Medium
**Time:** ~20 minutes

**Goal:** Create a custom flag type that validates URLs.

**Requirements:**
1. Implement `flag.Value` for URL validation
2. Ensure URLs have a valid scheme (http or https)
3. Optionally require specific hosts
4. Support multiple URL flags

<details>
<summary>Solution</summary>

```go
package main

import (
	"flag"
	"fmt"
	"net/url"
	"os"
	"strings"
)

// URLFlag validates and stores a URL
type URLFlag struct {
	URL           *url.URL
	AllowedHosts  []string
	RequireScheme []string
}

func NewURLFlag(allowedHosts, requiredSchemes []string) *URLFlag {
	return &URLFlag{
		AllowedHosts:  allowedHosts,
		RequireScheme: requiredSchemes,
	}
}

func (u *URLFlag) String() string {
	if u.URL == nil {
		return ""
	}
	return u.URL.String()
}

func (u *URLFlag) Set(value string) error {
	parsed, err := url.Parse(value)
	if err != nil {
		return fmt.Errorf("invalid URL: %w", err)
	}

	// Validate scheme
	if len(u.RequireScheme) > 0 {
		valid := false
		for _, s := range u.RequireScheme {
			if parsed.Scheme == s {
				valid = true
				break
			}
		}
		if !valid {
			return fmt.Errorf("URL scheme must be one of: %v", u.RequireScheme)
		}
	}

	// Validate host
	if len(u.AllowedHosts) > 0 {
		valid := false
		for _, h := range u.AllowedHosts {
			if parsed.Host == h || strings.HasSuffix(parsed.Host, "."+h) {
				valid = true
				break
			}
		}
		if !valid {
			return fmt.Errorf("URL host must be one of: %v", u.AllowedHosts)
		}
	}

	u.URL = parsed
	return nil
}

// URLSliceFlag for multiple URLs
type URLSliceFlag struct {
	URLs          []*url.URL
	RequireScheme []string
}

func (u *URLSliceFlag) String() string {
	strs := make([]string, len(u.URLs))
	for i, url := range u.URLs {
		strs[i] = url.String()
	}
	return strings.Join(strs, ", ")
}

func (u *URLSliceFlag) Set(value string) error {
	parsed, err := url.Parse(value)
	if err != nil {
		return fmt.Errorf("invalid URL: %w", err)
	}

	if len(u.RequireScheme) > 0 {
		valid := false
		for _, s := range u.RequireScheme {
			if parsed.Scheme == s {
				valid = true
				break
			}
		}
		if !valid {
			return fmt.Errorf("URL scheme must be one of: %v", u.RequireScheme)
		}
	}

	u.URLs = append(u.URLs, parsed)
	return nil
}

func main() {
	// Single URL with validation
	apiURL := NewURLFlag(nil, []string{"http", "https"})
	flag.Var(apiURL, "api", "API endpoint URL (http/https required)")

	// Multiple URLs
	webhooks := &URLSliceFlag{RequireScheme: []string{"https"}}
	flag.Var(webhooks, "webhook", "Webhook URL (https required, repeatable)")

	flag.Parse()

	if apiURL.URL != nil {
		fmt.Printf("API URL: %s\n", apiURL.URL)
		fmt.Printf("  Host: %s\n", apiURL.URL.Host)
		fmt.Printf("  Path: %s\n", apiURL.URL.Path)
	}

	if len(webhooks.URLs) > 0 {
		fmt.Printf("Webhooks (%d):\n", len(webhooks.URLs))
		for i, u := range webhooks.URLs {
			fmt.Printf("  %d. %s\n", i+1, u)
		}
	}
}
```

</details>

---

### Exercise 3: Config with Full Precedence

**Difficulty:** Medium
**Time:** ~25 minutes

**Goal:** Build a configuration system with proper precedence.

**Requirements:**
1. Support JSON config file
2. Environment variable overrides
3. Command-line flag overrides
4. Show the source of each config value

<details>
<summary>Solution</summary>

```go
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"strconv"
)

type ConfigSource string

const (
	SourceDefault ConfigSource = "default"
	SourceFile    ConfigSource = "file"
	SourceEnv     ConfigSource = "env"
	SourceFlag    ConfigSource = "flag"
)

type ConfigValue[T any] struct {
	Value  T
	Source ConfigSource
}

type Config struct {
	Host    ConfigValue[string]
	Port    ConfigValue[int]
	Debug   ConfigValue[bool]
	Timeout ConfigValue[int]
}

func LoadConfig(configPath string) (*Config, error) {
	cfg := &Config{
		Host:    ConfigValue[string]{Value: "localhost", Source: SourceDefault},
		Port:    ConfigValue[int]{Value: 8080, Source: SourceDefault},
		Debug:   ConfigValue[bool]{Value: false, Source: SourceDefault},
		Timeout: ConfigValue[int]{Value: 30, Source: SourceDefault},
	}

	// Layer 1: Config file
	if configPath != "" {
		if err := loadFromFile(cfg, configPath); err != nil {
			return nil, err
		}
	}

	// Layer 2: Environment variables
	loadFromEnv(cfg)

	// Layer 3: Flags (handled after this function returns)

	return cfg, nil
}

func loadFromFile(cfg *Config, path string) error {
	data, err := os.ReadFile(path)
	if err != nil {
		if os.IsNotExist(err) {
			return nil // File doesn't exist, skip
		}
		return err
	}

	var fileConfig struct {
		Host    *string `json:"host"`
		Port    *int    `json:"port"`
		Debug   *bool   `json:"debug"`
		Timeout *int    `json:"timeout"`
	}

	if err := json.Unmarshal(data, &fileConfig); err != nil {
		return fmt.Errorf("invalid config file: %w", err)
	}

	if fileConfig.Host != nil {
		cfg.Host = ConfigValue[string]{Value: *fileConfig.Host, Source: SourceFile}
	}
	if fileConfig.Port != nil {
		cfg.Port = ConfigValue[int]{Value: *fileConfig.Port, Source: SourceFile}
	}
	if fileConfig.Debug != nil {
		cfg.Debug = ConfigValue[bool]{Value: *fileConfig.Debug, Source: SourceFile}
	}
	if fileConfig.Timeout != nil {
		cfg.Timeout = ConfigValue[int]{Value: *fileConfig.Timeout, Source: SourceFile}
	}

	return nil
}

func loadFromEnv(cfg *Config) {
	if v := os.Getenv("APP_HOST"); v != "" {
		cfg.Host = ConfigValue[string]{Value: v, Source: SourceEnv}
	}
	if v := os.Getenv("APP_PORT"); v != "" {
		if i, err := strconv.Atoi(v); err == nil {
			cfg.Port = ConfigValue[int]{Value: i, Source: SourceEnv}
		}
	}
	if v := os.Getenv("APP_DEBUG"); v != "" {
		if b, err := strconv.ParseBool(v); err == nil {
			cfg.Debug = ConfigValue[bool]{Value: b, Source: SourceEnv}
		}
	}
	if v := os.Getenv("APP_TIMEOUT"); v != "" {
		if i, err := strconv.Atoi(v); err == nil {
			cfg.Timeout = ConfigValue[int]{Value: i, Source: SourceEnv}
		}
	}
}

func main() {
	// Flags for config file path and overrides
	configPath := flag.String("config", "config.json", "Path to config file")
	hostFlag := flag.String("host", "", "Server host")
	portFlag := flag.Int("port", 0, "Server port")
	debugFlag := flag.Bool("debug", false, "Enable debug mode")
	timeoutFlag := flag.Int("timeout", 0, "Request timeout in seconds")
	showSources := flag.Bool("show-sources", false, "Show config value sources")

	flag.Parse()

	// Load config from file and env
	cfg, err := LoadConfig(*configPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading config: %v\n", err)
		os.Exit(1)
	}

	// Apply flag overrides (only if explicitly set)
	flag.Visit(func(f *flag.Flag) {
		switch f.Name {
		case "host":
			cfg.Host = ConfigValue[string]{Value: *hostFlag, Source: SourceFlag}
		case "port":
			cfg.Port = ConfigValue[int]{Value: *portFlag, Source: SourceFlag}
		case "debug":
			cfg.Debug = ConfigValue[bool]{Value: *debugFlag, Source: SourceFlag}
		case "timeout":
			cfg.Timeout = ConfigValue[int]{Value: *timeoutFlag, Source: SourceFlag}
		}
	})

	// Print configuration
	fmt.Println("Configuration:")
	if *showSources {
		fmt.Printf("  Host:    %s (from %s)\n", cfg.Host.Value, cfg.Host.Source)
		fmt.Printf("  Port:    %d (from %s)\n", cfg.Port.Value, cfg.Port.Source)
		fmt.Printf("  Debug:   %v (from %s)\n", cfg.Debug.Value, cfg.Debug.Source)
		fmt.Printf("  Timeout: %d (from %s)\n", cfg.Timeout.Value, cfg.Timeout.Source)
	} else {
		fmt.Printf("  Host:    %s\n", cfg.Host.Value)
		fmt.Printf("  Port:    %d\n", cfg.Port.Value)
		fmt.Printf("  Debug:   %v\n", cfg.Debug.Value)
		fmt.Printf("  Timeout: %d\n", cfg.Timeout.Value)
	}
}
```

</details>

---

### Exercise 4: Multi-Command Tool

**Difficulty:** Hard
**Time:** ~30 minutes

**Goal:** Build a complete multi-command CLI with shared flags.

**Requirements:**
1. Global flags: `--verbose`, `--config`
2. Commands: `init`, `build`, `deploy`
3. Each command has its own flags
4. Proper help for each command

<details>
<summary>Solution</summary>

```go
package main

import (
	"flag"
	"fmt"
	"os"
	"strings"
)

// Global configuration
var (
	verbose    bool
	configFile string
)

func main() {
	// Define global flags (parsed manually to allow subcommand placement)
	args := parseGlobalFlags(os.Args[1:])

	if len(args) == 0 {
		printMainHelp()
		os.Exit(2)
	}

	command := args[0]
	cmdArgs := args[1:]

	switch command {
	case "init":
		cmdInit(cmdArgs)
	case "build":
		cmdBuild(cmdArgs)
	case "deploy":
		cmdDeploy(cmdArgs)
	case "help":
		if len(cmdArgs) > 0 {
			printCommandHelp(cmdArgs[0])
		} else {
			printMainHelp()
		}
	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n\n", command)
		printMainHelp()
		os.Exit(2)
	}
}

func parseGlobalFlags(args []string) []string {
	var remaining []string
	i := 0

	for i < len(args) {
		arg := args[i]

		switch {
		case arg == "-v" || arg == "--verbose":
			verbose = true
			i++
		case arg == "-c" || arg == "--config":
			if i+1 < len(args) {
				configFile = args[i+1]
				i += 2
			} else {
				fmt.Fprintln(os.Stderr, "Error: --config requires a value")
				os.Exit(2)
			}
		case strings.HasPrefix(arg, "--config="):
			configFile = strings.TrimPrefix(arg, "--config=")
			i++
		case strings.HasPrefix(arg, "-c="):
			configFile = strings.TrimPrefix(arg, "-c=")
			i++
		case arg == "--help" || arg == "-h":
			printMainHelp()
			os.Exit(0)
		case strings.HasPrefix(arg, "-"):
			// Unknown global flag, might be command-specific
			remaining = append(remaining, args[i:]...)
			return remaining
		default:
			// Non-flag argument (command or command arg)
			remaining = append(remaining, args[i:]...)
			return remaining
		}
	}

	return remaining
}

func printMainHelp() {
	fmt.Println(`Usage: myapp [global-options] <command> [command-options]

A professional project management tool.

Global Options:
  -v, --verbose       Enable verbose output
  -c, --config FILE   Config file path

Commands:
  init      Initialize a new project
  build     Build the project
  deploy    Deploy to target environment
  help      Show help for a command

Examples:
  myapp init --template webapp myproject
  myapp --verbose build --target production
  myapp -c custom.yaml deploy --env staging

Run 'myapp help <command>' for command-specific help.`)
}

func printCommandHelp(cmd string) {
	switch cmd {
	case "init":
		fmt.Println(`Usage: myapp init [options] [project-name]

Initialize a new project.

Options:
  --template string   Project template (default: "default")
  --force            Overwrite existing files
  --git              Initialize git repository

Examples:
  myapp init myproject
  myapp init --template webapp --git mywebapp`)

	case "build":
		fmt.Println(`Usage: myapp build [options]

Build the project.

Options:
  --target string     Build target: dev, staging, production (default: "dev")
  --output string     Output directory (default: "./dist")
  --clean            Clean before building

Examples:
  myapp build --target production
  myapp build --clean --output ./build`)

	case "deploy":
		fmt.Println(`Usage: myapp deploy [options]

Deploy to target environment.

Options:
  --env string        Environment: staging, production (required)
  --dry-run          Show what would be deployed
  --force            Skip confirmation prompts

Examples:
  myapp deploy --env staging
  myapp deploy --env production --dry-run`)

	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n", cmd)
		os.Exit(2)
	}
}

func logVerbose(format string, args ...interface{}) {
	if verbose {
		fmt.Printf("[DEBUG] "+format+"\n", args...)
	}
}

func cmdInit(args []string) {
	fs := flag.NewFlagSet("init", flag.ExitOnError)
	template := fs.String("template", "default", "Project template")
	force := fs.Bool("force", false, "Overwrite existing files")
	initGit := fs.Bool("git", false, "Initialize git repository")

	fs.Usage = func() { printCommandHelp("init") }
	fs.Parse(args)

	projectName := "."
	if fs.NArg() > 0 {
		projectName = fs.Arg(0)
	}

	logVerbose("Config file: %s", configFile)
	logVerbose("Initializing project: %s", projectName)

	fmt.Printf("Initializing project '%s'\n", projectName)
	fmt.Printf("  Template: %s\n", *template)
	fmt.Printf("  Force: %v\n", *force)
	fmt.Printf("  Init Git: %v\n", *initGit)
}

func cmdBuild(args []string) {
	fs := flag.NewFlagSet("build", flag.ExitOnError)
	target := fs.String("target", "dev", "Build target")
	output := fs.String("output", "./dist", "Output directory")
	clean := fs.Bool("clean", false, "Clean before building")

	fs.Usage = func() { printCommandHelp("build") }
	fs.Parse(args)

	logVerbose("Config file: %s", configFile)
	logVerbose("Building for target: %s", *target)

	if *clean {
		fmt.Println("Cleaning output directory...")
	}

	fmt.Printf("Building project\n")
	fmt.Printf("  Target: %s\n", *target)
	fmt.Printf("  Output: %s\n", *output)
}

func cmdDeploy(args []string) {
	fs := flag.NewFlagSet("deploy", flag.ExitOnError)
	env := fs.String("env", "", "Target environment (required)")
	dryRun := fs.Bool("dry-run", false, "Show what would be deployed")
	force := fs.Bool("force", false, "Skip confirmation")

	fs.Usage = func() { printCommandHelp("deploy") }
	fs.Parse(args)

	if *env == "" {
		fmt.Fprintln(os.Stderr, "Error: --env is required")
		fs.Usage()
		os.Exit(2)
	}

	if *env != "staging" && *env != "production" {
		fmt.Fprintf(os.Stderr, "Error: --env must be 'staging' or 'production'\n")
		os.Exit(2)
	}

	logVerbose("Config file: %s", configFile)
	logVerbose("Deploying to: %s", *env)

	if *dryRun {
		fmt.Printf("[DRY RUN] Would deploy to %s\n", *env)
		return
	}

	if *env == "production" && !*force {
		fmt.Print("Deploy to production? [y/N]: ")
		var response string
		fmt.Scanln(&response)
		if response != "y" && response != "Y" {
			fmt.Println("Deployment cancelled")
			return
		}
	}

	fmt.Printf("Deploying to %s...\n", *env)
}
```

</details>

---

## Common Mistakes

### Mistake 1: Not Checking NArg() Before Accessing Args

**The Problem:**
```go
source := flag.Arg(0)  // Returns "" if no args, but code may expect a value
```

**The Fix:**
```go
if flag.NArg() < 1 {
    fmt.Fprintln(os.Stderr, "Error: source file required")
    os.Exit(2)
}
source := flag.Arg(0)
```

---

### Mistake 2: Boolean Flag Syntax Confusion

**The Problem:**
```bash
./app -verbose false  # Sets verbose=true, "false" becomes positional arg!
```

**The Fix:**
```bash
./app -verbose=false  # Correct: explicit false
./app                 # Or just omit for default false
```

Document this behavior in your help text.

---

### Mistake 3: Flag Parsing After os.Args Modification

**The Problem:**
```go
command := os.Args[1]
os.Args = os.Args[2:]  // Modifies global state
flag.Parse()           // Now flag.Arg(0) is wrong
```

**The Fix:**
```go
command := os.Args[1]
fs := flag.NewFlagSet(command, flag.ExitOnError)
fs.Parse(os.Args[2:])  // Isolated flag set
```

---

## Summary

In this chapter, you learned:

- **Advanced flag techniques:** Variable binding, all supported types, duration flags, and custom usage messages make the standard library surprisingly powerful.

- **Positional arguments:** Using `flag.Args()`, `flag.Arg(n)`, and `flag.NArg()` to handle non-flag inputs alongside flags.

- **Custom flag types:** Implementing `flag.Value` for domain-specific validation like string slices, enums, and key-value pairs.

- **Environment integration:** Building proper precedence chains where flags override environment variables override config files override defaults.

- **Manual subcommands:** Using `flag.NewFlagSet` to isolate flags per command and build multi-command tools.

### Key Takeaways

1. Use `flag.StringVar` style for cleaner code with many flags
2. Duration flags (`flag.Duration`) save parsing code for time values
3. Custom types via `flag.Value` enable powerful validation
4. Environment fallbacks should be visible in help text
5. Each subcommand needs its own `FlagSet` for isolation

---

## What's Next

You've mastered argument parsing with the standard library. In Chapter 3, we'll introduce Cobra—the framework that powers kubectl, docker, and hugo. Cobra provides subcommands, shell completions, and documentation generation out of the box, letting you focus on your application logic.

---

## Further Reading

- [Go flag package source code](https://golang.org/src/flag/flag.go) - Learn from the implementation
- [POSIX Utility Conventions](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html) - Standard argument syntax
- [GNU Argument Syntax](https://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html) - Long option conventions
