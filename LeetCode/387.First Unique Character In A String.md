# Description

Given a string, find the first non-repeating character in it and return it's index. If it doesn't exist, return -1.

#### Ex1:

```
s = "leetcode"
return 0.

s = "loveleetcode",
return 2.

```

#### Note:

You may assume the string contain only lowercase letters.

# Code

```c++

class Solution {
public:
    int firstUniqChar(string s) {
        vector<int> v(26, 0);
        for (char c : s)
            v[c - 'a']++;
        for (int idx = 0; idx < s.length(); idx++)
            if (v[s[idx] - 'a'] == 1)
                return idx;
        return -1;
    }
};

```
