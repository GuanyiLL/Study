# Struct
## 基本知识
使用结构体存放点：
```c
struct point {
    int x;
    int y;
}
```
结构体的初始化可以在定义的后面使用初值表进行。初值表中同每个成员对应的初值必须是常量表达式，例如：
```c
struct point maxpt = { 320, 200 };
```
成员访问使用运算符'.'，使用下列语句打印点pt的坐标：
```c
printf("%d,%d", pt.x, pt.y);
```
结构体可以嵌套，使用两个点来定义矩形：
```c
struct rect {
    struct point pt1;
    struct point pt2;
}
```

## 结构体与函数
结构体的合法操作只有几种：作为一个整体复制和赋值，通过&运算符取地址，访问其成员。
```c
// makepoint函数,通过x，y坐标构造一个点
struct point makepoint(int x, int y) {
    struct point temp;

    temp.x = x;
    temp.y = y;
    return temp;
}
```

也可以将结构体当作函数参数：
```c
struct point addpoint(struct point p1, struct point p2) {
    p1.x += p2.x;
    p1.y += p2.y;
    return p1;
}
```

如果传递给函数的结构体很大，那么使用指针方式的效率通常比复制整个结构体的效率更高。声明
```c
struct point *pp;
```
pp为指向`struct point`类型对象的指针。对于pp的使用如下：
```c
struct point origin, *pp;

pp = &origin;
printf("origin is (%d,%d)\n", (*pp).x,(*pp).y);
```
而C语言提供了一种简写方式来方位结构体成员：
```c
p->结构体成员

printf("origin is (%d,%d)\n", pp->x, pp->y);

```
运算符`.`与`->`都是从左只有结合，对于以下声明：
```c
struct rect r, *rp = &r;
```
以下4个表达式等价：
```c
r.pt1.x
rp->pt1.x
(r.pt1).x
(rp->pt1).x
```
表达式
```c
++p->len
```
将增加len的值，而不是p。表达式等同于++（p->len）。

## 结构数组
声明如下：
```c
struct key {
    char *word;
    int count;
} keytab[NKEYS];
```
它声明了一个结构体类型key，并定义了该类型的结构体数组keytab，同时为其分配存储空间。数组keytab的每一个元素都是一个结构体。上述声明可以改写为以下形式：
```c
struct key {
    char *word;
    int count;
};
struct key keytab[NKEYS];
```
因为结构体keytab包含一个固定的名字集合，所以，最好将它声明为外部变量，这样只需要初始化一次。如下：
```c
struct key {
    char *word;
    int count;
} keytab[] = {
    "auto", 0,
    "break", 0,
    "case", 0,
    /* ... */
    "while", 0
};
```

## 指向结构体的指针
```c
#include <stdio.h>
#include <ctyps.h>
#include <string.h>
#define MAXWORD 100

int getword(char *, int);
struct key *binsearch(char *, struct key*, int);

main() {
    char word[MAXWORD];
    struct key *p;
    while(getword(word, MAXWORD) != EOF) 
        if (isalpha(word[0]))
            if ((p = binsearch(word, keytab, NKEYS)) != NULL) 
                p->count++;
    for (p = keytab; p < keytab + NKEYS; p++)
        if (p->count > 0)
            printf("%d %s \n", p->count, p->word);
    return 0;
}

struct key *binsearch(char *word, struct key *tab, int n) {
    int cond;
    struct key *low = &tab[0];
    struct key *high = &tab[n];
    struct key *mid;

    while(low < high) {
        mid = low + (high -low) / 2;
        if ((cond * strcmp(word, mid->word)) < 0) 
            high = mid;
        else if (cond > 0) 
            low = mid + 1;
        else 
            return mid;
    }
    return NULL;
}

```

## 自引用结构

假定一个问题：统计输入中所有单词的出现次数。使用二叉树来实现。

每个不同的单词在树中都是一个节点，每个结点包括：
* 一个指向该单词内容的指针
* 一个统计出现次数的计数值
* 一个指向左子数的指针
* 一个指向右子数的指针
任何节点最多拥有两个子树，也可能只有一个子树或一个也没有。

对节点的所有操作要保证，任何节点的左子树只包含按字典序小于该节点中单词的那些单词，右子树只包含按字典序大于该节点中单词的那些单词。
"now is the time for all good men to come to the aid of their party"

![struct tree](/img/Struct01.png)


