# Single Number II

Given a **non-empty** array of integers, every element appears *three* times except for one, which appears exactly once. Find that single one.

**Note:**

Your algorithm should have a linear runtime complexity. Could you implement it without using extra memory?

**Example 1:**

```
Input: [2,2,3,2]
Output: 3
```

**Example 2:**

```
Input: [0,1,0,1,0,1,99]
Output: 99
```

**Solution**

```swift
func singleNumber(_ nums: [Int]) -> Int {
    var map = [Int: Int]()
    for n in nums {
        var count = map[n] ?? 0
        count += 1
        map[n] = count
    }
    for (key, value) in map {
        if value == 1 {
            return key
        }
    }
    return -1
}

func singleNumber2(_ nums: [Int]) -> Int {
    let occ = nums.reduce(into: [Int: Int]()) { $0[$1, default: 0] += 1 }
    return occ.first(where: { $0.value == 1 })?.key ?? -1
}

func singleNumber3(_ nums: [Int]) -> Int {
    var one = 0
    var two = 0
    nums.forEach {
        one = (one ^ $0) & ~two
        two = (two ^ $0) & ~one
    }

    return one
}
```

