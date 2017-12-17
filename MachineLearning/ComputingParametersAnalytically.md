# Computing Parameters Analytically
## Normal Equation

θ=(X^T * X)^(−1) * X^T * y


Gradient Descent	|   Normal Equation
Need to choose alpha	| No need to choose alpha
Needs many iterations |	No need to iterate
O (kn2)	| O (n3), need to calculate inverse of XTX
Works well when n is large | Slow if n is very large

特征值n大于1w之后，考虑使用梯度下降算法，如果1w左右或更小，可以选择正规方程
