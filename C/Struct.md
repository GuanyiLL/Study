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

