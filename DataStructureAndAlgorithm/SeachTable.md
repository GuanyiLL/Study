# 查找

**查找表(Search Table)** 是由同一类型的数据元素构成的集合。由于"集合"中的数据元素之间存在着完全松散的关系，因此查找表示一种非常灵便的数据结构。

查找表常用操作：

1. 查询某个“特定的”数据元素是否在查找表中
2. 检索某个“特定的”数据元素各种属性
3. 在查找表中插入一个数据元素
4. 从查找表中删去某个元素。

若对查找表只做前两种统称为“查找”的操作，则称此类查找表为**静态查找表(Static Search Table)**。若在查找过程中同时插入查找表中不存在的数据元素，或者从查找表中删除已存在的某个数据元素，则称此类表为**动态查找表(Dynamic Seach Table)**。

**关键字(Key)**是数据元素中某个数据项的值，用来标识一个数据元素。若此关键字可以唯一地标识一个记录，则称此关键字为**主关键字(Primary Key)**。反之，称用以识别若干记录的关键字为**次关键字(Secondary Key)**。当数据元素只有一个数据项时，其关键字即为该数据元素的值。

**查找(Searching)**根据给定的某个值，在查找表中确定一个其关键字等于给定值记录或数据元素。若表中存在这样的一个记录，则称**查找**是成功的，此时查找的结果为给出整个记录的信息，或指示该记录在查找中的位置。反之**查找不成功**，此时查找的结果可给出一个“空”记录或“空”指针。

## 静态表查找

### 顺序表的查找

以顺序表活线性链表表示静态查找表，则Search函数可用顺序查找表来实现。

```c
// - - - - - -静态查找表的顺序存储结构- - - - - 
typedef struct {
    ElemType *elem; // 数据元素存储空间基址，建表时按实际长度分配，0号单元留空
    int length; // 表长度
}SSTable;

int Search_Seq(SSTable ST, KeyType key) {
    ST.elem[0].key = key; // 监视哨
    for (i = ST.length; !EQ(ST.elem[i].key, key); --i); // 从后向前找
    return i;   // 找不到时，i为0
}
```

查找操作的性能分析：

衡量一个算法好坏的量度有三条：时间复杂度、空间复杂度、算法的其他性能。对于查找算法，通常只需要一个或几个辅助空间。又，查找算法中的基本操作是“将记录的关键字和给定值进行比较”，因此，通常以“其关键字和给定值进行过比较的记录个数的平均值”作为衡量查找算法好坏的依据。

**定义:**为确定记录在查找表中的位置，需和给定值进行比较的关键字个数的期望值称为查找算法在查找成功时的**平均查找长度(Average Search Length)**。

### 有序表的查找

**折半查找(Binary Search)** 的查找过程是:先确定待查记录所在的范围，然后逐步缩小范围直到找到或找不到该记录为止。

```c
int Search_Bin(SSTable ST,KeyType key) {
    low = 1; high = ST.length;
    while(low <= high) {
        mid = (low + high) / 2;
        if EQ(key, ST.elem[mid].key) return mid;
        else if LT(key,ST.elem[mid].key) high = mid - 1;
        else low = mid + 1;
    }
    return 0;
}
```

折半查找性能分析：

如下11个数据元素的有序表`(05,13,19,21,37,56,64,75,80,88,92)`，找到第6个元素仅需比较1次，找到第3和第9个元素需比较2次，找到1、4、7和10个元素需比较3次，找到2、5、8和11个元素需比较4次。

查找过程如图：

![SearchTable01](/img/SearchTable01.jpg)

整个查找过程可以用此图描述。树种每一个节点表示表中一个记录，节点中的值为该记录在表中的位置，通常称这个描述查找过程的二叉树为判定树。找到有序表中任一记录的过程就是走了一条从根结点到与该记录相应的节点的路径，和给定值进行比较的关键字的个数恰为该结点在判定树上的层次数。因此，折半查找法在查找成功时进行比较的关键字的个数最多不超过树的深度，具有n个结点的判定树的深度为`logn+1`。

假定有序表的长度`n=2^h - 1`，则描述折半查找的判定树的深度为h的满二叉树。树中层次为1的结点有1个，层次为2的结点有2个，...，层次为h的结点有`2^(h-1)`个。假设表中每个记录的查找概率相等(P = 1/n)，则平局查找长度为：

![SearchTable02](/img/SearchTable02.jpg)

可见，折半查找的效率比顺序查找高，但折半查找只用于有序表，且限于顺序存储结构。

### 静态树查找

之前对有序表的查找性能的讨论是在“等概率”的前提下进行的。如果各记录的查找概率不等，按照之前的算法性能未必是最优的。如果只考虑查找成功的情况，则是查找性能达到最佳的判定树是其带权内路径长度PH值

![SearchTable03](/img/SearchTable03.png)

取最小值得二叉树。其中：n为二叉树上的结点个数；hi为第i个结点在二叉树上的层次数；节点的权wi=cpi(i=1,2,...,n)，其中pi为结点的查找概率，c为常量。称PH值取最小的二叉树为**静态最优查找树(Static Optimal Search Tree)**。

构造次优查找树的递归算法：

```c
Status SecondOptimal(BitTree &T, ElemType R[],float sw[],int low, int high) {
    i = low;min = abs(sw[high] - sw[low]); dw = sw[high] + sw[low - 1];
    for (j = low; j <= high; ++j) {
        if (abs(dw - sw[j] - sw[j - 1]) < min) {
            i = j; min = abs(dw - sw[j] - sw[j - 1]);
        }
    }
    if (!(T = (BiTree)malloc(sizeof(BiTNode)))) return ERROR;
    T->data = R[i];
    if (i == low) T->lchild = NULL;
    else SecondOptimal(T->lchild, R, sw, low, i-1);
    if (i == high) T->rchild = NULL;
    else SecondOptmal(T->rchild, R, sw, i+1, high);
    return OK;
}
```