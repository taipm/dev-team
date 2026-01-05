# Risk Mitigation Plan

## Dự án: AI YouTube Automation v2.0

---

## Risk Matrix

```text
           │ Low Impact │ Medium Impact │ High Impact │
───────────┼────────────┼───────────────┼─────────────┤
High Prob  │     R3     │      R1       │             │
───────────┼────────────┼───────────────┼─────────────┤
Med Prob   │     R5     │      R2       │     R4      │
───────────┼────────────┼───────────────┼─────────────┤
Low Prob   │            │      R6       │     R7      │
───────────┴────────────┴───────────────┴─────────────┘
```

---

## Risk Register

### R1: ChatGPT Free Tier Limit (50 msg/day)
| Attribute | Detail |
|-----------|--------|
| **Probability** | Cao |
| **Impact** | Trung bình |
| **Category** | Technical |
| **Owner** | @user |

**Mô tả**: Free tier chỉ cho 50 messages/ngày, có thể không đủ cho batch production.

**Mitigation Strategies**:
1. **Batch prompts**: Yêu cầu 5 scripts trong 1 prompt
2. **Save & reuse**: Lưu responses tốt làm template
3. **Off-peak usage**: Dùng vào đầu ngày để có full quota
4. **Alternative**: Claude.ai, Gemini làm backup

**Contingency**: Nếu bị limit, switch sang Gemini Free hoặc chờ ngày hôm sau.

---

### R2: YouTube Content Policy
| Attribute | Detail |
|-----------|--------|
| **Probability** | Trung bình |
| **Impact** | Trung bình |
| **Category** | Policy |
| **Owner** | @user |

**Mô tả**: YouTube có thể reject videos hoặc demonetize do AI-generated content.

**Mitigation Strategies**:
1. **Add value**: Focus vào educational content thực sự hữu ích
2. **Human touch**: Review và edit scripts trước khi dùng
3. **Disclosure**: Không hide việc dùng AI nếu được hỏi
4. **Diversify**: Không 100% phụ thuộc vào 1 channel

**Contingency**: Nếu bị flag, appeal và điều chỉnh content style.

---

### R3: Edge-TTS Voice Quality
| Attribute | Detail |
|-----------|--------|
| **Probability** | Cao |
| **Impact** | Thấp |
| **Category** | Technical |
| **Owner** | @user |

**Mô tả**: Giọng TTS có thể nghe không tự nhiên, ảnh hưởng watch time.

**Mitigation Strategies**:
1. **Background music**: Thêm nhạc nền che bớt robotic feel
2. **Speed adjustment**: Điều chỉnh tốc độ đọc
3. **Multiple voices**: Dùng nhiều giọng khác nhau
4. **Post-processing**: EQ và compression trong CapCut

**Contingency**: Nếu feedback xấu, thử ElevenLabs free tier.

---

### R4: Không Đạt YPP Requirements
| Attribute | Detail |
|-----------|--------|
| **Probability** | Trung bình |
| **Impact** | Cao |
| **Category** | Business |
| **Owner** | @user |

**Mô tả**: Không đạt 1000 subs + 4000 watch hours trong 4 tháng.

**Mitigation Strategies**:
1. **Shorts strategy**: Thêm Shorts để viral
2. **Community**: Engage comments, build community
3. **Collaboration**: Cross-promote với channels khác
4. **Paid promotion**: Nếu cần, nhẹ nhàng promote

**Contingency**: Extend timeline lên 6 tháng, focus quality over quantity.

---

### R5: Burnout / Time Management
| Attribute | Detail |
|-----------|--------|
| **Probability** | Trung bình |
| **Impact** | Thấp |
| **Category** | Personal |
| **Owner** | @user |

**Mô tả**: Làm quá nhiều dẫn đến kiệt sức, bỏ dở project.

**Mitigation Strategies**:
1. **Time cap**: Max 10-12 giờ/tuần
2. **Batch work**: Làm batch thay vì daily
3. **Buffer**: Luôn có 1 tuần videos dự phòng
4. **Break**: 1 ngày nghỉ hoàn toàn/tuần

**Contingency**: Reduce frequency to 5 videos/tháng nếu cần.

---

### R6: Copyright Issues
| Attribute | Detail |
|-----------|--------|
| **Probability** | Thấp |
| **Impact** | Trung bình |
| **Category** | Legal |
| **Owner** | @user |

**Mô tả**: Bị claim copyright từ music, images, hoặc content.

**Mitigation Strategies**:
1. **Royalty-free**: Chỉ dùng nhạc từ YouTube Audio Library
2. **Stock footage**: Pexels, Pixabay (đều CC0)
3. **Original scripts**: Không copy paste từ nguồn khác
4. **Cite sources**: Credit khi cần

**Contingency**: Remove/replace content ngay khi bị claim.

---

### R7: Account Suspension
| Attribute | Detail |
|-----------|--------|
| **Probability** | Thấp |
| **Impact** | Cao |
| **Category** | Platform |
| **Owner** | @user |

**Mô tả**: YouTube suspend account do spam hoặc policy violation.

**Mitigation Strategies**:
1. **Backup channel**: Tạo sẵn channel backup
2. **Content backup**: Lưu tất cả videos locally
3. **Diversify**: Repurpose content cho TikTok, Facebook
4. **Follow ToS**: Nghiêm túc tuân thủ guidelines

**Contingency**: Appeal và bắt đầu lại với channel mới.

---

## Risk Response Summary

| Risk | Response Type | Priority |
|------|---------------|----------|
| R1 | Mitigate | High |
| R2 | Accept + Monitor | Medium |
| R3 | Mitigate | Low |
| R4 | Mitigate | High |
| R5 | Avoid | Medium |
| R6 | Avoid | Low |
| R7 | Transfer/Avoid | Low |

---

## Review Schedule

| Frequency | Actions |
|-----------|---------|
| Weekly | Check R1, R3, R5 |
| Monthly | Review all risks, update probabilities |
| Phase end | Full risk assessment |

---

**Last Updated**: 04/01/2026
