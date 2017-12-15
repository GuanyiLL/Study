# Matrices and Vectors

## Matrix-vector multiplication

[1,2,1,5;0,3,0,4;-1,-2,0,0] * [1,3,2,1] = [14,13,-7]
> 1 x 1 + 2 X 3 + 1 x 2 + 5 x 1 = 14
0 x 1 + 3 x 3 + 0 x 2 + 4 x 1 = 13
-1 x 1 + (-2) x 3 + 0 x 2 + 0 x 1 = -7

nxm * nx1 = n(dimensional vector)

将矩阵中的每一行各项元素与向量中对应的每一元素乘积相加

## Matrix-matrix multiplication

[1,3,2;4,0,1] * [1,3;0,1;5,2] = [11,10,9,14]

> [1,3,2;4,0,1] * [1,0,5] = [11,9]
[1,3,2;4,0,1] * [3,1,2] = [10,14]

A x B != B x A

## Identity Matrix

[1,0;0,1] [1,0,0;0,1,0;0,0,1] 为单位矩阵

A * I = I * A = A

## Inverse and transpose

### Matrix inverse
A * A^-1 = A^-1 * A = I

### Matrix transpose

A = [1,2,0; 3,5,9]
A superscript T = [1,3;2,5;0,9]
