# Custom Questions

> Thêm câu hỏi discovery của riêng bạn vào đây

---

## Cách Thêm Câu Hỏi Mới

### Bước 1: Tạo file `.md` mới

Tạo file trong thư mục này với tên mô tả nội dung:
- `observability-questions.md`
- `security-deep-dive.md`
- `my-project-questions.md`

### Bước 2: Viết câu hỏi theo template

```markdown
# Tên Bộ Câu Hỏi
<!-- category: my-category -->
<!-- icon: 🔍 -->
<!-- author: your-name -->
<!-- created: 2024-01-20 -->

## Mô tả
Mô tả ngắn về bộ câu hỏi này.

---

## Câu hỏi

### 1. Tiêu đề câu hỏi
<!-- id: mycat-01 -->
<!-- depth: 2 -->

**Câu hỏi:** Nội dung câu hỏi của bạn?

**Tìm ở đâu:**
- `**/*.go` - Go source files
- `**/config.*` - Config files

**Keywords:** keyword1, keyword2, keyword3

---

### 2. Câu hỏi tiếp theo
<!-- id: mycat-02 -->
<!-- depth: 1 -->
<!-- depends: mycat-01 -->

**Câu hỏi:** Câu hỏi khác?

**Tìm ở đâu:**
- `**/test*`

**Keywords:** test, spec
```

### Bước 3: Chạy discovery

```
/microai:discovery-session *source:custom
```

hoặc

```
/microai:discovery-session *source:custom-questions/my-file.md
```

---

## Files Trong Thư Mục Này

| File | Mô tả |
|------|-------|
| `_template.md` | Template trống để copy |
| `observability.md` | Câu hỏi về logging, monitoring |
| `ownership.md` | Câu hỏi về team ownership |

---

## Tips

1. **Depth levels:**
   - `1` = Surface (5-10 phút/câu)
   - `2` = Moderate (10-20 phút/câu)
   - `3` = Deep (20+ phút/câu)

2. **Dependencies:** Nếu câu hỏi B cần câu trả lời từ A trước, thêm `depends: [a-id]`

3. **Search hints:** Càng specific càng tốt để Reader Agent tìm nhanh

---

*Discovery Team sẽ tự động load tất cả `.md` files trong thư mục này.*
