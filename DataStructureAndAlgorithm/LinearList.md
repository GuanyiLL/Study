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

