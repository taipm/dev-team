# Ollama Models Guide

## Recommended Models

### General Purpose

| Model | Size | Memory | Speed | Best For |
|-------|------|--------|-------|----------|
| qwen3:1.7b | 1.7B | ~2GB | Fast | Translation, quick tasks |
| llama3.2 | 3B | ~3GB | Fast | General, multilingual |
| qwen3:8b | 8B | ~8GB | Medium | Complex reasoning |
| mistral | 7B | ~7GB | Medium | Analysis, writing |

### Code Generation

| Model | Size | Memory | Speed | Best For |
|-------|------|--------|-------|----------|
| codellama | 7B | ~7GB | Medium | Code completion, generation |
| codellama:13b | 13B | ~13GB | Slow | Complex code tasks |
| deepseek-coder | 6.7B | ~7GB | Medium | Code review, refactoring |

### Specialized

| Model | Size | Memory | Speed | Best For |
|-------|------|--------|-------|----------|
| phi3 | 3.8B | ~4GB | Fast | Reasoning, math |
| llava | 7B | ~8GB | Slow | Image understanding |
| nomic-embed-text | 137M | ~200MB | Very Fast | Text embeddings |

## Model Selection Guide

### By Task

```
Translation/Quick Tasks → qwen3:1.7b
General Assistant → llama3.2 or mistral
Code Generation → codellama
Complex Reasoning → qwen3:8b or mistral
Math/Logic → phi3
```

### By Hardware

```
8GB RAM → qwen3:1.7b, llama3.2, phi3
16GB RAM → mistral, codellama, qwen3:8b
32GB+ RAM → codellama:13b, larger models
```

### By Speed Priority

```
Fastest → qwen3:1.7b (~1-2s first token)
Fast → llama3.2, phi3 (~2-3s)
Medium → mistral, codellama (~3-5s)
Slow → 13B+ models (~5-10s)
```

## Model Variants

### Size Variants

```
model:1.7b  - Smallest, fastest
model:7b   - Balanced
model:13b  - Better quality
model:70b  - Best quality (needs GPU)
```

### Quantization

```
model:q4_0  - 4-bit, smallest
model:q4_K_M - 4-bit optimized
model:q5_K_M - 5-bit, balanced
model:q8_0  - 8-bit, best quality
model:fp16  - Full precision
```

## Installation Commands

### Quick Setup

```bash
# Install recommended models
ollama pull qwen3:1.7b      # General purpose
ollama pull codellama       # Code tasks
ollama pull llama3.2        # Multilingual
```

### Verify Installation

```bash
# List all models
ollama list

# Test model
ollama run qwen3:1.7b "Hello, can you hear me?"
```

## Memory Management

### Check Usage

```bash
# Model storage location
ls ~/.ollama/models

# Disk usage
du -sh ~/.ollama/models/*
```

### Clean Up

```bash
# Remove unused models
ollama rm <model-name>

# Keep only essential models
ollama rm mistral
ollama rm llama2
```

## Performance Optimization

### GPU Acceleration

Ollama auto-detects and uses:
- NVIDIA CUDA
- Apple Metal (M1/M2/M3)
- AMD ROCm

### Memory Settings

```bash
# Reduce model memory retention
OLLAMA_KEEP_ALIVE=1m ollama serve

# Pre-load model for faster first response
ollama run qwen3:1.7b ""
```

## Troubleshooting

### Slow First Response

- Normal: Models load into memory on first use (~5-10s)
- Solution: Pre-load model or use smaller model

### Out of Memory

- Cause: Model too large for available RAM
- Solution: Use smaller variant (1.7b instead of 7b)

### GPU Not Used

- Check: `ollama run --verbose <model> "test"`
- Verify: GPU drivers installed correctly
