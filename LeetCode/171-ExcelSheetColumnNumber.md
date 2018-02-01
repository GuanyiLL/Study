# Description

Given a column title as appear in an Excel sheet, return its corresponding column number.

#### Ex

```

    A -> 1
    B -> 2
    C -> 3
    ...
    Z -> 26
    AA -> 27
    AB -> 28 

```

# Code

```c++

    int titleToNumber(string s) {
        int res = 0;
        for (char c:s) {
            res *= 26;
            res += c - 'A' + 1;
        }
        return res;
    }

```


