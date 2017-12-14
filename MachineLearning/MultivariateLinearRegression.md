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

## Gradient Descent in Practice 2 - Learning Rate

Debugging gradient descent. Make a plot with number of iterations on the x-axis. Now plot the cost function, J(θ) over the number of iterations of gradient descent. If J(θ) ever increases, then you probably need to decrease α.

Automatic convergence test. Declare convergence if J(θ) decreases by less than E in one iteration, where E is some small value such as 10−3. However in practice it's difficult to choose this threshold value.

If α is too small: slow convergence.

If α is too large: ￼may not decrease on every iteration and thus may not converge.

如果学习速率过小，那么收敛的速度会非常慢
如果学习速率过大，那么可能将不会在每次迭代中逐渐减小，最终无法收敛
