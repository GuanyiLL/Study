# 串

**串(String)**，是由0个或多个字符组成的有限序列。零个字符的串为**空串**，长度为0。
串中任意个连续的字符组成的子序列称为该串子串。包含子串的串相应地称为主串。

### 算法4.1
在主串S中取第i(i的初值为pos)个字符起，长度和串T相等的子串和串T比较，若相等，则求得函数值为i，否则i值增1直至串S中不存在和串T相等的子串为止。
```c
int Index(String S, String T, int pos) {
    // T为非空字串。若主串S中第pos个字符之后存在与T相等的子串
    // 则返回第一个这样子的子串在S中的位置，否则返回0
    if (pos > 0) {

        n = StrLength(S); s = StrLength(T); i = pos;
        while(i <= n - n + 1) {
            SubString(sub, S, i, m);
            if (StrCompare(sub,T) != 0)  ++i;
            else return i;          // 返回子串在主串中的位置
        }
    }
}
```
