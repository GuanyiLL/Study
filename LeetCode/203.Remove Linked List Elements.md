# Remove Linked List Elements

Remove all elements from a linked list of integers that have value ***val\***.

**Example:**

```
Input:  1->2->6->3->4->5->6, val = 6
Output: 1->2->3->4->5
```

**Solution**

```swift
 func removeElements(_ head: ListNode?, _ val: Int) -> ListNode? {
     var tmp=ListNode(-1,head), vHead=tmp
     while let next=tmp.next{
         if next.val==val {tmp.next=next.next}
         else {tmp=next}
     }
     return vHead.next
 }
```

