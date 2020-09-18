# Description


Find the contiguous subarray within an array (containing at least one number) which has the largest sum.

For example, given the array [-2,1,-3,4,-1,2,1,-5,4],
the contiguous subarray [4,-1,2,1] has the largest sum = 6.

# Code

```cpp

    int maxSubArray(vector<int>& nums) {
        size_t n = nums.size();
        vector<int> dp(n);
        dp[0] = nums[0];
        int m = dp[0];
        for(int i = 1; i < n; i++){
            dp[i] = nums[i] + (dp[i - 1] > 0 ? dp[i - 1] : 0);
            m = max(m, dp[i]);
        }
    
        return m;
    }

```
