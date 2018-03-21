# 数组

数组一般不做插入或删除操作，也就是说，一旦建立了数组，则结构中的数据元素个数和元素之间的关系就不再发生变动。因此，采用顺序存储结构表示数组是自然的事了。由于存储单元是一维结构，而数组是个多维的结构，则用一组连续存储单元存放数组的数据元素就有个次序约定问题。二维数组有两种存储方式：
* 列序为主 
* 行序为主
对于数组，一旦规定了它的维数和各维的长度，便可为他分配存储空间。
下面是数组的顺序存储表示和实现。
```c
// ----- 数组的顺序存储表示 ------
#include <stdarg.h>     
#define MAX_ARRAY_DIM 8   // 数组最大维数
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