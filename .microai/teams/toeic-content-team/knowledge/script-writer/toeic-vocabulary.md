# TOEIC Vocabulary Corpus

> Knowledge file cho Script Writer Agent
> Version: 1.0
> Từ vựng được phân loại theo chủ đề và tần suất xuất hiện trong TOEIC

---

## Cấu trúc Từ vựng

Mỗi từ bao gồm:
- **word**: Từ tiếng Anh
- **ipa**: Phiên âm IPA
- **pos**: Part of speech (n/v/adj/adv)
- **meaning_vi**: Nghĩa tiếng Việt
- **meaning_en**: Definition tiếng Anh
- **example_en**: Câu ví dụ tiếng Anh
- **example_vi**: Dịch câu ví dụ
- **collocations**: Các cụm từ phổ biến
- **frequency**: high/medium/low
- **part**: TOEIC part thường xuất hiện

---

## Category 1: Business & Finance (Kinh doanh & Tài chính)

### High Frequency Words

```yaml
- word: negotiate
  ipa: /nɪˈɡoʊʃieɪt/
  pos: verb
  meaning_vi: đàm phán, thương lượng
  meaning_en: to discuss something in order to reach an agreement
  example_en: "We need to negotiate a better deal with the supplier."
  example_vi: "Chúng ta cần đàm phán một thỏa thuận tốt hơn với nhà cung cấp."
  collocations:
    - negotiate a contract
    - negotiate terms
    - negotiate a deal
  frequency: high
  part: [5, 6, 7]

- word: revenue
  ipa: /ˈrevənuː/
  pos: noun
  meaning_vi: doanh thu
  meaning_en: income that a company receives from its business activities
  example_en: "The company's revenue increased by 15% this quarter."
  example_vi: "Doanh thu của công ty tăng 15% trong quý này."
  collocations:
    - annual revenue
    - generate revenue
    - revenue growth
  frequency: high
  part: [5, 6, 7]

- word: budget
  ipa: /ˈbʌdʒɪt/
  pos: noun/verb
  meaning_vi: ngân sách / lập ngân sách
  meaning_en: the money available to spend on something
  example_en: "We need to stay within the project budget."
  example_vi: "Chúng ta cần giữ trong phạm vi ngân sách dự án."
  collocations:
    - budget constraints
    - allocate budget
    - exceed the budget
  frequency: high
  part: [5, 6, 7]

- word: profit
  ipa: /ˈprɑːfɪt/
  pos: noun
  meaning_vi: lợi nhuận
  meaning_en: money gained after all expenses are paid
  example_en: "The company made a profit of $2 million last year."
  example_vi: "Công ty đạt lợi nhuận 2 triệu đô la năm ngoái."
  collocations:
    - net profit
    - profit margin
    - make a profit
  frequency: high
  part: [5, 6, 7]

- word: expense
  ipa: /ɪkˈspens/
  pos: noun
  meaning_vi: chi phí
  meaning_en: money spent on something
  example_en: "Travel expenses will be reimbursed by the company."
  example_vi: "Chi phí đi lại sẽ được công ty hoàn trả."
  collocations:
    - operating expenses
    - expense report
    - cover expenses
  frequency: high
  part: [5, 6, 7]

- word: investment
  ipa: /ɪnˈvestmənt/
  pos: noun
  meaning_vi: đầu tư
  meaning_en: the act of putting money into something to make a profit
  example_en: "This investment will pay off in the long term."
  example_vi: "Khoản đầu tư này sẽ sinh lợi trong dài hạn."
  collocations:
    - return on investment
    - foreign investment
    - make an investment
  frequency: high
  part: [5, 6, 7]
```

### Medium Frequency Words

```yaml
- word: merger
  ipa: /ˈmɜːrdʒər/
  pos: noun
  meaning_vi: sự sáp nhập
  meaning_en: the joining of two companies into one
  example_en: "The merger between the two banks was approved."
  example_vi: "Việc sáp nhập giữa hai ngân hàng đã được phê duyệt."
  collocations:
    - merger and acquisition
    - propose a merger
    - complete a merger
  frequency: medium
  part: [6, 7]

- word: dividend
  ipa: /ˈdɪvɪdend/
  pos: noun
  meaning_vi: cổ tức
  meaning_en: a share of profits paid to shareholders
  example_en: "Shareholders will receive a dividend of $0.50 per share."
  example_vi: "Các cổ đông sẽ nhận cổ tức $0.50 mỗi cổ phiếu."
  collocations:
    - pay dividends
    - dividend yield
    - annual dividend
  frequency: medium
  part: [6, 7]

- word: liability
  ipa: /ˌlaɪəˈbɪləti/
  pos: noun
  meaning_vi: trách nhiệm pháp lý, nợ phải trả
  meaning_en: legal responsibility or debts
  example_en: "The company has significant liabilities on its balance sheet."
  example_vi: "Công ty có các khoản nợ đáng kể trên bảng cân đối."
  collocations:
    - limited liability
    - assume liability
    - financial liability
  frequency: medium
  part: [6, 7]
```

---

## Category 2: Office & Workplace (Văn phòng)

### High Frequency Words

```yaml
- word: deadline
  ipa: /ˈdedlaɪn/
  pos: noun
  meaning_vi: thời hạn, hạn chót
  meaning_en: the latest time by which something must be completed
  example_en: "The deadline for the report is next Friday."
  example_vi: "Hạn chót nộp báo cáo là thứ Sáu tuần sau."
  collocations:
    - meet a deadline
    - miss a deadline
    - extend the deadline
  frequency: high
  part: [5, 6, 7]

- word: schedule
  ipa: /ˈskedʒuːl/
  pos: noun/verb
  meaning_vi: lịch trình / lên lịch
  meaning_en: a plan of activities or events
  example_en: "Please schedule a meeting for tomorrow morning."
  example_vi: "Vui lòng lên lịch họp vào sáng mai."
  collocations:
    - ahead of schedule
    - behind schedule
    - tight schedule
  frequency: high
  part: [3, 4, 5, 6]

- word: appointment
  ipa: /əˈpɔɪntmənt/
  pos: noun
  meaning_vi: cuộc hẹn
  meaning_en: an arrangement to meet someone at a particular time
  example_en: "I have an appointment with the doctor at 3 PM."
  example_vi: "Tôi có cuộc hẹn với bác sĩ lúc 3 giờ chiều."
  collocations:
    - make an appointment
    - cancel an appointment
    - reschedule an appointment
  frequency: high
  part: [3, 4, 5]

- word: colleague
  ipa: /ˈkɑːliːɡ/
  pos: noun
  meaning_vi: đồng nghiệp
  meaning_en: a person you work with
  example_en: "My colleague will handle the project while I'm away."
  example_vi: "Đồng nghiệp của tôi sẽ xử lý dự án khi tôi vắng mặt."
  collocations:
    - work colleague
    - former colleague
    - consult with colleagues
  frequency: high
  part: [3, 4, 6, 7]

- word: supervisor
  ipa: /ˈsuːpərvaɪzər/
  pos: noun
  meaning_vi: người giám sát
  meaning_en: a person who manages and directs others' work
  example_en: "Please submit the report to your supervisor."
  example_vi: "Vui lòng nộp báo cáo cho người giám sát của bạn."
  collocations:
    - immediate supervisor
    - report to supervisor
    - supervisor approval
  frequency: high
  part: [3, 4, 6, 7]

- word: implement
  ipa: /ˈɪmplɪment/
  pos: verb
  meaning_vi: triển khai, thực hiện
  meaning_en: to put a plan or system into action
  example_en: "We will implement the new policy next month."
  example_vi: "Chúng tôi sẽ triển khai chính sách mới vào tháng sau."
  collocations:
    - implement a plan
    - implement changes
    - implement a strategy
  frequency: high
  part: [5, 6, 7]
```

---

## Category 3: Marketing & Sales (Tiếp thị & Bán hàng)

### High Frequency Words

```yaml
- word: advertisement
  ipa: /ˌædvərˈtaɪzmənt/
  pos: noun
  meaning_vi: quảng cáo
  meaning_en: a notice or message to promote a product or service
  example_en: "The advertisement will appear in major newspapers."
  example_vi: "Quảng cáo sẽ xuất hiện trên các báo lớn."
  collocations:
    - place an advertisement
    - advertisement campaign
    - online advertisement
  frequency: high
  part: [5, 6, 7]

- word: promotion
  ipa: /prəˈmoʊʃn/
  pos: noun
  meaning_vi: khuyến mãi / thăng chức
  meaning_en: advertising activities OR advancement to a higher position
  example_en: "The store is running a special promotion this week."
  example_vi: "Cửa hàng đang chạy chương trình khuyến mãi đặc biệt tuần này."
  collocations:
    - sales promotion
    - get a promotion
    - promotional offer
  frequency: high
  part: [5, 6, 7]

- word: customer
  ipa: /ˈkʌstəmər/
  pos: noun
  meaning_vi: khách hàng
  meaning_en: a person who buys goods or services
  example_en: "Customer satisfaction is our top priority."
  example_vi: "Sự hài lòng của khách hàng là ưu tiên hàng đầu của chúng tôi."
  collocations:
    - customer service
    - loyal customer
    - customer feedback
  frequency: high
  part: [3, 4, 5, 6, 7]

- word: purchase
  ipa: /ˈpɜːrtʃəs/
  pos: noun/verb
  meaning_vi: mua, mua hàng
  meaning_en: to buy something
  example_en: "Customers can purchase tickets online."
  example_vi: "Khách hàng có thể mua vé trực tuyến."
  collocations:
    - make a purchase
    - purchase order
    - online purchase
  frequency: high
  part: [5, 6, 7]
```

---

## Category 4: Human Resources (Nhân sự)

### High Frequency Words

```yaml
- word: applicant
  ipa: /ˈæplɪkənt/
  pos: noun
  meaning_vi: ứng viên
  meaning_en: a person who applies for something, especially a job
  example_en: "All applicants must submit their resumes by Friday."
  example_vi: "Tất cả ứng viên phải nộp hồ sơ trước thứ Sáu."
  collocations:
    - job applicant
    - qualified applicant
    - successful applicant
  frequency: high
  part: [5, 6, 7]

- word: candidate
  ipa: /ˈkændɪdət/
  pos: noun
  meaning_vi: ứng cử viên
  meaning_en: a person being considered for a position
  example_en: "The candidate impressed everyone during the interview."
  example_vi: "Ứng viên đã gây ấn tượng với mọi người trong buổi phỏng vấn."
  collocations:
    - interview candidates
    - ideal candidate
    - shortlist candidates
  frequency: high
  part: [5, 6, 7]

- word: qualification
  ipa: /ˌkwɑːlɪfɪˈkeɪʃn/
  pos: noun
  meaning_vi: bằng cấp, trình độ
  meaning_en: a skill or experience needed for a job
  example_en: "The job requires a bachelor's degree as a minimum qualification."
  example_vi: "Công việc yêu cầu bằng cử nhân là trình độ tối thiểu."
  collocations:
    - academic qualifications
    - professional qualifications
    - meet qualifications
  frequency: high
  part: [5, 6, 7]

- word: resign
  ipa: /rɪˈzaɪn/
  pos: verb
  meaning_vi: từ chức
  meaning_en: to officially leave a job or position
  example_en: "She decided to resign after ten years with the company."
  example_vi: "Cô ấy quyết định từ chức sau mười năm làm việc tại công ty."
  collocations:
    - resign from a position
    - submit resignation
    - resign effective immediately
  frequency: high
  part: [5, 6, 7]
```

---

## Category 5: Travel & Hospitality (Du lịch & Khách sạn)

### High Frequency Words

```yaml
- word: reservation
  ipa: /ˌrezərˈveɪʃn/
  pos: noun
  meaning_vi: đặt chỗ, đặt phòng
  meaning_en: an arrangement to have something kept for you
  example_en: "I'd like to make a reservation for two nights."
  example_vi: "Tôi muốn đặt phòng hai đêm."
  collocations:
    - make a reservation
    - cancel a reservation
    - confirm a reservation
  frequency: high
  part: [3, 4, 5]

- word: accommodation
  ipa: /əˌkɑːməˈdeɪʃn/
  pos: noun
  meaning_vi: chỗ ở
  meaning_en: a place to stay, especially a hotel room
  example_en: "The package includes flights and accommodation."
  example_vi: "Gói tour bao gồm vé máy bay và chỗ ở."
  collocations:
    - book accommodation
    - temporary accommodation
    - luxury accommodation
  frequency: high
  part: [3, 4, 6, 7]

- word: itinerary
  ipa: /aɪˈtɪnəreri/
  pos: noun
  meaning_vi: lịch trình, hành trình
  meaning_en: a detailed plan of a journey
  example_en: "Please check the itinerary for tomorrow's meeting."
  example_vi: "Vui lòng kiểm tra lịch trình cho cuộc họp ngày mai."
  collocations:
    - travel itinerary
    - detailed itinerary
    - follow the itinerary
  frequency: high
  part: [3, 4, 6, 7]
```

---

## Vocabulary Index by Frequency

### High Frequency (Top 100)

| # | Word | Category | Part |
|---|------|----------|------|
| 1 | negotiate | Business | 5,6,7 |
| 2 | revenue | Business | 5,6,7 |
| 3 | budget | Business | 5,6,7 |
| 4 | deadline | Office | 5,6,7 |
| 5 | schedule | Office | 3,4,5,6 |
| 6 | appointment | Office | 3,4,5 |
| 7 | customer | Marketing | 3,4,5,6,7 |
| 8 | applicant | HR | 5,6,7 |
| 9 | reservation | Travel | 3,4,5 |
| 10 | implement | Office | 5,6,7 |
| ... | ... | ... | ... |

---

## Usage Notes

1. **Script Writer** sử dụng corpus này để tạo nội dung chính xác
2. **Quality Reviewer** dùng để validate từ vựng trong videos
3. Mỗi từ đã được kiểm tra từ các nguồn ETS official
4. Collocations là các cụm từ thường gặp trong TOEIC test

---

*Last updated: 2026-01-04*
*Total words: 500+ (expanding to 2000+)*
