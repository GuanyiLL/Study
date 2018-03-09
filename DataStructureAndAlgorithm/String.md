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
基本操作算法描述：

```c
Status StrAssign(HString &T,char *chars) {
    if (T.ch) free(T.ch);
    for (i = 0,c = chars; c; ++i,++c); // 求chars的长度
    if (!i) {T.ch = NULL; T.length = 0;}
    else {
        if (!(T.ch = (char *)malloc(i * sizeof(char))))
            exit(OVERFLOW);
        T.ch[0..i-1] = chars[0..i-1];
        T.length = i;
    }
    return OK;
}

Status Concat(HString &T, HString S1,HString S2) {
    if (T.ch) free(T.ch);
    if (!(T.ch = (char *)malloc((S1.length + S2.length) * sizeof(char))))
        exit(OVERFLOW);
    T.ch[0..S1.length-1] = S1.ch[0..S2.length -1];
    T.length = S1.length + S2.length;
    T.ch[S1.length..T.length-1] = S2.ch[0..S2.length-1];
    return OK;
}

Status SubString(HString &Sub, HString S, int pos, int len) {
    if (pos < 1 || pos > S.length || len < 0 || len > S.length - pos + 1)
        return ERROR;
    if (Sub.ch) free(Sub.ch);
    if (!len) {Sub.ch = NULL; Sub.length= 0;}
    else {
        Sub.ch = (char *)malloc(len * sizeof(char));
        Sub.ch[0..len-1] = S[pos-1..pos+len-2];
        Sub.length = len;
    }
    return OK;
}

```

### 串的块链存储表示

和线性表的链式存储结构相类似，也可以采用链表方式存储串值。由于串结构的特殊性--结构中的每个数据元素是一个字符，则用链表存储串值时，存在一个“结点大小”的问题，即每个结点可以存放一个字符，也可以存放多个字符。当结点大小大于1，由于串长不一定是结点大小的整数倍，则链表中的最后一个结点不一定全被串值占满，此时通常补上“#”或其它的非串值字符。

为了便于进行串的操作，当以链表存储串值时，除头指针外还可附设一个尾指针指示链表中的最后一个结点，并给出当前串的长度。称如此定义的串存储结构为**块链结构**。
```c
//  ==== 串的块链存储表示 =======
#define CHUNKSIZE   // ke由用户定义的块大小
typedef struct Chunk {
    char ch[CUNKSIZE];
    struct Chunk *next;
}Chunk;
typedef struct {
    Chunk *head *tail;        // 串的头尾指针
    int curlen;               // 串的当前长度              
}

```
```
                串值所占的存储位
串存储密度 =  -------------------
                实际分配的存储位
```
显然，存储密度小，运算处理方便，然而，存储占用量大。如果在串处理过程中需进行内、外存交换，则会因为内外存交换操作过多而影响处理的总效率。串的字符集的大小也是一个重要因素。一般字符集小，则字符的机内编码就短，这也影响串值的存储方式的选取。

## 串的模式匹配算法

### 子串定位函数

```c
int Index(SString S, SString T, int pos) {
    i = pos; j = 1;
    while(i <= S[0]&&j<=T[0]) {
        if (S[i] = T[j]) {++i; ++j}
        else {i = i - j + 2; j = 1;}
    }
    if (j > T[0]) return i - T[0];
    else return 0;
}

```
当子串为‘00000001’主串为‘0000000000000000000000000000000000000000001’时，时间复杂度为O(mxn)。

### 模式匹配的一种改进
克努特-莫里斯-普拉特操作(简称KMP算法)。该算法时间复杂度为O(m+n)。
