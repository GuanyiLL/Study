# Description

Given an unsorted array of integers, find the length of longest continuous increasing subsequence (subarray).

#### Ex1:

```
Input: [1,3,5,4,7]
Output: 3
Explanation: The longest continuous increasing subsequence is [1,3,5], its length is 3. 
Even though [1,3,5,7] is also an increasing subsequence, it's not a continuous one where 5 and 7 are separated by 4. 
```

#### Ex2

```
Input: [2,2,2,2,2]
Output: 1
Explanation: The longest continuous increasing subsequence is [2], its length is 1. 
```

#### Note:
Length of the array will not exceed 10,000

# Code

```cpp
    int findLengthOfLCIS(vector<int>& nums) {
        int res = 0, anchor = 0;        
        for (int i = 0; i < nums.size(); i++) {
            if (i > 0 && nums[i - 1] >= nums[i]) anchor = i;
            res = max(res, i - anchor + 1);
        }
        return res;
    }
```

