# Description

Given an array of integers where 1 ≤ a[i] ≤ n (n = size of array), some elements appear twice and others appear once.

Find all the elements of [1, n] inclusive that do not appear in this array.

Could you do it without extra space and in O(n) runtime? You may assume the returned list does not count as extra space.

#### Ex1:

```
Input:
[4,3,2,7,8,2,3,1]
Output:
[5,6]

```

## 思路

数组中的元素为1-n的实数，那么也就是说数组中的元素可以当做数组下标使用，将出现过的数字对应数组中的元素改为负数，最终的数组中只有缺少的数字位置-1的元素是正数，然后将正数的元素下标加上1，则为缺失的数字。
```
[4,3,2,7,8,2,3,1]

转变后

[-4,-3,-2,-7,8,2,-3,-1]

```

# Code

```c++

class Solution {
public:
    vector<int> findDisappearedNumbers(vector<int>& nums) {
        for (int i = 0;i < nums.size(); i++) {
            int m = abs(nums[i]) - 1;
            if (nums[m] > 0)
                nums[m] = -nums[m];
        }
        vector<int> res;
        for (int i = 0;i < nums.size(); i++) {
            if (nums[i] > 0) {
                res.push_back(i + 1);
            }
        }
        return res;
    }
};

```

