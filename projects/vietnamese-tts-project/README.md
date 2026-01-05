# Vietnamese TTS - Custom Voice Training

Tạo model Text-to-Speech tiếng Việt từ giọng nói cá nhân, chạy trên macOS M1.

## Quick Start

```bash
# 1. Setup environment
conda create --name vn-tts python=3.10
conda activate vn-tts
pip install -r requirements.txt

# 2. Copy MP3 files vào mp3_files/
cp /path/to/your/*.mp3 ./mp3_files/

# 3. Convert MP3 → WAV
python scripts/convert_audio.py

# 4. Auto-transcribe
python scripts/auto_transcribe.py

# 5. Create dataset
python scripts/create_metadata.py

# 6. Fine-tune (see Training section)

# 7. Inference
python scripts/inference.py --text "Xin chào!"
```

## Project Structure

```
vietnamese-tts-project/
├── mp3_files/              # File MP3 gốc của bạn
├── dataset/
│   ├── wavs/               # WAV files đã xử lý
│   ├── metadata_train.csv
│   └── metadata_eval.csv
├── transcripts.txt         # Nội dung text của mỗi audio
├── scripts/
│   ├── convert_audio.py    # MP3 → WAV conversion
│   ├── auto_transcribe.py  # Whisper transcription
│   ├── create_metadata.py  # Dataset preparation
│   └── inference.py        # TTS inference
├── F5-TTS-Vietnamese/      # Training framework
│   └── checkpoints/
│       └── my_voice/       # Fine-tuned model
└── outputs/                # Generated audio
```

## Installation

### 1. Create Environment

```bash
# Tạo conda environment
conda create --name vn-tts python=3.10
conda activate vn-tts

# Cài PyTorch cho M1
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu

# Cài requirements
pip install -r requirements.txt
```

### 2. Install F5-TTS-Vietnamese

```bash
git clone https://github.com/nguyenthienhy/F5-TTS-Vietnamese.git
cd F5-TTS-Vietnamese
pip install -r requirements.txt
cd ..
```

## Usage

### Step 1: Convert MP3 to WAV

```bash
# Copy MP3 files vào mp3_files/
cp /path/to/your/audio/*.mp3 ./mp3_files/

# Convert với default settings (24kHz, normalized)
python scripts/convert_audio.py

# Hoặc custom settings
python scripts/convert_audio.py \
    --input ./mp3_files \
    --output ./dataset/wavs \
    --sample-rate 24000 \
    --workers 4
```

### Step 2: Auto-Transcribe

```bash
# Transcribe với faster-whisper (khuyến nghị)
python scripts/auto_transcribe.py

# Options
python scripts/auto_transcribe.py \
    --input ./dataset/wavs \
    --output ./transcripts.txt \
    --model medium \
    --language vi
```

**Thời gian ước tính (60 phút audio, M1):**
| Model | faster-whisper |
|-------|----------------|
| tiny | ~4 phút |
| small | ~8 phút |
| medium | ~15 phút |
| large | ~30 phút |

### Step 3: Review Transcripts (Optional)

```bash
# Xem 20 transcripts đầu tiên
python scripts/create_metadata.py --review

# Sửa lỗi trong transcripts.txt nếu cần
nano transcripts.txt
```

### Step 4: Create Dataset

```bash
python scripts/create_metadata.py

# Output:
# - dataset/metadata_train.csv (90%)
# - dataset/metadata_eval.csv (10%)
```

### Step 5: Fine-tune Model

```bash
cd F5-TTS-Vietnamese

python train.py \
    --output_path ./checkpoints/my_voice \
    --train_csv_path ../dataset/metadata_train.csv \
    --eval_csv_path ../dataset/metadata_eval.csv \
    --language "vi" \
    --num_epochs 10 \
    --batch_size 4 \
    --lr 1e-5

# Monitor training
tensorboard --logdir ./checkpoints/my_voice/logs
```

**Tham số training cho M1:**
- `batch_size`: 4 (giảm xuống 2 nếu hết RAM)
- `num_epochs`: 5-10
- Thời gian: 4-8 giờ

### Step 6: Inference

```bash
# Single text
python scripts/inference.py --text "Xin chào, tôi là AI."

# Batch từ file
python scripts/inference.py --batch texts.txt --output outputs/

# Interactive mode
python scripts/inference.py --interactive

# Với fine-tuned model
python scripts/inference.py \
    --model F5-TTS-Vietnamese/checkpoints/my_voice/best_model.pth \
    --text "Đây là giọng nói của tôi."

# Voice cloning (với reference audio)
python scripts/inference.py \
    --text "Text cần đọc" \
    --ref-audio ./dataset/wavs/sample.wav \
    --ref-text "Nội dung trong sample.wav"
```

## Troubleshooting

| Vấn đề | Giải pháp |
|--------|-----------|
| Out of memory | Giảm `batch_size` xuống 2 |
| MPS không hoạt động | Dùng `--device cpu` |
| PyTorch lỗi CUDA | Cài lại từ CPU index |
| Training quá chậm | Dùng cloud GPU (Colab/Kaggle) |
| Whisper chậm | Dùng `faster-whisper` thay vì `openai-whisper` |

## Tips

1. **Audio quality**: Đảm bảo audio gốc không có nhiễu, echo
2. **Transcript accuracy**: Review và sửa lỗi transcript trước khi training
3. **Data amount**: 60+ phút audio cho kết quả tốt nhất
4. **Training overnight**: Chạy training qua đêm để tiết kiệm thời gian

## Resources

- [F5-TTS-Vietnamese](https://github.com/nguyenthienhy/F5-TTS-Vietnamese)
- [faster-whisper](https://github.com/SYSTRAN/faster-whisper)
- [F5-TTS-Vietnamese-100h Model](https://huggingface.co/hynt/F5-TTS-Vietnamese-100h)
