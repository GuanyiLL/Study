# Multiple Linear Regression (多元线性回归)
## Multiple Features

The multivariable form of the hypothesis function accommodating these multiple features is as follows:

hθ(x)=θ0+θ1x1+θ2x2+θ3x3+⋯+θnxn

hθ(x)=[θ0θ1...θn]⎡⎣⎢⎢⎢⎢x0x1⋮xn⎤⎦⎥⎥⎥⎥=θTx

## Gradient Descent in Practice 1 - Feature Scaling

为了使梯度下降算法运行更快，将x的值控制在-1到1之间（-3~3或者-1/3~1/3都可）。
特征缩放的方法则是将xi赋值为xi减去训练模型的平均值再除以最大值与最小值之差

xi := （xi - ui）/ Si

Where μi is the average of all the values for feature (i) and si is the range of values (max - min), or si is the standard deviation.

For example, if xi represents housing prices with a range of 100 to 2000 and a mean value of 1000, then,

xi:=(price−1000)/1900.
