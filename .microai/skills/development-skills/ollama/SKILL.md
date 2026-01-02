---
name: ollama
description: "Local LLM integration via Ollama. Use when agents need local AI inference without external API calls. Supports multiple models (qwen3, llama, codellama, mistral), streaming, configurable timeouts. Perfect for translation, code generation, text analysis tasks."
description_vi: "Tích hợp LLM local qua Ollama. Sử dụng khi agents cần inference AI local không cần gọi API bên ngoài. Hỗ trợ nhiều models, streaming, timeout tùy chỉnh."
license: apache-2.0
version: "1.0.0"
tags: [llm, ollama, local, inference, ai, translation, code-generation]
category: development-skills
created: "2026-01-02"
author: MicroAI Team
---

# Ollama Skill

> Local LLM inference for MicroAI agents - no API keys required.

## Quick Start

```bash
# 1. Check Ollama is running
./scripts/ollama-check.sh

# 2. Run inference
./scripts/ollama-run.sh --prompt "Explain recursion simply"

# 3. With specific model
./scripts/ollama-run.sh --model llama3.2 --prompt "Write a Python function"
```

## Prerequisites

- Ollama installed: https://ollama.ai
- Ollama service running: `ollama serve`
- At least one model pulled: `ollama pull qwen3:1.7b`

## Scripts Reference

### ollama-check.sh - Health Check

Verify Ollama service and model availability.

```bash
# Check service only
./scripts/ollama-check.sh
# Exit: 0=OK, 1=service down

# Check specific model
./scripts/ollama-check.sh --model qwen3:1.7b
# Exit: 0=OK, 1=service down, 2=model not found

# Verbose output
./scripts/ollama-check.sh --model qwen3:1.7b --verbose
```

### ollama-run.sh - Inference

Execute prompts with Ollama models.

```bash
# Basic usage (default: qwen3:1.7b)
./scripts/ollama-run.sh --prompt "Hello, who are you?"

# Specify model
./scripts/ollama-run.sh --model codellama --prompt "Write bubble sort"

# From stdin (for long prompts)
cat prompt.txt | ./scripts/ollama-run.sh --model qwen3:1.7b

# With system prompt
./scripts/ollama-run.sh --system "You are a translator" --prompt "Translate to Vietnamese: Hello"

# Custom timeout (default: 120s)
./scripts/ollama-run.sh --timeout 300 --prompt "Long analysis..."

# JSON output mode
./scripts/ollama-run.sh --json --prompt "List 3 colors as JSON array"
```

### ollama-models.sh - Model Management

List, pull, and inspect models.

```bash
# List available models
./scripts/ollama-models.sh list

# Pull a model
./scripts/ollama-models.sh pull qwen3:1.7b

# Show model info
./scripts/ollama-models.sh info qwen3:1.7b

# Delete a model
./scripts/ollama-models.sh delete qwen3:1.7b
```

## Integration Patterns

### Pattern 1: Translation Agent

```bash
# Check prerequisites
./scripts/ollama-check.sh --model qwen3:1.7b || exit 1

# Translate
./scripts/ollama-run.sh \
  --model qwen3:1.7b \
  --system "You are EN→VI translator. Output only translation." \
  --prompt "Translate: $CONTENT"
```

### Pattern 2: Code Generation

```bash
# Use codellama for code tasks
./scripts/ollama-run.sh \
  --model codellama \
  --system "You are a coding assistant. Output only code." \
  --prompt "Write Python function to parse JSON"
```

### Pattern 3: Batch Processing

```bash
# Process multiple prompts
for file in prompts/*.txt; do
  cat "$file" | ./scripts/ollama-run.sh --model qwen3:1.7b > "outputs/$(basename $file)"
done
```

### Pattern 4: Error Handling

```bash
# Check service first
if ! ./scripts/ollama-check.sh --model qwen3:1.7b; then
  echo "Ollama not ready. Run: ollama serve && ollama pull qwen3:1.7b"
  exit 1
fi

# Run with error capture
result=$(./scripts/ollama-run.sh --prompt "$PROMPT" 2>&1)
if [ $? -ne 0 ]; then
  echo "Inference failed: $result"
  exit 1
fi
```

## Recommended Models

| Model | Size | Best For | Speed |
|-------|------|----------|-------|
| qwen3:1.7b | ~1.7GB | Translation, general tasks | Fast |
| qwen3:8b | ~8GB | Complex reasoning | Medium |
| codellama | ~4GB | Code generation | Medium |
| llama3.2 | ~2GB | General, multilingual | Fast |
| mistral | ~4GB | Reasoning, analysis | Medium |

## Configuration

Default model can be overridden via environment:

```bash
export OLLAMA_DEFAULT_MODEL="qwen3:1.7b"
export OLLAMA_DEFAULT_TIMEOUT="120"
export OLLAMA_ENDPOINT="http://localhost:11434"
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "connection refused" | Start Ollama: `ollama serve` |
| "model not found" | Pull model: `ollama pull qwen3:1.7b` |
| Slow response | Use smaller model or increase timeout |
| Empty response | Check prompt format, try without --json |
| Out of memory | Use smaller model (1.7b instead of 8b) |

## References

- `references/01-api-reference.md` - Detailed API patterns
- `references/02-models-guide.md` - Model selection guide
