You are given an integer array `nums` sorted in ascending order, and an integer `target`.

Suppose that `nums` is rotated at some pivot unknown to you beforehand (i.e., `[0,1,2,4,5,6,7]` might become `[4,5,6,7,0,1,2]`).

*If `target` is found in the array return its index, otherwise, return `-1`.*

 

**Example 1:**

```
Input: nums = [4,5,6,7,0,1,2], target = 0
Output: 4
```

**Example 2:**

```
Input: nums = [4,5,6,7,0,1,2], target = 3
Output: -1
```

**Example 3:**

```
Input: nums = [1], target = 0
Output: -1
```

**Solution**

```swift
func search(_ nums: [Int], _ target: Int) -> Int {
    var low = 0
    var high = nums.count - 1
    
    while low < high {
        let mid = low + (high - low) / 2
        if nums[mid] == target { return mid }
        
        if nums[low] <= nums[mid] {
            if target < nums[mid] && nums[low] <= target {
                high = mid - 1
            } else {
                low = mid + 1
            }
        } else {
            if target > nums[mid] && target <= nums[high] {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
    }
    return nums[low] == target ? low : -1;
}
```

