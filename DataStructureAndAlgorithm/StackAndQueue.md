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

## 队列

和栈相反，队列是一种先进先出(First In First Out,FIFO)的线性表。队列只允许在表的一端进行插入，而在另一端删除元素。允许插入的一端叫**队尾(rear)**，允许删除的一端则称为队头。除了栈和队列之外，还有一种限定性数据结构是**双端队列**。双端队列是限定插入和删除操作在表的两端进行的线性表。

### 键队列

用链表表示的队列简称**键队列**。
```c
// ===== ADT Queue 的表示与实现 =====
typedef struce QNode {
    QElemType data;
    struct QNode *next;
}QNode, *QueuePtr;
typedef struct {
    QueuePtr front;     //队头指针
    QueuePtr rear;      //队尾指针
}LinkQueue;

// -----基本操作得算法描述（部分）-------

Status InitQueue(LinkQueue &Q) {
    // 构造一个空队列Q
    Q.front = Q.rear = (QueuePtr)malloc(sizeof(QNode));
    if (! Q.front) exit(OVERFLOW);
    Q.front->next = NULL;
    return OK;
}

Status DestroyQueue(LinkQueue &Q) {
    // 销毁队列Q
    while(Q.front) {
        Q.rear = Q.front->next;
        free(Q.front);
        Q.front = Q.rear;
    }
    return OK;
}

Status EnQueue(LinkQueue &Q, QElemType e) {
    // 插入元素e为Q的新的队尾元素
    p = (QueuePtr)malloc(sizeof(QNode));
    if (!p) exit(OVERFLOW);
    p->data = e; p->next = NULL;
    Q.rear->next = NULL;
    Q.rear = p;
    return OK;
}

Status DeQueue(LinkQueue &Q, QElemType &e) {
    // 如果队列不为空，删除Q队头元素，用e返回值，并且返回OK，否则返回ERROR
    if (Q.front == Q.rear) return ERROR;
    p = Q.front -> next;
    e = p->data;
    Q.front->next = p->next;
    if (Q.rear == p) Q.rear = Q.front;
    free(p);
    return OK;
}

```
注意：当队列中最后一个元素被删除，队列尾指针也丢失了，因此需对对尾指针重新赋值。

### 循环队列

在初始化空队列时，令`front = rear = 0`，每当插入新的队列尾元素时，尾指针增加一，删除队列头元素时，头指针增1。在循环队列中，只凭`Q.front = Q.rear`无法判别队列空间是空是满。解决这个问题有两种方法：
1. 设一个标志位以区分队列是空还是满
2. 少用一个元素空间，约定以“队列头指针在队列尾指针的下一位上”作为队列呈满的状态的标志

```c
// 循环队列的头尾指针
#define MAXQSIZE 100        //最大长度
typedef struct {
    QElemType *base;        //初始化的动态分配存储空间
    int front;              //头指针，若队列不为空，指向队列头元素
    int rear;               //尾指针，若队列不为空，指向队列尾元素的下一个位置
}SqQueue;

// ---------循环队列的基本操作的算法描述------
Status InitQueue(SqQueue &Q) {
    // 构造一个空队列Q
    Q.base = (ElemType *)malloc(MAXQSiZE*sizeof(ElemType));
    if (! Q.base) exit(OVERFLOW);
    Q.front = Q.rear = 0;
    return OM;
}

int QueueLength(SqQueue Q) {
    // 返回Q的元素的个，即队列的长度
    return (Q.rear-Q.front+MAXQSIZE) % MAXQSIZE;
}

Status EnQueue(SqQueue &Q,QElemType e) {
    // 插入元素e为Q的新的队尾元素
    if ((Q.rear + 1) % MAXSIZE == Q.front) return ERROR; // 队列满
    Q.base[Q.rear] = e;
    Q.rear = (Q.rear + 1) % MAXQSIZE;
    return OK;
}

Statue Dequeue(SqQueue &Q,QElemType &e) {
    // 若队列不空，则删除Q的堆头元素，用e返回其值，并返回OK
    // 否则返回ERROR
    if (Q.front == Q.rear) return ERROR;
    e = Q.base[Q.front];
    Q.front = (Q.front + 1) % MAXQSIZE;
    return OK;
}

```

