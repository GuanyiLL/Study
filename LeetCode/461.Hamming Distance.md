# 461 Hamming Distance

The [Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance) between two integers is the number of positions at which the corresponding bits are different.

Given two integers `x` and `y`, calculate the Hamming distance.

**Note:**
0 ≤ `x`, `y` < 231.

**Example:**

```
Input: x = 1, y = 4

Output: 2

Explanation:
1   (0 0 0 1)
4   (0 1 0 0)
       ↑   ↑

The above arrows point to positions where the corresponding bits are different.
```

**Solution**

```swift
func hammingDistance(_ x: Int, _ y: Int) -> Int {
    let bx = getBinary(n: x)
    let by = getBinary(n: y)
    var res = 0
    let count = max(bx.count, by.count)
    for i in 0..<count {
        var x = 0, y = 0
        if i > bx.count - 1 {
            x = 0
        } else {
            x = bx[i]
        }
        
        if i > by.count - 1 {
            y = 0
        } else {
            y = by[i]
        }
        
        if x != y {
            res += 1
        }
    }
    return res
}

func getBinary(n: Int) -> [Int] {
    var res = [Int]()
    var n = n
    var temp = 0
    while n > 0 {
        temp = n%2
        n /= 2
        res.append(temp)
    }
    return res
}

```



```swift
func hammingDistance(_ x: Int, _ y: Int) -> Int {
    let diff = x ^ y
    
    var result = 0
    
    for char in String(diff, radix: 2) where char == "1" {
        result += 1
    }
    
    return result
}
```

