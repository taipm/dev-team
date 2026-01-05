# Language Classification Rules

## Priority Order

Các rule được áp dụng theo thứ tự ưu tiên từ cao đến thấp.

## Rule 1: IPA Notation (Highest Priority)

**Pattern**: Text trong `/.../` hoặc `[...]`

**Examples**:
- `/əˈkɑːmplɪʃ/` → `en`
- `[əˈkɑːmplɪʃ]` → `en`
- `/əˈtʃiːv/` → `en`

**Regex**: `\/[^\/]+\/` hoặc `\[[^\]]+\]` (với IPA characters)

## Rule 2: Vietnamese Diacritics

**Characters**:
```
Vowels with diacritics:
- a: á à ả ã ạ ă ắ ằ ẳ ẵ ặ â ấ ầ ẩ ẫ ậ
- e: é è ẻ ẽ ẹ ê ế ề ể ễ ệ
- i: í ì ỉ ĩ ị
- o: ó ò ỏ õ ọ ô ố ồ ổ ỗ ộ ơ ớ ờ ở ỡ ợ
- u: ú ù ủ ũ ụ ư ứ ừ ử ữ ự
- y: ý ỳ ỷ ỹ ỵ

Special consonant:
- đ Đ
```

**Examples**:
- `hoàn thành` → `vi` (có à, à)
- `đạt được` → `vi` (có đ, ạ, ư, ợ)
- `Nhớ collocation:` → `vi` (có ớ)

**Detection**: Nếu text chứa bất kỳ Vietnamese diacritic → `vi`

## Rule 3: Known English Vocabulary

**Source**: `02-english-vocabulary.txt`

**Matching**: Case-insensitive, whole word match

**Examples**:
- `accomplish` → `en`
- `ACCOMPLISH` → `en`
- `Accomplish` → `en`

## Rule 4: English Collocations/Phrases

**Patterns**:
1. `[verb] + [article] + [noun]`: accomplish a goal
2. `[verb] + [noun]`: achieve success
3. `[verb] + [preposition] + [noun]`: succeed in business

**Collocation indicators**:
- Articles: a, an, the
- Prepositions: in, on, at, to, for, with, by, of, from

**Examples**:
- `accomplish a goal` → `en`
- `accomplish a task` → `en`
- `achieve success` → `en`
- `acquire knowledge` → `en`

## Rule 5: English Sentences

**Pattern**:
- Starts with capital letter
- Contains English words
- Ends with `.` `?` `!`
- No Vietnamese diacritics

**Examples**:
- `She accomplished her goal.` → `en`
- `He achieved great success.` → `en`
- `Did you acquire the skills?` → `en`

## Rule 6: Default (Vietnamese)

**Condition**: Không match rules 1-5

**Rationale**: Context mặc định trong TOEIC videos là tiếng Việt (giảng giải)

**Examples**:
- `Nhớ:` → `vi`
- `Ví dụ:` → `vi`
- `Mẹo:` → `vi`

---

## Edge Cases

### Case: Mixed in single sentence
```
Input: "Từ accomplish nghĩa là hoàn thành"
Split:
  - "Từ " → vi (có ừ)
  - "accomplish" → en (known word)
  - " nghĩa là hoàn thành" → vi (có ĩ, à, à)
```

### Case: Numbers and symbols
```
Input: "5 từ vựng"
Result: → vi (context Vietnamese)

Input: "5 words"
Result: → en (context English)
```

### Case: Abbreviations
```
Input: "TOEIC"
Result: → en (known acronym)

Input: "Part 5"
Result: → en (TOEIC context)
```

---

## Implementation Notes

1. **Tokenize first**: Split text vào các segments trước khi classify
2. **Apply rules in order**: Check từ rule 1 đến 6
3. **First match wins**: Dừng ngay khi match rule nào
4. **Merge adjacent**: Gộp các tokens cùng language liền kề
