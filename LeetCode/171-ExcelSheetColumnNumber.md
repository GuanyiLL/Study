# Description

Given a column title as appear in an Excel sheet, return its corresponding column number.

#### Ex

```

    A -> 1
    B -> 2
    C -> 3
    ...
    Z -> 26
    AA -> 27
    AB -> 28 

```

**Solution**

```c++

    int titleToNumber(string s) {
        int res = 0;
        for (char c:s) {
            res *= 26;
            res += c - 'A' + 1;
        }
        return res;
    }

```

```swift
func titleToNumber(_ s: String) -> Int {
    var res:Double = 0
    for (idx, c) in s.enumerated() {
        let charVal = Double(c.asciiValue! - Character("A").asciiValue! + 1)
        res += charVal * pow(26.0, Double(s.count - idx - 1))
    }
    return Int(res)
}
```

