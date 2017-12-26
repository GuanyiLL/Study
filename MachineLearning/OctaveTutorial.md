# Octave/Matlab Tutorial

## Basic Operations

PS1('>> ') 用来简化输出前缀（octave-3.2.4.exe:11 -> >>）

% semicolon supressing output 使变量不会自动打印到控制台上
（a = 3；）

disp命令用来打印属性的值
```
a = pi;
a // a = 3.1416
disp(a)   // 3.1416
disp(sprintf('2 decimals: %0.2f'. a)) //2 decimals: 3.14
```

format long
format short（默认的输出格式）

v = 1：0.1：2
生成一个从1开始，步长为0.1到2的向量
v = [1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2]
v = 1:6
v = [1,2,3,4,5,6]

ones(2,3) //生成一个2x3的矩阵，元素都为1
ans = [1,1,1; 1,1,1]

zeros(1,3) //生成一个1x3元素都为0的矩阵

rand(1,3) //生成一个1x3的矩阵，元素都为0~1之间的随机数

randn(1,3)
w = [-0.33517, 1.26847, -0.28211] //平均值为0的高斯分布方差或等于1的标准偏差

w = -6 + sqrt(10)(randn(1, 10000))
hist(w) //画出直方图

eye(4) 生成一个 4x4 的单位矩阵

## Computing on Data
A .* B 将矩阵A中的每一个元素与矩阵B中的对应元素相乘

A .^ 2 将矩阵A中的每个元素平方

1 ./ A 将A矩阵的各个元素被1除

log(v) 对矩阵V中元素做对数运算

exp(v) 自然数e的幂次运算

abs(v) 对每个元素求绝对值

- v === -1 * v

v + ones(length(v),1) //V为3x1的向量

将v中各元素都加1 等同于 v+1

A' 求矩阵A的置换矩阵

a = [1 15 2 0.5]

val = max(a)

val = 15

[val, ind] = max(a) // val 为 a中最大值， ind 为对应索引

a < 3 // ans = 1 0 1 1  各项对比后的bool值

find(a < 3) // ans = [1 3 4] 找出满足条件的索引

A = magic(3) // magic 生成行、列、对角线相加为同一个值的矩阵

```
A =
    8   1   6
    3   5   7
    4   9   2
```

[r , c] = find(A >= 7)
```
r =
    1
    3
    2

c =
    1
    2
    3
```
代表第一行第一列、第三行第二列、第二行第三列的元素满足>=7的条件

sum(a) 求出a中各个元素总和

prod(a) 求出a中各个元素的成绩

floor(a) 将a中元素向下取整

ceil(a) 将a中元素向上取整

```
A =
    8   1   6
    3   5   7
    4   9   2

max(A, [], 1)

ans =
    8   9   7

每一列的最大元素（1代表每一列）

max(A, [], 2)
ans =
    8
    7
    9

每一行的最大元素 （2代表每一列）

```
A（:） //将A转换成向量

A = magic(9)

sum(A,1) //对每一列求和，构成一个1x9

sum(A,2) //对每一行求和，构成一个9x1的向量

A .* eye(9)
```
ans =
  47  0   0   0   0   0   0   0   0
  0   68  0   0   0   0   0   0   0
  0   0   8   0   0   0   0   0   0
  0   0   0   20  0   0   0   0   0
  0   0   0   0   41  0   0   0   0
  0   0   0   0   0   62  0   0   0
  0   0   0   0   0   0   74  0   0
  0   0   0   0   0   0   0   14  0
  0   0   0   0   0   0   0   0   35
```

sum(sum(A. * eye(9)))   //1，1到9，9

sum(sum(A. * flipud(eye(9))))  //9，1 到 1，9

以上都是求对角线的和

pinv(A) 求出A矩阵的反矩阵A^-1

## Plotting Data

## Control Statements
```
v = zeros(10,1) //10x1的元素都为0的向量

for i = 1 : 10,  
  v(i) = 2 ^ i;
end;

v =
  2
  4
  8
  16
  32
  64
  128
  256
  512
  1024

indices = 1:10;   // 与 i=1:10 等价
for i = indices,
  disp(i)
end;

i = 1;
while i <= 5,
  v(i) = 100;
  i = i + 1;
end;

i = 1;
while true,
  v(i) = 999;
  i = i+1;
  if i == 6,
    break;
  end;
end;

```

addpath(‘/Users/kq/Desktop‘) //为octave添加环境路径以找到文件

```
>> [a,b] = squareAndCubeThisNumber(5);
>> a
a =  25
>> b
b =  125
>>
```

## Vectorization 

Unvectorized implemention

```
prediction = 0
for j = 1:n+1
  prediction = prediction + theta(j) * x(y)
end;
```

Vectorized implementation
```
prediction = theta' * x;
```