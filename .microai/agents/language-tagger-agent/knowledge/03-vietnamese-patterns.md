# Vietnamese Language Patterns

## Vietnamese Diacritics Detection

### Complete Character Set

```python
VIETNAMESE_CHARS = {
    # Vowels with tone marks
    'á', 'à', 'ả', 'ã', 'ạ',
    'ắ', 'ằ', 'ẳ', 'ẵ', 'ặ',
    'ấ', 'ầ', 'ẩ', 'ẫ', 'ậ',
    'é', 'è', 'ẻ', 'ẽ', 'ẹ',
    'ế', 'ề', 'ể', 'ễ', 'ệ',
    'í', 'ì', 'ỉ', 'ĩ', 'ị',
    'ó', 'ò', 'ỏ', 'õ', 'ọ',
    'ố', 'ồ', 'ổ', 'ỗ', 'ộ',
    'ớ', 'ờ', 'ở', 'ỡ', 'ợ',
    'ú', 'ù', 'ủ', 'ũ', 'ụ',
    'ứ', 'ừ', 'ử', 'ữ', 'ự',
    'ý', 'ỳ', 'ỷ', 'ỹ', 'ỵ',
    # Special vowels
    'ă', 'â', 'ê', 'ô', 'ơ', 'ư',
    # Special consonant
    'đ',
    # Uppercase versions
    'Á', 'À', 'Ả', 'Ã', 'Ạ',
    'Ắ', 'Ằ', 'Ẳ', 'Ẵ', 'Ặ',
    'Ấ', 'Ầ', 'Ẩ', 'Ẫ', 'Ậ',
    'É', 'È', 'Ẻ', 'Ẽ', 'Ẹ',
    'Ế', 'Ề', 'Ể', 'Ễ', 'Ệ',
    'Í', 'Ì', 'Ỉ', 'Ĩ', 'Ị',
    'Ó', 'Ò', 'Ỏ', 'Õ', 'Ọ',
    'Ố', 'Ồ', 'Ổ', 'Ỗ', 'Ộ',
    'Ớ', 'Ờ', 'Ở', 'Ỡ', 'Ợ',
    'Ú', 'Ù', 'Ủ', 'Ũ', 'Ụ',
    'Ứ', 'Ừ', 'Ử', 'Ữ', 'Ự',
    'Ý', 'Ỳ', 'Ỷ', 'Ỹ', 'Ỵ',
    'Ă', 'Â', 'Ê', 'Ô', 'Ơ', 'Ư',
    'Đ'
}
```

### Detection Function

```python
def has_vietnamese_diacritics(text: str) -> bool:
    return any(char in VIETNAMESE_CHARS for char in text)
```

## Common Vietnamese Instruction Phrases

Các cụm từ thường xuất hiện trong TOEIC video giảng dạy:

### Introduction
- `Chào mừng bạn đến với`
- `Hôm nay chúng ta sẽ học`
- `Bài học hôm nay`

### Word Introduction
- `Từ vựng số`
- `Từ tiếp theo`
- `Chúng ta có từ`

### Definition
- `nghĩa là`
- `có nghĩa là`
- `được dịch là`

### Examples
- `Ví dụ:`
- `Câu ví dụ:`
- `Xem ví dụ sau:`

### Tips
- `Mẹo:`
- `Lưu ý:`
- `Nhớ:`
- `Nhớ collocation:`
- `Cách nhớ:`

### Quiz
- `Câu hỏi:`
- `Đáp án đúng là:`
- `Hãy chọn đáp án:`
- `Dừng lại và suy nghĩ`

### Summary
- `Tóm tắt:`
- `Tổng kết:`
- `Hôm nay chúng ta đã học`

### Closing
- `Hẹn gặp lại`
- `Chúc bạn học tốt`
- `Đừng quên`

## Pattern Matching Examples

### Pattern 1: Vietnamese intro + English word + Vietnamese explanation
```
"Từ accomplish nghĩa là hoàn thành"
 ├── "Từ " → vi
 ├── "accomplish" → en
 └── " nghĩa là hoàn thành" → vi
```

### Pattern 2: Vietnamese label + English content
```
"Nhớ collocation: accomplish a goal"
 ├── "Nhớ collocation:" → vi
 └── "accomplish a goal" → en
```

### Pattern 3: English sentence + Vietnamese translation
```
"She accomplished her goal. - Cô ấy đã hoàn thành mục tiêu."
 ├── "She accomplished her goal." → en
 ├── " - " → separator (neutral)
 └── "Cô ấy đã hoàn thành mục tiêu." → vi
```

## Splitting Boundaries

### Primary Boundaries
1. `.` followed by space and capital letter
2. `-` surrounded by spaces (translation separator)
3. `:` followed by space (label separator)
4. `\n` newline

### Secondary Boundaries
1. `,` in certain contexts (list items)
2. `()` parentheses (alternate meaning)
3. `/` in IPA or alternatives
