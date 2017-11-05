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




