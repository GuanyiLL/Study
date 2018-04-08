# 树与二叉树

树形结构是一类重要的非线性数据结构。以树和二叉树最为常用。

## 树的定义和基本术语

**树(Tree)** 是n(n >= 0)

1. 有且仅有一个特定的称为根(Root)的结点；
2. 当n > 1时，其余结点可分为m(m >  0)个互不相交的有限集T1,T2,...,Tm,其中每一个集合本身又是一棵树，并且成为根的**子树(SubTree)**。

树的结构定义是一个递归的定义，即在树的定义中又用到了树的概念。

下面列出树结构中的一些基本术语：
树的**结点**包含一个数据元素及若干指向其子树的分支。结点拥有的子数称为**结点的度**。度为零的结点称为**叶子(Leaf)**或**终端结点**。度不为零的结点称为**非终端结点**或**分支结点**。除根结点外，分支结点也称为**内部结点**。树的度是树内各结点的度的最大值。结点的子树的根称为该结点的**孩子**，相应地，该结点称为孩子的**双亲**。同一双亲的孩子间互称**兄弟(Sibling)**。

结点的**层次**从根开始定义，根为第一层，根的孩子为第二层。若某结点在第l层，则其子树的根就在第l+1层。其双亲在同一层的结点互为**堂兄弟**。树中结点的最大层次称为树的**深度**或者**高度**。

**森林**是`m(m>=0)`棵互不相交的树的集合。对树中每个结点而言，其子树的集合即为森林。就逻辑结构而言，任何一棵树是一个二元祖`Tree(root, F)`，其中`root`是数据元素，称作树的根结点；`F`是`m(m>=0)`棵树的森林，`F = (T1,T2,T3,...,Tm)`，其中`Ti = (ri, Fi)`称作根`root`的第i棵子树。

## 二叉树

**二叉树**是另一种树形结构，它的特点是每个结点至多只有两棵子树，并且，二叉树的子树有左右之分，其次序不能任意颠倒。

### 性质

1. 在二叉树的第i层上至多有2^(i-1)个结点(i >= 1)
2. 深度为k的二叉树至多有2^k-1个结点。
3. 对任何一颗二叉树T，如果其终端结点数为n0，度为2个结点数为n2，则n0 = n2 + 1。完全二叉树和满二叉树，是两种特殊形态的二叉树。一棵深度为k且有2^k-1个结点的二叉树称为满二叉树。对满二叉树的结点进行连续编号，约定编号从根结点起，自上而下，自左至右。深度为k的，有n个结点的二叉树，当切仅当其每一个结点都与深度为k的满二叉树中编号从1至n的结点一一对应时，称之为完全二叉树。
4. 具有n个结点的完全二叉树的深度为log以2为底n的对数向下取整后加1。
5. 如果对一颗有n个结点的完全二叉树的结点按层序编号，则对任意节点i有：
    1. 如果i=1，则结点i是二叉树的根，无双亲；如果i>1，其双亲PARENT(i)是结点i/2向下取整。
    2. 如果2i>n，则结点i无左孩子；否则其左孩子是结点2i。
    3. 如果2i+i>n，则结点在i无又孩子；否则其右孩子RCHILD(i)是结点2i+1.

### 存储结构

#### 顺序存储结构

```c
// ------ 二叉树的顺序存储结构 -------
#define MAX_TREE_SIZE 100    // 二叉树的最大节点数
typedef TElemType SqBiTree[MAX_TREE_SIZE]; // 0号单元存储根节点
SqBiTree bt;
```

用一组地质连续的存储单元一次自上而下、自左至右存储完全二叉树上的结点元素，即将完全二叉树上编号为i的结点元素存储在如上定义的唯一数组中下标为i-1的分量重。在最坏的情况下，一个深度为k且只有k个结点的单支树却需要长度为2^k-1的一维数组。

#### 链式存储结构

由二叉树的定义得知，二叉树的结点由一个数据元素和分别指向其左、右子树的两个分支构成，则表示二叉树的链表中的结点至少包含三个域：数据域和左、右指针域。有时为了便于找到结点双亲，还可以增加一个指向其双亲结点的指针。这两种二叉树的存储结构分别称为二叉链表和三叉链表。

## 遍历二叉树和线索二叉树

### 遍历二叉树

假如以L、D、R分别表示遍历左子树、访问根节点和遍历右子树，则可有DLR,LDR,LRD,DRL,RDL,RLD六种遍历二叉树的方案。若限定先左后右，则只有前三种情况，分别称之为先序遍历，中序遍历，后序遍历。

先序遍历二叉树的操作定义为:
若二叉树为空，则空操作，否则：

1. 访问根节点
2. 先序遍历左子树
3. 先序遍历右子树

中序遍历二叉树的操作定义为：
若二叉树为空，则空操作，否则：

1. 中序遍历左子树
2. 访问根节点
3. 中序遍历右子树

后序遍历二叉树的操作定义为：
若二叉树为空，则空操作，否则：

1. 后序遍历左子树
2. 后续遍历右子树
3. 访问根节点

先序遍历二叉树递归算法：

```c
Status PrintElement(TElemType e) {
    printf(e);
    return OK;
}

PreOrderTraverse(T, PrintElement) {
    if (T) {
        if (Visit(T->data))
            if (PreOrderTraverse(T->data))
                if (PreOrderTraverse(T->rchild, Visit)) return Ok;
        return ERROR;
    } else return OK;
}

```

三种遍历方法的不同之处仅在于访问根结点和遍历左右子树的先后关系。仿照递归算法执行过程中递归工作栈的状态变化状况可直接写出相应的非递归算法。

```c
Status InOrderTraverse(BiTree T, Status(* Visit)(TElemType e)) {
    // 采用二叉链表存储结构，Visit是对数据元素操作的应用函数
    // 中序遍历二叉树T的非递归算法，对每个数据元素调用函数Visit。
    InitStack(S); Push(S,T);
    while(! StackEmpty(S)) {
        while (GetTop(S, p) && p) Push(S, p->lchild); // 向左走到尽头
        Pop(S, p);  // 空指针退栈
        if (!StatckEmpty(S)) {
            Pop(S,p);
            if(!Visit(p->data)) return ERROR;
            Push(S, p->rchild);
        }
    }
    return OK;
}

Status InOrderTraverse(BiTree T, Status(* Visit)(TElemType e)) {
    InitStack(S); p = T;
    while(p ||!StackEmpty(S)) {
        if (p) {
            Push(S,p);
            p = p->lchild;
        } else {
            Pop(S, p); if(!Visit(p->data))
            return Error;
        }
        p = p->child;
    }
    return OK;
}

```

使用先序遍历方法创建二叉树：

```c
Status CreateBiTree(BiTree &T) {
    scanf(&ch);
    if (ch == '') T = NULL;
    else {
        if (!(T = (BiTNode *)malloc(sizeof(BiTNode)))) exit(OVERFLOW);
        T -> data = ch;
        CreateBiTree(T->lchild);
        CreateBiTree(T->rchild);
    }
    return OK;
}
```

遍历二叉树的时间复杂度为O(n)。

### 线索二叉树

>试做如下规定：若结点有左子树，则其lchild域指示其左孩子，否则令lchild域指示其前驱；若结点有右子树，则其rchild域指示其右孩子，否则令rchild域指示其后继。为了避免混淆，尚需改变结点结构，增加两个标志位。

```c
|--------|--------|------|------|--------|
| lchild |  ltag  | data | rtag | rchild |
|--------|--------|------|------|--------|
```

其中：

```c
ltag = 0 lchild指向左孩子
       1 lchild指向前驱

rtag = 0 rchild指向右孩子
       1 rchild指向后继
```

以这种结点结构构成的二叉链表作为二叉树的存储结构，叫做**线索链表**，其中指向结点前驱和后继的指针，叫做**线索**。加上线索的二叉树称之为**线索二叉树**。对二叉树以某种次序遍历使其变为线索二叉树的过程叫做**线索化**。

在中序线索二叉树上遍历二叉树，虽然时间复杂度也为O(n)，但是常数因子要比上节的算法小，且不需要设栈。因此，若在某程序中所用二叉树需经常遍历或查找结点在便利所得线性序列中的前驱和后继，则应采用线索链表做存储结构。

```c
// ----- 二叉树的二叉线索存储表示 -----
typedef enum {
    Link, Thread
}PointerTag; // Link == 0: 指针，Thread == 1: 线索

typedef struct BiTrNode {
    TElemType      data;
    struct BiThrNode  *lchild, * rchild;  // 左右孩子指针
    PointerTag     Ltag, Rtag;  // 左右标志
}BiThrNode, *BiThrTree;

```

双向线索链表为存储结构时对二叉树进行遍历的算法：

```c
Status InOrderTraverse.Thr(BitThrTree T, Status(* Visit)(TElemType e)) {
    // T指向头结点，头结点的左链lchild指向根节点，可参见线索化算法
    // 中序遍历二叉线索树T的非递归算法，对每个数据元素调用函数Visit。
    p = T->lhild;
    while(p != T) {
        while(p -> Ltag == Link) p = p->lchild;
        if (!Visit(p->data)) return ERROR;
        while(p->RTag == Thread && p->rchild!=T) {
            p = p->rchild; Visit(p->data);
        }
        p = p->rchild;
    }
    return OK;
}
```

二叉树线索化的实质是将二叉链表中的空指针改为指向前驱或后继的线索，而前驱或后继的信息只有在遍历时才能得到，因此线索化的过程即为在遍历的过程中修改空指针的过程。为了几下遍历过程中的访问结点的先后关系，附设一个指针pre始终指向刚刚访问过的结点，若指针p指向当前访问的结点，则pre指向它的前驱。

```c
Status InOrderTreading(BitThrTree & Thrt, BiThrTree T) {
    // 中序遍历二叉树T，并将其中序线索化，Thrt指向头结点。
    if (!(Thrt = (BiThrTree)malloc(sizeof(BiThrNode)))) exit(OVERFLOW);
    Thrt->Ltag = Link; Thrt->RTag = Thread;    // 建头结点
    Thrt->rchild = Thrt;
    if (!T) Thrt->lchild = Thrt;
    else {
        Thrt->lchild = T; pre = Thrt;
        InThreading(T);
        pre->rchild = Thrt; pre->RTag = Thread;
        Thrt->rchild = pre;
    }
    return OK;
}

void InThreading(BiThrTree p) {
    if (p) {
        InThreading(p->lchild); // 左子树线索话
        if (!p->lchild) {p->LTag = Thread; p->lchild = pre;}  // 前驱线索
        if (!p->rchild) {pre->RTag = Thread;pre->rchild = p;} // 后继线索
        pre = p;
        InThreading(p->child) // 右子树线索化
    }
}

```

## 树和森林

### 树的存储结构

一、双亲表示法
假设一组连续空间存储树的结点，同时在每个结点中附设一个指示器指示器指示其双亲结点在链表中的位置，其形式说明如下：

```c

// ----- 树的双亲表存储表示 ------
#define MAX_TREE_SIZE 100
typedef struct PTNode {
    TElemType data;
    int parent;     // 双亲位置域
}PNode;
typedef struct {
    PTNode nodes[MAX_TREE_SIZE];
    int n       // 结点数
}PTree;
```

二、孩子表示法
由于树中每个结点可能有多棵子数，则可用多重链表，即每个结点有多个指针域，其中每个指针向一颗子树的根结点，此时链表中的结点可以有如下两种结点格式：

||||||||
| - | - | - | - | - | - | - |
data|child1|child2|...|childd|
data|degree|child1|child2|...|childd
||||||||

若采用第一种结点格式，则多重链表中的节点是同构的，d为树的度。由于树中很多节点的度小于d，所以链表中有很多空链域，空间较浪费，在一棵有n个结点度为k的树中必有`n(n-1)+1`个空链域。第二种方式，虽然能节约存储空间，但操作不方便。

另一种办法是吧每个结点的孩子结点排列起来，看成是一个线性表，切以单链表做存储结构，则n个结点有n个孩子链表。

```c
// ----- 树的孩子链表存储表示 -----
typedef struct CTNode {      // 孩子结点
    int child;
    struct CTNode *next;
} *ChildPtr;

typedef struct {
    ElemType data;
    ChildPtr firstchild; // 孩子链表头指针
} CTBox;

typedef struct {
    CTBox nodes[MAX, TREE_SIZE];
    int n,r;          // 节点数和根的位置
}CTree;
```

与双亲表示法相反，孩子表示法便于涉及孩子的操作的实现，却不适用于PARENT操作。将两者结合一下。

三、孩子兄弟表示法

又称二叉树表示法，或二叉链表表示法。即二叉链表作数的存储结构。链表中结点的两个链域分别指向该结点的第一个孩子结点和下一个兄弟结点，分别命名为firstchild域和nextsibling域。

```c
// ----- 树的二叉链表存储表示------
typedef struct CSNode {
    ElemType data;
    struct CSNode *firstchild, *nextsibling;
}CSNode, *CSTree;
```

### 森林与二叉树的转换

二叉树和树都可用二叉链表作为存储结构，则以二叉链表作为媒介可导出树与二叉树之间的一个对应关系。也就是说，给定一棵树，可以找到唯一的二叉树与之对应，从物理结构来看，域二叉链表相同，只是解释不同。

![树与二叉树的对应关系](/img/Tree01.jpeg)

一、森林转二叉树

如果F={T1,T2,T3,...,Tm}是森林，则可按如下规则转换成二叉树B={root,LB,RB}。

1. 若F为空，即m=0，则B为空树；
2. 若F非空，即m!=0，则B的根root即为森林中第一棵树的根ROOT(T1);B的左子树LB是从T1中根节点的子树森林F1 = {T11,T12,...,T1m1}转换而成的二叉树；其右子树RB是从森林F‘={T2,T3,...Tm}转换而成的二叉树。

二、二叉树转森林

如果B=(root,LB,RB)是一颗二叉树，则按如下规则转换成森林F={T1,T2,...,Tm};

1. 若B为空，则F为空;
2. 若B非空，F中第一课树T1的根ROOT(T1)即为二叉树B的根root；T1中根结点的子树森林F1是由B的左子树LB转换而成的森林；F中除T1之外其余的树组成的森林F'={T2,T3,...,Tm}是由B的右子树RB转换而成的森林。

### 树和森林的遍历

1. 先序遍历森林
    1. 访问森林中第一棵树的根节点；
    2. 先序遍历第一棵树中根节点的子森林；
    3. 先序遍历除去第一棵树之后剩余的树构成的森林。
2. 中序遍历森林
    1. 中序遍历森林重的第一棵树的根结点的子树森林；
    2. 访问第一棵树的根节点；
    3. 中序遍历除去第一棵树之后剩余的树构成的森林。

由之前森林与二叉树之间转换的规则可知，当森林转换成二叉树时，其第一棵树的子树森林转换成左子树，剩余树的森林转换成右子树，则上述森林的先序和中序遍历即为其对应的二叉树的先序和中序遍历。

因此当以二叉链表座位树的存储结构，树的先根遍历和中根遍历可借用二叉树的先序遍历和中序遍历的算法实现。

## 赫夫曼叔及其应用

**赫夫曼(Huffman)树**，又称最优树，是一类带权路径长度最短的树。

### 最优二叉树

从树中一个结点到另一个结点之间的分支构成这两个结点之间的路径，路径上的分支数目称**路径长度**。路径长度是从树跟到每一节点的路径长度之和。完全二叉树就是这种路径长度最短的二叉树。

结点的带权路径长度为从该结点到树根之间的路径长度与度与结点上权的乘积。树的带权路径长度为树中所有叶子结点的带权路径长度之和，通常记做![path](/img/Huffman01.png)。