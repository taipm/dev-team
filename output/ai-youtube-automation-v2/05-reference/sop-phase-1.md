# SOP Phase 1: Setup AI Stack

## AI YouTube Automation v2 - Thiết Lập Công Cụ AI

**Version:** 1.0
**Ngày tạo:** 2026-01-04
**Người phụ trách:** [Tên]
**Thời gian ước tính:** 2-3 ngày làm việc

---

## 1. Mục Tiêu

Thiết lập đầy đủ bộ công cụ AI cần thiết cho quy trình sản xuất video YouTube tự động, bao gồm:
- ChatGPT (tạo nội dung)
- Edge-TTS (chuyển văn bản thành giọng nói)
- CapCut (chỉnh sửa video)
- Canva (thiết kế thumbnail)

---

## 2. Prerequisites (Điều Kiện Tiên Quyết)

### 2.1 Yêu Cầu Phần Cứng
- [ ] Máy tính với RAM tối thiểu 8GB (khuyến nghị 16GB)
- [ ] Ổ cứng trống tối thiểu 50GB
- [ ] Kết nối Internet ổn định (tối thiểu 10Mbps)

### 2.2 Yêu Cầu Tài Khoản
- [ ] Email đã xác minh (Gmail khuyến nghị)
- [ ] Số điện thoại để xác thực 2 yếu tố
- [ ] Phương thức thanh toán (Visa/Mastercard) cho các gói trả phí

### 2.3 Kiến Thức Cơ Bản
- [ ] Hiểu biết cơ bản về YouTube Creator Studio
- [ ] Kỹ năng sử dụng máy tính cơ bản
- [ ] Tiếng Anh đọc hiểu cơ bản

---

## 3. Quy Trình Thực Hiện

### Bước 1: Thiết Lập ChatGPT

**Thời gian:** 30 phút

#### 1.1 Đăng Ký Tài Khoản OpenAI
1. Truy cập https://chat.openai.com
2. Click "Sign up"
3. Nhập email và tạo mật khẩu
4. Xác minh email qua link gửi về hộp thư
5. Hoàn tất thông tin profile

#### 1.2 Nâng Cấp ChatGPT Plus (Khuyến Nghị)
1. Đăng nhập vào ChatGPT
2. Click vào avatar góc trái > "My Plan"
3. Chọn "Upgrade to Plus" ($20/tháng)
4. Nhập thông tin thanh toán
5. Xác nhận đăng ký

#### 1.3 Cấu Hình Custom Instructions
1. Click avatar > Settings > Personalization
2. Trong phần "Custom instructions", nhập:
   - **What would you like ChatGPT to know about you?**
     ```
     Tôi là YouTube Content Creator, chuyên tạo video giáo dục/giải trí bằng tiếng Việt.
     Target audience: Người Việt 18-45 tuổi.
     Phong cách: Chuyên nghiệp nhưng gần gũi.
     ```
   - **How would you like ChatGPT to respond?**
     ```
     - Viết script video dạng narrative, dễ nghe
     - Sử dụng câu ngắn, rõ ràng
     - Có hook mở đầu hấp dẫn
     - Kết thúc có CTA (Call-to-Action)
     ```
3. Save settings

**Verification:**
- [ ] Có thể đăng nhập ChatGPT thành công
- [ ] Custom instructions đã được lưu
- [ ] Tạo thử 1 prompt và nhận response

---

### Bước 2: Thiết Lập Edge-TTS

**Thời gian:** 45 phút

#### 2.1 Cài Đặt Python (Nếu Chưa Có)
1. Truy cập https://www.python.org/downloads/
2. Tải Python 3.10 trở lên
3. Chạy installer, **tick "Add Python to PATH"**
4. Click "Install Now"
5. Verify bằng command: `python --version`

#### 2.2 Cài Đặt Edge-TTS
```bash
# Mở Terminal/Command Prompt
pip install edge-tts

# Kiểm tra cài đặt
edge-tts --list-voices
```

#### 2.3 Cấu Hình Voice Tiếng Việt
```bash
# Xem danh sách voice Việt Nam
edge-tts --list-voices | grep vi-VN

# Voice khuyến nghị:
# - vi-VN-HoaiMyNeural (Nữ - tự nhiên)
# - vi-VN-NamMinhNeural (Nam - chuyên nghiệp)
```

#### 2.4 Test Chuyển Đổi
```bash
# Test với văn bản mẫu
edge-tts --voice vi-VN-HoaiMyNeural --text "Xin chào, đây là video test của tôi" --write-media output_test.mp3

# Kiểm tra file output_test.mp3
```

**Verification:**
- [ ] Python đã cài đặt thành công
- [ ] edge-tts command hoạt động
- [ ] Tạo được file audio tiếng Việt

---

### Bước 3: Thiết Lập CapCut

**Thời gian:** 30 phút

#### 3.1 Cài Đặt CapCut Desktop
1. Truy cập https://www.capcut.com
2. Click "Download for Free"
3. Chạy installer và cài đặt
4. Mở CapCut và đăng nhập (TikTok/Google/Email)

#### 3.2 Cấu Hình Project Settings
1. Tạo Project mới
2. Settings > Project Settings:
   - Resolution: 1920x1080 (YouTube HD)
   - Frame Rate: 30fps
   - Aspect Ratio: 16:9
3. Save as Template

#### 3.3 Import Resource Pack
1. Vào tab "Templates"
2. Search "YouTube intro" / "transition"
3. Download các template cần thiết
4. Tổ chức vào folder riêng

#### 3.4 Thiết Lập Auto Captions
1. Vào tab "Text"
2. Chọn "Auto captions"
3. Chọn ngôn ngữ: Vietnamese
4. Test với video mẫu

**Verification:**
- [ ] CapCut đã cài đặt và đăng nhập
- [ ] Project settings đúng cấu hình
- [ ] Auto captions hoạt động với tiếng Việt

---

### Bước 4: Thiết Lập Canva

**Thời gian:** 30 phút

#### 4.1 Đăng Ký Tài Khoản Canva Pro
1. Truy cập https://www.canva.com
2. Sign up với Google/Email
3. Chọn "Canva Pro" trial hoặc mua ($12.99/tháng)
4. Xác nhận thanh toán

#### 4.2 Tạo Brand Kit
1. Vào "Brand Kit" trong sidebar
2. Thêm Brand colors:
   - Primary: [Màu chủ đạo của kênh]
   - Secondary: [Màu phụ]
   - Accent: [Màu nhấn]
3. Upload Logo kênh
4. Chọn Font chữ thống nhất:
   - Heading: Montserrat Bold
   - Body: Open Sans

#### 4.3 Tạo Template Thumbnail
1. Click "Create design" > YouTube Thumbnail (1280x720)
2. Thiết kế template cơ bản:
   - Vùng đặt ảnh chính
   - Vùng text tiêu đề
   - Logo kênh góc
3. Save as Template

#### 4.4 Tạo Folder Tổ Chức
1. Tạo folder: "YouTube Thumbnails"
2. Tạo folder: "YouTube Assets"
3. Upload stock images/icons thường dùng

**Verification:**
- [ ] Canva Pro đã active
- [ ] Brand Kit đã thiết lập
- [ ] Template thumbnail đã tạo
- [ ] Folders đã tổ chức

---

## 4. Xác Minh Hoàn Thành Phase 1

### Checklist Tổng Hợp

| Công cụ | Trạng thái | Ghi chú |
|---------|------------|---------|
| ChatGPT | [ ] Done | Custom instructions configured |
| Edge-TTS | [ ] Done | Vietnamese voice working |
| CapCut | [ ] Done | Project template ready |
| Canva | [ ] Done | Brand kit + thumbnail template |

### Test Tích Hợp

Thực hiện mini-workflow test:
1. [ ] Tạo script 30s bằng ChatGPT
2. [ ] Chuyển script thành audio bằng Edge-TTS
3. [ ] Import audio vào CapCut, thêm video/image
4. [ ] Tạo thumbnail bằng Canva

---

## 5. Xử Lý Lỗi Thường Gặp

### 5.1 ChatGPT

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-------------|-----------|
| "Too many requests" | Giới hạn rate | Chờ 1 giờ hoặc upgrade Plus |
| Response bị cắt | Quá dài | Chia prompt thành nhiều phần |
| Không hiểu context | Prompt không rõ | Thêm chi tiết, ví dụ cụ thể |

### 5.2 Edge-TTS

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-------------|-----------|
| "pip not found" | Python chưa add PATH | Reinstall Python, tick "Add to PATH" |
| Voice không khả dụng | Network issue | Kiểm tra internet, thử lại |
| Audio bị giật | Text quá dài | Chia thành đoạn nhỏ <500 từ |

### 5.3 CapCut

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-------------|-----------|
| Crash khi export | RAM không đủ | Đóng app khác, giảm resolution |
| Auto caption sai | Giọng không rõ | Dùng audio chất lượng cao hơn |
| Không sync audio | Import sai format | Convert audio sang MP3/WAV |

### 5.4 Canva

| Lỗi | Nguyên nhân | Giải pháp |
|-----|-------------|-----------|
| Upload fail | File quá lớn | Compress image <25MB |
| Font không hiển thị | Font Pro only | Upgrade hoặc dùng font free |
| Download chậm | Server busy | Thử lại sau hoặc đổi format |

---

## 6. Tài Liệu Tham Khảo

- [OpenAI Documentation](https://platform.openai.com/docs)
- [Edge-TTS GitHub](https://github.com/rany2/edge-tts)
- [CapCut Help Center](https://www.capcut.com/resource/help)
- [Canva Design School](https://www.canva.com/designschool/)

---

## 7. Phê Duyệt Phase 1

| Vai trò | Người phê duyệt | Ngày | Chữ ký |
|---------|-----------------|------|--------|
| Thực hiện | | | |
| Review | | | |
| Approve | | | |

---

**Ghi chú cập nhật:**
- v1.0 (2026-01-04): Tạo mới SOP Phase 1
