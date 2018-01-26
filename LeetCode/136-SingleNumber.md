# Description

Given an array of integers, every element appears twice except for one. Find that single one.

#### Note:
Your algorithm should have a linear runtime complexity. Could you implement it without using extra memory?

#### 思路

 输入[2,1,4,5,2,4,1]
```
 res = 0 ^ 2 ^ 1 ^ 4 ^ 5 ^ 2 ^ 4 ^ 1

     = 0 ^ 2 ^ 2 ^ 1 ^ 1 ^ 4 ^ 4 ^ 5

     = 0 ^ 0 ^ 0 ^ 0 ^ 5

     = 0 ^ 5

     = 5
```

# Code

```c++

class Solution {
public:
    int singleNumber(vector<int>& nums) {
        int res = 0;
        for (int i = 0; i < nums.size(); i++)
            res ^= nums[i];
        return res;
    }
};

```

