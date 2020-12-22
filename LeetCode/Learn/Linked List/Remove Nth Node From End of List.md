Given the `head` of a linked list, remove the `nth` node from the end of the list and return its head.

**Follow up:** Could you do this in one pass?

 

**Example 1:**

![img](https://assets.leetcode.com/uploads/2020/10/03/remove_ex1.jpg)

```
Input: head = [1,2,3,4,5], n = 2
Output: [1,2,3,5]
```

**Example 2:**

```
Input: head = [1], n = 1
Output: []
```

**Example 3:**

```
Input: head = [1,2], n = 1
Output: [1]
```

 

**Constraints:**

- The number of nodes in the list is `sz`.
- `1 <= sz <= 30`
- `0 <= Node.val <= 100`
- `1 <= n <= sz`



**Solution**

```swift
func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    let tmp:ListNode? = ListNode(0)
    tmp!.next = head
    var node1 = tmp
    var node2 = tmp
   
    for _ in 0...n {
        node1 = node1?.next
    }
    
    while node1 != nil {
        node1 = node1?.next
        node2 = node2?.next
    }
    
    node2?.next = node2?.next?.next
    return tmp!.next
}
```

