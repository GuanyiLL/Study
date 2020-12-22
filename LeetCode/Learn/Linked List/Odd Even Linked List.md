Given a singly linked list, group all odd nodes together followed by the even nodes. Please note here we are talking about the node number and not the value in the nodes.

You should try to do it in place. The program should run in O(1) space complexity and O(nodes) time complexity.

**Example 1:**

```
Input: 1->2->3->4->5->NULL
Output: 1->3->5->2->4->NULL
```

**Example 2:**

```
Input: 2->1->3->5->6->4->7->NULL
Output: 2->3->6->7->1->5->4->NULL
```

 

**Constraints:**

- The relative order inside both the even and odd groups should remain as it was in the input.
- The first node is considered odd, the second node even and so on ...
- The length of the linked list is between `[0, 10^4]`.



**Solution**

```swift
func oddEvenList(_ head: ListNode?) -> ListNode? {
    let node = ListNode(0)
    node.next = head
    
    var pre = node.next
    var cur = node.next
    
    while cur?.next?.next != nil {
        let odd = cur!.next!.next
        let tmp = cur?.next
        let tail = pre?.next

        tmp?.next = odd?.next
        odd?.next = tail
        pre?.next = odd
        
        pre = pre?.next
        cur = tmp
    }
    
    return node.next
}
```

Better Solution:

```swift
func oddEvenList(_ head: ListNode?) -> ListNode? {
            
    let evenStart = head?.next
    var oddEnd = head
    // 1->2->3->4->5->NULL
    
    var p1 = head
    var count = 1
    while p1 != nil {
        if count % 2 != 0 { oddEnd = p1 }
        count += 1

        let temp = p1?.next
        p1?.next = p1?.next?.next
        p1 = temp
    }
    oddEnd?.next = evenStart
    return head
}
```

