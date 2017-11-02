# C 指针与数组
## 指针与地址
用来保存变量地址的变量。（ANSIC使用void*来替代char*作为通用指针类型）
指针是能存放一个地址的一组存储单元
```c
p = &c;
```
把c的地址赋值给变量p，则称p为指向c的指针。&只能用于内存中的对象（变量与数组元素），不能作用于表达式、常量或者register类型的变量。
```c
int x = 1,y = 2, z[10];
int *ip;	/* ip是指向int类型的指针 */
	
ip = &x;	/* ip指向x */
y = *ip;	/* y的值为1 */
*ip = 0;	/* x的值为0 */
ip = &z[0]	/* ip指向z[0] */
```
指针只能指向某种特定类型的对象（void*除外）
```c
y = *ip + 1
```
把*ip指向的对象的值取出并加1，然后再将结果赋值给y（一元运算符*与&的优先级比算术运算符高）
```c
(*ip)++
```
以上表达式中的括号是必须的，否则该表达式将对ip进行加一运算，而不是对ip指向的对象进行加一运算（*与++这样的一元运算符遵循从右向左结合顺序）。

## 指针与函数参数
C语言是以传值的方式将参数值传递给被调用函数，因此，被调用函数不能直接修改主调函数中变量的值。
```c
void swap(int x, int y)    /* 错误定义的函数 */
{
    int temp;
    temp = x;
    x = y;
    y = temp;
}
```
则下列下列语句无法达到交换的目的。
```c
swap(a, b);
```
将指向要交换的变量的指针传给被调函数则可以实现目的:
```c
swap(&a, &b);
```
传递指针还需要将函数参数类型声明为指针：
```c
void swap(int *px, int *py)    /* 交换*px与*py */
{
    int temp;

    temp = *px;
    *px = *py;
    *py = temp;
}
```

## 指针与数组
```c
int a[10];
int *pa;
pa = &a[0];
``` 
pa为指向数组a的第0个元素，pa的值为数组元素a[0]的地址。
```c
x = *pa:
```
把数组元素a[0]中的内容赋值到变量x中。
pa指向数组中的特定元素，那么`pa+1`将指向下一个元素，`pa+i`将指向pa所指向数组元素之后的第i个元素，`pa-i`将指向pa所指向数组元素之前的第i个元素。因此，如果pa指向a[0]，那么`*（pa + 1）`引用的是数组元素a[1]的内容，`pa+i`是数组a[i]的地址，`*(pa+i)`的引用是数组元素a[i]的内容。
```c
pa = &a[0];
pa = a;
```
因为数组名所代表的就是该数组最开始的第一个元素地址，因此以上两种写法意义相同。
利用数组实现strlen：
```c
int strlen(char *s){
    int n;
    for (n = 0; *s != '\0'; s++) {
        n++;
    }
    return n;
}
```
因为s是指针，因此++运算不会影响`strlen`函数的调用者中的字符串，它仅对该指针在`strlen`函数中的似有副本进行自增运算。
以下代码都可以正确执行：
```c
strlen("hello, world"); /* 字符串常量 */
strlen(array);		/* 字符数组array有100个元素 */
strlen(ptr);		/* ptr是一个指向char类型对象的指针 */
```
在函数定义中
```c
char s[];
char *s;
```
两种表达式是等价的。

## 地址算术运算符
C语言中的地址运算方法是一致切有规律的，它将指针、数组和地址的算术运算集成在一起。
指针的初始化只能是0或者是表示地址的表达式，对于后者来说，表达式所代表的地址必须是在此前已定义的具有适当类型的数据的地址，比如：
```c
static char *allocp = allocbuf;
```
将`allocp`定义为字符类型指针，并将它初始化为`allocbuf`的起始地址，该起始地址是程序执行的下一个空闲位置。也可写成以下形式：
```c
static char *allocp = &allocbuf[0];
```
指针可以进行比较运算，指向相同数组的两个指针p和q，且q>p,那么q-p+1则表示q与p之间的元素个数。可以将strlen改写：
```c
int strlen(char *s) {
    char *p = s;
    while (*p != '\0') 
        p++;
    return p - s;
}
```
有效的指针运算包括相同类型指针之间的赋值运算；
指针同整数之间的加法或减法运算；
指向相同数组中元素的两个指针间的减法或比较运算；
将指针赋值为0或指针与0之间的比较运算。
其他所有形式的指针运算都是非法的。

## 字符指针与函数
字符串常量是一个字符数组，如：
```c
"I am a string"
```
字符数组以空字符`'\0'`结尾，字符串常量占据的存储单元数也因此比双引号内的字符数大1.
```c
char *pmessage;
pmessage = "now is the time";
```
把一个指向该字符数组的指针赋值给`pmessage`。该过程没有进行字符串的复制，只是涉及到指针的操作。C语言中没有提供将整个字符串作为一个整体进行处理的运算符。
```c
char amessage[] = "now is the time";    /* 定义一个数组 */
char *pmessage = "now is the time";     /* 定义个指针 */
```
上述声明中，`amessage`是一个仅仅足以存放初始化字符串及空字符`'\0'`的一维数组。数组中的单个字符可以进行修改，但`amessage`始终指向同一个存储位置。而`pmessage`是一个指针，其初值指向一个字符串常量，之后可以被修改以指向其他地址。
使用数组实现的`strcpy`函数：
```c
void strcpy(char *s, char *t) {
    int i;
    i = 0;
    while((s[i] = t[i]) != '\0')
        i++;
}
```
使用指针实现的`strcpy`函数：
```c
void strcpy(char *s, char *t){
    while((*s = *t) != '\0') {
        s++;
        t++;
    }
}
```
比较牛X的`strcpy`函数：
```c
void strcpy(char *s, char *t) {
    while((*s++ = *t++) != '\0') 
        ;
}
```
最牛X的`strcpy`函数：
```c
void strcpy(char *s, char *t) {
    while(*s++ = *t++)
        ;
}
```

## 指针数组以及指向指针的指针
指针也是变量，因此可以存放在数组内，
```c
int main ()
{
   char *names[] = {
                   "Zara Ali",
                   "Hina Ali",
                   "Nuha Ali",
                   "Sara Ali",
   };
   int i = 0;
 
   for ( i = 0; i < MAX; i++)
   {
      printf("Value of names[%d] = %s\n", i, names[i] );
   }
   return 0;
}
```

指向指针的指针是一种多级间接寻址的形式，或者说是一个指针链。通常，一个指针包含一个变量的地址。当我们定义一个指向指针的指针时，第一个指针包含了第二个指针的地址，第二个指针指向包含实际值的位置。
```c
int  var;
int  *ptr;
int  **pptr;

var = 3000;

/* 获取 var 的地址 */
ptr = &var;
/* 使用运算符 & 获取 ptr 的地址 */
pptr = &ptr;

/* 使用 pptr 获取值 */
printf("Value of var = %d\n", var );
printf("Value available at *ptr = %d\n", *ptr );
printf("Value available at **pptr = %d\n", **pptr);

/* 输出结果 */
Value of var = 3000
Value available at *ptr = 3000
Value available at **pptr = 3000
```

## 多维数组
C 语言支持多维数组。多维数组声明的一般形式如下：
```c
type name[size1][size2]...[sizen];
```
初始化一个二维数组：
```c
int a[3][4] = {
    {0, 1, 2, 3},
    {4, 5, 6, 7},
    {8, 9, 10, 11}
};
```
也可以不使用内嵌括号：
```c
int a[3][4] = {0,1,2,3,4,5,6,7,8,9,10,11};
```
## 指针与多维数组
如下两种定义：
```c
int a[10][20];
int *b[10];
```
从语法上看a[3][4]与b[3][4]都是对一个int对象的合法引用。但是a是一个真正的二维数组，编译器会分配200个int类型长度的存储空间，并且可以通过下标公式20*row+col计算得到a[row][col]的位置。b仅仅分配了10个指针，且没有初始化，它们的初始化必须显式进行。如果b的每个元素都指向一个具有20个元素的数组，那么编译器会分配200个int类型长度的存储空间以及10个指针的存储空间。指针数组的优点在于每个元素不必都指向一个具有20个元素的向量。
指针数组比较频繁的用处则是存放不同长度的字符串。
```c
char *name[] = {"Illegal month","Jan","Feb","Mar"};

char aname[][15] = {"Illegal month", "Jan", "Jan", "Feb", "Mar"};
```
## 命令行参数
C语言中，在程序开始执行时将命令行参数传递给程序，调用主函数main时，它带有两个参数。第一个参数（argc，用于参数计数）的值表示运行程序时命令行中参数的数目，第二个参数（argv，用于参数向量）是一个指向字符串数组的指针，每个字符串对应一个参数。比如echo命令：
```c
echo hello, world
```
会在屏幕中打印出`hello， world`

按照C语言约定，argv[0]的值是该程序的程序名，因此argc至少为1。上面例子中argc值为3,另外ANSI标准要求argv[argc]的值必须为一个空指针，argv的参数分别为：
argv[0]         echo\0
argv[1]         hello,\0
argv[2]         world\0
argv[3]         0

echo的第一个版本将argv看成一个字符指针数组：
```c
#include <stdio.h>

int main (int argc, char *argv[]) {
    int i;
    for (i = 1; 1 < argc; i++>)
        printf("%s%s",argv[i], (i < argc-1) ? " " : "");
    return 0;
}
```
第二个版本是在对argv进行自增运算、对argc进行自减运算的技术上实现的，argv是一个指向char类型的指针的指针：
```c
#include <stdio.h>
int main(int argc, char *argv[]) {
    while (--argc > 0) 
        printf((arvc > 1) ? "%s" : "%s", *++argv);
    printf("\n");
    return 0;
}
```

## 指向函数的指针



