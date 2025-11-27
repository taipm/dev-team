# Ví dụ Kiểm tra Math-Teacher Agent

## Bài tập 1: Giải tích Tích phân

**Yêu cầu:** Giải thích khái niệm integral theo cả tiếng Việt và tiếng Anh

### Tiếng Việt
Phép tích phân là phép toán ngược của phép đạo hàm. Nếu f(x) là đạo hàm của F(x), thì:

$$\int f(x) dx = F(x) + C$$

Trong đó C là hằng số tích phân.

### Tiếng Anh
Integration is the reverse operation of differentiation. If f(x) is the derivative of F(x), then:

$$\int f(x) dx = F(x) + C$$

Where C is the constant of integration.

## Bài tập 2: Đại số tuyến tính

**Matrix Operations:**

Given matrix A =
$$\begin{bmatrix} 2 & 1 \\ 3 & 4 \end{bmatrix}$$

Find det(A):

### Tiếng Việt
Định thức của ma trận 2×2:
$$\det(A) = ad - bc = (2)(4) - (1)(3) = 8 - 3 = 5$$

### English
The determinant of a 2×2 matrix:
$$\det(A) = ad - bc = (2)(4) - (1)(3) = 8 - 3 = 5$$

## Kiểm tra Agent

Math-teacher agent (Tân) nên:
1. Giải thích các khái niệm toán học bằng cả hai ngôn ngữ
2. Sử dụng LaTeX notation chính xác
3. Cung cấp examples và exercises
4. Biên tập và proofread content
5. Tạo tài liệu học thuật chất lượng

### Workflow Test
```
User: "Giải thích Pythagorean theorem song ngữ Việt-Anh"
→ math-teacher (Tân): Bilingual explanation with LaTeX
→ code-reviewer: Content quality review
→ Output: Professional bilingual math content
```