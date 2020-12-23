Given an array of integers `nums` sorted in ascending order, find the starting and ending position of a given `target` value.

If `target` is not found in the array, return `[-1, -1]`.

**Follow up:** Could you write an algorithm with `O(log n)` runtime complexity?

 

**Example 1:**

```
Input: nums = [5,7,7,8,8,10], target = 8
Output: [3,4]
```

**Example 2:**

```
Input: nums = [5,7,7,8,8,10], target = 6
Output: [-1,-1]
```

**Example 3:**

```
Input: nums = [], target = 0
Output: [-1,-1]
```

**Solution**

```swift
func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
    guard nums.count > 0 else {
        return [-1,-1]
    }
    let start = index(nums, true, target)
    if start == nums.count || nums[start] != target {
        return [-1, -1];
    }
    let end = index(nums, false, target) - 1;
    return [start, end]
}

func index(_ nums:[Int] ,_ isLeft: Bool, _ target: Int) -> Int {
    var lo = 0
    var hi = nums.count
    
    while lo < hi {
        let mid = lo + (hi - lo) / 2
        if nums[mid] > target || (isLeft && target == nums[mid]) {
            hi = mid;
        } else {
            lo = mid+1;
        }
    }
    
    return lo
}
```

