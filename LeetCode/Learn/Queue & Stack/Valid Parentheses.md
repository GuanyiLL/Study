Given a string `s` containing just the characters `'('`, `')'`, `'{'`, `'}'`, `'['` and `']'`, determine if the input string is valid.

An input string is valid if:

1. Open brackets must be closed by the same type of brackets.
2. Open brackets must be closed in the correct order.

 

**Example 1:**

```
Input: s = "()"
Output: true
```

**Example 2:**

```
Input: s = "()[]{}"
Output: true
```

**Example 3:**

```
Input: s = "(]"
Output: false
```

**Example 4:**

```
Input: s = "([)]"
Output: false
```

**Example 5:**

```
Input: s = "{[]}"
Output: true
```

 

**Constraints:**

- `1 <= s.length <= 104`
- `s` consists of parentheses only `'()[]{}'`.



**Solution**

my solution

```swift

func isValid(_ s: String) -> Bool {
    var stack = [Character]()
    for c in s {
        if c == "(" || c == "[" || c == "{" {
            stack.append(c)
        }
        if c == ")" {
            let l = stack.last
            if l != "(" {
                return false
            } else {
                stack.removeLast()
            }
        }
        if c == "]" {
            let l = stack.last
            if l != "[" {
                return false
            } else {
                stack.removeLast()
            }
        }
        if c == "}" {
            let l = stack.last
            if l != "{" {
                return false
            } else {
                stack.removeLast()
            }
        }
    }
    if stack.count > 0 {
        return false
    }
    return true
}
```

best solution:

```swift
func isValid(_ s: String) -> Bool {
    var map: [Character: Character] = ["(":")",
               "[":"]",
               "{":"}"]
    var stack = [Character]()
    for ch in s {
        if let open = map[ch] {
            stack.append(open)
        } else if stack.isEmpty || stack.removeLast() != ch {
            return false
        }
    }
    return stack.isEmpty
}
```

