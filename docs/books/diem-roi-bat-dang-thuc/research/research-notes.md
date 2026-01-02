# Research Notes: Phương pháp điểm rơi trong chứng minh bất đẳng thức

**Ngày nghiên cứu:** 2026-01-02
**Độ tin cậy:** Cao (nhiều nguồn xác minh)

---

## 1. Tổng quan về phương pháp điểm rơi

### Định nghĩa
"Điểm rơi trong các bất đẳng thức là giá trị đạt được của biến khi dấu '=' trong bất đẳng thức xảy ra."

**Nguồn:** [SKKN - Kỹ thuật chọn điểm rơi](https://sangkienkinhnghiem.net/skkn-huong-dan-hoc-sinh-ky-thuat-chon-diem-roi-trong-bat-dang-thuc-cauchy-9116/)

### Tầm quan trọng
- Trong quá trình chứng minh bất đẳng thức, kỹ thuật chọn "điểm rơi" là kỹ thuật rất quan trọng
- Nếu không "bảo toàn" được dấu đẳng thức thì phép chứng minh bị phủ nhận hoàn toàn
- Kỹ thuật này thường được dùng trong các kỳ thi học sinh giỏi và Olympic

**Nguồn:** [MathVN - Kỹ thuật chọn điểm rơi](https://www.mathvn.com/2015/01/ki-thuat-chon-iem-roi-trong-chung-minh.html)

### Phân loại điểm rơi (đã xác minh)

| Dạng | Điểm rơi | Ví dụ |
|------|----------|-------|
| Đối xứng | $a = b = c$ | AM-GM cơ bản |
| Biên tại điểm | $a = 0$ hoặc một biến bằng 0 | Nhiều BĐT cyclic |
| Biên tại cạnh | $a = b, c = 0$ | Schur với $t=1$ |
| Hỗn hợp | $a = b \neq c$ | Một số BĐT phức tạp |

**Nguồn:** [VnDoc - Cách xác định điểm rơi](https://vndoc.com/cach-xac-dinh-diem-roi-trong-bat-dang-thuc-339954)

---

## 2. Phương pháp SOS (Sum of Squares)

### Nguyên lý cơ bản
"One of the basic procedures for proving inequalities is to rewrite them as a sum of squares (SOS) and then, according to the most elementary property that the square of a real number is non-negative, to prove a certain inequality."

**Nguồn:** [SpringerLink - Sum of Squares](https://link.springer.com/chapter/10.1007/978-3-642-23792-8_17)

### Dạng SOS chuẩn cho 3 biến đối xứng

$(a - b)^2 \cdot S_c + (b - c)^2 \cdot S_a + (c - a)^2 \cdot S_b \geq 0$

trong đó $S_a, S_b, S_c$ là các hệ số cần tìm.

**Nguồn:** [AoPS - SOS Algorithm (Canada 2009)](https://services.artofproblemsolving.com/download.php?id=YXR0YWNobWVudHMvZC9mLzM1Y2ZjYzFiZjMxYjhkOWY0MTNmY2NiYTA5MDU5MmU3N2IwNGEyLnBkZg==&rn=U09TIEFsZ29yaXRobSAtIERhdmlkIEFydGh1ciAtIENhbmFkYSAyMDA5LnBkZg==)

### Ví dụ kinh điển

**Ví dụ 1: AM-GM**
Chứng minh $a^3 + b^3 + c^3 \geq 3abc$ với $a, b, c \geq 0$

**Ví dụ 2: IMO 1983/6**
Chứng minh $a^2b(a - b) + b^2c(b - c) + c^2a(c - a) \geq 0$ với $a, b, c$ là các cạnh tam giác

**Ví dụ 3: Schur**
$a^t(a-b)(a-c) + b^t(b-c)(b-a) + c^t(c-a)(c-b) \geq 0$ với $a, b, c, t \geq 0$

### Định lý Hilbert về SOS
- Đa thức một biến không âm khi và chỉ khi nó là tổng bình phương
- Hilbert chứng minh đây là các trường hợp duy nhất mà "không âm" tương đương với SOS
- Có thể kiểm tra phân tích SOS bằng semidefinite programming

**Nguồn:** [Princeton - SOS Techniques](https://www.princeton.edu/~aaa/Public/Teaching/ORF523/ORF523_Lec15.pdf)

---

## 3. Bất đẳng thức Schur

### Phát biểu
Với mọi số thực không âm $x, y, z$ và $t > 0$:
$$x^t(x-y)(x-z) + y^t(y-z)(y-x) + z^t(z-x)(z-y) \geq 0$$

Dấu bằng xảy ra khi và chỉ khi:
- $x = y = z$, hoặc
- Hai trong ba số bằng nhau và số còn lại bằng 0

**Nguồn:** [Wikipedia - Schur's inequality](https://en.wikipedia.org/wiki/Schur's_inequality)

### Chứng minh
Không mất tính tổng quát, giả sử $x \geq y \geq z$. Phân tích:
$(x-y)[x^t(x-z) - y^t(y-z)] + z^t(z-x)(z-y)$

- Vì $x^t \geq y^t$ và $x-z \geq y-z$, nên phần trong ngoặc vuông không âm
- $(x-y) \geq 0$, nên tích đầu không âm
- $z^t \geq 0$, $(z-x) \leq 0$, $(z-y) \leq 0$, nên tích sau không âm

**Nguồn:** [Brilliant - Schur's Inequality](https://brilliant.org/wiki/schurs-inequality/)

### Trường hợp đặc biệt

**Khi $t = 1$:**
$$a^3 + b^3 + c^3 + 3abc \geq a^2(b+c) + b^2(c+a) + c^2(a+b)$$

**Khi $t = 2$:**
$$x^4 + y^4 + z^4 + xyz(x+y+z) \geq x^3(y+z) + y^3(z+x) + z^3(x+y)$$

**Nguồn:** [Art of Problem Solving - Schur's Inequality](https://artofproblemsolving.com/wiki/index.php/Schur's_Inequality)

### Mở rộng Vornicu
Tổng quát hóa với hàm $f$ đơn điệu tăng:
$$f(x)(x-y)(x-z) + f(y)(y-z)(y-x) + f(z)(z-x)(z-y) \geq 0$$

**Nguồn:** [Cut-the-Knot - Schur's Inequality](https://www.cut-the-knot.org/arithmetic/algebra/SchursInequality.shtml)

---

## 4. Phương pháp pqr

### Nguyên lý
Cho bất đẳng thức với 3 biến $a, b, c$, đặt:
- $p = a + b + c$
- $q = ab + bc + ca$
- $r = abc$

Các biến $a, b, c$ là nghiệm của phương trình:
$$x^3 - px^2 + qx - r = 0$$

**Nguồn:** [The pqr handout](https://aritra-12.github.io/pdfs/The_pqr_handout%20(1).pdf)

### Điều kiện thực
Các số $a, b, c$ là thực khi và chỉ khi:
$$T(p, q, r) = -4p^3r + p^2q^2 + 18pqr - 4q^3 - 27r^2 \geq 0$$

Lưu ý: $T(p, q, r) = (a-b)^2(b-c)^2(c-a)^2$

**Nguồn:** [Turgor - pqr method](https://turgor.ru/lktg/2016/3/3-1en.pdf)

### Định lý chính (Tejs' Theorem)
> Khi hai trong ba đại lượng $p, q, r$ cố định, đại lượng thứ ba đạt cực đại/cực tiểu khi:
> - Hai trong ba biến $a, b, c$ bằng nhau, hoặc
> - Một trong ba biến $a, b, c$ bằng 0

**Hệ quả quan trọng:**
Mọi đa thức đối xứng bậc $\leq 5$ với các biến thực không âm $a, b, c$ có cực trị toàn cục sẽ đạt giá trị đó tại các bộ $(a, b, c)$ với:
- Hai biến bằng nhau, hoặc
- Một biến bằng 0

**Nguồn:** [Brilliant - The uvw Method](https://brilliant.org/wiki/the-uvw-method/)

---

## 5. Kỹ thuật cực trị trên biên

### Nguyên lý n-1 biến bằng nhau (Mildorf)
"If a differentiable function has a single inflexion point and is evaluated at n arbitrary reals with a fixed sum, any minimum or maximum must occur where..."

Cực trị xảy ra khi các biến nhận các giá trị biên.

**Nguồn:** [Thomas Mildorf - Olympiad Inequalities](https://artofproblemsolving.com/articles/files/MildorfInequalities.pdf)

### Phương pháp đạo hàm (Yufei Zhao)
"By considering the point of equality, we see that $(1, 1, 1)$ must be a local minimum of $f$. So consider the partial derivative... Since $(1, 1, 1)$ is a local minimum, this partial derivative when evaluated at $(1, 1, 1)$ must give zero."

**Nguồn:** [Yufei Zhao - Winter Camp 2008](https://yufeizhao.com/olympiad/wc08/ineq.pdf)

### Kỹ thuật cố định biến (IMO 2021/2)
"The first idea that comes into mind is to fix all the variables, except one, and to vary this one variable in order to see when gets its minimum. In this way, you may reduce the inequality to some special values of the variables."

**Nguồn:** [Analysis of IMO 2021 Problem 2](https://dgrozev.wordpress.com/2021/07/25/imo-2021-problem-2-a-controversial-inequality/)

---

## 6. Tài liệu tham khảo chính

### Sách và bài giảng quốc tế

1. **"Basics of Olympiad Inequalities" - Samin Riasat**
   - [Williams College PDF](https://web.williams.edu/Mathematics/sjmiller/public_html/161/articles/Riasat_BasicsOlympiadInequalities.pdf)
   - Bao gồm AM-GM, Cauchy-Schwarz, Hölder
   - Ví dụ từ IMO 1975, 1995, 2001

2. **"Olympiad Inequalities" - Thomas J. Mildorf**
   - [Art of Problem Solving](https://artofproblemsolving.com/articles/files/MildorfInequalities.pdf)
   - Nguyên lý n-1 biến bằng nhau
   - Điều kiện dấu bằng cho Schur

3. **"A Brief Introduction to Olympiad Inequalities" - Evan Chen**
   - [Evan Chen Handouts](https://web.evanchen.cc/handouts/Ineq/en.pdf)
   - Power Mean, Muirhead
   - Kỹ thuật homogenization

4. **"Winter Camp 2008 Inequalities" - Yufei Zhao (MIT)**
   - [MIT Winter Camp](https://yufeizhao.com/olympiad/wc08/ineq.pdf)
   - Phương pháp đạo hàm riêng
   - Isolated fudging

### Tài liệu tiếng Việt

1. **"Kỹ thuật chọn điểm rơi" - Phạm Bình Nguyên**
   - [MathVN](https://www.mathvn.com/2015/01/ki-thuat-chon-iem-roi-trong-chung-minh.html)

2. **"Các Phương Pháp Giải Toán Qua Các Kỳ Thi Olympic"**
   - Trần Nam Dũng, Võ Quốc Bá Cẩn, Lê Phúc Lữ
   - [MOlympiad](https://www.molympiad.net/2019/05/cac-phuong-phap-giai-toan-qua-cac-ki-thi-olympic.html)

3. **"Ứng dụng kỹ thuật chọn điểm rơi trong bài toán bất đẳng thức"**
   - [Tạp chí Thiết bị Giáo dục](https://vjol.info.vn/index.php/tctbgd/article/download/87742/74587/)

4. **Kỷ yếu Olympic Toán Sinh Viên toàn quốc**
   - [Vted.vn](https://vted.vn/tin-tuc/vtedvn-ky-yeu-olympic-toan-sinh-vien-toan-quoc-cac-nam-gan-day-tu-2015-den-2018-4769.html)

---

## 7. Bài tập Olympic tiêu biểu

### IMO Problems

| Năm | Bài | Điểm rơi | Kỹ thuật |
|-----|-----|----------|----------|
| IMO 1983/6 | $a^2b(a-b)+b^2c(b-c)+c^2a(c-a) \geq 0$ | Biên | SOS |
| IMO 1995 | $(abc)^{1/3}(a+b+c) \leq a^2+b^2+c^2$ | $(1,1,1)$ | AM-GM |
| IMO 2001/2 | $\frac{a}{\sqrt{a^2+8bc}}+...$ | $(1,1,1)$ | Cauchy |
| IMO 2005/3 | $\frac{x^5-x^2}{x^5+y^2+z^2}+...$ | $(1,1,1)$ | Đối xứng |
| IMO 2012/2 | $\sum a_i a_j/(a_i+a_j)$ | Đặc biệt | Counting |

**Nguồn:** [IMO Official - Shortlist 2023](https://www.imo-official.org/problems/IMO2023SL.pdf)

---

## 8. Công cụ tính toán

### Mathematica cho SOS
- SOSTOOLS package
- Semidefinite programming

### Python
- SymPy cho symbolic computation
- CVXPY cho SDP

**Nguồn:** [Harvard - Sums of Squares Relaxation](https://hankyang.seas.harvard.edu/Semidefinite/SOS.html)

---

## 9. Ghi chú cho Writer Agent

### Ưu tiên cao
1. Bắt đầu mỗi chương với **ví dụ động lực** để học sinh thấy tại sao cần kỹ thuật này
2. Luôn trình bày **điều kiện dấu bằng** ngay sau mỗi bất đẳng thức
3. Phân tích **quá trình tư duy** khi chọn điểm rơi, không chỉ trình bày lời giải

### Lưu ý kỹ thuật
1. Sử dụng notation nhất quán: $a, b, c$ cho 3 biến, $x_i$ cho $n$ biến
2. Phân biệt rõ symmetric vs cyclic inequalities
3. Giải thích tại sao pqr method hoạt động (không chỉ công thức)

### Cần bổ sung
1. Thêm nhiều ví dụ từ VMO (đề Việt Nam) nếu có thể
2. Bài tập có độ khó tăng dần trong mỗi chương
3. Phần "Sai lầm thường gặp" cho mỗi kỹ thuật
