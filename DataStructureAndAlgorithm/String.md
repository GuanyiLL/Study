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

## 串的表示

三种机内表示方法：
1. 定长顺序存储表示
2. 堆分配存储表示
3. 串的块链存储表示

### 定长顺序存储表示
类似于线性表的顺序结构，用一组地址连续的存储单元存储串值的字符序列。
```c
// - - - - - - 串的定长顺序存储表示 - - - - - - 
# define MAXSTRLEN 255                  // 用户可在255以内定义最大串长度
typedef unsigned char SString[MAXSTRLEN + 1];   // 0号单元存放串的长度

```
串的实际长度可在这予定义长度的范围内随意，超过予定义长度的串值则被舍去，称之为“截断”。对串长有两种表示方法：
1. 以下标为0的数组分量存放串的实际长度。
2. 在串值后面加一个不计入串长结束标记字符，如C语言中的`\0`。
第二种方式的串长为隐含值，不便于进行某些串操作。

* 串联接
假设S1、S2和T都是SString型串变量，T是有S1联结S2得到的。
```c
Status Concat(SString &T, SString S1, SString S2) {
    // 用T返回由S1和S2联接而成的新串。若未截断，则返回True，否则返回False
    if (S1[0] + S2[0] <= MAXSTRLEN) {   // 未截断
        T[1...S1[0]] = S1[1...S1[0]];
        T[S1[0]+1..S1[0]+S2[0]] = S2[1...S2[0]];
        T[0] = S1[0] + S2[0];
        uncut = TRUE;
    } else if (S1[0] < MAXSTRLEN) {     // 截断
        T[1...S1[0]] = S1[1...S1[0]];
        T[S1[0] + 1...MAXSTRLEN] = S2[1...MAXSTRLEN-S1[0]];
        T[0] = MAXSTRLEN;
        uncut = FALSE;
    } else {                        // 截断（仅取S1）
        T[0...MAXSTRLEN] = S1[0..MAXSTRLEN];
        uncut = FALSE;
    }
    return uncut;
}
```

 求子串

```c
Status SubString(SString &Sub, SString S, int pos ,int len) {
    if (pos < 1 || pos > S[0] || len < 0 || len > S[0] - pos +1) 
        return ERROR; 
    Sub[1...len] = S[pos...pos + len -1];
    Sub[0] = len;
    return OK;
}

```
### 堆分配存储表示

存储特点：依旧以一组地址连续的存储单元存放串值字符序列。但他们的存储空间是在程序执行过程中动态分配而得的。C语言中，存在名为堆的存储区，由C语言的`malloc()`和`free()`管理。
```c
// ------- 串的堆分配存储表示------
typedef struct {
    char *ch;       // 若是非空串，则按串长分配存储区，否则ch为NULL
    int length;     // 串长度 
}HString;

```
这种存储结构表示时的串操作仍是基于“字符序列的肤质”进行的。
```c
Status StrInsert(HString &S, int pos, HString T) {
    // 1<p=pos<=StrLength(S) + 1.在串S的第pos个字符之前插入串T
    if (pos < 1 || pos > S.length + 1) return ERROR;   // pos不合法
    if (T.length) {
        if (! (S.ch = (char *)realloc(S.ch, (S.length + T.length) * sizeof(char))));
            exit(OVERFLOW);
        for (i = S.length - 1; i >= pos - 1; --i) // 为插入T而腾出位置
            S.ch[i + T.length] = S.ch[i];
        S.ch[pos -1...pos+T.lenght - 2] = T.ch[0...T.length-1]; // 插入T
        S.length += T.length;
    }
    return OK;
}// StrInsert

```


