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

查找一个新单词是否已经在树中，可以从根节点开始，比较新单词与该节点中的单词。若单词小于该节点中的单词，则在左子树中继续查找，否则在右子树查找。如果搜寻方向无子树，则说明新单词不在树中，则当前的空位就是存放新单词的位置。

```c
struct tnode {
    char *word;                 /* 树的节点 */
    int count;                  /* 指向单词的指针 */
    struct tnode *left;         /* 左子节点 */
    struct tnode *right;        /* 右子节点 */
}
```
以上为树结构体。

```c
#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAXWORD 100
struct tnode *addtree(struct tnode*, char*);
void treeprint(struct tnode *);
int getword(char *,int);

main() {
    struct tnode *root;
    char word[MAXWORD];

    root = NULL;
    while(getword(word,MAXWORD) != EOF) 
        if (isalpha(word[0]))
            root = addtree(root, word);
    treenode(root);
    return 0; 
}
```
函数`addtree`是递归调用的，主函数以参数的一个单词将作为树的最顶层。在每一部中，新单词与节点中存储的单词进行比较，随后，通过递归调用`addtree`而转向左子树或右子树。该单词最终将与树中的某个节点匹配，或遇到一个空指针。若生成新节点，则返回一个指向新节点的指针。
```c
struct tnode *talloc(void);
char *strdup(char *);

struct tnode *address(struct tnode *p, char *w) {
    int cond;

    if (p == NULL) {
        p = talloc();
        p -> word = strdup(w);
        p -> countt = 1;
        p -> left = p -> right = NULL;
    } else if ((cond = strcmp(w, p -> word)) == 0) {
        p -> count++;
    } else if (cond < 0) {
        p -> left = addtree(p -> left, w);
    } else {
        p -> right = addtree(p -> right, w);
    }

    return p;
}
```
新节点的存储空间由`talloc`获得。`talloc`函数返回一个指针，指针能容纳一个树节点的空闲空间。函数`strdup`将新单词复制到某个隐藏位置。计数值将被初始化，两个子树被置空。增加新节点时，这部分代码只在树叶部分执行。该程序忽略了对`strdup`和`talloc`返回值的出错检查。
`treeprint`函数按顺序打印树。在每个节点，它先打印左子树，然后是该单词本身，最后是右子树。
```c
void treeprint(struct tnode *p) {
    if (p != NULL) {
        treeprint(p -> left);
        printf("%4d %s \n", p->count, p->word);
        treeprint(p->right);
    }
}
```
talloc函数如下：
```c
/* talloc函数：创建一个tnode */
truct tnode *talloc(void) {
    return (struct tnode *)malloc(sizeof(struct tnode));
}
```
`strdup`函数只是把通过其参数传入的字符串复制到某个安全的位置。它是通过调用`malloc`函数实现的：
```c
char *strdup(char *s) {         /* 复制s到某个位置 */
    char *p;
    p = (char *)malloc(strlen(s) + 1);
    if (p != NULL) 
        strcpy(p, s);
    return p;
}
```

## 表查找



