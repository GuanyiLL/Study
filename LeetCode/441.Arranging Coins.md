# Arranging Coins

Solution

You have a total of *n* coins that you want to form in a staircase shape, where every *k*-th row must have exactly *k* coins.

Given *n*, find the total number of **full** staircase rows that can be formed.

*n* is a non-negative integer and fits within the range of a 32-bit signed integer.

**Example 1:**

```
n = 5

The coins can form the following rows:
¤
¤ ¤
¤ ¤

Because the 3rd row is incomplete, we return 2.
```



**Example 2:**

```
n = 8

The coins can form the following rows:
¤
¤ ¤
¤ ¤ ¤
¤ ¤

Because the 4th row is incomplete, we return 3.
```

**Solution**

```swift
func arrangeCoins(_ n: Int) -> Int {
    var n = n
    var row = 1
    while true {
        n -= row
        if n < 0 {
            return row - 1
        }
        row += 1
    }
}

func arrangeCoins(_ n: Int) -> Int {
    var left = 0, right = n
    var k = 0, curr = 0;
    while left <= right {
        k = left + (right - left) / 2;
        curr = k * (k + 1) / 2;
        
        if curr == n { return k }
        
        if (n < curr) {
            right = k - 1;
        } else {
            left = k + 1;
        }
    }
    return rig
```

