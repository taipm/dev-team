# Chapter 1: Introduction to CLI Development

> "The command line is a powerful tool. Master it, and you'll find yourself more productive than you ever thought possible."
> — Anonymous Developer

## Introduction

Every developer has a collection of scripts and small programs that make their daily work easier. Maybe it's a tool to format log files, a script to deploy code, or a utility to manage configurations. At some point, these scripts grow complex enough that they need proper argument parsing, help messages, and error handling. That's when you need a real command-line interface (CLI) application.

In this chapter, we'll explore why Go has become the go-to language for building CLI tools, understand the anatomy of a well-designed command-line application, and create your first "Hello, CLI" program. By the end, you'll have a solid foundation for building professional-grade command-line tools.

**In this chapter, you will learn:**
- Why Go is an excellent choice for CLI development
- The components that make up a CLI application
- How to use Go's standard library for basic CLI functionality
- Best practices for exit codes and output streams

---

## Why Go for CLI Applications?

Before we write any code, let's understand why Go has become the preferred language for CLI tools at companies like Google, Docker, and HashiCorp.

### Single Binary Distribution

Go compiles to a single static binary with no external dependencies. This means:

```bash
# Build your application
go build -o myapp

# Ship it anywhere - no runtime needed
scp myapp server:/usr/local/bin/
```

Compare this to Python or Node.js, where you need to ensure the correct runtime version is installed, manage virtual environments, and handle dependency conflicts. With Go, you just copy the binary and run it.

### Fast Startup Time

CLI tools need to start instantly. Users expect immediate response when they type a command. Go programs typically start in milliseconds, while JVM-based languages can take seconds just to initialize.

```bash
# Measure startup time
time ./myapp --help
# real    0m0.003s  <- Go is fast!
```

### Cross-Platform Compilation

Go's cross-compilation is remarkably simple. Build for any supported platform from your development machine:

```bash
# Build for Linux from macOS
GOOS=linux GOARCH=amd64 go build -o myapp-linux

# Build for Windows
GOOS=windows GOARCH=amd64 go build -o myapp.exe

# Build for ARM (Raspberry Pi, Apple Silicon)
GOOS=linux GOARCH=arm64 go build -o myapp-arm
```

No special toolchains, no Docker containers, no complex setup. Just set two environment variables and build.

### Strong Standard Library

Go's standard library provides everything you need for basic CLI development:

| Package | Purpose |
|---------|---------|
| `flag` | Command-line flag parsing |
| `os` | Environment variables, exit codes, file operations |
| `os/exec` | Running external commands |
| `io` | Input/output interfaces |
| `fmt` | Formatted I/O |
| `bufio` | Buffered I/O for efficient file processing |

You can build a functional CLI tool using only the standard library, though we'll later explore powerful frameworks like Cobra for more complex applications.

---

## Anatomy of a CLI Application

Every well-designed CLI application shares common components. Understanding these will help you design better tools.

### The Command Structure

```
myapp <command> [subcommand] [flags] [arguments]
```

Let's break this down:

- **Program name** (`myapp`): The executable name
- **Command** (`serve`, `config`, `version`): The action to perform
- **Subcommand** (`config get`, `config set`): Nested actions
- **Flags** (`--port 8080`, `-v`): Modifiers for the command
- **Arguments** (`file.txt`): Positional inputs

**Example from real tools:**

```bash
# Docker: command + subcommand + flags + arguments
docker container run --name web -p 8080:80 nginx

# Git: command + flags + arguments
git commit -m "Initial commit" file.txt

# kubectl: command + subcommand + flags
kubectl get pods --namespace production
```

### Input and Output Streams

Every CLI program has three standard streams:

```
┌─────────────────────────────────────────────────────────┐
│                    Your CLI Application                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  stdin (0)  ──────────►  [Processing]  ──────► stdout (1)
│  (input)                                       (output) │
│                              │                          │
│                              └──────────────► stderr (2)│
│                                               (errors)  │
└─────────────────────────────────────────────────────────┘
```

**Critical rule:** Normal output goes to `stdout`, errors go to `stderr`. This allows users to redirect them separately:

```bash
# Redirect output to file, see errors on screen
myapp process data.txt > results.txt

# Redirect errors to log, see output on screen
myapp process data.txt 2> errors.log

# Redirect both separately
myapp process data.txt > results.txt 2> errors.log
```

### Exit Codes

Exit codes tell the shell (and other programs) whether your command succeeded:

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Misuse of command (bad arguments) |
| 126 | Command cannot execute |
| 127 | Command not found |
| 128+N | Killed by signal N |

**Always exit with an appropriate code:**

```go
// Success
os.Exit(0)

// General error
os.Exit(1)

// Bad arguments
os.Exit(2)
```

This enables scripting:

```bash
if myapp validate config.yaml; then
    echo "Config is valid"
    myapp deploy
else
    echo "Invalid config, aborting"
fi
```

---

## Your First CLI Application

Let's build a simple but proper CLI application. We'll create a greeting tool that demonstrates the fundamental concepts.

### Project Setup

```bash
# Create project directory
mkdir hello-cli && cd hello-cli

# Initialize Go module
go mod init hello-cli

# Create main file
touch main.go
```

### Basic Implementation

```go
package main

import (
	"flag"
	"fmt"
	"os"
)

// Version information (set during build)
var version = "dev"

func main() {
	// Define flags
	name := flag.String("name", "World", "Name to greet")
	excited := flag.Bool("excited", false, "Add excitement to greeting")
	showVersion := flag.Bool("version", false, "Show version and exit")

	// Custom usage message
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [options]\n\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "A friendly greeting application.\n\n")
		fmt.Fprintf(os.Stderr, "Options:\n")
		flag.PrintDefaults()
	}

	// Parse command-line flags
	flag.Parse()

	// Handle version flag
	if *showVersion {
		fmt.Printf("hello-cli version %s\n", version)
		os.Exit(0)
	}

	// Validate input
	if *name == "" {
		fmt.Fprintln(os.Stderr, "Error: name cannot be empty")
		os.Exit(2)
	}

	// Generate greeting
	greeting := fmt.Sprintf("Hello, %s", *name)
	if *excited {
		greeting += "!"
	} else {
		greeting += "."
	}

	// Output to stdout
	fmt.Println(greeting)
	os.Exit(0)
}
```

### Let's Break This Down

**1. Package and Imports**

```go
package main

import (
	"flag"   // Command-line flag parsing
	"fmt"    // Formatted I/O
	"os"     // OS functionality (exit, stderr)
)
```

Every executable Go program starts with `package main` and a `main()` function.

**2. Flag Definition**

```go
name := flag.String("name", "World", "Name to greet")
excited := flag.Bool("excited", false, "Add excitement")
```

The `flag` package provides typed flag parsing. Each flag has:
- A name (`"name"`)
- A default value (`"World"`)
- A description for help text

**3. Custom Usage Message**

```go
flag.Usage = func() {
	fmt.Fprintf(os.Stderr, "Usage: %s [options]\n\n", os.Args[0])
	// ...
}
```

Override `flag.Usage` to customize the `--help` output.

**4. Error Handling**

```go
if *name == "" {
	fmt.Fprintln(os.Stderr, "Error: name cannot be empty")
	os.Exit(2)
}
```

Notice we write errors to `stderr` and exit with code 2 (bad arguments).

### Building and Running

```bash
# Build the application
go build -o hello-cli

# Run with defaults
./hello-cli
# Output: Hello, World.

# Run with flags
./hello-cli --name="Gopher" --excited
# Output: Hello, Gopher!

# Check help
./hello-cli --help
# Usage: ./hello-cli [options]
#
# A friendly greeting application.
#
# Options:
#   -excited
#         Add excitement to greeting
#   -name string
#         Name to greet (default "World")
#   -version
#         Show version and exit

# Check version
./hello-cli --version
# hello-cli version dev
```

### Setting Version at Build Time

Use `ldflags` to inject version information:

```bash
go build -ldflags "-X main.version=1.0.0" -o hello-cli
./hello-cli --version
# hello-cli version 1.0.0
```

---

## Working with Standard Streams

Understanding stdin, stdout, and stderr is crucial for building Unix-friendly tools.

### Reading from stdin

```go
package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	fmt.Fprintln(os.Stderr, "Enter lines (Ctrl+D to finish):")

	lineCount := 0
	for scanner.Scan() {
		lineCount++
		line := scanner.Text()
		fmt.Printf("Line %d: %s\n", lineCount, line)
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Error reading input:", err)
		os.Exit(1)
	}

	fmt.Fprintf(os.Stderr, "\nProcessed %d lines\n", lineCount)
}
```

**Key points:**
- Use `bufio.Scanner` for line-by-line reading
- Prompts and status messages go to `stderr`
- Actual output goes to `stdout`

This allows piping:

```bash
cat data.txt | ./myapp > processed.txt
```

### Detecting Pipe vs Terminal

Sometimes you need to know if input comes from a pipe or a user:

```go
package main

import (
	"fmt"
	"os"
)

func main() {
	stat, _ := os.Stdin.Stat()

	if (stat.Mode() & os.ModeCharDevice) == 0 {
		fmt.Println("Input is from a pipe")
	} else {
		fmt.Println("Input is from a terminal")
	}
}
```

This is useful for:
- Showing interactive prompts only in terminal mode
- Disabling colors when output is piped
- Changing behavior based on context

---

## Exercises

Practice what you've learned with these exercises.

### Exercise 1: Word Counter

**Difficulty:** Easy
**Time:** ~15 minutes

**Goal:** Build a CLI tool that counts words in input.

**Requirements:**
1. Read from stdin
2. Count total words
3. Support a `--lines` flag to also count lines
4. Output results to stdout, errors to stderr

**Example Usage:**
```bash
echo "Hello World" | ./wordcount
# 2 words

echo -e "Hello\nWorld" | ./wordcount --lines
# 2 words, 2 lines
```

<details>
<summary>Solution</summary>

```go
package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strings"
)

func main() {
	countLines := flag.Bool("lines", false, "Also count lines")
	flag.Parse()

	scanner := bufio.NewScanner(os.Stdin)

	wordCount := 0
	lineCount := 0

	for scanner.Scan() {
		line := scanner.Text()
		lineCount++
		words := strings.Fields(line)
		wordCount += len(words)
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Error:", err)
		os.Exit(1)
	}

	if *countLines {
		fmt.Printf("%d words, %d lines\n", wordCount, lineCount)
	} else {
		fmt.Printf("%d words\n", wordCount)
	}
}
```

**Explanation:** We use `strings.Fields()` which splits on whitespace and handles multiple spaces correctly.

</details>

---

### Exercise 2: File Checker

**Difficulty:** Medium
**Time:** ~20 minutes

**Goal:** Build a CLI tool that checks if files exist.

**Requirements:**
1. Accept file paths as positional arguments
2. Support `--quiet` flag (only exit code, no output)
3. Exit 0 if all files exist, 1 if any missing
4. Show which files are missing (unless quiet)

**Example Usage:**
```bash
./filecheck file1.txt file2.txt
# file1.txt: OK
# file2.txt: MISSING
# (exit code 1)

./filecheck --quiet file1.txt && echo "All files exist"
```

<details>
<summary>Solution</summary>

```go
package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	quiet := flag.Bool("quiet", false, "Suppress output")
	flag.Parse()

	files := flag.Args()

	if len(files) == 0 {
		fmt.Fprintln(os.Stderr, "Usage: filecheck [--quiet] file1 [file2 ...]")
		os.Exit(2)
	}

	allExist := true

	for _, file := range files {
		_, err := os.Stat(file)
		exists := err == nil

		if !exists {
			allExist = false
		}

		if !*quiet {
			if exists {
				fmt.Printf("%s: OK\n", file)
			} else {
				fmt.Printf("%s: MISSING\n", file)
			}
		}
	}

	if allExist {
		os.Exit(0)
	} else {
		os.Exit(1)
	}
}
```

**Explanation:** We use `flag.Args()` to get positional arguments after all flags. `os.Stat()` checks if a file exists.

</details>

---

### Exercise 3: Environment Printer

**Difficulty:** Easy
**Time:** ~10 minutes

**Goal:** Print environment variables with filtering.

**Requirements:**
1. Print all environment variables by default
2. Support `--prefix` flag to filter by prefix
3. Support `--format` flag with options: `plain` (default), `export`, `json`

<details>
<summary>Solution</summary>

```go
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"strings"
)

func main() {
	prefix := flag.String("prefix", "", "Filter by prefix")
	format := flag.String("format", "plain", "Output format: plain, export, json")
	flag.Parse()

	vars := make(map[string]string)

	for _, env := range os.Environ() {
		parts := strings.SplitN(env, "=", 2)
		key, value := parts[0], parts[1]

		if *prefix == "" || strings.HasPrefix(key, *prefix) {
			vars[key] = value
		}
	}

	switch *format {
	case "plain":
		for k, v := range vars {
			fmt.Printf("%s=%s\n", k, v)
		}
	case "export":
		for k, v := range vars {
			fmt.Printf("export %s=%q\n", k, v)
		}
	case "json":
		data, _ := json.MarshalIndent(vars, "", "  ")
		fmt.Println(string(data))
	default:
		fmt.Fprintln(os.Stderr, "Unknown format:", *format)
		os.Exit(2)
	}
}
```

</details>

---

## Common Mistakes

Avoid these common pitfalls when building CLI applications.

### Mistake 1: Writing Errors to stdout

**The Problem:**
```go
// Wrong: errors go to stdout
fmt.Println("Error: file not found")
```

**The Fix:**
```go
// Correct: errors go to stderr
fmt.Fprintln(os.Stderr, "Error: file not found")
```

**Why This Matters:** When users pipe your output, errors will corrupt their data. Always use stderr for errors.

---

### Mistake 2: Forgetting Exit Codes

**The Problem:**
```go
if err != nil {
	fmt.Fprintln(os.Stderr, "Error:", err)
	return // Just returns, exit code is 0!
}
```

**The Fix:**
```go
if err != nil {
	fmt.Fprintln(os.Stderr, "Error:", err)
	os.Exit(1) // Proper error exit code
}
```

**Why This Matters:** Scripts rely on exit codes to determine success. A zero exit code after an error breaks automation.

---

### Mistake 3: Hardcoding Program Name

**The Problem:**
```go
fmt.Println("Usage: myapp [options]")
```

**The Fix:**
```go
fmt.Printf("Usage: %s [options]\n", os.Args[0])
```

**Why This Matters:** Users might rename your binary. Using `os.Args[0]` shows the actual command they used.

---

## Summary

In this chapter, you learned:

- **Why Go excels at CLI development:** Single binaries, fast startup, easy cross-compilation, and a strong standard library make Go ideal for command-line tools.

- **CLI application anatomy:** Commands, subcommands, flags, and arguments form the structure. Stdin, stdout, and stderr handle I/O. Exit codes communicate success or failure.

- **Practical implementation:** Using the `flag` package, handling input/output correctly, and following Unix conventions.

### Key Takeaways

1. Go's single-binary output eliminates deployment complexity
2. Always write errors to stderr, output to stdout
3. Exit codes are contracts with the shell—respect them
4. The `flag` package handles basic needs; Cobra awaits for complex CLIs

---

## What's Next

You now understand the foundations of CLI development in Go. In Chapter 2, we'll dive deeper into argument and flag parsing, exploring positional arguments, custom flag types, and handling complex input scenarios. Then in Chapter 3, we'll introduce Cobra—the framework that powers Kubernetes, Docker, and hundreds of other production CLI tools.

---

## Further Reading

- [Go flag package documentation](https://pkg.go.dev/flag)
- [The Art of Unix Programming - Command-Line Interface Design](http://www.catb.org/~esr/writings/taoup/html/ch11s06.html)
- [12 Factor CLI Apps](https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46)
