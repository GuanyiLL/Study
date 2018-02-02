# Description

Given two strings s and t which consist of only lowercase letters.

String t is generated by random shuffling string s and then add one more letter at a random position.

Find the letter that was added in t.

#### Ex1:

```
Input:
s = "abcd"
t = "abcde"

Output:
e

Explanation:
'e' is the letter that was added.
```

## 思路

与在数组中找出出现1次的数字同理，每一项进行异或。
```
0 ^ a ^ a ^ b ^ b ^ c 
= 0 ^ 0 ^ 0 ^ c
= 0 ^ c
= c
```

# Code

```c++
class Solution {
public:
    char findTheDifference(string s, string t) {
        char res = 0;
        for (char c : s) res ^= c;
        for (char c : t) res ^= c;
        return res;
    }
};
```