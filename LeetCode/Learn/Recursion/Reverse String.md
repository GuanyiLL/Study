Write a function that reverses a string. The input string is given as an array of characters `char[]`.

Do not allocate extra space for another array, you must do this by **modifying the input array [in-place](https://en.wikipedia.org/wiki/In-place_algorithm)** with O(1) extra memory.

You may assume all the characters consist of [printable ascii characters](https://en.wikipedia.org/wiki/ASCII#Printable_characters).

 

**Example 1:**

```
Input: ["h","e","l","l","o"]
Output: ["o","l","l","e","h"]
```

**Example 2:**

```
Input: ["H","a","n","n","a","h"]
Output: ["h","a","n","n","a","H"]
```

**Solution**

```swift
func helper(_ idx: Int, _ s: inout [Character]) {
    if idx > (s.count - 1 - idx) {
        return
    }
    let lc = s[idx]
    helper(idx + 1,&s)
    s[idx] = s[s.count - 1 - idx]
    s[s.count - 1 - idx] = lc
}


func reverseString(_ s: inout [Character]) {
    if s.count == 0 {
        return
    }
    helper(0, &s)
}
```

