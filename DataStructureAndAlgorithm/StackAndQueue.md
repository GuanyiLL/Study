# 栈和队列

## 栈

**栈(Stack)**是限定仅在表尾进行插入或删除操作的线性表。栈尾端称为**栈顶**，头端称为**栈低**。不含元素的空表称为空栈。栈又称为后进先出(Last In First Out)的线性表(简称LIFO结构)。
```c
// ---------基本嫂做描述（部分）----------
Status InitStack(SqStack &S) {
    // 构造一空个空栈个空栈 S
    S.base = (SElemType *)malloc(STACK_INIT_SIZE * sizeos(ElemType));
    if (! S.base) exit(OVERFLOW);
    S.stacksize = STACK_INIT_SIZE;
    return OK;
}

Status GetTop(SqStack S, SElemType &e) {
    // 若栈不空，则用e返回S的栈顶元素，并返回Ok；否则返回ERROR
    if (S.top == S.base) return ERROR;
        e = *(S.top -1);
        return OK;
}

Status Push(SqStack &S,SElemType e) {
    // 插入元素e为新的栈顶元素
    if (S.top - S.base >= S.stacksize) {
        S.base = (ElemType *)realloc(S.base, S.stacksize + STACKINCREMENT) * sizeof(ElemType));
        if (!S.base) exit(OVERFLOW);
        S.top = S.base + S.stacsize;
        S.stacksize += STACKINCREMENT;
    }
    *S.top++ = e;
    return OK;
}


Status Pop(SqStack &S, SElemType &e) {
    if (S.top == S.base) return ERROR;
    e= * --S.top;
    return OK;
}
```

##栈的应用

### 算法3.1 数制转换

对于输入任意的非负十进制整数，打印输出与其等值的八进制数。
```c
void conversion() {
    InitStack(S);
    scanf("%d",N);
    while(N) {
        Push(S, N % 8);
        N = N / 8;
    }
    while(! StackEmpty) {
        Pop(S,e);
        printf("%d",e);
    }
}

```

### 算法3.2 行编辑程序

一个行编辑程序的功能：接受用户从终端输入的程序或数据，并存入用户的数据区。用`#`以表示前一个字符无效；以`@`表示当前行中字符均无效：
```

用户输入如下：
whli##ilr#e(s# *s)
    outcha@putchar(*s=#++);
实际输入：
while(*s)
  putchar(*s++);

```
则可以使用如下算法：
```c
void LineEdit() {
    InitStack(S);
    ch = getchar();
    while(!EOF) {
        while(!EOR && ch != '\n') {
            switch(ch) {
                case '#': Pop(S,c);      break;
                case '@': ClearStack(S); break;
                default: Push(S,ch);     break;
            }
            ch = getchar();
        }
        ClearStack(S);
        if (ch != EOF) ch = getChar();
    }
    DestroyStack(S);
}

```

### 算法3.3 迷宫




