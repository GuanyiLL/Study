# Computing Parameters Analytically
## Normal Equation

θ=(X^T * X)^(−1) * X^T * y


Gradient Descent	|   Normal Equation
Need to choose alpha	| No need to choose alpha
Needs many iterations |	No need to iterate
O (kn2)	| O (n3), need to calculate inverse of XTX
Works well when n is large | Slow if n is very large

特征值n大于1w之后，考虑使用梯度下降算法，如果1w左右或更小，可以选择正规方程

## Normal Equation Noninvertibility （正规方程不可逆）
Octave 求解反矩阵
* pinv （pseudo-inverse）
* inv  （inverse）

有些时候X置换矩阵与X的乘积不可逆
* 有多余的特征

  E.g x1 = size in feet^2

      x2 = size in m^2
* 太多的特征
  - 删除一些特征，或者做一些整合


If XTX is noninvertible, the common causes might be having :
Redundant features, where two features are very closely related (i.e. they are linearly dependent)
Too many features (e.g. m ≤ n). In this case, delete some features or use "regularization" (to be explained in a later lesson).
