# 58.Length of Last Word

Given a string *s* consists of upper/lower-case alphabets and empty space characters `' '`, return the length of last word (last word means the last appearing word if we loop from left to right) in the string.

If the last word does not exist, return 0.

**Note:** A word is defined as a **maximal substring** consisting of non-space characters only.

**Example:**

```
Input: "Hello World"
Output: 5
```

**My Solution**

```swift
func lengthOfLastWord(_ s: String) -> Int {
    var lastWord = ""
    var temp = ""
    for c in s {
        if c == " " {
            if temp.count > 0 {
                lastWord = temp
            }
            temp = ""
        } else {
            temp.append(c)
        }
    }
    if temp.count > 0 {
        return temp.count
    }
    return lastWord.count
}
```



**Fastest Solution**

```swift
func lengthOfLastWord(_ s: String) -> Int {
    var ans = 0
    
    for ch in s.reversed() {
        if ch != " " {
            ans += 1
        } else if ans > 0 {
            return ans
        }
    }
    
    return ans
}
```

