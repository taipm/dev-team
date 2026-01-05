---
name: "5why"
description: "5-Why Auto Analyzer - Phân tích nguyên nhân gốc rễ tự động sử dụng Ollama"
---

# 5-Why Auto Analyzer

Kích hoạt agent phân tích 5-Why tự động.

## Cách sử dụng

Khi user invoke skill này, thực hiện:

1. **Check Ollama service**:
```bash
/Users/taipm/GitHub/dev-team/.microai/skills/development-skills/ollama/scripts/ollama-check.sh --model qwen3:1.7b
```

2. **Lấy problem từ user**:
- Nếu có `$ARGUMENTS`: Sử dụng làm problem statement
- Nếu không có: Hỏi user nhập problem cần phân tích

3. **Chạy phân tích tự động**:
```bash
/Users/taipm/GitHub/dev-team/.microai/agents/ollama-auto-agent/scripts/5why-loop.sh --problem "$PROBLEM"
```

4. **Hiển thị kết quả**: Đọc report file và tóm tắt cho user

## Options

- `--model`: Chọn model Ollama (default: qwen3:1.7b)
- `--max-depth`: Số iteration tối đa (default: 20)

## Examples

```
/microai:5why Website load chậm
/microai:5why --model qwen3:8b Deploy thất bại liên tục
/microai:5why Khách hàng phàn nàn về chất lượng sản phẩm
```

## Workflow

```
User Input → Check Ollama → Run 5-Why Loop → Display Results
                              ↓
                        [Automatic loop]
                        Why #1 → Answer → Evaluate
                        Why #2 → Answer → Evaluate
                        ...
                        → Root Cause Found
                        → Generate Report
```

## Arguments

$ARGUMENTS
