# Description

We define a harmonious array is an array where the difference between its maximum value and its minimum value is exactly 1.

Now, given an integer array, you need to find the length of its longest harmonious subsequence among all its possible subsequences.

#### Ex

```

Input: [1,3,2,2,5,2,3,7]
Output: 5
Explanation: The longest harmonious subsequence is [3,2,2,2,3].

```

#### Note

The length of the input array will not exceed 20,000.

# Code

```cpp

int findLHS(vector<int>& nums) {
    int res = 0;
    map<int, int> m;
    for (int num : nums) m[num]++;
    for (auto a : m) {
        if (m.count(a.first + 1)) {
            res = max(res, m[a.first] + m[a.first + 1]);
        }
    }
    return res;
}

/*
 
 //single loop
 
int findLHS(vector<int>& nums) {
    int res = 0;
    unordered_map<int, int> m;
    for (int n : nums) {
        m[n]++;
        if (m.count(n + 1)) {
            res = max(res, m[n] + m[n + 1]);
        }
        if (m.count(n - 1)) {
            res = max(res, m[n - 1] + m[n]);
        }
    }
    return res;
}
*/

```
