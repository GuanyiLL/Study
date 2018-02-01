# Description

Given a positive integer, return its corresponding column title as appear in an Excel sheet.

#### Ex1:

```

    1 -> A
    2 -> B
    3 -> C
    ...
    26 -> Z
    27 -> AA
    28 -> AB 

```

# Code

```c++

    string convertToTitle(int n) {
        string result;
        if (n <= 0) return result;

        while (n) {
            char c = (--n)%26 + 'A';
            result = c + result;
            n /= 26;
        }
        return result;
    }

```
