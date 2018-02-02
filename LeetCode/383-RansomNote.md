# Description

Given an arbitrary ransom note string and another string containing letters from all the magazines, write a function that will return true if the ransom note can be constructed from the magazines ; otherwise, it will return false.

Each letter in the magazine string can only be used once in your ransom note.

#### Note:
You may assume that both strings contain only lowercase letters.

```
canConstruct("a", "b") -> false
canConstruct("aa", "ab") -> false
canConstruct("aa", "aab") -> true

```


## 思路

magazine中的字母出现的次数大于等于ransomNote中的即可，而并不需要顺序一样，开始理解题意错误。例如：
```
ransomNote = "aa"
magazine = "abab" 
return true

```

# Code

```c++

    bool canConstruct(string ransomNote, string magazine) {
        vector<int> arr(26,0);
        for (int idx = 0; idx < magazine.length(); idx++) {
            arr[magazine[idx] - 'a']++;
        }
        for (int idx = 0; idx < ransomNote.length(); idx++) {
            if (--arr[ransomNote[idx]-'a'] < 0) {
                return false;
            }
        }
        return true;
    }

```


