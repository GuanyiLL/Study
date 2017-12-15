# Multiple Linear Regression (多元线性回归)
## Multiple Features

The multivariable form of the hypothesis function accommodating these multiple features is as follows:

hθ(x)=θ0+θ1x1+θ2x2+θ3x3+⋯+θnxn

hθ(x)=[θ0θ1...θn]⎡⎣⎢⎢⎢⎢x0x1⋮xn⎤⎦⎥⎥⎥⎥=θTx

## Gradient Descent in Practice 1 - Feature Scaling （特征缩放）

为了使梯度下降算法运行更快，将x的值控制在-1到1之间（-3~3或者-1/3~1/3都可）。
特征缩放的方法则是将xi赋值为xi减去训练模型的平均值再除以最大值与最小值之差

xi := （xi - ui）/ Si

Where μi is the average of all the values for feature (i) and si is the range of values (max - min), or si is the standard deviation.

For example, if xi represents housing prices with a range of 100 to 2000 and a mean value of 1000, then,

xi:=(price−1000)/1900.

## Gradient Descent in Practice 2 - Learning Rate （学习速率）

Debugging gradient descent. Make a plot with number of iterations on the x-axis. Now plot the cost function, J(θ) over the number of iterations of gradient descent. If J(θ) ever increases, then you probably need to decrease α.

Automatic convergence test. Declare convergence if J(θ) decreases by less than E in one iteration, where E is some small value such as 10^−3. However in practice it's difficult to choose this threshold value.

If α is too small: slow convergence.

If α is too large: ￼may not decrease on every iteration and thus may not converge.

如果学习速率过小，那么收敛的速度会非常慢
如果学习速率过大，那么可能将不会在每次迭代中逐渐减小，最终无法收敛

## Features and Polynomial Regression (多项式回归)

We can improve our features and the form of our hypothesis function in a couple different ways.

We can combine multiple features into one. For example, we can combine x1 and x2 into a new feature x3 by taking x1⋅x2.

Polynomial Regression

Our hypothesis function need not be linear (a straight line) if that does not fit the data well.

We can change the behavior or curve of our hypothesis function by making it a quadratic, cubic or square root function (or any other form).

For example, if our hypothesis function is hθ(x)=θ0+θ1x1 then we can create additional features based on x1, to get the quadratic function hθ(x)=θ0+θ1x1+θ2x21 or the cubic function hθ(x)=θ0+θ1x1+θ2x21+θ3x31
In the cubic version, we have created new features x2 and x3 where x2=x21 and x3=x31.

To make it a square root function, we could do: hθ(x)=θ0+θ1x1+θ2x1‾‾√
One important thing to keep in mind is, if you choose your features this way then feature scaling becomes very important.

eg. if x1 has range 1 - 1000 then range of x21 becomes 1 - 1000000 and that of x31 becomes 1 - 1000000000
