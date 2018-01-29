# Description

Give a string s, count the number of non-empty (contiguous) substrings that have the same number of 0's and 1's, and all the 0's and all the 1's in these substrings are grouped consecutively.

Substrings that occur multiple times are counted the number of times they occur.

#### Ex1:

```
Input: "00110011"
Output: 6
Explanation: There are 6 substrings that have equal number of consecutive 1's and 0's: "0011", "01", "1100", "10", "0011", and "01".

Notice that some of these substrings repeat and are counted the number of times they occur.

Also, "00110011" is not a valid substring because all the 0's (and 1's) are not grouped together.

```

#### Ex2:

```
Input: "10101"
Output: 4
Explanation: There are 4 substrings: "10", "01", "10", "01" that have equal number of consecutive 1's and 0's.

```

#### Note:

* `s.length` will be between 1 and 50,000.
* `s` will only consist of "0" or "1" characters.

# Approach #1: Group By Character 

### 直觉

可以将字符串`s`转变为装有连续相同字符的长度的数组`groups`，如果`s="11000111100000"`，`groups=[2,3,4,6]`.

对于形式为`0 * k + 1 * k`或者`1 * k + 0 * k`的每一个二进制串，该串中间必须出现在两个分组之间。

尝试计算`grourps[i]`与`grourps[i+1]`。如果有`groups[i] = 2, groups[i+1] = 3`,这表示`00111`与`11000`。现在求出`min(groups[i],groups[i+1])`有效的二进制字符串。因为这个字符串左边或右边的二进制数字必须在边界处改变，所以我们的答案永远不会变得更大。

### 算法

先创建一个上面提到的数组，`s`的第一个元素属于它自己的组。然后每个元素与前一个元素不相同，所以它创建一个新的大小为1的数组；或者它们相同，所以最近的组的大小加1.

之后使用`min(groups[i - 1],groups[i])`的总和。

# Code

```c++

    int countBinarySubstrings(string s) {
        vector<int> groups;
        groups.push_back(1);
        int idx = 0;
        for (int i = 1; i < s.length(); i++) {
            if (s[i] != s[i - 1]) {
                groups.push_back(1);
                idx++;
            } else {
                groups.at(idx)++;
            }
        }
        int res = 0;
        for (int i = 1; i < groups.size();i++) {
            res += min(groups[i - 1],groups[i]);
        }
        return res;
    }

```

