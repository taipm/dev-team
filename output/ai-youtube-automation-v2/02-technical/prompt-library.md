# Prompt Library - AI YouTube Automation v2

> Thu vien prompt da duoc test va toi uu cho ChatGPT Free (50 msg/day)
> Niche: Giao duc/Kien thuc | Content type: Faceless educational videos

---

## Muc luc

1. [Script Generation Prompts](#1-script-generation-prompts)
2. [Idea Brainstorming Prompts](#2-idea-brainstorming-prompts)
3. [SEO Optimization Prompts](#3-seo-optimization-prompts)
4. [Title Variations Prompts](#4-title-variations-prompts)
5. [Hook & Intro Prompts](#5-hook--intro-prompts)
6. [Thumbnail Text Prompts](#6-thumbnail-text-prompts)
7. [Call-to-Action Prompts](#7-call-to-action-prompts)
8. [Content Research Prompts](#8-content-research-prompts)

---

## 1. Script Generation Prompts

### Prompt 1.1: Script co ban (Dang giai thich)

```
Viet script YouTube video ve chu de "{CHU_DE}" voi cac yeu cau sau:

**Thong tin video:**
- Do dai: {THOI_LUONG} phut (khoang {SO_TU} tu)
- Doi tuong: {DOI_TUONG_MUC_TIEU}
- Giong dieu: Than thien, de hieu, nhu dang noi chuyen voi ban

**Cau truc bat buoc:**
1. Hook (10-15 giay): Cau hoi gay to mo hoac fact gay soc
2. Intro (30 giay): Gioi thieu van de, tai sao quan trong
3. Noi dung chinh (chia 3-5 phan ro rang)
4. Tong ket + CTA (30 giay)

**Yeu cau:**
- Moi doan co goi y hinh anh/video minh hoa [trong ngoac vuong]
- Su dung vi du thuc te, so lieu cu the
- Cau ngan, de nghe khi voiceover
- Them transition phrases giua cac phan

Viet bang tieng Viet co dau.
```

**Vi du su dung:**
- {CHU_DE}: "Tai sao chung ta ngap va ngap co lay khong?"
- {THOI_LUONG}: 8
- {SO_TU}: 1200
- {DOI_TUONG_MUC_TIEU}: Nguoi xem 18-35 tuoi, thich khoa hoc

---

### Prompt 1.2: Script dang Listicle (Top N)

```
Viet script YouTube video dang listicle: "{TIEU_DE_LISTICLE}"

**Thong so:**
- So luong items: {SO_ITEMS}
- Thoi luong: {THOI_LUONG} phut
- Sap xep: {THU_TU} (ngau nhien/tang dan/giam dan theo do thu vi)

**Format moi item:**
- Ten item + giai thich ngan (2-3 cau)
- Mot fact/so lieu thu vi
- Vi du hoac case study mini
- [Goi y hinh anh minh hoa]
- Cau chuyen tiep sang item tiep theo

**Cau truc:**
1. Hook: Teaser item hap dan nhat (khong tiet lo het)
2. Intro ngan: Gioi thieu chu de
3. Cac items (tu it hap dan den hap dan nhat)
4. Bonus item hoac honorable mentions
5. CTA: Subscribe + goi y video lien quan

Viet bang tieng Viet co dau.
```

**Vi du su dung:**
- {TIEU_DE_LISTICLE}: "7 Hien tuong ky la cua nao bo ma khoa hoc chua giai thich duoc"
- {SO_ITEMS}: 7
- {THOI_LUONG}: 12
- {THU_TU}: tang dan

---

### Prompt 1.3: Script dang Comparison (So sanh)

```
Viet script YouTube video so sanh: "{DOI_TUONG_A} vs {DOI_TUONG_B}: {CAU_HOI_SO_SANH}"

**Goc nhin:** {TRUNG_LAP/UNG_HO_A/UNG_HO_B}

**Tieu chi so sanh (bat buoc):**
1. {TIEU_CHI_1}
2. {TIEU_CHI_2}
3. {TIEU_CHI_3}
4. {TIEU_CHI_4}
5. Tong ket: Ai/cai nao phu hop voi ai?

**Format moi tieu chi:**
- Giai thich ngan tieu chi
- Phan tich A (uu/nhuoc)
- Phan tich B (uu/nhuoc)
- Ket luan phan nay
- [Goi y visual: bang so sanh, animation]

**Cau truc:**
- Hook: Dat cau hoi tranh cai
- Gioi thieu ca 2 doi tuong
- So sanh tung tieu chi
- Verdict cuoi cung
- CTA + poll hoi y kien viewer

Viet bang tieng Viet co dau.
```

---

## 2. Idea Brainstorming Prompts

### Prompt 2.1: Brainstorm Ideas theo Niche

```
Dong vai mot YouTube content strategist chuyen ve niche {NICHE}.

Brainstorm 20 y tuong video voi cac tieu chi:
- Evergreen content (khong bi loi thoi)
- Co search volume tiem nang cao
- Phu hop voi faceless video format
- De research va viet script trong 2-3 gio

**Phan loai theo:**
1. Giai thich khai niem (5 y tuong)
2. Listicle/Top N (5 y tuong)
3. Debunk myths/Giai ma (5 y tuong)
4. How-to/Tutorial (5 y tuong)

**Format moi y tuong:**
- Tieu de goi y
- Estimated search volume: Cao/Trung binh/Thap
- Do kho san xuat: De/Trung binh/Kho
- Potential hook (1 cau)

Niche: {NICHE_CU_THE}
```

**Vi du:** {NICHE_CU_THE} = "Tam ly hoc doi thuong"

---

### Prompt 2.2: Idea tu Trending Topics

```
Dua tren cac xu huong hien tai, goi y 10 y tuong video giao duc/kien thuc lien quan den:

**Xu huong/Su kien:** {XU_HUONG}

**Yeu cau:**
- Goc nhin giao duc, khong phai tin tuc
- Evergreen hoa duoc (van co gia tri sau 1-2 nam)
- Khong vi pham guidelines YouTube
- Phu hop faceless format

**Format:**
| STT | Tieu de | Goc tiep can | Evergreen score (1-10) |
```

---

### Prompt 2.3: Content Gap Analysis

```
Phan tich content gap cho kenh YouTube ve {NICHE}:

**Cac chu de da lam:**
{DANH_SACH_VIDEO_DA_LAM}

**Yeu cau:**
1. Xac dinh 10 chu de con thieu trong niche nay
2. Goi y 5 series tiem nang (3-5 video moi series)
3. De xuat 3 collaboration topic voi niche lien quan

**Format output:**
- Missing topics + ly do nen lam
- Series ideas + outline so bo
- Collaboration opportunities
```

---

## 3. SEO Optimization Prompts

### Prompt 3.1: Full SEO Package

```
Toi uu SEO cho video YouTube voi thong tin sau:

**Noi dung video:**
- Chu de: {CHU_DE}
- Noi dung chinh: {TOM_TAT_NOI_DUNG}
- Do dai: {THOI_LUONG} phut

**Yeu cau tao:**
1. **Title:** 5 variations (duoi 60 ky tu, co keyword chinh)
2. **Description:**
   - 3 dong dau hap dan (hien tren preview)
   - Timestamps (dua tren cau truc video)
   - Links placeholder
   - Hashtags (3-5)
3. **Tags:** 15-20 tags (mix broad + specific)
4. **Thumbnail text:** 3 options (duoi 5 tu)

**Target keyword:** {KEYWORD_CHINH}
**Secondary keywords:** {KEYWORDS_PHU}

Viet bang tieng Viet co dau.
```

---

### Prompt 3.2: Keyword Research Assistant

```
Lam keyword research cho video YouTube ve "{CHU_DE}":

**Tasks:**
1. Liet ke 20 related keywords (tu khoa lien quan)
2. 10 long-tail keywords
3. 10 question-based keywords (nguoi xem hay hoi gi?)
4. 5 competitor keywords (tu khoa doi thu dung)

**Format:**
| Keyword | Type | Estimated Competition | Recommended Usage |
```

---

### Prompt 3.3: Description Generator

```
Viet description YouTube cho video:

**Tieu de:** {TIEU_DE}
**Noi dung chinh:** {TOM_TAT}
**Timestamps:**
{DANH_SACH_TIMESTAMPS}

**Yeu cau:**
- 3 dong dau: Hook + value proposition (hien tren preview)
- Paragraph giai thich chi tiet (150-200 tu)
- Section timestamps
- CTA section
- Social links placeholder
- 3-5 hashtags cuoi

**Tone:** Than thien, chuyen nghiep

Viet bang tieng Viet co dau.
```

---

## 4. Title Variations Prompts

### Prompt 4.1: Title Generator

```
Tao 10 variations tieu de YouTube cho video ve:

**Chu de:** {CHU_DE}
**Noi dung chinh:** {NOI_DUNG_TOM_TAT}
**Target emotion:** {CAM_XUC_MUC_TIEU} (to mo/soc/huu ich/FOMO)

**Yeu cau moi title:**
- Duoi 60 ky tu (hien thi day du)
- Co keyword chinh o dau neu duoc
- Khong clickbait qua muc
- Co hook element (so, cau hoi, promise)

**Format:**
1. [Dang cau hoi]
2. [Dang "How to"]
3. [Dang so/listicle]
4. [Dang "Tai sao"]
5. [Dang debunk]
6. [Dang comparison]
7. [Dang "Su that ve"]
8. [Dang warning/alert]
9. [Dang story]
10. [Dang controversial]

Viet bang tieng Viet co dau.
```

---

### Prompt 4.2: A/B Testing Titles

```
Cho tieu de goc: "{TIEU_DE_GOC}"

Tao 5 A/B test variations voi:
1. Thay doi hook element
2. Thay doi structure
3. Them/bot so
4. Thay doi emotional trigger
5. Thay doi length

**Phan tich moi variation:**
- Diem manh
- Diem yeu
- Best use case
- CTR prediction (1-10)
```

---

## 5. Hook & Intro Prompts

### Prompt 5.1: Hook Generator

```
Viet 5 hooks khac nhau cho video ve "{CHU_DE}":

**Yeu cau:**
- Do dai: 10-15 giay doc (30-50 tu)
- Phai grab attention trong 3 giay dau
- Khong hua suong, phai deliver trong video

**Cac dang hook:**
1. **Question hook:** Dat cau hoi gay to mo
2. **Statistic hook:** Mo dau bang so lieu gay soc
3. **Story hook:** Mini story/scenario
4. **Myth hook:** "Ban nghi X nhung thuc ra..."
5. **Promise hook:** "Sau video nay, ban se..."

**Format moi hook:**
- Script text
- [Goi y visual]
- Emotional trigger: {cam xuc nham den}

Viet bang tieng Viet co dau.
```

---

### Prompt 5.2: Intro Templates

```
Viet intro template (sau hook) cho video dang {DANG_VIDEO}:

**Thong tin:**
- Chu de: {CHU_DE}
- Do dai intro: 20-30 giay
- Co keu goi subscribe: Co/Khong

**Cau truc intro:**
1. Transition tu hook
2. Gioi thieu ban than/kenh (neu can)
3. Neu van de/context
4. Promise: Video nay se giai quyet gi
5. (Optional) Quick CTA

Viet bang tieng Viet co dau.
```

---

## 6. Thumbnail Text Prompts

### Prompt 6.1: Thumbnail Text Ideas

```
Tao text cho thumbnail video:

**Tieu de video:** {TIEU_DE}
**Noi dung chinh:** {NOI_DUNG}

**Yeu cau:**
- Toi da 4-5 tu
- Readable khi thumbnail nho
- Complement (khong duplicate) title
- Trigger emotion

**Tao 5 options:**
1. [Dang cau hoi ngan]
2. [Dang so an tuong]
3. [Dang emotional word]
4. [Dang contrast/versus]
5. [Dang mystery/teaser]

Kem goi y mau sac va font style cho moi option.
```

---

## 7. Call-to-Action Prompts

### Prompt 7.1: CTA Script Generator

```
Viet 3 CTA scripts khac nhau cho cuoi video:

**Context video:** {CHU_DE_VIDEO}
**Video tiep theo goi y:** {VIDEO_LIEN_QUAN}

**Cac dang CTA:**
1. **Standard CTA** (10 giay): Like, subscribe, notification
2. **Value-add CTA** (15 giay): Goi y video lien quan + why
3. **Community CTA** (15 giay): Comment question + engagement

**Yeu cau:**
- Natural, khong robotic
- Specific reason to subscribe
- Khong qua aggressive

Viet bang tieng Viet co dau.
```

---

## 8. Content Research Prompts

### Prompt 8.1: Deep Research Assistant

```
Research sau ve chu de "{CHU_DE}" de chuan bi viet script:

**Can research:**
1. **Facts & Statistics:** 10 facts thu vi (co nguon)
2. **Common misconceptions:** 5 dieu moi nguoi hay hieu sai
3. **Expert opinions:** Cac chuyen gia noi gi
4. **Historical context:** Lich su/nguon goc neu relevant
5. **Real-world examples:** 3-5 case studies/examples

**Format:**
- Moi point kem source/explanation
- Danh dau diem nao "must include" vs "nice to have"
- Highlight controversial points can verify them

Tap trung vao thong tin co the verify duoc.
```

---

### Prompt 8.2: Competitor Analysis

```
Phan tich 3 video doi thu ve chu de "{CHU_DE}":

**Video 1:** {LINK_HOAC_TIEU_DE_1}
**Video 2:** {LINK_HOAC_TIEU_DE_2}
**Video 3:** {LINK_HOAC_TIEU_DE_3}

**Phan tich moi video:**
1. Hook su dung
2. Structure/outline
3. Diem manh
4. Diem co the lam tot hon
5. Comments hay duoc quan tam

**Output:**
- Best practices rut ra
- Gaps co the khai thac
- Differentiation strategy cho video cua minh
```

---

## Tips su dung Prompt Library

### Workflow toi uu cho 50 msg/day limit:

1. **Ngay 1:** Brainstorm ideas (1-2 prompts) + Research (1 prompt)
2. **Ngay 2:** Script generation (1-2 prompts) + Revision
3. **Ngay 3:** SEO optimization (1 prompt) + Titles (1 prompt)

### Best Practices:

1. **Combine prompts:** Gop nhieu yeu cau nho vao 1 prompt lon
2. **Context stacking:** Dung ket qua prompt truoc lam input prompt sau
3. **Save templates:** Luu cac prompt hay dung voi placeholders
4. **Iterate smart:** Revise trong cung conversation de giu context

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | {DATE} | Initial prompt library voi 8 categories |

---

*Tai lieu thuoc du an AI YouTube Automation v2*
