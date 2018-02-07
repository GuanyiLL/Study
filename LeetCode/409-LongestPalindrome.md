# Description

Given a string which consists of lowercase or uppercase letters, find the length of the longest palindromes that can be built with those letters.

This is case sensitive, for example `"Aa"` is not considered a palindrome here.

#### Note:

Assume the length of given string will not exceed 1,010.

#### Ex

```
Input:
"abccccdd"

Output:
7

Explanation:
One longest palindrome that can be built is "dccaccd", whose length is 7.

```

# Code

```cpp

    int longestPalindrome(string s) {
        int res = 0;
        unordered_map<char, int> m;
        for (char c : s) m[c]++;
        for (auto it = m.begin(); it != m.end(); ++it) {
            res += it->second / 2 * 2;
            if (res % 2 == 0 && it->second % 2 == 1) {
                res++;
            }
        }
        return res;
    }

```
