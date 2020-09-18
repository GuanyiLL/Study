# Description

Given a string, you need to reverse the order of characters in each word within a sentence while still preserving whitespace and initial word order.

#### Ex

>Input: "Let's take LeetCode contest"
>Output: "s'teL ekat edoCteeL tsetnoc"

*Note:*  In the string, each word is separated by single space and there will not be any extra space in the string.


# Code

```c++

    string reverseWords(string s) {
        int length = 0;
        for (int idx = 0; idx < s.size(); idx++) {
            char c = s[idx];
            length++;
            if (c == ' ' || idx == s.size() - 1) {
                reverse(s.begin() + idx - length + 1, s.begin() + idx + (idx == s.size() - 1 ? 1 : 0));
                length = 0;
            }
        }
        return s;
    }

```
