# Hướng Dẫn Cài Đặt Công Cụ AI YouTube Automation

> **Dự án:** AI YouTube Automation v2.0
> **Cập nhật:** 04/01/2026
> **Đối tượng:** Free Tier Only

---

## Mục Lục

1. [ChatGPT Free](#1-chatgpt-free)
2. [Edge-TTS](#2-edge-tts)
3. [CapCut](#3-capcut)
4. [Canva Free](#4-canva-free)
5. [Pexels/Pixabay](#5-pexelspixabay)
6. [YouTube Studio](#6-youtube-studio)

---

## 1. ChatGPT Free

### Mục đích sử dụng
- Tạo ý tưởng video (Ideas)
- Viết kịch bản (Script)
- Tối ưu SEO (Tags, Description, Title)

### Giới hạn Free Tier
| Thông số | Giới hạn |
|----------|----------|
| Tin nhắn/ngày | ~50 messages |
| Model | GPT-4o mini |
| Context window | 8K tokens |
| File upload | Không hỗ trợ |

### Các bước cài đặt

#### Bước 1: Đăng ký tài khoản
1. Truy cập [chat.openai.com](https://chat.openai.com)
2. Click **Sign up**
3. Đăng ký bằng:
   - Email + Password
   - Google Account (khuyến nghị)
   - Microsoft Account
4. Xác nhận email và hoàn tất profile

#### Bước 2: Tạo Custom Instructions
1. Vào **Settings** > **Personalization**
2. Bật **Custom instructions**
3. Điền thông tin:

**What would you like ChatGPT to know about you?**
```
Tôi là content creator YouTube Việt Nam, niche Giáo dục/Kiến thức.
Target audience: Người Việt 18-35 tuổi, quan tâm self-improvement.
Phong cách: Faceless video, giọng nói AI, nội dung giá trị.
```

**How would you like ChatGPT to respond?**
```
- Viết script bằng tiếng Việt có dấu, dễ đọc cho TTS
- Câu ngắn gọn, 10-15 từ/câu
- Không dùng từ lóng, emoji trong script
- Cung cấp hook mạnh đầu video
- Kết thúc bằng CTA rõ ràng
```

#### Bước 3: Lưu Prompt Templates

**Template 1: Script Generator**
```
Viết script YouTube 8-10 phút về chủ đề: [CHỦ ĐỀ]

Yêu cầu:
1. Hook 15 giây đầu gây tò mò
2. Intro ngắn 30 giây
3. 5-7 điểm chính, mỗi điểm 1-1.5 phút
4. Kết luận + CTA subscribe
5. Không dùng emoji, ký hiệu đặc biệt
6. Câu ngắn, dễ đọc cho TTS
```

**Template 2: SEO Optimizer**
```
Tối ưu SEO cho video YouTube:
Tiêu đề gốc: [TIÊU ĐỀ]
Nội dung: [TÓM TẮT NỘI DUNG]

Yêu cầu:
1. 5 tiêu đề thay thế (50-60 ký tự, có keyword)
2. Description 200 từ với timestamps
3. 15 tags liên quan (mix high/low competition)
4. 3 hashtags chính
```

**Template 3: Ideas Generator**
```
Tạo 10 ý tưởng video YouTube về [CHUYÊN MỤC]

Yêu cầu mỗi ý tưởng:
- Tiêu đề hấp dẫn
- Target audience cụ thể
- Đánh giá độ khó (1-5)
- Estimated views potential
```

---

## 2. Edge-TTS

### Mục đích sử dụng
- Chuyển script thành giọng nói tiếng Việt
- Tạo voiceover chất lượng cao miễn phí

### Giới hạn Free Tier
| Thông số | Giới hạn |
|----------|----------|
| Số ký tự | Unlimited |
| Voices | 400+ giọng |
| Vietnamese voices | 4 giọng |
| Tốc độ | Adjustable |
| Output format | MP3, WAV |

### Vietnamese Voices Available
| Voice ID | Giới tính | Đặc điểm |
|----------|-----------|----------|
| vi-VN-HoaiMyNeural | Nữ | Trẻ, năng động |
| vi-VN-NamMinhNeural | Nam | Trưởng thành, chuyên nghiệp |

### Các bước cài đặt

#### Bước 1: Cài đặt Python
1. Tải Python từ [python.org](https://python.org)
2. Chọn phiên bản 3.9+
3. Tick **Add Python to PATH** khi cài đặt
4. Kiểm tra:
```bash
python --version
```

#### Bước 2: Cài đặt edge-tts
```bash
pip install edge-tts
```

#### Bước 3: Kiểm tra voices tiếng Việt
```bash
edge-tts --list-voices | grep vi-VN
```

Output:
```
vi-VN-HoaiMyNeural
vi-VN-NamMinhNeural
```

#### Bước 4: Tạo audio từ script

**Cách 1: Command Line**
```bash
edge-tts --voice vi-VN-NamMinhNeural --text "Xin chào các bạn" --write-media output.mp3
```

**Cách 2: Python Script (khuyến nghị)**
```python
import edge_tts
import asyncio

async def create_audio(text, output_file, voice="vi-VN-NamMinhNeural"):
    """Tạo audio từ text"""
    communicate = edge_tts.Communicate(text, voice)
    await communicate.save(output_file)
    print(f"Đã lưu: {output_file}")

# Sử dụng
script = """
Xin chào các bạn, chào mừng đến với kênh của mình.
Hôm nay chúng ta sẽ tìm hiểu về 5 thói quen của người thành công.
"""

asyncio.run(create_audio(script, "video_01.mp3"))
```

#### Bước 5: Batch Processing Script
```python
import edge_tts
import asyncio
import os

async def batch_tts(scripts_folder, output_folder, voice="vi-VN-NamMinhNeural"):
    """Xử lý batch nhiều script"""
    os.makedirs(output_folder, exist_ok=True)

    for filename in os.listdir(scripts_folder):
        if filename.endswith('.txt'):
            input_path = os.path.join(scripts_folder, filename)
            output_path = os.path.join(output_folder, filename.replace('.txt', '.mp3'))

            with open(input_path, 'r', encoding='utf-8') as f:
                text = f.read()

            communicate = edge_tts.Communicate(text, voice)
            await communicate.save(output_path)
            print(f"Done: {filename} -> {output_path}")

# Chạy batch
asyncio.run(batch_tts("scripts/", "audio/"))
```

---

## 3. CapCut

### Mục đích sử dụng
- Chỉnh sửa video
- Ghép audio + video footage
- Thêm captions/subtitles tự động
- Export video chất lượng cao

### Giới hạn Free Tier
| Thông số | Giới hạn |
|----------|----------|
| Export quality | 4K |
| Watermark | Không có |
| Cloud storage | 1GB |
| Auto captions | Có (tiếng Việt) |
| Templates | Limited |

### Các bước cài đặt

#### Bước 1: Tải và cài đặt
1. Truy cập [capcut.com](https://www.capcut.com)
2. Tải phiên bản Desktop (Windows/Mac)
3. Cài đặt và đăng nhập bằng:
   - TikTok account
   - Email
   - Google/Facebook

#### Bước 2: Cấu hình Project Settings
1. Tạo **New Project**
2. Cài đặt:
   - Resolution: **1080p (1920x1080)** - YouTube standard
   - Frame rate: **30fps**
   - Aspect ratio: **16:9** (video thường) hoặc **9:16** (Shorts)

#### Bước 3: Import Assets
```
Thư mục dự án khuyến nghị:
project/
├── audio/          # Voice-over từ Edge-TTS
├── footage/        # Stock video từ Pexels
├── music/          # Background music
├── thumbnails/     # Từ Canva
└── exports/        # Video hoàn chỉnh
```

#### Bước 4: Workflow cơ bản

1. **Import Audio** (voice-over)
   - Kéo file MP3 vào timeline
   - Đặt vào Audio track

2. **Thêm Stock Footage**
   - Import video clips từ Pexels
   - Đặt vào Video track phía trên
   - Cắt ghép theo audio

3. **Auto Captions**
   - Vào **Text** > **Auto Captions**
   - Chọn ngôn ngữ: **Vietnamese**
   - Click **Create**
   - Chỉnh sửa nếu cần

4. **Thêm Transitions**
   - **Transitions** tab
   - Khuyến nghị: Fade, Dissolve (nhẹ nhàng)
   - Duration: 0.3-0.5s

5. **Background Music**
   - Import nhạc nền
   - Giảm volume: 10-20%
   - Fade in/out ở đầu/cuối

#### Bước 5: Export Settings
```
Format: MP4
Resolution: 1080p
Frame rate: 30fps
Bitrate: 15-20 Mbps (High quality)
```

---

## 4. Canva Free

### Mục đích sử dụng
- Tạo thumbnails hấp dẫn
- Tạo assets đồ họa cho video
- Brand kit đơn giản

### Giới hạn Free Tier
| Thông số | Giới hạn |
|----------|----------|
| Designs | Unlimited |
| Templates | 250,000+ |
| Storage | 5GB |
| Brand Kit | 1 kit, 3 colors |
| Background remover | Không có |
| Premium elements | Không có |

### Các bước cài đặt

#### Bước 1: Đăng ký tài khoản
1. Truy cập [canva.com](https://www.canva.com)
2. Đăng ký bằng Google (khuyến nghị)
3. Chọn mục đích: **Content Creator**

#### Bước 2: Tạo YouTube Thumbnail Template

1. Click **Create a design**
2. Tìm **YouTube Thumbnail** (1280 x 720 px)
3. Tạo master template:

**Thành phần thumbnail hiệu quả:**
```
+-------------------------------------------+
|  [HÌNH ẢNH NỀN]                           |
|                                           |
|  +------------------------+               |
|  |   TIÊU ĐỀ LỚN        |   [ICON/       |
|  |   (2-4 từ)           |    ELEMENT]    |
|  +------------------------+               |
|                                           |
|  [SUBTEXT NHỎ]                           |
+-------------------------------------------+
```

#### Bước 3: Thiết lập Brand Kit

1. Vào **Brand Hub** > **Brand Kit**
2. Thêm:
   - **Logo**: Upload logo kênh
   - **Colors**: 3 màu chính (VD: #FF0000, #FFFFFF, #000000)
   - **Fonts**: Chọn 2 fonts (Heading + Body)

#### Bước 4: Tạo Thumbnail Template Gallery

Tạo 5-10 template styles khác nhau:

| Style | Mô tả | Use case |
|-------|-------|----------|
| Bold Text | Chữ to, nền gradient | Tips, How-to |
| Face + Text | (Faceless thay = icon) | Storytelling |
| Numbered | "5 Cách...", "7 Bí quyết..." | Listicle |
| Before/After | Split layout | Comparison |
| Question | Dấu ? lớn | Curiosity gap |

#### Bước 5: Export Settings
```
File type: PNG (chất lượng cao nhất)
Size: 1280 x 720 px
Quality: Highest
```

---

## 5. Pexels/Pixabay

### Mục đích sử dụng
- Stock footage cho video
- Hình ảnh minh họa
- Nhạc nền miễn phí

### Giới hạn
| Thông số | Pexels | Pixabay |
|----------|--------|---------|
| License | Free, no attribution | Free, no attribution |
| Videos | 4K available | 4K available |
| Photos | Unlimited | Unlimited |
| Music | Có | Có |
| API | Có | Có |

### Các bước cài đặt

#### Bước 1: Đăng ký tài khoản
1. **Pexels**: [pexels.com](https://www.pexels.com) - Sign up
2. **Pixabay**: [pixabay.com](https://pixabay.com) - Join

#### Bước 2: Tìm kiếm hiệu quả

**Keywords tiếng Anh cho niche Giáo dục:**
```
- Productivity, success, motivation
- Business, office, teamwork
- Nature, peaceful, meditation
- Technology, coding, computer
- Books, reading, library
- Fitness, healthy lifestyle
- City, urban, modern life
```

#### Bước 3: Tải video theo batch

**Tổ chức thư mục:**
```
footage/
├── productivity/
│   ├── typing_laptop_01.mp4
│   └── planning_notes_01.mp4
├── success/
│   ├── celebration_01.mp4
│   └── achievement_01.mp4
├── nature/
│   ├── sunrise_01.mp4
│   └── forest_peaceful_01.mp4
└── transitions/
    ├── light_leak_01.mp4
    └── blur_01.mp4
```

#### Bước 4: Sử dụng Pexels API (Optional)
```python
import requests
import os

PEXELS_API_KEY = "YOUR_API_KEY"  # Lấy từ pexels.com/api

def search_videos(query, per_page=10):
    """Tìm kiếm video trên Pexels"""
    headers = {"Authorization": PEXELS_API_KEY}
    url = f"https://api.pexels.com/videos/search?query={query}&per_page={per_page}"

    response = requests.get(url, headers=headers)
    return response.json()

# Tìm video về productivity
videos = search_videos("productivity")
for video in videos['videos']:
    print(f"ID: {video['id']}, Duration: {video['duration']}s")
```

---

## 6. YouTube Studio

### Mục đích sử dụng
- Upload và quản lý video
- Xem analytics
- Quản lý comments
- Monetization settings

### Các bước cài đặt

#### Bước 1: Tạo YouTube Channel
1. Đăng nhập Google Account
2. Truy cập [studio.youtube.com](https://studio.youtube.com)
3. Click **Create a channel**
4. Chọn **Use a custom name**
5. Đặt tên kênh phù hợp với niche

#### Bước 2: Channel Settings cơ bản

**Branding:**
- Profile picture: 800x800 px
- Banner: 2560x1440 px
- Video watermark: 150x150 px

**Basic info:**
- Channel description (có keywords)
- Links (social media, website)
- Contact email

#### Bước 3: Default Upload Settings

Vào **Settings** > **Upload defaults**:

**Title:**
```
[Chủ đề] - [Benefit/Hook]
```

**Description template:**
```
[HOOK - 2 dòng đầu quan trọng nhất]

TIMESTAMPS:
00:00 - Intro
01:00 - Điểm 1
...

TRONG VIDEO NÀY:
[Tóm tắt nội dung 3-5 dòng]

TÀI LIỆU LIÊN QUAN:
[Links nếu có]

ĐỪNG QUÊN:
- SUBSCRIBE và bấm chuông để không bỏ lỡ video mới
- LIKE nếu video hữu ích
- COMMENT chia sẻ ý kiến của bạn

#keyword1 #keyword2 #keyword3
```

**Tags template:**
```
self improvement, phát triển bản thân, thói quen tốt,
productivity, năng suất, thành công, motivation
```

#### Bước 4: Playlist Strategy

Tạo playlists theo chủ đề:
```
Phát triển bản thân
   ├── Thói quen buổi sáng
   ├── Quản lý thời gian
   └── Tư duy tích cực

Kỹ năng sống
   ├── Giao tiếp hiệu quả
   ├── Ra quyết định
   └── Học cách học

Sức khỏe & Wellness
   ├── Ngủ ngon
   ├── Tập thể dục
   └── Mindfulness
```

#### Bước 5: Analytics Tracking

Metrics quan trọng theo dõi hàng tuần:
| Metric | Mục tiêu | Ghi chú |
|--------|----------|---------|
| Views | +20%/tuần | So với tuần trước |
| Watch time | >50% | Average percentage viewed |
| CTR | >5% | Click-through rate |
| Subscribers | +50/tuần | Net subscribers |
| Comments | >10/video | Engagement signal |

---

## Checklist Hoàn Thành Setup

- [ ] ChatGPT account + Custom Instructions
- [ ] Python + edge-tts installed
- [ ] CapCut Desktop installed & configured
- [ ] Canva account + Thumbnail templates
- [ ] Pexels/Pixabay accounts + Initial footage library
- [ ] YouTube Channel created & branded
- [ ] Upload defaults configured
- [ ] Playlists created
- [ ] All tools tested with sample content

---

**Tài liệu liên quan:**
- [Pipeline Architecture](./pipeline-architecture.md)
- [Phase 1 Breakdown](../03-planning/phase-1-breakdown.md)
- [OPPM](../01-oppm/oppm.md)
