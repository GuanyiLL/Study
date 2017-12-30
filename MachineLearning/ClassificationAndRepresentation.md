# Classification and Representation

## Classification
解决分类问题时，也可以使用线性回归，将大于0.5的预测值当做1，小于0.5的预测值当做0.但是这样的方式并不是很好，因为分类不是线性函数。
分类问题的预测结果为离散值，y只能取0或1.例如垃圾邮件分类问题。那么x(i)可能是一封电子邮件的一些特征，如果它是一封垃圾邮件，y可以是1，否则为0。因此，y∈{0,1}。 0也称为负类，1是正类，有时也用符号“ - ”和“+”表示。

## Hypothesis Representation
Logistic Regression Model (逻辑回归模型)

want 0 <= h(x) <= 1

Sigmoid function
Logistic function

```
hθ(x)=g(θ^T * x)
z=θ^T * x
g(z)=1/(1+e^−z)
```
```
hθ(x)=P(y=1|x;θ)=1−P(y=0|x;θ)
P(y=0|x;θ)+P(y=1|x;θ)=1
```
## Decision Boundary
当假想函数h(x)的值大于或等于0.5时，预测值y=1。

当假想函数h(x)的值小于0.5时，预测值y=0.

当逻辑函数g的输入值大于或等于0时，则输出值大于或等于0.5.
```
z=0,e^0=1⇒g(z)=1/2
z→∞,e^−∞→0⇒g(z)=1
z→−∞,e^∞→∞⇒g(z)=0
```
# Logistic Regression Model
## Cost function
如果我们用线性回归函数的代价函数，我们得到的代价函数将是一个非凸函数，导致我们的代价函数有多个局部最小值，将影响我们使用梯度下降算法寻找全局最小值。
hθ(x)跟Cost(hθ(x),y)的关系
* 当y=1时，Cost(hθ(x),y)=−log(hθ(x))
* 当y=0时，Cost(hθ(x),y)=−log(hθ(1−x))

构建Cost(hθ(x),y)的特点
* 当实际的y=1且hθ也为1时代价函数值为0，当y=1但hθ不为1时代价随着hθ的变小而变大
* 当实际的y=0且hθ也为0时代价函数值为0，当y=1但hθ不为1时代价随着hθ的变大而变大
$ J(\theta) = -\frac{1}{2} [\sum_{i=1}^m y^(i) log(h_\theta (x^(i))) + (1-y^(i)) log(1-h_\theta (x^(i) ))] $
