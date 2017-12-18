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
