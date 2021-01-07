Given an array of integers `nums`, sort the array in ascending order.

**Example 1:**

```
Input: nums = [5,2,3,1]
Output: [1,2,3,5]
```

**Example 2:**

```
Input: nums = [5,1,1,2,0,0]
Output: [0,0,1,1,2,5]
```

**Solution**

```swift
class Solution {
    func sortArray(_ nums: [Int]) -> [Int] {
        if nums.count <= 1 {
            return nums
        }
        let pivot = nums.count/2
        let leftArr = nums[0..<pivot]
        let rightArr = nums[pivot..<nums.count]
    
        let left = sortArray(Array(leftArr))
        let right = sortArray(Array(rightArr))

        return mergeSort(left,right)
    }
  
    func mergeSort(_ lhs:[Int], _ rhs:[Int]) -> [Int] {
        var res = Array(repeating:0,count:lhs.count + rhs.count), idx = 0, l = 0, r = 0
        while l < lhs.count && r < rhs.count{
            if lhs[l] < rhs[r]{
                res[idx] = lhs[l]
                l += 1
                idx += 1
            } else {
                res[idx] = rhs[r]
                r += 1
                idx += 1
            }
        }
    
        while l < lhs.count{
            res[idx] = lhs[l]
            l += 1
            idx += 1
        }
        while r < rhs.count{
            res[idx] = rhs[r]
            r += 1
            idx += 1
        }
        return res
    }
}
```

