Evaluate the value of an arithmetic expression in [Reverse Polish Notation](http://en.wikipedia.org/wiki/Reverse_Polish_notation).

Valid operators are `+`, `-`, `*`, `/`. Each operand may be an integer or another expression.

**Note:**

- Division between two integers should truncate toward zero.
- The given RPN expression is always valid. That means the expression would always evaluate to a result and there won't be any divide by zero operation.

**Example 1:**

```
Input: ["2", "1", "+", "3", "*"]
Output: 9
Explanation: ((2 + 1) * 3) = 9
```

**Example 2:**

```
Input: ["4", "13", "5", "/", "+"]
Output: 6
Explanation: (4 + (13 / 5)) = 6
```

**Example 3:**

```
Input: ["10", "6", "9", "3", "+", "-11", "*", "/", "*", "17", "+", "5", "+"]
Output: 22
Explanation: 
  ((10 * (6 / ((9 + 3) * -11))) + 17) + 5
= ((10 * (6 / (12 * -11))) + 17) + 5
= ((10 * (6 / -132)) + 17) + 5
= ((10 * 0) + 17) + 5
= (0 + 17) + 5
= 17 + 5
= 22
```



**Solution**

```swift
func evalRPN(_ tokens: [String]) -> Int {
    var stack = [Int]()
    var v1 = 0, v2 = 0
    for s in tokens {
        switch s {
        case "+":
            v2 = stack.removeLast()
            v1 = stack.removeLast()
            stack.append(v1 + v2)
            break
        case "-":
            v2 = stack.removeLast()
            v1 = stack.removeLast()
            stack.append(v1 - v2)
            break
        case "*":
            v2 = stack.removeLast()
            v1 = stack.removeLast()
            stack.append(v1 * v2)
            break
        case "/":
            v2 = stack.removeLast()
            v1 = stack.removeLast()
            stack.append(v1 / v2)
            break
        default:
            stack.append(Int(s)!)
        }
    }
    
    return stack.removeLast()
}
```

