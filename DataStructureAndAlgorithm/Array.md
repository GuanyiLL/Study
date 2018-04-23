# 数组

数组一般不做插入或删除操作，也就是说，一旦建立了数组，则结构中的数据元素个数和元素之间的关系就不再发生变动。因此，采用顺序存储结构表示数组是自然的事了。由于存储单元是一维结构，而数组是个多维的结构，则用一组连续存储单元存放数组的数据元素就有个次序约定问题。二维数组有两种存储方式：

* 列序为主
* 行序为主

对于数组，一旦规定了它的维数和各维的长度，便可为他分配存储空间。
下面是数组的顺序存储表示和实现。

```c
// ----- 数组的顺序存储表示 ------
#include <stdarg.h>
#define MAX_ARRAY_DIM 8     // 数组最大维数

typedef struct {
    ElemType *base;         // 数组元素基址
    int     dic;            // 数组维数
    int     *bounds;        // 数组维界基址
    int     *constants;     // 数组映像函数常量基址
} Array;

Status InitArray(Array &A, int dim, ...) {
    if (dim < 1 || dim > MAX_ARRAY_DIM) return ERROR;
    A.dim = dim;
    A.bounds = (int *)malloc(dim * sizeof(int));
    if (!A.bounds) exit(OVERFLOW);
    elemtotal = 1;
    va_start(ap, dim)              //ap 是 va_list类型，是存放变长参数表信息的数组
    for (i = 0; i < dim; ++i) {
        A.bounds[i] = va_arg(ap, int);
        if (A.bounds[i] < 0) return UNDERFLOW;
        elemtotal * = A.bounds[i];
    }
    va_end(ap);
    A .base = (ElemType *)malloc(elemtotal * sizeof(ELemType));
    if (!A.base) exit (OVERFLOW);
    // 求映像函数的常数c1，并存入A.constants[i - 1], i = 1,...,dim
    A.constants = (int *)malloc(dim * sizeof(int));
    if (! A.constants) exit(OVERFLOW);
    A.constants[dim - 1] = 1; 
    for(i = dim - 2; i >= 0; --i) {
        A.constants[i] = A.bounds[i + 1] * A.constants[i + 1];
    }
    return OK;
}

Status DestroyArray(Array &A) {
    if (! A.base) return ERROR;
    free(A.base); A.base = NULL;
    if (!A.bounds) rerturn ERROR;
    free(A.bounds); A.bounds = NULL;
    if (! A.constants) return ERROR;
    free(A.constants); A.constants = NULL;
    return OK;
}

Status Locate(Array A, va_list ap, int &off) {
    off = 0;
    for (i = 0; i < A.dim; ++A) {
        ind = va_arg(ap, int);
        if (ind < 0 || ind >= A.bounds[i]) return OVERFLOW;
        off += A.constants[i] * ind;
    }
    return OK;
}

Status Value(Array A, ElemType &e, ...) {
    va_start(ap, e);
    if ((result = Locate(A, ap, off)) > 0) return result;
    e = *(A.base + off);
    return Ok;
}

Status Assign(Array &A, ElemType e, ...) {
    va_start(ap, e);
    if ((result = Locate(A, ap, off)) <= 0) return result;
    *(A.base + offf) = e;
    return Ok;
}

```

## 矩阵的压缩存储

通常，高级语言编制程序，都适用二维数组来存储矩阵元。然而，在数值分析中经常出现一些阶数很高的矩阵，同时在矩阵中有许多值相同的元素或者是零元素。有时为了节省存储空间，可以对这类矩阵进行**压缩存储**，即为多个值相同的元只分配一个存储空间，对零元不分配空间。

假若值相同的元素或者零元素在矩阵中的分布有一定规律，则称为**特殊矩阵**；反之，称为**稀疏矩阵**。

### 特殊矩阵

若n阶矩阵满足以下性质：

$$ a_{ij} = a_{ji}   (i\geq\;1,j\leq\;n) $$

则称为对称矩阵。

对于对称矩阵，可以为每一对对称元分配一个存储空间，则可将`n^2`个元压缩存储到`n(n + 1) / 2`个元空间中。不失一般性，我们可以行序为主序存储其下三角中的元。

假设以一维数组`sa[0..n(n+1) / 2]`作为n阶对称矩阵A的存储结构，则`sa[k]`和矩阵元`aij`之间存在着一一对应的关系：
![Array-01](/img/Array01.jpeg)
对于任意给定一组下标(i,j)，均可在sa中找到矩阵元aij，反之，对所有的`k = 1，2,...,n(n+1)/2`，都能确定`sa[k]`中的元在矩阵中的位置（i，j）。由此称`sa[0..n(n+1)/2]`为n阶对称矩阵A的压缩存储。

### 稀疏矩阵

概念：假设在`m x n`的矩阵中，有t个元素不为零。令`δ = t / m x n`，称`δ`为矩阵的稀疏因子。通常认为在`δ <= 0.5`时称为系数矩阵。
按照压缩存储的概念，只存储稀疏矩阵的非零元。因此除了存储非零元的值之外，还必须同事记下他所在的行和列的位置。一个三元组`（row，col，elem）`唯一确定了矩阵A的一个非零元。

```c
// ----- 稀疏矩阵的三元组顺序表存储表示 -----
# define MAXSIZE 12500      // 假设非零元个数的最大值为 125000
typedef struct {
    int  i, j;              // 非零元的下标
    ElemType   e;
}Triple;
typedef union {
    Triple data[MAXSIZE + 1]; // 非零三元组表，data[0]未用
    int    mu,nu,tu;            // 句真的行数列数和非零元个数
} TSMatrix;
```

转置运算是一种最简单的矩阵运算。对于一个`m x n`的矩阵M，它的转置矩阵T是一个`n x m`的矩阵，且T(i,j) = M(j, i), 1<=i<=n,1<=j<=m。 

```
---------------------                            -----------------------
i       j       v                                   i       j       v
---------------------                            -----------------------
1       2       12                                  1       3       -3
1       3       9                                   1       6       15
3       1       -3                                  2       1       12
3       6       14                                  2       5       18
4       3       24                                  3       1       9
5       2       18                                  3       4       24
6       1       15                                  4       6       -7
6       4       -7                                  6       3       14
----------------------                           -------------------------
      a.data                                             b.data
```

矩阵置换的步骤：

1. 将矩阵的行列值相互交换；
2. 将每个三元组中的i和j互相调换；
3. 重排三元组之间的次序。

前两条比较容易，关键是第三条，即三元组是以T的行(M的列)为主序依次排列的。
可以有两种处理方式：

1. 按照b.data中三元祖的次序依次在a.data中找到相应的三元组进行置换。为了找到M的每一列中所有的非零元素，需要对其三元组表a.data从第一行起整个扫描一遍，由于a.data是以M的行序为主序来存放每个非零元素的，由此得到的则是b.data的顺序。

```c
Status TransposeSMatrix(TSMatrix M, TSMatrix &T) {
    T.mu = M.nu; T.nu = M.mu; T.tu = M.tu;
    if (T.tu) {
        q = 1;
        for (col = 1; col <= M.nu; ++col) {
            for (p = 1;p<=M.tu;++p) {
                if (M.data[p].j == col) {
                    T.data[q].i = M.data[p].j; T.data[q].j = M.data[p].i;
                    T.data[q].e = M.data[p].e; ++q;
                }
            }
        }
    }
    return OK;
}
```

此算法主要的工作是在`p`和`col`的两重循环中完成，时间复杂度为`O(nu * tu)`。当非零元的个数`tu`和`mu*nu`同数量级时，时间复杂度为`O(mu * nu^2)`，虽然节省了存储空间，但是时间复杂度提高，因此该算法仅适用于`tu <= mu * nu`的情况。

2. a.data中三元组的次序进行置换，并将转置后的三元组置入b中恰当的位置。如果能预先确定矩阵M中每一列的第一个非零在b.data中应有的位置，那么在对a.data中的三元组依次做转置时，便可直接放到b.data中恰当的位置上去。为了确定这些位置，在转置前，应先求得M的每一列中非零元个数，进而求得每一列的第一个非零元在b.data中的位置。

在此附设num和cpot两个向量。num[col]表示矩阵M中第col列中的非零元的个数，cpot[col]指示M中第col列的第一个非零元在b.data中的恰当位置。

```c
cpot[1] = 1;

cpot[col] = cpot[col -1] + num[col -1]   2 <= col <= a.nu
```

置换算法：

```c
Status FastTransposeSMatrix(TSMatrix M, TSMatrix &T) {
    T.mu = M.nu; T.nu = M.mu; T.tu = M.tu;
    if (T.tu) {
        for (col = 1; col <= M.nu; ++col) num[col] = 0;
        for (t = 1; t<=M.tu; ++t) ++num[M.data[t].j];
        cpot = 1;

        for (col = 2;col <= M.nu; ++col) cpot[col] = cpot[col - 1] + num[col - 1];
        for (p = 1; p <= M.tu; ++p) {
            col = M.data[p].j;     q = copt[col];
            T.data[q].i = M.data[p].j; T.data[q].j = M.data[p].i;
            T.data[q].e = M.data[p].e; ++cpot[col];
        }
    }
    return OK;
}
```
