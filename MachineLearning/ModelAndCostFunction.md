## Model Representation

To establish notation for future use, we’ll use x(i) to denote the “input” variables (living area in this example), also called input features, and y(i) to denote the “output” or target variable that we are trying to predict (price). A pair (x(i),y(i)) is called a training example, and the dataset that we’ll be using to learn—a list of m training examples (x(i),y(i));i=1,...,m—is called a training set. Note that the superscript “(i)” in the notation is simply an index into the training set, and has nothing to do with exponentiation. We will also use X to denote the space of input values, and Y to denote the space of output values. In this example, X = Y = ℝ.

To describe the supervised learning problem slightly more formally, our goal is, given a training set, to learn a function h : X → Y so that h(x) is a “good” predictor for the corresponding value of y. For historical reasons, this function h is called a hypothesis. Seen pictorially, the process is therefore like this:

                    Training set
                        |
                        |
                Learning algorithm
                        |
                        |
                x---->  h ----> predicted y
            (living area        (predicted price of house)
            of house)


When the target variable that we’re trying to predict is continuous, such as in our housing example, we call the learning problem a regression problem. When y can take on only a small number of discrete values (such as if, given the living area, we wanted to predict if a dwelling is a house or an apartment, say), we call it a classification problem.

## Cost Function

We can measure the accuracy of our hypothesis function by using a cost function. This takes an average difference (actually a fancier version of an average) of all the results of the hypothesis with inputs from x's and the actual output y's.

J(θ0,θ1)=12m∑i=1m(y^i−yi)^2=12m∑i=1m(hθ(xi)−yi)^2
To break it apart, it is 12 x¯ where x¯ is the mean of the squares of hθ(xi)−yi , or the difference between the predicted value and the actual value.

This function is otherwise called the "Squared error function", or "Mean squared error". The mean is halved (12) as a convenience for the computation of the gradient descent, as the derivative term of the square function will cancel out the 12 term. The following image summarizes what the cost function does:

![cost function](/img/CostFunction01.jpg)


## Gradient Descent (梯度下降算法)

 Θj := Θj - α * δ/δθj J(θ0，θ1)

:= 赋值运算符

α  学习速率

δ/δθj J(θ0，θ1) 微分项

梯度下降计算

temp0 := Θ0 - α * δ/δθ0

temp1 := Θ1 - α * δ/δθ1

Θ0 := temp0

Θ1 := temp1

必须是同步更新，而不是将通过计算得出的Θ0带入到公式中求出Θ1
