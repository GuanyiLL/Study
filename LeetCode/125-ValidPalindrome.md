# 125 Valid Palindrome

Given a string, determine if it is a palindrome, considering only alphanumeric characters and ignoring cases.

**Note:** For the purpose of this problem, we define empty string as valid palindrome.

**Example 1:**

```
Input: "A man, a plan, a canal: Panama"
Output: true
```

**Example 2:**

```
Input: "race a car"
Output: false
```

 

**Constraints:**

- `s` consists only of printable ASCII characters.

**Solution**

```swift
func isPalindrome(_ s: String) -> Bool {
    guard s.count > 0 else {
        return true
    }
    let str = s.uppercased()
    var l = s.startIndex
    var r = s.index(before: s.endIndex)
    while l < r {
        let lc = str[l]
        if !(lc.isNumber || lc.isLetter) {
            l = str.index(after: l)
            continue
        }
        let rc = str[r]
        if !(rc.isNumber || rc.isLetter) {
            r = str.index(before: r)
            continue
        }
        if lc != rc {
            return false
        }
        l = str.index(after: l)
        r = str.index(before: r)
    }
    return true
}
```



```go
import "strings"

func isNumber(s byte) bool {
	return s >= '0' && s <= '9'
}

func isLetter(s byte) bool {
	return s >= 'A' && s <= 'Z'
}

func isPalindrome(s string) bool {
	if len(s) == 0 {
		return true
	}
	str := strings.ToUpper(s)
	l := 0
	r := len(str) - 1
	for l < r {
		lc := str[l]
		if !(isLetter(lc) || isNumber(lc)) {
			l++
			continue
		}
		rc := str[r]
		if !(isLetter(rc) || isNumber(rc)) {
			r--
			continue
		}
		if lc != rc {
			return false
		}
		l++
		r--
	}
	return true
}
```

