Given a **positive** integer *num*, write a function which returns True if *num* is a perfect square else False.

**Follow up:** **Do not** use any built-in library function such as `sqrt`.

 

**Example 1:**

```
Input: num = 16
Output: true
```

**Example 2:**

```
Input: num = 14
Output: false
```

 

**Constraints:**

- `1 <= num <= 2^31 - 1`



**Solution**

```swift
class Solution {
    func isPerfectSquare(_ num: Int) -> Bool {
        if num <= 1 { return true }
        var lo = 0
        var hi = num / 2
        while lo <= hi {
            let mid = lo + (hi - lo) / 2
            if mid * mid == num {
                return true
            } else if mid * mid > num {
                hi = mid - 1
            } else {
                lo = mid + 1
            }
        }
        return false
    }
}
```

