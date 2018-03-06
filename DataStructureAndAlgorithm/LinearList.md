# 线性表
特点：在数据元素的非空有限集中
1. 存在唯一的一个被称作“第一个”的数据元素
2. 存在唯一的一个被称作“最后一个”的数据元素
3. 除第一个外，集合中的每个数据元素均只有一个前驱
4. 除最后一个外，集合中每个元素均只有一个后继

### 算法2.1
利用两个线性表LA于LB分别表示两个集合A和B，现在要求A集合为A、B的并集。首先将线性表LA扩大，将存在于线性表LB中而不存在于LA中的数据元素插入到LA中去。只要从线性表LB中依次取得每个元素，并依值在线性表LA中进行查访，若不存在，则插入。
```c
void union(List &La, List &Lb) {
    // 将所有在线性表Lb中但不在La中的数据元素输入到La中
    La.len = ListLength(La); Lb.len = ListLength(Lb); // 求线性表的长度
    for (i = 1; i <= Lb.len; i++) {
        GetElem(Lb, i, e); // 取Lb中第i个数据元素到La中
        if (! LocateElem(La, e, equal)) ListInsert(La, ++La.len, e);
        // La 中不存在和e相同的数据元素，则插入
    }
} // union

// 时间复杂度O(ListLength(LA) x ListLength(LB))

```
### 算法2.2 
已知线性表LA和LB中的数据元素按值非递减有序排列，要求将LA和LB归并为一个新的线性表LC，切LC中的数据元素仍按值非递减有序排列。
```c
void MergeList(List La, List Lb, List &Lc) {
    InitList(Lc);
    i = j = 1; k = 0;
    La.len = ListLenght(La);Lb.len = ListLenght(Lb);
    while((i <= La.len) && (j <= Lb.len)) {
        GetElem(La, i, ai); GetElem(Lb, j, bj);
        if (ai <= bj) {ListInsert(Lc, ++k, ai); ++i;}
        else{ListInsert(Lc, ++k, bj); ++j;}
    }
    while(i <= La.len) {
        GetElem(La, ++i, ai); ListInsert(Lc, ++k, ai);
    }
    while(j <= Lb.len) {
        GetElem(Lb, ++j, bj); ListInsert(Lc, ++k, bj);
    }
} // MergeList

时间复杂度O(ListLength(LA) + ListLength(LB))

```
## 线性表的顺序表示和实现

线性表的这种机内表示称作线性表的顺序存储结构或顺序影响，反之，称这种存储结构的线性表为顺序表。它的特点是，为表中相邻的元素ai和ai+1赋以相邻的存储位置LOC(ai)和LOC(ai+1)。换句话说，以元素在计算机内“物理位置相邻”来表示线性表中数据元素之间的逻辑关系。每一个数据元素的存储位置都和线性表的起始位置相差一个和数据元素在线性表中的位序成正比的常数。由此，只要确定了存储线性表的起始位置，线性表中任一数据元素都可以随机存取，所以线性表的顺序存储结构是一种随机存取的存储结构。

## 算法2.7 循序表的合并

顺序表的合并，与2.2比较相似。时间复杂度为`O(La.length + Lb.length)`。

```c
void MergeList_Sq(SqList La, SqList Lb, SqList &Lc) {
    // 已知顺序线性表La和Lb的元素按值非递减排序
    // 归并La和Lb得到新的顺序线性表Lc，Lc的元素也按值非递减排列
    pa = La.elem; pb = Lb.elem;
    Lc.listsize = Lc.length = La.length + Lb.length;
    pc = Lc.elem = (ElemType *)malloc(Lc.listsize * sizeof(ElemType));
    if (! Lc.elem)exit(OVERFLOW);  // 存储分配失败
    pa_last = La.elem + La.length - 1;
    pb_last = Lb.elem + Lb.length - 1;
    while(pa <= pa_last && pb <= pb_last) {
        if (*pa <= *pb) *pc++ = *pa++;
        else *pc++ = *pb++;
    }
    while(pa <= pa_last) *pc++ = *pa++;
    while(pb <= pb_last) *pc++ = *pb++;
} // MergeList_Sq

```

## 线性表的链式表示和实现

链式存储结构不要求逻辑上相邻的元素在屋里位置上也相邻，因此它没有顺序存储结构所具有的弱点，但同时也失去了顺序表可随机存取的优点。

为了表示每个数据元素ai 与其直接后继数据元素ai+1之间的逻辑关系，对数据元素ai来说，出了存储其本身的信息之外，还需存储一个指示其直接后继的信息。这两部分信息组成数据元素ai的存储映像，称为**结点（Node）**。它包括两个域：其中存储数据元素信息的域称为**数据域**；存储直接后继存储位置的域称为**指针域**。

这种数据结构又被称为**线性链表**或**单链表**

### 单链表的插入与删除

```c
Status ListInert_L(LinkList &L, int i, ElemType e) {}
    // 在带头结点的单链线性表L中第i个位置之前插入元素e
    p = L; j = 0;
    while(p && j < i-1) {p = p->next; ++j}      // 寻找第i-1个结点
    if(!p || j > i-1) return ERROR;             // i 小于1或者大于表长
    s = (LinkList)malloc(sizeof(LNode));        // 生成新节点
    s->data = e; s->next = p->next;
    p->next = s;
    return OK;
}

Status LinstDelete_L(LinkList &L, int i, ElemType &e) {
    // 在带头结点的单链线性表L中， 删除第i个元素，并由e返回其值
    p = L; j = 0;
    while(p->next && j < i-1){              // 寻找第i个结点，并令p指向其前趋
        p = p->next; j++;
    }
    if (!(p->next) || j > i-1) return ERROR // 删除位置不合理
    q = p->next; p->next = q->next;         // 删除并释放结点
    e = q->data; free(q);
    return OK;
}
```
以上算法时间复杂度均为`O(n)`。

### 算法2.12 单链表合并

```c
void MergeList_L(LinkList &La, LinkList &Lb, LinkList &Lc) {
    // 已知单链线性表La和Lb元素按值非递减排列
    // 归并La和Lb得到新的单链线性表Lc，Lc的元素也按值非递减排列。
    pa = La->next; pb = Lb->next;
    Lc = pc = La;
    while (pa && pb) {
        if (pc->data <= pb->data) {
            pc->next = pa; pc = pa; pa = pa->next;
        }
        else {pc->next = pb; pc = pb; pb = pb->next;}
    }
    pc->next = pa?pa:pb;
    free(Lb);
}

```
### 静态连标中的定位

有时，也可以借用一维数组来描述线性链表：

```c
#define MAXSIZE 1000 // length

typedef struct {
    ElemType data;
    int cur;
} component, SLinkList[MAXSIZE];

```
这种描述方法便于不设“指针”类型的高级程序设计语言中使用的链表结构。在静态链表中，若设i=S[0].cur, 则S[i].data存储线性表的第一个数据元素，且S[i].cur指示第二个结点在数组中的位置。一般情况，若第i个分量表示链表的第k个结点，则S[i].cur指示第k+1个结点的位置。因此在静态链表中实现线性表的操作和动态链表相似，以整形游标i代替动态指针p，i=S[i].cur的操作为指针后移（p = p->next)。如在静态链表中实现定位函数：
```c
int LocateElem_SL(SLinkList S, ElemType e) {
    // 在静态单链线性表L中查找第1个值为e的元素。
    // 若找到，则返回它在L中的位序， 否则返回0.
    i = S[0].cur;
    while(i && S[i].data != e) i = S[i].cur;
    return i;
}

```

假设由终端输入集合元素，先建立表示集合A的静态链表S，而后再输入集合B的元素的同时查找S表，若存在和B相同的元素，则从表S中删除之，否则将此元素输入S表。
将此操作分为3个步骤：
1. 将整个数组空间初始化成一个链表；
2. 从备用空间取得一个结点；
3. 将空闲结点链结到备用链表上。

```c
void InitSpace_SL(SLinkList &space) {
    // 将一维数组space中各分量链成一个备用链表，space[0].cur为头指针
    // “0”表示空指针
    for(i = 0; i < MAXSIZE - 1; i++) space[i].cur = i + 1;
    space[MAXSIZE - 1].cur = 0;
}

int Malloc_SL(SLinkList &space) {
    // 若备用空间链表非空，则返回分配的结点下标，否则返回0
    i = space[0].cur;
    if (space[0].cur) space[0].cur = space[i].cur;
    return i;
}

void Free_SL(SLinkList &sapce, int k) {
    // 将下标为k的空闲结点回收到备用链表
    space[k].cur = space[0].cur; space[0].cur = k;
}

void difference(SLinkList &space, int &S) {
    InitSapce_SL(space);            // 初始化备用空间
    S = Malloc_SL(space);           // 生成S头结点
    r = S;                          // r指向S的当前最后结点
    scanf(m，n);                    // 输入A和B的元素个数
    for(j = 1; j <= m; j++) {       // 建立集合A
        i = Malloc_SL(space);       // 分配结点
        scanf(space[i].data);       // 输入A的元素值
        spcae[r].cur = i; r = i;    // 插入到尾表
    }
    space[r].cur = 0;               // 尾结点的指针为空
    for(j = 1; j <= n; ++j) {       // 依次输入B的元素，若不存在当前表中，则插入，否则删除
        scanf(b); p = S; k = space[S].cur;                  // k指向集合A中的第一个结点
        while(k != space[r].cur && space[k].data != b) {    // 在当前表中查找
            p = k;  = space[k].cur;
        }
    }
    if (k == space[r].cur) {        // 当前表中不存在该元素，插入在r所指结点之后，切r的位置不变
        i = Malloc_SL(space);
        space[i].data = b;
        space[i].cur = space[r].cur;
        space[r].cur = i;
    } else {                            // 该元素已在表中，删除之
        space[p].cur = space[k].cur;
        Free_SL(space, k);
        if (r ==k) r = p;               // 若删除的是尾元素，则需修改尾指针
    }
}

```
### 循环链表
**循环链表（Circular Linked List）**是另一种形式的链式存储结构。它的特点是表中最后一个结点的指针或指向头结点，整个链表形成一个环。
### 双向链表
在双向链表的结点中有两个指针域，其一指向直接后继，另一个指向前趋，C语言描述如下:
```c

typedef struct DuLNode {
    ElemType    data;
    struct DuLNode  *prior;
    struct DuLnode  *next;
}DuLNode, *DuLinkList;
```

双向链表中的插入与删除：

```c
Status ListInert_DuL(DuLinkList &L, int i, ElemType e) {
    // 在带头结点的双链循环线性表L中的第i个位置之前插入元素e，
    // i的合法值为 1 <= i <= 表长 + 1.
    if (!(p - GetElemP_DuL(L, i)))          // 在L中确定第i个元素的位置指针p
        return ERROR;
    if (!(s = (DuLinkList)malloc(sizeof(DuLNode)))) return ERROR;
    s->data = e;
    s->prior = p->prior; p->prior->next = s;
    s->next = p; p->prior = s;
    return OK;
}

Status ListDelete_DuL(DuLinkList &L, int i, ElemType &e) {
    if (!(p - GetElemP_DuL(L, i))) 
        return ERROR
    e = p->data;
    p->prior->next = p->next;
    p->next->prior = p->prior;
    free(p);
    return OK;
}

```




