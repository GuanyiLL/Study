# Sort

* 内部排序：待排序记录存放在计算机存储器中进行的排序过程
* 外部排序：待排序记录的数量很大，以致内存一次不能容纳全部记录，在排序过程中需对外存进行访问的排序过程

内部排序，按排序过程中依据的不同原则大致可以分为插入排序、交换排序、选择排序、归并排序和计数排序等五类；如果按内部排序过程中所需工作量来区分，则可分为三类：

1. 简单的排序方法，时间复杂度为$O(n^2)$。
2. 先进的排序方法，时间复杂度为$O(nlogn)$。
3. 基数排序，时间复杂度为$O(dn)$。

## 插入排序

### 直接插入排序

 算法如下：

 ```c
 void InsertSort(SqList &L) {
     // 对顺序表L作直接插入排序
     for(i = 2; i <= L.length; ++i) {
         if LT(L.r[i].key, L.r[i-1].key) {
             L.r[0] = L.r[i];           // 复制为哨兵
             for (j = i-1; LT(L.r[0].key, L.r[j].key); --j)
                L.r[j+1] = L.r[j];   // 记录后移
             L.r[j+1] = L.r[0];      // 插入到正确位置
         }
     }
 }
 ```

 时间复杂度为$O(n^2)$

### 其他插入排序

#### 折半插入排序

```c
void BInsertSort(SqList &L) {
    //对顺序表L作折半插入排序
    for (i = 2; i <= L.length; ++i) {
        L.r[0] = L.r[i];            // 将L.r[i]暂存到L.r[0]
        low = 1; high = i - 1;
        while(low <= high) {        // 在r[low..high]中折半查找有序插入的位置
            m = (low + high) / 2;   // 折半
            if LT(L.r[0].key, L.r[m].key) high = m - 1; // 插入点在底半区
            else low = m + 1;  // 插入点在高半区
        }
        for (j = i - 1; j >= high + 1; --j) L.r[j + 1] = L.r[j];  // 记录后移
        L.r[high + 1] = L.r[0];  // 插入
    }
}
```

折半插入所需附加存储空间和直接插入排序相同，从时间上比较，折半插入排序仅减少了关键字间的比较次数，儿记录的移动次数不变。因此时间复杂度仍然为$O(n^2)$。

### 插入表排序

存储结构如下 ：

```c
#define SIZE 100        // 静态链表容量
typedef struct {
    RcdType rc;         // 记录项
    int next;           // 指针项
}SLNode;
typedef struct {
    SLNode r[SIZE];     // 0号单元为表头结点
    int length;         // 链表当前长度
}SLinkListType;
```

算法如下：

```c
void Arrange(SLinkListType &SL) {
    /*
        根据静态链表SL中各结点的指针值调整记录位置，使得SL中记录按关键字非递减减有序顺序排列
    */
    p = SL.r[0].next;                   // p指示第一个记录的当前位置
    for (i = 1; i<SL.length; ++i) {     // SL.r[1..i-1]中记录已按关键字有序排列，第i个记录在SL中的当前位置应不小于i
        while(p < i) p = SL.r[p].next;  // 找到第i个记录，并用p指示其在SL中当前位置
        q = SL.r[p].next;    // 指示尚未调整的表尾
        if (p!=i) {
            SL.r[p]<-->SL.r[i];     // 交换记录，使第i个记录到位
            SL.r[i].next = p;       // 指向被移走的记录，使得以后可由while循环找回
        }
        p = q;  // p指示尚未调整的表尾，为找第i+1个记录作准备
    }
}

```

## 希尔排序

希尔排序又称“缩小增量排序”(Diminishing Increment Sort)，它也是一种属于插入排序类的方法，但在时间效率上有较大改进。

它的基本思想：先将整个待排记录序列分割成若干个子序列分别进行直接插入排序，待整个序列中的记录“基本有序”时，在对全体进行一次直接插入排序。

```c
void ShellInsert(SqList &L, int dk) {
    /*
        对顺序表L做一趟希尔插入排序。本算法适合一趟直接插入排序相比，做了以下修改：
            1. 前后记录位置的增量是dk，而不是1；
            2. r[0]只是暂存单元，不是哨兵。当j<=0时，插入位置已找到。
    */
    for (i = dk + 1; i <= L.length; ++i) {
        if LT(L.r[i].key, L.r[i - dk].key) {        // 将L.r[i]插入有序增量子表
            L.r[0] = L.r[i];
            for (j = i - dk; j > 0 && LT(L.r[0].key, L.r[j].key); j -= dk)
                L.r[j+dk] = L.r[j];     // 记录后移，查找插入位置
            L.r[j + dk] = L.r[0];       // 插入
        }
    }
}

void ShellSort(SqList &L, int dlta[], int) {
    // 按增量序列 dlta[0..t-1]对顺序表L作希尔排序
    for (k = 0; k < t; ++t) {
        ShellInsert(L, dlta[k]);  // 一趟增量为dlta[k]的插入排序
    }
}
```

希尔排序的分析是一个复杂的问题，因为它的时间是所取“增量”序列的函数，涉及一些数学上尚未解决的难题。有人指出，当增量序列为$dlta[k]=2^{t-k+1}$时，希尔排序的时间复杂度为$O(n^{3/2})$，t为排序趟数，$1\leq\;k\leq\;t\leq\; \lfloor log(n+1)\rfloor$。

还有人在大量实验基础上推出：当N在某个特定范围内，希尔排序所需的比较和移动次数约为$n^{1.3}$，当$n\to\infty$时，可减少到$n(logn)^{2}$。增量序列中的值没有除1之外的公因子，并且最后一个增量值必须等于1。

## 快速排序

```c
int Partition(SqList &L,int low, int high) {
    /*
        交换顺序表L中子表r[low..high]的记录，枢轴记录到位，并返回其所在位置，此时在它之前(后)的记录均不大(小)于它
    */
    L.r[0] = L.r[low]; // 用子表的第一个记录做枢轴记录
    pivotkey = L.r[low].key;        // 枢轴记录关键字
    while(low < high) {             // 从表的两端交替地向中间扫描
        while(low < high && L.r[high].key >= pivotkey) --high;              // 将比枢轴记录小的移动到低端
        while(low < high && L.r[low].key <= pivotkey) ++low;
        L.r[high] = L.r[low];       // 将比枢轴记录大的记录移到高端
    }
    L.r[low] = L.r[0];          // 枢轴记录到位
    return low;                 // 返回枢轴位置
}
```

递归形式：

```c
void QSort(SqList &L,int low, int high) {
    // 对顺序表L中的子序列L.r[low..high]作快速排序
    if (low < high) {                   // 长度大于1
        pivotloc = Partition(L, low, high)  // 将L.r[low..high] 一分为二
        QSort(L, low, pivotloc-1);      // 对低子表递归排序，pivotloc是枢轴位置
        QSort(L, pivotloc+1, high);     // 对高子表递归排序
    }
}

void QuickSort(SqList &L) {
    // 对顺序表L作快速排序
    QSort(L, 1, L.length);
}
```

快速排序的平均时间为$T_{avg}(n)=knlnn$,其中n为待排序序列中记录的个数，k为某个常数，经验证明，在所有同数量级的此类(先进的)排序方法中，快速排序的常数因子k最小。因此，就平均时间而言，快速排序是目前被认为是最好的一种内部排序方法。

## 选择排序

**选择排序(Selection Sort)**的基本思想是:每一趟在n - i + 1(i=1,..,n-1)个记录中选取关键字最小的记录作为有序序列中第i个记录。其中最简单、且为读者最熟悉的是**简单选择排序(Simple Selection Sort)**。

```c
void SelectSort(SqList &L) {
    for (i = 1; i < L.length; ++i) {
        j = SelectionMinKey(L, i);
        if (i != j) L.r[i] <--> L.r[j];
    }
}
```

### 堆排序

**堆排序(HeapSort)**只需要一个记录大小的辅助空间，每个待排序的记录仅占有一个存储空间。