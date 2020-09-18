# Description

Given a string, find the length of the longest substring without repeating characters.

## EX1:

```
Input: "abcabcbb"
Output: 3 
Explanation: The answer is "abc", with the length of 3. 
```

## EX2:

```
Input: "bbbbb"
Output: 1
Explanation: The answer is "b", with the length of 1.
```

## EX3:

```
Input: "pwwkew"
Output: 3
Explanation: The answer is "wke", with the length of 3. 
             Note that the answer must be a substring, "pwke" is a subsequence and not a substring.
```

## Code

```cpp
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        vector<int> M(256,-1);
        int i, j, res = 0; //i sweep index, j no-repeating-substring-begin idx
        for(j = 0, i = 0; i < s.length(); ++i) {
            if(M[s[i]] >= j) {
                res = max(res, i-j);
                j = M[s[i]]+1;
            }
            M[s[i]] = i;
        }
        return max(res, i-j);
    }
};
```
