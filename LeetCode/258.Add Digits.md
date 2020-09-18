# 258 Add Digits

Given a non-negative integer `num`, repeatedly add all its digits until the result has only one digit.

**Example:**

```
Input: 38
Output: 2 
Explanation: The process is like: 3 + 8 = 11, 1 + 1 = 2. 
             Since 2 has only one digit, return it.
```

**Follow up:**
Could you do it without any loop/recursion in O(1) runtime?

**Solution**

```swift

func addDigits(_ num: Int) -> Int {
    var total = 0
    var n = num
    while n > 0 {
        total = total + (n % 10)
        n /= 10
    }
    
    if total / 10 != 0 {
        return addDigits(total)
    }
    
    return total
}
```

```go
func addDigits(num int) int {
	total := 0
	for num > 0 {
		total = total + (num % 10)
		num = num / 10
	}

	if total/10 > 0 {
		return addDigits(total)
	}

	return total
}
```

