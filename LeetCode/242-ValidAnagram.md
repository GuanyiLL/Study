# Description 
Given two strings s and t, write a function to determine if t is an anagram of s.

For example,
s = "anagram", t = "nagaram", return true.
s = "rat", t = "car", return false.

#### Note:
You may assume the string contains only lowercase alphabets.

#### Follow up:
What if the inputs contain unicode characters? How would you adapt your solution to such case?

# 分析
只要判断两个字符串中字符个数是否相等即可。

# Code 
```c++

class Solution {
public:
    bool isAnagram(string s, string t) {
        vector<int> v(26, 0);
        for (char c : s) v[c - 'a']++;
        for (char c : t) v[c - 'a']--;
        for (int e : v)
            if (e != 0)
                return false;
        return true;
    }
};

```
