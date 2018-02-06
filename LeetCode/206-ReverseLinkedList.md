# Description

Reverse a singly linked list.

#### Hint:

A linked list can be reversed either iteratively or recursively. Could you implement both?

# Solution

## Approach #1 (Iterative) 迭代法

假设现在有一个链表`1->2->3->Ø`，现在要把它变成`Ø<-1<-2<-3`。当遍历这个链表时，将当前节点的next指针指向当前节点的前一个节点。因为节点没有前节点的引用，所以必须事先将前一个元素存储下来。还需要另外一个指针来存放改变之前的下一个节点。在最后返回最新的头节点即可。

```cpp

ListNode* reverseList(ListNode* head) {
    ListNode *prev = NULL;
    ListNode *curr = head;  // 假设head = [1,2,3,4]
    while (curr != NULL) {
        ListNode *nextTemp = curr->next;    //将 2->3->4 暂存  -->  3->4  --> 4  --> NULL
        curr->next = prev;  // 将curr的next指向前一个暂存的节点 1 -> NULL --> 2->1 --> 3->2->1 -> 4->3->2->1 
        prev = curr;    // 将前一个节点替换为当前节点 prev = 1-> NULL --> prev = 2->1 --> prev = 3->2->1 --> prev = 4->3->2->1
        curr = nextTemp; // 将curr改为 2->3->4 之后循环迭代之前步骤做相同处理 --> curr = 3->4 --> 4 --> NULL
    }
    return prev;
}

```

### 复杂度分析

* 时间复杂度：O(n). n为链表长度，时间复杂度为O(n)
* 空间复杂度：O(1)


## Approach #2 (Recursive) 递归

递归方法则是假设末尾的节点已经是逆序好的。
假设链表`n1 → … → nk-1 → nk → nk+1 → … → nm → Ø`,现在`nk+1`到`nm`为已经逆序，并且现在代码执行到`nk`的位置：
```
n1 → … → nk-1 → nk → nk+1 ← … ← nm
```
现在讲`nk+1`的next指向`nk`。
因此`nk.next.next = nk`
而`n1`的next指针必须指向NULL，否则将形成环。

```cpp
ListNode* reverseList(ListNode* head) {
    if (head == NULL || head->next == NULL) return head;
    ListNode *p = reverseList(head->next);
    head->next->next = head;
    head->next = NULL;
    return p;
}

```

