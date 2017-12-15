# Computing Parameters Analytically
## Normal Equation

θ=(X^T * X)^(−1) * X^T * y


Gradient Descent	|   Normal Equation
Need to choose alpha	| No need to choose alpha
Needs many iterations |	No need to iterate
O (kn2)	| O (n3), need to calculate inverse of XTX
Works well when n is large | Slow if n is very large
