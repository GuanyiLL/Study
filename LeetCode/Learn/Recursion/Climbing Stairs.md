You are climbing a staircase. It takes `n` steps to reach the top.

Each time you can either climb `1` or `2` steps. In how many distinct ways can you climb to the top?

 

**Example 1:**

```
Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps
```

**Example 2:**

```
Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step
```

**Solution**

```swift

func climbStairs(_ i: Int, _ n: Int, _ memo:inout [Int]) -> Int {
    if i > n {
        return 0
    }
    if i == n {
        return 1
    }
    if memo[i] > 0 {
        return memo[i]
    }
    memo[i] = climbStairs(i + 1, n, &memo) + climbStairs(i + 2, n, &memo)
    return memo[i]
}

func climbStairs(_ n: Int) -> Int {
    var memo = Array(repeating: 0, count: n+1)
    return climbStairs(0, n, &memo)
}
```

