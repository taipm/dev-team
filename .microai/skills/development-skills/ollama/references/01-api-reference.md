# Ollama API Reference

## Overview

Ollama provides both CLI and REST API for local LLM inference.

## CLI Commands

### Basic Commands

```bash
# Start service
ollama serve

# List models
ollama list

# Pull model
ollama pull <model>

# Run inference
ollama run <model> "<prompt>"

# Show model info
ollama show <model>

# Delete model
ollama rm <model>
```

### Inference Patterns

```bash
# Simple prompt
ollama run qwen3:1.7b "What is 2+2?"

# Multi-line prompt via stdin
echo "Explain recursion" | ollama run qwen3:1.7b

# Heredoc for complex prompts
ollama run qwen3:1.7b << 'EOF'
You are a translator.
Translate to Vietnamese: Hello world
EOF
```

## REST API

### Endpoint

```
Default: http://localhost:11434
```

### Generate

```bash
curl http://localhost:11434/api/generate -d '{
  "model": "qwen3:1.7b",
  "prompt": "Why is the sky blue?",
  "stream": false
}'
```

### Chat

```bash
curl http://localhost:11434/api/chat -d '{
  "model": "qwen3:1.7b",
  "messages": [
    {"role": "system", "content": "You are a helpful assistant"},
    {"role": "user", "content": "Hello!"}
  ],
  "stream": false
}'
```

### List Models

```bash
curl http://localhost:11434/api/tags
```

### Pull Model

```bash
curl http://localhost:11434/api/pull -d '{
  "name": "qwen3:1.7b"
}'
```

## Response Format

### Generate Response

```json
{
  "model": "qwen3:1.7b",
  "created_at": "2024-01-01T00:00:00Z",
  "response": "The sky is blue because...",
  "done": true,
  "context": [...],
  "total_duration": 1234567890,
  "load_duration": 123456789,
  "prompt_eval_count": 10,
  "eval_count": 50
}
```

### Streaming Response

Each chunk:
```json
{"model":"qwen3:1.7b","response":"The","done":false}
{"model":"qwen3:1.7b","response":" sky","done":false}
{"model":"qwen3:1.7b","response":"","done":true}
```

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| Connection refused | Service not running | `ollama serve` |
| Model not found | Model not pulled | `ollama pull <model>` |
| Timeout | Large response | Increase timeout or use streaming |
| Out of memory | Model too large | Use smaller model |

## Environment Variables

```bash
OLLAMA_HOST=0.0.0.0          # Bind address
OLLAMA_ORIGINS=*             # CORS origins
OLLAMA_MODELS=/path/to/models # Model storage path
OLLAMA_KEEP_ALIVE=5m         # Model memory retention
```

## Performance Tips

1. **Model Loading**: First request loads model (~5-10s), subsequent requests are faster
2. **Keep Alive**: Models stay in memory for 5 minutes by default
3. **Streaming**: Use streaming for better UX on long responses
4. **GPU**: Ollama auto-detects GPU for acceleration

## Integration Examples

### Python

```python
import subprocess

def ollama_run(model: str, prompt: str) -> str:
    result = subprocess.run(
        ["ollama", "run", model],
        input=prompt,
        capture_output=True,
        text=True
    )
    return result.stdout

response = ollama_run("qwen3:1.7b", "Hello!")
```

### Bash Function

```bash
ollama_infer() {
    local model="${1:-qwen3:1.7b}"
    local prompt="$2"
    echo "$prompt" | ollama run "$model"
}

ollama_infer "qwen3:1.7b" "Explain Python decorators"
```
